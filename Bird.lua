Bird = Class{}

local GRAVITY = (25/30)

function Bird:init()
    self.image = love.graphics.newImage('assets/bird2.png')
    self.width = self.image:getWidth()*0.03
    self.height = self.image:getHeight()*0.03

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y, 0, 0.03, 0.03)
    print(fps)
end

function Bird:update(dt)
    fps = love.timer.getFPS()
    self.dy = self.dy + GRAVITY * dt * fps

    -- anti-gravity const = -5 (add a sudden burst of negative gravity if we hit space)
    if love.keyboard.wasPressed('space') == true then
        self.dy = -(6.5) *(fps/30)
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:collides(pipe)
    -- AABB type collision detection with someleeway for user ( 4 - top and left offset; 8 - bottom and right offset)
    if (self.x + 4) + (self.width - 8) >= pipe.x and (self.x + 4) < pipe.x + PIPE_WIDTH then
        if (self.y + 4) + (self.height - 8) >= pipe.y and (self.y + 4) < pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end