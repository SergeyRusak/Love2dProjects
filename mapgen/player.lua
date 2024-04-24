Player = {}
Player.__index = Player

function Player:create(maxHP)
    local pl = {}
    pl.x = conf.room.tw*conf.room.ts * 0.5
    pl.y = conf.room.th*conf.room.ts * 0.5
    pl.maxHP = maxHP or 6
    pl.hp = pl.maxHP
    pl.imunetime = 0.5
    pl.imuneactivetime = 0
    pl.speed = 300
    pl.arange = 50
    pl.r = 20
    pl.mx = 0
    pl.direction = 1
    pl.my = 0
    pl.state = "idle"
    pl.duration = 0.5
    pl.time = 0
    pl.sprite = love.graphics.newImage("sprites/player.png")
    pl.lastsprite = love.graphics.newQuad(1 * 64, 64 * 0, 64, 64, pl.sprite:getDimensions())
    pl.move = {}
    pl.move.r = {}
    for i = 1, 3 do
        pl.move.r[i] = love.graphics.newQuad((i - 1) * 64, 64 * 0, 64, 64, pl.sprite:getDimensions())
    end
    pl.move.l = {}
    for i = 1, 3 do
        pl.move.l[i] = love.graphics.newQuad((i - 1) * 64, 64 * 1, 64, 64, pl.sprite:getDimensions())
    end
    pl.move.u = {}
    for i = 1, 3 do
        pl.move.u[i] = love.graphics.newQuad((i - 1) * 64, 64 * 2, 64, 64, pl.sprite:getDimensions())
    end
    pl.move.d = {}
    for i = 1, 3 do
        pl.move.d[i] = love.graphics.newQuad((i - 1) * 64, 64 * 3, 64, 64, pl.sprite:getDimensions())
    end
    pl.brawl = {}
    pl.brawl.r = {}
    pl.brawl.l = {}
    for i = 1, 2 do
        pl.brawl.r[i] = love.graphics.newQuad((i - 1) * 64, 64 * 4, 64, 64, pl.sprite:getDimensions())
    end
    for i = 1, 2 do
        pl.brawl.l[i] = love.graphics.newQuad((i - 1) * 64, 64 * 5, 64, 64, pl.sprite:getDimensions())
    end
    pl.death = love.graphics.newQuad(0, 64 * 7, 64, 64, pl.sprite:getDimensions())
    setmetatable(pl, Player)
    return pl 
end
function Player:update(dt,mx,my)
    if (self.state ~= "dead") then
        if (mx ~= 0 or my ~= 0) then
            self.mx = mx
            self.my = my
            if mx~=0 then
                self.direction = mx
            end
            if self.state ~= "brawl" then
                self:setState("run", 0.25)
            end
            self.x = self.x + self.speed * mx * dt
            self.y = self.y + self.speed * my * dt
        else
            if self.state ~= "brawl" then
                self:setState("idle", 0.5)
            end
        end
    end

    self.time = self.time + dt
    if self.time > self.duration then
        self.time = self.time - self.duration
    end
    
    if self.imuneactivetime > 0 then
        self.imuneactivetime = self.imuneactivetime - dt
        if self.imuneactivetime < 0 then
            self.imuneactivetime = 0 
        end
    end
end
function Player:hurt()
    if self.imuneactivetime == 0 then
        self.hp = self.hp - 1
        if self.hp < 1 then
            self:setState("dead",1)
        end
        self.imuneactivetime = self.imunetime
    end
end
function Player:draw()
    if self.state == "dead" then
        love.graphics.draw(self.sprite,self.death,self.x,self.y,0,self.direction)
    end
    if(self.imuneactivetime ==0) or (math.floor(self.imuneactivetime*10)%2==0) then
        if self.state == "idle" then
            love.graphics.draw(self.sprite,self.lastsprite,self.x-32,self.y-32)
        end
        if self.state == "brawl" then
            if self.direction == -1 then
                love.graphics.draw(self.sprite,self.brawl.r[math.floor(self.time/self.duration*2)+1],self.x-32,self.y-32)
            else
                love.graphics.draw(self.sprite,self.brawl.l[math.floor(self.time/self.duration*2)+1],self.x-32,self.y-32)
            end
            if self.time/self.duration >0.9 then 
                self:setState("idle", 0.1)
            end 
        end

        if self.state == "run" then
            if self.mx == 1 then
                self.lastsprite = self.move.r[math.floor(self.time/self.duration*3) +1]
            else
                if self.mx == -1 then
                    self.lastsprite = self.move.l[math.floor(self.time/self.duration*3) +1]
                else
                    if self.my == 1 then
                    self.lastsprite = self.move.d[math.floor(self.time/self.duration*3) +1]
                    else
                        if self.my == -1 then
                            self.lastsprite = self.move.u[math.floor(self.time/self.duration*3) +1]
                        end
                    end
                end
            end
            love.graphics.draw(self.sprite,self.lastsprite,self.x-32,self.y-32)
        end

        
            
    end
end
function Player:setState(state,duration)
    if self.state ~= state then
        self.state = state
        self.duration = duration
        self.time = 0
    end

end

function Player:fight(enemies)
    if self.state ~="brawl" and self.state ~="dead" then
        self:setState("brawl",0.2)
        for i,e in pairs(enemies) do
         if (e.x - self.x) * self.direction > 0 and ((e.x - self.x)*(e.x - self.x) + (e.y - self.y)*(e.y - self.y))<= self.arange* self.arange then
            e:hurt()
         end
        end 


    end


end