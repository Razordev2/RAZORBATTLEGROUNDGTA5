Utils = Utils or {}

-- Calculate 3D Distance between two vectors or tables
function Utils.GetDistance3D(pos1, pos2)
    if not pos1 or not pos2 then return 999999.0 end
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dz = pos1.z - pos2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Calculate 2D Distance (ignoring Z height)
function Utils.GetDistance2D(pos1, pos2)
    if not pos1 or not pos2 then return 999999.0 end
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    return math.sqrt(dx * dx + dy * dy)
end

-- Generate a unique string ID with prefix
function Utils.GenerateId(prefix)
    prefix = prefix or "ID"
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomStr = ""
    for i = 1, 6 do
        local rand = math.random(1, #chars)
        randomStr = randomStr .. string.sub(chars, rand, rand)
    end
    return string.format("%s_%s", prefix, randomStr)
end

-- Sanitize text string for safe display
function Utils.SanitizeText(str)
    if not str or type(str) ~= "string" then return "" end
    return (str:gsub("[<>]", ""))
end

-- Deep table copy helper
function Utils.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Utils.DeepCopy(orig_key)] = Utils.DeepCopy(orig_value)
        end
        setmetatable(copy, Utils.DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end
