local calendar = nil
local offset = 0

function remove_calendar()
    if calendar ~= nil then
	naughty.destroy(calendar)
	calendar = nil
	offset = 0
    end
end

function add_calendar(inc_offset)
    local save_offset = offset
    remove_calendar()
    offset = save_offset + inc_offset
    local datespec = os.date("*t")
    datespec = datespec.year * 12 + datespec.month - 1 + offset
    datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
    local day = os.date("%d")
    local cal = awful.util.pread("ncal -hCm " .. datespec)
    cal = string.gsub(cal, ' '..day..' ', '<span font-weight="bold" color="#FFFFFF"> '..day..' </span>')
    calendar = naughty.notify({
	text = string.format('<span font_desc="%s">%s</span>', "monospace", cal),
	timeout = 0, hover_timeout = 0.5,
	width = 160,
    })
end
