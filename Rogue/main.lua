

require 'pqueue'
require 'player'
require 'map'
function love.load()
    width  = love.graphics.getWidth()
    height = love.graphics.getHeight()
    loadTextures()
    lmap = {{ 3,  7,  7, 13,  7,  7,  7,  4},
           { 8,  0,  0,  8,  0,  0,  0,  8},
           { 8,  0,  0,  8,  0,  0,  0,  8},
           { 8,  0,  0,  8, 14,  0,  0,  8},
           { 8,  0,  0, 10,  0,  9,  14,  8},
           { 8,  0,  0,  0,  0,  10,  14,  8},
           { 8,  0,  0,  0,  0,  0,  0,  8},
           { 5,  7,  7,  7,  7,  7,  7,  6}}

    map = Map:create(lmap)
    scaleX = width/(map.width*16)
    scaleY = height/(map.height*16)
    player = Player:create(Map:localToGlobal(1,1))
    
end
function love.update(dt)
    player:update(dt)
end
function love.draw()

    love.graphics.push()
    love.graphics.scale(scaleX,scaleY)
    map:draw()
    player:draw()
    love.graphics.pop()
end


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
        {13, 1*16,  0*16}, -- down cross
        {14, 3*16, 14*16}, -- spikes
    }
    env.textures = {}
    for i = 1, #quads do
        local q = quads[i]
        env.textures[q[1]] = love.graphics.newQuad(q[2], q[3], 16, 16, env.tileset:getDimensions())
    end

    pl = {}
    pl.idle ={} 
    pl.tileset = love.graphics.newImage("assets/RoguePlayer_48x48.png")
    pl.move = {}
    for i = 1, 6 do
        pl.move[i] = love.graphics.newQuad((i - 1) * 48, 48 * 2, 48, 48, pl.tileset:getDimensions())
    end

    for i = 1, 8 do
        pl.idle[i] = love.graphics.newQuad((i - 1) * 48, 0, 48, 48, pl.tileset:getDimensions())
    end

end


function love.mousepressed(x,y,button)
    local gx = x/scaleX
    local gy = y/scaleY
    local lx,ly = Map:globalToLocal(gx,gy)
    if not map:isWall(lx,ly) then
        local lpx,lpy = map:globalToLocal(player.x,player.y) 
        local path = map:getPathW({lpx,lpy},{lx,ly})
        player:setPath(map:pathToGlobal(path))

       
    end
end