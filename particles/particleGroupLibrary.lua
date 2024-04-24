function boxbreakparticle(x,y,xs,ys,r)
    local bundle = {}
    local img = love.graphics.newImage("assets/texture.png")
    local yip = img:getPixelHeight() * ys
    local xip = img:getPixelWidth() * xs
    local colorsides = {1,0,0}
    local colordots = {0,1,0}
    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y-yip/2),1,Vector:create(-25,0),Vector:create(25,-25),0,0,0,img,Vector:create(1,0.1),colorsides))
    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y-yip/2),1,Vector:create(0,-25),Vector:create(-25,25),0,0,0,img,Vector:create(0.1,1),colorsides))
    table.insert(bundle, Particle:create(Vector:create(x+xip/2,y-yip/2),1,Vector:create(0,25),Vector:create(-25,-25),0,0,0,img,Vector:create(0.1,1),colorsides))
    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y+yip/2),1,Vector:create(-25,0),Vector:create(25,25),0,0,1,img,Vector:create(1,0.1),colorsides))

    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y-yip/2),3,Vector:create(10,10),Vector:create(50,50),0,0,0,img,Vector:create(0.3,0.3),colordots))
    table.insert(bundle, Particle:create(Vector:create(x+xip/2,y-yip/2),3,Vector:create(-10,10),Vector:create(-50,50),0,0,0,img,Vector:create(0.3,0.3),colordots))
    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y+yip/2),3,Vector:create(10,-10),Vector:create(50,-50),0,0,0,img,Vector:create(0.3,0.3),colordots))
    table.insert(bundle, Particle:create(Vector:create(x+xip/2,y+yip/2),3,Vector:create(-10,-10),Vector:create(-50,-50),0,0,0,img,Vector:create(0.3,0.3),colordots))
    return bundle
end

function boxbreakparticle2(x,y,xs,ys,r)
    local bundle = {}
    local img = love.graphics.newImage("assets/texture.png")
    local yip = img:getPixelHeight() * ys
    local xip = img:getPixelWidth() * xs
    local colorsides = {1,0,0}
    local colordots = {0,1,0}
    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y-yip/2),1,Vector:random(-25,25,-25,25),Vector:random(-25,25,-25,25),0,0,0,img,Vector:create(1,0.1),colorsides))
    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y-yip/2),1,Vector:random(-25,25,-25,25),Vector:random(-25,25,-25,25),0,0,0,img,Vector:create(0.1,1),colorsides))
    table.insert(bundle, Particle:create(Vector:create(x+xip/2,y-yip/2),1,Vector:random(-25,25,-25,25),Vector:random(-25,25,-25,25),0,0,0,img,Vector:create(0.1,1),colorsides))
    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y+yip/2),1,Vector:random(-25,25,-25,25),Vector:random(-25,25,-25,25),0,0,1,img,Vector:create(1,0.1),colorsides))

    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y-yip/2),3,Vector:random(-25,25,-25,25),Vector:random(-25,25,-25,25),0,0,0,img,Vector:create(0.3,0.3),colordots))
    table.insert(bundle, Particle:create(Vector:create(x+xip/2,y-yip/2),3,Vector:random(-25,25,-25,25),Vector:random(-25,25,-25,25),0,0,0,img,Vector:create(0.3,0.3),colordots))
    table.insert(bundle, Particle:create(Vector:create(x-xip/2,y+yip/2),3,Vector:random(-25,25,-25,25),Vector:random(-25,25,-25,25),0,0,0,img,Vector:create(0.3,0.3),colordots))
    table.insert(bundle, Particle:create(Vector:create(x+xip/2,y+yip/2),3,Vector:random(-25,25,-25,25),Vector:random(-25,25,-25,25),0,0,0,img,Vector:create(0.3,0.3),colordots))
    return bundle
end