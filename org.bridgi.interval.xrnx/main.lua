require 'interface'
require 'language'
require 'common'
require 'maths'
require 'logging'
require 'metatables'
require 'settings'
require 'tunings'

renoise.tool():add_menu_entry { name   = "Main Menu:Tools:Bridgi:Interval Calculator",
                                invoke = function() calculate_intervals() end }

renoise.tool():add_keybinding { name   = "Global:Tools:Interval Calculator",
                                invoke = function() calculate_intervals() end }

--  ____ ____ _  _ ____ ____ _ ____    _ _  _ ___ ____ ____ _  _ ____ _       ____ _  _ _  _ ____ ___ _ ____ _  _ ____
--  | __ |___ |\ | |___ |__/ | |       | |\ |  |  |___ |__/ |  | |__| |       |___ |  | |\ | |     |  | |  | |\ | [__
--  |__] |___ | \| |___ |  \ | |___    | | \|  |  |___ |  \  \/  |  | |___    |    |__| | \| |___  |  | |__| | \| ___]

function new_interval(note1, note2, volume1, volume2)
    return Interval:new {
        note1 = note1,
        note2 = note2,
        volume1 = volume1,
        volume2 = volume2
    }
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
-- based on combining the intervals, not actual frequency ratios, which are not available when thinking in pure intervals
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
local function position_key(sequence_index, line_index)
  for k, _ in pairs(position_keys) do
    if k.sequence == sequence_index and k.line == line_index then return k end
  end
  local key = {line = line_index, sequence = sequence_index}
  position_keys[key] = true
  return key
end

-- Backward search for notes which might be part of an interval considering our current position
local function look_back(lines, pattern_track, track, track_idx, position, col_idx, delta)
  local song       = renoise.song()
  local c_seq_idx  = position.sequence
  local c_line_idx = position.line - 1
  local c_delta    = 1
  delta = delta and delta or 0
  repeat
    if c_line_idx < 1 and c_seq_idx - 1 > 0 then
      c_seq_idx = c_seq_idx - 1
      local prev_pattern = song.patterns[song.sequencer.pattern_sequence[c_seq_idx]]
      pattern_track = prev_pattern.tracks[track_idx]
      c_line_idx = prev_pattern.number_of_lines
    else
      if c_line_idx < 1 or c_delta + delta > settings.max_delta.value then return nil, nil, nil, nil end
    end
    local c_line = pattern_track.lines[c_line_idx]
    if not c_line then
      trace_log("Strange issue at line "
              ..tostring(c_line_idx)
              .." in pattern "..tostring(c_seq_idx)
              ..": Cannot retrieve line data. Plugin is going to throw an exception")
    end
    if has_note(c_line, track) then
      local position = position_key(c_seq_idx, c_line_idx)
      local line = { line = c_line, delta = c_delta + delta }
      lines[position] = line
      if (col_idx and is_note(c_line.note_columns[col_idx].note_value)) or not col_idx then return position, line end
    end
    c_line_idx = c_line_idx - 1
    c_delta    = c_delta    + 1
  until false
end

-- Forward search for notes which might be part of an interval considering our current position
local function look_forward(lines, pattern_track, track, track_idx, position, col_idx, delta)
  local song       = renoise.song()
  local c_seq_idx  = position.sequence
  local c_line_idx = position.line + 1
  local c_delta    = 1
  delta = delta and delta or 0
  repeat
    local no_of_lines = song.patterns[song.sequencer.pattern_sequence[c_seq_idx]].number_of_lines
    local no_of_sequences = table.getn(song.sequencer.pattern_sequence)
    if c_line_idx > no_of_lines and c_seq_idx < no_of_sequences then
      c_seq_idx = c_seq_idx + 1
      local next_pattern = song.patterns[song.sequencer.pattern_sequence[c_seq_idx]]
      pattern_track = next_pattern.tracks[track_idx]
      c_line_idx = 1
    else
      if c_line_idx > no_of_lines or c_delta + delta > settings.max_delta.value then return nil, nil end
    end
    local c_line = pattern_track.lines[c_line_idx]
     if has_note(c_line, track) then
      local pos = position_key(c_seq_idx, c_line_idx)
      local line = { line = c_line, delta = c_delta + delta}
      lines[pos] = line
      if (col_idx and is_note(c_line.note_columns[col_idx].note_value)) or not col_idx then return pos, line end
    end
    c_line_idx = c_line_idx + 1
    c_delta    = c_delta    + 1
  until false
end

