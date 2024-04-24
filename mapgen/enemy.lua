Enemy = {}
Enemy.__index = Enemy

function Enemy:create(x, y)
    local enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.spd = 100
    enemy.hp = 3
    enemy.tx = 0
    enemy.ty = 0 
    enemy.direction = 1
    enemy.duration = 0.5
    enemy.time = 0
    enemy.tiles = love.graphics.newImage("sprites/enemy.png")
    enemy.move = {}
    enemy.movet = 0
    if math.random() >0.5 then
        enemy.movet = 3
        for i = 1, 3 do
            enemy.move[i] = love.graphics.newQuad((i - 1) * 64, 64 * 1, 64, 64, enemy.tiles:getDimensions())
        end
    else
        enemy.movet = 2
        for i = 1, 2 do
            enemy.move[i] = love.graphics.newQuad((i - 1) * 64, 64 * 4, 64, 64, enemy.tiles:getDimensions())
        end
    end
    setmetatable(enemy, Enemy)
    return enemy
end
function Enemy:update(Player,dt,enemies)
    local l_x = Player.x - self.x
    local l_y = Player.y - self.y
    if (l_x * self.direction) < 0 then
        self.direction = l_x / math.abs(l_x)
    end
    self.time = self.time + dt
    if self.time > self.duration then
        self.time = self.time - self.duration
    end


    local dist = math.sqrt(l_x*l_x+l_y*l_y)
    if dist < 5 then
        Player:hurt()
        l_x = 0
        l_y = 0
    end 
        self.x = self.x + l_x / dist * dt * self.spd
        self.y = self.y + l_y/ dist * dt * self.spd
end

function Enemy:setTarget(x,y)
    self.tx = x
    self.ty = y
end
function Enemy:hurt()
    self.hp = self.hp - 1
end

function Enemy:draw()
    love.graphics.draw(self.tiles,self.move[math.floor(self.time/self.duration*self.movet) +1],self.x-32,self.y-32,0,self.direction,1)
end