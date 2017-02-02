
local composer = require( "composer" )
local clock = require( "objects.clock" )
local top = require( "objects.top" )
local bottom = require( "objects.bottom" )
local scene = composer.newScene()

-- create()
function scene:create( event )

    local sceneGroup = self.view

    -- self.wheel = display.newImageRect("dn.png", 1200, 1200)
    -- self.wheel.y = display.contentHeight
    -- self.wheel.x = display.contentCenterX
    -- sceneGroup:insert(self.wheel)

    local sun = display.newImageRect("sun.png", 64, 64)
    sceneGroup:insert(sun)
    self.sun = sun


    local moon = display.newImageRect("moon.png", 64, 64)
    sceneGroup:insert(moon)
    self.moon = moon


    -- local sun = display.newImageRect("moon.png", 128, 128)
    -- sun.y = display.contentHeight
    -- sun.x = display.contentCenterX
    -- sceneGroup:insert(sun)
    -- self.sun = sun

    self.clock = clock:create()
    sceneGroup:insert(self.clock)
    self.clock.x, self.clock.y = display.contentCenterX, display.contentCenterY

    -- top

    self.top = top:create()
    sceneGroup:insert(self.top)

    self.top.x = display.contentCenterX
    self.top.y = -70

    transition.to(self.top, {
        y = 30,
        time = 800,
        transition = easing.inOutCubic
    })

    -- bottom

    self.bottom = bottom:create()
    sceneGroup:insert(self.top)

    self.bottom.x = display.contentCenterX
    self.bottom.y = display.contentHeight + 70

    transition.to(self.bottom, {
        y = display.contentHeight - 30,
        time = 800,
        transition = easing.inOutCubic
    })

    self.accumulated = 0
    self.previous = system.getTimer()

end

-- enterFrame() system callback
function scene:enterFrame()

    -- Use a pseudo fixed timestep for updating the clock.
    local time_now = system.getTimer()
    local delta = time_now - self.previous

    self.previous = time_now
    self.accumulated = self.accumulated + delta

    while (self.accumulated >= 1000) do

        self.top.step()
        self.clock:step(true)
        self.bottom.step()

        local h, m, s = self.clock:getTime()
        local seconds = (h * 60 * 60) + (m * 60) + s

        -- 6 - 18
        -- 18 - 24, 0 - 6
        local moon = ((math.pi * 2) / 24) * (h + (m / 60))
        self.moon.x = self.clock.x + (math.sin(moon) * (170))
        self.moon.y = self.clock.y + (math.cos(moon) * -(170))

        local sun = ((math.pi * 2) / 24) * (h + (m / 60)) + math.pi
        self.sun.x = self.clock.x + (math.sin(sun) * (170))
        self.sun.y = self.clock.y + (math.cos(sun) * -(170))

        self.accumulated = self.accumulated - 1000

    end
end

-- Scene listeners
scene:addEventListener( "create", scene )

-- Runtime listeners
Runtime:addEventListener( "enterFrame", scene )

return scene
