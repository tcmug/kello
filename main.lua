
local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

display.setDefault('magTextureFilter', 'nearest')
display.setDefault('minTextureFilter', 'nearest2')

composer.gotoScene( "scenes.clock" )

