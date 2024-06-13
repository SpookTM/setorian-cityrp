paris = paris or {}

resource.AddWorkshop("2034472616") -- Main Content
resource.AddWorkshop("2871167838") -- Additional Content

util.AddNetworkString("PARIS_AddBlipTOHUD")
util.AddNetworkString("PARIS_RemoveBlipFROMHUD")

local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")


function PLAYER:AddMapBlip(Mat, BlipID, Scale, Color, FadeDist, Zone, Follow)
    timer.Simple(1, function()
        net.Start("PARIS_AddBlipTOHUD")
            net.WriteTable(
                {
                    VectorOrEntity = self,
                    Mat = Mat,
                    ID = BlipID,
                    Scale = Scale,
                    Color = Color,
                    Follow = Follow,
                    FadeDist = FadeDist,
                    Zone = Zone
                }
            )
        net.Broadcast()
    end)
end

function ENTITY:AddMapBlip(Mat, BlipID, Scale, Color, FadeDist, Zone, Follow)
    timer.Simple(1, function()
        net.Start("PARIS_AddBlipTOHUD")
            net.WriteTable(
                {
                    VectorOrEntity = self,
                    Mat = Mat,
                    ID = BlipID,
                    Scale = Scale,
                    Color = Color,
                    Follow = Follow,
                    FadeDist = FadeDist,
                    Zone = Zone
                }
            )
        net.Broadcast()
    end)
end

function ENTITY:AddMapBlipSpecificPlayer(Mat, BlipID, Scale, Color, FadeDist, Zone, Follow, Player)
    timer.Simple(1, function()
        net.Start("PARIS_AddBlipTOHUD")
            net.WriteTable(
                {
                    VectorOrEntity = self,
                    Mat = Mat,
                    ID = BlipID,
                    Scale = Scale,
                    Color = Color,
                    Follow = Follow,
                    FadeDist = FadeDist,
                    Zone = Zone
                }
            )
        net.Send(Player)
    end)
end

function AddMapBlip(Vector, Mat, BlipID, Scale, Color, FadeDist, Zone, Follow)
    timer.Simple(1, function()
        net.Start("PARIS_AddBlipTOHUD")
            net.WriteTable(
                {
                    VectorOrEntity = Vector,
                    Mat = Mat,
                    ID = BlipID,
                    Scale = Scale,
                    Color = Color,
                    Follow = Follow,
                    FadeDist = FadeDist,
                    Zone = Zone
                }
            )
        net.Broadcast()
    end)
end

function AddMapBlipSpecificPlayer(Vector, Mat, BlipID, Scale, Color, FadeDist, Zone, Follow, Player)
    timer.Simple(1, function()
        net.Start("PARIS_AddBlipTOHUD")
            net.WriteTable(
                {
                    VectorOrEntity = Vector,
                    Mat = Mat,
                    ID = BlipID,
                    Scale = Scale,
                    Color = Color,
                    Follow = Follow,
                    FadeDist = FadeDist,
                    Zone = Zone
                }
            )
        net.Send(Player)
    end)
end

function RemoveBlip(BlipID)
    timer.Simple(1, function()
        net.Start("PARIS_RemoveBlipFROMHUD")
            net.WriteTable(
                {
                    ID = BlipID,
                }
            )
        net.Broadcast()
    end)
end

function PLAYER:RemoveBlip(BlipID)
    timer.Simple(1, function()
        net.Start("PARIS_RemoveBlipFROMHUD")
            net.WriteTable(
                {
                    ID = BlipID,
                }
            )
        net.Send(self)
    end)
end


hook.Add("PlayerInitialSpawn", "PARIS_AddBlipTOHUD", function(ply)
    ply:AddMapBlip("_playerMaterial", ply:UniqueID(), 25, Color(255,255,255,255), false, "*", true)
end)

