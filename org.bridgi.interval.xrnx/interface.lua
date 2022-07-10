require "constants"
require "common"

local DIALOG_MARGIN                = renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
local DIALOG_SPACING               = renoise.ViewBuilder.DEFAULT_DIALOG_SPACING
local CONTENT_SPACING              = renoise.ViewBuilder.DEFAULT_CONTROL_SPACING
local CONTENT_MARGIN               = renoise.ViewBuilder.DEFAULT_CONTROL_MARGIN
local DEFAULT_CONTROL_HEIGHT       = renoise.ViewBuilder.DEFAULT_CONTROL_HEIGHT
local DEFAULT_DIALOG_BUTTON_HEIGHT = renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT
local DEFAULT_MINI_CONTROL_HEIGHT  = renoise.ViewBuilder.DEFAULT_MINI_CONTROL_HEIGHT

function configuration_section(vb, settings, calculation_results)
    return vb:row { vb:column { vb:row {
                vb:space  { width    = 5 },
                vb:row {
                    style = "invisible",
                    vb:text   { id       = ID_SETTINGS,
                                width    = 100,
                                style    = "strong",
                                text     = "???" },

                },
                vb:space  { width    = 5 },
                vb:switch { id       = ID_SETTINGS_INTERVAL,
                            width    = 400,
                            bind     = settings.view_type,
                            notifier = function(new_index)
                                           settings.view_type.value = new_index
                                           update_interface(vb, settings, calculation_results)
                                       end } },
        vb:row {
        vb:space  { width    = 110 },
        vb:row {
            vb:popup {id       = ID_SETTINGS_TUNING,
                      width    = 150,
                      bind     = settings.tuning,
                      notifier = function(new_index)
                          settings.tuning.value = new_index
                          update_interface(vb, settings, calculation_results)
                      end }
            },
            vb:popup  { id       = ID_SETTINGS_TUNING_NOTE,
                        width    = 50,
                        bind     = settings.tuning_note,
                        notifier = function(new_index)
                            update_interface(vb, settings, calculation_results)
                        end },
            vb:popup  { id       = "popup_language",
                        items    = {"Deutsch","English"},
                        width    = 130,
                        notifier = function(new_index)
                            if new_index == 1 then settings.language.value = "de"
                            else settings.language.value = "en"
                            end
                            update_interface(vb, settings, calculation_results)
                        end }
            }},
            vb:space  { width    = 20 },
            vb:rotary { min      =  1.0,
                        max      = 50.0,
                        default  =  3.5,
                        width    =  2 * DEFAULT_CONTROL_HEIGHT,
                        height   =  2 * DEFAULT_CONTROL_HEIGHT,
                        bind     = settings.dissonance_threshold_1,
                        notifier = function(value)
                            settings.dissonance_threshold_1.value = value
                            if value >= settings.dissonance_threshold_2.value then
                                settings.dissonance_threshold_1.value = settings.dissonance_threshold_2.value - 0.001
                            end
                            update_interface(vb, settings, calculation_results)
                        end
            },
            vb:rotary { min      =  1.0,
                        max      = 99.0,
                        default  =  6.5,
                        width    =  2 * DEFAULT_CONTROL_HEIGHT,
                        height   =  2 * DEFAULT_CONTROL_HEIGHT,
                        bind     = settings.dissonance_threshold_2,
                        notifier = function(value)
                            settings.dissonance_threshold_2.value = value
                            if value <= settings.dissonance_threshold_1.value then
                                settings.dissonance_threshold_2.value = settings.dissonance_threshold_1.value + 0.001
                            end
                            if value >= settings.dissonance_threshold_3.value then
                                settings.dissonance_threshold_2.value = settings.dissonance_threshold_3.value - 0.001
                            end
                            update_interface(vb, settings, calculation_results)
                        end
            },
            vb:rotary { min      =  1.0,
                        max      = 99.0,
                        default  = 11.0,
                        width    =  2 * DEFAULT_CONTROL_HEIGHT,
                        height   =  2 * DEFAULT_CONTROL_HEIGHT,
                        bind     = settings.dissonance_threshold_3,
                        notifier = function(value)
                            settings.dissonance_threshold_3.value = value
                            if value <= settings.dissonance_threshold_2.value then
                                settings.dissonance_threshold_3.value = settings.dissonance_threshold_2.value + 0.001
                            end
                            update_interface(vb, settings, calculation_results)
                        end
            },
            vb:column { vb:text                { id      = ID_SETTINGS_DISSONANCE_THRESHOLD,
                                                 text    = "???" },
                        vb:row { vb:valuefield { min     =  1.0,
                                                 max     = 10.0,
                                                 width   = 45,
                                                 active  = false,
                                                 bind    = settings.dissonance_threshold_1 },
                                 vb:valuefield { min     =  2.0,
                                                 max     = 90.0,
                                                 width   = 45,
                                                 active  = false,
                                                 bind    = settings.dissonance_threshold_2 },
                                 vb:valuefield { min     =  5.0,
                                                 max     = 99.0,
                                                 width   = 45,
                                                 active  = false,
                                                 bind    = settings.dissonance_threshold_3 } }

            },
            vb:space  { width    = 10 },
            vb:rotary { min      =  0.004,
                        max      =  0.015,
                        default  =  0.004,
                        width    =  2 * DEFAULT_CONTROL_HEIGHT,
                        height   =  2 * DEFAULT_CONTROL_HEIGHT,
                        bind     = settings.hearing_threshold,
                        notifier = function(value)
                                       update_interface(vb, settings, calculation_results)
                                   end },
            vb:column { vb:text       { id      = ID_SETTINGS_HEARING_THRESHOLD,
                                        text    = "???" },
                        vb:valuefield { min     =  0.004,
                                        max     =  0.015,
                                        active  = false,
                                        bind    = settings.hearing_threshold }
            },
            vb:rotary { min      =  0.00,
                        max      =  1.00,
                        default  =  0.20,
                        width    =  2 * DEFAULT_CONTROL_HEIGHT,
                        height   =  2 * DEFAULT_CONTROL_HEIGHT,
                        bind     = settings.volume_reduction
            },
            vb:column { vb:text       { id      = ID_SETTINGS_VOLUME_REDUCTION,
                                        text    = "???" },
                        vb:valuefield { min     =  0.00,
                                        max     =  1.00,
                                        active  = false,
                                        bind    = settings.volume_reduction }
            },
            vb:space  { width = 10 },
            vb:column { vb:text       { id      = ID_SETTINGS_PITCH,
                                        text    = "???" },
                        vb:valuebox   { min     =  400.00,
                                        max     =  470.00,
                                        active  = true,
                                        bind    = settings.pitch,
                                        notifier = function(value)
                                            update_interface(vb, settings, calculation_results)
                                        end }
            },
            vb:space  { width = 10 },
            vb:column { vb:text       { id      = ID_SETTINGS_MATRIX_SIZE,
                                        text    = "???" },
                        vb:valuebox   { min     =  3,
                                        max     = 10,
                                        active  = true,
                                        bind    = settings.max_lines } },
            vb:space  { width = 10 },
            vb:column { vb:text       { id      = ID_SETTINGS_SEARCH_ROWS,
                                        text    = "???" },
                        vb:valuebox   { min     =   1,
                                        max     = 255,
                                        active  = true,
                                        bind    = settings.max_delta },
            }
        }
