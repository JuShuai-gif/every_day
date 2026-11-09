#!/bin/sh
set -eu
# 只读采样；IRQ号由实际板端/proc/interrupts确认，不默认使用博客31。
case "${1:-}" in ''|*[!0-9]*) echo 'usage: sh collect.sh IRQ' >&2;exit 2;; esac
[ "$(uname -s)" = Linux ] || { echo 'Linux /proc required' >&2;exit 2; }
irq=$1
uname -a
for i in 1 2; do
 date -u '+%Y-%m-%dT%H:%M:%SZ'
 cat /proc/uptime
 cat /sys/devices/system/cpu/online
 cat /proc/interrupts
 cat /proc/softirqs
 for name in smp_affinity_list effective_affinity_list; do
   printf '%s: ' "$name"
   if [ -r "/proc/irq/$irq/$name" ]; then cat "/proc/irq/$irq/$name"; else echo unavailable; fi
 done
 if [ "$i" = 1 ]; then sleep 1; fi
 done
