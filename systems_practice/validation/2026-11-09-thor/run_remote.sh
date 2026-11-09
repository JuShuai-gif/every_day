#!/bin/sh
set -u
mkdir -p evidence
sha256sum -c SHA256SUMS > evidence/hash-before.txt || exit 90
run() {
 label=$1;shift
 printf '%s\n' "$*" > "evidence/$label.command.txt"
 "$@" > "evidence/$label.txt" 2>&1
 rc=$?
 printf '%s %s\n' "$label" "$rc" >> evidence/exits.txt
}
for col in daily arm os cpp17; do
 for mode in release sanitize; do
 run "$col-$mode" timeout 90 sh "systems_practice/$col/2026-11-09/run.sh" "$mode"
 done
done
run arm-assembly g++ -std=c++17 -O2 -S systems_practice/arm/2026-11-09/src/main.cpp -o evidence/arm.s
for col in quant-videogen vlash; do
 run "paper-$col" sh "systems_practice/paper/2026-11-09/$col/run.sh"
done
run smoothquant docker run --rm --pull=never --network=none --runtime=nvidia -v "$PWD:/work:ro" -e QUANT_OUTPUT=/tmp/quant -w /work/systems_practice/quantization/2026-11-09/smoothquant --entrypoint sh ghr-flashrt-thor-backup:latest run.sh
run backlog-autoround docker run --rm --pull=never --network=none --entrypoint python ghr-flashrt-thor-backup:latest -c 'import auto_round; print(auto_round.__version__)'
sha256sum -c SHA256SUMS > evidence/hash-after.txt || exit 91
cat evidence/exits.txt
