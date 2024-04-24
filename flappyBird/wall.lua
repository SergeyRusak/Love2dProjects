lastwall = 0
walls = {}


Wall = {}  
    function Wall:new(pos, gap)

    local obj = {}
        obj.pos = pos
        obj.gap = gap
        obj.speed = speed
        obj.complete = false
        obj.width = wallwidth
        obj.x = width+obj.width
        function obj:getRect()
            return obj.x, 0, obj.width, obj.pos-(obj.gap/2), obj.x, obj.pos+(obj.gap/2), obj.width, height-obj.pos-(obj.gap/2)
            --        x1,y1,        w1,                  h1,    x2,                  y2,        w2,                  h2
        end
        function obj:draw()
            x1,y1,w1,h1,x2,y2,w2,h2 = self:getRect()
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(pipe,x1,y1+h1,0,pipe_sx,-1)
            love.graphics.draw(pipe,x2,y2,0,pipe_sx)
            if debug then
                love.graphics.rectangle("line",x1,y1,w1,h1)
                love.graphics.rectangle("line",x2,y2,w2,h2)
            end
            
        end
        function obj:regen(pos,gap,lwall)
            self.x = lwall.x + lwall.width + gapbtwwalls
            self.pos = pos
            self.gap  = gap
            self.complete = false
        end
        function obj:isCollide(bird)
                     
            local x1,y1,w1,h1,x2,y2,w2,h2 =  self:getRect()
             return not ((x1 > bird.x+bird.w/2 or bird.x-bird.w/2 > x1+w1) or ((bird.pos-bird.h/2 > y1+h1) and                   
             (y2 > bird.pos+ bird.h/2)))    
                      
                        
                        

                       

        end
        function obj:update(dt,bird,i)
            self.x = self.x -self.speed * dt
            if not self.complete and self.x  < bird.x then
                score = score + 1
                scr:play()
                self.complete = true
            end 
            if self.x+self.width < 0 then
                lastpos,lastgap = genWall(lastpos, lastgap)
                self:regen(lastpos,lastgap,walls[lastwall])
                lastwall = i
            end
        end
        setmetatable(obj, self)
        self.__index = self; return obj
    end

function genWall(prevpos, prevgap)
    
    tempgap = prevgap *0.98
    if tempgap < mingap then
        tempgap = mingap
    end
    temppos = math.random(tempgap,height-tempgap)
    return temppos,tempgap
end

