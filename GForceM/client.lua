local FirstSpawn    = true
local GMETER        = false

AddEventHandler("playerSpawned", function()
    if FirstSpawn then
        FirstSpawn = false
    
        GMETER = GMeter:new()
        GMETER:__init()
    end    
end)

-- ALLOW RESTART
if FirstSpawn then
    if not GMETER then
        GMETER = GMeter:new()
        GMETER:__init()
    else
        if not GMETER.Initialised then
            GMETER:__init()
        end
    end
end 