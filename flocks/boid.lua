Boid = {}
Boid.__index = Boid

function Boid:create(x, y)
    local boid = {}
    setmetatable(boid, Boid)
    boid.position = Vector:create(x, y)
    boid.velocity = Vector:create(math.random(-10, 10) / 10, math.random(-10, 10) / 10)
    boid.acceleration = Vector:create(0, 0)
    boid.r = 5
    boid.vertices = {0, - boid.r * 2, -boid.r, boid.r * 2, boid.r, 2 * boid.r}
    boid.maxSpeed = 4
    boid.maxForce = 0.1
    boid.color = {math.random(),math.random(),math.random()}
    
    boid.scolor = boid.color
    return boid
end

function Boid:update(boids)
    if isSep then
        sep = self:separate(boids)
        self:applyForce(sep)
    end
    if isAlign then
        align = self:align(boids)
        self:applyForce(align)
    end
    if isCoh then
        coh = self:cohesion(boids)
        self:applyForce(coh)
    else
        self.scolor = self.color
    end


    self.velocity:add(self.acceleration)
    self.velocity:limit(self.maxSpeed)
    self.position:add(self.velocity)
    self.acceleration:mul(0)
    self:borders()
end

function Boid:applyForce(force)
    self.acceleration:add(force)
end

function Boid:seek(target)
    local desired = target - self.position
    desired:norm()
    desired:mul(self.maxSpeed)
    local steer = desired - self.velocity
    steer:limit(self.maxForce)
    return steer
end

function Boid:separate(others)
    local separation = 25.
    local steer = Vector:create(0,0)
    local count = 0
    for i = 0, #others do
        local other = others[i]
        local d = self.position:distTo(other.position)

        if d > 0 and d < separation then
            local diff = self.position - other.position
            diff:norm()
            diff:div(d)
            steer:add(diff)
            count = count + 1
            
        end
    end
    if count > 0 then
        steer:div(count)
    end
    if steer:mag() > 0 then
        steer:norm()
        steer:mul(self.maxSpeed)
        steer:sub(self.velocity)
        steer:limit(self.maxForce)
    end
    return steer
end

function Boid:align(others)
    local aligndist = 50.
    local movement = Vector:create(0,0)
    local count = 0
    for i = 0, #others do
        local other = others[i]
        local d = self.position:distTo(other.position)

        if d > 0 and d < aligndist then
            movement:add(other.velocity)
            count = count + 1
        end
    end

    if count>0 then
        movement:div(count)
    end
    
    if movement:mag() > 0 then
        movement:norm()
        movement:mul(self.maxSpeed)
        movement:sub(self.velocity)
        movement:limit(self.maxForce)
    end
    return movement
end
function Boid:cohesion(others)
    local cohdist = 50.
    local target = Vector:create(0,0)
    local count = 0
    local swcolor = {0,0,0}
    for i = 0, #others do
        local other = others[i]
        local d = self.position:distTo(other.position)

        if d > 0 and d < cohdist then
            target:add(other.position)
            count = count + 1
        end
        
    end

    if count>0 then
        self.scolor = self:findleader(others,target).color
        target:div(count)
    end
    

    return self:seek(target)
end


function Boid:findleader(boids,position)
    local leader = boids[0]
    for i,b in pairs(boids) do
        if leader.position:distTo(position) > b.position:distTo(position) then
            leader = b
        end
    end
    return leader
end

function Boid:borders()
    if self.position.x < -self.r then
        self.position.x = width - self.r
    end
    if self.position.x > width + self.r then
        self.position.x = self.r
    end

    if self.position.y < -self.r then
        self.position.y = height - self.r
    end
    if self.position.y > height + self.r then
        self.position.y = self.r
    end
end


function Boid:draw()
    r, g, b, a = love.graphics.getColor()

    love.graphics.setColor((self.scolor[1]),
                           (self.scolor[2]),
                           (self.scolor[3]))
    local theta = self.velocity:heading() + math.pi / 2
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(theta)
    love.graphics.polygon("fill", self.vertices)
    love.graphics.pop()
    if self.target ~= nil then
        love.graphics.line(self.position.x,self.position.y,self.target.position.x,self.target.position.y)
    end
    love.graphics.setColor(r, g, b, a)
end

