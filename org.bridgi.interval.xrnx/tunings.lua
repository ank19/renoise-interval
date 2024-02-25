require 'settings'
require 'maths'
require 'common'

-- For each tuning a method xxx_interval is provided, having a signature (note1, note2, interval, octaves), despite
-- the fact that not each tuning might require all arguments, e.g. for pure intervals the actual notes are irrelevant.

--  ____ ____ _  _ _  _ ____ _  _    ___ _  _ _  _ _ _  _ ____    ____ _  _ _  _ ____ ___ _ ____ _  _ ____
--  |    |  | |\/| |\/| |  | |\ |     |  |  | |\ | | |\ | | __    |___ |  | |\ | |     |  | |  | |\ | [__
--  |___ |__| |  | |  | |__| | \|     |  |__| | \| | | \| |__]    |    |__| | \| |___  |  | |__| | \| ___]
--

-- Create frequency table for well tempered tunings on reference octave, takes tuning note and pitch into account
function reference_frequencies(commas, fractions)
    local cycle_of_fifths = CYCLE_OF_FIFTHS[settings.tuning_note.value]
    local pitch_index = REFERENCE_NOTE_CYCLE_INDEX[settings.tuning_note.value]
    local fifths = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }
    fifths[pitch_index] = settings.pitch.value
    local fifth_ratio = function (i) return ((3 / 2) * commas[i] ^ fractions[i]) end
    if pitch_index >  1 then for i = pitch_index - 1,  1, -1 do fifths[i] = fifths[i + 1] * 1 / fifth_ratio(i) end end
    if pitch_index < 12 then for i = pitch_index + 1, 12,  1 do fifths[i] = fifths[i - 1] * fifth_ratio(i - 1) end end
    local frequencies = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }
    for i, n in ipairs(cycle_of_fifths) do frequencies[n + 1] = fifths[i] end
    for j = 9, 1, -1 do
        while frequencies[j + 1] / frequencies[j] > 2.0 do frequencies[j] = frequencies[j] * 2 end
        while frequencies[j + 1] / frequencies[j] < 1.0 do frequencies[j] = frequencies[j] / 2 end
    end
    for j = 11, 12, 1 do
        while frequencies[j] / frequencies[j - 1] < 1.0 do frequencies[j] = frequencies[j] * 2 end
        while frequencies[j] / frequencies[j - 1] > 2.0 do frequencies[j] = frequencies[j] / 2 end
    end
    return frequencies
end

function cached_frequencies(cache, commas, fractions)
    local cache_key = cache_key(settings.pitch.value, settings.tuning_note.value)
    local frequencies = cache[cache_key]
    if frequencies then
        return frequencies
    end
    frequencies = reference_frequencies(commas, fractions)
    cache[cache_key] = frequencies
    return frequencies
end

function frequency(note, reference_frequencies)
    local mod = math.floor(math.abs(note) / 12) - 4
    return reference_frequencies[note % 12 + 1] * (mod >= 4 and 2 ^ (mod - 4) or (1 / (2 ^ (0 - mod))))
end

-- Calculate interval properties
function well_tempered_interval(note1, note2, octaves, frequency_function)
    local f1, f2 = frequency_function(note1), frequency_function(note2)
    f1, f2 =  math.max(f1, f2), math.min(f1, f2)
    local p = round(f1, 2) / round(f2, 2)
    local cents = ((note2 - note1) % 12 == 0) and (1200 * octaves)  -- Avoid rounding issues for whole octaves
                  or (1200 * math.log(p) / math.log(2))
    local a, b = approximate_rational(p, math.huge, settings.hearing_threshold.value)
    if not a or not b then
        a, b = reduce_fraction(round(f1, 0), round(f2, 0))
    end
    return a, b, cents, p, f1, f2
end

--  ___  _   _ ___ _  _ ____ ____ ____ ____ ____ ____ _  _
--  |__]  \_/   |  |__| |__| | __ |  | |__/ |___ |__| |\ |
--  |      |    |  |  | |  | |__] |__| |  \ |___ |  | | \|

local pythagorean_frequencies_weak = setmetatable({}, { __mode = "k" })

-- Create frequency table for Pythagorean tuning on reference octave, takes tuning note and pitch into account
-- Algorithm as outlined on https://en.wikipedia.org/wiki/Pythagorean_tuning
function pythagorean_frequencies()
    return cached_frequencies(pythagorean_frequencies_weak,
            { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
            { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 })
end

-- Use the frequency set for the reference octave to calculate a specific note frequency
function pythagorean_frequency(note)
    return frequency(note, pythagorean_frequencies())
end

function pythagorean_interval(note1, note2, _, octaves)
    return well_tempered_interval(note1, note2, octaves, pythagorean_frequency)
end

--  _  _ _ ____ _  _ ___  ____ ____ ____ ____ ____    _ _ _
--  |_/  | |__/ |\ | |__] |___ |__/ | __ |___ |__/    | | |
--  | \_ | |  \ | \| |__] |___ |  \ |__] |___ |  \    | | |
--

