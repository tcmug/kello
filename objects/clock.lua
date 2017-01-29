
-- The clock face.

clock = {}

function clock:create()

    local clock = display.newGroup()
    local clock_size = 150

    local circle = display.newCircle(320, 570, clock_size, clock_size)
    circle.x = 0
    circle.y = 0
    circle:setFillColor( 0, 0, 0 )
    circle.strokeWidth = 4
    circle:setStrokeColor( 1, 1, 1 )
    clock:insert(circle)
    local anim_time = 300

    delta = 0

    clock.x, clock.y = display.contentCenterX, display.contentCenterY

    local secondsMargin = 13
    local numberMargin = 33

    for number = 1,60 do
        local sz = 2
        if (number % 5 == 0) then
            sz = 4
        end
        local seconds = display.newCircle(0, 0, sz, sz)
        delta = ((math.pi * 2) / 60) * number
        seconds.x = (math.sin(delta) * (clock_size - secondsMargin))
        seconds.y = (math.cos(delta) * -(clock_size - secondsMargin))
        seconds:setFillColor( 0.5, 0.5, 0.5 )
        clock:insert(seconds)
    end


    for number = 1,12 do
        local hours = display.newText(number, 0, 0, "Roboto-Regular.ttf", 15)
        delta = ((math.pi * 2) / 12) * number
        hours.x = (math.sin(delta) * (clock_size - numberMargin))
        hours.y = (math.cos(delta) * -(clock_size - numberMargin))
        clock:insert(hours)
    end

    local function hand(steps, delay, hand_length, color)

        local the_hand = display.newGroup()

        local line = display.newRect(0, -hand_length / 2, 3, hand_length)
        line:setFillColor(color[1], color[2], color[3])
        the_hand:insert(line)
        the_hand.step_sz = (360 / steps)
        the_hand.steps = steps
        the_hand.rotation = 0

        the_hand.set = function(value, animate)
            if (animate) then
                local rotation = value * the_hand.step_sz
                if (rotation == 0) then
                    rotation = 360
                end
                local function trimRotation()
                    if (the_hand.rotation >= 360) then
                        the_hand.rotation = the_hand.rotation - 360
                    end
                end
                transition.to(the_hand, {
                    rotation = rotation,
                    time = anim_time,
                    transition = easing.outElastic,
                    onComplete = trimRotation
                })
            else
                the_hand.rotation = value * the_hand.step_sz
            end
        end
        return the_hand
    end

    local th = os.date("%I"):match("0*(%d+)")
    local tm = os.date("%M"):match("0*(%d+)")
    local ts = os.date("%S"):match("0*(%d+)")

    clock.hour   = hand(12 * 60 * 60, 60 * 60, clock_size - 55, {1,1,1})
    clock.minute = hand(60 * 60, 60, clock_size - 25, {1,1,1})
    clock.second = hand(60, 1, clock_size - 20, {1,0,0})
    clock.second.set(ts)

    clock:insert(clock.hour)
    clock:insert(clock.minute)
    clock:insert(clock.second)

    local circle = display.newCircle(0, 0, 5, 5)
    circle.strokeWidth = 5
    circle:setStrokeColor( 1, 1, 1 )
    clock:insert(circle)

    function clock:step(animate)
        local th = tonumber(os.date("%I"):match("0*(%d+)"))
        local tm = tonumber(os.date("%M"):match("0*(%d+)"))
        local ts = tonumber(os.date("%S"):match("0*(%d+)"))

        self.hour.set(th * 60 * 60 + (tm * 60), animate)
        self.minute.set(tm * 60 + ts, animate)
        self.second.set(ts, animate)
    end

    clock:step(false)

    return clock

end


return clock
