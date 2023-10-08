--  _  _ ____ ___ _  _
--  |\/| |__|  |  |__|
--  |  | |  |  |  |  |
--

-- Alternative to Cantor's pairing function, with a given N, yielding numbers between zero and the number of unique combinations
--     https://math.stackexchange.com/questions/4011580/alternatives-to-cantors-pairing-that-produces-numbers-between-0-and-the-number
-- The reasoning here is to avoid having to deal with Lua's speciality of finalizing the iteration on nil values
-- Needs to be adjusted when used to work with Lua's one-based indexing...
function schildkraut(a, b, n)
    return (a * (2 * n - 1 - a)) / 2 + (b - a - 1)
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

-- Used for testing purposes (comparing expected values and actual values)

local EPSILON = 0.01

function is_almost(a, b)
    return math.abs(a - b) < EPSILON
end

--  ____ ____ _  _ ____ _ ____ ____
--  |__/ |___ |\ | |  | | [__  |___
--  |  \ |___ | \| |__| | ___] |___
--

-- Check if a note value represents an actual note or (contains an note 'OFF' indicator or is empty)

local NOTE_OFF   = 120
local NOTE_EMPTY = 121

function is_note(note_value)
    return note_value and note_value ~= NOTE_OFF and note_value ~= NOTE_EMPTY
end

-- Simple check if track's note line contains at least one note
function has_note(line, track)
    local flag = false
    for column = 1, track.visible_note_columns do
        local note_column = line.note_columns[column]
        if is_note(note_column.note_value) then flag = true end
    end
    return flag
end

-- Make sure that the volume is inside [0, 127]

local VOLUME_MAX = 127

function safe_volume(volume)
    return (not volume) and VOLUME_MAX or (volume > VOLUME_MAX and VOLUME_MAX or volume)
end

-- Calculate volume percentages for a given chord
function add_volume_percentage(...)
    local tmp = {...}
    local t   = {}
    local sum = 0
    for _, a in ipairs(tmp) do sum = sum + safe_volume(a.volume) end
    local vp = (sum == 0) and function(a) return 0 end or function(a) return round(safe_volume(a.volume) / sum, 4) end
    for i, a in ipairs(tmp) do t[i] = a
        t[i].volume_percentage = vp(a)
    end
    return t
end

--  _    ____ ____ ____ _ _  _ ____
--  |    |  | | __ | __ | |\ | | __
--  |___ |__| |__] |__] | | \| |__]
--

if renoise.app() then
    interval_log_file_name = renoise.app().log_filename.."_interval.log"
    interval_log_file = io.open(interval_log_file_name, "a")
end

local function log(level, something)
    if interval_log_file then
        interval_log_file:write(tostring(level.." "..something),"\n")
        interval_log_file:flush()
    else
        print(tostring(level.."  "..something))
    end
end


function trace_log(something)
    log("TRACE", something)
end

function error_log(something)
    log("ERROR", something)
end

function test_log(something)
    log("TEST ", something)
end

function vararg_tostring(separator, ...)
    local N = select('#', ...)
    if not ... or N == 0 then return "<empty varargs>" end
    local s = ""
    local sep = ""
    for i = 1, N do
        s = s..sep..select(i, ...)
        sep = separator
    end
    return s
end

--  _  _ ____ ___ ____ ___ ____ ___  _    ____ ____
--  |\/| |___  |  |__|  |  |__| |__] |    |___ [__
--  |  | |___  |  |  |  |  |  | |__] |___ |___ ___]
--

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
