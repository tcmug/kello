
local debounce = require("misc.debounce")
local composer = require( "composer" )

tabs = {}

function tabs:new(tabs)

    local group = display.newGroup()
    local tabHeight = 50
    local tabWidth = display.actualContentWidth / tabs.count
    local tabX = (tabs.count / 2) * -tabWidth + (tabWidth/2)

    local active = 1

    local function tapped(event)
        if (active == event.target.index) then
            return
        end
        local options = {
            effect = "slideLeft",
            time = 200
        }
        if (active > event.target.index) then
            options.effect = "slideRight"
        end
        composer.gotoScene( event.target.scene, options )
        active = event.target.index
    end

    local tap_debouncer = debounce(300, tapped)

    for key, value in pairs(tabs.tabs) do
        local rect = display.newRect(tabX, 0, tabWidth - 2, tabHeight - 2)
        rect.index = key
        rect:setFillColor( 0, 1, 0 )
        rect.scene = value
        group:insert(rect)
        tabX = tabX + tabWidth

        rect:addEventListener("tap", tap_debouncer)
    end

    return group
end

return tabs
