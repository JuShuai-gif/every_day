#!/usr/bin/env python3
"""Read Linux CPU identity/topology without assuming RK3588 CPU numbering."""

import argparse
import json
import os
from pathlib import Path
import platform
import re
from datetime import datetime, timezone


CORE_PARTS = {(0x41, 0xD05): "Cortex-A55", (0x41, 0xD0B): "Cortex-A76"}


def read_text(path):
    try:
        return Path(path).read_text().strip()
    except (OSError, UnicodeError):
        return None


def cpu_list(text):
    if not text:
        return set()
    result = set()
    for item in text.split(","):
        if not re.fullmatch(r"[0-9]+(?:-[0-9]+)?", item.strip()):
            raise ValueError("invalid CPU list: " + text)
        bounds = [int(value) for value in item.strip().split("-")]
        first, last = bounds[0], bounds[-1]
        if last < first or last > 1048576:
            raise ValueError("invalid CPU range: " + item)
        result.update(range(first, last + 1))
    return result


def number(text):
    try:
        return int(text, 0) if text is not None else None
    except ValueError:
        return None


def midr_identity(value):
    return {"implementer": (value >> 24) & 0xFF, "part": (value >> 4) & 0xFFF,
            "variant": (value >> 20) & 0xF, "revision": value & 0xF}


def proc_identities(proc_root):
    identities = {}
    text = read_text(Path(proc_root) / "cpuinfo") or ""
    for block in re.split(r"\n\s*\n", text):
        fields = {}
        for line in block.splitlines():
            if ":" in line:
                key, value = line.split(":", 1)
                fields[key.strip().lower()] = value.strip()
        processor = number(fields.get("processor"))
        if processor is not None:
            identities[processor] = {
                "implementer": number(fields.get("cpu implementer")),
                "part": number(fields.get("cpu part")),
            }
    return identities


def size_bytes(text):
    match = re.fullmatch(r"([0-9]+)([KMG]?)", (text or "").upper())
    return int(match[1]) * (1024 ** " KMG".index(match[2] or " ")) if match else None


