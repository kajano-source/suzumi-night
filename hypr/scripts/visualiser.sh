#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  visualiser.sh — cava, only when there is music playing
#
#    visualiser.sh toggle | on | off
#
#  cava on an iGPU is cheap, but an always-on visualiser with no music playing
#  is just a flat line burning cycles — so this waits for playerctl to report
#  something playing, and hides itself again when playback stops.
# ═══════════════════════════════════════════════════════════════════════════
set -u

CFG="$HOME/.config/hypr"
STATE="$HOME/.cache/cava-state"

running() { pgrep -x cava >/dev/null 2>&1; }

start() {
    running && return 0
    cava >/dev/null 2>&1 &
    # Park it in a 1x1 window in the corner so it doesn't cover the desktop.
    hyprctl dispatch movetoworkspace special:97,activewindow:1 >/dev/null 2>&1
    hyprctl dispatch togglespecialworkspace 97 >/dev/null 2>&1
    sleep 0.2
    hyprctl dispatch workspace 1 >/dev/null 2>&1
    echo "visualiser: on"
}

stop() {
    running && pkill -x cava
    echo "visualiser: off"
}

case "${1:-toggle}" in
    on)     start ;;
    off)    stop ;;
    toggle) running && stop || start ;;
    status) running && echo "visualiser: on" || echo "visualiser: off" ;;
    *)      echo "usage: $0 {on|off|toggle|status}" >&2; exit 1 ;;
esac
