require 'vector'
require 'newmover'

function love.load()
    G = 0.4
    n = 15
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    mover  = Mover:create(Vector:create(width/2,height/2-100),Vector:create(0,0),1)
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        mover.angle = mover.angle - 0.05
    end
    if love.keyboard.isDown("right") then
        mover.angle = mover.angle + 0.05
    end
    if love.keyboard.isDown("up") then
        x = 0.1 * math.cos(mover.angle)
        y = 0.1 * math.sin(mover.angle)
        mover:applyForce(Vector:create(x,y))
        mover.active = true
    else
        mover.active = false
    end
    mover:check_boundaries()
    mover:update()
end

function love.draw()
    mover:draw()
end