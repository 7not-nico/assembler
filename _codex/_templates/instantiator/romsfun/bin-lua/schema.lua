-- schema.lua — constants citation for the romsfun Lua project
-- purity: pure
-- ring: 0 (PURE)
-- Cites instantiator/romsfun/schema/seed.sql (the SQL-seed constants home,
-- 02-events.sql pattern) and exports the domain constants. r0_romsfun
-- imports these — no constant is hardcoded elsewhere in the project.
local M = {}

-- resolve the schema relative to the project dir: the entry script runs
-- from bin-lua/ and the seed lives at bin-lua/schema/seed.sql (this dir).
-- arg[0] is the script path (reliable; debug.source of a required module is
-- cwd-relative and unusable).
local script_dir = (arg and arg[0]):match("^(.*)/[^/]*$") or "."
local schema_file = script_dir .. "/schema/seed.sql"

-- templates root: bin-lua → romsfun → instantiator → _templates
M.templates_root = script_dir .. "/.."

local seed = {}

-- Lua patterns are not PCRE: match key + value up to the closing quote
for line in io.lines(schema_file) do
	local key, value = line:match("^%s*%('([A-Z0-9_]+)', '([^']*)',")
	if key then
		seed[key] = value
	end
end

function M.value(key)
	local v = seed[key]
	if v == nil then
		error("schema miss: " .. key .. " not in " .. schema_file, 2)
	end
	return v
end

-- typed domain constants
M.VALID_CONSOLES = {}
for c in M.value("CONSOLE_VALID"):gmatch("%S+") do
	M.VALID_CONSOLES[c] = true
end
M.IMAGE_EXTS = {}
for e in M.value("IMAGE_EXTS"):gmatch("%S+") do
	M.IMAGE_EXTS[e] = true
end
M.TIMEOUT_BROWSE = tonumber(M.value("TIMEOUT_BROWSE"))
M.TIMEOUT_FETCH = tonumber(M.value("TIMEOUT_FETCH"))
M.TRACE_HEAD = tonumber(M.value("TRACE_HEAD"))
M.LAUNCH_LOG = M.value("LAUNCH_LOG")
M.FETCH_SELECTOR = M.value("FETCH_SELECTOR")
M.TRACE_PATTERNS = {}
for p in M.value("TRACE_PATTERNS"):gmatch("[^|]+") do
	M.TRACE_PATTERNS[#M.TRACE_PATTERNS + 1] = p
end

return M
