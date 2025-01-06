require "constants"
require "common"

local DIALOG_MARGIN                = renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
local DIALOG_SPACING               = renoise.ViewBuilder.DEFAULT_DIALOG_SPACING
local CONTENT_SPACING              = renoise.ViewBuilder.DEFAULT_CONTROL_SPACING
local CONTENT_MARGIN               = renoise.ViewBuilder.DEFAULT_CONTROL_MARGIN
local DEFAULT_CONTROL_HEIGHT       = renoise.ViewBuilder.DEFAULT_CONTROL_HEIGHT
local DEFAULT_DIALOG_BUTTON_HEIGHT = renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT
local DEFAULT_MINI_CONTROL_HEIGHT  = renoise.ViewBuilder.DEFAULT_MINI_CONTROL_HEIGHT

local SEPARATOR_WIDTH = 10
local INDEX_WIDTH     = 40
local ELEMENT_HEIGHT  = 20
local FULL_HD_WIDTH   = 1920
local SETTINGS_WIDTH  = 50

function configuration_section(vb, settings, data, dialog_type)
    return
        vb:column {
           vb:row {
                vb:switch { id = ID_SETTINGS_INTERVAL,
                            width = 270,
                            bind = settings.view_type,
                            notifier = function(new_index)
                                settings.view_type.value = new_index
                                update_interface(vb, settings, data)
                            end },
                vb:popup { id = ID_SETTINGS_TUNING,
                           width = SETTINGS_WIDTH * 2.5,
                           bind = settings.tuning,
                           notifier = function(new_index)
                               settings.tuning.value = new_index
                               update_interface(vb, settings, data)
                           end },
                vb:popup { id = ID_SETTINGS_TUNING_NOTE,
                           width = SETTINGS_WIDTH,
                           bind = settings.tuning_note,
                           notifier = function(new_index)
                               update_interface(vb, settings, data)
                           end },
                vb:popup { id = "popup_language",
                           items = { "Deutsch", "English" },
                           width = 70,
                           notifier = function(new_index)
                               if new_index == 1 then
                                   settings.language.value = "de"
                               else
                                   settings.language.value = "en"
                               end
                               update_interface(vb, settings, data)
                           end },
                vb:space { width = 5 },
                vb:text { id = ID_SETTINGS_CHORD_CALC,
                          width = SETTINGS_WIDTH / 1.25,
                          text = "???" },
                vb:checkbox { id = ID_SETTINGS_CHORD_CALC_BOX,
                              bind = settings.chord_calculation,
                              width = 15,
                              notifier = function(new_index)
                                  update_interface(vb, settings, data)
                              end },
                vb:space { width = 5 },
                vb:text { id = ID_SETTINGS_SKIP_EMPTY,
                          width = SETTINGS_WIDTH,
                          text = "???" },
                vb:checkbox { id = ID_SETTINGS_SKIP_EMPTY_BOX,
                              bind = settings.skip_empty_compact,
                              width = 15,
                              notifier = function(new_index)
                                  update_interface(vb, settings, data)
                              end },
                vb:space { width = 10 },
                vb:text { id = ID_SETTINGS_REOPEN_NOTE, text = "???" }
        },
        vb:column {
            vb:row {
                vb:rotary { min = 1.0,
                            max = 50.0,
                            default = 3.5,
                            width = 2 * DEFAULT_CONTROL_HEIGHT,
                            height = 2 * DEFAULT_CONTROL_HEIGHT,
                            bind = settings.dissonance_threshold_1,
                            notifier = function(value)
                                settings.dissonance_threshold_1.value = value
                                if value >= settings.dissonance_threshold_2.value then
                                    settings.dissonance_threshold_1.value = settings.dissonance_threshold_2.value - 0.001
                                end
                                update_interface(vb, settings, data)
                            end
                },
                vb:rotary { min = 1.0,
                            max = 99.0,
                            default = 6.5,
                            width = 2 * DEFAULT_CONTROL_HEIGHT,
                            height = 2 * DEFAULT_CONTROL_HEIGHT,
                            bind = settings.dissonance_threshold_2,
                            notifier = function(value)
                                settings.dissonance_threshold_2.value = value
                                if value <= settings.dissonance_threshold_1.value then
                                    settings.dissonance_threshold_2.value = settings.dissonance_threshold_1.value + 0.001
                                end
                                if value >= settings.dissonance_threshold_3.value then
                                    settings.dissonance_threshold_2.value = settings.dissonance_threshold_3.value - 0.001
                                end
                                update_interface(vb, settings, data, dialog_type)
                            end
                },
                vb:rotary { min = 1.0,
                            max = 99.0,
                            default = 11.0,
                            width = 2 * DEFAULT_CONTROL_HEIGHT,
                            height = 2 * DEFAULT_CONTROL_HEIGHT,
                            bind = settings.dissonance_threshold_3,
                            notifier = function(value)
                                settings.dissonance_threshold_3.value = value
                                if value <= settings.dissonance_threshold_2.value then
                                    settings.dissonance_threshold_3.value = settings.dissonance_threshold_2.value + 0.001
                                end
                                update_interface(vb, settings, data)
                            end
                },
                vb:column { vb:text { id = ID_SETTINGS_DISSONANCE_THRESHOLD,
                                      text = "???" },
                            vb:row { vb:valuefield { min = 1.0,
                                                     max = 10.0,
                                                     width = 45,
                                                     active = false,
                                                     bind = settings.dissonance_threshold_1 },
                                     vb:valuefield { min = 2.0,
                                                     max = 90.0,
                                                     width = 45,
                                                     active = false,
                                                     bind = settings.dissonance_threshold_2 },
                                     vb:valuefield { min = 5.0,
                                                     max = 99.0,
                                                     width = 45,
                                                     active = false,
                                                     bind = settings.dissonance_threshold_3 } }
                },
                vb:space { width = 10 },
                vb:rotary { id = ID_SETTINGS_HEARING_THRESHOLD_VALUE,
                            min = 0.004,
                            max = 0.015,
                            default = 0.004,
                            width = 2 * DEFAULT_CONTROL_HEIGHT,
                            height = 2 * DEFAULT_CONTROL_HEIGHT,
                            bind = settings.hearing_threshold,
                            active = true,
                            notifier = function(value)
                                update_interface(vb, settings, data)
                            end },
                vb:column { vb:text { id = ID_SETTINGS_HEARING_THRESHOLD,
                                      text = "???" },
                            vb:valuefield { min = 0.004,
                                            max = 0.015,
                                            active = false,
                                            bind = settings.hearing_threshold }
                },
                vb:rotary { min = 0.00,
                            max = 1.00,
                            default = 0.20,
                            width = 2 * DEFAULT_CONTROL_HEIGHT,
                            height = 2 * DEFAULT_CONTROL_HEIGHT,
                            bind = settings.volume_reduction
                },
                vb:column { vb:text { id = ID_SETTINGS_VOLUME_REDUCTION,
                                      text = "???" },
                            vb:valuefield { min = 0.00,
                                            max = 1.00,
                                            active = false,
                                            bind = settings.volume_reduction }
                },
                vb:space { width = 5 },
                vb:column { vb:text { id = ID_SETTINGS_PITCH,
                                      text = "???" },
                            vb:valuebox { id = ID_SETTINGS_PITCH_VALUE,
                                          min = 400.00,
                                          max = 470.00,
                                          active = true,
                                          bind = settings.pitch,
                                          notifier = function(value)
                                              update_interface(vb, settings, data)
                                          end }
                },
                vb:space { width = 5 },
                vb:column { vb:text { id = ID_SETTINGS_MATRIX_SIZE,
                                      text = "???" },
                            vb:valuebox { min = 3,
                                          max = 24,
                                          width = SETTINGS_WIDTH,
                                          active = true,
                                          bind = settings_lines() } },
                vb:space { width = 5 },
                vb:column { vb:text { id = ID_SETTINGS_SEARCH_ROWS,
                                      text = "???" },
                            vb:valuebox { min = 1,
                                          max = 255,
                                          width = SETTINGS_WIDTH,
                                          active = true,
                                          bind = settings_delta() },
                },
                vb:space { width = 5 },
                vb:column { vb:text { id = ID_SETTINGS_TRACKS,
                                      text = "???" },
                            vb:valuebox { min = 1,
                                          max = 12,
                                          width = SETTINGS_WIDTH,
                                          active = true,
                                          bind = settings_tracks() },
                }
            }
        }
    }
