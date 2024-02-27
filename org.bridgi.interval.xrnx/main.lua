require 'interface'
require 'language'
require 'common'
require 'maths'
require 'logging'
require 'metatables'
require 'settings'
require 'tunings'

renoise.tool():add_menu_entry { name   = "Main Menu:Tools:Bridgi:Interval Calculator (Condensed view)",
                                invoke = function() calculate_intervals(DIALOG_CONDENSED) end }
renoise.tool():add_menu_entry { name   = "Main Menu:Tools:Bridgi:Interval Calculator (Compact view)",
                                invoke = function() calculate_intervals(DIALOG_COMPACT) end }

renoise.tool():add_keybinding { name   = "Global:Tools:Interval Calculator (Condensed view)",
                                invoke = function() calculate_intervals(DIALOG_CONDENSED) end }
renoise.tool():add_keybinding { name   = "Global:Tools:Interval Calculator (Compact view)",
                                invoke = function() calculate_intervals(DIALOG_COMPACT) end }

--  ____ ____ _  _ ____ ____ _ ____    _ _  _ ___ ____ ____ _  _ ____ _       ____ _  _ _  _ ____ ___ _ ____ _  _ ____
--  | __ |___ |\ | |___ |__/ | |       | |\ |  |  |___ |__/ |  | |__| |       |___ |  | |\ | |     |  | |  | |\ | [__
--  |__] |___ | \| |___ |  \ | |___    | | \|  |  |___ |  \  \/  |  | |___    |    |__| | \| |___  |  | |__| | \| ___]

function new_interval(note1, note2, volume1, volume2)
    return Interval:new { note1 = note1, note2 = note2, volume1 = volume1, volume2 = volume2 }
end

--  ____ _  _ ____ ____ ___     ___  _ ____ ____ ____ _  _ ____ _  _ ____ ____
--  |    |__| |  | |__/ |  \    |  \ | [__  [__  |  | |\ | |__| |\ | |    |___
--  |___ |  | |__| |  \ |__/    |__/ | ___] ___] |__| | \| |  | | \| |___ |___

-- Calculate ratios between all combinations of dyads
-- based on actual frequency ratios, not by combining the intervals
local function chord_ratios_frequencies(...)
    local N = select('#', ...)
    if not ... or N == 0 then return nil end
    local ratios = Ratios.new {}
    for i = 1, N - 1 do
        for j = i + 1, N do
            local interval = new_interval(select(i, ...).note, select(j, ...).note)
            ratios[schildkraut(i - 1, j - 1, N) + 1] = interval:ratio()
        end
    end
    trace_log("Chord ratios (frequencies) for N="..N.." notes: "..Ratios.tostring(ratios, nil, "  "))
    return ratios
end

-- Calculate ratios between all combinations of dyads
-- based on combining the intervals, not the actual frequency ratios, as there are none when thinking in pure intervals
local function chord_ratios_pure(...)
    local N = select('#', ...)
    if not ... or N == 0 then return nil end
    local ratios = Ratios.new {}
    for i = 1, N - 1 do
        for j = i + 1, N do
            -- Calculate ratio between note at index i and note at index j by multiplying out the ratios in between
            local a, b = 1, 1
            for k = i + 1, j do
                local interval = new_interval(select(k, ...).note, select(k - 1, ...).note)
                local _a, _b = interval:ab()
                a, b = a * _a, b * _b
            end
            a, b = reduce_fraction(a, b)
            ratios[schildkraut(i - 1, j - 1, N) + 1] = { a, b }
        end
    end
    trace_log("Chord ratios (pure) for N="..N.." notes: "..Ratios.tostring(ratios, nil, "  "))
    return ratios
end

