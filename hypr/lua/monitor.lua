-- ═══════════════════════════════════════════════════════════════════════════
--  monitor.lua
--
--  Laptop panel: eDP-1, 1920x1080 @ 60.05Hz, 15.6", 309x174mm.
--
--  SCALE — 1.25 gives a 1536x864 logical workspace, which is the sweet spot
--  on a 1080p panel: text is comfortable without everything feeling huge.
--    • too small / want max crispness for screenshots -> 2 (960x540, small)
--    • want everything smaller                              -> 1.0
--
--  To add an external monitor, append another hl.monitor() call with the
--  output name from `hyprctl monitors`.
-- ═══════════════════════════════════════════════════════════════════════════

local t = require("lua.theme")

-- ── Catch-all, matched first (lowest priority in Hyprland) ─────────────────
-- An empty output name matches every monitor. Having this as a base means the
-- scale and mode still apply if the output is ever renamed (e.g. eDP-1 ->
-- eDP-2 after a firmware update, or a different panel on a repair).
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1.25,
})

-- ── Laptop panel ───────────────────────────────────────────────────────────
-- Rules are matched most-specific-first, so this overrides the catch-all above.
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.25,
})

-- ── External example ───────────────────────────────────────────────────────
-- hl.monitor({ output = "DP-1", mode = "2560x1440@165", position = "0x0", scale = 1 })
--
-- ── Disable the built-in mascot wallpaper ──────────────────────────────────
-- Hyprland 0.56 ships a random anime-girl splash background. We are driving
-- our own wallpaper (swww / mpvpaper), so turn it off.
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
    },
})

-- Keep the theme colours in the environment so child processes and scripts
-- can read them without re-parsing this config.
hl.env("HYPR_THEME_BG",     t.base)
hl.env("HYPR_THEME_MANTLE", t.mantle)
hl.env("HYPR_THEME_TEXT",   t.text)
hl.env("HYPR_THEME_VIOLET", t.violet)
hl.env("HYPR_THEME_MAGENTA", t.magenta)
hl.env("HYPR_THEME_DIM",    t.dim)
hl.env("HYPR_THEME_SUBTEXT", t.subtext)
hl.env("HYPR_THEME_SURFACE", t.surface)
hl.env("HYPR_THEME_BORDER", t.border)
