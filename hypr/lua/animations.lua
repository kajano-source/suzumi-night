-- ═══════════════════════════════════════════════════════════════════════════
--  animations.lua
--
--  Hyprland 0.55+ replaced the old "named style" animations
--  (animation = slide, 1, 4, 1, 1) with per-"leaf" animation definitions
--  plus named curves and springs:
--
--      hl.curve("name", { type = "bezier", points = { {x, y}, {x, y} } })
--      hl.curve("name", { type = "spring", mass=, stiffness=, damping= })
--      hl.animation({ leaf = "...", enabled = true, speed = N, bezier = "..." })
--
--  The tuning goal: quick and "settled", never bouncy. Springs on window
--  open/close give the whole desktop a slight physicality, which suits the
--  soft neon look.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Curves ─────────────────────────────────────────────────────────────────
hl.curve("linear",       { type = "bezier", points = { {0, 0},     {1, 1}     } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1}  } })
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1},  {0.32, 1}  } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0},  {0.1, 1}   } })

-- ── Springs ────────────────────────────────────────────────────────────────
-- One gentle spring for window open/close. Damping is high enough that it
-- settles in roughly one overshoot rather than wobbling.
hl.curve("softPop",  { type = "spring", mass = 1, stiffness = 260, dampening = 28 })
hl.curve("smoothOut", { type = "spring", mass = 1, stiffness = 210, dampening = 26 })

-- ── Master ─────────────────────────────────────────────────────────────────
hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "default" })

-- ── Windows ────────────────────────────────────────────────────────────────
hl.animation({ leaf = "windows",    enabled = true, speed = 5,    spring = "smoothOut" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4,    spring = "softPop", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2,    bezier = "easeInOutCubic", style = "popin 92%" })
hl.animation({ leaf = "border",     enabled = true, speed = 5,    bezier = "easeOutQuint" })

-- ── Fades (fullscreen, damage, dim) ────────────────────────────────────────
hl.animation({ leaf = "fade",    enabled = true, speed = 4, bezier = "quick" })
hl.animation({ leaf = "fadeIn",  enabled = true, speed = 3, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "almostLinear" })

-- ── Layers: wofi launcher, mako notifications, waybar ──────────────────────
hl.animation({ leaf = "layers",        enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 5, bezier = "easeOutQuint", style = "popin 96%" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 2, bezier = "easeInOutCubic", style = "popin 96%" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 4, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3, bezier = "almostLinear" })

-- ── Workspaces ─────────────────────────────────────────────────────────────
hl.animation({ leaf = "workspaces",    enabled = true, speed = 3, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 3, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7, bezier = "quick" })
