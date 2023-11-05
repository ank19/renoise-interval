require 'settings'
require 'maths'
require 'common'


-- For each tuning a method xxx_interval is provided, having a signature (note1, note2, interval, octaves), despite
-- the fact that not each tuning might require all arguments, e.g. for pure intervals the actual notes are irrelevant.

--  ___  _   _ ___ _  _ ____ ____ ____ ____ ____ ____ _  _
--  |__]  \_/   |  |__| |__| | __ |  | |__/ |___ |__| |\ |
--  |      |    |  |  | |  | |__] |__| |  \ |___ |  | | \|

local pythagorean_frequencies_weak = setmetatable({}, { __mode = "k" })

-- Create frequency table for Pythagorean tuning on reference octave
-- Takes tuning note and pitch into account
-- Algorithm as outlined on https://en.wikipedia.org/wiki/Pythagorean_tuning
function pythagorean_frequencies()
    local cache_key = cache_key(settings.pitch.value, settings.tuning_note.value)
    local cached = pythagorean_frequencies_weak[cache_key]
    if cached then
        trace_log("Returning cached Pythagorean frequencies")
        return cached
    end
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
    pythagorean_frequencies_weak[cache_key] = frequencies
    return frequencies
end

-- Use the frequency set for the reference octave to calculate a specific note frequency
function pythagorean_frequency(note)
    local mod = math.floor(math.abs(note) / 12) - 4
    local frequencies = pythagorean_frequencies()
    local base = frequencies[note % 12 + 1]
    local frequency = base * (mod >= 4 and 2 ^ (mod - 4) or (1 / (2 ^ (0 - mod))))
    trace_log("Calculated frequency "..frequency.."Hz for note "..note.." in Pythagorean with "..settings.pitch.value.."Hz pitch, octave modifier was "..mod)
    return frequency
end

-- Calculate interval properties
function pythagorean_interval(note1, note2, interval, octaves)
    trace_log("Calculating interval data from "..note1.." to "..note2.." in Pythagorean temperament");
    local f1, f2 = pythagorean_frequency(note1), pythagorean_frequency(note2)
    f1, f2 =  math.max(f1, f2), math.min(f1, f2)
    local p = round(f1, 2) / round(f2, 2)
    local cents = ((note2 - note1) % 12 == 0) and (1200 * octaves)  -- Avoid rounding issues for whole octaves
                  or (1200 * math.log(p) / math.log(2))
    local a, b = approximate_rational(p, math.huge, settings.hearing_threshold.value)
    if not a or not b then a, b = reduce_fraction(round(f1, 0), round(f2, 0)) end
    return a, b, cents, p, f1, f2
end

--  ____ ____ _  _ ____ _       ___ ____ _  _ ___  ____ ____ ____ _  _ ____ _  _ ___
--  |___ |  | |  | |__| |        |  |___ |\/| |__] |___ |__/ |__| |\/| |___ |\ |  |
--  |___ |_\| |__| |  | |___     |  |___ |  | |    |___ |  \ |  | |  | |___ | \|  |

-- Calculate a specific note frequency based on the pitch setting
function equal_frequency(note)
    -- Pitch node in renoise shifted by +8 (instead of 49)
    -- https://en.wikipedia.org/wiki/12_equal_temperament
    local frequency = settings.pitch.value * ((2 ^ (1 / 12)) ^ (note - 57))
    trace_log("Calculated frequency "..frequency.."Hz for note "..note.." in equal temperament with "..settings.pitch.value.."Hz pitch")
    return frequency
end

-- Calculate interval properties
function equal_interval(note1, note2, interval, octaves)
    local f1, f2 = equal_frequency(note1), equal_frequency(note2)
    f1, f2 =  math.max(f1, f2), math.min(f1, f2)
    local p = round(f1, 2) / round(f2, 2)
    local cents = math.abs(note2 - note1) * 100
    local a, b = approximate_rational(p, math.huge, settings.hearing_threshold.value)
    if not a or not b then a, b = reduce_fraction(round(f1, 0), round(f2, 0)) end
    return a, b, cents, p, f1, f2
end

--  ___  _  _ ____ ____    _ _  _ ___ ____ ____ _  _ ____ _    ____
--  |__] |  | |__/ |___    | |\ |  |  |___ |__/ |  | |__| |    [__
--  |    |__| |  \ |___    | | \|  |  |___ |  \  \/  |  | |___ ___]

-- Calculate interval properties
function pure_interval(note1, note2, interval, octaves)
    local a, b = unpack(PURE_INTERVALS[interval + 1])
    local cents = 1200 * (octaves + math.log(a / b) / math.log(2))
    return a, b, cents, nil, nil, nil
end

--  ___ _  _ _  _ _ _  _ ____    _    _ ____ ___
--   |  |  | |\ | | |\ | | __    |    | [__   |
--   |  |__| | \| | | \| |__]    |___ | ___]  |

TUNING = {
    pure_interval,
    equal_interval,
    pythagorean_interval
}
