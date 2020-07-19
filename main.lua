-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local relayout = require("relayout")

--
-- Layout

local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY

--
-- Variables

local pipes = {}
local canAddPipe = 0
local hasStarted = false
local score = 0

--
-- Groups

local grpMain = display.newGroup()

local grpWorld = display.newGroup()
grpMain:insert(grpWorld)

local grpHud = display.newGroup()
grpMain:insert(grpHud)

--
-- Backgrounds

local backgrounds = {}

local b1 = display.newImageRect(grpWorld, "background.png", _W, _H)
b1.x = _CX
b1.y = _CY
backgrounds[#backgrounds+1] = b1

local b2 = display.newImageRect(grpWorld, "background.png", _W, _H)
b2.x = _CX + _W
b2.y = _CY
backgrounds[#backgrounds+1] = b2

local b3 = display.newImageRect(grpWorld, "background.png", _W, _H)
b3.x = _CX + (_W * 2)
b3.y = _CY
backgrounds[#backgrounds+1] = b3

--
-- Sounds

local sndFlap = audio.loadStream("flap.wav")
local sndCrash = audio.loadStream("crash.wav")
local sndScore = audio.loadStream("score.mp3")

--
-- Bird

local bird = display.newImageRect( grpWorld, "flappy.png", 25, 20 )
bird.x = 100
bird.y = _CY
bird.velocity = 0
bird.crashed = false
bird.gravity = 0.6

--
-- Score label

local lblScore = display.newText("0p", _CX, 180, "PressStart2P-Regular.ttf", 40)
grpHud:insert(lblScore)

--
-- Add pipe

local function addPipe()

    local distanceBetween = math.random(120, 200)
    local yPosition = math.random(150, _H - 150)

    local pTop = display.newImageRect(grpWorld, "pipe.png", 50, 600)
    pTop.x = _W + 50
    pTop.y = yPosition - (distanceBetween / 2) - 300
    pTop.type = "pipe"
    pTop.xScale = -1
    pTop.rotation = -180
    pipes[#pipes+1] = pTop

    local pBottom = display.newImageRect(grpWorld, "pipe.png", 50, 600)
    pBottom.x = _W + 50
    pBottom.y = yPosition + (distanceBetween / 2) + 300
    pBottom.type = "pipe"
    pipes[#pipes+1] = pBottom

    local pSensor = display.newRect(grpWorld, _W + 80, _CY, 5, _H)
    pSensor.fill = { 0, 1, 0 }
    pSensor.type = "sensor"
    pSensor.alpha = 0
    pipes[#pipes+1] = pSensor
end

--
--

local function checkCollision(obj1, obj2)

    local left  = (obj1.contentBounds.xMin) <= obj2.contentBounds.xMin and (obj1.contentBounds.xMax) >= obj2.contentBounds.xMin
    local right = (obj1.contentBounds.xMin) >= obj2.contentBounds.xMin and (obj1.contentBounds.xMin) <= obj2.contentBounds.xMax
    local up    = (obj1.contentBounds.yMin) <= obj2.contentBounds.yMin and (obj1.contentBounds.yMax) >= obj2.contentBounds.yMin
    local down  = (obj1.contentBounds.yMin) >= obj2.contentBounds.yMin and (obj1.contentBounds.yMin) <= obj2.contentBounds.yMax

    return (left or right) and (up or down)
end

--
-- Update

local function update()

    if hasStarted and bird.crashed == false then
        for i = #backgrounds, 1, -1 do
            local b = backgrounds[i]
            b:translate( -2, 0 )

            if b.x < -(_W / 2) then
                b.x = b.x + (_W * 3)
            end
        end

        for i = #pipes, 1, -1 do
            local object = pipes[i]
            object:translate( -2, 0 )

            if object.x < -100 then
                local child = table.remove(pipes, i)

                if child ~= nil then
                    child:removeSelf()
                    child = nil
                end
            end

            if checkCollision(object, bird) then
                if object.type == "sensor" then
                    print("SCOOORE")

                    score = score + 1

                    lblScore.text = score .. "p"

                    print("Score: " .. score)

                    local child = table.remove(pipes, i)

                    audio.play(sndScore)

                    if child ~= nil then
                        child:removeSelf()
                        child = nil
                    end
                else
                    audio.play(sndCrash)
                    print("DIIIIIIIIIIEEE")

                    bird.crashed = true

                    transition.to(bird, {time=200, y=_H - 30})
                end
            end
        end

        --

        bird.velocity = bird.velocity - bird.gravity
        bird.y = bird.y - bird.velocity

        if bird.y > _H or bird.y < 0 then
            print("DIIIIIIIEEE")

            bird.crashed = true

            transition.to(bird, {time=200, y=_H - 30})

            audio.play(sndCrash)
        end

        --

        if canAddPipe > 100 then
            addPipe()
        
            canAddPipe = 0
        end

        canAddPipe = canAddPipe + 1
    end
end

Runtime:addEventListener("enterFrame", update)

--
-- Touch

local function touch( event )

    if event.phase == "began" then
        if not hasStarted then
            hasStarted = true
        end

        audio.play(sndFlap)

        bird.velocity = 10
    end
end

Runtime:addEventListener("touch", touch)