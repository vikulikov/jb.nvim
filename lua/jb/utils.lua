local M = {}

---@alias profile "light" | "dark"

-- Function to read the JSON palette
---@return table
function M.read_palette()
    local plugin_dir = vim.fn.expand("<sfile>:p:h:h")
    local palette_path = plugin_dir .. "/lua/jb/palette.json"
    local file = io.open(palette_path, "r")
    if not file then
        error("Could not open palette.json at " .. palette_path)
    end
    local content = file:read("*a")
    file:close()
    local ok, palette = pcall(vim.fn.json_decode, content)
    if not ok then
        error("Failed to parse palette.json: " .. palette)
    end
    return palette
end

--- Function to resolve a path in the palette
--- @param colors table
--- @param path string
--- @param profile profile
--- @param inherit_level ?number
--- @return vim.api.keyset.highlight
function M.resolve_path(colors, path, profile, inherit_level)
    inherit_level = inherit_level or 0
    local path_spl = M.split(path, "|")
    local node = colors
    for i, v in pairs(path_spl) do
        if i < #path_spl and type(node[v]) == "table" then
            node = node[v]
        elseif i == #path_spl and type(node[v]) == "table" and type(node[v][profile]) == "table" then
            return node[v][profile]
        elseif
            i == #path_spl
            and (type(node[v]) == "string" or type(node[v][profile]) == "string")
            -- Allows only three levels of inheritance
            and inherit_level <= 3
        then
            return M.resolve_path(colors, (node[v][profile] or node[v]), profile, inherit_level + 1)
        else
            error("Invalid path: " .. path .. "; Missing node: " .. v)
        end
    end
    error("Nothing to resolve from.")
end

--- Function to get colors from palette table
--- @param colors table
--- @param path_prop string
--- @param profile profile
--- @return {name: string, hl: table, prop: string|nil|boolean}
function M.get_hl_props(colors, path_prop, profile)
    local path_prop_spl = M.split(path_prop, ".")
    local prop = path_prop_spl[2]
    local hl = M.resolve_path(colors, path_prop_spl[1], profile)
    -- local hl = node[profile]
    -- if type(hl) == "string" then
    --     hl = M.resolve_path(colors, hl)[profile]
    -- end
    local hl_group_name = string.gsub(path_prop_spl[1], "|", "_")
    if prop ~= nil and type(hl[prop]) == nil then
        error("Invalid property: " .. prop .. " for " .. path_prop)
    end
    if type(hl) ~= "table" then
        error("Invalid highlight at: " .. path_prop .. ". Inspection: " .. vim.inspect(hl))
    end
    return { name = hl_group_name, hl = hl, prop = hl[prop] }
end

function M.split(str, sep)
    sep = sep or "%s"
    local t = {}
    for substr in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, substr)
    end
    return t
end

--- @return vim.api.keyset.highlight
function M.get_project_color_hl()
    local cwd = vim.fn.getcwd()
    ---@type string
    local name = vim.fs.basename(cwd)
    local parent = vim.fs.basename(vim.fs.dirname(cwd))
    local parent_parent = vim.fs.basename(vim.fs.dirname(vim.fn.fnamemodify(cwd, ":h")))
    ---Add numbers to hashs to make it more random
    local num_parent = tonumber(parent) or 1
    local num_name = 1
    for _, v in ipairs({ name:byte(-3, -1) }) do
        num_name = num_name + v
    end
    ---Get hashs and ensure within 0-255 range
    ---@type number
    local r, g, b =
        M.string_to_hash(parent_parent) % 255,
        (M.string_to_hash(parent) * num_parent) % 255,
        (M.string_to_hash(name) * num_name) % 255

    ---Calculate hue from sum of hashs
    local hue = (r + g + b) % 360 / 360

    -- Background: High saturation (0.8) and lightness (0.5)
    local r1, g1, b1 = M.hsl_to_rgb(hue, 0.7, 0.5)

    -- Foreground: White or near-white
    local r2, g2, b2 = 255, 255, 255

    return { bg = string.format("#%02X%02X%02X", r1, g1, b1), fg = string.format("#%02X%02X%02X", r2, g2, b2) }
end

---@param str string
---@return number
function M.string_to_hash(str)
    if str == "" then
        return 0
    end

    local hash = 0
    for i = 1, #str do
        local char = string.byte(str, i)
        -- Simulate Java's 32-bit integer arithmetic
        hash = ((hash * 31) + char) % 0x100000000
        -- Handle negative numbers (Java's int is signed)
        if hash >= 0x80000000 then
            hash = hash - 0x100000000
        end
    end
    return hash
end

function M.rgb_to_hue(r, g, b)
    -- Normalize RGB values to 0-1 range
    r = r / 255
    g = g / 255
    b = b / 255

    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min
    local hue = 0

    if delta == 0 then
        return 0
    elseif max == r then
        hue = 60 * (((g - b) / delta) % 6)
    elseif max == g then
        hue = 60 * (((b - r) / delta) + 2)
    elseif max == b then
        hue = 60 * (((r - g) / delta) + 4)
    end

    -- Ensure hue is positive
    if hue < 0 then
        hue = hue + 360
    end

    return hue
end

function M.hsl_to_rgb(h, s, l)
    if s == 0 then
        return l, l, l
    end

    local function hue2rgb(p, q, t)
        if t < 0 then
            t = t + 1
        end
        if t > 1 then
            t = t - 1
        end
        if t < 1 / 6 then
            return p + (q - p) * 6 * t
        end
        if t < 1 / 2 then
            return q
        end
        if t < 2 / 3 then
            return p + (q - p) * (2 / 3 - t) * 6
        end
        return p
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q

    local r = hue2rgb(p, q, h + 1 / 3)
    local g = hue2rgb(p, q, h)
    local b = hue2rgb(p, q, h - 1 / 3)

    return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

return M
