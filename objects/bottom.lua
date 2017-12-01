
-- The bottom part of the clock scene.

bottom = {}

function bottom:create(clock)

    local group = display.newGroup()
    local clock_size = 150
    local offset = 0

    group.clock = clock
    group.digital = display.newText(os.date("%H : %M : %S"), 0, -20, "Roboto-Regular.ttf", 17)
    group:insert(group.digital)

    group.period = display.newText("", 0, 0, "Roboto-Regular.ttf", 17)
    group:insert(group.period)

    group.month = display.newText("", 0, 20, "Roboto-Regular.ttf", 17)
    group:insert(group.month)

    group.extra = display.newText("", 0, 40, "Roboto-Regular.ttf", 17)
    group:insert(group.extra)

    local months = {
        "tammikuu",
        "helmikuu",
        "maaliskuu",
        "huhtikuu",
        "toukokuu",
        "kesäkuu",
        "heinäkuu",
        "elokuu",
        "syyskuu",
        "lokakuu",
        "marraskuu",
        "joulukuu"
    }

    function group:step()

        month = os.date("%m")
        h, m, s = group.clock:getTime()
        group.digital.text = string.format("%02d : %02d : %02d", h, m, s)
        local day = tonumber(os.date("%d"):match("0*(%d+)"))
        local month = tonumber(os.date("%m"):match("0*(%d+)"))
        local mth = tonumber(os.date("%H"):match("0*(%d+)"))

        if (mth >= 22) then
            group.period.text = "On yö"
        elseif (mth >= 17) then
            group.period.text = "On ilta"
        elseif (mth >= 10) then
            group.period.text = "On päivä"
        elseif (mth >= 6) then
            group.period.text = "On aamu"
        elseif (mth >= 0) then
            group.period.text = "On yö"
        end

        group.month.text = day .. " " .. months[month] .. 'ta';

        if (month == 12) then
            if (day < 24) then
                group.extra.text = (24 - day) .. " yötä jouluun!"
            elseif (day == 24) then
                group.extra.text = "JOULUAATTO!"
            end
        end
    end

    group:step()

    return group

end


return bottom
