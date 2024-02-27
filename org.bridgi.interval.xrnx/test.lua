--  _  _ ____ _    ___  ____ ____    ____ _  _ _  _ ____ ___ _ ____ _  _ ____
--  |__| |___ |    |__] |___ |__/    |___ |  | |\ | |     |  | |  | |\ | [__
--  |  | |___ |___ |    |___ |  \    |    |__| | \| |___  |  | |__| | \| ___]

function equals(o1, o2)
    if o1 == o2 then return true end
    if type(o1) ~= type(o2) then
        test_log("Variable types to not match "..tostring(type(o1)).."/"..tostring(type(o2)))
        return false
    end
    if type(o1) ~= 'table' then
        test_log("Variable type is not a table "..tostring(type(o1)))
        return false
    end
    local keys = {}
    for k1, v1 in pairs(o1) do
        local v2 = o2[k1]
        if v2 == nil then
            test_log("First table contains key "..k1..", which is not present in second table")
            return false
        end
        if equals(v1, v2) == false then
            test_log("Values for key "..k1.." do not match: "..tostring(v1).."/"..tostring(v2))
            return false
        end
        keys[k1] = true
    end
    for k2, _ in pairs(o2) do
        if not keys[k2] then
            test_log("Second table contains key "..k2..", which is not present in first table")
            return false
        end
    end
    return true
end

--  ____ ____ _  _ ____ _ ____ ____    _  _ ____ ____ _  _ ____
--  |__/ |___ |\ | |  | | [__  |___    |\/| |  | |    |_/  [__
--  |  \ |___ | \| |__| | ___] |___    |  | |__| |___ | \_ ___]

settings = {
}

Document = {
}

local HEARING_THRESHOLD = 0.011
local MAX_LINES = 4

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
     },
     delta_condensed = {
         value = 99
     },
     delta_compact = {
         value = 255
     },
     lines_condensed = {
         value = MAX_LINES
     },
     lines_compact = {
         value = MAX_LINES
     },
     volume_reduction = {
         value = 0.20
     },
     tracks_condensed = {
         value = 1
     },
     tracks_compact = {
         value = 2
     },
     dialog_type = {
         value = DIALOG_CONDENSED
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

dofile("C:\\Users\\Andreas\\AppData\\Roaming\\Renoise\\V3.4.0\\Scripts\\Tools\\org.bridgi.interval.xrnx\\maths.lua")
dofile("C:\\Users\\Andreas\\AppData\\Roaming\\Renoise\\V3.4.0\\Scripts\\Tools\\org.bridgi.interval.xrnx\\main.lua")

--  ___ ____ ____ ___ ____     ___  _  _ ____ ____    _ _  _ ___ ____ ____ _  _ ____ _    ____
--   |  |___ [__   |  [__  .   |__] |  | |__/ |___    | |\ |  |  |___ |__/ |  | |__| |    [__
--   |  |___ ___]  |  ___] .   |    |__| |  \ |___    | | \|  |  |___ |  \  \/  |  | |___ ___]
--

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

local function assert_interval_dissonance(expected, note1, note2, volume1, volume2, message)
    local single_line = message:gsub("\n"," ")
    local interval = new_interval(note1, note2, volume1, volume2)
    -- local _, wrapper =
    local properties = interval:properties()
    local actual = properties.dissonance
    assert(is_almost(expected, actual), single_line.." - dissonance of "..actual.." doesn't match expected dissonance of "..expected)
    test_log("Verified dissonance for '"..single_line.."': "..actual)
end

local function assert_chord_dissonance(expected, chord, message)
    local single_line = message:gsub("\n"," ")
    local actual = dissect_chord(1, nil, unpack(chord))
    assert(is_almost(expected, actual), single_line.." - dissonance of "..actual.." doesn't match expected dissonance of "..expected)
    test_log("Verified chord dissonance for '"..single_line.."': "..actual)
end

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
    assert_interval_dissonance(1, 1, 13, nil, nil, "Octave - nil volume")
end

--  ___ ____ ____ ___ ____     ____ ___  ___  ____ ____ _  _ _ _  _ ____ ___ _ ____ _  _
--   |  |___ [__   |  [__  .   |__| |__] |__] |__/ |  |  \/  | |\/| |__|  |  | |  | |\ |
--   |  |___ ___]  |  ___] .   |  | |    |    |  \ |__| _/\_ | |  | |  |  |  | |__| | \|
--