-- Calculate dissonance for a chord with notes not necessarily having the same volume level
-- Basically the chord is dissected into chords having the same volume level, again using the function above.
function dissect_chord(depth, ratio_cache, ...)
    local N = select('#', ...)
    if not ... or N == 0 then return nil end
    if not depth then depth = 1 end
    if not ratio_cache then
        -- The calculation of the ratio depends on whether we know the frequencies
        -- or whether we have only the pure intervals between notes
        local f
        if settings.tuning.value == 1 then f = chord_ratios_pure else f = chord_ratios_frequencies end
        ratio_cache = f(...)
    end
    local remaining = 0
    local volume = math.huge
    -- Get lowest volume level which is still larger than zero and find out how many notes still have a volume level larger than zero
    for i = 1, N do
        local e = select(i, ...)
        if e.volume_percentage > 0 then
            remaining = remaining + 1
            volume = math.min(volume, e.volume_percentage)
        end
    end
    if remaining <= 1 then  -- End of recursion
        return 1 -- Return a dissonance value of one in case if less than two notes left - then we just have a prime
    end
    -- Get dyads in which both notes still have a volume level larger than zero
    local partial = Ratios.new {}
    for i = 1, N - 1 do
        for j = i + 1, N do
            if select(i, ...).volume_percentage > 0 and select(j, ...).volume_percentage > 0 then
                table.insert(partial, ratio_cache[schildkraut(i - 1, j - 1, N) + 1])
            end
        end
    end
    -- Reduce volume level for all notes by the minimum volume level
    local rest = {}
    for i = 1, N do
        local e = select(i, ...)
        table.insert(rest, { note = e.note, delta = e.delta, volume_percentage = math.max(e.volume_percentage - volume, 0)})
    end
    -- Get dissonance for the dyads with minimum volume level and start-over again for the remaining volume level
    return dissonance_value(nil, volume, remaining, partial) * dissect_chord(depth + 1, ratio_cache, unpack(rest))
end

local function dissect_chord_wrapper(...)
    local tmp = {...}
    return function()
        return dissect_chord(1, nil, unpack(tmp))
    end
end

--  ____ _ _  _ ___     _  _ ____ ___ ____ ____
--  |___ | |\ | |  \    |\ | |  |  |  |___ [__
--  |    | | \| |__/    | \| |__|  |  |___ ___]
--

-- Storage for the keys of a set to make sure that there's only one table representing a specific position
-- (used to get sort of a hash set structure which supports keys as tables)
local position_keys = {}

-- Test if a key is already existing - if not, create a new one
function position_key(sequence_index, line_index)
    for k, _ in pairs(position_keys) do
        if k.sequence == sequence_index and k.line == line_index then return k end
    end
    local key = { line = line_index, sequence = sequence_index }
    position_keys[key] = true
    return key
end

-- Retrieve lines from all tracks of interest
local function get_lines(song, position)
    local lines = {}
    for i = 0, settings_tracks().value - 1 do
        local track_index   = song.selected_track_index + i
        local pattern_index = song.sequencer.pattern_sequence[position.sequence]
        local pattern_track = song.patterns[pattern_index].tracks[track_index]
        lines[track_index]  = pattern_track.lines[position.line]
    end
    return lines
end

