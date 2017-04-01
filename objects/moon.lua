
-- The top part of the clock scene.

moon = {}

function moon:create()

    local group = display.newGroup()

    local moon = display.newImageRect("moon.png", 100, 100)
    group:insert(moon)

    group.x, group.y = display.contentCenterX, display.contentCenterY

    return group

end


return moon
