#!/bin/sh
set -eu

# 一键归档：默认只提交每日练习和仓库维护配置，避免误提交其他本地文件。
usage() {
  echo "用法: $0 [--all] [提交信息]" >&2
  echo "  --all  暂存整个仓库（默认仅 systems_practice、格式和 scripts）" >&2
}

stage_all=false
if [ "${1:-}" = "--all" ]; then
  stage_all=true
  shift
fi
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi
if [ "$#" -gt 1 ]; then
  usage
  exit 64
fi

# 定位仓库根目录，允许从任意子目录执行该脚本。
root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "错误：当前目录不在 Git 仓库中。" >&2
  exit 2
}
cd "$root"

# 格式化失败立即停止，避免提交半格式化的 C/C++/CUDA 代码。
if [ -x scripts/format-cpp.sh ]; then
  scripts/format-cpp.sh
fi
git diff --check

if [ "$stage_all" = true ]; then
  git add -A
else
  # 这些目录/文件覆盖每日练习及其维护规则，不会默认纳入用户的其他本地工作。
  git add -- systems_practice scripts .clang-format .gitignore
fi

if git diff --cached --quiet; then
  echo "没有可提交的变更。"
  exit 0
fi

message=${1:-"chore: archive practice update"}
git commit -m "$message"
git push origin HEAD
echo "已提交并推送：$(git rev-parse --short HEAD)"
