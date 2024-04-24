Vector = {}
Vector.__index = Vector

function Vector:create(x, y)
    local vector = {}
    vector.x = x
    vector.y = y
    setmetatable(vector, Vector)
    return vector
end

function Vector:__add(other)
    x = self.x + other.x
    y = self.y + other.y
    vec = Vector:create(x,y)
    return vec
end

function Vector:__sub(other)
    x = self.x - other.x
    y = self.y - other.y
    vec = Vector:create(x,y)
    return vec
end

function Vector:__mul(value)
    x = self.x * value
    y = self.y * value
    vec = Vector:create(x,y)
    return vec
end

function Vector:__div(value)
    x = self.x / value
    y = self.y / value
    vec = Vector:create(x,y)
    return vec
end

function Vector:mag()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:norm()
    normv = Vector:create(self.x / self:mag(),self.y / self:mag())
    return normv
end
function Vector:resize(lenght)
    norm = self:norm() * lenght
    return norm
end
function Vector:__tostring()
    return
end