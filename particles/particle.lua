Particle = {}
Particle.__index = Particle

function Particle:create(location,lifespan,startVelocity,acceleration,rotation,rotVelocity,rotAcceleration,texture,size,color)
    local particle = {}
    particle.location = location
    particle.lifespan = lifespan
    particle.acceleration = acceleration
    particle.rotation = rotation
    particle.rotVelocity = rotVelocity
    particle.rotAcceleration = rotAcceleration
    particle.velocity = startVelocity
    particle.texture = texture
    particle.size = size
    particle.color = color
    setmetatable(particle, Particle)
    return particle
end
function Particle:draw()
    local r,g,b,a = love.graphics.getColor()
    local nr,ng,nb = self.color
    love.graphics.setColor(nr,ng,nb,self.lifespan/100)
    love.graphics.draw(self.texture,self.location.x,self.location.y,self.rotation,self.size.x,self.size.y)
    love.graphics.getColor(r,g,b,a)
end
function Particle:update(dt)
    self.lifespan = self.lifespan - dt
    self.velocity:add(self.acceleration * dt)
    self.location:add(self.velocity * dt)
    self.rotVelocity = self.rotVelocity + self.rotAcceleration * dt
    self.rotation = self.rotation + self.rotVelocity * dt
end
function Particle:isDead()
    return self.lifespan < 0
end

