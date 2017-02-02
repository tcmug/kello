
-- The clock face.

local hand = require( "objects.hand" )

clock = {}

function clock:create()

    local clock = display.newGroup()
    local clock_size = 145

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

    clock.hour = hand:create("hand.png", 100, 12 * 60 * 60)
    clock:insert(clock.hour)

    clock.minute = hand:create("hand.png", 120, 60 * 60)
    clock:insert(clock.minute)

    clock.second = hand:create("sec_hand.png", 130, 60)
    clock:insert(clock.second)

    local circle = display.newCircle(0, 0, 10, 10)
    circle.x = 0
    circle.y = 0
    circle:setFillColor( 0, 0, 0 )
    circle.strokeWidth = 4
    circle:setStrokeColor( 1, 1, 1 )
    clock:insert(circle)
    local anim_time = 300

    function clock:step()
        local h, m, s = self:getTime()
        self.hour:set(h * 60 * 60 + (m * 60), true)
        self.minute:set(m * 60 + s, true)
        self.second:set(s, true)
    end

    function clock:getTime()
        return tonumber(os.date("%H"):match("0*(%d+)")),
            tonumber(os.date("%M"):match("0*(%d+)")),
            tonumber(os.date("%S"):match("0*(%d+)"))

    end

    clock:step();

    return clock

end


return clock
