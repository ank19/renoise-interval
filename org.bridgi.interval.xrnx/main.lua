require 'interface'
require 'language'
require 'common'

renoise.tool():add_menu_entry { name   = "Main Menu:Tools:Bridgi:Interval Calculator",
                                invoke = function() calculate_intervals() end }

renoise.tool():add_keybinding { name   = "Global:Tools:Interval Calculator",
                                invoke = function() calculate_intervals() end }
--  ____ ____ ___ ___ _ _  _ ____ ____
--  [__  |___  |   |  | |\ | | __ [__
--  ___] |___  |   |  | | \| |__] ___]

local settings = renoise.Document.create("IntervalCalculatorSettings") { view_type              =   1,
                                                                         language               = "de",
                                                                         max_delta              =  30,
                                                                         max_lines              =   8,
                                                                         dissonance_threshold_1 =   3.5,
                                                                         dissonance_threshold_2 =   6.5,
                                                                         dissonance_threshold_3 =  11.0,
                                                                         hearing_threshold      =   0.004,
                                                                         tuning                 =   1,
                                                                         tuning_note            =   3,
                                                                         pitch                  = 440,
                                                                         volume_reduction       =   0.20}
--  ____ ____ ___ _ ____ _  _ ____ _       ____ ___  ___  ____ ____ _  _ _ _  _ ____ ___ _ ____ _  _
--  |__/ |__|  |  | |  | |\ | |__| |       |__| |__] |__] |__/ |  |  \/  | |\/| |__|  |  | |  | |\ |
--  |  \ |  |  |  | |__| | \| |  | |___    |  | |    |    |  \ |__| _/\_ | |  | |  |  |  | |__| | \|

-- Approximate fraction algorithm from
--   Harmony Perception by Periodicity Detection
--   Article in Journal of Mathematics and Music ?? June 2013
--   DOI: 10.1080/17459737.2015.1033024
--   Frieder Stolzenburg
local function approximate_irrational(irrational, max)
  local m = max and max or math.huge
  local p = settings.hearing_threshold.value
  local x = irrational
  local x1 = (1 - p) * x
  local x2 = (1 + p) * x
  local al = math.floor(x)
  local bl = 1
  local l = al / bl
  if x1 <= l and l <= x2  then
    return { al, bl }
  end
  local ar = al + 1
  local br = 1
  local r = ar / br
  if x1 <= r and r <= x2  then
    return { ar, br }
  end
  repeat
    local am = al + ar
    local bm = bl + br
    if am > m or bm > m then
      error_log("Not able to approximate interval for ".. irrational
              .." with hearing threshold "..tostring(p)
              .." and numerator and denominator limit ".. m)
      return { 0, 0 }
    end
    local ambm = am / bm
    if x1 <= ambm and ambm <= x2 then
      trace_log("Approximated interval ".. irrational
              .." with hearing threshold "..tostring(p)
              .." to "..tostring(am).."/"..tostring(bm))

      return { am, bm }
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
local function approximate_rational(a, b, max)
  return approximate_irrational(a / b, max)
end

local function fallback_frequency(frequency1, frequency2)
  local a = round(math.max(frequency1, frequency2),  0)
  local b = round(math.min(frequency1, frequency2),  0)
  local gcd = greatest_common_divisor(a, b)
  a = a / gcd
  b = b / gcd
  return a, b
end

--  ___  _   _ ___ _  _ ____ ____ ____ ____ ____ ____ _  _
--  |__]  \_/   |  |__| |__| | __ |  | |__/ |___ |__| |\ |
--  |      |    |  |  | |  | |__] |__| |  \ |___ |  | | \|

