settings = {}
--flow settings
settings.screen = {}
settings.screen.backgroundcolor = {0,0,0} -- RGB color of background (from 0.0 to 1.0)
settings.screen.blend = 'screen' -- blendmode 
-- available: 'alpha','screen','add','subtrack','multiply','lighten','darken'
settings.dot = {}
settings.dot.size = function(x)
    return 1/(x+0.1)
end



return settings