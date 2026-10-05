#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  install.sh — put this dotfiles repo onto a machine
#
#      ./install.sh            # copy everything into ~/.config
#      ./install.sh --link     # symlink instead of copy (live editing)
#      ./install.sh --dry-run  # show what would happen, change nothing
# ═══════════════════════════════════════════════════════════════════════════
set -eu

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="copy"
DRY=0

for arg in "$@"; do
    case "$arg" in
        --link)    MODE="link" ;;
        --dry-run) DRY=1 ;;
        -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
        *) echo "unknown option: $arg" >&2; exit 1 ;;
    esac
done

put() {
    # put <src> <dest>
    local src="$1" dest="$2"
    [ -e "$src" ] || return 0

    if [ "$DRY" -eq 1 ]; then
        echo "  would install  $src -> $dest"
        return 0
    fi

    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"

    if [ "$MODE" = "link" ]; then
        ln -s "$src" "$dest"
        echo "  linked  $dest"
    else
        cp -r "$src" "$dest"
        # preserve the executable bit on scripts
        case "$src" in *.sh) chmod +x "$dest" ;; esac
        echo "  copied  $dest"
    fi
}

echo "Installing $(basename "$REPO")  (mode: $MODE)"

# ── Hyprland ───────────────────────────────────────────────────────────────
put "$REPO/hypr/hyprland.lua"  "$HOME/.config/hypr/hyprland.lua"
put "$REPO/hypr/lua"           "$HOME/.config/hypr/lua"
put "$REPO/hypr/scripts"       "$HOME/.config/hypr/scripts"
put "$REPO/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
put "$REPO/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"

# ── Bar / launcher / notifications / terminal ──────────────────────────────
put "$REPO/waybar" "$HOME/.config/waybar"
put "$REPO/wofi"   "$HOME/.config/wofi"
put "$REPO/mako"   "$HOME/.config/mako"
put "$REPO/kitty"  "$HOME/.config/kitty"

# ── Assets the config expects ──────────────────────────────────────────────
# The rice references ~/.local/share/hypr-rice/ for the wallpaper, the live
# wallpaper clip and the lock-screen avatar. It is NOT in this repo because
# the video is 34 MB. Populate it with:
#
#     cp ~/Pictures/Wallpapers/suzumi-4k.jpg ~/.local/share/hypr-rice/
#     cp ~/Videos/*.mp4                      ~/.local/share/hypr-rice/suzumi-live.mp4
#
# and generate the avatar with:
#
#     magick WALLPAPER -crop 700x700+1270+280 +repage -resize 400x400 /tmp/a.png
#     magick /tmp/a.png \
#       \( -size 400x400 xc:none -fill white -draw "circle 200,200 200,3" \) \
#       -alpha set -compose DstIn -composite PNG32:$HOME/.local/share/hypr-rice/avatar.png
#
# Everything else works without it; only the lock screen and the live
# wallpaper toggle need the avatar and the clip.

mkdir -p "$HOME/.local/share/hypr-rice"

# ── Summary ────────────────────────────────────────────────────────────────
cat <<'EOF'

Done. Useful next steps:

  1. Pick Hyprland at the login screen (it now lists both Plasma and Hyprland).
  2. Check the config parses:      Hyprland --verify-config
  3. Inside Hyprland, reload with: SUPER + R
  4. Full keybind reference:       SUPER + U
  5. Change the palette:           edit hypr/lua/theme.lua, then SUPER + R

Packages this rice needs:
  hyprland hypridle hyprlock waybar wofi mako kitty grim slurp swappy
  wl-clipboard cliphist awww mpvpaper brightnessctl playerctl wpctl-pulse
  pavucontrol cava matugen polkit-gnome hyprpolkitagent
  (plus fonts: JetBrainsMono Nerd Font, Material Symbols)
EOF
