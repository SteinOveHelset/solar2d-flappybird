display.setStatusBar(display.HiddenStatusBar)

local composer = require('composer')
composer.recycleOnSceneChange = true
composer.gotoScene( "scenes.menu" )