end

function table_header(vb, no_of_note_columns, per_column_width)
    local head_aligner = vb:horizontal_aligner { width = no_of_note_columns * 40,
                                                 mode  = "distribute" }
    local head_row = vb:row { width = no_of_note_columns * 40,
                              head_aligner }
    for columns = 1, no_of_note_columns do
        local column = vb:column { width = per_column_width }
        column:add_child(vb:row { style = "body",
                                  vb:horizontal_aligner { mode  = "center",
                                                          width = per_column_width,
                                                          vb:button { width  = per_column_width,
                                                                      height = HEADER_HEIGHT,
                                                                      color  = COLOR_HEADER_1,
                                                                      active = false,
                                                                      text   = tostring(columns)}}})
        head_aligner:add_child(column)
        if columns ~= no_of_note_columns then
            column = vb:column { width = per_column_width }
            column:add_child(vb:row { style = "body",
                                      vb:horizontal_aligner { mode  = "center",
                                                              width = per_column_width,
                                                              vb:button { width  = per_column_width,
                                                                          height = HEADER_HEIGHT,
                                                                          color  = COLOR_HEADER_2,
                                                                          active = false,
                                                                          text   = "---"}}})
            head_aligner:add_child(column)
        end
    end
    head_aligner:add_child(vb:column { vb:button { width  = 10,
                                                   height = HEADER_HEIGHT,
                                                   active = false,
                                                   color  = COLOR_HEADER_2,
                                                   text   = ""}})
    head_aligner:add_child(vb:column { vb:button { id     = ID_HEADER_CHORD_ACTUAL,
                                                   width  = per_column_width,
                                                   height = HEADER_HEIGHT,
                                                   active = false,
                                                   color  = COLOR_HEADER_1,
                                                   text   = "???"}})
    head_aligner:add_child(vb:column { vb:button { id     = ID_HEADER_CHORD_LINGER,
                                                   width  = per_column_width,
                                                   height = HEADER_HEIGHT,
                                                   active = false,
                                                   color  = COLOR_HEADER_1,
                                                   text   = "???"}})
    return head_row
end

function interval_button(vb, per_column_width, row, col)
    return vb:button { id      = ID_ELEMENT..row.."."..col,
                       width   = per_column_width,
                       height  = 30,
                       color   = COLOR_DEFAULT,
                       active  = false,
                       text    = "???\n???\n???" }
