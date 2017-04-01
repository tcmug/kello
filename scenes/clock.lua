
local composer = require( "composer" )
local clock = require( "objects.clock" )
local top = require( "objects.top" )
local bottom = require( "objects.bottom" )
local sun = require( "objects.sun" )
local moon = require( "objects.moon" )

local widget = require( "widget" )
local config = require( "misc.configuration" )
local debounce = require( "misc.debounce")
local tabs = require( "misc.tabs")

local scene = composer.newScene()

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- background

    local sky = display.newImageRect("sky-morning.png", display.actualContentWidth, display.actualContentHeight / 2)
    sky.x, sky.y = display.contentCenterX, (display.contentCenterY - (display.actualContentHeight / 4))
    sceneGroup:insert(sky)
    self.sky_morning = sky

    sky = display.newImageRect("sky-day.png", display.actualContentWidth, display.actualContentHeight / 2)
    sky.x, sky.y = display.contentCenterX, (display.contentCenterY - (display.actualContentHeight / 4))
    sceneGroup:insert(sky)
    self.sky_day = sky

    sky = display.newImageRect("sky-evening.png", display.actualContentWidth, display.actualContentHeight / 2)
    sky.x, sky.y = display.contentCenterX, (display.contentCenterY - (display.actualContentHeight / 4))
    sceneGroup:insert(sky)
    self.sky_evening = sky

    sky = display.newImageRect("sky-night.png", display.actualContentWidth, display.actualContentHeight / 2)
    sky.x, sky.y = display.contentCenterX, (display.contentCenterY - (display.actualContentHeight / 4))
    sceneGroup:insert(sky)
    self.sky_night = sky

    local sun = sun:create()
    sceneGroup:insert(sun)
    self.sun = sun

    local moon = moon:create()
    sceneGroup:insert(moon)
    self.moon = moon

    local ground = display.newRect(display.contentCenterX, display.contentCenterY + display.actualContentHeight / 2, display.actualContentWidth, display.actualContentHeight)
    ground:setFillColor( 0, 0.2, 0 )
    sceneGroup:insert(ground)
    self.ground = ground

    -- clock

    self.clock = clock:create(110)
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
    sceneGroup:insert(self.bottom)

    self.bottom.x = display.contentCenterX
    self.bottom.y = display.contentHeight + 70

    transition.to(self.bottom, {
        y = display.contentHeight - 30,
        time = 800,
        easing = easing.inOutCubic
    })

    self.accumulated = 0
    self.previous = system.getTimer()


    local t = tabs:new({
        count = 2,
        tabs = {
            "scenes.clock",
            "scenes.settings",
        }
    })

    t.x = display.contentCenterX
    t.y = display.actualContentHeight - 50

    -- Runtime listeners
    Runtime:addEventListener( "enterFrame", self )
end


function scene:destroy()
    print("destroyed")
    Runtime:removeEventListener( "enterFrame", self )
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
        transition.to(self.moon, {
            x = self.clock.x + (math.sin(moon) * (140)),
            y = self.clock.y + (math.cos(moon) * -(155)),
            time = 800,
            transition = easing.inOutCubic
        })

        local sun = ((math.pi * 2) / 24) * (h + (m / 60)) + math.pi
        transition.to(self.sun, {
            x = self.clock.x + (math.sin(sun) * (140)),
            y = self.clock.y + (math.cos(sun) * -(155)),
            time = 800,
            transition = easing.inOutCubic
        })

        local sky_ma = math.max(0, math.sin(sun))
        local sky_da = math.max(0, math.cos(sun))
        local sky_ea = math.max(0, -math.sin(sun))
        local sky_na = math.max(0, -math.cos(sun))

        --print(math.sin(sun), sky_ma, sky_da, sky_ea, sky_na)
        self.sky_morning.alpha = sky_ma
        self.sky_day.alpha = sky_da
        self.sky_evening.alpha = sky_ea
        self.sky_night.alpha = sky_na

        local c = math.cos(sun)
        if (c < 0) then
            c = 0
        end

        -- self.sky:setFillColor(0, 0, c * 0.7 + 0.1)
        self.ground:setFillColor(0, c * 0.5 + 0.1, 0)

        self.accumulated = self.accumulated - 1000

    end
end


-- hide()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then


        local sheet = graphics.newImageSheet("selector.png", {
            width = 32,
            height = 32,
            numFrames = 4
        })

        self.clock.second:set_sprite(
            sheet,
            config:get("arm.second", 1)
        )

        self.clock.minute:set_sprite(
            sheet,
            config:get("arm.minute", 1)
        )

        self.clock.hour:set_sprite(
            sheet,
            config:get("arm.hour", 1)
        )

    elseif ( phase == "did" ) then

    end
end

scene:addEventListener( "show", scene )
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

return scene