-- Create frequency table for Pythagorean tuning on reference octave
-- Takes tuning note and pitch into account
-- Algorithm as outlined on https://en.wikipedia.org/wiki/Pythagorean_tuning
local function pythagorean_frequencies()
  local cycle_of_fifths = CYCLE_OF_FIFTHS[settings.tuning_note.value]
  -- Get index of a' (in renoise A4 = 57 = 4 * 12 + 9)
  local pitch_note_i
  for i, n in ipairs(cycle_of_fifths) do
    if n == 9 then -- Kammerton a' == 9
      pitch_note_i = i
    end
  end
  local fifths = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }
  fifths[pitch_note_i] = settings.pitch.value
  if pitch_note_i >  1 then for i = pitch_note_i - 1,  1, -1 do fifths[i] = fifths[i + 1] * (2 / 3) end end
  if pitch_note_i < 12 then for i = pitch_note_i + 1, 12,  1 do fifths[i] = fifths[i - 1] * (3 / 2) end end
  local log = ""
  for _, v in ipairs(fifths) do log = log .. v .. " " end
  trace_log("Frequencies (unadjusted, circle): "..log)
  local frequencies = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }
  for i, n in ipairs(cycle_of_fifths) do
    frequencies[n + 1] = fifths[i]
  end
  log = ""
  for _, v in ipairs(frequencies) do log = log .. v .. " " end
  trace_log("Frequencies (unadjusted, increasing): "..log)
  trace_log("Adjusting frequencies left of a'")
  for j = 9, 1, -1 do
    while frequencies[j + 1] / frequencies[j] > 2.0 do frequencies[j] = frequencies[j] * 2 end
    while frequencies[j + 1] / frequencies[j] < 1.0 do frequencies[j] = frequencies[j] / 2 end
  end
  trace_log("Adjusting frequencies right of a'")
  for j = 11, 12, 1 do
    while frequencies[j] / frequencies[j - 1] < 1.0 do frequencies[j] = frequencies[j] * 2 end
    while frequencies[j] / frequencies[j - 1] > 2.0 do frequencies[j] = frequencies[j] / 2 end
  end
  log = ""
  for _, v in ipairs(frequencies) do log = log .. v .. " " end
  trace_log("Frequencies (adjusted): "..log)
  return frequencies
end

-- Use the frequency set for the reference octave to calculate a specific note frequency
local function pythagorean_frequency(frequencies, note)
  trace_log("Calculating Pythagorean frequency for note "..note)
  local octave_mod = math.floor(math.abs(note) / 12) - 4
  local base = frequencies[note % 12 + 1]
  trace_log("  Octave modifier is ".. octave_mod ..", base frequency is "..base)
  local frequency = base * (octave_mod >= 4 and 2 ^ (octave_mod - 4) or (1 / (2 ^ (0 - octave_mod))))
  trace_log("  Final frequency is "..frequency.." based on "..settings.pitch.value)
  return frequency
end

-- Calculate interval properties
local function pythagorean_interval(note1, note2, interval, octaves, volume)
  trace_log("Calculating interval data from "..note1.." to "..note2.." in Pythagorean temperament");
  local frequencies = pythagorean_frequencies()
  local frequency1 = round(pythagorean_frequency(frequencies, note1), 2)
  local frequency2 = round(pythagorean_frequency(frequencies, note2), 2)
  local p = math.max(frequency1, frequency2) / math.min(frequency1, frequency2)
  local cents = ((note2 - note1) % 12 == 0) and (1200 * octaves)  -- Avoid rounding issues for whole octaves
                or (1200 * math.log(p) / math.log(2))
  local a, b = unpack(approximate_irrational(p))
  if not a or not b then
    trace_log("    Cannot approximate irrational for interval no. "..tostring(interval + 1)..": "..p.."; using frequency ratio to it's shortest terms")
    a, b = fallback_frequency(frequency1, frequency2)
  end
  local dissonance = math.sqrt(2) ^ octaves * ((a * b) ^ volume)
  return a, b, cents, p, frequency1, frequency2, dissonance
end

--  ____ ____ _  _ ____ _       ___ ____ _  _ ___  ____ ____ ____ _  _ ____ _  _ ___
--  |___ |  | |  | |__| |        |  |___ |\/| |__] |___ |__/ |__| |\/| |___ |\ |  |
--  |___ |_\| |__| |  | |___     |  |___ |  | |    |___ |  \ |  | |  | |___ | \|  |

