Repeller = {}
Repeller.__index = Repeller

function Repeller:create(x, y)
    local repeller = {}
    setmetatable(repeller, Repeller)
    repeller.location = Vector:create(x, y)
    repeller.r = 40
    repeller.strength = 10
    return repeller
end

function Repeller:draw()
    love.graphics.circle("line", self.location.x, self.location.y, self.r)
end

function Repeller:repel(p)
    print(p.location)
    local dir = Vector: create (
                                self.location.x - p.location.x,
                                self.location.y,p.location.y)
    local d = dir:mag()
    if d <= self.r * 2.01 then
        d = 1
    end
    local dir = dir:norm()
    local force = -1 * self.strength / (d * d)
    dir:mul(force)
    return dir
end