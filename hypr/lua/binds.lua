-- ═══════════════════════════════════════════════════════════════════════════
--  binds.lua
--
--  $mainMod = SUPER (the Meta/Windows key)
--
--  Syntax notes for 0.56 (all verified with `Hyprland --verify-config`):
--    • keystrings join with " + ":  "SUPER + SHIFT + Q"
--    • arg 2 is a dispatcher from hl.dsp.* (or any Lua function)
--    • arg 3 is an optional options table: { locked, repeating, mouse, description }
--    • fullscreen:  hl.dsp.window.fullscreen({ mode = "fullscreen"|"maximized",
--                                             behavior = 0|1 })
--    • hl.dsp.window.set_prop takes { prop = "...", value = "..." } — a STRING
--    • hl.dsp.window.resize takes { x, y, relative = true }
--    • hl.dsp.window.move takes { direction } or { workspace } or { x, y }
--    • there is NO hl.dsp.fullscreen_state, hl.dsp.window.maximize,
--      hl.dsp.window.killwindow, or hl.dsp.window.pin in 0.56
--
--  A few tiling presets go through `hyprctl dispatch` because the word
--  forms ("left half", "top left") are only accepted by the hyprlang
--  dispatcher, not by the Lua binding.
-- ═══════════════════════════════════════════════════════════════════════════

local S     = "SUPER"
local SHIFT = "SHIFT"
local ALT   = "ALT"
local CTRL  = "CTRL"

-- ── App targets (one place to re-point the whole rice) ─────────────────────
local term     = "kitty"
local files    = "nemo"
local editor   = "code"
local launcher = "wofi"
local scripts  = os.getenv("HOME") .. "/.config/hypr/scripts"

-- ═══════════════════════════════════════════════════════════════════════════
--  CRITICAL BINDS
--  Bound first and marked `locked`, so they still work with the lock screen
--  covering the session. If anything ever goes wrong, these are the escape
--  hatches.
-- ═══════════════════════════════════════════════════════════════════════════
hl.bind(S .. " + L", hl.dsp.exec_cmd(scripts .. "/lock.sh"),
        { locked = true, description = "Lock the screen" })

hl.bind(S .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd(scripts .. "/switch-to-plasma.sh"),
        { locked = true, description = "Back to KDE Plasma" })

hl.bind(S .. " + " .. ALT .. " + ESCAPE", hl.dsp.exec_cmd(scripts .. "/switch-to-hyprland.sh"),
        { locked = true, description = "Start Hyprland (from Plasma)" })

hl.bind(S .. " + SHIFT + Q", hl.dsp.exit(),
        { locked = true, description = "Log out of Hyprland" })

-- Reload is bound very early: if you break the config while editing, this
-- plus a login cycle is the fastest recovery.
hl.bind(S .. " + R", hl.dsp.exec_cmd("hyprctl reload"),
        { locked = true, description = "Reload the config" })

-- ═══════════════════════════════════════════════════════════════════════════
--  APPLICATIONS
-- ═══════════════════════════════════════════════════════════════════════════
hl.bind(S .. " + RETURN",      hl.dsp.exec_cmd(term),   { description = "Terminal" })
hl.bind(S .. " + E",           hl.dsp.exec_cmd(files),  { description = "File manager" })
hl.bind(S .. " + T",           hl.dsp.exec_cmd(editor), { description = "Editor" })
hl.bind(S .. " + D",           hl.dsp.exec_cmd(scripts .. "/menu.sh"),
                                { description = "Menu" })
hl.bind(S .. " + V",           hl.dsp.exec_cmd(launcher .. " --show drun --insensitive"),
                                { description = "App grid" })
hl.bind(S .. " + grave",       hl.dsp.exec_cmd(term))
hl.bind(S .. " + apostrophe",  hl.dsp.exec_cmd(launcher .. " --show drun --insensitive"))

hl.bind(S .. " + SPACE", hl.dsp.exec_cmd(scripts .. "/clipboard.sh"),
        { description = "Clipboard history" })
