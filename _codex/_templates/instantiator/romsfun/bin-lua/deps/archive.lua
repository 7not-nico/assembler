-- deps/archive.lua — shared archive dependency: probe + listing
-- purity: io
-- ring: 4 (LOCAL-WRITE)
-- Mirrors deps/archive.sh + the Python/TS ports: file-type detection and
-- archive listing for verify/acquire. Pure transforms compose the io
-- probes (io.popen).
local r0 = require("r0_core")

local M = {}

-- _popen {cmd} — run a command, return stdout. io. The one popen helper.
local function _popen(cmd)
	local p = io.popen(cmd .. " 2>/dev/null")
	local out = p:read("*a")
	p:close()
	return out
end

function M.file_type(file)
	return _popen('file -b "' .. file .. '"')
end

function M.unzip_listing(archive)
	local lines = {}
	for line in _popen('unzip -Z1 "' .. archive .. '"'):gmatch("[^\n]+") do
		if line ~= "" then
			lines[#lines + 1] = line
		end
	end
	return lines
end

function M.unzip_sizes(archive)
	return _popen('unzip -l "' .. archive .. '"')
end

function M.first_image(listing, exts)
	for _, line in ipairs(listing) do
		local lower = line:lower()
		if exts then
			for e in pairs(exts) do
				if lower:sub(-#e) == e then
					return line
				end
			end
		elseif r0.is_image(line) then
			return line
		end
	end
	return nil
end

function M.parse_size(unzip_out, image)
	-- Lua $ is not multiline — match per line. Anchor size at line start,
	-- then date (12-24-1996) + time (23:32) + image.
	local esc = image:gsub("([%.%+%-%*%?%[%]%(%)%^%$])", "%%%1")
	for line in unzip_out:gmatch("[^\n]+") do
		local size = line:match("^%s*(%d+)%s+%d%d?%-%d%d?%-%d%d%d%d%s+%d%d?:%d%d%s+" .. esc .. "%s*$")
		if size then
			return size
		end
	end
	return ""
end

function M.file_size(file)
	return tonumber(_popen('stat -c%s "' .. file .. '"')) or 0
end

return M
