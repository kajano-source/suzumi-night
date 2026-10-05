# Suzumi Night — a Hyprland rice for Garuda Linux

A purple/neon desktop built around one anime-girl wallpaper, with KDE Plasma
kept alongside it so you can switch between the two at the login screen.

```
Garuda Linux (rolling) · Hyprland 0.56.2 · KDE Plasma 6.7.5
i5-1235U · Intel Iris Xe · eDP-1 1920x1080@60
```

---

## What you get

**Two desktops, one login screen.** Plasma is still installed and untouched.
The login screen now lists `Plasma (Wayland)` and `Hyprland`, and you pick.

**A theme taken from the wallpaper.** Every colour in this rice was sampled
out of `suzumi-4k.jpg` — deep violet surfaces, a magenta→violet→indigo
gradient border, neon-pink highlights. It is defined in one file
([`hypr/lua/theme.lua`](hypr/lua/theme.lua)).

**Hyprland's animation system, properly used.** 0.55+ replaced the old
`slide`/`popin` animation names with per-"leaf" definitions plus named
curves and springs. This config defines its own bezier curves and two gentle
springs, then tunes all 16 animation leaves.

---

## Logging in

| Screen | What you get |
|---|---|
| `Plasma (Wayland)` | Your original Garuda Mokka desktop, exactly as before |
| `Hyprland` | This rice |

To go from Hyprland to Plasma without rebooting: **`SUPER` + `SHIFT` + `ESC`**.
That binds to a script that hands the seat back to `plasmalogin`, so you land
on the login screen and choose Plasma.

> **Autologin was turned off** in `/etc/plasmalogin.conf` — with it on you
> were dropped straight into Plasma and the chooser never appeared. To put it
> back, uncomment the `[Autologin]` block in that file (the original is kept
> at `/etc/plasmalogin.conf.orig`).

---

## Keybinds

Press **`SUPER` + `U`** inside Hyprland for this list in a searchable window.

### Launch

| Key | Action |
|---|---|
| `SUPER` `Return` | terminal (kitty) |
| `SUPER` `D` | menu — apps **and** rice actions in one list |
| `SUPER` `E` | file manager (nemo) |
| `SUPER` `T` | editor (VS Code) |
| `SUPER` `V` | app grid |
| `SUPER` `SPACE` | clipboard history |
| `SUPER` `X` | calculator |
| `SUPER` `Y` | colour picker |

### Windows

| Key | Action |
|---|---|
| `SUPER` `Q` | close window |
| `SUPER` `SHIFT` `C` | close every window |
| `SUPER` `F` / `SHIFT+F` | fullscreen / maximise |
| `SUPER` `SHIFT` `V` | float / tile |
| `SUPER` `M` | dwindle ↔ master layout |
| `SUPER` `I` | pin on top |
| `SUPER` `H J K L` | focus ← ↓ ↑ → |
| `SUPER` `SHIFT` + `H J K L` | move window |
| `SUPER` `ALT` + `H J K L` | resize window |
| `SUPER` `SHIFT` `,` / `.` | tile left / right half |
| `SUPER` `SHIFT` `;` / `/` | tile top / bottom half |
| `SUPER` `G` / `SHIFT+G` / `SHIFT+A` / `SHIFT+Z` | the four quarters |
| `SUPER` `C` | scratchpad |

### Workspaces

`SUPER` `1`–`0` to jump, `SHIFT` to send the window with you. Three-finger
horizontal swipe on the touchpad, or `SUPER` + scroll.

### System

| Key | Action |
|---|---|
| `SUPER` `S` / `SHIFT+S` / `ALT+S` | screenshot: area / screen / window |
| `SUPER` `W` | wallpaper picker (thumbnail gallery) |
| `SUPER` `ALT+A` | live wallpaper on/off |
| `SUPER` `B` | show/hide the bar |
| `SUPER` `L` | lock screen |
| `SUPER` `P` | power menu |
| `SUPER` `R` | reload the config |
| `SUPER` `SHIFT+ESC` | → KDE Plasma |
| `SUPER` `ALT+ESC` | → Hyprland (from Plasma) |

---

## Layout

```
hypr/
  hyprland.lua        entry point — requires the modules below, in order
  lua/
    theme.lua         THE PALETTE. Change this one file to retheme everything.
    env.lua           GTK/Qt/Java/SDL env vars
    monitor.lua       outputs + scale
    input.lua         keyboard, touchpad, gestures, cursor
    look.lua          general + decoration (corners, borders, blur, glow)
    animations.lua    curves, springs, and the 16 animation leaves
    workspaces.lua    named + special workspaces
    rules.lua         window rules + layer rules
    binds.lua         keybinds
    autostart.lua     daemon startup
  scripts/            everything invoked by a keybind
  hypridle.conf       dim → lock → suspend
  hyprlock.conf       the lock screen
waybar/               bar config + stylesheet
wofi/                 launcher theme (GTK4)
mako/                 notification daemon
kitty/                terminal config + colour scheme
install.sh            deploy this repo to ~/.config
```

`theme.lua` is the single source of truth for colour. The waybar stylesheet
mirrors it by hand — if you change the palette, update
`waybar/style.css` and `kitty/themes/suzumi.conf` too.

---

## Editing it

```bash
# validate without starting a session — prints every problem it finds
Hyprland --verify-config

# apply changes to the running session
SUPER + R          # or: hyprctl reload

# restart one daemon
~/.config/hypr/scripts/bar.sh restart
~/.config/hypr/scripts/autostart.sh      # idempotent, safe to re-run
```

Autostart writes to `/tmp/hypr-autostart.log` and says `FAIL` for anything
that did not come up, which is usually where to look when something looks
half-alive.

---

## Notes on this machine

**`awww`, not `swww`.** Garuda ships swww as `awww` (the package `Provides:
swww`, but the binaries are `/usr/bin/awww` and `/usr/bin/awww-daemon`, and
its `--resize` takes `crop` rather than `cover`). The scripts use `awww`.

**The live wallpaper is opt-in.** `SUPER`+`ALT`+`A` plays
`~/.local/share/hypr-rice/suzumi-live.mp4` through mpvpaper. It is a 4K clip
and this is an Iris Xe with shared memory — it will spin the fan. The static
image is the default for that reason.

**Nested Hyprland has two limitations.** Starting Hyprland *inside* Plasma
shares your D-Bus session, so Plasma keeps the `org.freedesktop.Notifications`
name and mako cannot acquire it. Everything else works. When you pick
Hyprland at the login screen instead, Plasma is not running and this does not
apply.

**Nesting was used to test this.** The config was validated by running
Hyprland nested inside the live Plasma session — screenshots taken, window
decorations and the launcher and the lock screen all confirmed working, and
several real bugs were caught that `--verify-config` alone does not see.

---

## Packages required

```
hyprland  hypridle  hyprlock  waybar  wofi  mako  kitty
grim  slurp  swappy  wl-clipboard  cliphist  awww  mpvpaper
brightnessctl  playerctl  pavucontrol  cava  matugen
hyprpolkitagent  xdg-desktop-portal-hyprland
nemo  code
ttf-jetbrains-mono-nerd  ttf-material-symbols-variable-git
```

Arch equivalents: `wpctl-pulse` provides `wpctl`; the `awww` package
provides `swww` as a virtual dependency.