-- Source: https://www.colinpykett.org.uk/handy-guide-to-choosing-temperaments.htm
--     Best suited: C maj, F maj, G maj, A# maj, E min
--     Reasonable:  D maj, D# maj, G# maj, C min, C# min, D min, D# min, F min, F# min, G min, G# min, A min, A# min, B min
--     Not suited:  C# maj, E maj, F# maj, A maj, B maj

local kirnberger3_frequencies_weak = setmetatable({}, { __mode = "k" })

function kirnberger3_frequencies()
    return cached_frequencies(kirnberger3_frequencies_weak,
            { 0, 0, 0, 0, 0, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, 0, 0, 0 },
            { 0, 0, 0, 0, 0, -1/4, -1/4, -1/4, -1/4, 0, 0, 0 })
end

function kirnberger3_frequency(note)
    return frequency(note, kirnberger3_frequencies())
end

function kirnberger3_interval(note1, note2, _, octaves)
    return well_tempered_interval(note1, note2, octaves, kirnberger3_frequency)
end

--  ____ _ _  _ ___ _  _    ____ ____ _  _ _  _ ____    _  _ ____ ____ _  _ ___ ____ _  _ ____
--  [__  |  \/   |  |__| __ |    |  | |\/| |\/| |__|    |\/| |___ |__| |\ |  |  |  | |\ | |___
--  ___] | _/\_  |  |  |    |___ |__| |  | |  | |  |    |  | |___ |  | | \|  |  |__| | \| |___
--

-- Source: https://www.colinpykett.org.uk/handy-guide-to-choosing-temperaments.htm
--     Best suited: C maj, D maj, F maj, G maj, A maj, A# maj, D min, G min, A min
--     Reasonable:  D# maj, E maj, C min, E min, F# min, B min
--     Not suited:  C# maj, F# maj, G# maj, D# min

local sixth_comma_frequencies_weak = setmetatable({}, { __mode = "k" })

function sixth_comma_frequencies()
    return cached_frequencies(sixth_comma_frequencies_weak,
            { SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA, SYNTONIC_COMMA },
            { -1/6, 5/6, -1/6, -1/6, -1/6, -1/6, -1/6, -1/6, -1/6, -1/6, -1/6, -1/6 })
end

function sixth_comma_frequency(note)
    return frequency(note, sixth_comma_frequencies())
end

function sixth_comma_interval(note1, note2, _, octaves)
    return well_tempered_interval(note1, note2, octaves, sixth_comma_frequency)
end

--  _ _ _ ____ ____ ____ _  _ _  _ ____ _ ____ ___ ____ ____    _ _ _
--  | | | |___ |__/ |    |_/  |\/| |___ | [__   |  |___ |__/    | | |
--  |_|_| |___ |  \ |___ | \_ |  | |___ | ___]  |  |___ |  \    | | |
--

-- Source: https://www.colinpykett.org.uk/handy-guide-to-choosing-temperaments.htm
--     Best suited: C maj, F maj, A# maj, E min, A min
--     Reasonable:  D maj, D# maj, E maj, G maj, G# maj, A maj, B maj, C# min, D min, D# min, F min, F# min, G min, G# min, A min, A# min, B min
--     Not suited:  C# maj, F# maj, C min

local werckmeister3_frequencies_weak = setmetatable({}, { __mode = "k" })

function werckmeister3_frequencies()
    return cached_frequencies(werckmeister3_frequencies_weak,
            { 0, 0, 0, 0, 0, PYTHAGOREAN_COMMA, PYTHAGOREAN_COMMA, PYTHAGOREAN_COMMA, 0, 0, PYTHAGOREAN_COMMA, 0 },
            { 0, 0, 0, 0, 0, -1/4, -1/4, -1/4, 0, 0, -1/4, 0 })
end

function werckmeister3_frequency(note)
    return frequency(note, werckmeister3_frequencies())
end

function werckmeister3_interval(note1, note2, _, octaves)
    return well_tempered_interval(note1, note2, octaves, werckmeister3_frequency)
end

--  ____ ____ _  _ ____ _       ___ ____ _  _ ___  ____ ____ ____ _  _ ____ _  _ ___
--  |___ |  | |  | |__| |        |  |___ |\/| |__] |___ |__/ |__| |\/| |___ |\ |  |
--  |___ |_\| |__| |  | |___     |  |___ |  | |    |___ |  \ |  | |  | |___ | \|  |

-- Calculate a specific note frequency based on the pitch setting
function equal_frequency(note)
    -- Pitch node in renoise shifted by +8 (instead of 49)
    -- https://en.wikipedia.org/wiki/12_equal_temperament
    return settings.pitch.value * ((2 ^ (1 / 12)) ^ (note - 57))
end

-- Calculate interval properties
function equal_interval(note1, note2, _, _)
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
function pure_interval(_, _, interval, octaves)
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
    pythagorean_interval,
    kirnberger3_interval,
    werckmesiter3_interval,
    sixth_comma_interval
}
