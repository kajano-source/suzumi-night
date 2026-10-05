#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  wallpaper.sh — pick and set a wallpaper with a smooth awww crossfade
#
#    wallpaper.sh                 → interactive wofi image gallery
#    wallpaper.sh <path|dir|URL>  → set directly, no prompt
#
#  ⚠ Garuda ships swww as `awww`. Note `--resize crop` here, not "cover":
#    that is awww's name for "fill the screen, crop the overflow".
#
#  awww is the only thing that ever draws the root window, so there is never
#  a fight with hyprpaper/mpvpaper for the screen.
# ═══════════════════════════════════════════════════════════════════════════
set -u

GALLERY_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
RICE="$HOME/.local/share/hypr-rice"
CURRENT_FILE="$HOME/.cache/hypr-wallpaper-current"

command -v awww >/dev/null 2>&1 || {
    notify-send "Wallpaper" "awww is not installed" 2>/dev/null
    echo "awww not installed" >&2
    exit 1
}

set_wallpaper() {
    local img="$1"

    if [ ! -e "$img" ]; then
        notify-send "Wallpaper" "not found: $img" 2>/dev/null
        echo "not found: $img" >&2
        return 1
    fi

    # mpvpaper owns the screen when the live wallpaper is on — stop it
    # first, otherwise this change is invisible.
    if pgrep -x mpvpaper >/dev/null 2>&1; then
        pkill -x mpvpaper 2>/dev/null
        sleep 0.3
    fi

    awww img "$img" \
        --resize crop \
        --transition-type any \
        --transition-fps 60 \
        --transition-duration 1.2 >/dev/null 2>&1

    mkdir -p "$HOME/.cache"
    printf '%s\n' "$img" > "$CURRENT_FILE"

    # Re-derive the accent colours from the new image so anything sampling
    # from it follows along.
    if command -v matugen >/dev/null 2>&1; then
        matugen image "$img" --mode dark >/dev/null 2>&1 || true
    fi

    notify-send -a "Wallpaper" "Suzumi Night" "Set ✨  $(basename "$img")" 2>/dev/null
    echo "Wallpaper set: $img"
}

# ── Direct argument ────────────────────────────────────────────────────────
if [ "$#" -gt 0 ]; then
    set_wallpaper "$1"
    exit $?
fi

# ── Interactive gallery ────────────────────────────────────────────────────
mkdir -p "$GALLERY_DIR"

mapfile -t IMAGES < <(
    {
        find "$GALLERY_DIR" -maxdepth 1 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
               -o -iname '*.webp' -o -iname '*.jxl' \) 2>/dev/null
        [ -f "$RICE/suzumi-4k.jpg" ] && printf '%s\n' "$RICE/suzumi-4k.jpg"
    } | awk 'NF' | sort -u
)

if [ "${#IMAGES[@]}" -eq 0 ]; then
    notify-send "Wallpaper" "No images found in $GALLERY_DIR" 2>/dev/null
    exit 1
fi

# wofi renders a real thumbnail grid for entries that are image paths.
CHOICE=$(printf '%s\n' "${IMAGES[@]}" | wofi \
    --dmenu \
    --insensitive \
    --prompt "Wallpaper  ▸ " \
    --preview-images true \
    --preview-image-size 380x220 \
    -i \
    -h scrollbar:yes \
    -h wrap=no)

[ -z "${CHOICE:-}" ] && exit 0

set_wallpaper "$CHOICE"
