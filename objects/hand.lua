
-- A clock hand.

hand = {}

function clampRotation(degrees)
    if (degrees == 0) then
        return 360
    end
    if (degrees >= 360) then
        return degrees - (math.floor(degrees / 360) * 360)
    end
    return degrees
end

function hand:create(image_src, length, steps)

    local hand = display.newGroup()
    local image = display.newImage(image_src)

    local ratio = image.width / image.height
    local scaled_height = length
    local scaled_width = image.width * ratio

    image:removeSelf()

    local line = display.newImageRect(image_src, image.width, scaled_height)


    line.y = -line.height / 2

    hand:insert(line)
    hand.step_sz = (360 / steps)
    hand.steps = steps
    hand.step_value = 0
    hand.rotation = 0
    hand:insert(line)

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


    -- make 'myObject' listen for touch events
    hand:addEventListener( "touch", hand )

    return hand

end


return hand