-- Just creates a sorted hash set
local function ordered_line_pairs(t)
  local keys = {}
  for k in pairs(t) do keys[#keys + 1] = k end
  table.sort(keys, function(a, b)
    if     a.sequence < b.sequence then return true
    elseif a.sequence > b.sequence then return false
    else                                return a.line < b.line
    end
  end)
  local i = 0
  return function()
    i = i + 1
    if keys[i] then return keys[i], t[keys[i]] end
  end
end

-- Just counts the number of keys in a table
local function count_keys(tbl)
  local count = 0
  for _,_ in pairs(tbl) do count = count + 1 end
  return count
end

-- Get some details about what the search yielded so far
-- Basically used to check if a few lines of notes were missed in between, as first priority is to lookup intervals
local function line_statistics(tbl)
  local count = 0
  local first = position_key(math.huge, math.huge)
  local last  = position_key(-math.huge,-math.huge)
  for k, _ in pairs(tbl) do
    count = count + 1
    if first.sequence > k.sequence or (first.sequence == k.sequence and first.line > k.line) then first = k end
    if  last.sequence < k.sequence or ( last.sequence == k.sequence and  last.line < k.line) then last  = k end
  end
  return count, first, last
end

-- Find lines of notes which make up the interval, eventually find more lines of notes, if there is still space
-- left (determined by a configuration property which indicates the maximum number of lines to be displayed)
local function find_lines_of_interest(track, pattern_track, position)

  local lines_of_interest  = {}
  local lines              = {}
  local line               = pattern_track.lines[position.line]
  local no_of_note_columns = track.visible_note_columns
  local track_idx          = renoise.song().selected_track_index
  local this_line          = { line = line, delta = 0 }
  local ante, ante_line
  local post, post_line

  -- Make sure that for each note in a column at least one interval is found if any
  -- This might result in "missing" lines, but this is deliberately accepted
  for column = 1, no_of_note_columns do
    ante, ante_line = look_back   (lines, pattern_track, track, track_idx, position, column)
    post, post_line = look_forward(lines, pattern_track, track, track_idx, position, column)
    local this
    if is_note(line.note_columns[column].note_value) then this = position; lines[this] = this_line end
    if this and (ante or post) then lines_of_interest[this] = this_line end
    if ante and (this or post) then lines_of_interest[ante] = ante_line end
    if post and (ante or this) then lines_of_interest[post] = post_line end
  end

  -- Add additional lines, if there's still space left to display more lines
  local flag = false
  local ante_delta = 0
  local post_delta = 0
  ante = position
  post = position
  repeat
    local no_of_lines = count_keys(lines_of_interest)
    if no_of_lines >= settings.max_lines.value then break end
    if not flag then
      if ante then
        ante, ante_line = look_back   (lines, pattern_track, track, track_idx, ante, nil, ante_delta)
        if ante then lines_of_interest[ante] = ante_line; ante_delta = ante_line.delta end
      end
      flag = true
    elseif flag then
      if post then
        post, post_line = look_forward(lines, pattern_track, track, track_idx, post, nil, post_delta)
        if post then lines_of_interest[post] = post_line; post_delta = post_line.delta end
      end
      flag = false
    end
    if not ante and not post then break end
  until false

  -- Determine how many lines there are in the same range of the lines of interest
  local _, first, last = line_statistics(lines_of_interest)
  local filtered_lines = {}
  local left_out_lines = {}
  for k, v in pairs(lines) do
    if (k.sequence > first.sequence or (k.sequence == first.sequence and k.line >= first.line)) and
       (k.sequence <  last.sequence or (k.sequence ==  last.sequence and k.line <=  last.line)) then
      filtered_lines[k] = v
    else
      left_out_lines[k] = v
    end
  end

  return count_keys(filtered_lines) == count_keys(lines_of_interest), lines_of_interest, left_out_lines
end

-- Check for empty columns in order to optimize UI
function empty_columns(lines_of_interest, no_of_note_columns)
  local column_empty  = {}
  local empty_columns = 0
  for col = 1, no_of_note_columns do
    local empty = true
    for _, v in ordered_line_pairs(lines_of_interest) do
      local note_column = v.line.note_columns[col]
      if is_note(note_column.note_value) then
        empty = false
      end
    end
    column_empty[col] = empty
    if empty then empty_columns = empty_columns + 1 end
  end
  return empty_columns, column_empty
end

--  ___  _  _ _ _    ___     _  _ ____ ___ ____ _ _  _
--  |__] |  | | |    |  \    |\/| |__|  |  |__/ |  \/
--  |__] |__| | |___ |__/    |  | |  |  |  |  \ | _/\_

