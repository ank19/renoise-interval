interval_texts={}
interval_texts["de"]={"Prime\n",
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

interval_texts["en"]={"Prime\n",
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

octave_texts={}
octave_texts["de"]="Oktave(n)"
octave_texts["en"]="octave(s)"

effect_texts={}
effect_texts["de"]={"Weichheit,\nFriede,\nHalt",
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
effect_texts["en"]={"Softness,\nPeace,\nCohesion",
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

dissonance_texts = {}
dissonance_texts["de"] = { "Starke\nKonsonanz",
                           "Unvollk.\nKonsonanz",
                           "Leichte\nDissonanz",
                           "Scharfe\nDissonanz"}
dissonance_texts["en"] = { "Strong\nconsonance",
                           "Imperfect\nconsonance",
                           "Slight\ndissonance",
                           "Sharp\ndissonance"}

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
chord_header_actual["de"] = "Akkord"
chord_header_actual["en"] = "Chord"

chord_header_linger = {}
chord_header_linger["de"] = "Nachklang"
chord_header_linger["en"] = "Lingering"

settings_header = {}
settings_header["de"] = "Einstellungen"
settings_header["en"] = "Settings"

settings_interval = {}
settings_interval["de"] = {"Sonanz" , "Intervall", "Effekt", "Cents"}
settings_interval["en"] = {"Sonance", "Interval" , "Effect", "Cents"}

settings_tuning = {}
settings_tuning["de"] = {"Reine Intervalle", "Gleichstufig"     ,"Pythagoreisch"}
settings_tuning["en"] = {"Pure intervals"  , "Equal temperament","Pythagorean"  }

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

settings_pitch = {}
settings_pitch["de"] = "Kammerton a' (A4)"
settings_pitch["en"] = "Diaspon a' (A4)"

settings_reopen_note = {}
settings_reopen_note["de"] = "*=Fenster muss neu geöffnet werden"
settings_reopen_note["en"] = "*=Window must be re-opened"

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

local function get_view(vb, id)
    local view = vb.views[id]
    if not view then
        local error_text = "Unknown view element: '"..id.."'"
        renoise.app():show_message(error_text)
        error(error_text)
    end
    return view
end

local function update_text(vb, id, text)
    get_view(vb, id).text = text
end

local function update_color(vb, id, color)
    get_view(vb, id).color = color
end

local function update_items(vb, id, items)
    get_view(vb, id).items = items
end

local function dissonance_details(dissonance, settings)
    local language = settings.language.value
    if not dissonance then
        return dissonance_omitted_texts[language], COLOR_BLACK
    end
    local specific_dissonance = dissonance
    if not specific_dissonance then
        return dissonance_omitted_texts[language], COLOR_BLACK
    end
    local dissonance_thresholds={settings.dissonance_threshold_1.value,
                                 settings.dissonance_threshold_2.value,
                                 settings.dissonance_threshold_3.value,
                                 math.huge}
    for i = 1, #dissonance_thresholds do
        if specific_dissonance <= dissonance_thresholds[i] then
            return dissonance_texts[language][i] .."\n("..string.format("%.2f", specific_dissonance)..")",
                   DISSONANCE_COLORS[i]
        end
    end
    return nil, COLOR_BLACK
end

local function interval_text(language, interval)
    local function display_interval(delta)
        return (delta >= 13 and delta <= 24) and delta or interval.interval -- Additional intervals Ninth...Fifteenth
    end
    -- local a, b = interval:ab()
    return interval_texts[language][display_interval(math.abs(interval.halftones), interval.interval) + 1]
            .."\n("
            ..tostring(interval.halftones)
            .." HT)"
end

local function effect_text(language, interval)
    local text = "n/a"
    local octave_text = tostring(interval.octaves).." "..octave_texts[language]
    local has_dedicated_text = interval.octaves == 0 or (interval.octaves == 1 and interval.interval == 12)
    if     interval.octaves <  0 then octave_text = ""..octave_text
    elseif has_dedicated_text    then octave_text = ""
                                      text = effect_texts[language][interval.interval + 1]
       else                           octave_text = "+"..octave_text
    end
    return text, octave_text
end

local function cents_text(properties)
    return properties.cents and string.format("%.0f\nCents", properties.cents) or "\n---\n"
end

local function update_interval(vb, data, settings, cache)
    local language       = settings.language.value
    local view_type      = settings.view_type.value
    local view           = data.view
    local display_chords = data.status ~= STATUS_LINES_OMITTED and settings.chord_calculation.value
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
                    local wrapper = interval.chord
                    if wrapper then
                        dissonance = wrapper()
                    end
                end
                if dissonance then
                    local dissonance_text, dissonance_color = dissonance_details(dissonance, settings)
                    if     view_type == 1 or interval.chord then update_text (vb, view_id, dissonance_text)
                                                                 update_color(vb, view_id, dissonance_color)
                    elseif view_type == 2 then update_text (vb, view_id, interval_text(language, interval))
                                               update_color(vb, view_id, dissonance_color)
                    elseif view_type == 3 then update_text (vb, view_id, effect_text(language, interval))
                                               update_color(vb, view_id, dissonance_color)
                    elseif view_type == 4 then update_text (vb, view_id, cents_text(properties))
                                               update_color(vb, view_id, dissonance_color)
                    end
                end
            end
        end
    end
end

function update_interface(vb, settings, data)
    local language          = settings.language.value
    local status            = data.status.status
    local status_text       = status_texts[status][language]
    local counterpoint      = data.counterpoint
    local counterpoint_text = counterpoint_texts[COUNTERPOINT_OK][language]
    if counterpoint.code then
        counterpoint_text = counterpoint_texts[counterpoint.code][language]..counterpoint.details
        update_color(vb, ID_COUNTERPOINT_BAR, COLOR_STATUS_WARNING)
    else
        update_color(vb, ID_COUNTERPOINT_BAR, COLOR_DEFAULT)
    end
    update_text    (vb, ID_STATUS_BAR                   , status_text)
    update_text    (vb, ID_COUNTERPOINT_BAR             , counterpoint_text)
    update_text    (vb, ID_HEADER_CHORD_ACTUAL          , chord_header_actual      [language])
    update_text    (vb, ID_HEADER_CHORD_LINGER          , chord_header_linger      [language])
    update_text    (vb, ID_SETTINGS_DISSONANCE_THRESHOLD, dissonance_threshold_text[language])
    update_text    (vb, ID_SETTINGS_HEARING_THRESHOLD   , hearing_threshold_texts  [language])
    update_text    (vb, ID_SETTINGS_VOLUME_REDUCTION    , settings_volume_reduction[language])
    update_text    (vb, ID_SETTINGS_PITCH               , settings_pitch           [language])
    update_text    (vb, ID_SETTINGS_MATRIX_SIZE         , settings_matrix_size     [language])
    update_text    (vb, ID_SETTINGS_SEARCH_ROWS         , settings_search_rows     [language])
    update_text    (vb, ID_SETTINGS_CHORD_CALC          , settings_chord_calc      [language])
    update_text    (vb, ID_SETTINGS_REOPEN_NOTE         , settings_reopen_note     [language])
    update_items   (vb, ID_SETTINGS_INTERVAL            , settings_interval        [language])
    update_items   (vb, ID_SETTINGS_TUNING              , settings_tuning          [language])
    update_items   (vb, ID_SETTINGS_TUNING_NOTE         , settings_tuning_note     [language])
    if language == "de" then vb.views.popup_language.value = 1
                        else vb.views.popup_language.value = 2
    end
    local cache = {}
    update_interval(vb, data, settings, cache)
end
