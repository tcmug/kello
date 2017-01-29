
-- The top part of the clock scene.

top = {}

function top:create()

    local group = display.newGroup()
    local clock_size = 150
    local offset = 0

    group.day = display.newText("", 0, -10, "Roboto-Regular.ttf", 17)
    group:insert(group.day)

    group.explanatory = display.newText("", 0, 10, "Roboto-Regular.ttf", 17)
    group:insert(group.explanatory)

    function group:step()

        local td = tonumber(os.date("%w"))

        local days = {
            "sunnuntai",
            "maanantai",
            "tiistai",
            "keskiviikko",
            "torstai",
            "perjantai",
            "lauantai"
        }

        local th = tonumber(os.date("%I"):match("0*(%d+)"))
        local tm = tonumber(os.date("%M"):match("0*(%d+)"))
        local ts = tonumber(os.date("%S"):match("0*(%d+)"))

        group.day.text = "Tänään on " .. days[td + 1]

        if (tm < 1) then
            group.explanatory.text = "Kello on tasan " .. th
        elseif (tm < 30) then
            group.explanatory.text = "Kello on " .. tm .. " minuuttia yli " .. th
        elseif (tm == 30) then
            if (th == 12) then
                group.explanatory.text = "Kello on puoli 1"
            else
                group.explanatory.text = "Kello on puoli " .. (th + 1)
            end
        else
            if (th == 12) then
                group.explanatory.text = "Kello on " .. (60 - tm) .. " minuuttia vailla 1"
            else
                group.explanatory.text = "Kello on " .. (60 - tm) .. " minuuttia vailla " .. (th + 1)
            end
        end

    end

    group:step()

    return group

end


return top