-- Initial creation of the note matrix used as data source
function note_matrix(lines_of_interest, no_of_note_columns, left_out)
  local empty_columns, column_empty = empty_columns(lines_of_interest, no_of_note_columns)
  local min_delta = math.huge
  local notes  = {}
  local value  = {}
  local steps  = {}
  local volume = {}
  local gaps   = {}
  local marker = {}
  local i = 0
  local p
  for _, v in ordered_line_pairs(lines_of_interest) do
    i = i + 1
    local filtered_left_out = {}
    if i > 1 then
      for a, b in ipairs(left_out) do
        if (p.sequence < a.sequence or (p.sequence == a.sequence and p.line < a.line)) and
           (a.sequence < v.sequence or (v.sequence == a.sequence and a.line < v.line)) then
          table.insert(filtered_left_out, b)
        end
      end
    end
    p = v
    notes [i] = {}
    value [i] = {}
    volume[i] = {}
    steps [i] = {}
    gaps  [i] = {}
    local j = 0
    for col = 1, no_of_note_columns do
      if not column_empty[col] then
        j = j + 1
        local note_column = v.line.note_columns[col]
        notes [i][j] = note_column.note_string
        value [i][j] = note_column.note_value
        volume[i][j] = safe_volume(note_column.volume_value)
        steps [i][j] = v.delta
        if v.delta < min_delta then
          min_delta = v.delta
        end
        for _, b in ipairs(filtered_left_out) do
          if is_note(b.note_columns[col].note_value) then
            gaps[i][j] = true
          end
        end
      end
    end
  end
  for row = 1, #steps do
    marker[row] = {}
    for col = 1, no_of_note_columns do
      marker[row][col] = steps[row][col] == min_delta
    end
  end
  return {
    no_of_note_columns = no_of_note_columns - empty_columns,
    notes              = notes,
    value              = value,
    volume             = volume,
    steps              = steps,
    gaps               = gaps,
    marker             = marker
  }
end

-- Calculate intervals between successive notes
function vertical_intervals(data)
    local interval           = data.interval
    local value              = data.value
    local volume             = data.volume
    local gaps               = data.gaps
    local no_of_note_columns = data.no_of_note_columns
    for row = 1, #value - 1 do
        interval[row] = {}
        for col = 1, no_of_note_columns do
            local note1 = value[row    ][col]
            local note2 = value[row + 1][col]
            if is_note(note1) and is_note(note2) and not gaps[row + 1][col] then
                interval[row][col * 2] = new_interval(note1, note2, volume[row][col], volume[row + 1][col])
            elseif is_note(note2) and not is_note(note1) and row > 1 and not gaps[row +1][col] then
                local note0
                local volume0
                for b = row - 1, 1, -1 do
                    note0 = (is_note(value[b][col]) and not gaps[b][col]) and value[b][col] or nil
                    volume0 = volume[b][col]
                    if note0 then break end
                end
                if is_note(note0) then
                    interval[row][col * 2] = new_interval(note0, note2, volume0, volume[row + 1][col])
                end
            end
        end
    end
end

-- Calculate intervals between dyads of a chord
function horizontal_intervals(data)
    local interval           = data.interval
    local value              = data.value
    local volume             = data.volume
    local no_of_note_columns = data.no_of_note_columns
    for row = 1, #value do
        if not interval[row] then
            interval[row] = {}
        end
        for col = 1, no_of_note_columns - 1 do
            local note1 = value[row][col]
            local note2 = value[row][col + 1]
            if is_note(note1) and is_note(note2) then
                interval[row][col * 2 + 1] = new_interval(note1, note2, volume[row][col], volume[row][col + 1])
            elseif is_note(note2) and not is_note(note1) and col > 1 then
                local note0, volume0
                for b = col - 1, 1, -1 do
                    note0 = is_note(value[row][b]) and value[row][b] or nil
                    volume0 = volume[b][col]
                    if note0 then break end
                end
                if is_note(note0) then
                    interval[row][col * 2 + 1] = new_interval(note0, note2, volume0, volume[row][col + 1])
                end
            end
        end
    end
end

-- This function considers the chord as a whole, in contrast to the functions above, which are only
-- about dyads viewed independently of each other. In addition to the actual chord, the function
-- searches for reverberating notes, but only if no lines were omitted previously. Currently, the
-- function does not consider "OFF" notes
function whole_chord(data, complete)
  local interval           = data.interval
  local value              = data.value
  local volume             = data.volume
  local steps              = data.steps
  local no_of_note_columns = data.no_of_note_columns
  local chord_linger       = {}
  local chord_actual       = {}
  for row = 1, #value do
    chord_actual[row] = {}
    chord_linger[row] = {}
    for col = 1, no_of_note_columns do
      local delta = 0
      for search_row = row, 1, -1 do
        local note = value[search_row][col]
        if row ~= search_row then
          delta = delta + steps[search_row][col]
        end
        if is_note(note) then
          local actual_volume = safe_volume(volume[search_row][col])
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

    local add_volume_percentage = function(t)
        local v = {}
        for i, e in ipairs(t) do v[i] = e.volume end
        v = { volume_percentage(unpack(v)) }
        for i, e in ipairs(v) do t[i].volume_percentage = e end
    end

    -- Do not consider lingering chords if we haven't got a full set of notes
    -- in order to avoid invalid values at the top of the interval matrix
    if #chord_linger[row] < no_of_note_columns then
        chord_linger[row] = {}
    else
        add_volume_percentage(chord_linger[row])
    end
    add_volume_percentage(chord_actual[row])
    if not interval[row] then
      interval[row] = {}
    end
    interval[row][no_of_note_columns * 2 + 1] = dissect_chord_wrapper(unpack(chord_actual[row]))
    -- Lingering chord dissonance only makes sense if no lines were omitted
    if complete then interval[row][no_of_note_columns * 2 + 2] = dissect_chord_wrapper(unpack(chord_linger[row]))
    else             interval[row][no_of_note_columns * 2 + 2] = nil
    end
  end
