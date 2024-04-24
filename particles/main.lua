require("vector")
require("particle")
require("particleSystem")
require("particleGroupLibrary")

function love.load()
    frames = 0
    math.randomseed(os.time())
    particleSystem = ParticleSystem:create()
end

function love.update(dt)
    frames = 1/dt
    for i = 0,60 do
        x,y = love.mouse.getPosition()
    particleSystem:addBundle(boxbreakparticle2(math.random(0,width),math.random(0,height),1,1,0))
end
   particleSystem:update(dt)
end

function love.draw()
    love.graphics.print(tostring(frames),0,0)
    love.graphics.setColor(0.5,1,0.5,1)
    particleSystem:draw()
    
end

function love.mousepressed(x,y,button,istouch,presses)

end