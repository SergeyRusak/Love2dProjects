Mover = {}
Mover.__index = Mover

function Mover:create(location, velocity, weight)
    local mover = {}
    setmetatable(mover, Mover)
    mover.location = location
    mover.angle = 0
    mover.velocity = velocity
    mover.aVelocity = 0
    mover.aAcceleration = 0
    mover.acceleration = Vector:create(0, 0)
    mover.weight = weight or 1
    mover.active = false
    mover.size = 20 + mover.weight
    return mover
end

function Mover:draw()

    r,g,b,a = love.graphics.getColor()
    love.graphics.push() --Сохраняем стандартную координатную сетку
    love.graphics.translate(self.location.x, self.location.y) --Переходим в локальную сетку вокруг фигуры
    love.graphics.rotate(self.angle) --Поворачиваем объект
    love.graphics.setLineWidth(4)
    love.graphics.line(-30,-30,30,0,-30,30,-30,-30)
    type = "line"
    if self.active then
        love.graphics.setColor(1,0,0,1)
        type = "fill"
    end

    
    love.graphics.rectangle(type, -40, 5, 10, 20) --Рисуем объект в новом положении
    love.graphics.rectangle(type, -40, -25, 10, 20)

    love.graphics.setColor(r,g,b,a)
    love.graphics.pop() --Возвращаемся в исходную сетку
end

function Mover:applyForce(force)
    self.acceleration:add(force * self.weight)
end

function Mover:update()
    self.aVelocity = self.aVelocity + self.aAcceleration
    self.velocity:add(self.acceleration)
    self.location:add(self.velocity)
    self.acceleration:mul(0)
end

function Mover:check_boundaries()
    if self.location.x > width - self.size then
        self.location.x = width - self.size
        self.velocity.x = -1 * self.velocity.x
    elseif self.location.x < self.size then
        self.location.x = self.size
        self.velocity.x = -1 * self.velocity.x
    end
    if self.location.y > height - self.size then
        self.location.y = height - self.size
        self.velocity.y = -1 * self.velocity.y
    elseif self.location.y < self.size then
        self.location.y = self.size
        self.velocity.y = -1 * self.velocity.y
    end
end

function Mover:checkLoop()
    if self.location.x > width then
        self.location.x = 0
    elseif self.location.x < 0 then
        self.location.x = width
    end
    if self.location.y > height then
        self.location.y = 0
    elseif self.location.y < 0 then
        self.location.y = height
    end
end