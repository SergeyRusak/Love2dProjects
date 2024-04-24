Sling = {}
Sling.__index = Sling

function Sling:create(x, y,size)
    local sling = {}
    sling.x = x
    sling.y = y
    sling.size = size
    sling.ax = sling.size
    sling.ay = sling.size*0.4
    sling.force = 10
    sling.sprite = love.graphics.newImage("sprites/sling.png")
    sling.curve = love.math.newBezierCurve({sling.size*0.2,sling.size*0.9,sling.size,sling.size*0.4,sling.size*1.5,sling.size*0.3})
    sling.ammo = {}
    for i= 1,5 do
    table.insert(sling.ammo,love.graphics.newImage("sprites/ammo ("..tostring(i)..").png"))
    end
    setmetatable(sling, Sling)
    return sling
end

function Sling:pull(m_x,m_y)
    self.curve:setControlPoint(2,m_x-self.x+sling.size,m_y-self.y+sling.size*1.5)
    local x1,y1 = self.curve:getControlPoint(1)
    local x2,y2 = self.curve:getControlPoint(2)
    local x3,y3 = self.curve:getControlPoint(3)
    self.ax = (((x1+x3)*0.5)+x2)*0.5
    self.ay = (((y1+y3)*0.5)+y2)*0.5
end
function Sling:fire()
    print(Vector:create(self.size - self.ax,self.size*1.5 - self.ay))
    local ammo = table.remove(self.ammo,1)
 local m = Mover:create(Vector:create(self.size+self.x,self.size*0.5+self.y),Vector:create(self.size - self.ax,self.size*0.4 - self.ay)*(self.force),self.size,0.3,ammo)
 self.ax = sling.size
 self.ay = sling.size*0.4
 self.curve:setControlPoint(2,self.ax,self.ay)
 table.insert(self.ammo,math.random(1,4),ammo)
 return m    
end

function Sling:draw()
    love.graphics.push()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.translate(self.x,self.y)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0.58,0.18,0.16,1)
    love.graphics.line(self.curve:render())
    love.graphics.setColor(r,g,b,a)
    if aim then
        love.graphics.draw(self.ammo[1],self.ax-self.size*0.5,self.ay-self.size*0.5,0,self.size/self.ammo[1]:getPixelWidth(),self.size/self.ammo[1]:getPixelHeight())
    end
    
    love.graphics.draw(self.sprite,0,0,0,self.size*0.005,self.size*0.005)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end
