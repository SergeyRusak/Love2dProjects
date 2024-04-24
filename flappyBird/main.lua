require 'audio'
require 'gameconfig'
require 'wall'
require 'bg'
love.window.setMode(width,height)



isMenu = true
isGameOver = false
isGame = false
isPause = false

isColliding = false



score = 0
time = 0
kspeed =  1


function love.load()
    math.randomseed(os.time())
    audiosetup()
    bg = BG:create()
end

function love.update(dt)
    time = time +dt
    if not isPause  and not isGameOver then
        bg:update(dt,kspeed)
    end
    if not isMenu then
        if not isPause and not isGameOver then
            if (love.keyboard.isDown('w') or love.keyboard.isDown('space')) and bird.velocity >=-120 then
                bird.velocity = bird.jump * -1
                flaps:play()
            end
            isColliding = (bird.pos-bird.h/2 < 0) or (bird.pos > height-bird.h/2)
            for i = 0,wallscnt do
                if isColliding then
                    break
                end
                isColliding = isColliding or walls[i]:isCollide(bird)
            end
            if  isColliding then
                isGameOver = true
                bgm:stop()
                gms:play()
                
            end
        end
        if not isPause then
            birdupdate(dt,isGameOver)
            for i = 0,wallscnt do
                if not isGameOver then
                    walls[i]:update(dt,bird,i)
                end
            end
        end
    end
end
function love.draw()
    bg:draw()
    if isMenu then
        love.graphics.push()
        love.graphics.translate(width*0.1,height*0.1)
        love.graphics.rotate(math.sin(time)*math.pi/32)
        love.graphics.draw(menu_img,0,0,0,width/menu_img:getPixelWidth()*0.8,width/menu_img:getPixelWidth()*0.8)
        love.graphics.setColor(0,0,0,1)
        love.graphics.print("Чтобы начать игру нажмите ПРОБЕЛ", 160,350)
        love.graphics.setColor(1,1,1,1)
        love.graphics.pop()

    end
    if isGame or isGameOver then
        for i = 0, wallscnt do
            walls[i]:draw()
            local wx = walls[i].x

        end
        
    
        love.graphics.draw(brd,bird.x-brd:getWidth()  * brd_scale * 0.5 ,bird.pos - brd:getHeight() * brd_scale *0.5 ,0,brd_scale,brd_scale)
         local ty = bird.pos - bird.h*1.5
         if ty < height*0.1 then
            ty = height*0.1
        end
        if(isGameOver) then
            love.graphics.setColor(0,0,0,0.5)
            love.graphics.rectangle("fill",0,0,width,height)
            love.graphics.setColor(1,1,1,1)
            love.graphics.print("Конец игры",bird.x-width*0.2,ty)
            love.graphics.print("Для начала новой игры нажмите Пробел",bird.x-width*0.2,ty + 60)
        else
            love.graphics.setColor(0,0,0,1)
        end        
        love.graphics.print("Счёт: "..tostring(score),bird.x-10,ty)
    end
    
    
    if(isPause) then
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle("fill",0,0,width,height)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print("Пауза",width/3,height/2-10)
    end
    
end

function love.keypressed(key)
    
    if key == 'space' and (isGameOver or (not isGame)) then
        isMenu = false
        isGame = true
        isGameOver = false
        newGame()
        gms:stop()
        bgm:play()
    end

    if (key =='space'or key =='w') and isGame and not isPause then
        flaps:stop()
        flaps:play()
        if bird.velocity > 0 then
            bird.velocity = 0
        end
        bird.velocity = bird.jump * -1
    end
    if key == 'p'and isGame then
        isPause = not isPause
    end
end



function newGame()
    startGameSetup()
    kspeed = 1
    for i = 0, wallscnt  do
        p,g = genWall(lastpos,lastgap)
        tempw = Wall:new(p,g)
        lastgap = g
        lastpos = p
        tempw.x = width+ (gapbtwwalls+tempw.width)*i
        walls[i] = tempw
        lastwall = i
    end

end



