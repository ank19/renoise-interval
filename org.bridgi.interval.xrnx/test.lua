--  ___ ____ ____ ___    ____ ____ _  _ ____ ___ ____ _  _ ___ ____
--   |  |___ [__   |     |    |  | |\ | [__   |  |__| |\ |  |  [__
--   |  |___ ___]  |     |___ |__| | \| ___]  |  |  | | \|  |  ___]

local CONSONANCE_PRIME          =  1.00
local CONSONANCE_MINOR_SECOND   = 15.49
local CONSONANCE_MAJOR_SECOND   =  8.49
local CONSONANCE_MINOR_THIRD    =  5.48
local CONSONANCE_MAJOR_THIRD    =  4.47
local CONSONANCE_PERFECT_FOURTH =  3.46
local CONSONANCE_TRITONE        = 37.95
local CONSONANCE_PERFECT_FIFTH  =  2.45
local CONSONANCE_MINOR_SIXTH    =  6.32
local CONSONANCE_MAJOR_SIXTH    =  3.87
local CONSONANCE_MINOR_SEVENTH  = 12.00
local CONSONANCE_MAJOR_SEVENTH  = 10.95
local CONSONANCE_PERFECT_OCTAVE =  1.41
local CONSONANCE_TWO_OCTAVES    =  2.00
local CONSONANCE_MAJOR_TRIAD    =  3.91

local CONSONANCE_PYTHAGOREAN_WOLF_FIFTH = 18.17

local PYTHAGOREAN_D4  =  586.67
local PYTHAGOREAN_Eb4 =  618.05
local PYTHAGOREAN_E4  =  660.00
local PYTHAGOREAN_F4  =  695.30
local PYTHAGOREAN_Gb4 =  742.50
local PYTHAGOREAN_G4  =  782.22
local PYTHAGOREAN_Ab4 =  835.31
local PYTHAGOREAN_A4  =  880.00
local PYTHAGOREAN_Bb4 =  927.08
local PYTHAGOREAN_B4  =  990.00
local PYTHAGOREAN_C5  = 1042.96
local PYTHAGOREAN_Db5 = 1113.75
local PYTHAGOREAN_D5  = 1173.33

local EQUAL_TEMPERAMENT_D4  =  587.33
local EQUAL_TEMPERAMENT_Eb4 =  622.25
local EQUAL_TEMPERAMENT_E4  =  659.26
local EQUAL_TEMPERAMENT_F4  =  698.46
local EQUAL_TEMPERAMENT_Gb4 =  739.99
local EQUAL_TEMPERAMENT_G4  =  784.00
local EQUAL_TEMPERAMENT_Ab4 =  830.60
local EQUAL_TEMPERAMENT_A4  =  880.00
local EQUAL_TEMPERAMENT_Bb4 =  932.33
local EQUAL_TEMPERAMENT_B4  =  987.77
local EQUAL_TEMPERAMENT_C5  = 1046.50
local EQUAL_TEMPERAMENT_Db5 = 1108.73
local EQUAL_TEMPERAMENT_D5  = 1174.66

local HEARING_THRESHOLD = 0.011

--  _  _ ____ _    ___  ____ ____    ____ _  _ _  _ ____ ___ _ ____ _  _ ____
--  |__| |___ |    |__] |___ |__/    |___ |  | |\ | |     |  | |  | |\ | [__
--  |  | |___ |___ |    |___ |  \    |    |__| | \| |___  |  | |__| | \| ___]

local function assert_interval_dissonance(expected, note1, note2, volume1, volume2, message)
    local single_line = message:gsub("\n"," ")
    local _, wrapper = interval_properties(note1, note2, volume1, volume2)
    local interval, halftones, _, _, a, b, cents, p, frequency1, frequency2, actual = wrapper(nil)
    assert(is_almost(expected, actual), single_line.." - dissonance of "..actual.." doesn't match expected dissonance of "..expected)
    test_log("Verified dissonance for '"..single_line.."': "..actual)
end

local function assert_chord_dissonance(expected, chord, message)
    local single_line = message:gsub("\n"," ")
    local actual = dissect_chord(1, nil, nil, unpack(chord))
    assert(is_almost(expected, actual), single_line.." - dissonance of "..actual.." doesn't match expected dissonance of "..expected)
    test_log("Verified chord dissonance for '"..single_line.."': "..actual)
end

local function assert_approximation(expected_a, expected_b, irrational, limit, message)
    local actual_a, actual_b = unpack(approximate_rational(irrational, limit, HEARING_THRESHOLD))
    local single_line = message:gsub("\n"," ")
    assert(actual_a == expected_a and actual_b == expected_b,
            "Approximation for '"..single_line.."' yielded ratio "..actual_a.."/"..actual_b
                    ..", but expected "..expected_a.."/"..expected_b)
    test_log("Verified approximation for for '"..single_line.."': "..expected_a.."/"..expected_b)