-- Search for lines of interest in various directions
local function look(song, lines_seen, track_index, position, column, delta, take_all, direction)
    assert(direction == -1 or direction == 1 or direction == 0)
    local sequence_index = position.sequence
    local line_index     = position.line + direction
    local pattern_index  = song.sequencer.pattern_sequence[position.sequence]
    local pattern_track  = song.patterns[pattern_index].tracks[track_index]
    delta = delta and delta or 0
    if not take_all then take_all = false end
    if direction == 0 then
        local line = pattern_track.lines[position.line]
        if is_note(line.note_columns[column].note_value) or take_all then
            lines_seen[position] = { lines = get_lines(song, position), delta = 0 }
            return { position = position, lines = lines_seen[position] }, lines_seen
        else
            return nil, lines_seen
        end
    end
    local n = 1
    repeat
        local lines_count     = song.patterns[song.sequencer.pattern_sequence[sequence_index]].number_of_lines
        local sequences_count = table.getn(song.sequencer.pattern_sequence)
        if direction > 0 and line_index > lines_count and sequence_index < sequences_count then
            sequence_index = sequence_index + 1
            local next_pattern = song.patterns[song.sequencer.pattern_sequence[sequence_index]]
            pattern_track = next_pattern.tracks[track_index]
            line_index = 1
        elseif direction < 0 and line_index < 1 and sequence_index - 1 > 0 then
            sequence_index = sequence_index - 1
            local prev_pattern = song.patterns[song.sequencer.pattern_sequence[sequence_index]]
            pattern_track = prev_pattern.tracks[track_index]
            line_index = prev_pattern.number_of_lines
        else
            if line_index > lines_count or line_index < 1 or n + delta > settings_delta().value then
                return nil, lines_seen
            end
        end
        local line = pattern_track.lines[line_index]
        if has_note(song, line, track_index) or take_all then
            local key = position_key(sequence_index, line_index)
            lines_seen[key] = { lines = get_lines(song, key), delta = n + delta }
            if (column and is_note(line.note_columns[column].note_value)) or not column or take_all then
                return { position = key, lines = lines_seen[key] }, lines_seen
            end
        end
        line_index = line_index + direction
        n = n + 1
    until false
end

-- Just creates a sorted hash set
function ordered_line_pairs(tbl)
    local keys = {}
    for k in pairs(tbl) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b)
        if     a.sequence < b.sequence then return true
        elseif a.sequence > b.sequence then return false
        else                                return a.line < b.line
        end
    end)
    local i = 0
    return function()
        i = i + 1
        if keys[i] then return i, keys[i], tbl[keys[i]] end
    end
end

-- Just counts the number of keys in a table
local function count_keys(tbl)
    local count = 0
    for _, _ in pairs(tbl) do count = count + 1 end
    return count
end

-- Helper function to check whether the maximum number of lines to be displayed is already reached
local function max_lines_reached(lines_of_interest)
    return count_keys(lines_of_interest) >= settings_lines().value
end

-- Get some details about what the search yielded so far
-- Basically used to check if a few lines of notes were missed in between, as first priority is to lookup intervals
function line_statistics(lines_of_interest)
    local count = 0
    local first = position_key(math.huge, math.huge)
    local last  = position_key(-math.huge,-math.huge)
    for k, _ in pairs(lines_of_interest) do
        count = count + 1
        if is_before_line(k, first) then first = k end
        if is_after_line (k, last ) then last  = k end
    end
    return count, first, last
end

-- Get measures
function line_measures(song, lines_of_interest)
    local measures = {}
    for i = 0, settings_tracks().value - 1 do
        local track_index   = i + song.selected_track_index
        local column_count  = get_visible_columns(song, track_index)
        local columns       = {}
        local empty_column_count = 0
        for j = 1, column_count do
            local n = 0
            for _, _, v in ordered_line_pairs(lines_of_interest) do
                local note_column = v.lines[track_index].note_columns[j]
                if is_note(note_column.note_value) then
                    n = n + 1
                end
            end
            local is_empty = n == 0
            columns[j] = { is_empty = is_empty, covered = n > 1, track_index = track_index }
            if is_empty then empty_column_count = empty_column_count + 1 end
        end
        measures[track_index] = { column_count       = column_count,
                                  columns            = columns,
                                  track_index        = track_index,
                                  empty_column_count = empty_column_count }
    end
    return measures
end