-- Calculate a specific note frequency based on the pitch setting
local function equal_frequency(note)
  trace_log("Calculating equal temperament frequency for note "..note)
  -- Pitch node in renoise shifted by +8 (instead of 49)
  -- https://en.wikipedia.org/wiki/12_equal_temperament
  local frequency = settings.pitch.value * ((2 ^ (1 / 12)) ^ (note - 57))
  trace_log("  Final frequency is "..frequency.." based on "..settings.pitch.value)
  return frequency
end

-- Calculate interval properties
local function equal_interval(note1, note2, interval, octaves, volume)
  trace_log("Calculating interval data from "..note1.." to "..note2.." in equal temperament");
  local frequency1 = round(equal_frequency(note1),2)
  local frequency2 = round(equal_frequency(note2),2)
  local p          = math.max(frequency1, frequency2) / math.min(frequency1, frequency2)
  local cents      = math.abs(note2 - note1) * 100
  local a, b       = unpack(approximate_irrational(p))
  if not a or not b then
    trace_log("    Cannot approximate irrational for interval no. "..tostring(interval + 1)..": "..p.."; using frequency ratio to it's shortest terms")
    a, b = fallback_frequency(frequency1, frequency2)
  end
  local dissonance = math.sqrt(2) ^ octaves * ((a * b) ^ volume)
  return a, b, cents, p, frequency1, frequency2, dissonance
end

--  ___  _  _ ____ ____    _ _  _ ___ ____ ____ _  _ ____ _    ____
--  |__] |  | |__/ |___    | |\ |  |  |___ |__/ |  | |__| |    [__
--  |    |__| |  \ |___    | | \|  |  |___ |  \  \/  |  | |___ ___]

-- Calculate interval properties
local function pure_interval(note1, note2, interval, octaves, volume)
  trace_log("Calculating interval data from "..note1.." to "..note2.." in pure intervals");
  local a, b       = unpack(PURE_INTERVALS[interval + 1])
  local cents      = 1200 * (octaves + math.log(a / b) / math.log(2))
  trace_log("Using constant interval ratio "..a.."/"..b.." (pure intervals)");
  local dissonance = math.sqrt(2) ^ octaves * ((a * b) ^ volume)
  return a, b, cents, nil, nil, nil, dissonance
end

--  ____ ____ _  _ ____ ____ _ ____    _ _  _ ___ ____ ____ _  _ ____ _       ____ _  _ _  _ ____ ___ _ ____ _  _ ____
--  | __ |___ |\ | |___ |__/ | |       | |\ |  |  |___ |__/ |  | |__| |       |___ |  | |\ | |     |  | |  | |\ | [__
--  |__] |___ | \| |___ |  \ | |___    | | \|  |  |___ |  \  \/  |  | |___    |    |__| | \| |___  |  | |__| | \| ___]

-- Calculate basic interval properties
local function interval_properties(note1, note2, volume1, volume2)
  local halftones = note2 - note1
  local delta     = math.abs(halftones)
  local octaves   = math.floor(math.abs(halftones) / 12)
  local interval  = delta % 12
  local t1, t2    = unpack(add_volume_percentage({ volume = volume1 }, { volume = volume2 }))
  local volume    = math.min(t1.volume_percentage, t2.volume_percentage) -- The reasoning here is that the note having
                                                                         -- the higher volume can be considered as prime
                                                                         -- anyhow and therefore can be discarded as
                                                                         -- the dissonance then resolves to one
  if note1 ~= note2 and interval == 0 then
    interval = 12
  end
  local display_interval = interval -- Additional intervals Ninth...Fifteenth
  if delta >= 13 and delta <= 24 then
    display_interval = delta
  end
  return interval, function()
    local f
    if     settings.tuning.value == 3 then f = pythagorean_interval
    elseif settings.tuning.value == 2 then f = equal_interval
    elseif settings.tuning.value == 1 then f = pure_interval
    end
    local a, b, cents, p, frequency1, frequency2, dissonance = f(note1, note2, interval, octaves, volume)
    return interval, halftones, octaves * ((halftones < 0 and -1) or 1), display_interval,
           a, b, cents, p, frequency1, frequency2, dissonance
  end
end

