
--  ____ ____ _  _ _  _ ___ ____ ____ ___  ____ _ _  _ ___
--  |    |  | |  | |\ |  |  |___ |__/ |__] |  | | |\ |  |
--  |___ |__| |__| | \|  |  |___ |  \ |    |__| | | \|  |

-- Helper function to add concat violation strings to a table
local violation = function(violation, ...)
    local tables = {...}
    for _, t in ipairs(tables) do
        if t.violations then
            t.violations = t.violations.."\n"..violation
        else
            t.violations = violation
        end
    end
end

-- Check for some violations according to the counterpoint (Kontrapunkt) system
function check_counterpoint(data)

    -- If lines were omitted, counterpoint analysis is not supported
    if not data.complete then
        return data
    end

    local notes     = data.notes
    local row_count = #notes
    local fifths    = {}
    local fourths   = {}
    local octaves   = {}
    local leap_up   = {}
    local leap_down = {}
    local step_up   = {}
    local step_down = {}
    local empty     = {}

    local function leap_direction(n)
        return n > 0 and 1 or n < 0 and -1 or 0
    end

    for row = 1, row_count do
        fifths   [row] = nil
        fourths  [row] = nil
        octaves  [row] = nil
        leap_up  [row] = nil
        leap_down[row] = nil
        step_up  [row] = nil
        step_down[row] = nil
        empty    [row] = true
        for column = 1, #notes[row] do
            local t = notes[row][column].vertical
            if type(t) == 'table' then

                empty[row] = false

                -- Consecutive intervals
                fourths[row] = t.interval ==  5 and t or fourths[row]  -- also considers 11th, .. as fourths
                fifths [row] = t.interval ==  7 and t or fifths [row]  -- also considers 12th, .. as fifths
                octaves[row] = t.interval == 12 and t or octaves[row]  -- also considers 19th, .. as octaves

                -- Leaps
                local halftones = math.abs(t.halftones)
                local is_leap   = halftones >= 7
                -- Note: Unison is considered as a step, too, as the the effect is similar to a small step
                local is_step   = halftones == 1 or halftones == 2 or halftones == 0
                local direction = leap_direction(t.halftones)
                leap_up  [row] = (direction ==  1 and is_leap) and t or leap_up  [row]
                leap_down[row] = (direction == -1 and is_leap) and t or leap_down[row]
                step_up  [row] = ((direction ==  1 or direction == 0) and is_step) and t or step_up  [row]
                step_down[row] = ((direction == -1 or direction == 0) and is_step) and t or step_down[row]

                -- Tritone
                if t.interval == 6 then
                    violation("6", t)
                end
            end
        end
    end

    local previous
    previous = function(t, i)
        if t[i] ~= nil then
            return i, t[i]
        elseif i > 1 and empty[i] then
            return previous(t, i - 1)
        else
            return nil, nil
        end
    end

    local next
    next = function(t, i, rows)
        if t[i] ~= nil then
            return i, t[i]
        elseif i < rows and empty[i] then
            return next(t, i + 1, rows)
        else
            return nil, nil
        end
    end

    local consecutive
    consecutive = function(t1, t2, i, f)
        if t1[i] then
            local j, v = f(t2, i - 1)
            if v then
                return j
            end
        end
        return nil
    end

    for row = 2, row_count do
        local j = consecutive(fifths, fifths, row, previous)
        if j then
            violation("5-5", fifths[row], fifths[j])
        end
        local k = consecutive(octaves, octaves, row, previous)
        if k then
            violation("8-8", octaves[row], octaves[k])
        end
    end

    for row = 3, row_count do
        local i = consecutive(fifths, fourths, row, previous)
        if i and i > 1 then
            local j = consecutive(fourths, fifths, i, previous)
            if j then
                violation("5-4-5", fifths[row], fifths[j], fourths[i])
            end
        end
    end

    for row = 1, row_count - 1 do
        if leap_up[row] then
            local _, v = next(step_down, row + 1, row_count)
            if not v then
                violation(">=+7 ~-1|2", leap_up[row])
            end
        end
        if leap_down[row] then
            local _, v = next(step_up, row + 1, row_count)
            if not v then
                violation(">=-7 ~+1|2", leap_down[row])
            end
        end
    end

    return data
end
