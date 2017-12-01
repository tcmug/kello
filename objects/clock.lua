
-- The clock face.

local hand = require( "objects.hand" )

module = {}

-- Compute the difference in seconds between local time and UTC.
function get_timezone()
  local now = os.time()
  return os.difftime(now, os.time(os.date("!*t", now)))
end


function module:create(clock_size)

    local clock = display.newGroup()
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

    clock.hour = hand:create(clock_size - 35, 12 * 60 * 60)
    clock:insert(clock.hour)

    clock.minute = hand:create(clock_size - 20, 60 * 60)
    clock:insert(clock.minute)

    clock.second = hand:create(clock_size - 10, 60)
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
        if not self.paused then
            self.time = {
                tonumber(os.date("%H"):match("0*(%d+)")),
                tonumber(os.date("%M"):match("0*(%d+)")),
                tonumber(os.date("%S"):match("0*(%d+)"))
            }
            self.seconds = (self.time[1] * 60 * 60) + (self.time[2] * 60) + (self.time[3])
            self.hour:set(self.seconds, true)
            self.minute:set(self.seconds, true)
            self.second:set(self.seconds, true)
        end
    end

    function clock:advance(seconds)
        self.seconds = self.seconds + seconds
        self.hour:set(self.seconds, false)
        self.minute:set(self.seconds, false)
        self.second:set(self.seconds, false)
    end

    function clock:getTime()
        local h = self.seconds
        local m = self.seconds
        local s = self.seconds
        h = math.floor(h / 60 / 60)
        m = math.floor(m / 60) - (h * 60)
        if (s >= 60) then
            s = math.floor(s - math.floor(s / 60) * 60)
        end
        return h, m, s
    end

    clock:step()

    return clock

end


return module