local function assert_approximation(expected_a, expected_b, irrational, limit, message)
    local actual_a, actual_b = approximate_rational(irrational, limit, HEARING_THRESHOLD)
    local single_line = message:gsub("\n"," ")
    assert(actual_a == expected_a and actual_b == expected_b,
            "Approximation for '"..single_line.."' yielded ratio "..actual_a.."/"..actual_b
                    ..", but expected "..expected_a.."/"..expected_b)
    test_log("Verified approximation for for '"..single_line.."': "..expected_a.."/"..expected_b)
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



--  ___ ____ ____ ___ ____     ____ _ _  _ ___ _  _    ____ ____ _  _ _  _ ____    _  _ ____ ____ _  _ ___ ____ _  _ ____
--   |  |___ [__   |  [__  .   [__  |  \/   |  |__| __ |    |  | |\/| |\/| |__|    |\/| |___ |__| |\ |  |  |  | |\ | |___
--   |  |___ ___]  |  ___] .   ___] | _/\_  |  |  |    |___ |__| |  | |  | |  |    |  | |___ |  | | \|  |  |__| | \| |___
--

local SIXTH_COMMA_D4  =  587.88
local SIXTH_COMMA_Eb4 =  618.05  --  TODO: Should be 618.7Hz
local SIXTH_COMMA_E4  =  658.63
local SIXTH_COMMA_F4  =  701.10
local SIXTH_COMMA_Gb4 =  737.90
local SIXTH_COMMA_G4  =  785.47
local SIXTH_COMMA_Ab4 =  826.70
local SIXTH_COMMA_A4  =  880.00
local SIXTH_COMMA_Bb4 =  925.16   --  TODO: Should be 926.2Hz
local SIXTH_COMMA_B4  =  985.90
local SIXTH_COMMA_C5  = 1049.46
local SIXTH_COMMA_Db5 = 1104.56
local SIXTH_COMMA_D5  = 1175.77

-- calculate_frequency(note, tuning_note, tuning_frequency)

local function assert_sixth_comma(expected_hz, note, message)
    test_log("Calculating Sixth Comma for note "..note)
    local actual_hz = sixth_comma_frequency(note)
    assert(is_almost(actual_hz, expected_hz), "Sixth comma "..message..": Expected "..expected_hz.."Hz, but got "..actual_hz.."Hz")
    test_log("Verified Sixth comma frequency "..expected_hz.." for "..message)
end

local function test_sixth_comma_frequencies()
    assert_sixth_comma(SIXTH_COMMA_D4 , 62, "D4")
    assert_sixth_comma(SIXTH_COMMA_Eb4, 63, "Eb4")
    assert_sixth_comma(SIXTH_COMMA_E4 , 64, "E4")
    assert_sixth_comma(SIXTH_COMMA_F4 , 65, "F4")
    assert_sixth_comma(SIXTH_COMMA_Gb4, 66, "Gb4")
    assert_sixth_comma(SIXTH_COMMA_G4 , 67, "G4")
    assert_sixth_comma(SIXTH_COMMA_Ab4, 68, "Ab4")
    assert_sixth_comma(SIXTH_COMMA_A4 , 69, "A4")
    assert_sixth_comma(SIXTH_COMMA_Bb4, 70, "Bb4")
    assert_sixth_comma(SIXTH_COMMA_B4 , 71, "B4")
    assert_sixth_comma(SIXTH_COMMA_C5 , 72, "C5")
    assert_sixth_comma(SIXTH_COMMA_Db5, 73, "Db5")
    assert_sixth_comma(SIXTH_COMMA_D5 , 74, "D5")
end

--  ___ ____ ____ ___ ____     _ _ _ ____ ____ ____ _  _ _  _ ____ _ ____ ___ ____ ____    _ _ _
--   |  |___ [__   |  [__  .   | | | |___ |__/ |    |_/  |\/| |___ | [__   |  |___ |__/    | | |
--   |  |___ ___]  |  ___] .   |_|_| |___ |  \ |___ | \_ |  | |___ | ___]  |  |___ |  \    | | |
--

local WERCKMEISTER_III_D4  =  588.66
local WERCKMEISTER_III_Eb4 =  620.15
local WERCKMEISTER_III_E4  =  657.77
local WERCKMEISTER_III_F4  =  697.67
local WERCKMEISTER_III_Gb4 =  737.49
local WERCKMEISTER_III_G4  =  784.88
local WERCKMEISTER_III_Ab4 =  826.87
local WERCKMEISTER_III_A4  =  880.00
local WERCKMEISTER_III_Bb4 =  930.22
local WERCKMEISTER_III_B4  =  983.31
local WERCKMEISTER_III_C5  = 1046.50
local WERCKMEISTER_III_Db5 = 1106.23
local WERCKMEISTER_III_D5  = 1177.32

