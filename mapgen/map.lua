Map = {}
Map.__index = Map

function Map:create(w,h)
    local map = {}
    setmetatable(map, Map)
    
    map.map = {}
    map.width = w or 13
    map.height = h or 13
    map.c_x = math.floor(w/2)+1
    map.c_y = math.floor(h/2)+1
    for y = 1, width do
        local t = {}
        for x =1,height do
            table.insert(t,nil)
        end
        table.insert(map.map,t)
    end
    return map
end
function Map:generate()
    self.map[self.c_y][self.c_x] = Room:create()
    self:_generate(self.c_x,self.c_y,0)
end

function Map:_generate(x,y,l)
    if self.map[y][x].doors ~= nil  then
        return
    end
    self.map[y][x].doors = {0,0,0,0}
    local ways = self:getNear(x,y)
    for i,c in pairs(ways) do
        if c == -1 then
            self.map[y][x].doors[i] = 0
        end
        if c == 1 then
            self.map[y][x].doors[i] = 1 
        end
        if c ==0 and math.random() > l then
            self.map[y][x].doors[i] = 1
            if i == 1 then
                self.map[y-1][x] = Room:create()
                self:_generate(x,y-1,l+0.3)   
            end
            if i == 2 then
                self.map[y][x+1] = Room:create()
                self:_generate(x+1,y,l+0.3)   
            end 
            if i == 3 then
                self.map[y+1][x] = Room:create()
                self:_generate(x,y+1,l+0.3)   
            end 
            if i == 4 then
                self.map[y][x-1] = Room:create()
                self:_generate(x-1,y,l+0.3)   
            end 
        end
    end 


end

function Map:nextRoom(nx,ny)
    if(self.c_x + nx > 0 and self.c_x + nx < self.width+1) and (self.c_y + ny > 0 and self.c_y + ny < self.height+1)then
        self.c_x = self.c_x + nx
        self.c_y = self.c_y + ny
        return true
    end
    return false
end

function Map:getNear(x,y)
    local n = {-1,-1,-1,-1}
    if (x+1<self.width + 1) then
        if self.map[y][x+1] ~= nil then
            if(self.map[y][x+1].doors[4] == 1) then
                n[2] = 1
            else
                n[2] = -1
            end
        else
            n[2] = 0
        end
    end
    if (x-1>0) then
        if self.map[y][x-1] ~= nil then
            if(self.map[y][x-1].doors[2] == 1) then
                n[4] = 1
            else
                n[4] = -1
            end
        else
            n[4]=0
        end
    end
    if (y+1< self.height+1) then
        if self.map[y+1][x] ~= nil then
            if(self.map[y+1][x].doors[1] == 1) then
                n[3] = 1
            else
                n[3] = -1
            end
        else
            n[3]=0
        end
    end
    if (y-1>0) then
        if self.map[y-1][x] ~= nil then
            if(self.map[y-1][x].doors[3] == 1) then
                n[1] = 1
            else
                n[1] = -1
            end
        else
            n[1] = 0
        end
    end
    return n    
end

function Map:drawAll(size)
    love.graphics.push()    
    for i,r in pairs(self.map) do
        for j,c in pairs(r) do
            love.graphics.push()
            love.graphics.translate((j-1)*size, (i-1)*size)
            if i==self.c_y and j==self.c_x then
                r,g,b,a = love.graphics.getColor()
                love.graphics.setColor(0.5,0.8,0.5,0.5)
                love.graphics.rectangle("fill",0,0,size,size)
                love.graphics.setColor(r,g,b,a)
            end
            c:drawmap(size)
            love.graphics.pop()
        end 
    end
    love.graphics.pop()
end

function Map:drawRoom()
    self.map[self.c_y][self.c_x]:draw()
end