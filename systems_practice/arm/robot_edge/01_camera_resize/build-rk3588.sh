#!/usr/bin/env bash
set -euo pipefail
: "${CROSS_CXX:?set absolute path to a Mac-runnable AArch64 Linux C++ compiler}"
: "${SYSROOT:?set matching RK3588 Linux sysroot}"
[[ "$CROSS_CXX" = /* && -x "$CROSS_CXX" && "$SYSROOT" = /* && -d "$SYSROOT" ]] ||
  { echo "CROSS_CXX/SYSROOT must be valid absolute paths" >&2; exit 2; }
triple=$("$CROSS_CXX" -dumpmachine)
[[ "$triple" == aarch64*linux* ]] ||
  { echo "compiler does not target aarch64 Linux: $triple" >&2; exit 2; }
root=$(cd -- "$(dirname -- "$0")" && pwd)
neon=${EDGE_ENABLE_NEON:-ON}
auto_vectorize=${EDGE_AUTO_VECTORIZE:-ON}
case "$neon/$auto_vectorize" in
  ON/ON|ON/OFF|OFF/ON|OFF/OFF) ;;
  *) echo "EDGE_ENABLE_NEON and EDGE_AUTO_VECTORIZE must be ON or OFF" >&2; exit 2 ;;
esac
suffix=""
if [[ "$neon/$auto_vectorize" != ON/ON ]]; then
  suffix="-neon-$neon-auto-$auto_vectorize"
fi
tune=${RK_TUNE:-generic}
case "$tune" in
  generic|cortex-a55|cortex-a76) ;;
  *) echo "RK_TUNE must be generic, cortex-a55 or cortex-a76" >&2; exit 2 ;;
esac
build="$root/build/rk3588-$tune$suffix"
mkdir -p "$root/records"
record=$(mktemp -d "$root/records/cross-$(date +%Y%m%d-%H%M%S)-XXXXXX")
run() {
  bash "$root/scripts/manifest.sh" > "$record/environment.txt"
  printf 'cpu_tune=%s explicit_neon=%s auto_vectorize=%s\n' "$tune" "$neon" "$auto_vectorize" >> "$record/environment.txt"
  "$CROSS_CXX" --version >> "$record/environment.txt"
  printf 'target=%s\nsysroot=%s\n' "$triple" "$SYSROOT" >> "$record/environment.txt"
  cmake -S "$root" -B "$build" -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_TOOLCHAIN_FILE="$root/cmake/rk3588.cmake" -DBUILD_TESTING=OFF \
    "-DEDGE_CPU_TUNE=$tune" "-DEDGE_ENABLE_NEON=$neon" "-DEDGE_AUTO_VECTORIZE=$auto_vectorize"
  cmake --build "$build" --parallel 2
  cp "$build/compile_commands.json" "$record/compile_commands.json"
  file "$build/camera_resize" | tee "$record/binary-format.txt"
  file "$build/camera_resize" | grep -Eq 'ELF 64-bit.*(ARM aarch64|aarch64)' ||
    { echo "expected Linux AArch64 ELF" >&2; exit 2; }
  shasum -a 256 "$build/camera_resize" > "$record/binary-sha256.txt"
  cp "$record/environment.txt" "$build/build-environment.txt"
  printf 'status=BUILT_NOT_BOARD_VERIFIED binary=%s\n' "$build/camera_resize"
}

run "$@" 2>&1 | tee "$record/session.log"
