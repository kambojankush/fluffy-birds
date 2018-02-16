Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    
    -- anti-gravity const = -5 (add a sudden burst of negative gravity if we hit space)
    if love.keyboard.wasPressed('space') == true then
        self.dy = -5
    end

    self.y = self.y + self.dy
end