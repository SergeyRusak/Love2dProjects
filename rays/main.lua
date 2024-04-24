require 'obstacle'
require 'ray'
function love.load()
    width  = love.graphics.getWidth()
    height = love.graphics.getHeight()

    obstacles = {}

    local points = {{50, 50}, {width-50, 50}, {width-50, height-50}, {50, height-50}, {50, 50}}
    obstacles[1] = Obstacle:create(points)
    
    points = {{100, 100}, {100, 200}, {200, 200}, {200, 100}, {100, 100}}
    obstacles[2] = Obstacle:create(points)
    
    points = {{500, 100}, {650, 100}, {650, 300}, {500, 100}}
    obstacles[3] = Obstacle:create(points)

    points = {{450, 400}, {650, 500}, {480, 600}, {380, 420}, {450, 400}}
    obstacles[4] = Obstacle:create(points)

    points = {{80, 300}, {140, 300}, {140, 470}, {120, 470}, {80, 300}}
    obstacles[5] = Obstacle:create(points)
    points = {{125, 125}, {125, 175}, {175, 175}, {175, 125}, {125, 125}}
    obstacles[6] = Obstacle:create(points)

    rays={}
    rcount = 180
    for i = 1,rcount do
        local ray = Ray:create()
        table.insert(rays,ray)
    end

end

function love.update(dt)
    local x,y= love.mouse.getPosition()
    for i,o in pairs(obstacles) do
        o.visible = false
    end
    for i = 1, #rays do
        rays[i].origin = {x,y}
        rays[i].to = {tonumber(string.format("%.3f", math.cos(math.pi*2 /#rays * i)))+x,tonumber(string.format("%.3f", math.sin(math.pi*2 /#rays * i)))+y}
        rays[i]:castTo(obstacles)
    end

end
function love.draw()
    
    for i = 1,#rays do
        rays[i]:draw()
    end
    for i,o in pairs(obstacles) do
        o:draw()
    end
end