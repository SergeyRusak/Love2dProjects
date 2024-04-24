Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:create(x, y)
    local vehicle = {}
    setmetatable(vehicle, Vehicle)
    vehicle.acceleration = Vector:create(0, 0)
    vehicle.velocity = Vector:create(0, 0)
    vehicle.location = Vector:create(x, y)
    vehicle.r = 5
    vehicle.vertices = {0, - vehicle.r * 2, -vehicle.r, vehicle.r * 2, vehicle.r, 2 * vehicle.r}
    vehicle.maxSpeed = 4
    vehicle.maxForce = 0.1
    vehicle.wtheta = 0
    return vehicle
end

function Vehicle:update()
    self.velocity:add(self.acceleration)
    self.velocity:limit(self.maxSpeed)
    self.location:add(self.velocity)
    self.acceleration:mul(0)
end

function Vehicle:applyForce(force)
    self.acceleration:add(force)
end

function Vehicle:follow(flow)
    local desired,mult = flow:getVector(self.location,true)
    desired:mul(self.maxSpeed)
    local steer = desired - self.velocity
    steer:limit(self.maxForce)
    self:applyForce(steer)
end

function Vehicle:borders()
    if self.location.x < -self.r then
        self.location.x = width + self.r
    end
    if self.location.y < -self.r then
        self.location.y = height + self.r
    end
    if self.location.x > width + self.r then
        self.location.x = -self.r
    end
    if self.location.y > height + self.r then
        self.location.y = -self.r
    end
end


function Vehicle:draw()
    local theta = self.velocity:heading() + math.pi / 2
    local r,g,b,a = love.graphics.getColor()
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(theta)
    if  not debug then
        love.graphics.setColor(self.location.x/width,self.location.y/height,theta/(math.pi*2),1)
        love.graphics.circle("fill",0,0,settings.dot.size(self.velocity:mag()))
    else
        love.graphics.setColor(0,1,0,1)
        love.graphics.polygon("fill", self.vertices)
    end
    love.graphics.pop()
    love.graphics.setColor(r,g,b,a)
end