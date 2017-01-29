
-- The bottom part of the clock scene.

bottom = {}

function bottom:create()

    local group = display.newGroup()
    local clock_size = 150
    local offset = 0

    group.digital = display.newText(os.date("%H : %M : %S"), 0, -10, "Roboto-Regular.ttf", 17)
    group:insert(group.digital)

    group.period = display.newText("", 0, 10, "Roboto-Regular.ttf", 17)
    group:insert(group.period)

    function group:step()

        group.digital.text = os.date("%H : %M : %S")

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

    end

    group:step()

    return group

end


return bottom
