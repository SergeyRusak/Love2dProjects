BG = {}
BG.__index = BG

function BG:create()
    local bg = {}
    bg.bg = love.graphics.newImage("gfx/bg/bg2.png")
    bg.bgx = 0
    bg.bgspd = 75
    bg.koefw = width/bg.bg:getPixelWidth()
    bg.koefh = height/bg.bg:getPixelHeight()

    bg.gr = love.graphics.newImage("gfx/bg/ground.png")
    bg.grx = 0
    bg.grspd = speed

    bg.lp = {}
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/b1.png"),x = width*0.3,spd = 30})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/b2.png"),x = width*0.9,spd = 45})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l1.png"),x = width*0  ,spd = 50})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l2.png"),x = width*0.1,spd = 55})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l3.png"),x = width*0.2,spd = 60})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l4.png"),x = width*0.3,spd = 45})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l1.png"),x = width*0.4,spd = 50})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l4.png"),x = width*0.5,spd = 45})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l3.png"),x = width*0.6,spd = 60})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l2.png"),x = width*0.7,spd = 55})
    table.insert(bg.lp,{img = love.graphics.newImage("gfx/bg/l1.png"),x = width*0.8,spd = 50})

    bg.cl = {}
    table.insert(bg.cl,{img = love.graphics.newImage("gfx/bg/cloud1.png"),x = width*0.3, y = height*0.1,spd = 10})
    table.insert(bg.cl,{img = love.graphics.newImage("gfx/bg/cloud2.png"),x = width*0.7, y = height*0.2,spd = 25})
    table.insert(bg.cl,{img = love.graphics.newImage("gfx/bg/cloud3.png"),x = width*0.2, y = height*0.3,spd = 15})
    table.insert(bg.cl,{img = love.graphics.newImage("gfx/bg/cloud4.png"),x = width*0.3, y = height*0.2,spd = 20})


    
    
    setmetatable(bg, BG)
    return bg
end
function BG:update(dt,k)
    self.bgx = self.bgx - self.bgspd* k * dt
    if self.bgx <  -width then
        self.bgx = self.bgx + width
    end 

    self.grx = self.grx - self.grspd* k * dt
    if self.grx <  -width then
        self.grx = self.grx + width
    end

    for i,l in pairs(self.lp) do
        l.x = l.x - l.spd* k * dt
        if l.x <  -width then
            l.x = l.x + width
        end
    end

    for i,l in pairs(self.cl) do
        l.x = l.x - l.spd* k * dt
        if l.x <  -width then
            l.x = l.x + width
        end
    end

end
function BG:draw()
    r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.bg,self.bgx,0,0,self.koefw,self.koefh)
    love.graphics.draw(self.bg,self.bgx+width,0,0,self.koefw,self.koefh)

    for i,l in pairs(self.cl) do
        love.graphics.draw(l.img,l.x,l.y,0,self.koefw,self.koefh)
        love.graphics.draw(l.img,l.x+width,l.y,0,self.koefw,self.koefh)
    end

    love.graphics.draw(self.gr,self.grx,height- self.gr:getPixelHeight()* self.koefh,0,self.koefw,self.koefh)
    love.graphics.draw(self.gr,self.grx+width,height - self.gr:getPixelHeight()* self.koefh,0,self.koefw,self.koefh)


    for i,l in pairs(self.lp) do

        love.graphics.draw(l.img,l.x,height- (self.gr:getPixelHeight()+l.img:getPixelHeight())* self.koefh  ,0,self.koefw,self.koefh)
        love.graphics.draw(l.img,l.x+width,height - (self.gr:getPixelHeight()+l.img:getPixelHeight())* self.koefh,0,self.koefw,self.koefh)
    end

    love.graphics.getColor(r,g,b,a)
end