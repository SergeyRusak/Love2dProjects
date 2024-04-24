Ray = {}
Ray.__index = Ray

function Ray:create(origin)
    local ray = {}
    ray.origin = origin or {0,0}
    ray.to = ray.origin
    ray.intersections = {}
    ray.closest = {}
    setmetatable(ray, Ray)
    return ray
end
function Ray:draw()
    r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(0,1,0,1)
    
    if #self.closest >0 then
        love.graphics.line(self.origin[1],self.origin[2],self.closest[1],self.closest[2])
    end

    
    love.graphics.setColor(r,g,b,a)

end

function Ray:castTo(obstacles)
    local intercests = {}
    local closest = {}
    local closest_obj = nil
    for i,o in pairs(obstacles) do
        local seg = o:getSegments()
        for i,s in pairs(seg) do
            local res = self:intersection(s)
            if res ~= nil then
                table.insert(intercests,res)
                if closest.t1 == nil or closest.t1 > res.t1 then
                    closest = {res.x,res.y,t1=res.t1}
                    closest_obj = o
                    
                end
            end
        end
       
    end
    if closest_obj ~= nil then
        closest_obj.visible = true
    end
    self.intersections = intercests 
    self.closest = closest 
  
end


function getformula(x1,y1,x2,y2)
local A = y1-y2
local B = x2-x1
local C = x1*y2 - x2*y1
return A,B,C


end
function Ray:intersection2(segment)
    local rx1 = self.origin[1]
    local ry1 = self.origin[2]
    local rx2 = self.to[1]
    local ry2 = self.to[2]
    local A1,B1,C1 = getformula(rx1,ry1,rx2,ry2)



    local sx1 = segment[1][1]
    local sy1 = segment[1][2]
    local sx2 = segment[2][1]
    local sy2 = segment[2][2]
    local A2,B2,C2 = getformula(sx1,sy1,sx2,sy2)

    if A1/B1 == A2/B2 then
        return nil
    end
    local poiy = (C1*A2 - C2*A1)/(A1*B2 - A2*B1)
    local poix = (B1*C2 - B2*C1)/(A1*B2 - A2*B1)

    if ((poix <= math.max(sx1,sx2)) and (poix >= math.min(sx1,sx2))and (poiy <= math.max(sy1,sy2)) and (poiy >= math.min(sy1,sy2)))or
       ((poix <= math.max(rx1,rx2)) and (poix >= math.min(rx1,rx2))and (poiy <= math.max(ry1,ry2)) and (poiy >= math.min(ry1,ry2))) then
        return {x = poix,y = poiy,t = (poix - rx1)*(poix - rx1) + (poiy-ry1)*(poiy-ry1)}
    end
    return nil
end


function Ray:intersection(segment)
    local rpx = self.origin[1]
    local rpy = self.origin[2]
    local rdx = self.to[1] - rpx
    local rdy = self.to[2] - rpy

    local spx = segment[1][1]
    local spy = segment[1][2]
    local sdx = segment[2][1] - spx
    local sdy = segment[2][2] - spy

    local rmag = math.sqrt(rdx * rdx + rdy * rdy)
    local smag = math.sqrt(sdx * sdx + sdy * sdy)
    if ((rdx / rmag == sdx/smag) and (rdy / rmag == sdy / smag)) then
        return nil
    end

    local t2 = (rdx * (spy - rpy) + rdy * (rpx - spx)) / (sdx * rdy - sdy * rdx)
    local t1 = (spx + sdx * t2 - rpx) / rdx
    if (t1 < 0) then
        return nil
    end
    if (t2 < 0 or t2 > 1) then
        return nil
    end

    local x = rpx + rdx * t1
    local y = rpy + rdy * t1

    return {x = x, y = y, t1 = t1}
end

