height = 720
width = 1280
function love.conf(t)
    t.window.width = width
    t.window.height = height
end

function confGenerate()
conf = {}
-- map settings
conf.map = {}
conf.map.w = 13
conf.map.h = 13

--room settings
conf.room = {}
conf.room.tw = 10
conf.room.th = 5
conf.room.ts = 112
conf.room.field ={}
conf.room.field.offset = 78
conf.room.wall = {}
table.insert(conf.room.wall,love.graphics.newImage("sprites/room1.png"))
table.insert(conf.room.wall,love.graphics.newImage("sprites/room2.png"))
table.insert(conf.room.wall,love.graphics.newImage("sprites/room3.png"))
conf.room.door = love.graphics.newImage("sprites/door.png")
conf.room.sx = math.min(width/conf.room.wall[1]:getPixelWidth(),height/conf.room.wall[1]:getPixelHeight())
conf.room.sy = math.min(width/conf.room.wall[1]:getPixelWidth(),height/conf.room.wall[1]:getPixelHeight())
conf.room.offset_move = 45
conf.room.offset_x = (width - conf.room.wall[1]:getPixelWidth()*conf.room.sx)*0.5
conf.room.offset_y = (height - conf.room.wall[1]:getPixelHeight() * conf.room.sy)*0.5

--minimap settings
conf.minimap = {}
conf.minimap.s = math.min(width,height)/math.max(conf.map.w,conf.map.h) * 0.25  
conf.minimap.x = width - conf.minimap.s *conf.map.w 
conf.minimap.y = 0


return conf
end