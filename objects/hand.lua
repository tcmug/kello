
-- A clock hand.

module = {}

local hand = {}

function clampRotation(degrees)
    return degrees - (math.floor(degrees / 360) * 360)
end

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
        if (new_rotation < self.rotation) then
            new_rotation = new_rotation + 360
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
        self.parent.paused = true

        local x = event.x - self.parent.x
        local y = event.y - self.parent.y

        local deg = math.atan2(x, -y) * (180 / math.pi)
        if (deg < 0) then
            deg = 360 + deg
        end

        self.prev_deg = deg

    elseif self.isFocus then

        if event.phase == "moved" then
            local x = event.x - self.parent.x
            local y = event.y - self.parent.y

            local deg = math.atan2(x, -y) * (180 / math.pi)
            if (deg < 0) then
                deg = 360 + deg
            end

            local diff = deg - self.prev_deg
            self.prev_deg = deg

            if (diff > 300) then
                diff = diff - 360
            end

            if (diff < -300) then
                diff = diff + 360
            end

            if (diff > 1 or diff < 1) then
                self.parent:advance(diff / (360 / self.steps))
            end

        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus( self, nil )
            self.isFocus = false
            self.parent.paused = false
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
