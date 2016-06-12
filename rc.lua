-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local revelation = require("revelation")
local monitor = require("monitor")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
revelation.init()
-- theme.wallpaper = "/home/xiao/picture/ice.jpg"
beautiful.border_width = 0

-- This is used later as the default terminal and editor to run.
terminal = "termite"
file_manager = "thunar"
idaa = "idea.sh"
pycharm = "pycharm"
chrome = "google-chrome-stable"
editor = "vim"
-- editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
-- if beautiful.wallpaper then
--     for s = 1, screen.count() do
--         gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--     end
-- end

-- {{{ Function definitions

-- scan directory, and optionally filter outputs
function scandir(directory, filter)
    local i, t, popen = 0, {}, io.popen
    if not filter then
        filter = function(s) return true end
    end
    -- print(filter)
    for filename in popen('ls -a "'..directory..'"'):lines() do
        if filter(filename) then
            i = i + 1
            t[i] = filename
        end
    end
    return t
end

-- }}}

math.randomseed(os.time())
wp_path = "/home/xiao/picture/walpapers/"
wp_files = scandir(wp_path, wp_filter)
for s = 1, screen.count() do
    wp_index = math.random( 1, #wp_files)
    gears.wallpaper.maximized(wp_path .. wp_files[wp_index], s, true)
end

-- configuration - edit to your liking
-- wp_index = 1
-- wp_timeout  = 300
-- wp_path = "/home/xiao/picture/walpapers/"
-- wp_filter = function(s) return string.match(s,"%.png$") or string.match(s,"%.jpg$") end
-- wp_files = scandir(wp_path, wp_filter)

-- -- setup the timer
-- wp_timer = timer { timeout = wp_timeout }
-- wp_timer:connect_signal("timeout", 
--     function()
--         -- set wallpaper to current index for all screens
--         for s = 1, screen.count() do
--             wp_index = math.random( 1, #wp_files)
--             gears.wallpaper.maximized(wp_path .. wp_files[wp_index], s, true)
--         end
--     end)

-- -- initial start when rc.lua is first run
-- wp_timer:start()


-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    names = {"终端", "编程", "浏览器", "聊天", "虚拟机","备用",7,8,9},
    layout = {layouts[6], layouts[10], layouts[6], layouts[1], layouts[6],
            layouts[1], layouts[1], layouts[1], layouts[1]}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    { "restart", awesome.restart },
    { "quit", awesome.quit }
}

mymainmenu = awful.menu({ 
    items = { 
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal },
        { "File Manager", file_manager },
        { "IDEA", idea },
        { "Pycharm", pycharm },
        { "Chrome", chrome}

    }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
app_folders = { "/usr/share/applications/", "~/.local/share/applications/" }
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()
-- Create a net widget
-- mynetwidget = wibox.widget.textbox()
-- vicious.register(mynetwidget, vicious.widgets.net, '<span color="#CC9393">${ens33 down_kb} KB/S</span> <span color="#7F9F7F">${ens33 up_kb} KB/S</span>', 3)
-- theme.widget_net = "/usr/share/icons/Adwaita/16x16/actions/go-down.png"
-- theme.widget_netup = "/usr/share/icons/Adwaita/16x16/actions/go-up.png"
-- dnicon = wibox.widget.imagebox()
-- upicon = wibox.widget.imagebox()
-- dnicon:set_image(theme.widget_net)
-- upicon:set_image(theme.widget_netup)

-- Create a memwidget
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "Mem <span color='yellow'>$1% </span>", 13)

-- Create a cpuwidget
cpuwidget = wibox.widget.textbox()
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, "CPU <span color='yellow'>$1% </span>", 13)

battery_widget = wibox.widget.textbox()
vicious.register(battery_widget, vicious.widgets.bat, "BAT <span color='yellow'>$1 $2% </span>", 13, "BAT1")

vol_widget = wibox.widget.textbox()
vicious.register(vol_widget, vicious.widgets.volume, "$2 <span color='yellow'>$1% </span>", 13, "Master")

monitor_widget = wibox.widget.textbox()
monitor_ok = "<span color = 'yellow'> OK </span>"
-- monitor_ok = "<span color = 'red' background = 'yellow'> OK </span>"
monitor_widget:set_markup(monitor_ok)
monitor_timer = timer({timeout = 20})
monitor_timer:connect_signal("timeout", 
    function()
        message = monitor.work()
        if message == nil then
            monitor_widget:set_markup(monitor_ok)
        else
            monitor_widget:set_markup("<span color = 'red' background = 'yellow'> "..message.." </span>")
        end
    end)
monitor_timer:start()

