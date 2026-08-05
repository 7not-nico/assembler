-- r0_romsfun.lua — pure core: domain helpers
-- purity: pure
-- ring: 0 (PURE)
-- Typed-functional style: pure functions, immutable tables. Constants come
-- from schema.lua (the seed.sql citation) — none defined here. O(1)
-- membership via table lookup — validate_console is hot (every browse).
local schema = require("schema")

local M = {}

-- constants (from the schema, at the top)
M.VALID_CONSOLES = schema.VALID_CONSOLES
M.IMAGE_EXTS = schema.IMAGE_EXTS
M.TIMEOUT_BROWSE = schema.TIMEOUT_BROWSE
M.TIMEOUT_FETCH = schema.TIMEOUT_FETCH
M.TRACE_HEAD = schema.TRACE_HEAD
M.LAUNCH_LOG = schema.LAUNCH_LOG
M.FETCH_SELECTOR = schema.FETCH_SELECTOR

local SLUG_RE = "[^a-z0-9]+"

-- pure helpers

function M.validate_console(console)
  if console == "" then
    error("console required: one of " .. M.list_consoles(), 2)
  end
  if not M.VALID_CONSOLES[console] then
    error("invalid console '" .. console .. "' — valid: " .. M.list_consoles(), 2)
  end
  return console
end

function M.list_consoles()
  local keys = {}
  for k in pairs(M.VALID_CONSOLES) do keys[#keys + 1] = k end
  table.sort(keys)
  return table.concat(keys, ", ")
end

function M.slugify(name)
  local base, dot, ext = name:match("^(.*)%.([^.]+)$")
  if not dot then base, ext = name, "" end
  local slug = base:lower():gsub(SLUG_RE, "-"):gsub("^%-+", ""):gsub("%-+$", "")
  if dot then return slug .. "." .. ext end
  return slug
end

function M.is_image(name)
  local ext = name:match("%.([^.]+)$")
  return ext ~= nil and M.IMAGE_EXTS[ext:lower()] ~= nil
end

return M
