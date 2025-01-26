interval_texts_short={}
interval_texts_short["de"]={"r1",
                            "k2",
                            "g2",
                            "k3",
                            "g3",
                            "r4",
                            "tt",
                            "r5",
                            "k6",
                            "g6",
                            "k7",
                            "g7",
                            "r8",
                            "k9",
                            "g9",
                            "k10",
                            "g11",
                            "r11",
                            "g11",
                            "r12",
                            "k13",
                            "g13",
                            "k14",
                            "g14",
                            "r15"}

interval_texts_short["en"]={"P1",
                            "m2",
                            "M2",
                            "m3",
                            "M3",
                            "P4",
                            "TT",
                            "P5",
                            "m6",
                            "M6",
                            "m7",
                            "M7",
                            "P8",
                            "m9",
                            "M9",
                            "m10",
                            "M10",
                            "P11",
                            "A11",
                            "P12",
                            "m13",
                            "M13",
                            "m14",
                            "M14",
                            "P15"}

interval_texts_long={}
interval_texts_long["de"]={"Prime\n",
                           "Kleine\nSekunde",
                           "Große\nSekunde",
                           "Kleine\nTerz",
                           "Große\nTerz",
                           "Reine\nQuarte",
                           "Tritonus\n",
                           "Reine\nQuinte",
                           "Kleine\nSexte",
                           "Große\nSexte",
                           "Kleine\nSeptime",
                           "Große\nSeptime",
                           "Reine\nOktave",
                           "Kleine\nNone",         -- 13
                           "Große\nNone",          -- 14
                           "Kleine\nDezime",       -- 15
                           "Große\nDezime",        -- 16
                           "Reine\nUndezime",      -- 17 Quarte
                           "Übermäßige\nUndezime", -- 18
                           "Duodezime\n",          -- 19 Quinte
                           "Kleine\nTredezime",    -- 20
                           "Große\nTredezime",     -- 21
                           "Kleine\nQuartdezime",  -- 22
                           "Große\nQuartdezime",   -- 23
                           "Quindezime\n"  }       -- 24

interval_texts_long["en"]={"Prime\n",
                           "Minor\nsecond",
                           "Major\nsecond",
                           "Minor\nthird",
                           "Major\nthird",
                           "Perfect\nfourth",
                           "Tritone\n",
                           "Perfect\nfifth",
                           "Minor\nsixth",
                           "Major\nsixth",
                           "Minor\nseventh",
                           "Major\nseventh",
                           "Perfect\noctave",
                           "Minor\nninth",
                           "Major\nninth",
                           "Minor\ntenth",
                           "Major\ntenth",
                           "Perfect\neleventh",
                           "Major\neleventh",
                           "Twelfth\n",
                           "Minor\nthirteenth",
                           "Major\nthirteenth",
                           "Minor\nforteenth",
                           "Major\nforteenth",
                           "Fifteenth\n"}

interval_texts={}
interval_texts["de"]={"Prime",
                      "Kl. Sekunde",
                      "Gr. Sekunde",
                      "Kl. Terz",
                      "Gr. Terz",
                      "Quarte",
                      "Tritonus",
                      "Quinte",
                      "Kl. Sexte",
                      "Gr. Sexte",
                      "Kl. Septime",
                      "Gr. Septime",
                      "Oktave",
                      "Kl. None",         -- 13
                      "Gr. None",         -- 14
                      "Kl. Dezime",       -- 15
                      "Gr. Dezime",       -- 16
                      "Undezime",        -- 17 Quarte
                      "Über. Undez.",     -- 18
                      "Duodezime",       -- 19 Quinte
                      "Kl. Tredezime",    -- 20
                      "Gr. Tredezime",    -- 21
                      "Kl. Quartdez.",    -- 22
                      "Gr. Quartdez.",    -- 23
                      "Quindezime"  }    -- 24