--  ____ _  _ ____ ____ ___     ___  _ ____ ____ ____ _  _ ____ _  _ ____ ____
--  |    |__| |  | |__/ |  \    |  \ | [__  [__  |  | |\ | |__| |\ | |    |___
--  |___ |  | |__| |  \ |__/    |__/ | ___] ___] |__| | \| |  | | \| |___ |___


-- Calculate dissonance for a chord with notes having the same level of volume
-- The calculation is (a1 * ... * an * b1 * ... * bn) ^ ( (1 / n ) * volume percentage distributed on two-tones)
-- where n is the number of intervals and a/ b the frequency ratios to lowest terms
local function chord_dissonance(volume, ...)
  if not arg or arg.n == 0 then
    return nil
  end
  trace_log("Calculating chord dissonance for "..arg.n.." notes and volume "..tostring(volume))
  local intervals = {}
  for i1, _ in ipairs(arg) do
    for i2, _ in ipairs(arg) do
      if i2 > i1 then -- Calculate ratio between note at index i1 and note at index i2
        local overall_ratio = { 1, 1 }
        for i3 = i1 + 1, i2 do
          local _, wrapper = interval_properties(arg[i3].note, arg[i3 - 1].note, volume, volume)
          local _, _, _, _, a, b, _, _, _, _, _ = wrapper()
          overall_ratio[1] = overall_ratio[1] * a
          overall_ratio[2] = overall_ratio[2] * b
        end
        -- Shorten fractions to it's lowest terms
        local gcd = greatest_common_divisor(overall_ratio[1], overall_ratio[2])
        overall_ratio[1] = overall_ratio[1] / gcd
        overall_ratio[2] = overall_ratio[2] / gcd
        table.insert(intervals, overall_ratio)
      end
    end
  end
  local dissonance = 1
  for _, interval in ipairs(intervals) do
    dissonance = dissonance * interval[1] * interval[2]
  end
  return dissonance ^ (volume / (arg.n - 1))
end