-- calculate_frequency(note, tuning_note, tuning_frequency)

local function assert_werckmeister3(expected_hz, note, message)
    test_log("Calculating Werckmeister III for note "..note)
    local actual_hz = werckmeister3_frequency(note)
    assert(is_almost(actual_hz, expected_hz), "Werckmeister III "..message..": Expected "..expected_hz.."Hz, but got "..actual_hz.."Hz")
    test_log("Verified Werckmeister III frequency "..expected_hz.." for "..message)
end

local function test_werckmeister3_frequencies()
    assert_werckmeister3(WERCKMEISTER_III_D4 , 62, "D4")
    assert_werckmeister3(WERCKMEISTER_III_Eb4, 63, "Eb4")
    assert_werckmeister3(WERCKMEISTER_III_E4 , 64, "E4")
    assert_werckmeister3(WERCKMEISTER_III_F4 , 65, "F4")
    assert_werckmeister3(WERCKMEISTER_III_Gb4, 66, "Gb4")
    assert_werckmeister3(WERCKMEISTER_III_G4 , 67, "G4")
    assert_werckmeister3(WERCKMEISTER_III_Ab4, 68, "Ab4")
    assert_werckmeister3(WERCKMEISTER_III_A4 , 69, "A4")
    assert_werckmeister3(WERCKMEISTER_III_Bb4, 70, "Bb4")
    assert_werckmeister3(WERCKMEISTER_III_B4 , 71, "B4")
    assert_werckmeister3(WERCKMEISTER_III_C5 , 72, "C5")
    assert_werckmeister3(WERCKMEISTER_III_Db5, 73, "Db5")
    assert_werckmeister3(WERCKMEISTER_III_D5 , 74, "D5")
end

--  ___ ____ ____ ___ ____     _  _ _ ____ _  _ ___  ____ ____ ____ ____ ____    _ _ _
--   |  |___ [__   |  [__  .   |_/  | |__/ |\ | |__] |___ |__/ | __ |___ |__/    | | |
--   |  |___ ___]  |  ___] .   | \_ | |  \ | \| |__] |___ |  \ |__] |___ |  \    | | |
--

local KIRNBERGER_III_D4  =  588.50
local KIRNBERGER_III_Eb4 =  619.97
local KIRNBERGER_III_E4  =  657.95
local KIRNBERGER_III_F4  =  697.47
local KIRNBERGER_III_Gb4 =  735.61
local KIRNBERGER_III_G4  =  784.66
local KIRNBERGER_III_Ab4 =  827.57
local KIRNBERGER_III_A4  =  880.00
local KIRNBERGER_III_Bb4 =  929.96
local KIRNBERGER_III_B4  =  983.87
local KIRNBERGER_III_C5  = 1046.20
local KIRNBERGER_III_Db5 = 1103.42
local KIRNBERGER_III_D5  = 1176.99

-- calculate_frequency(note, tuning_note, tuning_frequency)

local function assert_kirnberger3(expected_hz, note, message)
    test_log("Calculating Kirnberger III for note "..note)
    local actual_hz = kirnberger3_frequency(note)
    assert(is_almost(actual_hz, expected_hz), "Kirnberger III "..message..": Expected "..expected_hz.."Hz, but got "..actual_hz.."Hz")
    test_log("Verified Kirnberger III frequency "..expected_hz.." for "..message)
end

local function test_kirnberger3_frequencies()
    assert_kirnberger3(KIRNBERGER_III_D4 , 62, "D4")
    assert_kirnberger3(KIRNBERGER_III_Eb4, 63, "Eb4")
    assert_kirnberger3(KIRNBERGER_III_E4 , 64, "E4")
    assert_kirnberger3(KIRNBERGER_III_F4 , 65, "F4")
    assert_kirnberger3(KIRNBERGER_III_Gb4, 66, "Gb4")
    assert_kirnberger3(KIRNBERGER_III_G4 , 67, "G4")
    assert_kirnberger3(KIRNBERGER_III_Ab4, 68, "Ab4")
    assert_kirnberger3(KIRNBERGER_III_A4 , 69, "A4")
    assert_kirnberger3(KIRNBERGER_III_Bb4, 70, "Bb4")
    assert_kirnberger3(KIRNBERGER_III_B4 , 71, "B4")
    assert_kirnberger3(KIRNBERGER_III_C5 , 72, "C5")
    assert_kirnberger3(KIRNBERGER_III_Db5, 73, "Db5")
    assert_kirnberger3(KIRNBERGER_III_D5 , 74, "D5")