interval_texts["en"]={"Prime",
                      "Min. second",
                      "Maj. second",
                      "Min. third",
                      "Maj. third",
                      "Fourth",
                      "Tritone",
                      "Fifth",
                      "Min. sixth",
                      "Maj. sixth",
                      "Min. seventh",
                      "Maj. seventh",
                      "Octave",
                      "Min. ninth",
                      "Maj. ninth",
                      "Min. tenth",
                      "Maj. tenth",
                      "Eleventh",
                      "Maj. eleventh",
                      "Twelfth",
                      "Min. thirteenth",
                      "Maj. thirteenth",
                      "Min. fourteenth",
                      "Maj. fourteenth",
                      "Fifteenth"}

interval_colors={}

interval_colors["classical"]={
    {0xFF, 0xFF, 0xFF}, -- 0 Halbtonschritte (Prime): Weiß (Neutralität, Einheit)
    {0xAA, 0x33, 0x33}, -- 1 Halbton (kleine Sekunde): Dunkelrot (Spannung, Disharmonie)
    {0xFF, 0x66, 0x66}, -- 2 Halbtöne (große Sekunde): Hellrot (Leichte Spannung, Bewegung)
    {0xFF, 0xAA, 0x66}, -- 3 Halbtöne (kleine Terz): Orange (Wärme, Nähe)
    {0xFF, 0xDD, 0x66}, -- 4 Halbtöne (große Terz): Gelb (Helligkeit, Harmonie)
    {0x66, 0xFF, 0x66}, -- 5 Halbtöne (reine Quarte): Grün (Aufbruch, Stabilität)
    {0x33, 0x33, 0xFF}, -- 6 Halbtöne (Tritonus): Blau (Spannung, Dunkelheit)
    {0x66, 0xFF, 0xAA}, -- 7 Halbtöne (reine Quinte): Türkis (Harmonie, Klarheit)
    {0xFF, 0xCC, 0xFF}, -- 8 Halbtöne (kleine Sexte): Rosa (Melancholie, Sanftheit)
    {0xFF, 0x99, 0xCC}, -- 9 Halbtöne (große Sexte): Violett (Erhabenheit, Romantik)
    {0xAA, 0x33, 0x99}, -- 10 Halbtöne (kleine Septime): Dunkelviolett (Spannung, Erwartung)
    {0x33, 0x00, 0x66}, -- 11 Halbtöne (große Septime): Dunkelblauviolett (Dringlichkeit, Instabilität)
    {0xFF, 0xFF, 0x00}, -- 12 Halbtöne (Oktave): Gelb (Vollendung, Einheit)
    {0xFF, 0xAA, 0xFF}, -- 13 Halbtöne (kleine None): Lila (Milde Spannung, Weite)
    {0xFF, 0xFF, 0x99}, -- 14 Halbtöne (große None): Hellgelb (Leichte Öffnung, Wärme)
    {0x99, 0xFF, 0x66}, -- 15 Halbtöne (kleine Dezime): Hellgrün (Optimismus, Nähe)
    {0x66, 0xFF, 0x33}, -- 16 Halbtöne (große Dezime): Intensivgrün (Stabilität, Harmonie)
    {0x33, 0x99, 0xFF}, -- 17 Halbtöne (reine Undezime): Hellblau (Weite, Offenheit)
    {0x00, 0x66, 0xFF}, -- 18 Halbtöne (übermäßige Undezime): Tiefblau (Spannung, Sehnsucht)
    {0xCC, 0x66, 0xFF}, -- 19 Halbtöne (Duodezime): Violett (Erhabenheit, Bewegung)
    {0x99, 0x33, 0xCC}, -- 20 Halbtöne (kleine Tredezime): Dunkelviolett (Melancholie, Schwere)
    {0x33, 0x00, 0x99}, -- 21 Halbtöne (große Tredezime): Tiefviolett (Tiefe, Ausdruck)
    {0x66, 0x33, 0x00}, -- 22 Halbtöne (kleine Quartdezime): Braun (Erdung, Schwere)
    {0xFF, 0x99, 0x00}, -- 23 Halbtöne (große Quartdezime): Orange (Offenheit, Wärme)
    {0xFF, 0x66, 0x00}, -- 24 Halbtöne (Quindezime): Tieforange (Energie, Vollendung)
}

