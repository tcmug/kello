
-- The top part of the clock scene.

sun = {}

function sun:create()

    local group = display.newGroup()
    local sun = display.newImageRect("sun.png", 100, 100)
    local shine1 = display.newImageRect("shine.png", 36, 36)
    local shine2 = display.newImageRect("shine.png", 36, 36)
    local shine3 = display.newImageRect("shine.png", 36, 36)
    sun.x, sun.y = 0, 0
    group.x, group.y = display.contentCenterX, display.contentCenterY
    group:insert(shine1)
    group:insert(shine2)
    group:insert(shine3)
    group:insert(sun)

    local fadein, fadeout

    function fadein(obj)
        obj.alpha = 0
        obj.width = 300
        obj.height = 300
        obj.time = (math.random() * 5000) + 5000
        obj.target = (math.random() * 45) - (45/2)
        obj.rotation = math.random() * 90
        transition.to(obj, {
            time=obj.time,
            alpha=0.2,
            rotation=obj.rotation + obj.target,
            onComplete=fadeout
        })
    end

    function fadeout(obj)
        transition.to(obj, {
            time=obj.time,
            alpha=0,
            scaleX=2,
            rotation=obj.rotation + obj.target,
            onComplete=fadein
        })
    end

    shine1.rotation = math.random() * 360
    shine2.rotation = math.random() * 360
    shine3.rotation = math.random() * 360

    fadein(shine1)
    fadein(shine2)
    fadein(shine3)

    return group

end


return sun
