local NOTE_OFF   = 120
local NOTE_EMPTY = 121

function is_note(note_value)
    return note_value and note_value ~= NOTE_OFF and note_value ~= NOTE_EMPTY
end

function has_note(line, track)
    local flag = false
    for column = 1, track.visible_note_columns do
        local note_column = line.note_columns[column]
        if is_note(note_column.note_value) then flag = true end
    end
    return flag
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

-- Make sure that the volume is inside [0, 127]
function safe_volume(volume)
    return (not volume) and 127 or (volume > 127 and 127 or volume)
end

-- Calculate volume percentages for a given chord
function add_volume_percentage(...)
    local tmp = {...}
    local t   = {}
    local sum = 0
    for _, a in ipairs(tmp) do sum = sum + safe_volume(a.volume) end
    local vp = (sum == 0) and function(a) return 0 end
            or function(a) return round(safe_volume(a.volume) / sum, 4) end
    for i, a in ipairs(tmp) do t[i] = a
        t[i].volume_percentage = vp(a)
    end
    return t
end

if renoise.app() then
    interval_log_file_name = renoise.app().log_filename.."_interval.log"
    interval_log_file = io.open(interval_log_file_name, "a")
end

function trace_log(something)
    if interval_log_file then
        interval_log_file:write(tostring("TRACE: "..something),"\n")
        interval_log_file:flush()
    end
    print(tostring("TRACE: "..something))
end

function error_log(something)
    if interval_log_file then
        interval_log_file:write(tostring("ERROR: "..something),"\n")
        interval_log_file:flush()
    end
    print(tostring("ERROR: "..something))
end
