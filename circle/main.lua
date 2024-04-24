require 'code'
function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    angle = 0
    anglespeed = math.pi*2/3 --треть круга в секунду
    coder = Coder:create()
    text = ""
    encode = {}
    print(text)
    encode = coder:encode(text)
end
function love.update(dt)

    angle = angle+ anglespeed* dt
    if angle > math.pi*2 then
        angle = angle - math.pi*2
    end
    
end
function love.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Text:"..text,0,0)
    love.graphics.print("Press A,B,C or D for encode",0,15)
    love.graphics.print("Press delete for clear encode text",0,30)
    love.graphics.push()
    love.graphics.translate(width/2,height/2)
    love.graphics.rotate(-angle)
    love.graphics.setColor(1,1,1,1)
    is_white = false
    local ta = 0
    for i,t in pairs(encode) do
        
        if is_white then
            love.graphics.setColor(1,1,1,1)
        else
            love.graphics.setColor(0,0,0,1)
        end
        love.graphics.arc("fill","pie",0,0,height/3,math.rad(ta),math.rad(ta+t))
        is_white = not is_white
        ta = ta +t
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.circle("fill",0,0,height/3*0.7)
    love.graphics.setColor(0,0,0,1)
    love.graphics.circle("fill",0,0,height/3*0.2)
    love.graphics.circle("fill",height*0.1,0,height*0.01)
    
    love.graphics.pop()
end

function love.keypressed(key)
    if key == "a" or key == "b" or key == "c" or key == "d"  then
        text = text..string.upper(key)
        encode = coder:encode(text)
    end
    if key == "delete" then
        text =""
        encode = coder:encode(text)
    end
end