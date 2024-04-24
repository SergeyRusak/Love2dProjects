require 'vector'
require 'mover'
require 'rogatka'
function love.load()
    width  = love.graphics.getWidth()
    height = love.graphics.getHeight()
    custom = 50
    offset_x = 150
    offset_y = 500
    bg = love.graphics.newImage("sprites/bg.png")
    p_x = 0
    p_y = 0
    aim = false
    sling = Sling:create(offset_x,offset_y,custom)
    gravity = Vector:create(0,100)
    torture = 100
    movers = {}
end
function love.update(dt)
    if love.mouse.isDown(1) then
        local x,y = love.mouse.getPosition()
        if aim then
        
        sling:pull(x-p_x+offset_x,y-p_y+offset_y)
        else
            aim = true
            p_x = x
            p_y = y
        end
    end
    for id,mover in pairs(movers) do
        local v = mover.velocity:copy()
        v:mul(-torture)
        mover:applyForce(gravity)
        mover:update(dt)
        if mover.velocity:mag()<mover.size*0.25 then
            table.remove(movers,id)
        end
        
    end
end
function love.draw()
love.graphics.draw(bg,0,0,0,width/bg:getPixelWidth(),height/bg:getPixelHeight())

    if aim then
        love.graphics.circle('line',p_x,p_y,5)
    end
    sling:draw()
    for _,mov in pairs(movers) do
        mov:draw()
    end
end

function love.mousereleased(m)
    aim = false
    local m = sling:fire()
    table.insert(movers,m)
end