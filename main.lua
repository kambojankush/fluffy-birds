-- virtual resolution handling library
-- https://github.com/Ulydev/push
push = require 'push'

-- classic OOP class library
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
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

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Birds')
    
    -- initilaize all the rquired fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)

    -- set current font to flappy font
    love.graphics.setFont(flappyFont)

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true, 
        resizable = true,
        fullscreen = false
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end,
    }
    gStateMachine:change('title')

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

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
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()
    -- draw the ground on top of the background, toward the bottom of the screen,
    -- at its negative looping point 
    -- (height of ground = 16)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
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