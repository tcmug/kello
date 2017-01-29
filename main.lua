
local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

local options = {
    effect = "fade",
    time = 0
}

composer.gotoScene("scenes.clock", options)

