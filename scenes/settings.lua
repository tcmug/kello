
local composer = require( "composer" )
local selector = require("misc.selector")
local scene = composer.newScene()
local config = require("misc.configuration")

-- create()
function scene:create( event )
    local sceneGroup = self.view
    local rect = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    rect:setFillColor( 0.4, 0.4, 0.3 )
    sceneGroup:insert(rect)

    local sel = selector:create({
        count = 4,
        selected = config:get("arm.hour", 1),
        items = {
            "scenes.clock",
            "hello",
            "scenes.settings",
            "yikes",
        }
    })
    sel.x, sel.y = display.contentCenterX, display.contentCenterY - 60
    sceneGroup:insert(sel)

    self.hour_selector = sel

    sel = selector:create({
        count = 4,
        selected = config:get("arm.minute", 1),
        items = {
            "scenes.clock",
            "hello",
            "scenes.settings",
            "yikes",
        }
    })

    sel.x, sel.y = display.contentCenterX, display.contentCenterY
    sceneGroup:insert(sel)

    self.min_selector = sel

    sel = selector:create({
        count = 4,
        selected = config:get("arm.second", 1),
        items = {
            "scenes.clock",
            "hello",
            "scenes.settings",
            "yikes",
        }
    })

    sel.x, sel.y = display.contentCenterX, display.contentCenterY + 60
    sceneGroup:insert(sel)

    self.sec_selector = sel

end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        config:set("arm.hour", self.hour_selector.selected)
        config:set("arm.minute", self.min_selector.selected)
        config:set("arm.second", self.sec_selector.selected)

    elseif ( phase == "did" ) then

    end
end


-- Scene listeners
scene:addEventListener( "hide", scene )
scene:addEventListener( "create", scene )

return scene