hl.bind(S .. " + N",     hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind(S .. " + P",     hl.dsp.exec_cmd(scripts .. "/powermenu.sh"),
        { description = "Power menu" })
hl.bind(S .. " + X",     hl.dsp.exec_cmd(launcher .. " --overlay calc"))
hl.bind(S .. " + Y",     hl.dsp.exec_cmd("hyprpicker"),
        { description = "Colour picker" })
hl.bind(S .. " + U",     hl.dsp.exec_cmd(scripts .. "/easter-egg.sh"),
        { description = "Keybind cheat sheet" })

-- ═══════════════════════════════════════════════════════════════════════════
--  WINDOW MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════
hl.bind(S .. " + Q", hl.dsp.window.close(),  { description = "Close window" })
-- killwindow has no Lua binding in 0.56, so this goes via hyprctl.
hl.bind(S .. " + " .. SHIFT .. " + C", hl.dsp.exec_cmd("hyprctl dispatch killwindow all:"),
        { description = "Close every window" })

-- Fullscreen / maximise. Note the signature in 0.56 is
--   hl.dsp.window.fullscreen({ mode = "fullscreen" | "maximized", behavior = N })
-- and that there is NO hl.dsp.fullscreen_state / hl.dsp.window.maximize.
hl.bind(S .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", behavior = 0 }),
        { description = "Fullscreen" })
hl.bind(S .. " + " .. SHIFT .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", behavior = 0 }),
        { description = "Maximise" })

hl.bind(S .. " + " .. SHIFT .. " + V", hl.dsp.window.float({ action = "toggle" }),
        { description = "Float / tile" })
hl.bind(S .. " + M", hl.dsp.layout("togglesplit"),
        { description = "dwindle <-> master" })
hl.bind(S .. " + I", hl.dsp.window.set_prop({ prop = "pinned", value = "1" }),
        { description = "Pin on top" })
hl.bind(S .. " + " .. SHIFT .. " + J", hl.dsp.window.pseudo(),
        { description = "Pseudotile" })
hl.bind(S .. " + " .. ALT .. " + M", hl.dsp.exec_cmd("hyprctl keyword animations:enabled toggle"),
        { description = "Toggle animations" })

-- ── Focus ──────────────────────────────────────────────────────────────────
for _, d in ipairs({ { "left", "H" }, { "down", "J" }, { "up", "K" }, { "right", "L" } }) do
    hl.bind(S .. " + " .. d[1], hl.dsp.focus({ direction = d[1] }))
    hl.bind(S .. " + " .. d[2], hl.dsp.focus({ direction = d[1] }))
end

-- ── Move ───────────────────────────────────────────────────────────────────
for _, d in ipairs({ { "left", "H" }, { "down", "J" }, { "up", "K" }, { "right", "L" } }) do
    hl.bind(S .. " + " .. SHIFT .. " + " .. d[1], hl.dsp.window.move({ direction = d[1] }))
    hl.bind(S .. " + " .. SHIFT .. " + " .. d[2], hl.dsp.window.move({ direction = d[1] }))
end

-- ── Resize ─────────────────────────────────────────────────────────────────
local STEP = 40
for _, r in ipairs({
        { "left",  -STEP,  0 }, { "right",  STEP,  0 },
        { "up",       0, -STEP }, { "down",    0,  STEP } }) do
    hl.bind(S .. " + " .. ALT .. " + " .. r[1],
            hl.dsp.window.resize({ x = r[2], y = r[3], relative = true }))
end
hl.bind(S .. " + " .. ALT .. " + H", hl.dsp.window.resize({ x = -STEP, y =  0, relative = true }))
hl.bind(S .. " + " .. ALT .. " + L", hl.dsp.window.resize({ x =  STEP, y =  0, relative = true }))
hl.bind(S .. " + " .. ALT .. " + J", hl.dsp.window.resize({ x =  0, y =  STEP, relative = true }))
hl.bind(S .. " + " .. ALT .. " + K", hl.dsp.window.resize({ x =  0, y = -STEP, relative = true }))

-- ── Halves and quarters ────────────────────────────────────────────────────
-- The word forms ("left half", "top left") are only understood by the
-- hyprlang dispatcher, so these go through hyprctl.
--
-- Two easy mistakes here, both of which I made on the first pass:
--   1. the KEY you bind and the WORD the dispatcher understands are different
--      things. Binding "SUPER + left half" is a parse error, because
--      "left half" is not a keysym — it is only the dispatcher's argument.
--   2. the word must be the last argument of `hyprctl dispatch movewindow`.
--
--      SUPER + SHIFT + comma / period     → left / right half
--      SUPER + SHIFT + semicolon / slash  → top / bottom half
--      SUPER + G / SHIFT + G / SHIFT + A / SHIFT + Z → the four quarters
local function tileWord(key, word, desc)
    hl.bind(S .. " + " .. SHIFT .. " + " .. key,
            hl.dsp.exec_cmd("hyprctl dispatch movewindow " .. word),
            { description = desc })
end
tileWord("comma",    "left half",   "Tile left half")
tileWord("period",   "right half",  "Tile right half")
tileWord("semicolon", "top half",   "Tile top half")
tileWord("slash",    "bottom half", "Tile bottom half")

hl.bind(S .. " + G",          hl.dsp.exec_cmd("hyprctl dispatch movewindow top left"),    { description = "Quarter: top left" })
hl.bind(S .. " + " .. SHIFT .. " + G", hl.dsp.exec_cmd("hyprctl dispatch movewindow top right"),   { description = "Quarter: top right" })
hl.bind(S .. " + " .. SHIFT .. " + A", hl.dsp.exec_cmd("hyprctl dispatch movewindow bottom left"), { description = "Quarter: bottom left" })
hl.bind(S .. " + " .. SHIFT .. " + Z", hl.dsp.exec_cmd("hyprctl dispatch movewindow bottom right"),{ description = "Quarter: bottom right" })

-- ── Swap with neighbour ────────────────────────────────────────────────────
for _, d in ipairs({ { "left", "H" }, { "down", "J" }, { "up", "K" }, { "right", "L" } }) do
    hl.bind(S .. " + " .. SHIFT .. " + " .. d[1], hl.dsp.window.swap({ direction = d[1] }))
end

-- ═══════════════════════════════════════════════════════════════════════════
--  WORKSPACES
-- ═══════════════════════════════════════════════════════════════════════════
-- SUPER + 1..0 jump; +SHIFT sends the window. 10 lives on the 0 key.
for i = 1, 10 do
    local key = i % 10
    hl.bind(S .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(S .. " + " .. SHIFT .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Take the window with you.
hl.bind(S .. " + " .. SHIFT .. " + bracketleft",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(S .. " + " .. SHIFT .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))

-- Scroll / three-finger swipe through workspaces.
hl.bind(S .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { mouse = true })
hl.bind(S .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { mouse = true })

-- ── Scratchpad ─────────────────────────────────────────────────────────────
hl.bind(S .. " + C", hl.dsp.workspace.toggle_special("scratchpad"),
        { description = "Toggle the scratchpad" })
hl.bind(S .. " + " .. ALT .. " + C", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- ── Drag / resize a window with Super + mouse ──────────────────────────────
hl.bind(S .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(S .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ═══════════════════════════════════════════════════════════════════════════
--  SCREENSHOTS
-- ═══════════════════════════════════════════════════════════════════════════
hl.bind(S .. " + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh region"),
        { description = "Screenshot: area" })
hl.bind(S .. " + " .. SHIFT .. " + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh full"),
        { description = "Screenshot: screen" })
hl.bind(S .. " + " .. ALT .. " + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh window"),
        { description = "Screenshot: window" })
hl.bind(S .. " + " .. CTRL .. " + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh region delay 3"))
hl.bind("PRINT",        hl.dsp.exec_cmd(scripts .. "/screenshot.sh full"))
hl.bind(S .. " + PRINT", hl.dsp.exec_cmd(scripts .. "/screenshot.sh region"))

-- ═══════════════════════════════════════════════════════════════════════════
--  AUDIO / BRIGHTNESS / MEDIA
-- ═══════════════════════════════════════════════════════════════════════════
local MEDIA = { locked = true, repeating = true }
local function media(key, cmd, description)
    hl.bind(key, hl.dsp.exec_cmd(cmd),
            { locked = true, repeating = true, description = description })
end

media("XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", "Volume up")
media("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",        "Volume down")
media("XF86AudioMute",        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",      "Mute")
media("XF86AudioMicMute",     "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",    "Mute microphone")
media("XF86AudioNext",        "playerctl next",       "Next track")
media("XF86AudioPause",       "playerctl play-pause", "Play / pause")
media("XF86AudioPlay",        "playerctl play-pause", "Play / pause")
media("XF86AudioPrev",        "playerctl previous",   "Previous track")
media("XF86MonBrightnessUp",   "brightnessctl set 5%+", "Brightness up")
media("XF86MonBrightnessDown", "brightnessctl set 5%-", "Brightness down")

-- The same, behind Super, in case firmware grabs the hardware keys.
media(S .. " + XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")
media(S .. " + XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
media(S .. " + XF86AudioMute",        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")

hl.bind(S .. " + up",   hl.dsp.exec_cmd("brightnessctl set 5%+"))
hl.bind(S .. " + down", hl.dsp.exec_cmd("brightnessctl set 5%-"))

-- ═══════════════════════════════════════════════════════════════════════════
--  RICE CONTROLS
-- ═══════════════════════════════════════════════════════════════════════════
hl.bind(S .. " + B", hl.dsp.exec_cmd(scripts .. "/bar.sh toggle"),
        { description = "Show / hide the bar" })
hl.bind(S .. " + W", hl.dsp.exec_cmd(scripts .. "/wallpaper.sh"),
        { description = "Change the wallpaper" })
hl.bind(S .. " + " .. ALT .. " + A", hl.dsp.exec_cmd(scripts .. "/anime-wallpaper.sh toggle"),
        { description = "Live wallpaper on / off" })
