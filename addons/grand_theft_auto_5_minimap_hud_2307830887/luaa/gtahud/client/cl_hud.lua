paris = paris or {} -- Checks and adds paris Lib
local paris = paris -- Effiency
local surface = surface
local draw = draw
local LocalPlayer = LocalPlayer

-- HUD Made By Paris (https://steamcommunity.com/id/parisiscool/)
-- Please be considerate to the amount of hours put into the map packs, code, and ideas gone into this.
-- I recommend not touching any of this code unless you actually think you understand.

-- If you need support, just add me on steam (link above) and I'll try to get you what you need
-- If you want a specific maps support added, remember they can take 2-15 hours of work to add support for them.
-- This really means that a map may take weeks to be added and we can't do every map.


local Blips = {}

local function PlaySoundEffect()
    local n = math.random(1, 3)
    surface.PlaySound( "paris/sound" .. n .. ".mp3" )
end

-- Main content
steamworks.DownloadUGC( 2034472616, function( name, FileObject )
    if isstring(name) then
        game.MountGMA( name )
    end
end)

-- CUSTOM USER MAPS <<<
function paris:RegisterCustomMap(Details)
    paris.HUDMaps[Details.Map] = Details
    -- Removes workshop addon from fastdl if there is one
    paris.BlacklistedHudMaps = paris.BlacklistedHudMaps or {}
    paris.BlacklistedHudMaps[Details.Map] = true
end

-- Initializes workshop addon if there is one (Doesn't work in singleplayer)
hook.Add("InitPostEntity", "InitializeLuaMapFileHUD", function()

    if paris.BlacklistedHudMaps and paris.BlacklistedHudMaps[game.GetMap()] then return end

    include("gtahud/client/hudmaps/"..game.GetMap()..".lua")
    
end)

--[[                AutoRefresh Thing                ]]
--     This just checks if theres an update in the data.

paris.GlobalScale = 0.1
paris.Mat = nil
paris.Zone = nil

timer.Create("GtaHUDAutoRefresh", 0.25, 0, function()
    paris.AutoRefresh()
end)

local halfcircle = Material("paris/blips/halfcircle.png")
local Lerp = Lerp

local circleOutline = Material("paris/circle_outline.png")


-- local halfcircle = Material("paris/blips/halfcircle.png")

local PANEL = {}

AccessorFunc(PANEL, "MaskSize", "MaskSize", FORCE_NUMBER)

function PANEL:Init()
    -- self.map = vgui.Create("AvatarImage", self)
    -- -- self:SetPos(20,20)
    -- -- self:SetSize(200,200)
    -- self.map:SetPaintedManually(true)

    -- self.CirclePoly = {}
    -- self:SetMaskSize(1)

    -- print("XssdsdsdsdD")

    -- self:SetSize(paris.HUDSettings["HUDSizeX"],paris.HUDSettings["HUDSizeY"])
    self:SetSize(200,200)
    self:SetPos(paris.HUDSettings["HUDPosX"] + 40,ScrH()-(self:GetTall()+paris.HUDSettings["HUDPosY"]) - 30)

    self.rotation = 0
    self.vertices = 360
    self.scaler = 1
    self.map = vgui.Create("GtaCircleMap", self)
    self.map:SetPaintedManually(true)

    self.overlay = vgui.Create("GtaCircleMapOverlay", self)
    self.overlay:SetPaintedManually(true)


    paris.HUDPanelMask = self
end

function PANEL:CalculatePoly(w, h)
    local poly = {}

    local x = w/2
    local y = h/2 * self.scaler
    local radius = h/2

    table.insert(poly, { x = x, y = y })

    for i = 0, self.vertices do
    local a = math.rad((i / self.vertices) * -360) + self.rotation
    table.insert(poly, { x = x + math.sin(a) * radius, y = y + math.cos(a) * (radius * self.scaler) })
    end

    local a = math.rad(0)
    table.insert(poly, { x = x + math.sin(a) * radius, y = y + math.cos(a) * (radius * self.scaler) })
    self.data = poly
    -- PrintTable(self.data)
end

function PANEL:CalculateIconsPoly(w, h)
    local poly = {}

    local x = w/2
    local y = h/2 * self.scaler
    local radius = h/2

    table.insert(poly, { x = x, y = y })

    for i = 0, 17 do
    local a = math.rad((i / 17) * -360) + self.rotation
    table.insert(poly, { x = x + math.sin(a) * radius, y = y + math.cos(a) * (radius * self.scaler) })
    end

    local a = math.rad(0)
    table.insert(poly, { x = x + math.sin(a) * radius, y = y + math.cos(a) * (radius * self.scaler) })
    self.dataIcons = poly
    -- PrintTable(self.dataIcons)
end

function PANEL:PerformLayout(w, actualH)
    local h = self:GetTall()
    if (self.scaler < 1) then
        h = h * self.scaler
    end

    self.map:SetPos(0, h - actualH)
    self.map:SetSize(self:GetWide(), actualH)
    self.overlay:SetPos(0, h - actualH)
    self.overlay:SetSize(self:GetWide(), actualH)
    self:CalculatePoly(self:GetWide(), self:GetTall())
    self:CalculateIconsPoly(self:GetWide(), self:GetTall())
end

function PANEL:DrawPoly( w, h )
    if (!self.data) then
        self:CalculatePoly(w, h)
    end

    surface.DrawPoly(self.data)
end

function PANEL:FindNearestPos(x, y)

end

local render = render
local surface = surface
local whiteTexture = surface.GetTextureID("vgui/white")
function PANEL:Paint(w, h)

    -- print( self.map)

    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    draw.NoTexture()
    surface.SetDrawColor(color_white)
    self:DrawPoly(w, h)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    self.map:PaintManual()
    self.overlay:PaintManual()

    render.SetStencilEnable(false)
    render.ClearStencil()

    DisableClipping(true)
        surface.SetMaterial(circleOutline)
        surface.SetDrawColor(0, 0, 0)
        local x,y = 0,0
        if paris.HUDSettings["DrawOutline"] then
            local safezonex = (30*w)/255
            local safezoney = (30*h)/255
            surface.DrawTexturedRect((safezonex*-1), safezoney*-1, w+(safezonex*2), h+(safezoney*2))
        end
    DisableClipping(false)

    for k, v in pairs(Blips) do

        if !isvector(v.VectorOrEntity) and !IsValid(v.VectorOrEntity) then 
            Blips[k] = nil
            return 
        end

        local function DrawBlip()

            if IsValid(v.VectorOrEntity) and (v.VectorOrEntity:IsPlayer()) then
                v.FadeDist = paris.HUDSettings["PlayerFadeDistance"]
            end
            if v.VectorOrEntity == LocalPlayer() then
                v.FadeDist = nil
            end
            if not paris.HUDSettings["DrawOthers"] and isentity(v.VectorOrEntity) and (v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot())) then 
                if v.VectorOrEntity != LocalPlayer() then return end
            end

            if v.FadeDist then
                local dist = 0
                local OurVector = Vector(LocalPlayer():GetPos().x,LocalPlayer():GetPos().y,0)
                if isvector(v.VectorOrEntity) then
                    dist = math.Distance(OurVector.x, OurVector.y, v.VectorOrEntity.x, v.VectorOrEntity.y)
                elseif isentity(v.VectorOrEntity) then
                    dist = math.Distance(OurVector.x, OurVector.y, v.VectorOrEntity:GetPos().x, v.VectorOrEntity:GetPos().y)
                end
                v.LastDist = dist
                surface.SetDrawColor(v.col.r,v.col.g,v.col.b, (v.FadeDist - dist))
            else
                surface.SetDrawColor(v.col.r,v.col.g,v.col.b,v.col.a)
            end

            if (IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot())) and v.VectorOrEntity:GetNWInt("WantedLevel") != 0 and v.VectorOrEntity != LocalPlayer() then
                surface.SetDrawColor(240,0,0,v.col.a)
            end

            local RatX = v.x/ScrW()
            local RatY = v.y/ScrH()
            local x = (RatX*paris.HUDPanel:GetWide())
            local y = (RatY*paris.HUDPanel:GetTall())

            if x > paris.HUDPanel:GetWide() then
                x = paris.HUDPanel:GetWide()
            elseif x < 0 then
                x = 0
            end

            if y > paris.HUDPanel:GetTall() then
                y = paris.HUDPanel:GetTall()
            elseif y < (v.Scale)*-0.1 then
                y = (v.Scale)*-0.1
            end

            -- print(x,y)

            if (x < 100) and (y <= 100) then

                for i = 92, 182 do

                    if (x == 0) then
                        y = 100
                    else
                    
                        if (x >= self.data[i].x) and (x < self.data[i+1].x) and (y < self.data[i].y) then
                        -- if (x > self.data[i].x) and (y < self.data[i].y) then
                            x = self.data[i].x
                            y = self.data[i].y
                        end

                    end


                end

            elseif (x >= 100) and (y <= 100) then

                for i = 182, 272 do

                    if (x == paris.HUDPanel:GetWide()) then
                        y = 100
                    else

                        if (x >= self.data[i].x) and (x < self.data[i+1].x) and (y < self.data[i].y) then
                        -- if (x >= self.data[i].x) and (y >= self.data[i].y) and (y < self.data[i+1].y) then
                        -- if ( x < 200 and (x >= self.data[i].x) and (x < self.data[i+1].x)) or ((y >= self.data[i].y) and (y < self.data[i+1].y)) then
                            x = self.data[i].x
                            y = self.data[i].y
                        end

                    end

                end

            elseif (x >= 100) and (y >= 100) then

                for i = 272, 362 do

                    if (y == paris.HUDPanel:GetTall()) then
                        x = 100
                    else

                        if (x > self.data[i].x) and (y >= self.data[i].y) and (y < self.data[i+1].y) then
                            x = self.data[i].x
                            y = self.data[i].y
                        end

                    end

                end

            elseif (x < 100) and (y >= 100) then

                for i = 2, 92 do

                    if (y == paris.HUDPanel:GetTall()) then
                        x = 100
                    else

                        if (x < self.data[i].x) and (y > self.data[i].y) then
                            x = self.data[i].x
                            y = self.data[i].y
                        end

                    end

                end

            end

            -- print(x,y)

            -- if (y < 0) then
                -- if (x < 100) then

                    -- for i = 92, 362 do

                    --     if (x > self.data[i].x) and (x < self.data[i+1].x) and (y < self.data[i+1].y) then
                    --         x = self.data[i].x
                    --         y = self.data[i].y
                    --     end

                    -- end

                -- elseif (x >= 100) then

                --     for i = 182, 272 do

                --         if (x > self.data[i].x) and (x < self.data[i+1].x) then
                --             x = self.data[i].x
                --             y = self.data[i].y
                --         end



                --     end

                -- end
            -- elseif (y >= paris.HUDPanel:GetTall()) then

            --     for i = 92, 2, -1 do
            --         -- print(i)

            --         if (x > self.data[i].x) and (x < self.data[i+1].x) then
            --             x = self.data[i].x
            --             y = self.data[i].y
            --         end

            --     end

            -- end

            -- if (x < 0) or (x >= paris.HUDPanel:GetWide()) then
            --     if (y < 100) then

            --         for i = 182, 272 do

            --             if (y > self.data[i].y) and (y < self.data[i+1].y) then
            --                 y = self.data[i].y
            --                 -- y = self.data[i].y
            --             end

            --         end

            --     elseif (y >= 100) then

            --         for i = 92, 182 do

            --             if (y > self.data[i].y) and (y < self.data[i+1].y) then
            --                 y = self.data[i].y
            --                 -- y = self.data[i].y
            --             end

            --         end

            --     end
            -- end


            -- print(x,y)
            -- if y < 0 then
                -- if (x > 100) then

                --     -- if (y < 100) then

                --         for i = 182, #self.data - 1 do

                --             if (x > self.data[i].x) and (x < self.data[i+1].x) then
                --                 x = self.data[i].x
                --                 y = self.data[i].y
                --             end

                --         end

                --     elseif (y >= 100) then

                --         for i = 272, #self.data - 1 do

                --             if (x < self.data[i].x) and (x > self.data[i+1].x) then
                --                 x = self.data[i].x
                --                 y = self.data[i].y
                --             end

                --         end

                --     -- end

                -- end
            -- end

            -- print(x,y)

            -- local y = (RatY*(paris.HUDPanel:GetTall()))
            -- if y > paris.HUDPanel:GetTall() then
            --     y = paris.HUDPanel:GetTall()
            -- elseif y < (v.Scale)*-0.1 then
            --     y = (v.Scale)*-0.1
            -- end

            -- if (y > (v.Scale)*-0.1) then

            --     for i = 182, #self.data - 1 do
            --         -- print(i)
            --         if (y > self.data[i].y) and (y < self.data[i+1].y) then
            --             y = self.data[i].y
            --         end
            --     end

            -- end
    

            

            local Rot = 0

            if v.followang then
                if IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot()) then
                    if IsValid(v.VectorOrEntity:GetVehicle()) and v.VectorOrEntity != LocalPlayer() then
                        Rot = (LocalPlayer():EyeAngles().y*-1) + v.VectorOrEntity:GetVehicle():GetAngles().y + 90
                    elseif IsValid(v.VectorOrEntity:GetVehicle()) and v.VectorOrEntity == LocalPlayer() then
                        Rot = (LocalPlayer():EyeAngles().y*-1) + 90
                    elseif IsValid(LocalPlayer():GetVehicle()) then
                        Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
                    else
                        Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y
                    end
                elseif (IsValid(v.VectorOrEntity)) then
                    if IsValid(LocalPlayer():GetVehicle()) then
                        Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
                    else
                        Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y
                    end
                end
            end

            if v.Spinning then
                Rot = CurTime()*540
            end

            local doDraw = true
            local drawCount = false
            local count = 1
            if v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) and IsValid(v.VectorOrEntity:GetVehicle():GetParent()) then
                -- There vehicle is a seat DO NOT DRAW IT, the main draws it
                doDraw = false
            elseif v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) then
                -- First we check if the vehicle has seat children
                if LocalPlayer() == v.VectorOrEntity then
                    drawCount = false
                else
                    for _, child in pairs(v.VectorOrEntity:GetVehicle():GetChildren()) do
                        if IsValid(child) and child:IsVehicle() then
                            for _, ply in pairs(player.GetAll()) do
                                if ply:GetVehicle() == child then
                                    drawCount = true
                                    Rot = v.VectorOrEntity:GetAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
                                    count = count + 1
                                end
                            end
                        end
                    end
                end
            end
            -- the case if there is a car with no driver but passengers
            if v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) and IsValid(v.VectorOrEntity:GetVehicle():GetParent()) then
                local veh = v.VectorOrEntity:GetVehicle():GetParent()
                local driverValid = false
                for _, ply in pairs(player.GetAll()) do
                    if ply:GetVehicle() == veh then -- if theres a driver then we stop
                        driverValid = true
                    end
                end
                if !driverValid then
                    doDraw = true
                end
            end


            if doDraw then
                DisableClipping(true)
                    local color = surface.GetDrawColor()
                    surface.SetDrawColor(51, 255, 238, color.a)
                    surface.SetMaterial(halfcircle)

                    if IsValid(v.VectorOrEntity) and isentity(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and v.VectorOrEntity:GetFriendStatus() == "friend" and v.VectorOrEntity != LocalPlayer() then
                        surface.DrawTexturedRectRotated( x, y, v.Scale * 1.0, v.Scale * 1.0, 0 )
                    end

                    surface.SetDrawColor(color.r, color.g, color.b, color.a)
                    surface.SetMaterial(v.Mat)

                    surface.DrawTexturedRectRotated( x, y, v.Scale, v.Scale, Rot )
                    if drawCount then
                        draw.SimpleText(count, "DermaDefault", x, y - 1, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                DisableClipping(false)
            end
        end


        
        if IsValid(v.VectorOrEntity) and isentity(v.VectorOrEntity) and paris.HUDSettings["DrawOnlyIfSeen"] and v.VectorOrEntity != LocalPlayer() and !v.AlwaysThruWalls then
            local trace = {}
            trace.start = LocalPlayer():GetShootPos()
            trace.endpos = v.VectorOrEntity:GetPos() + Vector(0,0,10)
            if v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot()) then
                trace.endpos = v.VectorOrEntity:GetShootPos()
            end
            trace.filter = {LocalPlayer(), v.VectorOrEntity}
            if v.GetVehicle and IsValid(v:GetVehicle()) then 
                table.insert(trace.filter, v.VectorOrEntity:GetVehicle()) 
            end
            if IsValid(LocalPlayer():GetVehicle()) then 
                table.insert(trace.filter, LocalPlayer():GetVehicle()) 
            end
            local tr = util.TraceLine( trace )
            if (!tr.Hit) and (v.Zone=="*" or v.Zone==paris.Zone) then
                DrawBlip()
            end
        elseif (v.Zone=="*" or v.Zone==paris.Zone) then
            DrawBlip()
        end
        if !IsValid(v.VectorOrEntity) and !isvector(v.VectorOrEntity) then Blips[k] = nil end
    end

end

vgui.Register("GtaCircleMapMask", PANEL, "Panel")


PANEL = {}

function PANEL:Init()
    -- self:SetSize(paris.HUDSettings["HUDSizeX"],paris.HUDSettings["HUDSizeY"])
    -- self:SetPos(paris.HUDSettings["HUDPosX"],ScrH()-(paris.HUDPanel:GetTall()+paris.HUDSettings["HUDPosY"]))


    paris.HUDPanel = self

end

local lastresx, lastresy = ScrW(), ScrH()
local OutLine = Material("paris/hudoutlinehd.png")

function PANEL:Paint(w,h)

    -- surface.SetDrawColor( 20,20,20,200)
    -- surface.DrawRect(0,0,w,h)

    -- if paris.Maximized then
    --     paris.HUDPanel:SetSize(600,600)
    --     paris.HUDPanel:SetPos(paris.HUDSettings["HUDPosX"],ScrH()-(600+paris.HUDSettings["HUDPosY"]))
    -- else
    --     paris.HUDPanel:SetSize(paris.HUDSettings["HUDSizeX"],paris.HUDSettings["HUDSizeY"])
    --     paris.HUDPanel:SetPos(20,ScrH()-(paris.HUDPanel:GetTall()+60))
    -- end
    
    local x, y = self:LocalToScreen( 0, 0 )

    if paris.HUDSettings["DrawBackgroundBlur"] then

        local Fraction = 1.9 * (paris.HUDSettings["BackgroundBlurStrength"]/100)

        local matBlurScreen = Material( "pp/blurscreen" )
        surface.SetMaterial( matBlurScreen )
        surface.SetDrawColor( 255, 255, 255, 255 )

        for i=0.33, 1, 0.33 do
            matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
            matBlurScreen:Recompute()
            if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
            surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
        end
    end

    surface.SetDrawColor( 100, 100, 100, paris.HUDSettings["BackgroundOpacity"] )
    surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )

    -- if lastresx != ScrW() or lastresy != ScrH() then
    --     paris.HUDPanel:SetPos(paris.HUDSettings["HUDPosX"],ScrH()-(paris.HUDPanel:GetTall()+paris.HUDSettings["HUDPosY"]))
    -- end

    lastresx, lastresy = ScrW(), ScrH()

    -- DisableClipping(true)
    -- surface.SetMaterial(OutLine)
    -- surface.SetDrawColor(0, 0, 0, 200)
    -- local x,y = 0,0
    -- if paris.HUDSettings["DrawOutline"] then
    --     local safezonex = (25*w)/300
    --     local safezoney = (25*h)/200
    --     surface.DrawTexturedRect((safezonex*-1), safezoney*-1, w+(safezonex*2), h+(safezoney*2))
    -- end
    -- DisableClipping(false)

