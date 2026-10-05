-- ═══════════════════════════════════════════════════════════════════════════
--  theme.lua · "Suzumi Night"
--
--  A colour scheme sampled directly from the anime-girl wallpaper this setup
--  uses:  ~/.local/share/hypr-rice/suzumi-4k.jpg
--
--  The image is a purple/magenta neon city at night. Base tones were pulled
--  from the image with a quantiser and then re-balanced for UI legibility;
--  the accents are the neon highlights.
--
--  Every other module requires this one, so this file is the single place to
--  change the look of the whole desktop.
-- ═══════════════════════════════════════════════════════════════════════════

local T = {}

-- ── Base / surfaces ────────────────────────────────────────────────────────
T.base     = "14102a"   -- desktop void
T.mantle   = "191331"   -- bars, panels
T.crust    = "0e0b1e"   -- deepest: menus, launchers
T.surface  = "221a44"   -- generic surface
T.overlay  = "362a6b"   -- hover state
T.border   = "4a3a86"   -- hairlines & dividers

-- ── Text ───────────────────────────────────────────────────────────────────
T.text     = "ece3fb"   -- primary
T.subtext  = "b3a3d6"   -- secondary
T.dim      = "8878b3"   -- tertiary / disabled

-- ── Accents (the neon from the scene) ──────────────────────────────────────
T.violet   = "8b5cf6"   -- primary accent
T.purple   = "a962ea"   -- secondary accent
T.magenta  = "f472d0"   -- neon pink: the skyline highlight
T.pink     = "fc8ffc"   -- brightest neon, used very sparingly
T.blue     = "6d61f2"   -- the deep indigo of the windows
T.lilac    = "c9a7f5"   -- soft accent
T.cyan     = "7ad7f5"   -- cold highlight
T.green    = "a6e3a1"   -- success / volume
T.yellow   = "f9e2af"   -- warning / cpu
T.red      = "f38ba8"   -- error / danger / power

-- ── Helper: rgba() from a 6-digit hex + alpha ──────────────────────────────
--   c("f472d0", 0.5)  ->  "rgba(f472d080)"
function T.c(hex, alpha)
    if alpha == nil then
        return "rgba(" .. hex .. "ff)"
    end
    local a = math.floor(alpha * 255)
    return string.format("rgba(%s%02x)", hex, a)
end

-- ── Border gradient: the signature look of this rice ───────────────────────
T.border_gradient = {
    colors = { "rgba(" .. T.magenta .. "ff)", "rgba(" .. T.violet .. "ff)",
               "rgba(" .. T.blue .. "ff)" },
    angle  = 45,
}

T.border_inactive = "rgba(" .. T.border .. "80)"

return T