local Client_AllowedChange = {
    DrawHUD = true,
    HUDPosX = true,
    HUDPosY = true,
    HUDSizeX = true,
    HUDSizeY = true,
    CarCamHeight = false,
    CamHeight = false,
    CarLookAng = false,
    FOV = false,
    DrawVOID = true,
    KeepTiltedCamera = false,
    SetHUDColor = true,
    DrawBackgroundBlur = true,
    BackgroundBlurStrength = true,
    BackgroundOpacity = true,
    DrawOthers = true,
    DrawOutline = true,
    DrawStamina = false,
    PlayerFadeDistance = false,
    DrawOnlyIfSeen = false,
    DefaultChat = true,
    AllowMaximizeMap = false,
    blipdefault_player = false,
    blipdefault_npc = false,
    blipdefault_local = false,
    MaxWantedStars = false,
}

Default_Client_AllowedChange = table.Copy(Client_AllowedChange)

Settings = Settings or {}

local ConfigPath = "gtahudconfig_server.json"
if !file.Exists(ConfigPath, "DATA") or !istable(util.JSONToTable(file.Read(ConfigPath, "DATA"))) then
    file.Append(ConfigPath, util.TableToJSON(DefaultClientOptions, true))
    Settings = DefaultClientOptions
else
    Settings = util.JSONToTable(file.Read(ConfigPath, "DATA") )
    for k, v in pairs(DefaultClientOptions) do
        if Settings[k] == nil then -- new setting not set in server...
            Settings[k] = DefaultClientOptions[k]
        end
    end
    file.Write(ConfigPath, util.TableToJSON(Settings, true))
end

local ConfigPathAllowed = "gtahudconfig_server_allowed.json"
if !file.Exists(ConfigPathAllowed, "DATA") or !istable(util.JSONToTable(file.Read(ConfigPathAllowed, "DATA"))) then
    file.Append(ConfigPathAllowed, util.TableToJSON(Client_AllowedChange, true))
    Client_AllowedChange = Client_AllowedChange
else
    Client_AllowedChange = util.JSONToTable(file.Read(ConfigPathAllowed, "DATA") )
end

util.AddNetworkString("ReceiveServerSettings")
function PLAYER:SendGTAHUDSettings()
    net.Start("ReceiveServerSettings")
        net.WriteTable({
            Settings = Settings,
            AllowedChange = Client_AllowedChange
        })
    net.Send(self)
end

util.AddNetworkString("RequestServerSettings")
net.Receive("RequestServerSettings", function(len,ply)
    ply:SendGTAHUDSettings()
end)

function PLAYER:SendGTAHUDSettings()
    net.Start("ReceiveServerSettings")
        net.WriteTable({
            Settings = Settings,
            AllowedChange = Client_AllowedChange
        })
    net.Send(self)
end

for k, v in pairs(player.GetAll()) do
    v:SendGTAHUDSettings()
end

util.AddNetworkString("paris_resetadminsettings")
net.Receive("paris_resetadminsettings", function(len,ply)

    if not ply:IsSuperAdmin() then return end

    local SentChanges = {}
    for k, v in pairs(Client_AllowedChange) do
        if !v then
            SentChanges[k] = DefaultClientOptions[k]
        end
    end

    net.Start("ReceiveServerSettings")
    net.WriteTable({
        Settings = SentChanges,
        AllowedChange = Default_Client_AllowedChange
    })
    net.Broadcast()

end)

util.AddNetworkString("paris_adminupdatehudsettings")
net.Receive("paris_adminupdatehudsettings", function(len,ply)

    if not ply:IsSuperAdmin() then return end

    //Setting Changables

    if !ply:IsSuperAdmin() then return end
    local newdata = net.ReadTable()
    for k, v in pairs(newdata) do
        Client_AllowedChange[k] = v
    end

    file.Write(ConfigPathAllowed, util.TableToJSON(Client_AllowedChange, true))


    --[[//Setting Those Nonchagable Settings :)

    local newsettings = net.ReadTable()
    for k, v in pairs(newsettings) do
        Settings[k] = v
    end
    file.Write(ConfigPath, util.TableToJSON(Settings, true))]]

    for k, v in pairs(player.GetHumans()) do
        v:SendGTAHUDSettings()
    end

end)

