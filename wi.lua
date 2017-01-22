local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")
-- Battery widget
local assault = require('assault')

-- Spacers
volspace = wibox.widget.textbox()
volspace:set_text(" ")

-- {{{ BATTERY
-- Battery attributes
myassault = assault({
  critical_level = 0.15,
  critical_color = "#ff0000",
  charging_color = "#00ff00"
})
-- End Battery}}}
--
-- {{{ PACMAN
-- Icon
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)
--
-- Upgrades
pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg, function(widget, args)
   if args[1] > 0 then
   pacicon:set_image(beautiful.widget_pacnew)
   else
   pacicon:set_image(beautiful.widget_pac)
   end

  return args[1]
  end, 1801, "Arch S") -- Arch S for ignorepkg
--
-- Buttons
  function popup_pac()
  local pac_updates = ""
  local f = io.popen("pacman -Sup --dbpath /tmp/pacsync")
  if f then
  pac_updates = f:read("*a"):match(".*/(.*)-.*\n$")
  end
  f:close()
  if not pac_updates then
  pac_updates = "System is up to date"
  end
  naughty.notify { text = pac_updates }
  end
  pacwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_pac)))
  pacicon:buttons(pacwidget:buttons())
-- End Pacman }}}
--
-- {{{ VOLUME
-- Cache
vicious.cache(vicious.widgets.volume)
--
-- Icon
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
--
-- Volume %
volpct = wibox.widget.textbox()
vicious.register(volpct, vicious.widgets.volume, "$1%", nil, "Master")
--
-- Buttons
volicon:buttons(awful.util.table.join(
     awful.button({ }, 1,
     function() awful.util.spawn_with_shell("amixer -q set Master toggle") end),
     awful.button({ }, 4,
     function() awful.util.spawn_with_shell("amixer -q set Master 3+% unmute") end),
     awful.button({ }, 5,
     function() awful.util.spawn_with_shell("amixer -q set Master 3-% unmute") end)
            ))
     volpct:buttons(volicon:buttons())
     volspace:buttons(volicon:buttons())
 -- End Volume }}}
 --
-- {{{ Start CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
--
cpu = wibox.widget.textbox()
vicious.register(cpu, vicious.widgets.cpu, "All: $1% 1: $2% 2: $3% 3: $4% 4: $5%", 2)
-- End CPU }}}
--
-- {{{ Start Mem
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_ram)
--
mem = wibox.widget.textbox()
vicious.register(mem, vicious.widgets.mem, "Mem: $1% Use: $2MB Total: $3MB Free: $4MB Swap: $5%", 2)
-- End Mem }}}
--
-- {{{ Start Wifi
wifiicon = wibox.widget.imagebox()
wifiicon:set_image(beautiful.widget_wifi)
--
wifi = wibox.widget.textbox()
vicious.register(wifi, vicious.widgets.wifi, "${ssid} Rate: ${rate}MB/s Link: ${link}%", 3, "wlp4s0f0")
-- End Wifi }}}
