require 'room'
require 'map'
require 'player'
require 'enemy'

function love.load()
    math.randomseed(os.time())

    conf = confGenerate()



    heart = {}
    heart[1] = love.graphics.newImage("sprites/heart1.png")
    heart[2] = love.graphics.newImage("sprites/heart2.png")
    heart[3] = love.graphics.newImage("sprites/heart3.png")
NewGame()

    showAll = true
end
function love.update(dt)
    input(dt)
    if player.x > conf.room.offset_move + conf.room.ts * conf.room.tw - player.r then
        map:nextRoom(1,0)
        player.x = player.r
    end
    if player.y < player.r-conf.room.offset_move then
       map:nextRoom(0,-1)
       player.y = conf.room.th*conf.room.ts - player.r
    end
    if player.x < player.r-conf.room.offset_move then
        map:nextRoom(-1,0)
        player.x = conf.room.offset_move + conf.room.ts * conf.room.tw - player.r
    end
   if player.y > conf.room.offset_move +conf.room.th*conf.room.ts - player.r then 
        map:nextRoom(0,1)
        player.y = player.r + conf.room.offset_y + conf.room.offset_move*conf.room.sy
    end


    local room = map.map[map.c_y][map.c_x]
    if player.x > conf.room.ts * conf.room.tw - player.r then
        if room.doors[2] ==0 or not(player.y >conf.room.ts * conf.room.th*0.5 - 25 and player.y <conf.room.ts * conf.room.th*0.5 + 25) then
        player.x = conf.room.ts * conf.room.tw - player.r
        end
    end
    if player.y < player.r then
        if room.doors[1] ==0 or not (player.x >conf.room.ts * conf.room.tw*0.5 - 25 and player.x <conf.room.ts * conf.room.tw*0.5 + 25) then
       player.y = player.r
        end
    end
    if player.x < player.r then
        if room.doors[4] ==0 or not (player.y >conf.room.ts * conf.room.th*0.5 - 25 and player.y <conf.room.ts * conf.room.th*0.5 + 25) then
        player.x = player.r
        end
    end
   if player.y > conf.room.th*conf.room.ts - player.r then 
    if room.doors[3] ==0 or not (player.x >conf.room.ts * conf.room.tw*0.5 - 25 and player.x <conf.room.ts * conf.room.tw*0.5 + 25) then
        player.y = conf.room.th*conf.room.ts - player.r
    end
    end



    room:update(player,dt)


end
function love.draw()

    love.graphics.push()
    love.graphics.translate(conf.room.offset_x,conf.room.offset_y)
    love.graphics.scale(conf.room.sx,conf.room.sy)
    map:drawRoom()
    player:draw()
    love.graphics.pop()

    
    if showAll then
        love.graphics.push()
    love.graphics.translate(conf.minimap.x,conf.minimap.y)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle('fill',0,0, conf.minimap.s * conf.map.w,conf.minimap.s * conf.map.h)
    love.graphics.setColor(1,1,1,1)
        map:drawAll(conf.minimap.s)
        love.graphics.pop()
    end
   
    local mhp = player.maxHP
    local h = player.hp
    local i = 1
    while mhp > 0 do
        if h > 1 then
            love.graphics.draw(heart[1],i*64 +(8*i-1),16)
            h = h-2
        else
            if h>0 then
                love.graphics.draw(heart[2],i*64 +(8*i-1),16)
                h = h-1
            else
                love.graphics.draw(heart[3],i*64 +(8*i-1),16)
            end
        end
        mhp = mhp-2
        i=i+1
    end
    love.graphics.setColor(1,1,1,1)
end

function input(dt)
    local ix = 0
    local iy = 0
    if love.keyboard.isDown('w') then
        iy =  iy -1
    end
    if love.keyboard.isDown('s') then
        iy = iy + 1
    end
    if love.keyboard.isDown('a') then
        ix = ix - 1
    end
    if love.keyboard.isDown('d') then
        ix = ix + 1
    end

    player:update(dt,ix,iy)
end

function love.keypressed(key)
   
    if key == 'm' then
       showAll = not showAll
    end
    if key =='escape' then
        love.event.quit()
    end
    if key =="space" then
        player:fight(map.map[map.c_y][map.c_x].enemies)
    end
    if key =="r" then
        NewGame()
    end

end


function NewGame()
    map = Map:create(conf.map.w,conf.map.h)
    map:generate()
    player = Player:create()
end