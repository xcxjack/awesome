-- {{{ Grab environment
local http = require("socket.http")
-- }}}

local log_location = "/home/logs"
local services = {
    {name = "breakfast", url = "http://breakfast.anlaiye.com.cn/breakfast/settings/list"},
    -- {name = "breakfast", url = "http://breakfast.anlaiye.com.cn/breakfast/settings/list"}
}

local M = {}
local monitor = M

-- monitor: a web monitor, test web server
-- {{{ Monitor widget type
function M.work()
    local message = nil
    for i = 1, #services do
        local service = services[i]
        local name = service.name
        local dir = log_location.."/"..name
        local old_log = dir.."/error.log"
        local new_log = dir.."/error.new.log"
        local urlstr = service.url
        -- print(name)
        -- print(urlstr)
        local t = {}
        local r, c, h = http.request{
            url = urlstr,
            sink = ltn12.sink.table(t)
        }
        -- return r, c, h, table.concat(t)
        -- print("r="..r)
        -- print("c="..c)
        -- print("h="..table.concat(h))
        local data = table.concat(t)
        -- print("body="..data)
        os.execute("mkdir -p "..dir)
        local new_file = io.open(new_log, "w")
        new_file:write(data)
        new_file:write("\n")
        local new_length = string.len(data) + 1
        new_file:close()
        -- print(new_length)
        local old_file = io.open(old_log, "r")
        if old_file == nil then
            os.execute("cp "..new_log.." "..old_log)
        else
            local old_length = old_file:seek("end")
            -- print(old_length)
            old_file:close()
            if new_length > old_length or r == false or c ~= 200 then
                if message == nil then
                    message = name
                else
                    message = message.." "..name
                end
            else
                os.execute("cp "..new_log.." "..old_log)
            end
        end
    end
    return message
end

return monitor
