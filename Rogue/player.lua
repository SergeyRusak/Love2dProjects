Player = {}
Player.__index = Player

function Player:create(x, y)
    local pla = {}
    setmetatable(pla, Player)
    pla.hp = 3
    pla.x = x
    pla.y = y
    pla.tx = x
    pla.ty = y
    pla.state = "idle"
    pla.duration = 0.5
    pla.curtime = 0.0
    pla.direction = 1
    pla.path = {}

    return pla
end

function Player:update(dt)
    self.curtime = self.curtime + dt
    if self.curtime >= self.duration then
        self.curtime = self.curtime - self.duration
    end
    if self.x == self.tx and self.y == self.ty then
        self:setState("idle")
        self.duration = 0.9
    end


if self.y == self.ty and self.x == self.tx then
        local nt =  self:getNextTarget()
        if type(nt) ~= "boolean" then
            self:setTarget(nt[1],nt[2])
        end
    end
if self.x ~= self.tx then
    if self.x > self.tx then
        self.x = self.x - 1
        self.direction = -1
    else
        self.x = self.x + 1
        self.direction = 1
    end
    self:setState("move")
    self.duration = 0.5
end
if self.y ~= self.ty then
    if self.y > self.ty then
        self.y = self.y - 1
    else
        self.y = self.y + 1
    end
    self:setState("move")
    self.duration = 0.5
end




end
function Player:draw()
    love.graphics.push()
    love.graphics.translate(self.x,self.y)
    local sprite = 1
    if self.state == "move" then
        sprite = math.floor(self.curtime/self.duration* #pl.move)+1
        love.graphics.draw(pl.tileset,pl.move[sprite],self.direction * -12, -12,0,self.direction*0.5,0.5)
    elseif self.state == "idle" then
        sprite = math.floor(self.curtime/self.duration* #pl.idle)+1
        love.graphics.draw(pl.tileset,pl.idle[sprite],self.direction * -12, -12,0,self.direction*0.5,0.5)
    end
    

    
    love.graphics.pop()
end
function Player:getNextTarget()
    if  #self.path > 0 then
        local a = table.remove(self.path,1)
        return a
    end
    return false
end
function Player:setTarget(dx,dy)   
    self.tx = dx
    self.ty = dy
end
function Player:setPath(path)
    self.path = path
    local tg = self:getNextTarget()
    self:setTarget(tg[1],tg[2])
end
function Player:setState(state)
    if self.state ~= state then
        self.state = state
        self.curtime = 0
    end
end