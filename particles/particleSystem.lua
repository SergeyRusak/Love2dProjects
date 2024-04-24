ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:create()
    local ps = {}
    ps.index = 0
    ps.particles = {}

    setmetatable(ps,ParticleSystem)
    return ps
end

function ParticleSystem:addBundle(bundle)
    for key, particle in pairs(bundle) do
        table.insert(self.particles,particle)            
    end
end
function ParticleSystem:update(dt)
    repellers = repellers or {}
    for k,v in pairs(self.particles) do
        if v:isDead() then
            table.remove(self.particles,k)
        end
        v:update(dt)
    end

    

end
function ParticleSystem:draw()
    for k,v in pairs(self.particles) do
        v:draw()
        if v ~= nil then
            local r,g,b,a = love.graphics.getColor()
            if v:isDead() then
                love.graphics.setColor(1,0,0,1)
            else
                love.graphics.setColor(0,1,0,1)
            end
            love.graphics.setColor(r,g,b,a)
        end
    end
    love.graphics.print(table.getn(self.particles),0,20)
end