interval_colors["tension"] = {
    {0xCC, 0xCC, 0xCC}, -- 0 Halbtonschritte (Prime): Hellgrau (Neutralität)
    {0xFF, 0x00, 0x00}, -- 1 Halbton (kleine Sekunde): Rot (Disharmonie)
    {0xFF, 0x66, 0x33}, -- 2 Halbtöne (große Sekunde): Orange-Rot (Bewegung)
    {0xFF, 0x99, 0x00}, -- 3 Halbtöne (kleine Terz): Gold (Wärme)
    {0xFF, 0xFF, 0x00}, -- 4 Halbtöne (große Terz): Gelb (Strahlkraft)
    {0x33, 0xCC, 0x33}, -- 5 Halbtöne (reine Quarte): Grün (Stabilität)
    {0x00, 0x00, 0x99}, -- 6 Halbtöne (Tritonus): Dunkelblau (Spannung)
    {0x33, 0xFF, 0xFF}, -- 7 Halbtöne (reine Quinte): Cyan (Reinheit)
    {0xFF, 0x99, 0xFF}, -- 8 Halbtöne (kleine Sexte): Rosa (Sanftheit)
    {0xCC, 0x33, 0x99}, -- 9 Halbtöne (große Sexte): Purpur (Erhabenheit)
    {0x99, 0x00, 0x33}, -- 10 Halbtöne (kleine Septime): Tiefrot (Spannung)
    {0x00, 0x33, 0x66}, -- 11 Halbtöne (große Septime): Dunkelblau-Grün (Instabilität)
    {0xCC, 0xCC, 0x00}, -- 12 Halbtöne (Oktave): Dunkelgelb (Vollendung)
    {0x99, 0x33, 0x99}, -- 13 Halbtöne (kleine None): Dunkelrosa (Spannung)
    {0xFF, 0xFF, 0x66}, -- 14 Halbtöne (große None): Hellgelb (Öffnung)
    {0x66, 0xCC, 0x66}, -- 15 Halbtöne (kleine Dezime): Hellgrün (Frische)
    {0x00, 0x99, 0x33}, -- 16 Halbtöne (große Dezime): Dunkelgrün (Harmonie)
    {0x66, 0x99, 0xFF}, -- 17 Halbtöne (reine Undezime): Himmelblau (Weite)
    {0x00, 0x33, 0x99}, -- 18 Halbtöne (übermäßige Undezime): Tiefblau (Sehnsucht)
    {0x99, 0x33, 0xCC}, -- 19 Halbtöne (Duodezime): Violett (Erhabenheit)
    {0x66, 0x00, 0x99}, -- 20 Halbtöne (kleine Tredezime): Tiefviolett (Intensität)
    {0x33, 0x00, 0x66}, -- 21 Halbtöne (große Tredezime): Dunkelviolett (Ausdruck)
    {0x99, 0x66, 0x33}, -- 22 Halbtöne (kleine Quartdezime): Braun (Erdung)
    {0xFF, 0x66, 0x00}, -- 23 Halbtöne (große Quartdezime): Orange (Wärme)
    {0xCC, 0x33, 0x00}, -- 24 Halbtöne (Quindezime): Dunkelorange (Energie)
}