-- Eventually find more lines of notes, if there is still space left in the view, determined by a configuration property
-- which indicates the maximum number of lines to be displayed
function add_lines(song, lines_seen, lines_of_interest, track_index, position, take_all)
    -- Flag to indicate whether to continue searching backwards or forwards (used for alternating the search direction)
    local flag = false
    local delta_a = 0
    local delta_b = 0
    local a = { position = position, lines = nil }
    local b = { position = position, lines = nil }
    repeat
        if max_lines_reached(lines_of_interest) then break end
        -- Alternate backward and forward search
        if not flag then
            if b then
                for i = 0, settings_tracks().value - 1 do
                    if b then
                        b, lines_seen = look(song, lines_seen, track_index + i, b.position, nil, delta_b, take_all, -1)
                    end
                    if b then break end
                end
                if b then lines_of_interest[b.position] = b.lines; delta_b = b.lines.delta end
            end
            flag = true
        elseif flag then
            if a then
                for i = 0, settings_tracks().value - 1 do
                    if a then
                        a, lines_seen = look(song, lines_seen, track_index + i, a.position, nil, delta_a, take_all, 1)
                    end
                    if a then break end
                end
                if a then lines_of_interest[a.position] = a.lines; delta_a = a.lines.delta end
            end
            flag = false
        end
        if not b and not a then break end
    until false
    return lines_seen, lines_of_interest
end

-- Find lines of notes, just based on the view size and search settings
function find_lines(song, track_index, position)
    local lines_of_interest = {}
    local lines_seen        = {}
    local line
    for i = 0, settings_tracks().value - 1 do
        local column_count = get_visible_columns(song, track_index + i)
        for j = 1, column_count do
            line, lines_seen = look(song, lines_seen, track_index + i, position, j, nil, false, 0)
            if line then
                lines_of_interest[line.position] = line.lines
            end
            if max_lines_reached(lines_of_interest) then break end
        end
    end
    lines_seen, lines_of_interest = add_lines(song, lines_seen, lines_of_interest, track_index, position, settings.skip_empty_compact.value)
    return lines_of_interest
end

-- Find lines of notes, prioritize finding intervals over displaying all available lines
function find_lines_of_interest(song, track_index, position)
    local lines_of_interest = {}
    local lines_seen        = {}
    local a, b, c
    -- Make sure that for each note in a column at least one interval is found if any
    -- This might result in "missing" lines, which is favoured to get a more compact representation
    for i = 0, settings_tracks().value - 1 do
        local column_count = get_visible_columns(song, track_index + i)
        for j = 1, column_count do
            local measures = line_measures(song, lines_of_interest)
            local track_measures = measures[track_index + i]
            local column_measures = track_measures.columns[j]
            if not column_measures.covered then
                c, lines_seen = look(song, lines_seen, track_index + i, position, j, nil, false,  0)
                b, lines_seen = look(song, lines_seen, track_index + i, position, j, nil, false, -1)
                a, lines_seen = look(song, lines_seen, track_index + i, position, j, nil, false,  1)
                if c and (b or a) then lines_of_interest[c.position] = c.lines end
                if max_lines_reached(lines_of_interest) then break end
                if b and (c or a) then lines_of_interest[b.position] = b.lines end
                if max_lines_reached(lines_of_interest) then break end
                if a and (b or c) then lines_of_interest[a.position] = a.lines end
                if max_lines_reached(lines_of_interest) then break end
            end
        end
    end
    -- Add additional lines, if there's still space left to display more lines
    lines_seen, lines_of_interest = add_lines(song, lines_seen, lines_of_interest, track_index, position, false)
    -- Determine how many lines there are in the same range of the lines of interest
    local p
    for i, j, line_of_interest in ordered_line_pairs(lines_of_interest) do
        local lines_in_between = {}
        if i > 1 then
            for _, k, line_seen in ordered_line_pairs(lines_seen) do
                if is_before_line(p, k) and is_after_line(j, k) then
                    table.insert(lines_in_between, line_seen)
                    -- Do not consider gaps here, the line might not contain any notes at all
                end
            end
        end
        line_of_interest.in_between = lines_in_between
        p = j
    end
    return lines_of_interest
end

--  ___  _  _ _ _    ___     _  _ ____ ___ ____ _ _  _
--  |__] |  | | |    |  \    |\/| |__|  |  |__/ |  \/
--  |__] |__| | |___ |__/    |  | |  |  |  |  \ | _/\_

