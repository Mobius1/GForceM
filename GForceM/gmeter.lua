
GMeter = {
    sw = 0, sh = 0,
    PlayerPed = nil,
    inVehicle = false,
    vehicle = nil,
    vspeed = 0,
    vector = vector3(0,0,0),
    v1 = 0, v2 = 0,
    acelY = 0, acelX = 0,
    time = 1,
    ang = 0, ang2 = 0, ang3 = 0,
    Initialised = false,
    driver = false,
    textureDict = "gforce",
    killed = false
}

function GMeter:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function GMeter:__init()
    if not self.Initialised then
        Citizen.CreateThread(function()
            self.Initialised = true
            self.killed = false

            self.PlayerPed = PlayerPedId()
            self.inVehicle = IsPedInAnyVehicle(self.PlayerPed, false)
            
            if self.inVehicle then
                self.vehicle = GetVehiclePedIsUsing(self.PlayerPed)
                self.driver = self:__isDriver()
            end

            self:__getScreenSize()
            self:__createGrid()
            self:__createPointer() 

            self:__startInteractionThread()
            self:__startTimerThread()
            self:__startGForceThread()
            self:__startRenderThread()
        end)
    end
end

function GMeter:__destroy()
    self.Initialised = false
    self.killed = true
end

function GMeter:__getScreenSize()
    self.sw, self.sh = GetActiveScreenResolution()
end

function GMeter:__createGrid()
    Config.Grid.w = (Config.Grid.Width * self.sw) / self.sw
    Config.Grid.h = (Config.Grid.Height * self.sw) / self.sh
    
    Config.Grid.hx = Config.Grid.w/2
    Config.Grid.hy = Config.Grid.h/2

    Config.Grid.mx = Config.Grid.Pos.x+Config.Grid.hx
    Config.Grid.my = Config.Grid.Pos.y+Config.Grid.hy
end

function GMeter:__createPointer()
    -- LOAD SPRITE
    if not HasStreamedTextureDictLoaded(self.textureDict) then
        RequestStreamedTextureDict(self.textureDict)
    
        while not HasStreamedTextureDictLoaded(self.textureDict) do
            Citizen.Wait(1)
        end
    end           

    Config.Pointer.x = 0
    Config.Pointer.y = 0
    Config.Pointer.w = (Config.Pointer.Size * self.sw) / self.sw
    Config.Pointer.h = (Config.Pointer.Size * self.sw) / self.sh      
end

function GMeter:__getYAcceleration()
    self.v2 = GetEntitySpeed(self.vehicle)

    -- reversing
    if self.vector.y < 0 then
        self.v2 = self.v2 * -1
    end

    self.acelY = ((self.v2 - self.v1)/self.time) * 98.1
end

function GMeter:__getXAcceleration()
    self.ang2 = GetEntityPhysicsHeading(self.vehicle)
    self.ang = ((self.ang2-self.ang3) / self.time) * 0.01745
    self.acelX = (self.ang * self.v2) * 98.1
end

function GMeter:__limitG()
    if math.abs(self.acelX) > Config.MaxG.x then
        Config.Pointer.x = Config.Grid.mx
    end

    if self.acelX < -Config.MaxG.x then
        Config.Pointer.x = Config.Grid.Pos.x-Config.Grid.hx
    end    

    if math.abs(self.acelY) > Config.MaxG.y then
        Config.Pointer.y = Config.Grid.my
    end   
    
    if self.acelY < -Config.MaxG.y then
        Config.Pointer.y = Config.Grid.Pos.y-Config.Grid.hy
    end    
end