end

local function assert_pythagorean(expected_hz, frequencies, note, message)
    local actual_hz = pythagorean_frequency(frequencies, note)
    assert(is_almost(actual_hz, expected_hz), "Pythagorean "..message..": Expected "..expected_hz.."Hz, but got "..actual_hz.."Hz")
    test_log("Verified Pythagorean frequency "..expected_hz.." for "..message)
end

local function assert_equal_temperament(expected_hz, note, message)
    local actual_hz = equal_frequency(note)
    assert(is_almost(actual_hz, expected_hz), "Equal temperament "..message..": Expected "..expected_hz.."Hz, but got "..actual_hz.."Hz")
    test_log("Verified equal temperament frequency "..expected_hz.." for "..message)
end

local function assert_schildkraut(a, b, n, expected)
    local actual = schildkraut(a - 1, b - 1, n) + 1 -- Note: Fixing Lua one-based index
    assert(actual == expected, "Schildkraut value for "..a..","..b.." for N="..n..": Expected "..expected.." but got "..actual)
    test_log("Verified Schildkraut value for "..a..","..b.." for N="..n)
end


--  ____ ____ _  _ ____ _ ____ ____    _  _ ____ ____ _  _ ____
--  |__/ |___ |\ | |  | | [__  |___    |\/| |  | |    |_/  [__
--  |  \ |___ | \| |__| | ___] |___    |  | |__| |___ | \_ ___]

settings = {
}

Document = {
}

function Document:create(test)
 return function(mock) return {
     tuning = {
         value = 1
     },
     tuning_note = {
         value = 3
     },
     pitch = {
         value = 440
     },
     hearing_threshold = {
         value = HEARING_THRESHOLD
     }
 }  end
end

renoise = {
    ViewBuilder = {
        DEFAULT_DIALOG_MARGIN = -1
    },
    Document = Document
}

tool = {
}

function tool:add_menu_entry()
end

function tool:add_keybinding()
end

function renoise:tool()
    return tool
end

function renoise:app()
    return nil
end

renoise.__index = renoise

local DIALOG_MARGIN                = renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
local DIALOG_SPACING               = renoise.ViewBuilder.DEFAULT_DIALOG_SPACING
local CONTENT_SPACING              = renoise.ViewBuilder.DEFAULT_CONTROL_SPACING
local CONTENT_MARGIN               = renoise.ViewBuilder.DEFAULT_CONTROL_MARGIN
local DEFAULT_CONTROL_HEIGHT       = renoise.ViewBuilder.DEFAULT_CONTROL_HEIGHT
local DEFAULT_DIALOG_BUTTON_HEIGHT = renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT
local DEFAULT_MINI_CONTROL_HEIGHT  = renoise.ViewBuilder.DEFAULT_MINI_CONTROL_HEIGHT

dofile("C:\\Users\\Andreas\\AppData\\Roaming\\Renoise\\V3.4.0\\Scripts\\Tools\\org.bridgi.interval.xrnx\\main.lua")

--  ___ ____ ____ ___ ____
--   |  |___ [__   |  [__
--   |  |___ ___]  |  ___]

