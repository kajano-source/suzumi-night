#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  bar.sh — show / hide / restart waybar
#
#    bar.sh toggle | on | off | restart | css | status
# ═══════════════════════════════════════════════════════════════════════════
set -u

CFG="$HOME/.config/hypr"
BAR="$HOME/.config/waybar"
CSS="$BAR/style.css"

running() { pgrep -x waybar >/dev/null 2>&1; }

# waybar picks up style.css on its own; this only matters if the file is being
# edited and you want the change live.
reload_css() {
    [ -f "$CSS" ] || return 0
    command -v waybar >/dev/null 2>&1 || return 0
    # waybar has no hot-reload for CSS, so restart if we are running.
    if running; then
        pkill -x waybar; sleep 0.3; waybar >/dev/null 2>&1 &
    fi
}

case "${1:-toggle}" in
    on)
        running || { waybar >/dev/null 2>&1 & echo "bar: on"; }
        ;;
    off)
        if running; then pkill -x waybar; echo "bar: off"; fi
        ;;
    toggle)
        if running; then pkill -x waybar; echo "bar: off"
        else waybar >/dev/null 2>&1 & echo "bar: on"; fi
        ;;
    restart)
        pkill -x waybar 2>/dev/null
        sleep 0.3
        waybar >/dev/null 2>&1 &
        echo "bar: restarted"
        ;;
    css)
        reload_css
        echo "bar: css reloaded"
        ;;
    status)
        running && echo "bar: on" || echo "bar: off"
        ;;
    *)
        echo "usage: $0 {on|off|toggle|restart|css|status}" >&2
        exit 1
        ;;
esac
