Bird = Class{}

local GRAVITY = 3

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
        self.dy = -0.55
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:collides(pipe)
    -- AABB type collision detection with someleeway for user ( 2 - top and left offset; 4 - bottom and right offset)
    if (self.x + 2) + (self.width - 4) >= pipe.x and (self.x + 2) < pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and (self.y + 2) < pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end