function GMeter:__renderLabels()
    -- X-Axis            
    self:__renderText(self:__round(Config.MaxG.x, 2), Config.Grid.Pos.x - Config.Grid.hx - 0.005, Config.Grid.Pos.y + Config.Grid.hy + 0.005, 1, 0.2)
    self:__renderText(self:__round(Config.MaxG.x / 2, 2), (Config.Grid.Pos.x - (Config.Grid.hx / 2)) - 0.005, Config.Grid.Pos.y + Config.Grid.hy + 0.005, 1, 0.2)
    self:__renderText("0.0", Config.Grid.Pos.x - 0.005, Config.Grid.Pos.y + Config.Grid.hy + 0.005, 1, 0.2) 
    self:__renderText(self:__round(Config.MaxG.x / 2, 2), (Config.Grid.Pos.x + (Config.Grid.hx / 2)) - 0.005, Config.Grid.Pos.y + Config.Grid.hy + 0.005, 1, 0.2)  
    self:__renderText(self:__round(Config.MaxG.x, 2), (Config.Grid.Pos.x + Config.Grid.hx) - 0.005, Config.Grid.Pos.y + Config.Grid.hy + 0.005, 1, 0.2) 
    
    -- Y-Axis
    self:__renderText(self:__round(Config.MaxG.y, 2), Config.Grid.Pos.x + Config.Grid.hx + 0.005, (Config.Grid.Pos.y + Config.Grid.hy) - 0.009, 1, 0.2)
    self:__renderText(self:__round(Config.MaxG.y / 2, 2), Config.Grid.Pos.x + Config.Grid.hx + 0.005, (Config.Grid.Pos.y - (Config.Grid.hy / 2)) - 0.009, 1, 0.2)
    self:__renderText("0.0", Config.Grid.Pos.x + Config.Grid.hx + 0.005, Config.Grid.Pos.y - 0.009, 1, 0.2)
    self:__renderText(self:__round(Config.MaxG.y / 2, 2), Config.Grid.Pos.x + Config.Grid.hx + 0.005, (Config.Grid.Pos.y + (Config.Grid.hy / 2)) - 0.009, 1, 0.2)
    self:__renderText(self:__round(Config.MaxG.y, 2), Config.Grid.Pos.x + Config.Grid.hx + 0.005, (Config.Grid.Pos.y - Config.Grid.hy) - 0.009, 1, 0.2)
    
    -- self:__renderText("X: " .. self:__round(maConfig.Grid.h.abs(acelX), 2) .. " G", Config.Grid.Pos.x + Config.Grid.hx + 0.005, Config.Grid.Pos.y - 0.009, 1, 0.2)
    -- self:__renderText("Y: " .. self:__round(maConfig.Grid.h.abs(acelY), 2) .. " G", Config.Grid.Pos.x - 0.01, Config.Grid.Pos.y + Config.Grid.hy + 0.005, 1, 0.2)    
end

function GMeter:__renderPointer()
    DrawSprite(self.textureDict, "dot64", Config.Pointer.x, Config.Pointer.y, Config.Pointer.w * 1.5, Config.Pointer.h * 1.5, 0.00, Config.Pointer.BorderColor.r, Config.Pointer.BorderColor.g, Config.Pointer.BorderColor.b, Config.Pointer.BorderColor.a)    
    DrawSprite(self.textureDict, "dot64", Config.Pointer.x, Config.Pointer.y, Config.Pointer.w, Config.Pointer.h, 0.00, Config.Pointer.BackgroundColor.r, Config.Pointer.BackgroundColor.g, Config.Pointer.BackgroundColor.b, Config.Pointer.BackgroundColor.a) 
end

function GMeter:__renderGrid()
    local sw, sh = self.sw, self.sh

    if Config.ShowBackground then
        -- Background
        DrawRect(Config.Grid.Pos.x, Config.Grid.Pos.y, Config.Grid.w, Config.Grid.h, Config.Grid.BackgroundColor.r, Config.Grid.BackgroundColor.g, Config.Grid.BackgroundColor.b, Config.Grid.BackgroundColor.a)  
    end


    -- Horizontal Top
    DrawRect(Config.Grid.Pos.x, Config.Grid.Pos.y - Config.Grid.hy, Config.Grid.w, 2 / sh, 255, 255, 255, 255)

    -- Horizontal Center
    DrawRect(Config.Grid.Pos.x, Config.Grid.Pos.y, Config.Grid.w, 1 / sh, 255, 255, 255, 255) 

    -- Horizontal Bottom
    DrawRect(Config.Grid.Pos.x, Config.Grid.Pos.y + Config.Grid.hy, Config.Grid.w, 2 / sh, 255, 255, 255, 255)
    
    
    -- Vertical Left
    DrawRect(Config.Grid.Pos.x - Config.Grid.hx, Config.Grid.Pos.y, 2 / sw, Config.Grid.h, 255, 255, 255, 255)
    
    -- Vertical Center
    DrawRect(Config.Grid.Pos.x, Config.Grid.Pos.y, 1 / sw, Config.Grid.h, 255, 255, 255, 255)
    
    -- Vertical Right
    DrawRect(Config.Grid.Pos.x + Config.Grid.hx, Config.Grid.Pos.y, 2 / sw, Config.Grid.h, 255, 255, 255, 255) 
    
             
    if Config.ShowGridLines then
        DrawRect(Config.Grid.Pos.x, Config.Grid.Pos.y - (Config.Grid.hy / 2), Config.Grid.w, 1 / sh, 255, 255, 255, 100)
        
        DrawRect(Config.Grid.Pos.x, Config.Grid.Pos.y + (Config.Grid.hy / 2), Config.Grid.w, 1 / sh, 255, 255, 255, 100) 
        
        DrawRect(Config.Grid.Pos.x - (Config.Grid.hx / 2), Config.Grid.Pos.y, 1 / sw, Config.Grid.h, 255, 255, 255, 100)
        
        DrawRect(Config.Grid.Pos.x + (Config.Grid.hx / 2), Config.Grid.Pos.y, 1 / sw, Config.Grid.h, 255, 255, 255, 100)
    end
