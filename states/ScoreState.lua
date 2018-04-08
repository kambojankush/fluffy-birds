ScoreState = Class{__includes = BaseState}

GOLD_MEDAL = love.graphics.newImage('gold.png')
SILVER_MEDAL = love.graphics.newImage('silver.png')
BRONZE_MEDAL = love.graphics.newImage('bronze.png')

local background = love.graphics.newImage('background6.jpg')
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.setColor(255,255,255,200)
    love.graphics.draw(background, 0, -80, 0, 0.3, 0.3)
    love.graphics.setColor(255,255,255,255)
    love.graphics.printf('OOPS! You Lost!', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(getMedal(self.score), VIRTUAL_WIDTH / 2 - 16 , 120)
    love.graphics.printf('Press ENTER to play', 0, 160, VIRTUAL_WIDTH, 'center')
end

function getMedal(score)
    if score > 25 then
        return GOLD_MEDAL
    elseif score  > 10 then
        return SILVER_MEDAL
    else 
        return BRONZE_MEDAL
    end 
end