end

function interval_view(vb, per_column_width, row, col)
    return vb:row { vb:horizontal_aligner { mode   = "center",
                                            width  = per_column_width,
                                            margin = 0,
                                            interval_button(vb, per_column_width, row, col) }}
end

function note_button(vb, per_column_width, row, col, calculation_results)
    local not_a_note = not is_note(calculation_results.value[row][col])
    if not_a_note then
        return vb:row { style = "body",
                        vb:horizontal_aligner { mode  = "center",
                                                width = per_column_width,
                                                vb:button { width  = per_column_width,
                                                            height = 40,
                                                            color  = COLOR_NO_NOTE,
                                                            active = false,
                                                            text   = "\n---\n"}}}
    else
        local note_text = "\n"
                          ..calculation_results.notes[row][col]
                          .." ("
                          ..tostring(calculation_results.volume[row][col])
                          ..")\n"
        return vb:row { style = "plain",
                        vb:horizontal_aligner { mode  = "center",
                                                width = per_column_width,
                                                vb:button { width  = per_column_width,
                                                            height = 40,
                                                            color  = COLOR_IS_NOTE,
                                                            active = false,
                                                            text   = note_text}}}
    end
end

function create_view(vb, settings, data)

    local no_of_note_columns = data.no_of_note_columns
    local notes              = data.notes
    local steps              = data.steps
    local value              = data.value
    local counterpoint       = data.counterpoint
    local status             = data.status

    local base_width          = 1700
    local per_column_width    = base_width / (no_of_note_columns * 2 + 2)
    local total_width         = (no_of_note_columns + 1) * per_column_width
    local configuration_view  = configuration_section(vb, settings, data)
    local matrix_view         = vb:column { width = total_width, margin = CONTENT_MARGIN }
    local dialog_content      = vb:column { width = total_width, configuration_view, matrix_view }

    dialog_content:add_child(table_header(vb, no_of_note_columns, per_column_width))
    dialog_content:add_child(vb:row{ height=5, vb:space {}})

    for rows = 1, #notes do
        local aligner = vb:horizontal_aligner { width = no_of_note_columns * 40, mode  = "distribute" }
        local row     = vb:row                { width = no_of_note_columns * 40, aligner }
        for columns = 1, no_of_note_columns do
            local column = vb:column { width = per_column_width }
            -- Add note column
            column:add_child(note_button(vb, per_column_width, rows, columns, data))
            -- Add a trailing interval column for each note column but the last one
            -- Lilia wanted to know what a comment is, :-)
            if rows <= #value - 1 then column:add_child(interval_view(vb, per_column_width, rows, columns * 2)) end
            aligner:add_child(column)
            if columns <= no_of_note_columns - 1 then
                column = vb:column { width = per_column_width }
                column:add_child(interval_view(vb, per_column_width, rows, columns * 2 + 1))
                aligner:add_child(column)
                -- Add a trailing step row for each row but the last one
                if rows <= #value - 1 then
                    local step_text = "\n----- "..tostring(steps[rows][columns]).." -----\n"
                    column:add_child(vb:row { style = "body",
                                              vb:horizontal_aligner { mode  = "center",
                                                                      width = per_column_width,
                                                                      vb:text { width  = per_column_width,
                                                                                height = 50,
                                                                                font   = "italic",
                                                                                align  = "center",
                                                                                style  = "disabled",
                                                                                text   = step_text}}})
                end
            end
        end

        -- Add a small separator between the main matrix and the chord columns
        aligner:add_child( vb:column { vb:button { width  = 10,
                                                   height = 50,
                                                   active = false,
                                                   color  = COLOR_BLACK,
                                                   text   = "\n\n"}})
        -- Add two chord columns
        aligner:add_child( vb:column { interval_button(vb, per_column_width, rows, (no_of_note_columns * 2 + 1)) })
        aligner:add_child( vb:column { interval_button(vb, per_column_width, rows, (no_of_note_columns * 2 + 2)) })
        dialog_content:add_child(row)
    end

    -- Add a status bar
    if status then
        dialog_content:add_child(vb:row { width =  base_width - per_column_width + 10,
                                          vb:button { width  = base_width- per_column_width + 10,
                                                      height = DEFAULT_MINI_CONTROL_HEIGHT,
                                                      id     = ID_STATUS_BAR,
                                                      color  = status.color,
                                                      active = false,
                                                      text   = "???" }})
    end

    -- Add a counterpoint bar
    if counterpoint then
        dialog_content:add_child(vb:row { width =  base_width - per_column_width + 10,
                                          vb:button { width  = base_width- per_column_width + 10,
                                                      height = DEFAULT_MINI_CONTROL_HEIGHT,
                                                      id     = ID_COUNTERPOINT_BAR,
                                                      color  = COLOR_STATUS_WARNING,
                                                      active = false,
                                                      text   = "???" }})
    end

    return dialog_content
end
