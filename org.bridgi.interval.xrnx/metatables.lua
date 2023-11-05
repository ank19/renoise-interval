require 'maths'
require 'settings'
require 'common'


Ratios = {}

function Ratios.new()
    return setmetatable({}, Ratios)
end

function Ratios:single(a, b)
    local ratios = {}
    ratios[1] = { a, b }
    self.__index = self
    return setmetatable(ratios, self)
end

function Ratios:ratio()
    if #self ~= 1 then
        error("Expected single ratio, but got "..#self.." ratios")
    end
    return self[1]
end

function Ratios:ab()
    local ratio = self:ratio()
    return ratio[1], ratio[2]
end

function Ratios:tostring(sep1, sep2)
    sep1 = sep1 or "/"
    sep2 = sep2 or " * "
    local s = ""
    local sep = ""
    for _, e in ipairs(self) do
        local a, b = unpack(e)
        s = s..sep..a..sep1..b
        sep = sep2
    end
    return s
end






Interval = { }

local interval_weaktable = setmetatable({}, { __mode = "k" })

function Interval:new(t)

    local function of(note1, note2, volume1, volume2)
        local halftones = note2 - note1
        local octaves   = math.floor(math.abs(halftones) / 12)
        local interval  = math.abs(halftones) % 12
        return {
            note1 = note1,
            note2 = note2,
            interval = (note1 ~= note2 and interval == 0) and 12 or interval,
            halftones = halftones,
            octaves = octaves * ((halftones < 0 and -1) or 1),
            volume = math.min(volume_percentage(volume1 or 0, volume2 or 0)) -- The reasoning here is that the note having the higher
                                                                             -- volume can be considered as prime anyhow and therefore
                                                                             -- can be discarded as the dissonance then resolves to one
        }
    end

    self.__index = self

    function self:properties()
        local key = cache_key(
                self.note1,
                self.note2,
                self.interval,
                self.octaves,
                self.volume or 0,
                settings.tuning.value,
                settings.pitch.value,
                settings.tuning_note.value,
                settings.hearing_threshold.value)
        if interval_weaktable[key] then
            trace_log("Returning cached interval details")
            return interval_weaktable[key]
        else
            local tuning_f = TUNING[settings.tuning.value]
            local a, b, cents, _, frequency1, frequency2 = tuning_f(self.note1, self.note2, self.interval, self.octaves)
            local ratios = Ratios:single(a, b)
            interval_weaktable[key] = {
                ratios = ratios,
                cents = cents,
                frequency1 = frequency1,
                frequency2 = frequency2,
                dissonance = dissonance_value(self.octaves, self.volume, 2, ratios)
            }
            trace_log("returning non-cached interval details")
            return interval_weaktable[key]
        end
    end
    return setmetatable(of(t.note1, t.note2, t.volume1, t.volume2), self)
end

function Interval:ratios()
    return self:properties().ratios
end

function Interval:ratio()
    return self:ratios():ratio()
end

function Interval:ab()
    return self:ratios():ab()
end
