#!/usr/bin/env bash
set -euo pipefail
for arg in "$@"; do
  case "$arg" in
    --csv|--test|--profile|--help)
      echo "run-mac.sh reserves test/CSV handling; use build/native/motor_command $arg directly" >&2
      exit 2 ;;
  esac
done
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
build="$root/build/native$suffix"
sanitize_build="$root/build/sanitize$suffix"
cmake_options=(-DEDGE_CPU_TUNE=generic "-DEDGE_ENABLE_NEON=$neon" "-DEDGE_AUTO_VECTORIZE=$auto_vectorize")
mkdir -p "$root/records"
record=$(mktemp -d "$root/records/mac-$(date +%Y%m%d-%H%M%S)-XXXXXX")
run() {
  printf 'explicit_neon=%s auto_vectorize=%s tune=generic\n' "$neon" "$auto_vectorize"
  printf 'record=%s\nbenchmark_args=' "$record"
  printf '%q ' "$@"
  printf '\n'
  bash "$root/scripts/manifest.sh" > "$record/environment.txt"
  cmake -S "$root" -B "$build" -DCMAKE_BUILD_TYPE=Release -DEDGE_SANITIZE=OFF -DEDGE_TSAN=OFF "${cmake_options[@]}"
  cmake --build "$build" --parallel 2
  compiler=$(sed -n 's/^CMAKE_CXX_COMPILER:[^=]*=//p' "$build/CMakeCache.txt")
  "$compiler" --version >> "$record/environment.txt"
  shasum -a 256 "$build/motor_command" > "$record/binary-sha256.txt"
  cp "$build/compile_commands.json" "$record/compile_commands.json"
  ctest --test-dir "$build" --output-on-failure
  python3 -B -m unittest discover -s "$root/tests" -p 'test_*.py'
  "$build/motor_command" --mode all --samples 30 --csv "$record/samples.csv" "$@"
  if [[ "${SANITIZE:-1}" == 1 ]]; then
    cmake -S "$root" -B "$sanitize_build" -DCMAKE_BUILD_TYPE=Debug -DEDGE_SANITIZE=ON -DEDGE_TSAN=OFF "${cmake_options[@]}"
    cmake --build "$sanitize_build" --parallel 2
    ASAN_OPTIONS=detect_leaks=0 "$sanitize_build/motor_command" --test
    printf 'asan_ubsan=PASS leak_detection=DISABLED\n'
  else
    printf 'asan_ubsan=SKIPPED\n'
  fi
  python3 "$root/scripts/summarize.py" "$record/samples.csv" --output "$record/summary.json"
  printf 'status=PASS record=%s\n' "$record"
}

run "$@" 2>&1 | tee "$record/session.log"
