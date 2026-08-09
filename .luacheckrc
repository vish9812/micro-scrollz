-- micro embeds GopherLua, which implements Lua 5.1.
std = "lua51"

-- micro injects `import` into every plugin's environment.
read_globals = { "import" }

-- A micro plugin's entry points and action callbacks (`init`, `open`, `close`,
-- `preRune`, `onSetActive`, …) have to be globals: micro looks them up by name.
-- Top-level definitions are therefore intentional, not accidental globals.
allow_defined_top = true

-- Callbacks must match micro's signatures, so an unused parameter is a
-- requirement rather than a mistake.
unused_args = false

-- 131 = "unused global variable". Nothing in the plugin calls its own
-- callbacks — micro does, from Go — so "defined but never read" is the expected
-- shape for every entry point.
ignore = { "131" }
