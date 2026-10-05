#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  visualiser.sh — cava, only when there is music playing
#
#    visualiser.sh toggle | on | off | status
#
#  cava on an iGPU is cheap, but an always-on visualiser with nothing playing is
#  just a flat line burning cycles — so this is opt-in and parks itself in a
#  small floating window in the corner rather than hogging a workspace.
# ═══════════════════════════════════════════════════════════════════════════
set -u

CFG="$HOME/.config/hypr"

running() { pgrep -x cava >/dev/null 2>&1; }

start() {
    running && return 0

    command -v cava >/dev/null 2>&1 || {
        echo "cava is not installed" >&2
        return 1
    }

    cava >/dev/null 2>&1 &
    sleep 1

    if ! running; then
        echo "cava failed to start" >&2
        return 1
    fi

    # Make it small, floating and out of the way. These are the dispatcher
    # names verified against `hyprctl dispatch`, not the Lua API.
    hyprctl dispatch pin active:1  >/dev/null 2>&1 || true
    hyprctl dispatch togglefloating active: >/dev/null 2>&1 || true
    hyprctl dispatch movewindow "90% 90%" "30 30" "relative:" >/dev/null 2>&1 || true

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
