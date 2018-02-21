PipePair = Class{}

local GAP_HEIGHT = 77

function PipePair:init(y)
   self.x = VIRTUAL_WIDTH + 32
   self.y = y
   self.pipes = {
       ['top'] = Pipe('top', self.y),
       ['bottom'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT + math.random(-12,1))
   }

   self.remove = false
   self.scored = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['top'].x = self.x
        self.pipes['bottom'].x = self.x
    else
        self.remove = true
    end    
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do 
        pipe:render()
    end
end