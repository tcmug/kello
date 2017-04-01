--[[

local debounce = require( "debounce" )

Usage:

    local function onTap()
        print( "Tapped!" )
    end

    myObj:addEventListener( "tap", debounce( 200, onTap ) )

]]

debounce = {}
debounce_mt = { __index = debounce }

function debounce_new(time, func)
    local new = setmetatable( { debounce=false, func=func, time=time }, debounce_mt)
    local function wrap(event)
        new:call(event)
    end
    return wrap
end

function debounce:call(event)
    if (self.debounce) then
        return
    end
    self.func(event)
    self.debounce = true
    timer.performWithDelay(self.time, self)
end

function debounce:timer()
    self.debounce = false
end

return debounce_new