end

vgui.Register("GtaCircleMap", PANEL, "DPanel")


// LERP
    
    local CarLerpAng = 0
    local MainAngInfluence = 90
    local CamHeightLerp = 0
    local CamHeightInfluence = paris.HUDSettings["CamHeight"]
    local ForwardLerp = 100
    local ForwardLerpInfluence = 100
    local FOVLerp = 0
    local FOVLerpInfluence = 0
    local HudZoom = 1
    paris.HUDZoom = 1 -- This one is the influence
    local HealthAlphaLERP = 0
    local HealthAlphaLERPInfluence = 0

    -- 3d
    local lookang
    local campos
    local fov

    -- local mapmin,mapmax = game.GetWorld():GetModelBounds()
    -- local mapx = mapmax.x-mapmin.x
    -- local mapy = mapmax.y-mapmin.y

    hook.Add("PARIS_DamageTaken", "AddBloodStainToRadar", function(amount)
        HealthAlphaLERP = amount
    end)

    if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetVehicle()) then
        MainAngInfluence = paris.HUDSettings["CarLookAng"]
        CamHeightInfluence = paris.HUDSettings["CarCamHeight"]
        ForwardLerpInfluence = 400
    end

    function PlayerEnteredVehicle()
        MainAngInfluence = paris.HUDSettings["CarLookAng"]
        CamHeightInfluence = paris.HUDSettings["CarCamHeight"]
        ForwardLerpInfluence = 400
    end

    function PlayerLeaveVehicle()
        if !paris.HUDSettings["KeepTiltedCamera"] then
            MainAngInfluence = 90
        end
        CamHeightInfluence = paris.HUDSettings["CamHeight"]
        ForwardLerpInfluence = 100
    end

    net.Receive("PlayerEnteredVehicle", PlayerEnteredVehicle)
    net.Receive("PlayerLeaveVehicle", PlayerLeaveVehicle)