interval_colors["intuitive"] = {
    {0xFF, 0xFF, 0xFF}, -- Weiß (Reinheit, Identität)
    {0x80, 0x00, 0x00}, -- Dunkelrot (Spannung)
    {0xFF, 0x80, 0x00}, -- Orange (Leichte Bewegung)
    {0x80, 0x40, 0x00}, -- Braun (Melancholie)
    {0xFF, 0xC0, 0x00}, -- Gold (Freude)
    {0x00, 0x80, 0x00}, -- Grün (Aufbruch, Stabilität)
    {0x00, 0x00, 0x00}, -- Schwarz (Spannung, Dissonanz)
    {0x00, 0x80, 0x80}, -- Türkis (Harmonie)
    {0x80, 0x00, 0x40}, -- Dunkelviolett (Sehnsucht)
    {0xC0, 0xFF, 0x00}, -- Hellgrün (Wärme, Offenheit)
    {0x80, 0x00, 0x80}, -- Violett (Spannung, Dramatik)
    {0xFF, 0x00, 0xFF}, -- Magenta (Intensität)
    {0xFF, 0xFF, 0xFF}, -- Weiß (Vollkommenheit)
    {0x80, 0x00, 0x00}, -- Dunkelrot (wie kleine Sekunde)
    {0xFF, 0x80, 0x00}, -- Orange (wie große Sekunde)
    {0x80, 0x40, 0x00}, -- Braun (wie kleine Terz)
    {0xFF, 0xC0, 0x00}, -- Gold (wie große Terz)
    {0x00, 0x80, 0x00}, -- Grün (wie reine Quarte)
    {0x00, 0x00, 0x00}, -- Schwarz (wie Tritonus)
    {0x00, 0x80, 0x80}, -- Türkis (wie reine Quinte)
    {0x80, 0x00, 0x40}, -- Dunkelviolett (wie kleine Sexte)
    {0xC0, 0xFF, 0x00}, -- Hellgrün (wie große Sexte)
    {0x80, 0x00, 0x80}, -- Violett (wie kleine Septime)
    {0xFF, 0x00, 0xFF}, -- Magenta (wie große Septime)
    {0xFF, 0xFF, 0xFF}, -- Weiß (wie Oktave)
}

interval_colors["contrast"] = {
    {0x00, 0x00, 0x00},
    {0xFF, 0x00, 0x00},
    {0xFF, 0x80, 0x00},
    {0xFF, 0xFF, 0x00},
    {0x80, 0xFF, 0x00},
    {0x00, 0xFF, 0x00},
    {0x00, 0x80, 0x80},
    {0x00, 0x00, 0xFF},
    {0x80, 0x00, 0x80},
    {0xFF, 0x00, 0xFF},
    {0xFF, 0x00, 0x80},
    {0xC0, 0xC0, 0xC0},
    {0xFF, 0xFF, 0xFF},
    {0xFF, 0x40, 0x40},
    {0xFF, 0xA0, 0x40},
    {0xFF, 0xFF, 0x80},
    {0xA0, 0xFF, 0x40},
    {0x40, 0xFF, 0xA0},
    {0x40, 0xA0, 0xFF},
    {0xA0, 0x40, 0xFF},
    {0xFF, 0x40, 0xFF},
    {0xFF, 0x80, 0xFF},
    {0xFF, 0xC0, 0xFF},
    {0xE0, 0xE0, 0xE0},
    {0xFF, 0xFF, 0xFF}
}

octave_texts={}
octave_texts["de"]="Oktave(n)"
octave_texts["en"]="octave(s)"

effect_texts={}
effect_texts["de"]={"Weichheit\nHalt",
                    "Melancholie\nschüchtern",
                    "Neutral\nSehnsucht",
                    "ernst\nWeichheit",
                    "ruhig\nFreude",
                    "Hymne\nAuftakt",
                    "Unheil\ndüster",
                    "Leere\nUmfang",
                    "traurig\nunsicher",
                    "Hell\ngewinnend",
                    "Unerfüllt\nRomantik",
                    "Ambition\nhart",
                    "Leichtigkeit\ntragend"}
effect_texts["en"]={"Softness\nCohesion",
                    "Melancholy\nShyness",
                    "Neutrality\nLonging",
                    "serious\nsoft",
                    "calm\njoy",
                    "Hymn\nStart",
                    "Mischief\ndark",
                    "Emptiness\nSpace",
                    "pleasant\nuncertain",
                    "Bright\nWinning",
                    "Unfulfilled\nRomance",
                    "Ambition\nharsh",
                    "Lightness\nbearing"}