end

function GMeter:__startInteractionThread()
    Citizen.CreateThread(function()
        while true do
            if self.killed then
                return
            end

            self.inVehicle = IsPedInAnyVehicle(self.PlayerPed, false)
            if self.inVehicle then
                self.vehicle = GetVehiclePedIsUsing(self.PlayerPed)
                self.driver = self:__isDriver()
            end
            Citizen.Wait(1000)
        end
    end)    
end

function GMeter:__startTimerThread()
    Citizen.CreateThread(function()
        while true do

            if self.killed then
                return
            end

            if self.inVehicle and self.driver then
                local vtime = GetGameTimer()
                Citizen.Wait(Config.Tick)
                self.time = GetGameTimer() - vtime
            else
                Citizen.Wait(1000)
            end
        end
    end)    
end

function GMeter:__startGForceThread()
    Citizen.CreateThread(function()
        while true do

            if self.killed then
                return
            end

            if self.inVehicle and self.driver then
                -- PREVENT DIVIDE-BY-ZERO ERRRORS
                if self.time <= 0 then
                    self.time = 1
                end
    
                -- UPDATE VEHICLE VECTOR
                self.vector = GetEntitySpeedVector(self.vehicle, true)
    
                if self.v1 ~= self.v2 then
                    self.v1 = self.v2
                end
    
                if self.ang3 ~= self.ang2 then
                    self.ang3 = self.ang2
                end
    
                -- GET VEHICLE ACCELERATION
                self:__getXAcceleration()
                self:__getYAcceleration()
    
                Citizen.Wait(Config.Tick)
            else
                Citizen.Wait(1000)
            end
        end
    end)    
end

function GMeter:__startRenderThread()
    Citizen.CreateThread(function()
        while true do

            if self.killed then
                return
            end

            if self.inVehicle and self.driver then
                -- UPDATE POINTER POSITION
                Config.Pointer.x = Config.Grid.Pos.x + ((self.acelX / Config.MaxG.x) * Config.Grid.hx)
                Config.Pointer.y = Config.Grid.Pos.y + ((self.acelY / Config.MaxG.y) * Config.Grid.hy) 
                
                -- LIMIT G TO GRID
                self:__limitG()
    
                -- RENDER GRID
                if Config.ShowGrid then
                    self:__renderGrid()
                end
    
                -- RENDER POINTER
                self:__renderPointer()
                
                -- RENDER LABELS
                if Config.ShowLabels then
                    self:__renderLabels()
                end
            end
    
            Citizen.Wait(0)
        end
    end)
end

function GMeter:__isDriver()
    return self.PlayerPed == GetPedInVehicleSeat(self.vehicle, -1)
end

function GMeter:__renderText(Text, X, Y, J, Scale)
    if J == nil then
        J = 1
    end

    if Scale == nil then
        Scale = 0.75
    end

    SetTextJustification(J)
    SetTextFont(Config.Font)
    SetTextProportional(true)
    SetTextScale(Scale, Scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentSubstringPlayerName(Text)
    DrawText(X, Y)
end

function GMeter:__round(num, places)
    return tonumber(string.format("%." .. (places or 0) .. "f", num))
end