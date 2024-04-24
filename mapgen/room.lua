Room = {}
Room.__index = Room

function Room:create()
    local room = {}
    setmetatable(room, Room)
    room.tw = conf.room.tw
    room.th = conf.room.th
    room.doors = nil
    room.enemies = {}
    room.items = {}
    room.obstacles = love.graphics.newImage("sprites/decals.png")
    room.obspr = {}
    for i = 1, 3 do
        room.obspr[i] = love.graphics.newQuad(0 * 64, 64 * (i - 1), 64, 64, room.obstacles:getDimensions())
    end

    for w=1,math.random(0,5) do
        table.insert(room.enemies,
        Enemy:create(math.random(conf.room.offset_move,conf.room.tw*conf.room.ts-conf.room.offset_move),
                     math.random(conf.room.offset_move,conf.room.th*conf.room.ts-conf.room.offset_move)))  
    end
    room.wall = conf.room.wall[math.random(1,3)]
    room.tiles = {}
    for i=1,conf.room.th do
        local t = {}
        for j=1,conf.room.tw do
            local tt = 0
            if math.random() < 0.05 then
                tt = math.random(1,3)
            end
            table.insert(t,tt)
        end
        table.insert(room.tiles,t)
    end
    return room
end
function Room:drawmap(size)
    
    if self.doors[1]==0 then
        love.graphics.line(0,0,size,0)
    end
    if self.doors[2]==0 then
        love.graphics.line(size,size,size,0)
    end
    if self.doors[3]==0 then
        love.graphics.line(0,size,size,size)
    end
    if self.doors[4]==0 then
        love.graphics.line(0,0,0,size)
    end
    love.graphics.rectangle("line",size*0.25,size*0.25,size*0.5,size*0.5)
end
function Room:update(Player,dt)
    for i,e in pairs(self.enemies) do
        if e.hp == 0 then
            table.remove(self.enemies,i)
        else
           e:update(Player,dt,self.enemies)

           --local px,py = self:globalToLocal(Player.x,Player.y)
           --local ex,ey = self:globalToLocal(e.x,e.y)
           --local path =  self:getPath({ex,ey},{px,py})
           --print(path[1])
           --print("crash")
           --local ttx,tty = self:indexToLocal(path[1])
           --local tgx,tgy = self:localToGlobal(ttx,tty)
           --print(tgx,tgy)
           --print("--------")
           --e:setTarget(tgx,tgy)

           
        end
    end
end
function Room:draw()
    love.graphics.draw(self.wall,0,0,0)
    love.graphics.translate(conf.room.field.offset,conf.room.field.offset)   
    
    if self.doors[1]==1 then
        love.graphics.draw(conf.room.door,conf.room.tw * conf.room.ts *0.5 - 38,-conf.room.field.offset,0)
    end
    if self.doors[2]==1 then
        love.graphics.draw(conf.room.door,conf.room.tw * conf.room.ts + conf.room.field.offset+3, conf.room.th * conf.room.ts *0.5-38,math.pi/2)
    end
    if self.doors[3]==1 then
        love.graphics.draw(conf.room.door,conf.room.tw * conf.room.ts * 0.5 + 38 ,conf.room.th * conf.room.ts + conf.room.field.offset+3,math.pi)
    end
    if self.doors[4]==1 then
        love.graphics.draw(conf.room.door,-conf.room.field.offset, conf.room.th * conf.room.ts *0.5+38, -math.pi/2)
    end
    for i=1,conf.room.th do
        for j=1,conf.room.tw do
            if self.tiles[i][j] ~= 0 then
                love.graphics.draw(self.obstacles,self.obspr[self.tiles[i][j]],conf.room.ts*(j-1)+conf.room.ts*0.5 - 32,conf.room.ts*(i-1)+conf.room.ts*0.5 - 32)
            end
        end
    end


    for i,e in pairs(self.enemies) do
       e:draw()
    end
end

function Room:globalToLocal(x,y)
    return math.floor(x/conf.room.ts), math.floor(y/conf.room.ts)
end
function Room:localToGlobal(x,y)
    return math.floor(x*conf.room.ts + conf.room.ts*0.5), math.floor(y*conf.room.ts + conf.room.ts*0.5)
end
function Room:isWall(x,y)
    return self.tiles[y] == nil or self.tiles[y][x] == nil
end 

function Room:isRock(x,y)
    return self.tiles[y][x] == "rock"
end

function Room:localToIndex(x,y)
    return x+ conf.room.tw * y
end
function Room:indexToLocal(n)
    local y = math.floor(n/conf.room.tw)
    local x = n % conf.room.tw
    return x,y
end

function Room:getNeighbours(n)
    local x,y = self:indexToLocal(n)
    local coords = {{x-1,y},{x+1,y},{x,y-1},{x,y+1}}
    local neighbours = {}
    for i=1, #coords do
        local coord = coords[i]
        if not self:isWall(coord[1],coord[2]) and not self:isRock(coord[1],coord[2]) then
            table.insert(neighbours,self:localToIndex(coord[1],coord[2]))
        end
    end
    return neighbours
end
function Room:getPath(from,to)
local ifrom = self:localToIndex(from[1],from[2])
    local ito = self:localToIndex(to[1],to[2])
    local path = {}
    local frontier = {}
    table.insert(frontier,ifrom)
    local visited = {}
    visited[ifrom] = -1

    while #frontier > 0 do
        local current = table.remove(frontier,1)
        if current == ito then
            break
        end
        local nbs = self:getNeighbours(current)
        if #nbs >0 then
            for i = 1, #nbs do
                local n = nbs[i]
                if not visited[n] then
                    table.insert(frontier,n)
                    visited[n] = current
                end
            end
        end

    end


    local current = ito
    local fromidx = ifrom
    while current ~= fromidx do 
        table.insert(path,current)
        current = visited[current]
    end
    return path
end