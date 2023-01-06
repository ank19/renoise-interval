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
effect_texts["de"]={"Weichheit,\nFriede,\nZusammenhalt",
                    "unzufrieden,\nMelancholie,\nschüchtern",
                    "Neutral,\nSehnsucht,\nvergänglich",
                    "Ernsthaftigkeit,\nWeichheit,\nSehnsucht",
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
                           "Unvollkommene\nKonsonanz",
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
chord_header_linger["de"] = "Akkord (nachklingend)"
chord_header_linger["en"] = "Chord (lingering)"

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
settings_volume_reduction["de"] = "Dämpfung" -- Nachklang
settings_volume_reduction["en"] = "Damping" -- Lingering

settings_matrix_size = {}
settings_matrix_size["de"] = "Zeilen"
settings_matrix_size["en"] = "Rows"

settings_search_rows = {}
settings_search_rows["de"] = "Suchweite"
settings_search_rows["en"] = "Range"

settings_chord_calc = {}
settings_chord_calc["de"] = "Akkorde"
settings_chord_calc["en"] = "Chords"

settings_pitch = {}
settings_pitch["de"] = "Kammerton a' (A4)"
settings_pitch["en"] = "Diaspon a' (A4)"

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

local function update_text(vb, id, text)
    local view = vb.views[id]
    if not view then
        error_log("Unknown view '"..id.."'")
        return
    end
    view.text = text
end

local function update_color(vb, id, color)
    local view = vb.views[id]
    if not view then
        error_log("Unknown view '"..id.."'")
        return
    end
    view.color = color
end

local function update_items(vb, id, items)
    local view = vb.views[id]
    if not view then
        error_log("Unknown view '"..id.."'")
        return
    end
    view.items = items
end

local function dissonance_details(dissonance, settings)
    local language = settings.language.value
    if not dissonance then
        return dissonance_omitted_texts[language]
    end
    local specific_dissonance = dissonance
    if not specific_dissonance then
        return dissonance_omitted_texts[language]
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
    return nil
end

local function update_interval(vb, data, settings, cache)
    local language      = settings.language.value
    local view          = settings.view_type.value
    local interval_data = data.interval_data
    local value         = data.value
    for col = 2, data.no_of_note_columns * 2 + 2 do
        for row = 1, #value do
            local interval_text    = ""
            local effect_text      = ""
            local octave_text      = ""
            local dissonance_text  = ""
            local cents_text       = ""
            local dissonance_color = COLOR_DISSONANCE_X
            local view_id          = ID_ELEMENT..row.."."..col
            local is_chord_column  = col > data.no_of_note_columns * 2
            local interval, octave, halftones, display_interval, a, b, p, f1, f2, cents, dissonance
            if not is_chord_column then
                local wrapper = interval_data[row][col]
                if wrapper then
                    interval, halftones, octave, display_interval, a, b, cents, p, f1, f2, dissonance = wrapper(cache)
                end
            else
                local wrapper = interval_data[row][col]
                if wrapper then
                    dissonance = wrapper(cache)
                end
            end
            dissonance_text, dissonance_color = dissonance_details(dissonance, settings)
            if interval then
                octave_text = tostring(octave).." "..octave_texts[language]
                local has_dedicated_text = octave == 0 or (octave == 1 and interval == 12)
                if     octave <  0        then octave_text = ""..octave_text
                elseif has_dedicated_text then octave_text = ""
                                               effect_text = effect_texts[language][interval + 1]
                else                           octave_text = "+"..octave_text
                end
                interval_text = interval_texts[language][display_interval + 1]
                                .."\n("
                                ..tostring(halftones)
                                .." HT   "
                                ..a
                                .."/"
                                ..b
                                ..")"
                cents_text    = string.format("%.0f\nCents", cents)
            end
            if     view == 1 then if (interval or is_chord_column) and dissonance_text and dissonance_color then
                                      update_text (vb, view_id, dissonance_text )
                                      update_color(vb, view_id, dissonance_color)
                                  else
                                      update_text (vb, view_id, "\n---\n")
                                      update_color(vb, view_id, COLOR_DEFAULT    )
                                  end
            elseif view == 2 then if interval then
                                      update_text (vb, view_id, interval_text   )
                                      update_color(vb, view_id, dissonance_color)
                                  else
                                      update_text (vb, view_id, "\n---\n")
                                      update_color(vb, view_id, COLOR_DEFAULT    )
                                  end
            elseif view == 3 then if interval then
                                      update_text (vb, view_id, effect_text     )
                                      update_color(vb, view_id, dissonance_color)
                                  else
                                      update_text (vb, view_id, "\n---\n")
                                      update_color(vb, view_id, COLOR_DEFAULT    )
                                  end
            elseif view == 4 then if interval then
                                      update_text (vb, view_id, cents_text       )
                                      update_color(vb, view_id, dissonance_color )
                                  else
                                      update_text (vb, view_id, "\n---\n")
                                      update_color(vb, view_id, COLOR_DEFAULT    )
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
    update_text    (vb, ID_SETTINGS                     , settings_header          [language])
    update_text    (vb, ID_SETTINGS_DISSONANCE_THRESHOLD, dissonance_threshold_text[language])
    update_text    (vb, ID_SETTINGS_HEARING_THRESHOLD   , hearing_threshold_texts  [language])
    update_text    (vb, ID_SETTINGS_VOLUME_REDUCTION    , settings_volume_reduction[language])
    update_text    (vb, ID_SETTINGS_PITCH               , settings_pitch           [language])
    update_text    (vb, ID_SETTINGS_MATRIX_SIZE         , settings_matrix_size     [language])
    update_text    (vb, ID_SETTINGS_SEARCH_ROWS         , settings_search_rows     [language])
    update_text    (vb, ID_SETTINGS_CHORD_CALC          , settings_chord_calc      [language])
    update_items   (vb, ID_SETTINGS_INTERVAL            , settings_interval        [language])
    update_items   (vb, ID_SETTINGS_TUNING              , settings_tuning          [language])
    update_items   (vb, ID_SETTINGS_TUNING_NOTE         , settings_tuning_note     [language])
    if language == "de" then vb.views.popup_language.value = 1
                        else vb.views.popup_language.value = 2
    end
    local cache = {}
    update_interval(vb, data, settings, cache)
end
