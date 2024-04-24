Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:create(points)
    local obs = {}
    obs.points = points
    obs.visible = false
    setmetatable(obs, Obstacle)
    return obs
end
function Obstacle:getSegments()
    local segments = {}
    for i = 2, #self.points do
        local p1 = self.points[i-1]
        local p2 = self.points[i]
        table.insert(segments,{p1,p2})
    end
    return segments
end
function Obstacle:draw()
    r,g,b,a = love.graphics.getColor()
    if self.visible then
    love.graphics.setColor(1,0.25,0.25,1)
    else
        love.graphics.setColor(0.5,0.5,0.5,1)    
    end
    --love.graphics.polygon(points)

    for i = 2, #self.points do
        local p1 = self.points[i-1]
        local p2 = self.points[i]
        love.graphics.line(p1[1],p1[2],p2[1],p2[2])
    end
    love.graphics.setColor(r,g,b,a)
end