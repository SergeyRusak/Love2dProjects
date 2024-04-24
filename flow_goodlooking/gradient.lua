Gradient = {}
Gradient.__index = Gradient

function Gradient:create(wray,hray)
    local grad = {}
    grad.hray = hray or 10
    grad.wray = wray or 10
    grad.map = {}

    for i=0, grad.hray-1 do
        local temp = {}
        for j=0,grad.wray-1 do
            table.insert(temp,Vector:create(0,0))
        end
        table.insert(grad.map, temp)
    end
    setmetatable(grad, Gradient)
    return grad
end

function Gradient:generate(type)
   local xoff = math.random(1,100)/100
   local yoff = math.random(1,100)/100
   print(self.hray/2,self.wray/2)
    for i=1, self.hray do
        local temp = {}
        for j=1,self.wray do
            if type == "swarn" then
                local vc =  Vector:create(j-self.wray/2,i-self.hray/2)
                local theta = vc:heading() - math.pi/(vc:mag()*0.1 +0.1)
                self.map[i][j] = Vector:create(math.cos(theta), math.sin(theta))
            end
            if type == "circle" then
                local vc =  Vector:create(j-self.wray/2,i-self.hray/2)
                local theta = vc:heading()- vc:mag()/3
                self.map[i][j] = Vector:create(math.cos(theta), math.sin(theta))
            end
            if type == "spiral" then
                local vc =  Vector:create((i-self.hray/2)-(j-self.wray/2),-(j-self.wray/2)-(i-self.hray/2))
                local theta = vc:heading() 
                self.map[i][j] = Vector:create(math.cos(theta), math.sin(theta))
            end
            if type == "zavardo" then
                local vc =  Vector:create((i-self.hray/2)-(j-self.wray/2),-(j-self.wray/2)-(i-self.hray/2))
                local vc2 = Vector:create(j-self.wray/2,i-self.hray/2)
                local theta = vc:heading() 
                self.map[i][j] = Vector:create(math.cos(theta) * (vc2:mag()*vc2:mag()/(self.wray*self.wray+self.hray*self.hray)),
                                               math.sin(theta) * (vc2:mag()*vc2:mag()/(self.wray*self.wray+self.hray*self.hray)))
            end
            if type == "getover" then
                local vc = Vector:create(j-self.wray/2,i-self.hray/2)
                local theta = vc:heading()+math.pi 
                self.map[i][j] = Vector:create(math.cos(theta), math.sin(theta))
            end
            if type == "ray" then
                local vc =  Vector:create((i-self.hray/2)-(j-self.wray/2),-(j-self.wray/2)-(i-self.hray/2))
                local vc2 = Vector:create(j-self.wray/2,i-self.hray/2)
                local theta = vc:heading() + vc2:heading()
                self.map[i][j] = Vector:create(math.cos(theta), math.sin(theta))
            end
            if type == "random" then
            local theta = math.map(love.math.noise(xoff+j,yoff+i),
                                                    0, 1, 0, math.pi * 2)
            self.map[i][j] = Vector:create(math.cos(theta), math.sin(theta))
            end
        end
        
    end
end

function Gradient:draw()

    local hsize = height/self.hray
    local wsize = width/self.wray
    for i,t in pairs(self.map) do
        for j,v in pairs(t) do
            love.graphics.push()
            love.graphics.translate(j*wsize - wsize/2,i*hsize - hsize/2)
            love.graphics.line(0,0,v.x*wsize/2,v.y*hsize/2)
            --love.graphics.rectangle("line",-wsize/2,-hsize/2,wsize,hsize)
            love.graphics.pop()
        end
    end 

end

function Gradient:getVector(position,clone)
    local hsize = height/self.hray
    local wsize = width/self.wray
    local xc = math.floor(position.x/wsize)+1
    local yc = math.floor(position.y/hsize)+1
    if xc < 1 then
        xc = 1
    end
    if xc > self.wray then
        xc = self.wray
    end
    if yc < 1 then
        yc = 1
    end
    if yc > self.hray then
        yc = self.hray
    end
    
    local temp = Vector:create((xc*wsize)-wsize/2,(yc*hsize)-hsize/2)
    temp:sub(position)
    if (xc < 1 or xc > self.wray or yc < 1 or yc > self.hray) then
        return Vector:create(0,0) , 0
    end 
    if clone then
        return self.map[yc][xc]:copy(), 100/temp:mag()
    else
        return self.map[yc][xc], 100/temp:mag()
    end
end