hook.Add("PlayerInitialSpawn", "PARIS_SendHUDSettings", function(ply)
    ply:SendGTAHUDSettings()
end)

concommand.Add("requesthudsettings", function(ply)
    ply:SendGTAHUDSettings()
end)

util.AddNetworkString("PlayerEnteredVehicle")
hook.Add("PlayerEnteredVehicle", "PARIS_ServerToClientEnterVehicle", function(ply)
    net.Start("PlayerEnteredVehicle")
    net.Send(ply)
end)

util.AddNetworkString("PlayerLeaveVehicle")
hook.Add("PlayerLeaveVehicle", "PARIS_ServerToClientLeaveVehicle", function(ply)
    net.Start("PlayerLeaveVehicle")
    net.Send(ply)
end)


-- Blips system FOR ONLY ONES IN MAP FILE!!!!!

local Blips = {}

util.AddNetworkString("SendBlipsToClient")

local function SendEverybodyUpdatedBlips()
    net.Start("SendBlipsToClient")
        net.WriteTable(Blips)
    net.Broadcast()
end

local function SendUpdatedBlips(ply)
    net.Start("SendBlipsToClient")
        net.WriteTable(Blips)
    net.Broadcast()
end

hook.Add("PlayerInitialSpawn", "GiveBlipsOnJoin", function(ply)
    net.Start("SendBlipsToClient")
        net.WriteTable(Blips)
    net.Send(ply)
end)

util.AddNetworkString("RequestNewBlips")
net.Receive("RequestNewBlips", function(len,ply)

    net.Start("SendBlipsToClient")
        net.WriteTable(Blips)
    net.Send(ply)

end)

local function ReloadBlips()

    if  !file.Exists("gtahud", "DATA") then
        file.CreateDir("gtahud")
    end

    if file.Exists("gtahud/"..game.GetMap()..".json", "DATA") then
        local data = file.Read("gtahud/"..game.GetMap()..".json", "DATA")
        local tab = util.JSONToTable(data)
        if tab and istable(tab) then
            Blips = tab
        elseif data != "" then
            Error("ERROR: gtahud/"..game.GetMap()..".json is not JSON formatted! Failed to load blips!\n")
        elseif !data then
            file.Write("gtahud/"..game.GetMap()..".json", "{}")
        end
    else
        file.Write("gtahud/"..game.GetMap()..".json", "{}")
    end

    SendEverybodyUpdatedBlips()

end

ReloadBlips()

util.AddNetworkString("ReloadHUDBlips")
net.Receive("ReloadHUDBlips", function(len,ply)

    if !ply:IsAdmin() then return end
    ReloadBlips()
    paris:HUDPrintMessage("Reloaded blips from file!")

end)

util.AddNetworkString("AddHUDBlip")
net.Receive("AddHUDBlip", function(len,ply)

    if !ply:IsAdmin() then return end

    local NewBlip = net.ReadTable()

    Blips[#Blips+1] = {
        Pos = NewBlip.Pos,
        Icon = NewBlip.Icon,
        Scale = NewBlip.Scale,
        Color = NewBlip.Color,
        Zone = NewBlip.Zone,
        FadeDistance = NewBlip.FadeDistance
    }

    file.Write("gtahud/"..game.GetMap()..".json", util.TableToJSON(Blips, true))

    timer.Simple(0.01, function()
        paris:HUDPrintMessage("Added a new blip!")
        ReloadBlips()
    end)

end)