end

--  ___ ____ ____ ___ ____     ___  _   _ ___ _  _ ____ ____ ____ ____ ____ ____ _  _
--   |  |___ [__   |  [__  .   |__]  \_/   |  |__| |__| | __ |  | |__/ |___ |__| |\ |
--   |  |___ ___]  |  ___] .   |      |    |  |  | |  | |__] |__| |  \ |___ |  | | \|
--

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

local function assert_pythagorean(expected_hz, note, message)
    local actual_hz = pythagorean_frequency(note)
    assert(is_almost(actual_hz, expected_hz), "Pythagorean "..message..": Expected "..expected_hz.."Hz, but got "..actual_hz.."Hz")
    test_log("Verified Pythagorean frequency "..expected_hz.." for "..message)
end

-- The Pythagorean wolf fifth has a frequency ratio of
--     2^7 / (3/2)^11 = 2^18 / 3^11 = 262.144 / 177.147 = 1.47981
-- Assuming a hearing threshold of 0.01, that is approximately 22/15,
-- yielding a dissonance value of
--     (22 * 15)^0.5 = 18.166
local function test_pythagorean_wolf_fifth()
    -- C  C#  D  D#  E  F  F#  G  G#  A  A#  B
    -- 48 49  50 51  52 53 54  55 56  57 58  59
    local a, b, _, _, _, _ = pythagorean_interval(56, 63, -1, 0)
    local wolf = dissonance_value(1, 0.5, 2, Ratios:single(a, b))
    assert(is_almost(wolf, CONSONANCE_PYTHAGOREAN_WOLF_FIFTH), "Wrong dissonance of wolf fifth: ".. wolf)
    assert(a == 22 and b == 15, "Wrong frequency ratio for wolf fifth: "..a.."/"..b..", expected 22/15")
end

local function test_pythagorean_frequencies()
    assert_pythagorean(PYTHAGOREAN_D4 , 62, "D4")
    assert_pythagorean(PYTHAGOREAN_Eb4, 63, "Eb4")
    assert_pythagorean(PYTHAGOREAN_E4 , 64, "E4")
    assert_pythagorean(PYTHAGOREAN_F4 , 65, "F4")
    assert_pythagorean(PYTHAGOREAN_Gb4, 66, "Gb4")
    assert_pythagorean(PYTHAGOREAN_G4 , 67, "G4")
    assert_pythagorean(PYTHAGOREAN_Ab4, 68, "Ab4")
    assert_pythagorean(PYTHAGOREAN_A4 , 69, "A4")
    assert_pythagorean(PYTHAGOREAN_Bb4, 70, "Bb4")
    assert_pythagorean(PYTHAGOREAN_B4 , 71, "B4")
    assert_pythagorean(PYTHAGOREAN_C5 , 72, "C5")
    assert_pythagorean(PYTHAGOREAN_Db5, 73, "Db5")
    assert_pythagorean(PYTHAGOREAN_D5 , 74, "D5")
end

--  ___ ____ ____ ___ ____     ____ ____ _  _ ____ _       ___ ____ _  _ ___  ____ ____ ____ _  _ ____ _  _ ___
--   |  |___ [__   |  [__  .   |___ |  | |  | |__| |        |  |___ |\/| |__] |___ |__/ |__| |\/| |___ |\ |  |
--   |  |___ ___]  |  ___] .   |___ |_\| |__| |  | |___     |  |___ |  | |    |___ |  \ |  | |  | |___ | \|  |
--

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

local function assert_equal_temperament(expected_hz, note, message)
    local actual_hz = equal_frequency(note)
    assert(is_almost(actual_hz, expected_hz), "Equal temperament "..message..": Expected "..expected_hz.."Hz, but got "..actual_hz.."Hz")
    test_log("Verified equal temperament frequency "..expected_hz.." for "..message)
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

--  ___ ____ ____ ___ ____     ____ ____ _  _ _ _    ___  _  _ ____ ____ _  _ ___
--   |  |___ [__   |  [__  .   [__  |    |__| | |    |  \ |_/  |__/ |__| |  |  |
--   |  |___ ___]  |  ___] .   ___] |___ |  | | |___ |__/ | \_ |  \ |  | |__|  |
--

local function assert_schildkraut(a, b, n, expected)
    local actual = schildkraut(a - 1, b - 1, n) + 1 -- Note: Fixing Lua one-based index
    assert(actual == expected, "Schildkraut value for "..a..","..b.." for N="..n..": Expected "..expected.." but got "..actual)
    test_log("Verified Schildkraut value for "..a..","..b.." for N="..n)
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

