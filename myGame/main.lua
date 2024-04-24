


function love.load()
    frame = 0
    ftick = 20
    math.randomseed(os.time())
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    map = {}
    dmap = {}
    border = 10
    mapW = 400
    mapH = 300
    for y = 0, mapH do
        map[y]= {}
        for x=0, mapW do
            map[y][x] = math.floor((math.random(0,100)+55)/100)
            if y>=mapH-border or y <=border or x>= mapW-border or x<=border then
                map[y][x] = 1
            end

        end
    end
    map = smoothMap(map,mapW,mapH)
    map = smoothMap(map,mapW,mapH)
    map = smoothMap(map,mapW,mapH)
    map = smoothMap(map,mapW,mapH)
    map = smoothMap(map,mapW,mapH)
    dmap = smoothfillMap(map,mapW,mapH)
end

function findneibour(map,xx,yy,mapW,mapH)
    count=0
    gaus =map[yy][xx] * 0.25

    if(xx+1>=mapW) then
        count = count + 1
        gaus = gaus + 0.125
    else 
        count = count + map[yy][xx+1]
        gaus  = gaus  + map[yy][xx+1]  * 0.125
    end

    if(xx+1>=mapW or yy+1>=mapH ) then
        count = count + 1
        gaus = gaus + 0.0125
    else 
        count = count + map[yy+1][xx+1]
        gaus  = gaus  + map[yy+1][xx+1]  * 0.0125
    end

    if(xx+1>=mapW or yy-1<0) then
        count = count + 1
        gaus = gaus + 0.0125
    else 
        count = count + map[yy-1][xx+1]
        gaus  = gaus  + map[yy-1][xx+1]  * 0.0125
    end

    if(yy+1>=mapH) then
        count = count + 1
        gaus = gaus + 0.125
    else 
        count = count + map[yy+1][xx]
        gaus  = gaus  + map[yy+1][xx]  * 0.125
    end

    if(xx-1<0) then
        count = count + 1
        gaus = gaus + 0.125
    else 
        count = count + map[yy][xx-1]
        gaus  = gaus  + map[yy][xx-1]  * 0.125
    end

    if(xx-1<0 or yy+1>=mapH) then
        count = count + 1
        gaus = gaus + 0.0125
    else 
        count = count + map[yy+1][xx-1]
        gaus  = gaus  + map[yy+1][xx-1]  * 0.0125
    end

    if(xx-1<0 or yy-1<0) then
        count = count + 1
        gaus = gaus + 0.0125
    else 
        count = count + map[yy-1][xx-1]
        gaus  = gaus  + map[yy-1][xx-1]  * 0.0125
    end

    if(yy-1<0) then
        count = count + 1
        gaus = gaus + 0.125
    else 
        count = count + map[yy-1][xx]
        gaus  = gaus  + map[yy-1][xx]  * 0.125
    end

    return count, gaus
end

function smoothMap(map,mapW,mapH)
    tempMap = {}
    for y = 0, mapH do
        tempMap[y]= {}
        for x=0, mapW do
            tempMap[y][x] = 0
        end
    end
    for y = 0, mapH do
        for x=0, mapW do
            cn,gau = findneibour(map,x,y,mapW,mapH)
            tempMap[y][x] = map[y][x]
            if map[y][x]==0 and cn >=5 then
                tempMap[y][x] = 1
            end
            if map[y][x]==1 and cn < 5 then
                    tempMap[y][x] = 0
            end
                
        end
    end
return tempMap
end

function smoothfillMap(map,mapW,mapH)
    tempMap = {}
    for y = 0, mapH do
        tempMap[y]= {}
        for x=0, mapW do
            tempMap[y][x] = 0
        end
    end
    for y = 0, mapH do
        for x=0, mapW do
            cn, gau = findneibour(map,x,y,mapW,mapH)
            tempMap[y][x] = map[y][x]
            if map[y][x]==0 and cn >=5 then
                tempMap[y][x] = 1
            end
            if gau < 0.55 then
                tempMap[y][x] = 0
            end         
        end
    end
return tempMap
end


function love.update(dt)
    frame = frame + 1000
    if frame == ftick then
        frame = 0
        map = smoothMap(map,mapW,mapH)
        dmap = smoothfillMap(map,mapW,mapH)
    end


end

function love.draw()
    tileW = width/mapW
    tileH = height/mapH

    for y=0,mapH do
        for x=0,mapW do
            if(dmap[y][x]==1) then
                love.graphics.rectangle("fill",x*tileW,y*tileH,tileW,tileH)        
            end
        end
    end
end
