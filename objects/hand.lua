
-- A clock hand.

module = {}

function clampRotation(degrees)
    if (degrees == 0) then
        return 360
    end
    if (degrees >= 360) then
        return degrees - (math.floor(degrees / 360) * 360)
    end
    return degrees
end

local hand = {}


function hand:step()
    self.step_value = self.step_value + 1
    if (self.step_value == self.steps) then
        self.step_value = 0
    end
    self:set(self.step_value, true)
end

function hand:set(value, animate)
    if (animate) then
        local new_rotation = clampRotation(value * self.step_sz)
        local function trim()
            self.rotation = clampRotation(self.rotation)
        end
        transition.to(self, {
            rotation = new_rotation,
            time = anim_time,
            transition = easing.outElastic,
            onComplete = trim
        })
    else
        self.rotation = clampRotation(value * self.step_sz)
    end
end

function hand:touch( event )
    if event.phase == "began" then
        display.getCurrentStage():setFocus( self, event.id )
        self.isFocus = true

        self.markX = self.x
        self.markY = self.y

    elseif self.isFocus then
        if event.phase == "moved" then
            self.x = event.x - event.xStart + self.markX
            self.y = event.y - event.yStart + self.markY

        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus( self, nil )
            self.isFocus = false
            transition.to(self, {
                x = self.markX,
                y = self.markY,
                time = 250,
                easing = easing.outElastic
            });

        end
    end

    return true
end

function hand_new()
    local temp = display.newGroup()
    for key, value in pairs(hand) do
        temp[key] = value
    end
    return temp
end

function hand:set_sprite(sprite, key)

    if self.graphic then
        self.graphic:removeSelf()
    end

    local sequence = {
        name = "idle",
        frames = { key },
        times = 1,
        loopCount = 0
    }

    self.graphic = display.newSprite( sprite, sequence )
    self.graphic.width = 32 * (self.length / 45)
    self.graphic.height = 32 * (self.length / 45)
    self.graphic.y = -(self.graphic.height / 2)
    self.graphic.rotation = -45
    self:insert(self.graphic)

end

function module:create(length, steps)

    local hand = hand_new()

    hand.length = length
    hand.step_sz = (360 / steps)
    hand.steps = steps
    hand.step_value = 0
    hand.rotation = 0

    -- make 'myObject' listen for touch events
    hand:addEventListener( "touch", hand )

    return hand

end


return module