effect_texts_long={}
effect_texts_long["de"]={"Weichheit,\nFriede,\nHalt",
                         "unzufrieden,\nMelancholie,\nschüchtern",
                         "Neutral,\nSehnsucht,\nvergänglich",
                         "ernst,\nWeichheit,\nSehnsucht",
                         "ruhig,\nmelodiös,\nFreude",
                         "Hymne,\nAuftakt,\ngebrochen",
                         "Unheil,\ndüster,\nGefahr",
                         "Leere,\nUmfang,\nSanftheit",
                         "angenehm,\ntraurig,\nunsicher",
                         "Hell,\nSehnsucht,\ngewinnend",
                         "Unerfüllt,\nRomantik,\nleer",
                         "Ambition,\nfinster,\nhart",
                         "Leichtigkeit,\nStärke,\ntragend"}
effect_texts_long["en"]={"Softness,\nPeace,\nCohesion",
                         "unsatisfied,\nMelancholy,\nShyness",
                         "Neutrality,\nLonging,\nTransience",
                         "Seriousness,\nSoftness,\nLonging",
                         "calm,\nmelodious,\njoy",
                         "Hymn,\nStart,\nBroken",
                         "Mischief,\ndark,\ndanger",
                         "Emptiness,\nSpace,\nSoftness",
                         "pleasant,\nsadness,\nuncertain",
                         "Bright,\nLonging,\nWinning",
                         "Unfulfilled,\nRomance,\nempty",
                         "Ambition,\nsinister,\nharsh",
                         "Lightness,\nStrength,\nbearing"}

dissonance_texts_long = {}
dissonance_texts_long["de"] = { "Starke\nKonsonanz",
                                "Unvollk.\nKonsonanz",
                                "Leichte\nDissonanz",
                                "Scharfe\nDissonanz"}
dissonance_texts_long["en"] = { "Strong\nconsonance",
                                "Imperfect\nconsonance",
                                "Slight\ndissonance",
                                "Sharp\ndissonance"}

dissonance_texts = {}
dissonance_texts["de"] = { "Konsonant",
                           "Unvollkommen",
                           "Spannend",
                           "Dissonant"}
dissonance_texts["en"] = { "Consonance",
                           "Imperfect",
                           "Tension",
                           "Dissonance"}


dissonance_omitted_texts = {}
dissonance_omitted_texts["de"] = "Nicht\nberechnet\n(Zeilen ausgelassen)"
dissonance_omitted_texts["en"] = "Not\ncalculated\n(lines omitted)"

dissonance_threshold_text = {}
dissonance_threshold_text["de"] = "Sonanz-Schwellwerte"
dissonance_threshold_text["en"] = "Sonance thresholds"

hearing_threshold_texts = {}
hearing_threshold_texts["de"] = "Hörschwelle"
hearing_threshold_texts["en"] = "Audibility"

chord_header_actual = {}
chord_header_actual["de"] = {}
chord_header_actual["en"] = {}
chord_header_actual["de"][1] = "Akkord"
chord_header_actual["en"][1] = "Chord"
chord_header_actual["de"][2] = "Ak."
chord_header_actual["en"][2] = "Ch."

chord_header_linger = {}
chord_header_linger["de"] = {}
chord_header_linger["en"] = {}
chord_header_linger["de"][1] = "Nachklang"
chord_header_linger["en"][1] = "Lingering"
chord_header_linger["de"][2] = "N."
chord_header_linger["en"][2] = "L."

settings_header = {}
settings_header["de"] = "Einstellungen"
settings_header["en"] = "Settings"

settings_interval = {}
settings_interval["de"] = {"Sonanz" , "Intervall", "Effekt", "Cents"}
settings_interval["en"] = {"Sonance", "Interval" , "Effect", "Cents"}

omitted_text = {}
omitted_text["de"] = "(Ausgelassen)\n"
omitted_text["en"] = "(Omitted)\n"

