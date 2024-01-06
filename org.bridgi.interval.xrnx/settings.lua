--  ____ ____ ___ ___ _ _  _ ____ ____
--  [__  |___  |   |  | |\ | | __ [__
--  ___] |___  |   |  | | \| |__] ___]

settings = renoise.Document.create("IntervalCalculatorSettings") {
    view_type              =   1,
    language               = "en",
    max_delta              =  13,
    max_lines              =   8,
    dissonance_threshold_1 =   3.5,
    dissonance_threshold_2 =   6.5,
    dissonance_threshold_3 =  11.0,
    hearing_threshold      =   0.004,
    tuning                 =   1,
    tuning_note            =   3,
    pitch                  = 440,
    volume_reduction       =   0.20,
    tracks                 =   2,
    chord_calculation      = true
}
