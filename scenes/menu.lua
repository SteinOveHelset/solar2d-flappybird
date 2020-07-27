-- -----------------------------------------------------------------------------------
-- Import
-- -----------------------------------------------------------------------------------

local composer = require("composer")
local relayout = require("relayout")
local utilities = require("utilities")



-- -----------------------------------------------------------------------------------
-- Set variables
-- -----------------------------------------------------------------------------------

-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY

-- Scene
local scene = composer.newScene()

-- Groups
local grpMain



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  print("scene:create - menu")

  -- Create main group and insert to scene
  grpMain = display.newGroup()

  self.view:insert(grpMain)

  -- Insert objects to grpMain here

  local bg = display.newImageRect("background.png", _W, _H)
  bg.x = _CX
  bg.y = _CY
  grpMain:insert(bg)

  --

  local btnPlay = display.newText("Tap to start", _CX, _CY, "PressStart2P-Regular.ttf", 25)
  grpMain:insert(btnPlay)

  btnPlay:addEventListener("tap", function() 
    composer.gotoScene("scenes.game")
  end)
end



-- show()
function scene:show( event )
  if ( event.phase == "will" ) then
  elseif ( event.phase == "did" ) then
  end
end



-- hide()
function scene:hide( event )
  if ( event.phase == "will" ) then
  elseif ( event.phase == "did" ) then
  end
end



-- destroy()
function scene:destroy(event)
  if event.phase == "will" then
  end
end



-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