half_steps = {}
half_steps["de"] = "HT"
half_steps["en"] = "ST"

settings_tuning = {}
settings_tuning["de"] = {
    "Reine Intervalle",
    "Gleichstufig",
    "Pythagoreisch",
    "Kirnberger III",
    "Werckmeister III",
    "1/6 Mitteltönig"}
settings_tuning["en"] = {
    "Pure intervals",
    "Equal temperament",
    "Pythagorean",
    "Kirnberger III",
    "Werckmeister III",
    "1/6 Meantone"}

settings_tuning_note = {}
settings_tuning_note["de"] = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "H"}
settings_tuning_note["en"] = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}

settings_volume_reduction = {}
settings_volume_reduction["de"] = "Dämpfung*" -- Nachklang
settings_volume_reduction["en"] = "Damping*" -- Lingering

settings_matrix_size = {}
settings_matrix_size["de"] = "Zeilen*"
settings_matrix_size["en"] = "Rows*"

settings_search_rows = {}
settings_search_rows["de"] = "Suchweite*"
settings_search_rows["en"] = "Range*"

settings_chord_calc = {}
settings_chord_calc["de"] = "Akkorde*"
settings_chord_calc["en"] = "Chords*"

settings_skip_empty = {}
settings_skip_empty["de"] = "Leerzeilen*"
settings_skip_empty["en"] = "Empty lines*"

settings_pitch = {}
settings_pitch["de"] = "Kammerton a' (A4)"
settings_pitch["en"] = "Diaspon a' (A4)"

settings_search_tracks = {}
settings_search_tracks["de"] = "Spuren*"
settings_search_tracks["en"] = "Tracks*"

settings_reopen_note = {}
settings_reopen_note["de"] = "*=Fenster schließen"
settings_reopen_note["en"] = "*=Reopen window"

status_texts = {}
status_texts[STATUS_OK] = {}
status_texts[STATUS_OK]["de"] = "Ok"
status_texts[STATUS_OK]["en"] = "Ok"
status_texts[STATUS_LINES_OMITTED] = {}
status_texts[STATUS_LINES_OMITTED]["de"] = "Achtung: Einige Noten-Zeilen wurden zugunsten der Intervalldarstellung ausgelassen"
status_texts[STATUS_LINES_OMITTED]["en"] = "Pls. be aware that a few note lines were omitted in favour of displaying intervals"

counterpoint_texts = {}
counterpoint_texts[COUNTERPOINT_OK] = {}
counterpoint_texts[COUNTERPOINT_OK]["de"] = "Kontrapunkt: Keine bekannten Probleme"
counterpoint_texts[COUNTERPOINT_OK]["en"] = "Counterpoint: No known issues"
counterpoint_texts[COUNTERPOINT_PATTERN_VIOLATION] = {}
counterpoint_texts[COUNTERPOINT_PATTERN_VIOLATION]["de"] = "Kontrapunkt:  Ungültiges Intervallmuster: "
counterpoint_texts[COUNTERPOINT_PATTERN_VIOLATION]["en"] = "Counterpoint: Pattern violation: "

local function get_view(vb, id, ignore_unknown)
    ignore_unknown = ignore_unknown or false
    local view = vb.views[id]
    if not view and not ignore_unknown then
        local error_text = "Unknown view element: '"..id.."'"
        renoise.app():show_message(error_text)
        error(error_text)
    end
    return view
end

local function update_text(vb, id, text, ignore_unknown)
    local view = get_view(vb, id, ignore_unknown)
    if view then
        view.text = text
    end
end

local function update_color(vb, id, color, ignore_unknown)
    local view = get_view(vb, id, ignore_unknown)
    if view then
        view.color = color
    end
end

local function update_tooltip(vb, id, tooltip, ignore_unknown)
    local view = get_view(vb, id, ignore_unknown)
    if view then
        view.tooltip = tooltip
    end
end

local function update_items(vb, id, items)
    get_view(vb, id).items = items
end

