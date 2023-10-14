require 'maths'

-- Check if a note value represents an actual note or (contains an note 'OFF' indicator or is empty)
local NOTE_OFF   = 120
local NOTE_EMPTY = 121

function is_note(note_value)
    return note_value and note_value ~= NOTE_OFF and note_value ~= NOTE_EMPTY
end

-- Check if track's note line contains at least one note
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

