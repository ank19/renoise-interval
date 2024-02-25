require 'constants'

--  ____ ____ ___ ___ _ _  _ ____ ____
--  [__  |___  |   |  | |\ | | __ [__
--  ___] |___  |   |  | | \| |__] ___]

settings = renoise.Document.create("IntervalCalculatorSettings") {
    view_type              =   1,
    dialog_type            =   1,
    language               = "en",
    dissonance_threshold_1 =   3.5,
    dissonance_threshold_2 =   6.5,
    dissonance_threshold_3 =  11.0,
    hearing_threshold      =   0.004,
    tuning                 =   1,
    tuning_note            =   3,
    pitch                  = 440,
    volume_reduction       =   0.20,
    tracks_condensed       =   2,
    delta_condensed        =  20,
    lines_condensed        =   8,
    tracks_compact         =   3,
    delta_compact          =  64,
    lines_compact          =  24,
    chord_calculation      = true,
    skip_empty_compact     = true
}

-- Return number of tracks to be scanned for analysis
function settings_tracks()
    return settings.dialog_type.value == DIALOG_CONDENSED and settings.tracks_condensed or settings.tracks_compact
end

-- Return number of lines to be searched for relevant note columns
function settings_delta()
    return settings.dialog_type.value == DIALOG_CONDENSED and settings.delta_condensed or settings.delta_compact
end

-- Return number of lines to be displayed
function settings_lines()
    return settings.dialog_type.value == DIALOG_CONDENSED and settings.lines_condensed or settings.lines_compact
end