end

function table_header(vb, data, per_column_width, display_chords, dialog_type, index_width)
    local note_count = data.note_count
    local head_aligner = vb:horizontal_aligner { width = note_count * 40,
                                                 mode  = "distribute" }
    local head_row = vb:row { width = note_count * 40, head_aligner }
    head_aligner:add_child( vb:column { vb:button { width  = index_width,
                                                    height = ELEMENT_HEIGHT,
                                                    active = false,
                                                    color  = COLOR_DEFAULT,
                                                    text   = "/" }})
    for i = 1, note_count do
        local column = vb:column { width = per_column_width }
        local header = tostring(data.notes[1][i].track).."|"..tostring(data.notes[1][i].column)
        column:add_child(vb:row { style = "body",
                                  vb:horizontal_aligner { mode  = "center",
                                                          width = per_column_width,
                                                          vb:button { width  = per_column_width,
                                                                      height = HEADER_HEIGHT,
                                                                      color  = COLOR_HEADER_1,
                                                                      active = false,
                                                                      text   = header }}})
        head_aligner:add_child(column)
        head_aligner:add_child(vb:column { vb:button { width  = SEPARATOR_WIDTH,
                                                       height = HEADER_HEIGHT,
                                                       active = false,
                                                       color  = COLOR_HEADER_2,
                                                       text   = ""}})

        if i ~= note_count then
            column = vb:column { width = per_column_width }
            column:add_child(vb:row { style = "body",
                                      vb:horizontal_aligner { mode  = "center",
                                                              width = per_column_width,
                                                              vb:button { width  = per_column_width,
                                                                          height = HEADER_HEIGHT,
                                                                          color  = COLOR_HEADER_2,
                                                                          active = false,
                                                                          text   = dialog_type == DIALOG_CONDENSED and "Interval" or "I"}}})
            head_aligner:add_child(column)
            head_aligner:add_child(vb:column { vb:button { width  = SEPARATOR_WIDTH,
                                                           height = HEADER_HEIGHT,
                                                           active = false,
                                                           color  = COLOR_HEADER_2,
                                                           text   = ""}})
        end
    end
    if display_chords then
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
                                                       text   = "???" }})
    end
    return head_row
