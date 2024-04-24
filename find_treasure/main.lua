require "world"
require "player"
require "pqueue"
require "maze"

function loadTextures()
    env = {}
    env.tileset = love.graphics.newImage("assets/RogueEnvironment16x16.png")

    local quads = {
        {0,  5*16,  0*16}, -- floor v1
        {1,  6*16,  0*16}, -- floor v2
        {2,  7*16,  0*16}, -- floor v3
        {3,  0*16,  0*16}, -- upper left corner
        {4,  3*16,  0*16}, -- upper right corner
        {5,  0*16,  3*16}, -- lower left corner
        {6,  3*16,  3*16}, -- lower right corner
        {7,  2*16,  0*16}, -- horizontal
        {8,  0*16,  2*16}, -- vertical
        {9,  1*16,  2*16}, -- up
        {10, 2*16,  3*16}, -- down
        {11, 2*16,  1*16}, -- left
        {12, 1*16,  1*16}, -- right
        {13, 2*16,  2*16}, -- down cross
        {14, 1*16,  3*16}, -- up cross
        {15, 3*16,  1*16}, -- left cross
        {16, 0*16,  1*16}, -- right cross
        {17, 3*16, 14*16}, -- spikes
        {18, 5*16, 13*16} -- coin
    }
    env.textures = {}
    for i = 1, #quads do
        local q = quads[i]
        env.textures[q[1]] = love.graphics.newQuad(q[2], q[3], 16, 16, env.tileset:getDimensions())
    end

    pl = {}
    pl.tileset = love.graphics.newImage("assets/RoguePlayer_48x48.png")
    pl.textures = {}
    for i = 1, 6 do
        pl.textures[i] = love.graphics.newQuad((i - 1) * 48, 48 * 2, 48, 48, pl.tileset:getDimensions())
    end

end

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    loadTextures()

    world = World:create()
    scaleX = width / (world.width * 16)
    scaleY = height / (world.height * 16)

    world:placeObjects()
    player = world.player

    visited = {}
    crossroads = {}
    prevdirection =nil

end

function love.update(dt)
    player:update(dt, world)
    world:update(player)
    seek(world:getEnv())
end

function seek(env)
    --print(env.position[1], env.position[2], env.left, env.right, env.up, env.down, env.coin)
   -- print(visited[world:localToIndex(env.position[1]-1,env.position[2])] == nil,
     --     visited[world:localToIndex(env.position[1]+1,env.position[2])] == nil,
       --   visited[world:localToIndex(env.position[1],env.position[2]-1)] == nil,
         -- visited[world:localToIndex(env.position[1],env.position[2]+1)] == nil)
    visited[world:localToIndex(env.position[1], env.position[2])] = true
    local directions = {}
    if not env.left and  visited[world:localToIndex(env.position[1]-1,env.position[2])] == nil  then
        table.insert(directions, "left")
    end
    if not env.right and  visited[world:localToIndex(env.position[1]+1,env.position[2])] == nil then
        table.insert(directions, "right")
    end
    if not env.up and  visited[world:localToIndex(env.position[1],env.position[2]-1)] == nil then
        table.insert(directions, "up")
    end
    if not env.down and  visited[world:localToIndex(env.position[1],env.position[2]+1)] == nil then
        table.insert(directions, "down")
    end

    if #directions < 1 then
        local prevcross = table.remove(crossroads,#crossroads)
        local path = world:getPathW({env.position[1],env.position[2]},{prevcross.position[1],prevcross.position[2]})
        for i,p in pairs(path) do
            visited[p] = nil
        end
        seek(env)
        world:move(directions[love.math.random(1, #directions)])
        return
    end
    local j = love.math.random(1, #directions)
    if #directions >1 then
        table.insert(crossroads,env)
        for i,p in pairs(directions) do
            print(p,prevdirection)
            if p == prevdirection then
                j = i
                
                break
            end
        end
    end
    prevdirection = directions[j]
    world:move(directions[j])
    
end

function love.draw()
    love.graphics.scale(scaleX, scaleY)
    world:draw()
    for i,v in pairs(visited) do
        x,y = world:indexToLocal(i)
        love.graphics.rectangle("fill",x*16,y*16,16,16)
    end
    player:draw(world)
end

function love.keypressed(key)
    if key == "left" then
        world:move("left")
    end
    if key == "right" then
        world:move("right")
    end
    if key == "up" then
        world:move("up")
    end
    if key == "down" then
        world:move("down")
    end
end