--  ___ ____ ____ ___ ____     _  _ ____ _    _  _ _  _ ____
--   |  |___ [__   |  [__  .   |  | |  | |    |  | |\/| |___
--   |  |___ ___]  |  ___] .    \/  |__| |___ |__| |  | |___
--

local function assert_volume_percentage(input, expected)
    local actual = { volume_percentage(unpack(input)) }
    assert(equals(actual, expected), "Volume percentage does not match")
    test_log("Verified volume percentage "..unpack(expected))
end

local function test_volume_percentage()
    assert_volume_percentage({  80, 50, 20, 10 }, { 0.5000, 0.3125, 0.1250, 0.0625 })
    assert_volume_percentage({   0,  0,  0,  0 }, { 0.0000, 0.0000, 0.0000, 0.0000 })
end

--  ___ ____ ____ ___ ____     ____ ___ _  _ ____ ____
--   |  |___ [__   |  [__  .   |  |  |  |__| |___ |__/
--   |  |___ ___]  |  ___] .   |__|  |  |  | |___ |  \
--

local function test_order_comparison()
    local l1 = { sequence = 1, line = 1}
    local l2 = { sequence = 1, line = 2}
    local l3 = { sequence = 2, line = 1}
    assert(is_before_line(l1, l2), dump(l1).." should be identified as being before "..dump(l2))
    assert(not is_before_line(l1, l1), dump(l1).." should not be identified as being before "..dump(l1))
    assert(is_before_line(l2, l3), dump(l2).." should be identified as being before "..dump(l3))
    assert(is_after_line(l2, l1), dump(l2).." should be identified as being after "..dump(l1))
    assert(not is_after_line(l1, l1), dump(l1).." should not be identified as being after "..dump(l1))
    assert(is_after_line(l3, l2), dump(l2).." should be identified as being after "..dump(l3))
    assert(is_same_line(l1, l1), dump(l1).." should be identified as the same as "..dump(l1))
    assert(not is_same_line(l1, l2), dump(l1).." should be not be identified as the same as "..dump(l2))
    assert(not is_same_line(l1, l3), dump(l1).." should be not be identified as the same as "..dump(l3))
end

--  ___ ____ ____ ___ ____     ____ ____ _  _ ___  ____ _  _ ____ ____ ___     _  _ _ ____ _ _ _
--   |  |___ [__   |  [__  .   |    |  | |\ | |  \ |___ |\ | [__  |___ |  \    |  | | |___ | | |
--   |  |___ ___]  |  ___] .   |___ |__| | \| |__/ |___ | \| ___] |___ |__/     \/  | |___ |_|_|
--

local function assert_vertical_interval(notes, expected, row, column)
    local interval = notes[row][column].vertical
    local halftones = interval and interval.halftones or nil
    assert(halftones == expected, "Expected "..dump(expected).." at "..row.."/"..column..", but got "..dump(halftones))
    test_log("Successfully verified vertical interval at "..row.."/"..column.." : "..dump(halftones))
end

local function assert_horizontal_interval(notes, expected, row, column)
    local interval = notes[row][column].horizontal
    local halftones = interval and interval.halftones or nil
    assert(halftones == expected, "Expected "..dump(expected).." at "..row.."/"..column..", but got "..dump(halftones))
    test_log("Successfully verified horizontal interval at "..row.."/"..column.." : "..dump(halftones))
end