def probe(sys_root="/sys", proc_root="/proc", affinity=None):
    sys_root, proc_root = Path(sys_root), Path(proc_root)
    cpu_root = sys_root / "devices/system/cpu"
    discovered = sorted(int(path.name[3:]) for path in cpu_root.glob("cpu[0-9]*")
                        if re.fullmatch(r"cpu[0-9]+", path.name))
    online_text = read_text(cpu_root / "online")
    if online_text is not None:
        online = cpu_list(online_text)
        online_source = "sysfs_online"
    else:
        online = {cpu for cpu in discovered
                  if read_text(cpu_root / f"cpu{cpu}/online") != "0"}
        online_source = "individual_cpu_online_files"

    if affinity is None:
        affinity = set(os.sched_getaffinity(0)) if hasattr(os, "sched_getaffinity") else set()
        affinity_source = "sched_getaffinity" if hasattr(os, "sched_getaffinity") else "unavailable"
    else:
        affinity = set(affinity)
        affinity_source = "explicit_fixture_or_restricted_affinity"
    eligible = online & affinity
    fallback = proc_identities(proc_root)
    cpus = []
    for cpu in sorted(set(discovered) | online):
        base = cpu_root / f"cpu{cpu}"
        midr_text = read_text(base / "regs/identification/midr_el1")
        midr = number(midr_text)
        identity = midr_identity(midr) if midr is not None else fallback.get(cpu, {})
        implementer, part = identity.get("implementer"), identity.get("part")
        caches = []
        for index in sorted((base / "cache").glob("index*")):
            shared = read_text(index / "shared_cpu_list")
            caches.append({"index": index.name, "level": number(read_text(index / "level")),
                           "type": read_text(index / "type"), "size": read_text(index / "size"),
                           "size_bytes": size_bytes(read_text(index / "size")),
                           "line_bytes": number(read_text(index / "coherency_line_size")),
                           "shared_cpus": sorted(cpu_list(shared)) if shared else []})
        cpus.append({"cpu": cpu, "online": cpu in online, "allowed": cpu in eligible,
                     "midr": midr_text, **identity,
                     "identity_source": "midr_el1" if midr is not None else
                                        "proc_cpuinfo" if cpu in fallback else "unavailable",
                     "core": CORE_PARTS.get((implementer, part), "unknown"),
                     "package_id": number(read_text(base / "topology/physical_package_id")),
                     "cluster_id": number(read_text(base / "topology/cluster_id")),
                     "cluster_cpus": sorted(cpu_list(read_text(base / "topology/cluster_cpus_list"))),
                     "caches": caches,
                     "cpufreq": {key: read_text(base / "cpufreq" / key) for key in
                                 ("scaling_driver", "scaling_governor", "scaling_cur_freq",
                                  "cpuinfo_cur_freq", "scaling_min_freq", "scaling_max_freq")}})

    profiles, unavailable, evidence = {}, {}, {}
    for suffix, core in (("a55", "Cortex-A55"), ("a76", "Cortex-A76")):
        members = [cpu for cpu in cpus if cpu["allowed"] and cpu["core"] == core]
        if not members:
            unavailable["single_" + suffix] = "no online, affinity-allowed core with verified identity"
            unavailable["cluster_" + suffix] = "no online, affinity-allowed core with verified identity"
            continue
        profiles["single_" + suffix] = [members[0]["cpu"]]
        evidence["single_" + suffix] = members[0]["identity_source"]
        allowed_type = {cpu["cpu"] for cpu in members}
        groups = []
        for cpu in members:
            if cpu["cluster_cpus"]:
                group = set(cpu["cluster_cpus"]) & allowed_type
                groups.append((group, "topology/cluster_cpus_list"))
            elif (cpu["cluster_id"] is not None and cpu["cluster_id"] >= 0 and
                  cpu["package_id"] is not None and cpu["package_id"] >= 0):
                group = {other["cpu"] for other in members
                         if (other["package_id"], other["cluster_id"]) ==
                            (cpu["package_id"], cpu["cluster_id"])}
                groups.append((group, "topology/package_id+cluster_id"))
            else:
                # Shared caches are reported as cache groups, never invented physical clusters.
                for cache in cpu["caches"]:
                    sharing = set(cache["shared_cpus"])
                    if cache["type"] in ("Unified", "Data") and len(sharing) > 1:
                        group = sharing & allowed_type
                        if len(group) > 1 and sharing <= {c["cpu"] for c in cpus if c["core"] == core}:
                            groups.append((group, f"same_type_shared_L{cache['level']}_cache"))
        groups = [(group, source) for group, source in groups if len(group) >= 2]
        if groups:
            group, source = sorted(groups, key=lambda item: (-len(item[0]), sorted(item[0])))[0]
            profiles["cluster_" + suffix] = sorted(group)
            evidence["cluster_" + suffix] = source
        else:
            unavailable["cluster_" + suffix] = "no verified multi-core topology/cache group within affinity"

    compatible = (read_text(sys_root / "firmware/devicetree/base/compatible") or
                  read_text(proc_root / "device-tree/compatible") or "").split("\0")
    compatible = [value for value in compatible if value]
    thermal = [{"zone": zone.name, "type": read_text(zone / "type"),
                "temperature_millicelsius": number(read_text(zone / "temp"))}
               for zone in sorted((sys_root / "class/thermal").glob("thermal_zone*"))]
    return {"schema_version": 1, "recorded_utc": datetime.now(timezone.utc).isoformat(),
            "runtime": {"system": platform.system(), "machine": platform.machine()},
            "identity": {"compatible": compatible,
                         "is_rk3588": any(value in ("rockchip,rk3588", "rockchip,rk3588s")
                                           for value in compatible),
                         "model": read_text(sys_root / "firmware/devicetree/base/model") or
                                  read_text(proc_root / "device-tree/model")},
            "online_cpus": sorted(online), "online_source": online_source,
            "affinity_cpus": sorted(affinity), "affinity_source": affinity_source,
            "eligible_cpus": sorted(eligible), "cpus": cpus, "thermal": thermal,
            "profiles": profiles, "profile_evidence": evidence, "unavailable_profiles": unavailable,
            "notes": ["CPU part identity does not prove SoC identity",
                      "cache-derived cluster profile denotes a shared-cache group",
                      "frequency/temperature are snapshots, not power or energy measurements"]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sys-root", default="/sys")
    parser.add_argument("--proc-root", default="/proc")
    parser.add_argument("--affinity", help="restrict allowed CPUs; with custom roots, supply fixture affinity")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    affinity = None
    if args.affinity is not None:
        current = set(os.sched_getaffinity(0)) if hasattr(os, "sched_getaffinity") else set()
        requested = cpu_list(args.affinity)
        custom_roots = Path(args.sys_root) != Path("/sys") or Path(args.proc_root) != Path("/proc")
        affinity = requested if custom_roots else current & requested
    result = probe(args.sys_root, args.proc_root, affinity)
    encoded = json.dumps(result, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        args.output.write_text(encoded)
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
