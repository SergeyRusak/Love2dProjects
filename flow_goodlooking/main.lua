require("vector")
require("vehicle")
require("gradient")

function love.load()
    frames = 0
    time = 0
    settings = love.filesystem.load("EDITME.lua")()
    type = "none"
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    vchs={}
    for i = 1,20000 do
        table.insert(vchs,Vehicle:create(math.random(0,width),math.random(0,height)))
    end
    flowForce = 1
    grad = Gradient:create(192,108)
end

function love.update(dt)
    frames = 1/dt
    time = time + dt
    if time >= 10 then
        time = time -1
        settings = love.filesystem.load("EDITME.lua")() 
    end
    local x, y = love.mouse.getPosition()
    for k,v in pairs(vchs) do
        v:follow(grad)
        v:borders()
        v:update()
    end

    if love.mouse.isDown(1) then
    end
    if love.mouse.isDown(2) then 
    end
end

function love.draw()
    love.graphics.setBlendMode(settings.screen.blend,'premultiplied')
    for k,v in pairs(vchs) do
        v:draw()
    end
    if debug then
    grad:draw()
    end

    love.graphics.setBlendMode('replace')
    local color = settings.screen.backgroundcolor
    love.graphics.setBackgroundColor(color[1],color[2],color[3])
    love.graphics.setColor(1-color[1],1-color[2],1-color[3])
    end

function love.mousepressed(x, y, button, istouch, presses)
    
end

function love.mousereleased(x, y, button, istouch, presses)

end
function love.keypressed(key)
    print(key)

    if key == "d" then
        debug = not debug
    end 
    if key == "escape" then
        love.event.quit()
    end 
    
    if key =="0" then
        grad:generate("getover")
        type = "GETOVERHERE!!!"
    end
    if key =="1" then
        grad:generate("random")
        type = "random"
    end
    if key =="2" then
        grad:generate("swarn")
        type = "swarn"
    end
    if key =="3" then
        grad:generate("circle")
        type = "circle"
    end
    if key =="4" then
        grad:generate("spiral")
        type = "spiral"
    end
    if key =="5" then
        grad:generate("zavardo")
        type = "zavardo"
    end
    if key =="6" then
        grad:generate("ray")
        type = "ray"
    end
end

local function runFile(name)
	local ok, chunk, err = pcall(love.filesystem.load, name) -- load the chunk safely
	if not ok    then  return false, "Failed loading code: "..chunk  end
	if not chunk then  return false, "Failed reading file: "..err    end

	local ok, value = pcall(chunk) -- execute the chunk safely
	if not ok then  return false, "Failed calling chunk: "..tostring(value)  end

	return true, value -- success!
end
