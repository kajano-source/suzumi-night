#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  menu.sh — SUPER+D launcher
#
#  A single wofi list containing both real applications (read straight out of
#  the .desktop files) and a handful of one-shot rice actions. That way one
#  keypress gets you everything, and there is no dependence on wofi's own
#  drun sorting/filtering behaving in a particular way.
# ═══════════════════════════════════════════════════════════════════════════
set -u

CFG="$HOME/.config/hypr"

# ── Custom actions ─────────────────────────────────────────────────────────
# Format: "  label|payload"
ACTIONS=(
    "󰈙  Desktop Entries|desktop-files"
    "󰒁  Change Wallpaper|wallpaper"
    "󰓩  Toggle Live Wallpaper|anime"
    "󰔡  Toggle Music Visualiser|visualiser"
    "󰇳  Toggle Bar|bar"
    "󰩈  Bluetooth|bluetooth"
    "󰖯  Audio Mixer|mixer"
    "󰇮  Display Settings|displays"
    "󰐥  Power Menu|power"
    "󰈙  Switch to KDE Plasma|plasma"
    "󰨝  Switch to Hyprland|hyprland"
)

# ── Applications, harvested from .desktop files ────────────────────────────
# Keep label -> desktop-id pairs in two parallel arrays.
LABELS=()
PAYLOADS=()

for a in "${ACTIONS[@]}"; do
    LABELS+=("${a%%|*}")
    PAYLOADS+=("action:${a##*|}")
done

scan_desktop_dirs() {
    local dir file name
    for dir in /usr/share/applications \
               /usr/local/share/applications \
               "$HOME/.local/share/applications" \
               "$HOME/Desktop"; do
        [ -d "$dir" ] || continue
        # shellcheck disable=SC2012
        for file in "$dir"/*.desktop "$dir"/*.desktop.desktop; do
            [ -f "$file" ] || continue
            # Skip entries that are not actually launchable by a user.
            grep -qE '^NoDisplay=true|^Hidden=true|^Type=(Linker|Directory)' "$file" && continue
            name=$(grep -m1 '^Name=' "$file" | cut -d= -f2-)
            [ -n "$name" ] || continue
            LABELS+=("$name")
            PAYLOADS+=("desktop:$(basename "$file" .desktop.desktop)")
        done
    done
}
scan_desktop_dirs

if [ "${#LABELS[@]}" -eq 0 ]; then
    echo "no launchers found" >&2
    exit 1
fi

# ── Pick ───────────────────────────────────────────────────────────────────
CHOICE=$(printf '%s\n' "${LABELS[@]}" | wofi \
    --dmenu \
    --insensitive \
    --prompt "Launch ▸ " \
    -h scrollbar:yes \
    -h wrap=no \
    -h row_padding=6)

[ -z "${CHOICE:-}" ] && exit 0

# ── Resolve the chosen row back to its payload ─────────────────────────────
PAYLOAD=""
for ((i=0; i<${#LABELS[@]}; i++)); do
    if [ "${LABELS[$i]}" = "$CHOICE" ]; then
        PAYLOAD="${PAYLOADS[$i]}"
        break
    fi
done

[ -n "$PAYLOAD" ] || exit 0

case "$PAYLOAD" in
    action:desktop-files) exec nemo "$HOME/Desktop" ;;
    action:wallpaper)     exec "$CFG/scripts/wallpaper.sh" ;;
    action:anime)         exec "$CFG/scripts/anime-wallpaper.sh" toggle ;;
    action:visualiser)    exec "$CFG/scripts/visualiser.sh" toggle ;;
    action:bar)           exec "$CFG/scripts/bar.sh" toggle ;;
    action:bluetooth)     exec blueman-manager ;;
    action:mixer)         exec pavucontrol ;;
    action:displays)      exec systemsettings kcm_kscreen ;;
    action:power)         exec "$CFG/scripts/powermenu.sh" ;;
    action:plasma)        exec "$CFG/scripts/switch-to-plasma.sh" ;;
    action:hyprland)      exec "$CFG/scripts/switch-to-hyprland.sh" ;;
    desktop:*)            exec gtk-launch "${PAYLOAD#desktop:}" ;;
    *)                    echo "unhandled payload: $PAYLOAD" >&2; exit 1 ;;
esac