//

PANEL = {}

function PANEL:Init()

    paris.HUDBlipOverlay = self

    local mapmin,mapmax = game.GetWorld():GetModelBounds()
    self.mapx = mapmax.x-mapmin.x
    self.mapy = mapmax.y-mapmin.y

end

local halfcircle = Material("paris/blips/halfcircle.png")
local Lerp = Lerp

function PANEL:Paint()

    if !paris.HUDSettings["DrawHUD"] then return end
    if !IsValid(LocalPlayer()) then return end
    if (!LocalPlayer():GetCharacter()) then return end

    local ScreenWide = ScrW()
    
    -- 2d
    local scrw,scrh = ScrW(), ScrH()
    local w,h = paris.HUDPanelMask:GetSize()
    
    local x,y = paris.HUDPanelMask:GetPos()
    -- local x, y = 25,25

    -- surface.SetDrawColor( 20,20,20,200)
    -- surface.DrawRect(0,0,w,h)

    if IsValid(LocalPlayer()) then

        if IsValid(LocalPlayer():GetVehicle()) then
            MainAngInfluence = 28
            CamHeightInfluence = 3000
            ForwardLerpInfluence = 400
        elseif not IsValid(LocalPlayer():GetVehicle()) then
            MainAngInfluence = 90
            CamHeightInfluence = 5000
            ForwardLerpInfluence = 100
        end

        -- Soo much LERP :I

        CarLerpAng = Lerp( 4 * FrameTime() , CarLerpAng , MainAngInfluence)
        CamHeightLerp = Lerp( 4 * FrameTime() , CamHeightLerp , CamHeightInfluence)
        ForwardLerp = Lerp( 4 * FrameTime() , ForwardLerp , ForwardLerpInfluence)
        FOVLerp = Lerp( 4 * FrameTime() , FOVLerp , FOVLerpInfluence)
        HealthAlphaLERP = Lerp( 4 * FrameTime() , HealthAlphaLERP , HealthAlphaLERPInfluence)
        HudZoom = Lerp( 4 * FrameTime() , HudZoom , paris.HUDZoom)

        fov = math.Clamp(60+FOVLerp, 0, 140 )

        local MaximizeZoom = 1
        if paris.Maximized then
            MaximizeZoom = 3
        end


        --[[     CAMERA CONTROLLER     ]]--

        local plypos = LocalPlayer():GetPos()
        local plyang = LocalPlayer():EyeAngles()
        local plyeyeang = LocalPlayer():EyeAngles()

        local OfficialLookAng = Angle(0,0,0)
        local CamPos = Vector(0,0,0)

        if LocalPlayer():InVehicle() then

            if LocalPlayer():InVehicle() then
                plyang = plyang + LocalPlayer():GetAngles() + Angle(0,-90,0)
                FOVLerpInfluence = (LocalPlayer():GetVehicle():GetVelocity():Length()/120)
            else
                FOVLerpInfluence = math.abs(LocalPlayer():GetVelocity():Length()/60)
            end

            CamPos = (Vector(plypos.x,plypos.y,CamHeightLerp*HudZoom*MaximizeZoom)-(Angle(0,plyang.y,0):Forward()*ForwardLerp*HudZoom*MaximizeZoom*11))
        else
            FOVLerpInfluence = math.abs(LocalPlayer():GetVelocity():Length()/60)
            CamPos = ((Vector(plypos.x,plypos.y,CamHeightLerp*HudZoom*MaximizeZoom))+(Angle(0,plyang.y,0):Forward()*ForwardLerp*HudZoom*8))
        end

        OfficialLookAng = Angle(CarLerpAng,plyang.y,0) 

        lookang = OfficialLookAng

        campos = CamPos

    end

    cam.Start({
        x = x,
        y = y,
        w = w,
        h = h,
        type = "3D",
        origin = campos,
        angles = lookang,
        fov = fov,
        aspect = (w/h),
        subrect = true, -- Maybe idk
        zfar = 1000000,
    })

        for k, v in pairs(Blips or {}) do
            local initial = Vector(0,0,0)
            if isvector(v.VectorOrEntity) then
                initial = v.VectorOrEntity
            elseif isentity(v.VectorOrEntity) and IsValid(v.VectorOrEntity) then
                initial = v.VectorOrEntity:GetPos()
            end
            initial.z = 0 -- We don't want z value :P
            local Pos = LocalToWorld(initial, Angle(), Vector(0,0,0), Angle(0,0,0))
            local Output = Pos:ToScreen()
            if k == "LocalPlayer" then
                Blips[k].x = ScreenWide/2
            else
                Blips[k].x = Lerp( 120 * FrameTime() , Blips[k].x , Output.x)
            end
            Blips[k].y = Lerp( 120 * FrameTime() , Blips[k].y , Output.y)
        end

        if paris.Mat then
            render.SetMaterial(paris.Mat)
        end

        if not paris.Translate then
            paris.Translate = Vector(0,0,0)
        end


        render.DrawQuadEasy(Vector(0,0,0) + paris.Translate, Vector(0,0,1), self.mapx*(paris.Scale or 1)*(paris.ScaleX or 0), self.mapy*(paris.Scale or 1)*(paris.ScaleY or 0), paris.HUDColor, 90)

    cam.End3D()

    -- s:SetPos(paris.HUDPanelMask:GetPos())
    -- s:SetSize(paris.HUDPanelMask:GetWide(),paris.HUDPanelMask:GetTall())

    //////////////

    -- for k, v in pairs(Blips) do

    --     if !isvector(v.VectorOrEntity) and !IsValid(v.VectorOrEntity) then 
    --         Blips[k] = nil
    --         return 
    --     end

    --     local function DrawBlip()

    --         if IsValid(v.VectorOrEntity) and (v.VectorOrEntity:IsPlayer()) then
    --             v.FadeDist = paris.HUDSettings["PlayerFadeDistance"]
    --         end
    --         if v.VectorOrEntity == LocalPlayer() then
    --             v.FadeDist = nil
    --         end
    --         if not paris.HUDSettings["DrawOthers"] and isentity(v.VectorOrEntity) and (v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot())) then 
    --             if v.VectorOrEntity != LocalPlayer() then return end
    --         end

    --         if v.FadeDist then
    --             local dist = 0
    --             local OurVector = Vector(LocalPlayer():GetPos().x,LocalPlayer():GetPos().y,0)
    --             if isvector(v.VectorOrEntity) then
    --                 dist = math.Distance(OurVector.x, OurVector.y, v.VectorOrEntity.x, v.VectorOrEntity.y)
    --             elseif isentity(v.VectorOrEntity) then
    --                 dist = math.Distance(OurVector.x, OurVector.y, v.VectorOrEntity:GetPos().x, v.VectorOrEntity:GetPos().y)
    --             end
    --             v.LastDist = dist
    --             surface.SetDrawColor(v.col.r,v.col.g,v.col.b, (v.FadeDist - dist))
    --         else
    --             surface.SetDrawColor(v.col.r,v.col.g,v.col.b,v.col.a)
    --         end

    --         if (IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot())) and v.VectorOrEntity:GetNWInt("WantedLevel") != 0 and v.VectorOrEntity != LocalPlayer() then
    --             surface.SetDrawColor(240,0,0,v.col.a)
    --         end

    --         local RatX = v.x/ScrW()
    --         local RatY = v.y/ScrH()
    --         local x = (RatX*paris.HUDPanel:GetWide())
    --         if x > paris.HUDPanel:GetWide() then
    --             x = paris.HUDPanel:GetWide()
    --         elseif x < 0 then
    --             x = 0
    --         end
    --         local y = (RatY*(paris.HUDPanel:GetTall()))
    --         if y > paris.HUDPanel:GetTall() then
    --             y = paris.HUDPanel:GetTall()
    --         elseif y < (v.Scale)*-0.1 then
    --             y = (v.Scale)*-0.1
    --         end

    --         local Rot = 0

    --         if v.followang then
    --             if IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot()) then
    --                 if IsValid(v.VectorOrEntity:GetVehicle()) and v.VectorOrEntity != LocalPlayer() then
    --                     Rot = (LocalPlayer():EyeAngles().y*-1) + v.VectorOrEntity:GetVehicle():GetAngles().y + 90
    --                 elseif IsValid(v.VectorOrEntity:GetVehicle()) and v.VectorOrEntity == LocalPlayer() then
    --                     Rot = (LocalPlayer():EyeAngles().y*-1) + 90
    --                 elseif IsValid(LocalPlayer():GetVehicle()) then
    --                     Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
    --                 else
    --                     Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y
    --                 end
    --             elseif (IsValid(v.VectorOrEntity)) then
    --                 if IsValid(LocalPlayer():GetVehicle()) then
    --                     Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
    --                 else
    --                     Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y
    --                 end
    --             end
    --         end

    --         if v.Spinning then
    --             Rot = CurTime()*540
    --         end

    --         local doDraw = true
    --         local drawCount = false
    --         local count = 1
    --         if v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) and IsValid(v.VectorOrEntity:GetVehicle():GetParent()) then
    --             -- There vehicle is a seat DO NOT DRAW IT, the main draws it
    --             doDraw = false
    --         elseif v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) then
    --             -- First we check if the vehicle has seat children
    --             if LocalPlayer() == v.VectorOrEntity then
    --                 drawCount = false
    --             else
    --                 for _, child in pairs(v.VectorOrEntity:GetVehicle():GetChildren()) do
    --                     if IsValid(child) and child:IsVehicle() then
    --                         for _, ply in pairs(player.GetAll()) do
    --                             if ply:GetVehicle() == child then
    --                                 drawCount = true
    --                                 Rot = v.VectorOrEntity:GetAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
    --                                 count = count + 1
    --                             end
    --                         end
    --                     end
    --                 end
    --             end
    --         end
    --         -- the case if there is a car with no driver but passengers
    --         if v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) and IsValid(v.VectorOrEntity:GetVehicle():GetParent()) then
    --             local veh = v.VectorOrEntity:GetVehicle():GetParent()
    --             local driverValid = false
    --             for _, ply in pairs(player.GetAll()) do
    --                 if ply:GetVehicle() == veh then -- if theres a driver then we stop
    --                     driverValid = true
    --                 end
    --             end
    --             if !driverValid then
    --                 doDraw = true
    --             end
    --         end


    --         if doDraw then
    --             DisableClipping(true)
    --                 local color = surface.GetDrawColor()
    --                 surface.SetDrawColor(51, 255, 238, color.a)
    --                 surface.SetMaterial(halfcircle)

    --                 if IsValid(v.VectorOrEntity) and isentity(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and v.VectorOrEntity:GetFriendStatus() == "friend" and v.VectorOrEntity != LocalPlayer() then
    --                     surface.DrawTexturedRectRotated( x, y, v.Scale * 1.0, v.Scale * 1.0, 0 )
    --                 end

    --                 surface.SetDrawColor(color.r, color.g, color.b, color.a)
    --                 surface.SetMaterial(v.Mat)

    --                 surface.DrawTexturedRectRotated( x, y, v.Scale, v.Scale, Rot )
    --                 if drawCount then
    --                     draw.SimpleText(count, "DermaDefault", x, y - 1, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    --                 end
    --             DisableClipping(false)
    --         end
    --     end


        
    --     if IsValid(v.VectorOrEntity) and isentity(v.VectorOrEntity) and paris.HUDSettings["DrawOnlyIfSeen"] and v.VectorOrEntity != LocalPlayer() and !v.AlwaysThruWalls then
    --         local trace = {}
    --         trace.start = LocalPlayer():GetShootPos()
    --         trace.endpos = v.VectorOrEntity:GetPos() + Vector(0,0,10)
    --         if v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot()) then
    --             trace.endpos = v.VectorOrEntity:GetShootPos()
    --         end
    --         trace.filter = {LocalPlayer(), v.VectorOrEntity}
    --         if v.GetVehicle and IsValid(v:GetVehicle()) then 
    --             table.insert(trace.filter, v.VectorOrEntity:GetVehicle()) 
    --         end
    --         if IsValid(LocalPlayer():GetVehicle()) then 
    --             table.insert(trace.filter, LocalPlayer():GetVehicle()) 
    --         end
    --         local tr = util.TraceLine( trace )
    --         if (!tr.Hit) and (v.Zone=="*" or v.Zone==paris.Zone) then
    --             DrawBlip()
    --         end
    --     elseif (v.Zone=="*" or v.Zone==paris.Zone) then
    --         DrawBlip()
    --     end
    --     if !IsValid(v.VectorOrEntity) and !isvector(v.VectorOrEntity) then Blips[k] = nil end
    -- end

end

vgui.Register("GtaCircleMapOverlay", PANEL, "DPanel")

function paris:LoadHUD()
    paris:HUDPrintMessage("Loading the GTA HUD Module...")
    
    if IsValid(paris.HUDPanelMask) then paris.HUDPanelMask:Remove() end
    if IsValid(paris.HUDPanel) then paris.HUDPanel:Remove() end
    -- paris.HUDPanel = vgui.Create("DPanel")

   local MapPnl = vgui.Create("GtaCircleMapMask")
   -- MapPnl:SetSize(100,100)
   -- MapPnl:SetSize(paris.HUDSettings["HUDSizeX"],paris.HUDSettings["HUDSizeY"])
   -- MapPnl:SetPos(100,500)
   -- MapPnl:SetPos(paris.HUDSettings["HUDPosX"] - 20,ScrH()-(MapPnl:GetTall()+paris.HUDSettings["HUDPosY"]) - 30)
   

   MapPnl:InvalidateLayout()

    hook.Add("Think", "GTAHudPanelHider", function()
        if IsValid(paris.HUDPanel) then
            if (!LocalPlayer():GetCharacter()) then
                paris.HUDPanel:Hide()
            elseif !paris.HUDSettings["DrawHUD"] then 
                paris.HUDPanel:Hide()
            else
                paris.HUDPanel:Show()
            end
        end
    end)
    -- paris.HUDPanel:SetSize(paris.HUDSettings["HUDSizeX"],paris.HUDSettings["HUDSizeY"])
    -- paris.HUDPanel:SetPos(paris.HUDSettings["HUDPosX"],ScrH()-(paris.HUDPanel:GetTall()+paris.HUDSettings["HUDPosY"]))
    -- local lastresx, lastresy = ScrW(), ScrH()
    -- local OutLine = Material("paris/hudoutlinehd.png")
    -- paris.HUDColor = (paris.HUDSettings["SetHUDColor"])
    -- function paris.HUDPanel:Paint()

    --     if paris.Maximized then
    --         paris.HUDPanel:SetSize(600,600)
    --         paris.HUDPanel:SetPos(paris.HUDSettings["HUDPosX"],ScrH()-(600+paris.HUDSettings["HUDPosY"]))
    --     else
    --         paris.HUDPanel:SetSize(paris.HUDSettings["HUDSizeX"],paris.HUDSettings["HUDSizeY"])
    --         paris.HUDPanel:SetPos(20,ScrH()-(paris.HUDPanel:GetTall()+60))
    --     end
        
    --     local x, y = self:LocalToScreen( 0, 0 )

    --     if paris.HUDSettings["DrawBackgroundBlur"] then

    --         local Fraction = 1.9 * (paris.HUDSettings["BackgroundBlurStrength"]/100)

    --         local matBlurScreen = Material( "pp/blurscreen" )
    --         surface.SetMaterial( matBlurScreen )
    --         surface.SetDrawColor( 255, 255, 255, 255 )

    --         for i=0.33, 1, 0.33 do
    --             matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
    --             matBlurScreen:Recompute()
    --             if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
    --             surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
    --         end
    --     end

    --     surface.SetDrawColor( 100, 100, 100, paris.HUDSettings["BackgroundOpacity"] )
    --     surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )

    --     if lastresx != ScrW() or lastresy != ScrH() then
    --         paris.HUDPanel:SetPos(paris.HUDSettings["HUDPosX"],ScrH()-(paris.HUDPanel:GetTall()+paris.HUDSettings["HUDPosY"]))
    --     end

    --     lastresx, lastresy = ScrW(), ScrH()

    --     DisableClipping(true)
    --     surface.SetMaterial(OutLine)
    --     surface.SetDrawColor(0, 0, 0, 200)
    --     local x,y = 0,0
    --     if paris.HUDSettings["DrawOutline"] then
    --         local safezonex = (25*paris.HUDPanel:GetWide())/300
    --         local safezoney = (25*paris.HUDPanel:GetTall())/200
    --         surface.DrawTexturedRect((safezonex*-1), safezoney*-1, paris.HUDPanel:GetWide()+(safezonex*2), paris.HUDPanel:GetTall()+(safezoney*2))
    --     end
    --     DisableClipping(false)

    -- end




    --[[                 LERP System                 ]]
    -- This interpolates when you enter/exit vehicles

    -- local CarLerpAng = 0
    -- local MainAngInfluence = 90
    -- local CamHeightLerp = 0
    -- local CamHeightInfluence = paris.HUDSettings["CamHeight"]
    -- local ForwardLerp = 100
    -- local ForwardLerpInfluence = 100
    -- local FOVLerp = 0
    -- local FOVLerpInfluence = 0
    -- local HudZoom = 1
    -- paris.HUDZoom = 1 -- This one is the influence
    -- local HealthAlphaLERP = 0
    -- local HealthAlphaLERPInfluence = 0

    -- -- 3d
    -- local lookang
    -- local campos
    -- local fov

    -- local mapmin,mapmax = game.GetWorld():GetModelBounds()
    -- local mapx = mapmax.x-mapmin.x
    -- local mapy = mapmax.y-mapmin.y

    -- hook.Add("PARIS_DamageTaken", "AddBloodStainToRadar", function(amount)
    --     HealthAlphaLERP = amount
    -- end)

    -- if IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetVehicle()) then
    --     MainAngInfluence = paris.HUDSettings["CarLookAng"]
    --     CamHeightInfluence = paris.HUDSettings["CarCamHeight"]
    --     ForwardLerpInfluence = 400
    -- end

    -- function PlayerEnteredVehicle()
    --     MainAngInfluence = paris.HUDSettings["CarLookAng"]
    --     CamHeightInfluence = paris.HUDSettings["CarCamHeight"]
    --     ForwardLerpInfluence = 400
    -- end

    -- function PlayerLeaveVehicle()
    --     if !paris.HUDSettings["KeepTiltedCamera"] then
    --         MainAngInfluence = 90
    --     end
    --     CamHeightInfluence = paris.HUDSettings["CamHeight"]
    --     ForwardLerpInfluence = 100
    -- end

    -- net.Receive("PlayerEnteredVehicle", PlayerEnteredVehicle)
    -- net.Receive("PlayerLeaveVehicle", PlayerLeaveVehicle)

    --[[                LOWER HUD                ]]
    --            The Health/Ammo Boxes

    -- local PointA = 100
    -- local PointB = 100
    -- local TimeSince = CurTime()
    -- hook.Add("PARIS_DamageTaken", "AddBloodStainToHealth", function(taken, healthbefore)
    --     PointA = healthbefore - taken
    --     PointB = healthbefore
    --     TimeSince = CurTime()
    -- end)


    -- paris.HUDPanelOverlay = vgui.Create("DPanel", paris.HUDPanel)
    -- paris.HUDPanelOverlay:SetSize(paris.HUDPanel:GetWide(),paris.HUDPanel:GetTall())
    -- paris.HUDPanelOverlay:SetPos(0,0)
    -- paris.HUDPanelOverlay.GradientRight = Material( "paris/gradient_right.png" )
    -- local BloodSplash = Material("paris/bloodinside.png")
    -- local BottomColor = Color(5,5,5,220)
    -- local HealthBackground = Color(47, 81, 51,255)
    -- local HealthColor = Color(85, 153, 79,255)
    -- local HealthLowBackground = Color(95, 9, 13,255)
    -- local ArmorBackground = Color(17, 53, 75,255)
    -- local ArmorColor = Color(109, 191, 227,255)
    -- local StaminaBackground = Color(185, 153, 70,50)
    -- local StaminaColor = Color(185, 153, 70,255)
    -- function paris.HUDPanelOverlay:Paint()

    --     self:SetSize(paris.HUDPanel:GetWide(),paris.HUDPanel:GetTall())
    --     // Bottom shit
    --     draw.RoundedBox(0, 0, self:GetTall()-23, self:GetWide(), 23, BottomColor)

    --     if IsValid(LocalPlayer()) then

    --         local health = math.Clamp(LocalPlayer():Health(), 0, 100)
    --         if health > 30 then
    --             draw.RoundedBox(0, 0, self:GetTall()-18, (self:GetWide()/2)-2, 10, HealthBackground)
    --             draw.RoundedBox(0, 0, self:GetTall()-18, ((self:GetWide()/2)-2) * (health/100), 10, HealthColor)
    --         else
    --             draw.RoundedBox(0, 0, self:GetTall()-18, (self:GetWide()/2)-2, 10, HealthLowBackground)
    --             draw.RoundedBox(0, 0, self:GetTall()-18, ((self:GetWide()/2)-2) * (health/100), 10, Color(165, 33, 44,255*math.abs(math.sin(CurTime()*5))))
    --         end

    --         surface.SetMaterial(paris.HUDPanelOverlay.GradientRight)
    --         surface.SetDrawColor(150, 20, 20, 255-((CurTime()-TimeSince)*255))
    --         surface.DrawTexturedRect(((self:GetWide()/2)-2) * (health/100), self:GetTall()-18, PointA-PointB, 10)

    --         surface.SetMaterial(BloodSplash)
    --         local HealthAlpha = (HealthAlphaLERP*-1)
    --         if HealthAlpha > 10 then
    --             HealthAlpha = 10
    --         end
    --         surface.SetDrawColor(255, 50, 50, (HealthAlpha*40))
    --         surface.DrawTexturedRect( 0, 0, self:GetWide(),self:GetTall() - 18 )

    --         local armor = math.Clamp(LocalPlayer():Armor(), 0, 100)
    --         draw.RoundedBox(0, (self:GetWide()/2)+2, self:GetTall()-18, (self:GetWide()/2)-2, 10, ArmorBackground)
    --         draw.RoundedBox(0, (self:GetWide()/2)+2, self:GetTall()-18, ((self:GetWide()/2)-2) * (armor/100), 10, ArmorColor)

    --         // Add Stamina-Support here
    --         local stamina = 0
    --         local supported = false
    --         if LocalPlayer().Stamina then // PERP Stamina
    --             stamina = math.Clamp(LocalPlayer().Stamina, 0, 100)
    --             supported = true
    --         end
    --         if LocalPlayer().BurgerStamina then // Burger Stamina
    --             stamina = math.Clamp(LocalPlayer().BurgerStamina, 0, 100)
    --             supported = true
    --         end
    --         if LocalPlayer():GetNWInt( "tcb_Stamina", false ) then // The Coding Beast Stamina
    --             stamina = math.Clamp(LocalPlayer():GetNWInt( "tcb_Stamina" ), 0, 100)
    --             supported = true
    --         end


    --         if supported and paris.HUDSettings["DrawStamina"] then
    --             draw.RoundedBox(0, 2, self:GetTall()-5, (self:GetWide())-4, 3, StaminaBackground)
    --             draw.RoundedBox(0, 2, self:GetTall()-5, ((self:GetWide())-4) * (stamina/100), 3, StaminaColor)
    --         end

    --     end
    -- end



    --[[                BLIPS                ]]
    --       The entire system for blips

    -- if IsValid(paris.HUDPanel) then

    --     if IsValid(paris.HUDBlipOverlay) then paris.HUDBlipOverlay:Remove() end
    --     paris.HUDBlipOverlay = vgui.Create("DPanel")
    --     paris.HUDBlipOverlay:SetSize(paris.HUDPanel:GetWide(),paris.HUDPanel:GetTall())
    --     paris.HUDBlipOverlay:SetPos(0,0)


    --     local halfcircle = Material("paris/blips/halfcircle.png")
    --     local Lerp = Lerp

        -- function paris.HUDBlipOverlay:Paint()

        --     if !paris.HUDSettings["DrawHUD"] then return end
        --     if !IsValid(LocalPlayer()) then return end
        --     if (!LocalPlayer():GetCharacter()) then return end

        --     local ScreenWide = ScrW()
            
        --     -- 2d
        --     local scrw,scrh = ScrW(), ScrH()
        --     local w,h = paris.HUDPanelMask:GetSize()
            
        --     local x,y = paris.HUDPanelMask:GetPos()

        
        --     if IsValid(LocalPlayer()) then
        
        --         if IsValid(LocalPlayer():GetVehicle()) then
        --             MainAngInfluence = 28
        --             CamHeightInfluence = 3000
        --             ForwardLerpInfluence = 400
        --         elseif not IsValid(LocalPlayer():GetVehicle()) then
        --             MainAngInfluence = 90
        --             CamHeightInfluence = 5000
        --             ForwardLerpInfluence = 100
        --         end
        
        --         -- Soo much LERP :I
        
        --         CarLerpAng = Lerp( 4 * FrameTime() , CarLerpAng , MainAngInfluence)
        --         CamHeightLerp = Lerp( 4 * FrameTime() , CamHeightLerp , CamHeightInfluence)
        --         ForwardLerp = Lerp( 4 * FrameTime() , ForwardLerp , ForwardLerpInfluence)
        --         FOVLerp = Lerp( 4 * FrameTime() , FOVLerp , FOVLerpInfluence)
        --         HealthAlphaLERP = Lerp( 4 * FrameTime() , HealthAlphaLERP , HealthAlphaLERPInfluence)
        --         HudZoom = Lerp( 4 * FrameTime() , HudZoom , paris.HUDZoom)
        
        --         fov = math.Clamp(60+FOVLerp, 0, 140 )
        
        --         local MaximizeZoom = 1
        --         if paris.Maximized then
        --             MaximizeZoom = 3
        --         end
        
        
        --         --[[     CAMERA CONTROLLER     ]]--
        
        --         local plypos = LocalPlayer():GetPos()
        --         local plyang = LocalPlayer():EyeAngles()
        --         local plyeyeang = LocalPlayer():EyeAngles()
        
        --         local OfficialLookAng = Angle(0,0,0)
        --         local CamPos = Vector(0,0,0)
        
        --         if LocalPlayer():InVehicle() then
        
        --             if LocalPlayer():InVehicle() then
        --                 plyang = plyang + LocalPlayer():GetAngles() + Angle(0,-90,0)
        --                 FOVLerpInfluence = (LocalPlayer():GetVehicle():GetVelocity():Length()/120)
        --             else
        --                 FOVLerpInfluence = math.abs(LocalPlayer():GetVelocity():Length()/60)
        --             end
        
        --             CamPos = (Vector(plypos.x,plypos.y,CamHeightLerp*HudZoom*MaximizeZoom)-(Angle(0,plyang.y,0):Forward()*ForwardLerp*HudZoom*MaximizeZoom*11))
        --         else
        --             FOVLerpInfluence = math.abs(LocalPlayer():GetVelocity():Length()/60)
        --             CamPos = ((Vector(plypos.x,plypos.y,CamHeightLerp*HudZoom*MaximizeZoom))+(Angle(0,plyang.y,0):Forward()*ForwardLerp*HudZoom*8))
        --         end
        
        --         OfficialLookAng = Angle(CarLerpAng,plyang.y,0) 
        
        --         lookang = OfficialLookAng
        
        --         campos = CamPos
        
        --     end
        
        --     cam.Start({
        --         x = x,
        --         y = y,
        --         w = w,
        --         h = h,
        --         type = "3D",
        --         origin = campos,
        --         angles = lookang,
        --         fov = fov,
        --         aspect = (w/h),
        --         subrect = true, -- Maybe idk
        --         zfar = 1000000,
        --     })
        
        --         for k, v in pairs(Blips or {}) do
        --             local initial = Vector(0,0,0)
        --             if isvector(v.VectorOrEntity) then
        --                 initial = v.VectorOrEntity
        --             elseif isentity(v.VectorOrEntity) and IsValid(v.VectorOrEntity) then
        --                 initial = v.VectorOrEntity:GetPos()
        --             end
        --             initial.z = 0 -- We don't want z value :P
        --             local Pos = LocalToWorld(initial, Angle(), Vector(0,0,0), Angle(0,0,0))
        --             local Output = Pos:ToScreen()
        --             if k == "LocalPlayer" then
        --                 Blips[k].x = ScreenWide/2
        --             else
        --                 Blips[k].x = Lerp( 120 * FrameTime() , Blips[k].x , Output.x)
        --             end
        --             Blips[k].y = Lerp( 120 * FrameTime() , Blips[k].y , Output.y)
        --         end
        
        --         if paris.Mat then
        --             render.SetMaterial(paris.Mat)
        --         end

        --         if not paris.Translate then
        --             paris.Translate = Vector(0,0,0)
        --         end


        --         render.DrawQuadEasy(Vector(0,0,0) + paris.Translate, Vector(0,0,1), mapx*(paris.Scale or 1)*(paris.ScaleX or 0), mapy*(paris.Scale or 1)*(paris.ScaleY or 0), paris.HUDColor, 90)
        
        --     cam.End3D()

        --     paris.HUDBlipOverlay:SetPos(paris.HUDPanelMask:GetPos())
        --     paris.HUDBlipOverlay:SetSize(paris.HUDPanelMask:GetWide(),paris.HUDPanelMask:GetTall())

        --     //////////////

        --     for k, v in pairs(Blips) do

        --         if !isvector(v.VectorOrEntity) and !IsValid(v.VectorOrEntity) then 
        --             Blips[k] = nil
        --             return 
        --         end

        --         local function DrawBlip()

        --             if IsValid(v.VectorOrEntity) and (v.VectorOrEntity:IsPlayer()) then
        --                 v.FadeDist = paris.HUDSettings["PlayerFadeDistance"]
        --             end
        --             if v.VectorOrEntity == LocalPlayer() then
        --                 v.FadeDist = nil
        --             end
        --             if not paris.HUDSettings["DrawOthers"] and isentity(v.VectorOrEntity) and (v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot())) then 
        --                 if v.VectorOrEntity != LocalPlayer() then return end
        --             end

        --             if v.FadeDist then
        --                 local dist = 0
        --                 local OurVector = Vector(LocalPlayer():GetPos().x,LocalPlayer():GetPos().y,0)
        --                 if isvector(v.VectorOrEntity) then
        --                     dist = math.Distance(OurVector.x, OurVector.y, v.VectorOrEntity.x, v.VectorOrEntity.y)
        --                 elseif isentity(v.VectorOrEntity) then
        --                     dist = math.Distance(OurVector.x, OurVector.y, v.VectorOrEntity:GetPos().x, v.VectorOrEntity:GetPos().y)
        --                 end
        --                 v.LastDist = dist
        --                 surface.SetDrawColor(v.col.r,v.col.g,v.col.b, (v.FadeDist - dist))
        --             else
        --                 surface.SetDrawColor(v.col.r,v.col.g,v.col.b,v.col.a)
        --             end

        --             if (IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot())) and v.VectorOrEntity:GetNWInt("WantedLevel") != 0 and v.VectorOrEntity != LocalPlayer() then
        --                 surface.SetDrawColor(240,0,0,v.col.a)
        --             end

        --             local RatX = v.x/ScrW()
        --             local RatY = v.y/ScrH()
        --             local x = (RatX*paris.HUDPanel:GetWide())
        --             if x > paris.HUDPanel:GetWide() then
        --                 x = paris.HUDPanel:GetWide()
        --             elseif x < 0 then
        --                 x = 0
        --             end
        --             local y = (RatY*(paris.HUDPanel:GetTall()))
        --             if y > paris.HUDPanel:GetTall() then
        --                 y = paris.HUDPanel:GetTall()
        --             elseif y < (v.Scale)*-0.1 then
        --                 y = (v.Scale)*-0.1
        --             end
        
        --             local Rot = 0
        
        --             if v.followang then
        --                 if IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot()) then
        --                     if IsValid(v.VectorOrEntity:GetVehicle()) and v.VectorOrEntity != LocalPlayer() then
        --                         Rot = (LocalPlayer():EyeAngles().y*-1) + v.VectorOrEntity:GetVehicle():GetAngles().y + 90
        --                     elseif IsValid(v.VectorOrEntity:GetVehicle()) and v.VectorOrEntity == LocalPlayer() then
        --                         Rot = (LocalPlayer():EyeAngles().y*-1) + 90
        --                     elseif IsValid(LocalPlayer():GetVehicle()) then
        --                         Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
        --                     else
        --                         Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y
        --                     end
        --                 elseif (IsValid(v.VectorOrEntity)) then
        --                     if IsValid(LocalPlayer():GetVehicle()) then
        --                         Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
        --                     else
        --                         Rot = v.VectorOrEntity:EyeAngles().y - LocalPlayer():EyeAngles().y
        --                     end
        --                 end
        --             end

        --             if v.Spinning then
        --                 Rot = CurTime()*540
        --             end

        --             local doDraw = true
        --             local drawCount = false
        --             local count = 1
        --             if v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) and IsValid(v.VectorOrEntity:GetVehicle():GetParent()) then
        --                 -- There vehicle is a seat DO NOT DRAW IT, the main draws it
        --                 doDraw = false
        --             elseif v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) then
        --                 -- First we check if the vehicle has seat children
        --                 if LocalPlayer() == v.VectorOrEntity then
        --                     drawCount = false
        --                 else
        --                     for _, child in pairs(v.VectorOrEntity:GetVehicle():GetChildren()) do
        --                         if IsValid(child) and child:IsVehicle() then
        --                             for _, ply in pairs(player.GetAll()) do
        --                                 if ply:GetVehicle() == child then
        --                                     drawCount = true
        --                                     Rot = v.VectorOrEntity:GetAngles().y - LocalPlayer():EyeAngles().y - LocalPlayer():GetVehicle():GetAngles().y
        --                                     count = count + 1
        --                                 end
        --                             end
        --                         end
        --                     end
        --                 end
        --             end
        --             -- the case if there is a car with no driver but passengers
        --             if v.followang and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and IsValid(v.VectorOrEntity:GetVehicle()) and IsValid(v.VectorOrEntity:GetVehicle():GetParent()) then
        --                 local veh = v.VectorOrEntity:GetVehicle():GetParent()
        --                 local driverValid = false
        --                 for _, ply in pairs(player.GetAll()) do
        --                     if ply:GetVehicle() == veh then -- if theres a driver then we stop
        --                         driverValid = true
        --                     end
        --                 end
        --                 if !driverValid then
        --                     doDraw = true
        --                 end
        --             end


        --             if doDraw then
        --                 DisableClipping(true)
        --                     local color = surface.GetDrawColor()
        --                     surface.SetDrawColor(51, 255, 238, color.a)
        --                     surface.SetMaterial(halfcircle)

        --                     if IsValid(v.VectorOrEntity) and isentity(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer() and v.VectorOrEntity:GetFriendStatus() == "friend" and v.VectorOrEntity != LocalPlayer() then
        --                         surface.DrawTexturedRectRotated( x, y, v.Scale * 1.0, v.Scale * 1.0, 0 )
        --                     end

        --                     surface.SetDrawColor(color.r, color.g, color.b, color.a)
        --                     surface.SetMaterial(v.Mat)

        --                     surface.DrawTexturedRectRotated( x, y, v.Scale, v.Scale, Rot )
        --                     if drawCount then
        --                         draw.SimpleText(count, "DermaDefault", x, y - 1, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        --                     end
        --                 DisableClipping(false)
        --             end
        --         end


                
        --         if IsValid(v.VectorOrEntity) and isentity(v.VectorOrEntity) and paris.HUDSettings["DrawOnlyIfSeen"] and v.VectorOrEntity != LocalPlayer() and !v.AlwaysThruWalls then
        --             local trace = {}
        --             trace.start = LocalPlayer():GetShootPos()
        --             trace.endpos = v.VectorOrEntity:GetPos() + Vector(0,0,10)
        --             if v.VectorOrEntity:IsPlayer() or (v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot()) then
        --                 trace.endpos = v.VectorOrEntity:GetShootPos()
        --             end
        --             trace.filter = {LocalPlayer(), v.VectorOrEntity}
        --             if v.GetVehicle and IsValid(v:GetVehicle()) then 
        --                 table.insert(trace.filter, v.VectorOrEntity:GetVehicle()) 
        --             end
        --             if IsValid(LocalPlayer():GetVehicle()) then 
        --                 table.insert(trace.filter, LocalPlayer():GetVehicle()) 
        --             end
        --             local tr = util.TraceLine( trace )
        --             if (!tr.Hit) and (v.Zone=="*" or v.Zone==paris.Zone) then
        --                 DrawBlip()
        --             end
        --         elseif (v.Zone=="*" or v.Zone==paris.Zone) then
        --             DrawBlip()
        --         end
        --         if !IsValid(v.VectorOrEntity) and !isvector(v.VectorOrEntity) then Blips[k] = nil end
        --     end

        -- end

    -- end


    function AddMapBlip(Mat,VectorOrEntity,ID,Scale,col,FadeDist,Zone,followang,AlwaysThruWalls,Spinning,MapConfigBlip)
        local x,y = 0,0
        if Blips[ID] and Blips[ID].x and Blips[ID].y then
            x,y = Blips[ID].x, Blips[ID].y
        end
        local matstr = Mat
        if not string.EndsWith(Mat, ".png") then
            matstr = Mat .. ".png"
        end
        Blips[ID] = {
            ID = ID,
            Mat = Material(matstr),
            VectorOrEntity = VectorOrEntity,
            Scale = Scale,
            col = col,
            followang = followang,
            FadeDist = FadeDist,
            Zone = Zone,
            AlwaysThruWalls = AlwaysThruWalls,
            x = x,
            y = y,
            MapConfigBlip = MapConfigBlip,
            Spinning = Spinning,
        }
        paris.Blips = Blips
    end

    paris.HUDSettings["blipdefault_player"].Material = Material(paris.HUDSettings["blipdefault_player"].mat or "")

    for k, v in pairs(player.GetAll()) do
        if v != LocalPlayer() then
            AddMapBlip(paris.HUDSettings["blipdefault_player"].mat,v,v:UniqueID(),25,paris.HUDSettings["blipdefault_player"].col or Color(255,255,255,255),paris.HUDSettings["PlayerFadeDistance"],"*", true)
        end
    end

    hook.Add("Think", "PlayerZoneChanger", function()
        for _, blip in pairs(Blips) do
            if IsValid(blip.VectorOrEntity) and IsEntity(blip.VectorOrEntity) and blip.VectorOrEntity:IsPlayer() then
                for k, v in pairs(paris.HUDMaps or {}) do
                    if v.Map == game.GetMap() then
                        if not v.UseZones or not IsValid(LocalPlayer()) then
                            blip.Zone = "*"
                        else
                            for k, v in pairs(v.Zones) do
                                if k != "MAIN" then
                                    for _, vectors in pairs(v.InsideZones) do
                                        if blip.VectorOrEntity:GetPos():WithinAABox(vectors[1],vectors[2]) then
                                            blip.Zone = k
                                        end
                                    end
                                else
                                    blip.Zone = k
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    paris.HUDSettings["blipdefault_local"].Material = Material(paris.HUDSettings["blipdefault_local"].mat)
    AddMapBlip(paris.HUDSettings["blipdefault_local"].mat,LocalPlayer(),"LocalPlayer", 25, paris.HUDSettings["blipdefault_local"].col or Color(255,255,255,255),true,"*", true, true)

    net.Receive("SendBlipsToClient", function()

        local tab = net.ReadTable()

        for k, v in pairs(tab) do // Set IDS
            tab[k].ID = k
        end

        paris.MapBlips = tab

        for k, v in pairs(Blips) do // Removes old ones
            if v.MapConfigBlip then
                Blips[k] = nil
            end
        end

        for k, v in pairs(tab) do // Adds the new config
            if !v.Scale then
                v.Scale = 30
            end
            AddMapBlip(v.Icon,Vector(v.Pos.x,v.Pos.y,v.Pos.z),k, v.Scale, v.Color or Color(255,255,255),v.FadeDistance,v.Zone or "*", false, true, false, true)
        end

        paris.Blips = Blips

        paris:HUDPrintMessage("Received and applied new updated blips package!")

    end)

    net.Receive("PARIS_AddBlipTOHUD", function()
        local data = net.ReadTable()
        local fadedist = paris.HUDSettings["PlayerFadeDistance"]
        if data.FadeDist then
            fadedist = data.FadeDist
        end
        if data.VectorOrEntity == LocalPlayer() then return end
        if data.Mat == "_playerMaterial" then 
            data.Mat = paris.HUDSettings["blipdefault_player"].mat or ""
            data.Color = paris.HUDSettings["blipdefault_player"].col or Color(255,255,255,255)
        end
        AddMapBlip(data.Mat,data.VectorOrEntity,data.ID, data.Scale, data.Color, fadedist,data.Zone, data.Follow)
    end)

    net.Receive("PARIS_RemoveBlipFROMHUD", function()
        local data = net.ReadTable()
        Blips[data.ID] = nil
    end)

    net.Start("RequestNewBlips")
    net.SendToServer()

    hook.Add("Think", "DeadDrawerThinker", function()
        for k, v in pairs(Blips or {}) do
            if (isentity(v.VectorOrEntity) and IsValid(v.VectorOrEntity) and v.VectorOrEntity:IsPlayer()) or (isentity(v.VectorOrEntity) and IsValid(v.VectorOrEntity) and v.VectorOrEntity.IsBot and v.VectorOrEntity:IsBot()) then
                if v.VectorOrEntity:Alive() then
                    if v.OriginalMat then
                        v.Mat = v.OriginalMat
                        v.Scale = v.OriginalScale
                        v.OriginalMat = nil
                    end
                    if v.VectorOrEntity:GetPos().z - LocalPlayer():GetPos().z > 400 then
                        AddMapBlip("paris/blips/playerblip_higher",v.VectorOrEntity,"UpperLower"..v.VectorOrEntity:UniqueID(),25,color_white,paris.HUDSettings["PlayerFadeDistance"],"*",false)
                        Blips["UpperLower"..v.VectorOrEntity:UniqueID()].x = Blips[v.VectorOrEntity:UniqueID()].x
                        Blips["UpperLower"..v.VectorOrEntity:UniqueID()].y = Blips[v.VectorOrEntity:UniqueID()].y
                    elseif v.VectorOrEntity:GetPos().z - LocalPlayer():GetPos().z < -400 then
                        AddMapBlip("paris/blips/playerblip_lower",v.VectorOrEntity,"UpperLower"..v.VectorOrEntity:UniqueID(),25,color_white,paris.HUDSettings["PlayerFadeDistance"],"*",false)
                        Blips["UpperLower"..v.VectorOrEntity:UniqueID()].x = Blips[v.VectorOrEntity:UniqueID()].x
                        Blips["UpperLower"..v.VectorOrEntity:UniqueID()].y = Blips[v.VectorOrEntity:UniqueID()].y
                    else
                        Blips["UpperLower"..v.VectorOrEntity:UniqueID()] = nil
                    end
                else
                    if not v.OriginalMat then
                        v.OriginalMat = v.Mat
                        v.OriginalScale = v.Scale
                        v.Mat = Material("paris/blips/dead.png")
                        v.Scale = 16
                    end
                end
            end
        end
    end)

    --[[                FINISHED                ]]
    --       No, seriously thats everything

    paris:HUDPrintMessage("Successfully Loaded GTA HUD Module!")

end

hook.Add("InitPostEntity", "LoadGTAHUD_Paris", function()
    paris:LoadHUD()
    paris.HUDLoadFromNowOn = true
end)

if paris.HUDLoadFromNowOn then
    paris:LoadHUD()
end


paris.Binds = {}

paris.Binds["MaximizeMap"] = {
    button = KEY_M,
    OnPush = function()
        paris.Maximized = true
    end,
    OnNotPush = function()
        paris.Maximized = false
    end
}

-- hook.Add("StartChat", "ChatBoxOpenBoolPARIS", function()
--     GAMEMODE.ChatBoxOpen = true
-- end)

-- hook.Add("FinishChat", "ChatBoxOpenBoolPARIS", function()
--     GAMEMODE.ChatBoxOpen = false
--     gui.HideGameUI()
--     timer.Simple(0, function() gui.HideGameUI() end)
-- end)

local star = Material("paris/blips/star.png")
local buffer = 15
hook.Add("HUDPaint", "StarSystemTopRight", function()
    if LocalPlayer():GetNWInt("WantedLevel") > 0 then
        surface.SetMaterial(star)
        for i=5,1,-1 do
            if i>=(LocalPlayer():GetNWInt("WantedLevel")+1) then
                surface.SetDrawColor(0, 0, 0, 200)
            else
                if not paris.FlashingGrey then
                    local a = math.Round((math.sin(CurTime()*4)+1)/2)
                    surface.SetDrawColor(255, 255, 255, 255*a)
                    if a == 0 then
                        surface.SetDrawColor(0, 0, 0, 200)
                    end
                else
                    surface.SetDrawColor(255, 255, 255, 255)
                end
            end
            surface.DrawTexturedRect((ScrW()-buffer)-(32*i), buffer, 32, 32)
        end
    end
end)

net.Receive("SendClientServerCurTime", function()
    paris.ServerCurTimeDiff = net.ReadInt(32) - CurTime()
end)

timer.Create("HUDPoliceFlasher", 0.5, 0, function()

    paris.FlashingGrey = LocalPlayer():GetNWBool("CanCopsSeeYouWanted")

    if not IsValid(paris.HUDPanel) then return end

    if LocalPlayer():GetNWInt("WantedLevel") > 0 and paris.FlashingGrey then
        paris.Mapflashing = true
        if paris.HUDPanel.FlashOn then 
            paris.HUDColor = (Color(117, 147, 255, paris.HUDSettings["SetHUDColor"].a)) // Blue
            paris.HUDPanel.FlashOn = false
        else
            paris.HUDColor = (Color(255, 117, 117, paris.HUDSettings["SetHUDColor"].a)) // Red
            paris.HUDPanel.FlashOn = true
        end
    else
        paris.Mapflashing = false
        paris.HUDColor = (paris.HUDSettings["SetHUDColor"])
    end
end)

local function IsPlayerCop(ply)
    if ply.isCP then return ply:isCP() end
    if ply.IsGovernmentOfficial then return ply:IsGovernmentOfficial() end
end

local Panel
concommand.Add("+gtahud_wanted", function()

    if not IsPlayerCop(LocalPlayer()) then return end

    Panel = vgui.Create("PFrame")
    Panel:SetSize(100+50+(32*5),600)
    Panel:Center()
    Panel:CloseButton( true )
    Panel:Title("Nearest Players")
    Panel:MakePopup()
    Panel:SetKeyboardInputEnabled(false)
    Panel.DrawOutline = true

    local browser = PARIS_DrawDarkScrollPanel( Panel )
    browser:SetPos(10,60)
    browser:SetSize(Panel:GetWide()-20, Panel:GetTall()-70)
    local layout = vgui.Create("DListLayout", browser)
    layout:SetSize(browser:GetWide(), browser:GetTall() / 3)
    layout:SetPos(0, 0)

    local sortedplayers = {}
    for _, ply in pairs(player.GetAll()) do
        table.insert(sortedplayers, {ply,math.Round(LocalPlayer():GetPos():DistToSqr( ply:GetPos() ))})
    end

    table.SortByMember( sortedplayers, 2, true )

    for _, tab in ipairs(sortedplayers) do
        local ply = tab[1]
        if ply == LocalPlayer() then continue end
        local Player = vgui.Create("DButton", layout)
        Player:SetSize(layout:GetWide(), layout:GetTall())
        Player:SetPos(0,0)
        Player:SetText("")
        Player:SetCursor("arrow")
        function Player:Paint()
            local Nick = ply:Nick()
            if ply.GetRPName then Nick = ply:GetRPName() end
            draw.SimpleText(Nick, "HudBlipBrowserFont", (Player:GetWide()-50) - (((5-1)*32)),(Player:GetTall()/2)-(32+10), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
        function Player:DoClick() 
            browser:ScrollToChild(Player)
        end
        
        local PlayerModel = vgui.Create("DModelPanel", Player)
        PlayerModel:SetPos(0,0)
        PlayerModel:SetSize(100,Player:GetTall())
        PlayerModel:SetModel(ply:GetModel())
        PlayerModel:SetFOV(40)
        PlayerModel.DoClick = Player.DoClick
        function PlayerModel:LayoutEntity( Entity ) return end

        for i=5,1,-1 do
            local Star = vgui.Create("DButton", Player)
            Star:SetSize(32,32)
            Star:SetText("")
            Star:SetPos((Player:GetWide()-50) - (Star:GetWide()*(i-1)),Player:GetTall()/2-(Star:GetTall()/2))
            function Star:Paint()
                surface.SetMaterial(star)
                if i>=(ply:GetNWInt("WantedLevel")+1) then
                    surface.SetDrawColor(0, 0, 0, 200)
                else
                    surface.SetDrawColor(255, 255, 255, 255)
                end
                surface.DrawTexturedRect(0, 0, 32, 32)
            end
            function Star:DoClick()
                net.Start("GTAHUD_PoliceSetStar")
                net.WriteEntity(ply)
                net.WriteInt(i,8)
                net.SendToServer()
            end
        end

        local ClearButton = vgui.Create("PButton", Player)
        ClearButton:Text("CLEAR")
        ClearButton:SetSize(70,25)
        ClearButton:SetPos((Player:GetWide()-50) - ((5*32)/2),(Player:GetTall()/2)+32+5)
        function ClearButton:DoClick()
            net.Start("GTAHUD_PoliceSetStar")
            net.WriteEntity(ply)
            net.WriteInt(0,8)
            net.SendToServer()
        end

    end

end)

concommand.Add("-gtahud_wanted", function()
    if IsValid(Panel) then Panel:Remove() end
end)


hook.Add("HUDPaint", "PaintStarsForCops", function()
    for k, v in pairs(player.GetAll()) do
        if LocalPlayer():CanSee( v, true ) then
            if v:GetNWInt("WantedLevel") > 0 then

                local Pos = v:LocalToWorld(Vector(v:OBBCenter().x, v:OBBCenter().y, v:OBBMaxs().z + 5)):ToScreen()

                local Alpha = 255;

                local dist = v:GetPos():Distance(LocalPlayer():GetPos());
                
                local moreDist = 900 - dist;
                local percOff = moreDist / (900 - 800);
                        
                Alpha = percOff;

                surface.SetMaterial(star)
                for i=5,1,-1 do
                    if i>=(v:GetNWInt("WantedLevel")+1) then
                        surface.SetDrawColor(0, 0, 0, 200*Alpha)
                    else
                        surface.SetDrawColor(255, 255, 255, 255*Alpha)
                    end
                    surface.DrawTexturedRect(((16*5)/2) - (16*i) + Pos.x, Pos.y, 16, 16)
                end
            end
        end
    end
end)

hook.Add("Think", "BindPressedCheck", function()
    if GAMEMODE.ChatBoxOpen then return end
    for k, v in pairs(paris.Binds) do
        if !paris.HUDSettings["AllowMaximizeMap"] and k == "MaximizeMap"  then
            v.pressed = false
            v.OnNotPush()
        else
            if input.IsButtonDown(v.button) and !v.pressed and !gui.IsGameUIVisible() then
                v.pressed = true
                v.OnPush()
            elseif !input.IsButtonDown(v.button) and v.pressed then
                v.pressed = false
                v.OnNotPush()
            end
        end
    end
end)

paris.ActiveNPCs = {}
paris.HUDSettings["blipdefault_npc"].Material = Material(paris.HUDSettings["blipdefault_npc"].mat)
hook.Add("Think", "GetNPCCharactersInMap", function()
    if paris.HUDSettings["ShowNPC"] then
        for k, v in pairs(ents.GetAll()) do
            if v:IsNPC() then
                paris.ActiveNPCs[v] = true
                AddMapBlip(paris.HUDSettings["blipdefault_npc"].mat,v,v,25,paris.HUDSettings["blipdefault_npc"].col or color_white,paris.HUDSettings["PlayerFadeDistance"],"*", true)
            end
        end
    else
        for k, v in pairs(paris.ActiveNPCs or {}) do
            paris.Blips[k] = nil
        end
        paris.ActiveNPCs = {}
    end
end)

concommand.Add("glp", function()
    local p = LocalPlayer():GetEyeTrace().HitPos
    print("Vector("..math.Round(p.x)..","..math.Round(p.y)..","..math.Round(p.z)..")")
end)

concommand.Add("addvector", function()
    local v = LocalPlayer():GetPos()
    print("Vector( "..math.Round(v.x)..", "..math.Round(v.y)..", "..math.Round(v.z).." )")
end)

concommand.Add("Reloadgtahud", function()
    include("gtahud/client/cl_hud.lua")
end)

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )