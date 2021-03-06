
local debounce = require("misc.debounce")
local composer = require( "composer" )

module = {}

local select_item = {
}

function select_item:right()
    transition.to(self, {
        transition = easing.linear,
        x = self.x - self.width,
        time = 100
    })
end

function select_item:left()
    transition.to(self, {
        transition = easing.linear,
        x = self.x + self.width,
        time = 100
    })
end

function select_item_new(temp, width, height)
    temp.width = width
    temp.height = height
    for key, value in pairs(select_item) do
        temp[key] = value
    end
    return temp
end

limit = function ( obj )
    obj.parent:limit(obj)
end

function module:create(conf)

    local selHeight = 50
    local selWidth = 50

    local group = display.newGroup()

    group.config = conf
    group.selected = conf.selected

    function tap_left()
        if group.selected == 1 then
            return
        end
        group.selected = group.selected - 1
        for i=1, group.numChildren do
            if group[i].left ~= nil then
                group[i]:left()
            end
        end
    end

    function tap_right()
        if group.selected == conf.count then
            return
        end
        group.selected = group.selected + 1
        for i=1, group.numChildren do
            if group[i].right ~= nil then
                group[i]:right()
            end
        end
    end

    local selX = -(conf.selected - 1) * selWidth

    local sheet = graphics.newImageSheet("selector.png", {
        width = 128,
        height = 128,
        numFrames = 4
    })



    --local character = display.newSprite( sheet, sequence )

    local sceneGroup = self.view
    local rect = display.newRect(0, 0, 50, 50)
    rect:setFillColor( 0.5, 0.5, 0.5 )
    group:insert(rect)

    for key, value in pairs(conf.items) do

        local sequence = {
            name = "idle",
            frames = { key },
            times = 1,
            loopCount = 0
        }

        local moon = select_item_new(display.newSprite( sheet, sequence ), selWidth, selHeight)

        moon.x = selX
        selX = selX + selWidth

        group:insert(moon)
    end


    local switcher = graphics.newImageSheet("sa.png", {
        width = 64,
        height = 64,
        numFrames = 2
    })

    local left = {
        name = "left",
        frames = { 1 },
        times = 1,
        loopCount = 0
    }

    local right = {
        name = "right",
        frames = { 2 },
        times = 1,
        loopCount = 0
    }

    local rect = display.newSprite( switcher, left )
    rect.x = -display.contentCenterX + 32
    rect.y = 0
    rect.width = selWidth
    rect.height = selHeight
    group:insert(rect)
    rect:addEventListener("tap", debounce( 100, tap_left))

    local rect = display.newSprite( switcher, right )
    rect.x = display.contentCenterX - 32
    rect.y = 0
    rect.width = selWidth
    rect.height = selHeight
    group:insert(rect)

    group:insert(rect)

    rect:addEventListener("tap", debounce( 100, tap_right))

    return group

end

return module

--[[

    1  2  3  4

    4 [1] 2  3

]]

