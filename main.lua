-- virtual resolution handling library
-- https://github.com/Ulydev/push
push = require 'push'

-- classic OOP class library
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

require 'Bird'

require 'Pipe'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- speed at which we should scroll our images
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- our bird sprite
local bird = Bird()

-- table to store pipe sprites
local pipes = {}

local spawnTimer = 0

function love.load()
   love.graphics.setDefaultFilter('nearest', 'nearest')
   love.window.setTitle('Flappy Birds')
   
   math.randomseed(os.time())

   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       vsync = true, 
       resizable = true,
       fullscreen = false
   })

   -- initialize input table
   love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    spawnTimer = spawnTimer + dt
    if spawnTimer > 2 then
        table.insert(pipes, Pipe())
        spawnTimer = 0
    end

    for k, pipe in pairs(pipes) do
        pipe:update(dt)
        
        if pipe.x < -pipe.width then
            table.remove(pipes, k)
        end
    end

    bird:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pipe in pairs(pipes) do
        pipe:render()
    end

    -- draw the ground on top of the background, toward the bottom of the screen,
    -- at its negative looping point 
    -- (height of ground = 16)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:finish()
end

function love.keypressed(key)   
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then 
        return true
    else
        return false
    end
end