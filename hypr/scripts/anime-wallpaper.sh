#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  anime-wallpaper.sh — play the Suzumi live wallpaper as the desktop
#
#    anime-wallpaper.sh toggle   → on if off, off if on   (SUPER+ALT+A)
#    anime-wallpaper.sh on | off | status
#
#  mpvpaper renders the video into the root window. awww is cleared first so
#  there is exactly one owner of the wallpaper.
#
#  ⚠ PERFORMANCE: this is a 4K clip on an Intel Iris Xe (shared memory).
#  It will spin the fan. That is why it is opt-in and not the default — the
#  static image gives the same picture for a fraction of the power.
# ═══════════════════════════════════════════════════════════════════════════
set -u

RICE="$HOME/.local/share/hypr-rice"
VIDEO="$RICE/suzumi-live.mp4"
FALLBACK="$RICE/suzumi-4k.jpg"
LOG="$HOME/.cache/anime-wallpaper.log"
mkdir -p "$HOME/.cache"

have_mpvpaper() { command -v mpvpaper >/dev/null 2>&1; }

clear_static() {
    awww clear >/dev/null 2>&1 || true
}

start_animated() {
    have_mpvpaper || { echo "mpvpaper not installed" >&2; return 1; }
    [ -f "$VIDEO" ] || { echo "missing $VIDEO" >&2; return 1; }

    clear_static

    # Loop forever, no audio, no subtitle/OSC, slightly under real time so a
    # slow laptop stays responsive.
    mpvpaper "$VIDEO" \
        --loop-file \
        --no-audio \
        --no-input-terminal \
        --no-osc \
        --no-subtitles \
        --no-cache \
        --hwdec=no \
        --scale=bilinear \
        --fps=30 \
        --mute=yes \
        >"$LOG" 2>&1 &

    sleep 1
    if pgrep -x mpvpaper >/dev/null 2>&1; then
        notify-send -a "Wallpaper" "Suzumi Night" "Live wallpaper playing 🎞️" 2>/dev/null
        echo "animated wallpaper: ON"
        return 0
    fi
    echo "mpvpaper failed to start; see $LOG" >&2
    tail -3 "$LOG" >&2 2>/dev/null
    return 1
}

stop_animated() {
    pkill -x mpvpaper 2>/dev/null
    sleep 0.4
    # Put the static image back so the desktop isn't black.
    if [ -f "$FALLBACK" ]; then
        awww img "$FALLBACK" --resize crop --transition-type any \
            --transition-fps 60 --transition-duration 1.0 >/dev/null 2>&1
        printf '%s\n' "$FALLBACK" > "$HOME/.cache/hypr-wallpaper-current"
    fi
    notify-send -a "Wallpaper" "Suzumi Night" "Back to the static image" 2>/dev/null
    echo "animated wallpaper: OFF"
}

status() {
    if pgrep -x mpvpaper >/dev/null 2>&1; then
        echo "animated wallpaper: ON"
    else
        echo "animated wallpaper: OFF"
    fi
}

case "${1:-toggle}" in
    on|start)   start_animated ;;
    off|stop)   stop_animated ;;
    toggle)     pgrep -x mpvpaper >/dev/null 2>&1 && stop_animated || start_animated ;;
    status)     status ;;
    *)          echo "usage: $0 {on|off|toggle|status}" >&2; exit 1 ;;
esac
