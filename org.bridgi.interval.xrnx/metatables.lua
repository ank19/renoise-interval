Ratios = {}

Ratios.mt = {}

function Ratios.new()
    return setmetatable({}, Ratios.mt)
end

function Ratios.single(a, b)
    local ratios = {}
    ratios[1] = {a, b}
    return setmetatable(ratios, Ratios.mt)
end

function Ratios.tostring(ratios, sep1, sep2)
    sep1 = sep1 or "/"
    sep2 = sep2 or " * "
    local s = ""
    local sep = ""
    for _, e in ipairs(ratios) do
        local a, b = unpack(e)
        s = s..sep..a.. sep1 ..b
        sep = sep2
    end
    return s
end