util.AddNetworkString("RemoveHUDBlip")
net.Receive("RemoveHUDBlip", function(len,ply)

    if !ply:IsAdmin() then return end

    local BlipToRemove = net.ReadTable()

    Blips[BlipToRemove.key] = nil

    file.Write("gtahud/"..game.GetMap()..".json", util.TableToJSON(Blips, true))

    timer.Simple(0.01, function()
        paris:HUDPrintMessage("Removed a blip!")
        ReloadBlips()
    end)

end)

local function IsPlayerCop(ply)
    if ply.isCP then return ply:isCP() end
    if ply.IsGovernmentOfficial then return ply:IsGovernmentOfficial() end
end

util.AddNetworkString("GTAHUD_PoliceSetStar")
net.Receive("GTAHUD_PoliceSetStar", function(len,ply)

    if not IsPlayerCop(ply) then return end

    local otherply = net.ReadEntity()
    if not IsValid(otherply) then return end

    local level = net.ReadInt(8)
    if level > 5 then return end

    otherply.WantedLevelLoseTime = CurTime() + 10 + (10*level)
    ply.WantedLevelCanSee = CurTime() + 5

    otherply:SetNWInt("WantedLevel",level)

end)


function PLAYER:HasLOS( Entity )
	local tr = util.TraceLine( {
		start 	= self:GetShootPos(),
		endpos 	= Entity:GetPos() + Vector( 0, 0, 64 ),
        filter 	= { Entity, self, self:GetActiveWeapon(), self:GetVehicle() },
	} )
	
	local tr2 = util.TraceLine( {
		start 	= self:GetShootPos(),
		endpos 	= Entity:GetPos(),
		filter 	= { Entity, self, self:GetActiveWeapon(), self:GetVehicle() },
	} )
	
	if tr.Fraction > 0.98 or tr2.Fraction > 0.98 then return true end
end

function PLAYER:CanSee( Entity, Strict )
	if not IsValid( Entity ) then return end
	
	if Strict then
		if not self:HasLOS( Entity ) then return end
	end

	if self:GetPos():Distance( Entity:GetPos() ) < 200 then return true end

	local fov = self:GetFOV()
	local Disp = Entity:GetPos() - self:GetPos()
	local Dist = Disp:Length()
	local EntWidth = Entity:BoundingRadius() * 0.5
	
	local MaxCos = math.abs( math.cos( math.acos( Dist / math.sqrt( Dist * Dist + EntWidth * EntWidth ) ) + fov * ( math.pi / 180 ) ) )
	Disp:Normalize()

	if Disp:Dot( self:EyeAngles():Forward() ) > MaxCos and Entity:GetPos():Distance( self:GetPos() ) < 5000 then
		return true
	end
end

util.AddNetworkString("SendClientServerCurTime")
hook.Add("PlayerInitialSpawn", "SendClientServerCurTime", function(ply)
    net.Start("SendClientServerCurTime")
    net.WriteInt(CurTime(),32)
    net.Send(ply)
end)

hook.Add("Think", "CanCopSeeWantedPeople", function()

    for _, ply in pairs(player.GetAll()) do
        if ply:GetNWInt("WantedLevel") > 0 then
            for _, cop in pairs(player.GetAll()) do
                if IsPlayerCop(cop) then -- cop check
                    if cop:CanSee(ply, true) then
                        ply:SetNWBool("CanCopsSeeYouWanted", true)
                        ply.WantedLevelCanSee = CurTime() + 5
                        ply.WantedLevelLoseTime = CurTime() + 10 + (10*ply:GetNWInt("WantedLevel"))
                    end
                end
            end
        end
        
        if ( ply.WantedLevelLoseTime or (CurTime()+1) ) < CurTime() then
            ply:SetNWInt("WantedLevel", 0)
            ply.WantedLevelLoseTime = nil
        end

        if ( ply.WantedLevelCanSee or (CurTime()+1) ) < CurTime() then
            ply:SetNWBool("CanCopsSeeYouWanted", false)
            ply.WantedLevelCanSee = nil
        end

    end

end)

paris:HUDPrintMessage("Successfully Loaded GTA HUD Serverside Module!")
