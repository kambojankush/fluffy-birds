PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    -- our bird sprite
    self.bird = Bird()
    -- table to store pipe sprites
    self.pipePairs = {}
    self.spawnTimer = 0
-- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    self.score = 0
end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt
    
    if self.spawnTimer > 2 then
        local y = math.max( -PIPE_HEIGHT + 10,
                math.min(self.lastY + math.random(-40,40), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT)
        )
        self.lastY = y 
        table.insert(self.pipePairs, PipePair(y))
        self.spawnTimer = 0
    end

    self.bird:update(dt)
    
    for k, pair in pairs(self.pipePairs) do
        pair:update(dt)

        for l, pipe in pairs(pair.pipes) do 
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {score = self.score})
            end
        end
    end

    -- update score
    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then 
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {score = self.score})
    end
end

function PlayState:render()
    self.bird:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end