local function test_pure_intervals()

    selected_tuning = 1

    -- C  C#  D  D#  E  F  F#  G  G#  A  A#  B
    -- 48 49  50 51  52 53 54  55 56  57 58  59
    local MAJOR_TRIAD = {{ note = 52, volume = 50, volume_percentage = 0.333, delta = 0 },
                         { note = 56, volume = 50, volume_percentage = 0.333, delta = 0 },
                         { note = 59, volume = 50, volume_percentage = 0.333, delta = 0 }}
    -- ((5*4)^0.5 * (6*5)^0.5 * (3*2)^0.5)^0.333 = 3.91
    test_log("Start testing major triad chord dissonance calculation")
    assert_chord_dissonance(CONSONANCE_MAJOR_TRIAD, MAJOR_TRIAD, "Major triad")

    -- C  C#  D  D#  E  F  F#  G  G#  A  A#  B
    -- 48 49  50 51  52 53 54  55 56  57 58  59
    local DOMINANT_SEVENTH_CHORD_VOL_DIFF = {{ note = 52, volume = 0, volume_percentage = 0.2, delta = 0 },
                                             { note = 56, volume = 0, volume_percentage = 0.1, delta = 0 },
                                             { note = 59, volume = 0, volume_percentage = 0.1, delta = 0 },
                                             { note = 62, volume = 0, volume_percentage = 0.6, delta = 0 }}
    -- Every of the four notes is part of three pairs (of 6 pairs in total), therefore the volume has to be:
    --     0.1 / (4 - 1) = 1 / 30
    -- The expected dissonance value for the dissected chord having the volume 0.1 then is
    --     ( ( 6^(1/30) *  5^(1/30))
    --     * ( 6^(1/30) *  5^(1/30))
    --     * ( 5^(1/30) *  4^(1/30))
    --     * (36^(1/30) * 25^(1/30))
    --     * ( 3^(1/30) *  2^(1/30))
    --     * ( 9^(1/30) *  5^(1/30))) = 2.0959
    -- or
    --     (6 * 5 * 6 * 5 * 5 * 4 * 36 * 25 * 3 * 2 * 9 * 5) ^ (1 / 30) = 2.0959
    -- That leaves
    --     (9^0.1 * 5^0.1) = 1.4633
    -- for minor seventh between notes 52 and 62, the volume does not have to be distributed across the notes as it's
    -- only one pair of notes.
    -- Finally there's the prime for the last 40% of the volume for the last note:
    --     (1^0.2 * 1^0.2) = 1.0000
    -- That yields a dissonance value of 2.0959 * 1.4633 * 1.000 = 3.0669
    -- When using the actual frequency ratio instead of a combination of pure intervals, the ratio 9/5 for the
    -- seventh in the dominant seventh chord will be 16/9 (1.78) instead of 9/5 (1.80), resulting in a actual
    -- dissonance value of 3.44, as
    --     (16^0.1 * 9^0.1) = 1.6438
    -- The reasoning here is that prioritized use case is to use a specific tuning like equal temperament instead of
    -- the pure intervals.

    test_log("Start testing dominant seventh chord dissonance calculation")
    assert_chord_dissonance(2.0959 * 1.4633 * 1.000, DOMINANT_SEVENTH_CHORD_VOL_DIFF, "Dominant Seventh Chord")

    test_log("Start testing simple interval dissonance calculation")
    assert_interval_dissonance(CONSONANCE_PRIME         , 1,  1, 80, 80, interval_texts["en"][ 1])
    assert_interval_dissonance(CONSONANCE_MINOR_SECOND  , 1,  2, 80, 80, interval_texts["en"][ 2])
    assert_interval_dissonance(CONSONANCE_MAJOR_SECOND  , 1,  3, 80, 80, interval_texts["en"][ 3])
    assert_interval_dissonance(CONSONANCE_MINOR_THIRD   , 1,  4, 80, 80, interval_texts["en"][ 4])
    assert_interval_dissonance(CONSONANCE_MAJOR_THIRD   , 1,  5, 80, 80, interval_texts["en"][ 5])
    assert_interval_dissonance(CONSONANCE_PERFECT_FOURTH, 1,  6, 80, 80, interval_texts["en"][ 6])
    assert_interval_dissonance(CONSONANCE_TRITONE       , 1,  7, 80, 80, interval_texts["en"][ 7])
    assert_interval_dissonance(CONSONANCE_PERFECT_FIFTH , 1,  8, 80, 80, interval_texts["en"][ 8])
    assert_interval_dissonance(CONSONANCE_MINOR_SIXTH   , 1,  9, 80, 80, interval_texts["en"][ 9])
    assert_interval_dissonance(CONSONANCE_MAJOR_SIXTH   , 1, 10, 80, 80, interval_texts["en"][10])
    assert_interval_dissonance(CONSONANCE_MINOR_SEVENTH , 1, 11, 80, 80, interval_texts["en"][11])
    assert_interval_dissonance(CONSONANCE_MAJOR_SEVENTH , 1, 12, 80, 80, interval_texts["en"][12])
    assert_interval_dissonance(CONSONANCE_PERFECT_OCTAVE, 1, 13, 80, 80, interval_texts["en"][13])
    assert_interval_dissonance(CONSONANCE_TWO_OCTAVES   , 1, 25, 80, 80, "Two octaves")
end