local function dissonance_details(dissonance, settings, dialog_type)
    local language = settings.language.value
    if not dissonance then
        return dissonance_omitted_texts[language], COLOR_BLACK
    end
    local specific_dissonance = dissonance
    if not specific_dissonance then
        return dissonance_omitted_texts[language], COLOR_BLACK
    end
    local dissonance_thresholds = { settings.dissonance_threshold_1.value,
                                    settings.dissonance_threshold_2.value,
                                    settings.dissonance_threshold_3.value,
                                    math.huge }
    for i = 1, #dissonance_thresholds do
        if specific_dissonance <= dissonance_thresholds[i] then
            if dialog_type == DIALOG_CONDENSED then
                return dissonance_texts[language][i].."\n"..string.format("%.2f", specific_dissonance).."", DISSONANCE_COLORS[i]
            else
                return string.format("%.2f", specific_dissonance), DISSONANCE_COLORS[i]
            end
        end
    end
    return nil, COLOR_BLACK
end

local function interval_text(language, interval, dialog_type)
    local function display_interval(delta)
        return (delta >= 13 and delta <= 24) and delta or interval.interval -- Additional intervals Ninth...Fifteenth
    end
    local i = display_interval(math.abs(interval.halftones)) + 1
    return dialog_type == DIALOG_CONDENSED
            and interval_texts[language][i].."\n"..tostring(interval.halftones).." "..half_steps[language]
             or interval_texts_short[language][i].." ("..tostring(interval.halftones)..")"
end

local function effect_text(language, interval, dialog_type)
    if dialog_type ~= DIALOG_CONDENSED then
        return " ", " "
    end
    local function display_interval(delta)
        return (delta <= 12) and delta or interval.interval -- Additional intervals Ninth...Fifteenth
    end
    local i = display_interval(math.abs(interval.halftones)) + 1
    return effect_texts[language][i]
end

local function effect_color(language, interval, dialog_type)
    if dialog_type == DIALOG_CONDENSED then
        return nil
    end
    local function display_interval(delta)
        return (delta <= 12) and delta or interval.interval -- Additional intervals Ninth...Fifteenth
    end
    local i = display_interval(math.abs(interval.halftones)) + 1
    return interval_colors["classical"][i]
end

local function cents_text(properties, dialog_type)
    if properties.cents then
        return dialog_type == DIALOG_CONDENSED and string.format("%.0f\nCents", properties.cents) or string.format("%.0f", properties.cents)
    else
        return dialog_type == DIALOG_CONDENSED and "\n---" or "-"
    end
end

local function chords_displayed(vb, data, settings)
    return data.status ~= STATUS_LINES_OMITTED
           and
           settings.chord_calculation.value
           and
           vb.views[ID_HEADER_CHORD_ACTUAL] -- Takes into account that the window has to be re-opened for these view elements
end

local function update_interval(vb, data, settings, dialog_type)
    local language       = settings.language.value
    local view_type      = settings.view_type.value
    local view           = data.view
    local display_chords = chords_displayed(vb, data, settings)
    local row_count      = #view
    local column_count   = #view[1] - (display_chords and 0 or 2)
    for row = 1, row_count do
        for column = 1, column_count do
            local view_id = ID_ELEMENT.. row ..".".. column
            local element = view[row][column]
            if element.type == "data" and element.data then
                local interval = element.data
                local dissonance, properties
                if not interval.chord then
                    properties = interval:properties()
                    dissonance = properties.dissonance
                else
                    if type(interval.chord) == "function" then
                        local wrapper = interval.chord
                        if wrapper then
                            dissonance = wrapper()
                        end
                    end
                end
                if dissonance then
                    local dissonance_text, dissonance_color = dissonance_details(dissonance, settings, dialog_type)
                    if     view_type == 1 or interval.chord then
                        update_text (vb, view_id, dissonance_text )
                        update_color(vb, view_id, dissonance_color)
                    elseif view_type == 2 then
                        update_text (vb, view_id, interval_text(language, interval, dialog_type))
                        update_color(vb, view_id, dissonance_color)
                    elseif view_type == 3 then
                        update_text (vb, view_id, effect_text  (language, interval, dialog_type))
                        local color = effect_color(language, interval, dialog_type)
                        update_color(vb, view_id, color and color or effect_color(language, interval, dialog_type))
                    elseif view_type == 4 then
                        update_text (vb, view_id, cents_text   (properties, dialog_type))
                        update_color(vb, view_id, dissonance_color)
                    end
                end
                -- Check for violations property and update separator color
                if interval.violations then
                    local separator_id = ID_SEPARATOR..row.."."..column
                    update_color  (vb, separator_id, COLOR_STATUS_WARNING)
                    update_tooltip(vb, separator_id, interval.violations)
                end
            end
            if element.type == "data" and not element.data and element.direction == "vertical" and element.gap then
                update_text (vb, view_id, omitted_text[language])
                update_color(vb, view_id, COLOR_STATUS_WARNING_INTERVAL)
            end

        end
    end
