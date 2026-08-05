-- deps/trace.lua — shared trace dependency: evidence mining
-- purity: io
-- ring: 4 (LOCAL-WRITE)
-- Mirrors trace-evidence.sh: regex-pattern evidence extraction from a log.
-- Patterns come from the schema (single home). Pure transform over the
-- file read.
local schema = require("schema")

local M = {}

function M.trace(trace_file, head)
	local f = io.open(trace_file, "r")
	if not f then
		error("no such trace: " .. trace_file, 2)
	end
	local content = f:read("*a")
	f:close()
	local h = head or schema.TRACE_HEAD
	local matched = {}
	for line in content:gmatch("[^\n]+") do
		for _, pat in ipairs(schema.TRACE_PATTERNS) do
			if line:find(pat) then
				matched[#matched + 1] = line
				break
			end
		end
	end
	local out = {}
	for i = 1, math.min(h, #matched) do
		out[#out + 1] = matched[i]
	end
	return { lines = #matched, evidence = out }
end

return M