-- function bat-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end),
awful.button({ }, 3, function ()
    if instance then
        instance:hide()
        instance = nil
    else
        instance = awful.menu.clients({
            theme = { width = 250 }
        })
    end
end),
awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    -- right_layout:add(dnicon)
    -- right_layout:add(mynetwidget)
    right_layout:add(monitor_widget)
    right_layout:add(battery_widget)
    right_layout:add(vol_widget)
    right_layout:add(cpuwidget)
    right_layout:add(memwidget)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
    function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
    function ()
        awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- User defined widgets
    awful.key({         }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/picture/screenshots/ 2>/dev/null'") end),
    -- awful.key({ "Shift" }, "Print", function () awful.util.spawn("scrot -s -e 'mv $f ~/picture/ 2>/dev/null'") end),
    awful.key({ modkey  }, "e", function () awful.util.spawn(file_manager) end),
    awful.key({ modkey  }, "s", revelation),
    awful.key({ modkey  }, "=", function() awful.util.spawn_with_shell("xbacklight -inc 10") end),
    awful.key({ modkey  }, "-", function() awful.util.spawn_with_shell("xbacklight -dec 10") end),
    awful.key({ "Mod1"  }, "=", 
        function() 
            awful.util.spawn_with_shell("amixer set Master 5+")
            vicious.force({vol_widget})
        end),
    awful.key({ "Mod1"}, "-", 
        function() 
            awful.util.spawn_with_shell("amixer set Master 5-") 
            vicious.force({vol_widget})
        end),
    awful.key({ "Mod1"}, "m", 
        function() 
            awful.util.spawn_with_shell("amixer set Master toggle") 
            vicious.force({vol_widget})
        end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
    function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end),
    awful.key({ modkey,           }, "m",
    function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
    function ()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
            awful.tag.viewonly(tag)
        end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = awful.tag.gettags(client.focus.screen)[i]
            if tag then
                awful.client.movetotag(tag)
            end
        end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = awful.tag.gettags(client.focus.screen)[i]
            if tag then
                awful.client.toggletag(tag)
            end
        end
    end))
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
-- function myfocus_filter(c)
--     if awful.client.focus.filter(c) then
--         -- This works with tooltips and some popup-menus
--         if c.class == 'Wine' and c.above == true then
--             return nil
--         elseif c.class == 'Wine'
--                     and c.type == 'dialog'
--                     and c.skip_taskbar == true
--                     and c.size_hints.max_width and c.size_hints.max_width < 160
--             then
--             -- for popup item menus of Photoshop CS5
--             return nil
--         else
--             return c
--         end
--     end
-- end
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
    -- focus = myfocus_filter,
    focus = awful.client.focus.filter,
    properties = { border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    raise = true,
    keys = clientkeys,
    buttons = clientbuttons } },
    -- { rule = { class = "MPlayer" },
    -- properties = { floating = true } },
    -- { rule = { class = "pinentry" },
    -- properties = { floating = true } },
    -- { rule = { class = "gimp" },
    -- properties = { floating = true } },
    -- -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    -- properties = { tag = tags[1][2] } },
    { rule = { class = "electronic-wechat" },
    properties = { floating = true } },
    { 
        rule_any = { 
            instance = {"QQ.exe", "TM.exe"},
        },
        properties = { 
            floating = true, 
            focusable = true,
            border_width = 0,
        } 
    },
}
-- }}}
-- alt_switch_keys = awful.util.table.join(
-- -- it's easier for a vimer to manage this than figuring out a nice way to loop and concat
-- awful.key({'Mod1'}, 1, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+1') end),
-- awful.key({'Mod1'}, 2, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+2') end),
-- awful.key({'Mod1'}, 3, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+3') end),
-- awful.key({'Mod1'}, 4, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+4') end),
-- awful.key({'Mod1'}, 5, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+5') end),
-- awful.key({'Mod1'}, 6, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+6') end),
-- awful.key({'Mod1'}, 7, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+7') end),
-- awful.key({'Mod1'}, 8, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+8') end),
-- awful.key({'Mod1'}, 9, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+9') end)
-- )
-- function bind_alt_switch_tab_keys(client)
--     client:keys(awful.util.table.join(client:keys(), alt_switch_keys))
-- end -- }}}

-- client.connect_signal("manage", function (c, startup)
--     -- 其它配置

--     if c.instance == 'TM.exe' then
--         -- 添加 Alt+n 支持
--         bind_alt_switch_tab_keys(c)
--         -- 关闭各类新闻通知小窗口
--         if c.name and c.name:match('^腾讯') and c.above then
--             c:kill()
--         end
--     end

--     -- 其它配置
-- end)

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
        )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- Autorun programs
autorun = true
autorunApps = 
{
    "xcompmgr -c -C -f -F -D 3 -l 0 -t 0 -r 5",
}
if autorun then
    for app = 1, #autorunApps do
        awful.util.spawn_with_shell(autorunApps[app])
    end
end
