#!/usr/bin/env bash
# waybar custom module: CPU temperature in °C, with a "N/A" fallback.
# Tries coretemp/k10temp/zenpower, then falls back to the hwmon label that
# matches "cpu" / "coretemp" / "package".
set -u

# 1) Preferred: the coretemp / k10temp kernel modules.
for hw in /sys/class/hwmon/hwmon*/; do
    name=$(cat "${hw}name" 2>/dev/null || true)
    case "${name,,}" in
        coretemp|k10temp|zenpower|cpu_thermal)
            if [ -r "${hw}temp1_input" ]; then
                raw=$(cat "${hw}temp1_input" 2>/dev/null || echo 0)
                printf '%d\n' "$(( raw / 1000 ))"
                exit 0
            fi
            ;;
    esac
done

# 2) Fallback: any hwmon whose name mentions cpu/package.
for hw in /sys/class/hwmon/hwmon*/; do
    name=$(cat "${hw}name" 2>/dev/null || true)
    case "${name,,}" in
        *cpu*|*package*|*soc*)
            for t in "$hw"temp*_input; do
                [ -r "$t" ] || continue
                raw=$(cat "$t" 2>/dev/null || echo 0)
                # Skip the "max"/"crit" pseudo-sensors (usually 100000+).
                [ "$raw" -gt 0 ] && [ "$raw" -lt 200000 ] || continue
                printf '%d\n' "$(( raw / 1000 ))"
                exit 0
            done
            ;;
    esac
done

echo "—"
