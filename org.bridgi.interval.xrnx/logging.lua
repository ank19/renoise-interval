if renoise.app() then
    interval_log_file_name = renoise.app().log_filename.."_interval.log"
    interval_log_file = io.open(interval_log_file_name, "a")
end

local function log(level, something)
    if interval_log_file then
        interval_log_file:write(tostring(level.." "..something),"\n")
        interval_log_file:flush()
    else
        print(tostring(level.."  "..something))
    end
end

function trace_log(something)
    log("TRACE", something)
end

function error_log(something)
    log("ERROR", something)
end

function test_log(something)
    log("TEST ", something)
end

function vararg_tostring(separator, ...)
    local N = select('#', ...)
    if not ... or N == 0 then return "<empty varargs>" end
    local s = ""
    local sep = ""
    for i = 1, N do
        s = s..sep..select(i, ...)
        sep = separator
    end
    return s
end
