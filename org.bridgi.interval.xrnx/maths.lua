-- Alternative to Cantor's pairing function, with a given N, yielding numbers between zero and the number of unique combinations
--     https://math.stackexchange.com/questions/4011580/alternatives-to-cantors-pairing-that-produces-numbers-between-0-and-the-number
-- The reasoning here is to avoid having to deal with Lua's speciality of finalizing the iteration on nil values
-- Needs to be adjusted when used to work with Lua's one-based indexing...
function schildkraut(a, b, n)
    return (a * (2 * n - 1 - a)) / 2 + (b - a - 1)
end

-- Approximate fraction algorithm from
--   Harmony Perception by Periodicity Detection
--   Article in Journal of Mathematics and Music · March 2015
--   DOI: 10.1080/17459737.2015.1033024
--   Frieder Stolzenburg
function approximate_rational(irrational, limit, hearing_threshold)
    local m = limit and limit or math.huge
    local x = irrational
    local x1 = (1 - hearing_threshold) * x
    local x2 = (1 + hearing_threshold) * x
    local al = math.floor(x)
    local bl = 1
    local l = al / bl
    if x1 <= l and l <= x2  then
        return al, bl
    end
    local ar = al + 1
    local br = 1
    local r = ar / br
    if x1 <= r and r <= x2  then
        return ar, br
    end
    repeat
        local am = al + ar
        local bm = bl + br
        if am > m or bm > m then
            error_log("Cannot approximate rational for "..irrational
                    .." with hearing threshold "..hearing_threshold
                    .." and numerator/ denominator limit "..m)
            return nil, nil
        end
        local ambm = am / bm
        if x1 <= ambm and ambm <= x2 then
            trace_log("Approximated ".. irrational
                    .." with threshold "..hearing_threshold.." to "..am.."/"..bm)
            return am, bm
        elseif x2 < ambm then
            local k = math.floor((ar - x2 * br) / (x2 * bl - al))
            am = ar + k * al
            bm = br + k * bl
            ar = am
            br = bm
        elseif ambm < x1 then
            local k = math.floor((x1 * bl - al) / (ar - x1 * br))
            am = al + k * ar
            bm = bl + k * br
            al = am
            bl = bm
        end
    until false
end

-- Wrapper function for approximation of already known rational
--    ... in order to take hearing threshold into consideration
local function approximate_irrational(a, b, max, hearing_threshold)
    return approximate_rational(a / b, max, hearing_threshold)
end

function round(n, digits)
    local f = 10 ^ (digits or 0)
    return math.floor(0.5 + n * f) / f
end

function greatest_common_divisor(a, b)
    while b ~= 0 do
        local t = a
        a = b
        b = t % b
    end
    return a
end

function least_common_multiple(a, b)
    return (a ~= 0 and b ~= 0) and a * b / greatest_common_divisor(a, b) or 0
end

function reduce_fraction(a, b)
    local gcd = greatest_common_divisor(a, b)
    a = a / gcd
    b = b / gcd
    return a, b
end

-- Used for testing purposes (comparing expected values and actual values)
local EPSILON = 0.01
function is_almost(a, b)
    return math.abs(a - b) < EPSILON
end
