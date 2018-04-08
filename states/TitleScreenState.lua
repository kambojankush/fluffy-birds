TitleScreenState = Class{__includes = BaseState}
local background = love.graphics.newImage('assets/background7.jpg')
function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setColor(255,255,255,200)
    love.graphics.draw(background, 0, -80, 0, 0.3 , 0.3)
    love.graphics.setColor(255,255,255,255)
    
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Fluffy Birds', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press ENTER to play', 0, 200, VIRTUAL_WIDTH, 'center')
end