local function test_find_lines_of_interest_minimum()
    local patterns = {}
    patterns[1] = {
        number_of_lines = 3,
        tracks = {}
    }
    patterns[1].tracks[1] = {
        visible_note_columns = 3,
        lines = {}
    }
    patterns[1].tracks[1].lines[1] = { note_columns = {} }
    patterns[1].tracks[1].lines[1].note_columns[1] = { note_value = 40, note_string = "E2", volume_value = 80 }
    patterns[1].tracks[1].lines[1].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[1].tracks[1].lines[1].note_columns[3] = { note_value = 57, note_string = "A3", volume_value = 80 }
    patterns[1].tracks[1].lines[2] = { note_columns = {} }
    patterns[1].tracks[1].lines[2].note_columns[1] = { note_value = nil }
    patterns[1].tracks[1].lines[2].note_columns[2] = { note_value = nil }
    patterns[1].tracks[1].lines[2].note_columns[3] = { note_value = nil }
    patterns[1].tracks[1].lines[3] = { note_columns = {} }
    patterns[1].tracks[1].lines[3].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[1].tracks[1].lines[3].note_columns[2] = { note_value = nil }
    patterns[1].tracks[1].lines[3].note_columns[3] = { note_value = nil }
    patterns[2] = {
        number_of_lines = 3,
        tracks = {}
    }
    patterns[2].tracks[1] = {
        visible_note_columns = 3,
        lines = {}
    }
    patterns[2].tracks[1].lines[1] = { note_columns = {} }
    patterns[2].tracks[1].lines[1].note_columns[1] = { note_value = 64, note_string = "E4", volume_value = 80 }
    patterns[2].tracks[1].lines[1].note_columns[2] = { note_value = nil }
    patterns[2].tracks[1].lines[1].note_columns[3] = { note_value = nil }
    patterns[2].tracks[1].lines[2] = { note_columns = {} }
    patterns[2].tracks[1].lines[2].note_columns[1] = { note_value = 53, note_string = "F3", volume_value = 80 }
    patterns[2].tracks[1].lines[2].note_columns[2] = { note_value = 67, note_string = "G4", volume_value = 80 }
    patterns[2].tracks[1].lines[2].note_columns[3] = { note_value = 67, note_string = "G4", volume_value = 80 }
    patterns[2].tracks[1].lines[3] = { note_columns = {} }
    patterns[2].tracks[1].lines[3].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[2].tracks[1].lines[3].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[2].tracks[1].lines[3].note_columns[3] = { note_value = nil }
    patterns[3] = {
        number_of_lines = 3,
        tracks = {}
    }
    patterns[3].tracks[1] = {
        visible_note_columns = 3,
        lines = {}
    }
    patterns[3].tracks[1].lines[1] = { note_columns = {} }
    patterns[3].tracks[1].lines[1].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[3].tracks[1].lines[1].note_columns[2] = { note_value = nil }
    patterns[3].tracks[1].lines[1].note_columns[3] = { note_value = nil }
    patterns[3].tracks[1].lines[2] = { note_columns = {} }
    patterns[3].tracks[1].lines[2].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[3].tracks[1].lines[2].note_columns[2] = { note_value = nil }
    patterns[3].tracks[1].lines[2].note_columns[3] = { note_value = nil }
    patterns[3].tracks[1].lines[3] = { note_columns = {} }
    patterns[3].tracks[1].lines[3].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[3].tracks[1].lines[3].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[3].tracks[1].lines[3].note_columns[3] = { note_value = 45, note_string = "A2", volume_value = 80 }
    patterns[4] = {
        number_of_lines = 3,
        tracks = {}
    }
    patterns[4].tracks[1] = {
        visible_note_columns = 3,
        lines = {}
    }
    patterns[4].tracks[1].lines[1] = { note_columns = {} }
    patterns[4].tracks[1].lines[1].note_columns[1] = { note_value = nil }
    patterns[4].tracks[1].lines[1].note_columns[2] = { note_value = nil }
    patterns[4].tracks[1].lines[1].note_columns[3] = { note_value = nil }
    patterns[4].tracks[1].lines[2] = { note_columns = {} }
    patterns[4].tracks[1].lines[2].note_columns[1] = { note_value = 59, note_string = "B3", volume_value = 80 }
    patterns[4].tracks[1].lines[2].note_columns[2] = { note_value = nil }
    patterns[4].tracks[1].lines[2].note_columns[3] = { note_value = nil }
    patterns[4].tracks[1].lines[3] = { note_columns = {} }
    patterns[4].tracks[1].lines[3].note_columns[1] = { note_value = nil }
    patterns[4].tracks[1].lines[3].note_columns[2] = { note_value = nil }
    patterns[4].tracks[1].lines[3].note_columns[3] = { note_value = nil }
    local song = {
        selected_track_index = 1,
        selected_sequence_index = 1,
        patterns = patterns,
        sequencer = {
            pattern_sequence = {}
        },
        transport = {
           edit_pos = {
               line = 1
           }
       },
       tracks = {}
    }
    song.tracks[1] = { visible_note_columns = 3}
    song.tracks[2] = { visible_note_columns = 3}
    song.tracks[3] = { visible_note_columns = 3}
    song.tracks[4] = { visible_note_columns = 3}
    song.sequencer.pattern_sequence[1] = 1
    song.sequencer.pattern_sequence[2] = 2
    song.sequencer.pattern_sequence[3] = 3
    song.sequencer.pattern_sequence[4] = 4

    local sequence_index = song.selected_sequence_index
    local track_index = song.selected_track_index
    local line_index = song.transport.edit_pos.line
    local position = position_key(sequence_index, line_index)
    local lines = find_lines_of_interest(song, track_index, position)
    local count, first, last = line_statistics(lines)

    assert(count == MAX_LINES, "Expected "..MAX_LINES..", but got "..count.." lines")
    assert(first.sequence == 1 and first.line == 1, "Expected first sequence/ line to be 1/1, but got "..dump(first))
    assert(last.sequence == 2 and last.line == 2, "Expected last sequence/ line to be 3/3, but got "..dump(last))
    test_log("Successfully verified search for lines of interest (minimum)")

    local view = create_view(song, lines)
    assert(view.complete == true, "Expected view contain a complete set of notes")

    assert_vertical_interval(view.notes,  12, 1, 1)
    assert_vertical_interval(view.notes, nil, 1, 2)
    assert_vertical_interval(view.notes, nil, 1, 3)

    assert_vertical_interval(view.notes,  12, 2, 1)
    assert_vertical_interval(view.notes,  nil, 2, 2)
    assert_vertical_interval(view.notes, nil, 2, 3)

    assert_vertical_interval(view.notes, -11, 3, 1)
    assert_vertical_interval(view.notes,  12, 3, 2)
    assert_vertical_interval(view.notes,  10, 3, 3)

    assert_vertical_interval(view.notes, nil, 4, 1)
    assert_vertical_interval(view.notes, nil, 4, 2)
    assert_vertical_interval(view.notes, nil, 4, 3)

    assert_horizontal_interval(view.notes, 15 , 1, 1)
    assert_horizontal_interval(view.notes, 2  , 1, 2)
    assert_horizontal_interval(view.notes, nil, 1, 3)

    assert_horizontal_interval(view.notes, nil, 2, 1)
    assert_horizontal_interval(view.notes, nil, 2, 2)
    assert_horizontal_interval(view.notes, nil, 2, 3)

    assert_horizontal_interval(view.notes, nil, 3, 1)
    assert_horizontal_interval(view.notes, nil, 3, 2)
    assert_horizontal_interval(view.notes, nil, 3, 3)

    assert_horizontal_interval(view.notes,  14, 4, 1)
    assert_horizontal_interval(view.notes,   0, 4, 2)
    assert_horizontal_interval(view.notes, nil, 4, 3)

    check_counterpoint(view)
    test_log("Counterpoint: "..dump(view.counterpoint))
    assert(view.counterpoint.details == "12-12 ", "Expected '12-12', but got '"..view.counterpoint.details.."'")