-- Calculate dissonance for a chord with notes not necessarily having the same volume
-- Basically the chord is dissected into chords having the same level of volume, again using the function above.
local function dissect_chord(depth, ...)
  if not arg or arg.n == 0 then
    return nil
  end
  if not depth then
    depth = 1
  end
  local filtered    = {}
  local volume_only = {}
  local tmp_trace   = ""
  for _, a in ipairs(arg) do
    if a.volume_percentage > 0 then table.insert(filtered   , a       )
                                    table.insert(volume_only, a.volume_percentage)
                                    tmp_trace = tmp_trace.." "..tostring(a.note).."("..tostring(a.volume_percentage)..") "
    end
  end
  trace_log("There are "..#filtered.." notes left after filtering")
  if #filtered <= 1 then
    return 1 -- Return a dissonance value of one in case if only one note is left
  end
  trace_log("Calculating chord dissonance for "..tmp_trace)
  local min_volume = math.min(unpack(volume_only))
  local partial    = {}
  local rest       = {}
  for _, a in ipairs(filtered) do
    table.insert(partial, { note = a.note, delta = a.delta })
    table.insert(rest   , { note = a.note, delta = a.delta,
                                     volume_percentage = a.volume_percentage - min_volume})
  end
  trace_log("Found "..#partial.." notes with volume level "..min_volume..", which leaves "..#rest.." notes")
  return chord_dissonance(min_volume, unpack(partial)) * dissect_chord(depth + 1, unpack(rest))
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
  local notes  = {}
  local value  = {}
  local steps  = {}
  local volume = {}
  local gaps   = {}
  local i      = 0
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
        for _, b in ipairs(filtered_left_out) do
          if is_note(b.note_columns[col].note_value) then
            gaps[i][j] = true
          end
        end
      end
    end
  end
  return no_of_note_columns - empty_columns, notes, value, volume, steps, gaps
end

-- Calculate intervals between successive notes
function vertical_intervals(data)
  local interval           = data.interval
  local interval_data      = data.interval_data
  local value              = data.value
  local volume             = data.volume
  local gaps               = data.gaps
  local no_of_note_columns = data.no_of_note_columns
  for row = 1, #value - 1 do
    interval     [row] = {}
    interval_data[row] = {}
    for col = 1, no_of_note_columns do
      local note1 = value[row    ][col]
      local note2 = value[row + 1][col]
      if is_note(note1) and is_note(note2) and not gaps[row + 1][col] then
        interval     [row][col * 2],
        interval_data[row][col * 2] = interval_properties(note1, note2, volume[row][col], volume[row + 1][col])
      elseif is_note(note2) and not is_note(note1) and row > 1 and not gaps[row +1][col] then
        local note0
        local volume0
        for b = row - 1, 1, -1 do
          note0 = (is_note(value[b][col]) and not gaps[b][col]) and value[b][col] or nil
          volume0 = volume[b][col]
          if note0 then break end
        end
        if is_note(note0) then
          interval     [row][col * 2],
          interval_data[row][col * 2] = interval_properties(note0, note2, volume0, volume[row + 1][col])
        end
      end
    end
  end
end

-- Calculate intervals between two-tones of a chord
function horizontal_intervals(data)
  local interval           = data.interval
  local interval_data      = data.interval_data
  local value              = data.value
  local volume             = data.volume
  local no_of_note_columns = data.no_of_note_columns
  for row = 1, #value do
    if not interval     [row] then interval     [row] = {} end
    if not interval_data[row] then interval_data[row] = {} end
    for col = 1, no_of_note_columns - 1 do
      local note1 = value[row][col]
      local note2 = value[row][col + 1]
      if is_note(note1) and is_note(note2) then
        interval     [row][col * 2 + 1],
        interval_data[row][col * 2 + 1] = interval_properties(note1, note2, volume[row][col], volume[row][col + 1])
      elseif is_note(note2) and not is_note(note1) and col > 1 then
        local note0, volume0
        for b = col - 1, 1, -1 do
          note0 = is_note(value[row][b]) and value[row][b] or nil
          volume0 = volume[b][col]
          if note0 then break end
        end
        if is_note(note0) then
          interval     [row][col * 2 + 1],
          interval_data[row][col * 2 + 1] = interval_properties(note0, note2, volume0, volume[row][col + 1])
        end
      end
    end
  end
end

-- This function considers the chord as a whole, in contrast to the functions above, which are only
-- about two-tones viewed independently of each other. In addition to the actual chord, the function
-- searches for reverberating notes, but only if no lines were omitted previously. Currently, the
-- function does not consider "OFF" notes
function whole_chord(data, complete)
  local interval_data      = data.interval_data
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
    -- Do not consider lingering chords if we haven't got a full set of notes
    -- in order to avoid invalid values at the top of the interval matrix
    if #chord_linger[row] < no_of_note_columns then chord_linger[row] = {}
    else chord_linger[row] = add_volume_percentage(unpack(chord_linger[row]))
    end
    chord_actual[row] = add_volume_percentage(unpack(chord_actual[row]))
    if not interval_data[row] then
      interval_data[row] = {}
    end
    interval_data[row][no_of_note_columns * 2 + 1] = dissect_chord(1, unpack(chord_actual[row]))
    -- Lingering chord dissonance only makes sense if no lines were omitted
    if complete then interval_data[row][no_of_note_columns * 2 + 2] = dissect_chord(1, unpack(chord_linger[row]))
    else             interval_data[row][no_of_note_columns * 2 + 2] = nil
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
    for col = 1, no_of_note_columns do
      if interval[row][col] then
        if interval[row][col] ==  5 then has_fourth = true end
        if interval[row][col] ==  7 then has_fifth  = true end
        if interval[row][col] == 12 then has_octave = true end
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
  local data               = {}

  local complete, lines, left_out = find_lines_of_interest(track, pattern_track, position)
  if not complete then
    status = { status = STATUS_LINES_OMITTED, color = COLOR_STATUS_WARNING }
  end

  data.interval        = {}
  data.interval_data   = {}
  data.counterpoint    = {}
  data.status          = status

  data.no_of_note_columns, data.notes, data.value, data.volume, data.steps, data.gaps = note_matrix(lines, no_of_note_columns, left_out)

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
