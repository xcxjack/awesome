-- {{{ Grab environment
local http = require("socket.http")
local io = { open = io.open }
local setmetatable = setmetatable
local math = { floor = math.floor }
local table = { insert = table.insert }
-- }}}

local log_location = "/home/log"
local services = {
    {name = "breakfast", url = "http://breakfast.anlaiye.com.cn/breakfast/settings/list"},
    {name = "breakfast", url = "http://breakfast.anlaiye.com.cn/breakfast/settings/list"}
}

for i = 1, #services do
    service = services[i]
    name = service.name
    urlstr = service.url
    print(name)
    print(url)
    r, c = http.request{ url = urlstr }

    print("r="..r)
    print("c="..c)
end

-- monitor: a web monitor, test web server
-- xiao.widgets.monitor
local monitor = {}

-- Initialize function tables
local result  = {}

-- {{{ Monitor widget type
local function worker(format)
    local cpu_lines = {}

    -- Get CPU stats
    for s in services do
        print "abc"
    end

    -- for i, v in ipairs(cpu_lines) do
    --     -- Calculate totals
    --     local total_new = 0
    --     for j = 1, #v do
    --         total_new = total_new + v[j]
    --     end
    --     local active_new = total_new - (v[4] + v[5])

    --     -- Calculate percentage
    --     local diff_total  = total_new - cpu_total[i]
    --     local diff_active = active_new - cpu_active[i]

    --     if diff_total == 0 then diff_total = 1E-6 end
    --     cpu_usage[i]      = math.floor((diff_active / diff_total) * 100)

    --     -- Store totals
    --     cpu_total[i]   = total_new
    --     cpu_active[i]  = active_new
    -- end

    return "1"
end
-- }}}

return setmetatable(monitor, { __call = function(_, ...) return worker(...) end })
