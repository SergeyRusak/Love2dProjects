Map = {}
Map.__index = Map

function Map:create(lmap)
    for i,m in pairs(lmap) do
    end
    local map = {}
    map.map = lmap
    map.height = #lmap
    map.width = #lmap[1]
    map.weight = {}
    setmetatable(map, Map)
    return map
end
function Map:draw()
   
    for i = 1, self.height do
        for j = 1, self.width do
            local cell = self.map[i][j]
            local texture = env.textures[cell]
            love.graphics.draw(env.tileset,texture,16*(j-1),16*(i-1))
            if self.weight[self:localToIndex(j-1,i-1)] ~= nil  then
                love.graphics.print(tostring(self.weight[self:localToIndex(j-1,i-1)]),16*j-16,16*i-16)
            end
        end
    end
    
end


function Map:globalToLocal(x,y)
    return math.floor(x/16), math.floor(y/16)
end
function Map:localToGlobal(x,y)
    return math.floor(x*16 + 8), math.floor(y*16 + 8)
end
function Map:pathToGlobal(path)
    local npath = {}
    for i,p in pairs(path) do
        local tx,ty = self:indexToLocal(p)
        local x,y = self:localToGlobal(tx,ty)
        table.insert(npath,1,{x,y})
    end
    return npath
end


function Map:isWall(x,y)
    return self.map[y+1][x+1] >=3 and self.map[y+1][x+1] <=13
end 

function Map:isSpikes(x,y)
    return self.map[y+1][x+1] == 14
end

function Map:localToIndex(x,y)
    return x+ self.width * y
end
function Map:indexToLocal(n)
    local y = math.floor(n/self.width)
    local x = n % self.width
    return x,y
end

function Map:getNeighbours(n)
    local x,y = self:indexToLocal(n)
    local coords = {{x-1,y},{x+1,y},{x,y-1},{x,y+1}}
    local neighbours = {}
    for i=1, #coords do
        local coord = coords[i]
        if not self:isWall(coord[1],coord[2]) then
            table.insert(neighbours,self:localToIndex(coord[1],coord[2]))
        end
    end
    return neighbours
end

function Map:getPath(from,to)
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
    table.insert(path,ifrom)
    return path
end

function Map:getPathW(from,to)
    local ifrom = self:localToIndex(from[1],from[2])
    local ito = self:localToIndex(to[1],to[2])
    local frontier = PQueue:create()
    local path = {}
    frontier:put(0,ifrom)
    self.weight = {}
    local visited = {}
    visited[ifrom] = -1
    local costs = {}
    costs[ifrom] = 0

    while frontier:size() > 0 do
        local p,current = frontier:get()
        if current == ito then
            break
        end
        
        local nbs =self:getNeighbours(current)
        if #nbs > 0  then
            for i=1,#nbs do
                local next  = nbs[i]
                local nextx,nexty = self:indexToLocal(next)
                local cost = 1
                if self:isSpikes(nextx,nexty) then
                    cost = 20
                end
                new_cost = cost--costs[current] + 
                if costs[next] == nil or new_cost <  costs[next] then
                    costs[next] = new_cost
                    local priority = new_cost
                    frontier:put(priority,next)
                    self.weight[next]=priority
                    print(next,priority)
                    visited[next]=current
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
    table.insert(path,ifrom)
    return path


end