end

function update_interface(vb, settings, data)
    local dialog_type       = data.dialog_type
    local language          = settings.language.value

    if chords_displayed(vb, data, settings) then
        update_text(vb, ID_HEADER_CHORD_ACTUAL          , chord_header_actual      [language][dialog_type])
        update_text(vb, ID_HEADER_CHORD_LINGER          , chord_header_linger      [language][dialog_type])
    end
    update_text    (vb, ID_SETTINGS_DISSONANCE_THRESHOLD, dissonance_threshold_text[language])
    update_text    (vb, ID_SETTINGS_HEARING_THRESHOLD   , hearing_threshold_texts  [language])
    update_text    (vb, ID_SETTINGS_VOLUME_REDUCTION    , settings_volume_reduction[language])
    update_text    (vb, ID_SETTINGS_PITCH               , settings_pitch           [language])
    update_text    (vb, ID_SETTINGS_MATRIX_SIZE         , settings_matrix_size     [language])
    update_text    (vb, ID_SETTINGS_SEARCH_ROWS         , settings_search_rows     [language])
    update_text    (vb, ID_SETTINGS_TRACKS              , settings_search_tracks   [language])
    update_text    (vb, ID_SETTINGS_CHORD_CALC          , settings_chord_calc      [language])
    update_text    (vb, ID_SETTINGS_SKIP_EMPTY          , settings_skip_empty      [language])
    update_text    (vb, ID_SETTINGS_REOPEN_NOTE         , settings_reopen_note     [language])
    update_items   (vb, ID_SETTINGS_INTERVAL            , settings_interval        [language])
    update_items   (vb, ID_SETTINGS_TUNING              , settings_tuning          [language])
    update_items   (vb, ID_SETTINGS_TUNING_NOTE         , settings_tuning_note     [language])
    if language == "de" then vb.views.popup_language.value = 1
                        else vb.views.popup_language.value = 2
    end
    update_interval(vb, data, settings, dialog_type)

    -- Disable irrelevant controls for pure intervals
    if settings.tuning.value == 1 then
        get_view(vb, ID_SETTINGS_PITCH_VALUE            ).active = false
        get_view(vb, ID_SETTINGS_HEARING_THRESHOLD_VALUE).active = false
        get_view(vb, ID_SETTINGS_TUNING_NOTE            ).active = false
    elseif settings.tuning.value == 2 then
        get_view(vb, ID_SETTINGS_PITCH_VALUE            ).active = true
        get_view(vb, ID_SETTINGS_HEARING_THRESHOLD_VALUE).active = true
        get_view(vb, ID_SETTINGS_TUNING_NOTE            ).active = false
    else
        get_view(vb, ID_SETTINGS_PITCH_VALUE            ).active = true
        get_view(vb, ID_SETTINGS_HEARING_THRESHOLD_VALUE).active = true
        get_view(vb, ID_SETTINGS_TUNING_NOTE            ).active = true
    end
end
