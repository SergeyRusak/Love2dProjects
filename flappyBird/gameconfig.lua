debug = true
--window settings
width  = 1280
height = 720


--world settings
gravity = 500
speed = 200
--background settings
menu_img = love.graphics.newImage("gfx/menu.png")

--wall settings
gapbtwwalls = width/2
wallwidth = width/10
wallscnt = 5
lastwall = 0

--bird settings
brd_i = love.graphics.newImage("gfx/idle.png")
brd_f = love.graphics.newImage("gfx/flap.png")
brd_d = love.graphics.newImage("gfx/dth.png")
brd_scale = 0.1
brd = brd_i
bird = {}
bird.w = brd:getWidth()  * brd_scale * 0.8
bird.h = brd:getHeight() * brd_scale *0.8
print(bird.w,bird.h)
bird.x = width/2
bird.jump = 200
function birdupdate(dt,isgm)
    if not isgm then
        if bird.velocity < 0 then
            brd = brd_f
        else
            brd = brd_i
        end
        bird.velocity = bird.velocity + (gravity * dt)
        bird.pos = bird.pos + (bird.velocity * dt)
    else
        brd = brd_d
        
    end
end


--new game settings
startgap = height*0.7
startpos = height/2
mingap = bird.h * 2


--function for newGame
function startGameSetup()
    bird.x = width/2
    bird.pos = height/2
    bird.velocity = bird.jump
    score = 0
    gapbtwwalls = width/3
    walls = {}
    lastgap = startgap
    lastpos = startpos
end


local font = love.graphics.newFont("fonts/Adigiana_2.ttf",50)
love.graphics.setFont(font)
pipe = love.graphics.newImage("gfx/peg.png")
pipe_sx =wallwidth/pipe:getPixelWidth()