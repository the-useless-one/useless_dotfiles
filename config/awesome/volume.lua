local io = io
local string = string

module('volume')

cardid  = 0
channel = "Master"

function update_volume(mode, widget)
	local prefix = ' <span color="#FFFFFF">♫ </span>'
    if mode == "update" then
        local fd = io.popen("amixer -c " .. cardid .. " -- sget " .. channel)
        local status = fd:read("*all")
        fd:close()

        local volume = string.match(status, "(%d?%d?%d)%%")
        volume = string.format("%3d", volume)

        status = string.match(status, "%[(o[^%]]*)%]")

        if string.find(status, "on", 1, true) then
            volume = prefix .. volume .. "% " ..'<span font-weight="bold" color="#FFFFFF">::</span>'

        else
            volume = prefix .. '<span font-weight="bold" color="#FF0000">  0% </span>'
            volume = volume .. '<span font-weight="bold" color="#FFFFFF">::</span>'

        end
        widget.text = volume
    elseif mode == "up" then
        io.popen("amixer -c " .. cardid .. " sset " .. channel .. " unmute"):read("*all")
        io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%+"):read("*all")
        update_volume("update", widget)
    elseif mode == "down" then
        io.popen("amixer -c " .. cardid .. " sset " .. channel .. " unmute"):read("*all")
        io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-"):read("*all")
        update_volume("update", widget)
    else
        io.popen("amixer -c " .. cardid .. " sset " .. channel .. " toggle"):read("*all")
        update_volume("update", widget)
    end
end

