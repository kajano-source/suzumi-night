-- ═══════════════════════════════════════════════════════════════════════════
--  rules.lua · layer rules + window rules + smart gaps
--
--  In 0.56 these are Lua-only: the legacy `windowrulev2` / `layerrulev2`
--  keywords were deleted outright. This file is therefore the only place
--  where per-app behaviour lives.
--
--  Verified field sets for Hyprland 0.56.2:
--    layer_rule effects : blur, no_anim, animation
--    window_rule effects: float, pin, no_blur, center, fullscreen, maximize,
--                         rounding, border_size, border_color, opacity,
--                         suppress_event, no_focus, move, workspace, monitor,
--                         min_size, max_size, no_anim, nearest_neighbor,
--                         focus_on_activate, xray
--    match props        : class, title, xwayland, float, fullscreen,
--                         workspace, tag, group
--
--  ⚠ Because 0.56's layer rules no longer expose anchor / margin /
--    border_size / round_corners, the launcher's shape comes from the app
--    itself: ~/.config/wofi/style.css and ~/.config/mako/style.css.
--    The layer rules here only add blur and animation.
-- ═══════════════════════════════════════════════════════════════════════════

local t = require("lua.theme")

-- ═══════════════════════════════════════════════════════════════════════════
--  LAYER RULES
-- ═══════════════════════════════════════════════════════════════════════════

hl.layer_rule({
    name  = "launcher-blur",
    match = { namespace = "^wofi" },
    blur  = true,
})

hl.layer_rule({
    name   = "launcher-anim",
    match  = { namespace = "^wofi" },
    -- Animate the launcher surface; `slide` works well with a centre anchor.
    animation = "slide",
})

hl.layer_rule({
    name  = "notifications-blur",
    match = { namespace = "^mako" },
    blur  = true,
})

hl.layer_rule({
    name  = "bar-no-anim",
    match = { namespace = "^waybar$" },
    -- The bar should not fade in on every workspace switch.
    no_anim = true,
})

hl.layer_rule({
    name  = "lock-no-anim",
    match = { namespace = "^hyprlock" },
    no_anim = true,
})

-- ═══════════════════════════════════════════════════════════════════════════
--  WINDOW RULES
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Terminals: no blur, so glyphs stay perfectly crisp ─────────────────────
hl.window_rule({
    name  = "terminals",
    match = { class = "^(kitty|foot|alacritty|konsole|ghostty)$" },
    no_blur    = true,
    rounding   = 14,
    border_size = 2,
    border_color = t.border_gradient,
})

-- ── Editors: no blur; syntax highlighting wants a clean backdrop ───────────
hl.window_rule({
    name  = "editors",
    match = { class = "^(code|codium|kate|geany|emacs|nvim)$" },
    no_blur = true,
})

-- ── Media players: always floating and centred ─────────────────────────────
hl.window_rule({
    name  = "media-player",
    match = { class = "^(mpv|io.github.celluloid_player.Celluloid)$" },
    float        = true,
    center       = true,
    max_size     = "1280 760",
    border_size  = 2,
    border_color = t.c(t.violet),
})

-- ── Things that must never be tiled ───────────────────────────────────────
local NEVER_TILE =
    "^(pavucontrol|nm-connection-editor|nm-applet|blueman-manager|" ..
    "blueman-applet|org.remmina.remmina|xdg-desktop-portal-gtk|" ..
    "wofi|cliphist|hyprpicker|qalculate!|galculator)$"

hl.window_rule({ name = "never-tile", match = { class = NEVER_TILE }, float = true })

hl.window_rule({
    name  = "kde-dialogs",
    match = { class = "^(org.kde.kwin|plasmashell|systemsettings|org.kde.plasma.*)$" },
    float = true,
})

hl.window_rule({
    name  = "popup-classes",
    match = { class = "^(floating|popup|menu|tooltip)$" },
    float = true,
    no_focus = true,
})

-- ── Capture / streaming tools ──────────────────────────────────────────────
hl.window_rule({
    name  = "capture",
    match = { class = "^(obs|spectacle|kamoshi|wl-screenrec|kooha|GreenRecordingIndicator)$" },
    float = true,
})

-- ── Games own their fullscreen ─────────────────────────────────────────────
hl.window_rule({
    name  = "games",
    match = { class = "^(steam_appid|Steam)$" },
    float = true,
})

-- ── Browser politeness ─────────────────────────────────────────────────────
-- Firefox asking to go fullscreen while a page loads makes the layout jump
-- around; letting it do so on purpose is what the keybind is for.
hl.window_rule({
    name  = "browsers-no-maximize",
    match = { class = "^(firefox|org.mozilla.firefox|brave|chromium|chrome|google-chrome-stable|vivaldi)$" },
    suppress_event = "maximize",
})

-- A rule handle you can switch off at runtime:
--   hl.dsp.exec_cmd("...")  ->  or  rule:set_enabled(false)
local suppressMaximize = hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- ── Picture-in-picture: never tiled, never fullscreen ──────────────────────
hl.window_rule({
    name  = "picture-in-picture",
    match = { title = "^(Picture-in-Picture|Notification)" },
    float      = true,
    fullscreen = false,
    maximize   = false,
    pin        = true,
    no_anim    = true,
})

-- ── Overlay helpers always on top ──────────────────────────────────────────
hl.window_rule({
    name  = "clipboard-overlay",
    match = { class = "^(wl-clipboard-manager|cliphist|hyprpicker)$" },
    float        = true,
    pin          = true,
    no_anim      = true,
    border_size  = 2,
    border_color = t.c(t.magenta),
})

-- ── XWayland: fix drag with no real title/class ────────────────────────────
hl.window_rule({
    name  = "xwayland-drag",
    match = { class = "^$", title = "^$", xwayland = true, float = true,
              fullscreen = false, pin = false },
    no_focus = true,
})

-- ═══════════════════════════════════════════════════════════════════════════
--  SMART GAPS  —  a workspace holding exactly one window goes borderless
-- ═══════════════════════════════════════════════════════════════════════════
for _, w in ipairs({ "w[tv1]", "f[1]" }) do
    hl.workspace_rule({ workspace = w, gaps_out = 0, gaps_in = 0 })
    hl.window_rule({
        name  = "no-gaps-" .. w,
        match = { float = false, workspace = w },
        border_size = 0,
        rounding    = 0,
    })
end
