require 'maths'

-- Check if a note value represents an actual note or (contains an note 'OFF' indicator or is empty)
local NOTE_OFF   = 120
local NOTE_EMPTY = 121

function is_note(note_value)
    return note_value and note_value ~= NOTE_OFF and note_value ~= NOTE_EMPTY
end

-- Get number of visible columns for a specific track
function get_visible_columns(song, track_index)
    return song.tracks[track_index].visible_note_columns
end

-- Check if track's note line contains at least one note
function has_note(song, line, track_index)
    local flag = false
    for column = 1, get_visible_columns(song, track_index) do
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
function volume_percentage(...)
    local n = select('#', ...)
    local t = {}
    local sum = 0
    for i = 1, n do
        local v = safe_volume(select(i, ...))
        sum = sum + v
        t[i] = v
    end
    local percentage = (sum == 0) and function(_) return 0 end or function(e) return round(e / sum, 4) end
    for i = 1, n do t[i] = percentage(t[i]) end
    return unpack(t)
end

-- Cache key for complex table keys
function cache_key(...)
    local sep = "-#-"
    local s = ""
    local n = select('#', ...)
    for i = 1, n do
        s = s..tostring(select(i, ...))..sep
    end
    return s
end

-- Check if two lines are the the same
function is_same_line(line, another_line)
    return line.sequence == another_line.sequence and line.line == another_line.line
end

-- Check if one line is before another
function is_before_line(line, another_line)
    return line.sequence < another_line.sequence or (line.sequence == another_line.sequence and line.line < another_line.line)
end

-- Check if one line is after another
function is_after_line(line, another_line)
    return line.sequence > another_line.sequence or (line.sequence == another_line.sequence and line.line > another_line.line)
end

-- Dump object
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..dump(k)..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    elseif type(o) == 'nil' then
        return "(NIL)"
    elseif type(o) == 'function' then
        return "(function)"
    elseif type(o) == 'string' then
        return o
    else
        return tostring(o)
    end
end