-- Initial creation of a condensed view
function create_view(song, lines_of_interest)
    local measures  = line_measures(song, lines_of_interest)
    local min_delta = math.huge
    local max_index = -math.huge
    local notes     = {}
    local complete  = true
    -- Create note matrix for calculating intervals first
    for i, p, v in ordered_line_pairs(lines_of_interest) do
        notes[i] = {}
        local j = 0
        for k = 0, settings_tracks().value - 1 do
            for column = 1, measures[song.selected_track_index + k].column_count do
                if not measures[song.selected_track_index + k].columns[column].is_empty then
                    j = j + 1
                    local note = v.lines[k + song.selected_track_index].note_columns[column]
                    notes[i][j] = { column         = column,
                                    delta          = v.delta,
                                    track          = song.selected_track_index + k,
                                    sequence_index = p.sequence,
                                    line_index     = p.line,
                                    line           = v.lines[song.selected_track_index + k],
                                    string         = note.note_string,
                                    value          = note.note_value,
                                    volume         = safe_volume(note.volume_value) }
                    -- Check if there are lines in between which were left out
                    if v.in_between then
                        for _, b in ipairs(v.in_between) do
                            local line = b.lines[k + 1]
                            if not line then
                                renoise.app():show_message("B lines: "..dump(b.lines))
                            end
                            if not line.note_columns then
                                renoise.app():show_message("Line: "..dump(line))
                            end
                            if is_note(line.note_columns[column].note_value) then
                                notes[i][j].gaps = true
                                -- Memorize if there's at least one skipped note
                                complete = false
                            end
                        end
                    end
                end
            end
        end
        -- Set minimum delta between note line and current cursor position if applicable
        if v.delta < min_delta then min_delta = v.delta end
        -- Store highest sequence and line numbers to fine-tune column width
        local index_len = string.len(index_string(p.sequence, p.line))
        if index_len > max_index then max_index = index_len end
    end
    if #notes[1] == 0 then
        return nil
    end
    -- Mark each row according to the minimum delta
    for row = 1, #notes do
        for column = 1, #notes[row] do
            notes[row][column].marker = notes[row][column].delta == min_delta
        end
    end
    -- Calculate details for dyads and chords
    add_row_intervals(notes)
    add_column_intervals(notes)
    local chords = get_chords(notes, complete)
    -- Create actual view
    local view = {}
    for row = 1, #notes do
        view[row * 2 - 1] = {}
        if row < #notes then
            view[row * 2] = {}
        end
        for column = 1, #notes[row] do
            view[row * 2 - 1][column * 2 - 1] = { type = "note", note = notes[row][column] }
            if row < #notes then
                view[row * 2][column * 2 - 1] = { type = "data", data = notes[row][column].vertical }
            end
            if column < #notes[row] then
                view[row * 2 - 1][column * 2] = { type = "data", data = notes[row][column].horizontal }
                if row < #notes then
                    view[row * 2][column * 2] = { type = "text", text = notes[row][column].delta }
                end
            end
        end
        view[row * 2 - 1][#notes[row] * 2 + 0] = { type = "data", data = chords.actual[row] }
        view[row * 2 - 1][#notes[row] * 2 + 1] = { type = "data", data = chords.linger[row] }
        if row < #notes then
            view[row * 2][#notes[row] * 2 + 0] = { type = "text", text = notes[row][1].delta }
            view[row * 2][#notes[row] * 2 + 1] = { type = "text", text = notes[row][1].delta }
        end
    end
    return { measures   = measures,
             view       = view,
             notes      = notes,
             note_count = #notes[1],
             max_index  = max_index,
             complete   = complete,
             status     = complete and { status = STATUS_OK           , color = COLOR_DEFAULT        }
                                    or { status = STATUS_LINES_OMITTED, color = COLOR_STATUS_WARNING }}
end

-- Calculate intervals between successive notes
function add_row_intervals(notes)
    local rows = #notes
    if rows < 2 then
        return
    end
    for row = 2, rows do
        for column = 1, #notes[row] do
            local note1 = notes[row][column].value
            local volume1 = notes[row][column].volume
            if is_note(note1) and not notes[row][column].gaps then
                local note0, volume0
                for b = row - 1, 1, -1 do
                    note0 = (is_note(notes[b][column].value) and not notes[b][column].gaps) and notes[b][column].value or nil
                    volume0 = notes[b][column].volume
                    if note0 then break end
                end
                if is_note(note0) then
                    notes[row - 1][column].vertical = new_interval(note0, note1, volume0, volume1)
                end
            end
        end
    end
end

-- Calculate intervals between dyads of a chord
function add_column_intervals(notes)
    local rows = #notes
    for row = 1, rows do
        if #notes[row] < 2 then
            return
        end
        for column = 2, #notes[row] do
            local note1 = notes[row][column].value
            local volume1 = notes[row][column].volume
            if is_note(note1) then
                local note0, volume0
                for b = column - 1, 1, -1 do
                    note0 = is_note(notes[row][b].value) and notes[row][b].value or nil
                    volume0 = notes[row][b].volume
                    if note0 then break end
                end
                if is_note(note0) then
                    notes[row][column - 1].horizontal = new_interval(note0, note1, volume0, volume1)
                end
            end
        end
    end
end

-- This function considers the chord as a whole, in contrast to the functions above, which are only
-- about dyads viewed independently of each other. In addition to the actual chord, the function
-- searches for reverberating notes, but only if no lines were omitted previously. Currently, the
-- function does not consider "OFF" notes
function get_chords(notes, complete)
    local row_count = #notes
    local chord_linger = {}
    local chord_actual = {}
    for row = 1, row_count do
        chord_actual[row] = {}
        chord_linger[row] = {}
        local column_count = #notes[row]
        for column = 1, column_count do
            local delta = 0
            for search_row = row, 1, -1 do
                local note = notes[search_row][column].value
                if row ~= search_row then
                    delta = delta + notes[search_row][column].delta
                end
                if is_note(note) then
                    local actual_volume = safe_volume(notes[search_row][column].volume)
                    if search_row == row then
                        chord_actual[row][#chord_actual[row] + 1] = { note = note, delta  = delta, volume = actual_volume }
                    end
                    local damped_volume = actual_volume
                    if delta > 0 then
                        damped_volume = damped_volume * settings.volume_reduction.value ^ delta
                    end
                    chord_linger[row][#chord_linger[row] + 1] = { note = note, delta = delta, volume = damped_volume }
                    break
                end
            end
        end

        local add_volume_percentage = function(tbl)
            local v = {}
            for i, e in ipairs(tbl) do v[i] = e.volume end
            v = { volume_percentage(unpack(v)) }
            for i, e in ipairs(v) do tbl[i].volume_percentage = e end
        end

        add_volume_percentage(chord_actual[row])
        -- Do not consider lingering chords if we haven't got a full set of notes to avoid invalid values at the top
        if #chord_linger[row] < column_count then
            chord_linger[row] = {}
        else
            add_volume_percentage(chord_linger[row])
        end

        chord_actual[row].chord = dissect_chord_wrapper(unpack(chord_actual[row]))
        -- Lingering chord dissonance only makes sense if no lines were omitted
        chord_linger[row].chord = complete and dissect_chord_wrapper(unpack(chord_linger[row])) or {}
    end
    return { actual = chord_actual, linger = chord_linger }
end

--  ____ ____ _  _ _  _ ___ ____ ____ ___  ____ _ _  _ ___
--  |    |  | |  | |\ |  |  |___ |__/ |__] |  | | |\ |  |
--  |___ |__| |__| | \|  |  |___ |  \ |    |__| | | \|  |

-- Check for some violations according to the counterpoint (Kontrapunkt) system
function check_counterpoint(data)
    if not data.complete then
        return data
    end
    local notes = data.notes
    local row_count = #notes
    local fifths  = {}
    local fourths = {}
    local octaves = {}
    local leaps   = {}
    local seconds = {}
    local violations = ""

    local function leap_direction(n)
        return n > 0 and 1 or n < 0 and -1 or false
    end

    for row = 1, row_count do
        leaps  [row] = nil
        seconds[row] = nil
        fifths [row] = nil
        fourths[row] = nil
        octaves[row] = nil
        for column = 1, #notes[row] do
            local t = notes[row][column].vertical
            if type(t) == 'table' then
                local halftones = math.abs(t.halftones)
                fourths[row] = t.interval ==  5 -- also considers 11th, .. as fourths
                fifths [row] = t.interval ==  7 -- also considers 12th, .. as fifths
                octaves[row] = t.interval == 12 -- also considers 19th, .. as octaves
                leaps  [row] = (halftones >= 7                  ) and leap_direction(t.halftones) or false
                seconds[row] = (halftones == 1 or halftones == 2) and leap_direction(t.halftones) or false
            end
        end
    end

    local previous
    previous = function(t, i)
        if t[i] ~= nil then
            return i, t[i]
        elseif i > 1 then
            return previous(t, i - 1)
        else
            return nil, nil
        end
    end

    local next
    next = function(t, i, rows)
        if t[i] ~= nil then
            return i, t[i]
        elseif i < rows then
            return next(t, i + 1, rows)
        else
            return nil, nil
        end
    end

    local consecutive
    consecutive = function(t1, t2, i, f)
        if t1[i] then
            local j, v = f(t2, i - 1)
            if v then
                return j
            end
        end
        return nil
    end

    for row = 2, row_count do
        if consecutive(fifths , fifths , row, previous) then violations = violations.."5-5 "   end
        if consecutive(octaves, octaves, row, previous) then violations = violations.."12-12 " end
    end

    for row = 3, row_count do
        local i = consecutive(fifths, fourths, row, previous)
        if i and i > 1 then
            if consecutive(fourths, fifths, i, previous) then violations = violations.."5-4-5 " end
        end
    end

    for row = 1, row_count - 1 do
        if leaps[row] == 1 then
            local _, v = next(seconds, row + 1, row_count)
            if not v or v ~= -1 then violations = violations..">=+7~-1|2 " end
        elseif leaps[row] == -1 then
            local _, v = next(seconds, row + 1, row_count)
            if not v or v ~=  1 then violations = violations..">=-7~+1|2 " end
        end
    end

    if violations ~= "" then
        data.counterpoint = { code = COUNTERPOINT_PATTERN_VIOLATION, details = violations }
    else
        data.counterpoint = {}
    end

    return data
end

--  _  _ ____ _ _  _
--  |\/| |__| | |\ |
--  |  | |  | | | \|
--

local function log_marker(text)
    trace_log("-------------------------------------------------")
    trace_log("-- "..text)
    trace_log("--    at "..os.date("!%Y-%m-%dT%TZ"))
    trace_log("-------------------------------------------------")
end

function calculate_intervals(dialog_type)

    log_marker("INTERVAL ANALYSIS STARTED")

    settings.dialog_type.value = dialog_type

    -- Find notes
    local song        = renoise.song()
    local track_index = song.selected_track_index
    local position    = position_key(song.selected_sequence_index, song.transport.edit_pos.line)
    local lines
    if dialog_type == 1 then
        lines = find_lines_of_interest(song, track_index, position)
    elseif dialog_type == 2 then
        lines = find_lines(song, track_index, position)
    end

    -- Abort if nothing found to display
    if count_keys(lines) < 2 then
        renoise.app():show_message("Not enough notes found - at least two rows in search range required")
        return
    end

    -- Create view and check for some counterpoint violations
    local data = create_view(song, lines, track_index)
    if not data then
        renoise.app():show_message("No columns to display found (empty?)")
        return
    end
    data = check_counterpoint(data)
    data.dialog_type = dialog_type

    -- Create actual dialog and perform initial update of view elements
    local vb             = renoise.ViewBuilder()
    local dialog_content = create_dialog(vb, settings, data, dialog_type)
    renoise.app():show_custom_dialog("Interval Analysis", dialog_content)
    update_interface(vb, settings, data)

    log_marker("INTERVAL ANALYSIS ENDED")
end
