Mover = {}
Mover.__index = Mover

function Mover:create(location, velocity, weight,bounce,texture)
    local mover = {}
    setmetatable(mover, Mover)
    mover.location = location
    mover.velocity = velocity
    mover.weight = weight or 1
    mover.acceleration = Vector:create(0,0)
    mover.size = weight
    mover.bounce = bounce or 1
    mover.texture = texture
    return mover
end

function Mover:draw()
    love.graphics.draw(self.texture,self.location.x-self.size,self.location.y-self.size,0,self.size/self.texture:getPixelWidth(),self.size/self.texture:getPixelHeight())
    --love.graphics.circle("fill",self.location.x,self.location.y,self.size)
end

function Mover:update(dt)
    self.velocity:add(self.acceleration * dt)
    self.location:add(self.velocity * dt)
    self.acceleration:mul(0)
    self:checkBoundaries(dt)
end

function Mover:checkBoundaries(dt)
    if self.location.x > width-self.size then
        self.location.x = width-self.size
        self.velocity.x =  self.velocity.x * -self.bounce
    elseif self.location.x < self.size then
        self.location.x = self.size
        self.velocity.x = self.velocity.x * -self.bounce
    end
    if self.location.y > height-50-self.size then
        self.location.y = height-50-self.size
        self.velocity.y = self.velocity.y * -self.bounce
        self.velocity.x = self.velocity.x * self.bounce
    elseif self.location.y < self.size then
        self.location.y = self.size
        self.velocity.y = self.velocity.y * -self.bounce
    end
end

function Mover:applyForce(force)
    self.acceleration:add(force*self.weight)
end