end

-- This test is expected to find intervals for each column right away with the first two rows
-- and essentially checks if adding additional lines before and after these two lines works,
-- as the number of rows to be displayed is assumed to be four (see settings)
local function test_find_lines_of_interest_additional()
    local patterns = {}
    patterns[1] = {
        number_of_lines = 3,
        tracks = {}
    }
    patterns[1].tracks[1] = {
        visible_note_columns = 3,
        lines = {}
    }
    patterns[1].tracks[1].lines[1] = { note_columns = {} }
    patterns[1].tracks[1].lines[1].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[1].tracks[1].lines[1].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[1].tracks[1].lines[1].note_columns[3] = { note_value = 57, note_string = "A3", volume_value = 80 }
    patterns[1].tracks[1].lines[2] = { note_columns = {} }
    patterns[1].tracks[1].lines[2].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[1].tracks[1].lines[2].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[1].tracks[1].lines[2].note_columns[3] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[1].tracks[1].lines[3] = { note_columns = {} }
    patterns[1].tracks[1].lines[3].note_columns[1] = { note_value = nil }
    patterns[1].tracks[1].lines[3].note_columns[2] = { note_value = nil }
    patterns[1].tracks[1].lines[3].note_columns[3] = { note_value = nil }
    patterns[2] = {
        number_of_lines = 3,
        tracks = {}
    }
    patterns[2].tracks[1] = {
        visible_note_columns = 3,
        lines = {}
    }
    patterns[2].tracks[1].lines[1] = { note_columns = {} }
    patterns[2].tracks[1].lines[1].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[2].tracks[1].lines[1].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[2].tracks[1].lines[1].note_columns[3] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[2].tracks[1].lines[2] = { note_columns = {} }
    patterns[2].tracks[1].lines[2].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[2].tracks[1].lines[2].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[2].tracks[1].lines[2].note_columns[3] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[2].tracks[1].lines[3] = { note_columns = {} }
    patterns[2].tracks[1].lines[3].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[2].tracks[1].lines[3].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[2].tracks[1].lines[3].note_columns[3] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[3] = {
        number_of_lines = 3,
        tracks = {}
    }
    patterns[3].tracks[1] = {
        visible_note_columns = 3,
        lines = {}
    }
    patterns[3].tracks[1].lines[1] = { note_columns = {} }
    patterns[3].tracks[1].lines[1].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[3].tracks[1].lines[1].note_columns[2] = { note_value = nil }
    patterns[3].tracks[1].lines[1].note_columns[3] = { note_value = nil }
    patterns[3].tracks[1].lines[2] = { note_columns = {} }
    patterns[3].tracks[1].lines[2].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[3].tracks[1].lines[2].note_columns[2] = { note_value = nil }
    patterns[3].tracks[1].lines[2].note_columns[3] = { note_value = nil }
    patterns[3].tracks[1].lines[3] = { note_columns = {} }
    patterns[3].tracks[1].lines[3].note_columns[1] = { note_value = 52, note_string = "E3", volume_value = 80 }
    patterns[3].tracks[1].lines[3].note_columns[2] = { note_value = 55, note_string = "G3", volume_value = 80 }
    patterns[3].tracks[1].lines[3].note_columns[3] = { note_value = 57, note_string = "A3", volume_value = 80 }
    patterns[4] = {
        number_of_lines = 3,
        tracks = {}
    }
    patterns[4].tracks[1] = {
        visible_note_columns = 3,
        lines = {}
    }
    patterns[4].tracks[1].lines[1] = { note_columns = {} }
    patterns[4].tracks[1].lines[1].note_columns[1] = { note_value = nil }
    patterns[4].tracks[1].lines[1].note_columns[2] = { note_value = nil }
    patterns[4].tracks[1].lines[1].note_columns[3] = { note_value = nil }
    patterns[4].tracks[1].lines[2] = { note_columns = {} }
    patterns[4].tracks[1].lines[2].note_columns[1] = { note_value = 59, note_string = "B3", volume_value = 80 }
    patterns[4].tracks[1].lines[2].note_columns[2] = { note_value = nil }
    patterns[4].tracks[1].lines[2].note_columns[3] = { note_value = nil }
    patterns[4].tracks[1].lines[3] = { note_columns = {} }
    patterns[4].tracks[1].lines[3].note_columns[1] = { note_value = nil }
    patterns[4].tracks[1].lines[3].note_columns[2] = { note_value = nil }
    patterns[4].tracks[1].lines[3].note_columns[3] = { note_value = nil }
    local song = {
        selected_track_index = 1,
        selected_sequence_index = 1,
        patterns = patterns,
        sequencer = {
            pattern_sequence = {}
        },
        transport = {
            edit_pos = {
                line = 3
            }
        },
        tracks = {}
    }
    song.tracks[1] = { visible_note_columns = 3}
    song.tracks[2] = { visible_note_columns = 3}
    song.tracks[3] = { visible_note_columns = 3}
    song.tracks[4] = { visible_note_columns = 3}
    song.sequencer.pattern_sequence[1] = 1
    song.sequencer.pattern_sequence[2] = 2
    song.sequencer.pattern_sequence[3] = 3
    song.sequencer.pattern_sequence[4] = 4

    local sequence_index = song.selected_sequence_index
    local pattern_index = song.sequencer.pattern_sequence[sequence_index]
    local track_index = song.selected_track_index
    local pattern_track = song.patterns[pattern_index].tracks[track_index]
    local line_index = song.transport.edit_pos.line
    local track = song.tracks[track_index]
    local position = position_key(sequence_index, line_index)
    local lines = find_lines_of_interest(song, track_index, position)
    local count, first, last = line_statistics(lines)

    assert(count == MAX_LINES, "Expected "..MAX_LINES..", but got "..count.." lines")
    assert(first.sequence == 1 and first.line == 1, "Expected first sequence/ line to be 1/1, but got "..dump(first))
    assert(last.sequence == 2 and last.line == 2, "Expected last sequence/ line to be 2/2, but got "..dump(last))
    test_log("Successfully verified search for lines of interest (additional)")
end

--  ___ ____ ____ ___    ____ _  _ ____ ____ _  _ ___ _ ____ _  _
--   |  |___ [__   |     |___  \/  |___ |    |  |  |  | |  | |\ |
--   |  |___ ___]  |     |___ _/\_ |___ |___ |__|  |  | |__| | \|
--

test_find_lines_of_interest_minimum()
test_find_lines_of_interest_additional()
test_order_comparison()
test_volume_percentage()
test_schildkraut()
test_equal_temperament()
test_sixth_comma_frequencies()
test_kirnberger3_frequencies()
test_werckmeister3_frequencies()
test_pythagorean_frequencies()
test_pythagorean_wolf_fifth()
test_pure_intervals()
test_approximation()
