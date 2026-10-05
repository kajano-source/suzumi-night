#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  screenshot.sh — grim + slurp, themed, saved and copied to the clipboard
#
#    screenshot.sh region           → interactive area select
#    screenshot.sh region delay 3   → 3s countdown first
#    screenshot.sh window           → focused window, auto-cropped
#    screenshot.sh full             → whole output
#    screenshot.sh region clip      → area, no file written
#
#  ⚠ Garuda ships swww as `awww`, which has no `msg` subcommand, so there is
#    no "flash" transition. The capture goes to the clipboard, a
#    notification, and a file.
# ═══════════════════════════════════════════════════════════════════════════
set -u

MODE="${1:-region}"
DELAY=0
CLIP_ONLY=0

# Loose flags after the mode: "region delay 3 clip"
for ((i=1; i<=$#; i++)); do
    case "${!i}" in
        delay)  j=$((i+1)); DELAY="${!j}" ;;
        clip)   CLIP_ONLY=1 ;;
    esac
done

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

command -v grim >/dev/null 2>&1 || { echo "grim not installed" >&2; exit 1; }
command -v slurp >/dev/null 2>&1 || { echo "slurp not installed" >&2; exit 1; }

STAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUT="$DIR/Screenshot_${STAMP}.png"
TMP="$(mktemp -t shot-XXXXXX).png"
trap 'rm -f "$TMP"' EXIT

grab() {
    case "$MODE" in
        region)
            [ "$DELAY" -gt 0 ] && sleep "$DELAY"
            grim -g "$(slurp)" "$TMP"
            ;;
        window)
            # hyprctl reports the focused window geometry as at[] / size[].
            local geom
            geom=$(hyprctl activewindow -j 2>/dev/null | jq -r \
                '"\(.at[0].x),\(.at[0].y) \(.size[0])x\(.size[1])"')
            [ -n "$geom" ] && [ "$geom" != "null" ] || return 1
            grim -g "$geom" "$TMP"
            ;;
        full|output)
            grim -o "$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id')" \
                "$TMP" 2>/dev/null || grim "$TMP"
            ;;
        *)
            echo "unknown mode: $MODE" >&2
            return 1
            ;;
    esac
}

if ! grab; then
    echo "screenshot cancelled or failed" >&2
    exit 1
fi

[ -s "$TMP" ] || { echo "empty capture" >&2; exit 1; }

# ── Clipboard ──────────────────────────────────────────────────────────────
if command -v wl-copy >/dev/null 2>&1; then
    wl-copy -t image/png < "$TMP"
fi

# ── Save + announce ────────────────────────────────────────────────────────
if [ "$CLIP_ONLY" -eq 0 ]; then
    mv "$TMP" "$OUT" 2>/dev/null || cp "$TMP" "$OUT"
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -a "Screenshot" "Suzumi Night" "Saved · $(basename "$OUT")" 2>/dev/null
    echo "$OUT"
else
    echo "copied to clipboard"
fi
