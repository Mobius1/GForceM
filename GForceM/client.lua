METER = false

AddEventHandler("playerSpawned", function()
    if Config.Enabled then
        if not METER then
            METER = GMeter:new()
        else
            METER:__destroy()
        end

        Citizen.SetTimeout(3000, function()
            METER:__init()
        end)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if Config.Enabled then
        if resource == GetCurrentResourceName() then
            if METER == false then
                METER = GMeter:new()
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if Config.Enabled then
        if resource == GetCurrentResourceName() then
            if METER ~= false then
                METER:__destroy()
                METER = false
            end    
        end
    end
end)

TriggerEvent('chat:addSuggestion', '/gshow', 'Show the G-Meter')
TriggerEvent('chat:addSuggestion', '/ghide', 'Hide the G-Meter')
TriggerEvent('chat:addSuggestion', '/gtoggle', 'Toggle the G-Meter')

RegisterCommand("gshow", function(source, args, raw)
    METER.active = true
end)

RegisterCommand("ghide", function(source, args, raw)
    METER.active = false
end)

RegisterCommand("gtoggle", function(source, args, raw)
    METER.active = not METER.active
end)