end

function data_button(vb, per_column_width, element, row, col, dialog_type)
    return vb:row { vb:horizontal_aligner { mode   = "center",
                                            width  = per_column_width,
                                            margin = 0,
                                            vb:button { id      = ID_ELEMENT..row.."."..col,
                                                        width   = per_column_width,
                                                        height  = ELEMENT_HEIGHT,
                                                        color   = COLOR_DEFAULT,
                                                        active  = false,
                                                        text    = dialog_type == DIALOG_CONDENSED and "---\n" or "-" }}}
end

function note_button(vb, per_column_width, element, row, col, dialog_type)
    local note = element.note
    if not is_note(note.value) then
        return vb:row { style = "body",
                        vb:horizontal_aligner { mode  = "center",
                                                width = per_column_width,
                                                vb:button { width  = per_column_width,
                                                            height = ELEMENT_HEIGHT,
                                                            color  = note.marker and COLOR_NO_NOTE_MARKER or COLOR_NO_NOTE,
                                                            active = false,
                                                            text   = dialog_type == DIALOG_CONDENSED and "---\n" or "-" }}}
    else
        local note_text = dialog_type == DIALOG_CONDENSED and note.string.."\n" or note.string
        return vb:row { style = "plain",
                        vb:horizontal_aligner { mode  = "center",
                                                width = per_column_width,
                                                vb:button { width  = per_column_width,
                                                            height = ELEMENT_HEIGHT,
                                                            color  = note.marker and COLOR_IS_NOTE_MARKER or COLOR_IS_NOTE,
                                                            active = false,
                                                            text   = note_text }}}
    end
end

function text_button(vb, per_column_width, element, row, col, dialog_type)
    local text = dialog_type == DIALOG_CONDENSED and "\n" or ""
    return vb:row { style = "body",
                    vb:horizontal_aligner { mode  = "center",
                                            width = per_column_width,
                                            vb:text { width  = per_column_width,
                                                      height = ELEMENT_HEIGHT,
                                                      font   = "italic",
                                                      align  = "center",
                                                      style  = "disabled",
                                                      text   = text }}}
end

function separator_button(vb, per_column_width, element, row, col, dialog_type)
    return vb:column { vb:button { id       = ID_SEPARATOR..row.."."..col,
                                   width    = SEPARATOR_WIDTH,
                                   height   = ELEMENT_HEIGHT,
                                   active   = (math.fmod(row, 2) == 0 and math.fmod(col, 2) == 1)
                                              or
                                              (math.fmod(row, 2) == 1 and math.fmod(col, 2) == 0),
                                   color    = COLOR_BLACK,
                                   tooltip  = "n/a",
                                   text     = dialog_type == DIALOG_CONDENSED and "\n" or "",
                                   notifier = function()
                                       local self_reference = vb.views[ID_SEPARATOR..row.."."..col]
                                       renoise.app():show_message(self_reference.tooltip)
                                   end }}