end

--  ____ ____ _  _ _  _ ___ ____ ____ ___  ____ _ _  _ ___
--  |    |  | |  | |\ |  |  |___ |__/ |__] |  | | |\ |  |
--  |___ |__| |__| | \|  |  |___ |  \ |    |__| | | \|  |

-- Check for some violations according to the counterpoint (Kontrapunkt) system
function counterpoint_warnings(data)
    local interval           = data.interval
    local no_of_note_columns = data.no_of_note_columns
    local fifths             = {}
    local fourths            = {}
    local octaves            = {}
    local violations         = ""
    for row = 1, #interval do
        local has_fifth  = false
        local has_fourth = false
        local has_octave = false
        for col = 1, no_of_note_columns * 2 do
            local t = interval[row][col]
            if type(t) == 'table' then
                if t.interval ==  5 then has_fourth = true end
                if t.interval ==  7 then has_fifth  = true end
                if t.interval == 12 then has_octave = true end
            end
        end
        fourths[row] = has_fourth
        fifths [row] = has_fifth
        octaves[row] = has_octave
    end
    for row = 2, #interval do
        if fifths [row] and fifths [row - 1] then violations = violations.."5-5 "   end
        if octaves[row] and octaves[row - 1] then violations = violations.."12-12 " end
    end
    for row = 3, #interval do
        if fifths[row] and fourths[row - 1] and fifths[row - 2] then violations = violations.."5-4-5 " end
    end
    if violations ~= "" then
        data.counterpoint = { code = COUNTERPOINT_PATTERN_VIOLATION, details = violations }
    end
end

--  _  _ ____ _ _  _
--  |\/| |__| | |\ |
--  |  | |  | | | \|
--

function calculate_intervals()

  trace_log("-------------------------------------------------------------------------------------------------------------------------------------")
  trace_log("--   _____ __   _ _______ _______  ______ _    _ _______             _______ __   _ _______        __   __ _______ _____ _______")
  trace_log("--     |   | \\  |    |    |______ |_____/  \\  /  |_____| |           |_____| | \\  | |_____| |        \\_/   |______   |   |______")
  trace_log("--   __|__ |  \\_|    |    |______ |    \\_   \\/   |     | |_____      |     | |  \\_| |     | |_____    |    ______| __|__ ______|")
  trace_log("--")
  trace_log("--   _______ _______ _______  ______ _______ _______ ______")
  trace_log("--   |______    |    |_____| |_____/    |    |______ |     \\")
  trace_log("--   ______|    |    |     | |    \\_    |    |______ |_____/")
  trace_log("--")
  trace_log("--  At "..os.date("!%Y-%m-%dT%TZ"))
  trace_log("--")
  trace_log("-------------------------------------------------------------------------------------------------------------------------------------")

  local vb                 = renoise.ViewBuilder()
  local song               = renoise.song()
  local status             = { status = STATUS_OK, color = COLOR_DEFAULT }
  local sequence_index     = song.selected_sequence_index
  local pattern_index      = song.sequencer.pattern_sequence[sequence_index]
  local track_index        = song.selected_track_index
  local pattern_track      = song.patterns[pattern_index].tracks[track_index]
  local line_index         = song.transport.edit_pos.line
  local track              = song.tracks[track_index]
  local no_of_note_columns = track.visible_note_columns
  local position           = position_key(sequence_index, line_index)

  local complete, lines, left_out = find_lines_of_interest(track, pattern_track, position)
  if not complete then
    status = { status = STATUS_LINES_OMITTED, color = COLOR_STATUS_WARNING }
  end

  local data = note_matrix(lines, no_of_note_columns, left_out)

  data.interval         = {}
  data.counterpoint     = {}
  data.status           = status

  if data.no_of_note_columns < 1 then
    renoise.app():show_message("No notes found")
    return
  end

  vertical_intervals  (data)
  horizontal_intervals(data)
  whole_chord         (data, complete)
  if complete then counterpoint_warnings(data) end

  local dialog_content = create_view(vb, settings, data)
  local control_dialog = renoise.app():show_custom_dialog("Interval Analysis", dialog_content)
  update_interface(vb, settings, data)
end