-- Test approximation of equal temperament ('just tuning')
local function test_approximation()
    local limit = 999 -- Nominator / denominator limit
    assert_approximation( 1,  1, 1.000, limit, interval_texts["en"][ 1])
    assert_approximation(16, 15, 1.059, limit, interval_texts["en"][ 2])
    assert_approximation( 9,  8, 1.122, limit, interval_texts["en"][ 3])
    assert_approximation( 6,  5, 1.189, limit, interval_texts["en"][ 4])
    assert_approximation( 5,  4, 1.260, limit, interval_texts["en"][ 5])
    assert_approximation( 4,  3, 1.335, limit, interval_texts["en"][ 6])
    assert_approximation( 7,  5, 1.414, limit, interval_texts["en"][ 7])
    assert_approximation( 3,  2, 1.498, limit, interval_texts["en"][ 8])
    assert_approximation( 8,  5, 1.587, limit, interval_texts["en"][ 9])
    assert_approximation( 5,  3, 1.682, limit, interval_texts["en"][10])
    assert_approximation( 9,  5, 1.782, limit, interval_texts["en"][11])
    assert_approximation(15,  8, 1.888, limit, interval_texts["en"][12])
    assert_approximation( 2,  1, 2.000, limit, interval_texts["en"][13])
end

-- The Pythagorean wolf fifth has a frequency ratio of
--     2^7 / (3/2)^11 = 2^18 / 3^11 = 262.144 / 177.147 = 1.47981
-- Assuming a hearing threshold of 0.01, that is approximately 22/15,
-- yielding a dissonance value of
--     (22 * 15)^0.5 = 18.166
local function test_pythagorean_wolf_fifth()
    -- C  C#  D  D#  E  F  F#  G  G#  A  A#  B
    -- 48 49  50 51  52 53 54  55 56  57 58  59
    local frequencies = pythagorean_frequencies()
    local a, b, _, _, _, _, wolf = pythagorean_interval(56, 63, -1, 0, 0.5,  { frequencies = frequencies })
    assert(is_almost(wolf, CONSONANCE_PYTHAGOREAN_WOLF_FIFTH), "Wrong dissonance of wolf fifth: ".. wolf)
    assert(a == 22 and b == 15, "Wrong frequency ratio for wolf fifth: "..a.."/"..b..", expected 22/15")
end

local function test_pythagorean_frequencies()
    local frequencies = pythagorean_frequencies()
    assert_pythagorean(PYTHAGOREAN_D4 , frequencies, 62, "D4")
    assert_pythagorean(PYTHAGOREAN_Eb4, frequencies, 63, "Eb4")
    assert_pythagorean(PYTHAGOREAN_E4 , frequencies, 64, "E4")
    assert_pythagorean(PYTHAGOREAN_F4 , frequencies, 65, "F4")
    assert_pythagorean(PYTHAGOREAN_Gb4, frequencies, 66, "Gb4")
    assert_pythagorean(PYTHAGOREAN_G4 , frequencies, 67, "G4")
    assert_pythagorean(PYTHAGOREAN_Ab4, frequencies, 68, "Ab4")
    assert_pythagorean(PYTHAGOREAN_A4 , frequencies, 69, "A4")
    assert_pythagorean(PYTHAGOREAN_Bb4, frequencies, 70, "Bb4")
    assert_pythagorean(PYTHAGOREAN_B4 , frequencies, 71, "B4")
    assert_pythagorean(PYTHAGOREAN_C5 , frequencies, 72, "C5")
    assert_pythagorean(PYTHAGOREAN_Db5, frequencies, 73, "Db5")
    assert_pythagorean(PYTHAGOREAN_D5 , frequencies, 74, "D5")

end

local function test_equal_temperament()
    assert_equal_temperament(EQUAL_TEMPERAMENT_D4 , 62, "D4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_Eb4, 63, "Eb4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_E4 , 64, "E4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_F4 , 65, "F4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_Gb4, 66, "Gb4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_G4 , 67, "G4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_Ab4, 68, "Ab4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_A4 , 69, "A4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_Bb4, 70, "Bb4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_B4 , 71, "B4")
    assert_equal_temperament(EQUAL_TEMPERAMENT_C5 , 72, "C5")
    assert_equal_temperament(EQUAL_TEMPERAMENT_Db5, 73, "Db5")
    assert_equal_temperament(EQUAL_TEMPERAMENT_D5 , 74, "D5")
end

local function test_schildkraut()
    assert_schildkraut(1, 2, 5,  1)
    assert_schildkraut(1, 3, 5,  2)
    assert_schildkraut(1, 4, 5,  3)
    assert_schildkraut(1, 5, 5,  4)
    assert_schildkraut(2, 3, 5,  5)
    assert_schildkraut(2, 4, 5,  6)
    assert_schildkraut(2, 5, 5,  7)
    assert_schildkraut(3, 4, 5,  8)
    assert_schildkraut(3, 5, 5,  9)
    assert_schildkraut(4, 5, 5, 10)
end

test_schildkraut()
test_equal_temperament()
test_pythagorean_frequencies()
test_pythagorean_wolf_fifth()
test_pure_intervals()
test_approximation()
