
local composer = require( "composer" )
local clock = require( "objects.clock" )
local top = require( "objects.top" )
local bottom = require( "objects.bottom" )
local scene = composer.newScene()

-- create()
function scene:create( event )

    local sceneGroup = self.view

    self.clock = clock:create()
    sceneGroup:insert(self.clock)

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
        self.accumulated = self.accumulated - 1000
    end
end

-- Scene listeners
scene:addEventListener( "create", scene )

-- Runtime listeners
Runtime:addEventListener( "enterFrame", scene )

return scene