end


function index_string(sequence, line, dialog_type)
    local sequence_string = tostring(sequence - 1)
    local line_string = tostring(line - 1)
    return dialog_type == DIALOG_CONDENSED and "-"..sequence_string.."-\n"..line_string or sequence_string.."|"..line_string
end

function create_dialog(vb, settings, data, dialog_type)
    local usable_window_width  = FULL_HD_WIDTH - SEPARATOR_WIDTH * 4
    local max_expected_columns = dialog_type == DIALOG_CONDENSED and 20 or 30
    local view                 = data.view
    local display_chords       = data.status ~= STATUS_LINES_OMITTED and settings.chord_calculation.value
    local row_count            = #view
    local column_count         = #view[1] - (display_chords and 0 or 2)
    local base_width           = math.min(column_count * usable_window_width / max_expected_columns, usable_window_width)
    local per_column_width     = base_width / column_count
    local total_width          = column_count * per_column_width + SEPARATOR_WIDTH
    local configuration_view   = configuration_section(vb, settings, data, dialog_type)
    local matrix_view          = vb:column { width = total_width, margin = CONTENT_MARGIN }
    local dialog_content       = vb:column { width = total_width, configuration_view, matrix_view }
    local index_width          = INDEX_WIDTH * (data.max_index / 3.5)

    -- Add a status bar (Deprecated, TODO: Remove)
    --[[ local bar_width = math.min(FULL_HD_WIDTH, total_width) - (display_chords and 0 or SEPARATOR_WIDTH + 2) + index_width
     if data.status and data.status.status ~= STATUS_OK then
        dialog_content:add_child(vb:row { width = bar_width,
                                          vb:button { width  = bar_width,
                                                      height = DEFAULT_MINI_CONTROL_HEIGHT,
                                                      id     = ID_STATUS_BAR,
                                                      color  = data.status.color,
                                                      active = false,
                                                      text   = "???" }})
    end

    -- Add a counterpoint bar
    if data.counterpoint and data.counterpoint.code then
        dialog_content:add_child(vb:row { width = bar_width,
                                          vb:button { width  = bar_width,
                                                      height = DEFAULT_MINI_CONTROL_HEIGHT,
                                                      id     = ID_COUNTERPOINT_BAR,
                                                      color  = COLOR_STATUS_WARNING,
                                                      active = false,
                                                      text   = "---" }})
    end ]]--

    dialog_content:add_child(table_header(vb, data, per_column_width, display_chords, dialog_type, index_width))
    dialog_content:add_child(vb:row { height = 5, vb:space {}})
    for y = 1, row_count do
        local aligner = vb:horizontal_aligner { width = per_column_width, mode  = "distribute" }
        local row     = vb:row                { width = per_column_width, aligner }
        if view[y][1].type == "note" then
            local note = view[y][1].note
            local index = index_string(note.sequence_index, note.line_index, dialog_type)
            aligner:add_child( vb:column { vb:button { width  = index_width,
                                                       height = ELEMENT_HEIGHT,
                                                       active = false,
                                                       color  = COLOR_IS_NOTE_MARKER,
                                                       text   = dialog_type == DIALOG_CONDENSED and index or index }})
        else
            aligner:add_child( vb:column { vb:button { width  = index_width,
                                                       height = ELEMENT_HEIGHT,
                                                       active = false,
                                                       color  = COLOR_DEFAULT,
                                                       text   = dialog_type == DIALOG_CONDENSED and "-\n" or "-" }})
        end
        for x = 1, column_count do
            local column = vb:column { width = per_column_width }
            local element = view[y][x]
            if     element.type == "note" then column:add_child(note_button(vb, per_column_width, element, y, x, dialog_type))
            elseif element.type == "data" then column:add_child(data_button(vb, per_column_width, element, y, x, dialog_type))
            elseif element.type == "text" then column:add_child(text_button(vb, per_column_width, element, y, x, dialog_type))
            end
            -- Lilia wanted to know what a comment is, :-)
            aligner:add_child(column)
            if x <= column_count + (display_chords and -2 or 0) then
                aligner:add_child(separator_button(vb, per_column_width, element, y, x, dialog_type))
            end
        end
        dialog_content:add_child(row)
    end
    return dialog_content
end