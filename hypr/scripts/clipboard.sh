#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  clipboard.sh — cliphist-backed clipboard manager (SUPER+Space)
#  Enter pastes into the previously focused window, Ctrl+V deletes, Ctrl+U
#  clears the whole history.
# ═══════════════════════════════════════════════════════════════════════════
set -u

command -v cliphist >/dev/null 2>&1 || { echo "cliphist not installed" >&2; exit 1; }

# wofi needs to stay open while the key is held so we can read the binding.
RESULT=$(cliphist list | wofi \
    --dmenu \
    --prompt "Clipboard ▸ " \
    --keep-input \
    --passthrough \
    --hide-input \
    -i \
    -h scrollbar:yes)

[ -z "${RESULT:-}" ] && exit 0

# The entry we actually want is the selection line, not the keystrokes.
LINE=$(printf '%s\n' "$RESULT" | tail -n1)
ID=$(printf '%s' "$LINE" | cut -d' ' -f1)

case "$RESULT" in
    $'\x0b'*)  # Ctrl+V — wipe just this entry
        [ -n "${ID:-}" ] && cliphist delete "$ID" && echo "deleted entry $ID"
        ;;
    $'\x15'*)  # Ctrl+U — wipe everything
        cliphist clear
        notify-send -a "Clipboard" "Suzumi Night" "History cleared" 2>/dev/null
        echo "history cleared"
        ;;
    *)
        [ -n "${ID:-}" ] || exit 0
        cliphist decode "$ID" | wl-copy
        # paste into the window we came from
        wtype -M ctrl -k v -m ctrl 2>/dev/null || xdotool key --clearmodifiers ctrl+v 2>/dev/null
        echo "pasted entry $ID"
        ;;
esac
