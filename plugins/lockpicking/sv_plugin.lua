resource.AddWorkshop( "2318212263" ) -- NS Lockpicking Content

local PLUGIN = PLUGIN

-------------------------------
--[[ START / STOP SESSIONS ]]--
-------------------------------
PLUGIN.Sessions = PLUGIN.Sessions or {}

function PLUGIN:StartSession(door, ply, item)
	local s = setmetatable({}, self.SessionClass)

	s:Link(door, ply, item)
	self.Sessions[s] = true
	s:StartingAction()
	
    return s
end

function PLUGIN:StopSession(s)
    s:Unlink()
    self.Sessions[s] = nil
    s = nil
end



-----------------------
--[[ SESSION CLASS ]]--
-----------------------
local Class = PLUGIN.SessionClass or {}
Class.__index = Class
Class.Sounds = {}
Class.LockAngle = 0
Class.PinAngle = 0
Class.Freeze = true


-- Link the session instance to the concerned objects (item, entity, player)
function Class:Link(door, ply, item)
    self.Door = door
	self.Player = ply
    self.Item = item
    ply.LockpickSession = self
    door.LockpickSession = self
    item.LockpickSession = self
end

-- Unink the session instance from the concerned objects (item, entity, player)
function Class:Unlink()
    local door = self.Door
    if ( IsValid(door) ) then
        door.LockpickSession = nil
    end

    local ply = self.Player
    if ( IsValid(ply) ) then
        ply.LockpickSession = nil
    end

    local item = self.Item
    if ( item ) then
        item.LockpickSession = nil
    end
end


-- Start the lockpicking session
function Class:Start()
	local cfg = PLUGIN.CONFIG

	-- Generate unlock zone
	self.UnlockCenter = math.random(-180, 180)
	self.UnlockLimitA = self.UnlockCenter - cfg.UnlockSize
	self.UnlockLimitB = self.UnlockCenter + cfg.UnlockSize
	self.WeakLimitA = self.UnlockCenter - cfg.WeakSize
	self.WeakLimitB = self.UnlockCenter + cfg.WeakSize
	
	self.Freeze = false
	self.LastActivity = CurTime()
	netstream.Start(ply, "lpStart", self.Item:GetID())
end

-- Stop the lockpicking session
function Class:Stop(share, msg)
    local cfg = PLUGIN.CONFIG
	local ply = self.Player
	local item = self.Item

	if ( self.ChangingPin ) then ply:setAction() end -- Stop bobbypin changing action
	self:StopSound("tension")
	timer.Remove("lpEnterSound")
	self:StopSound("enter")

	-- Unfreeze player and restore his old weapon after the ScreenFade is done
	timer.Simple(cfg.FadeTime,function()
		ply:SelectWeapon(self.OldWep)
		timer.Simple(0.1, function()
			ply:SetWepRaised(self.OldWepRaise)
		end)
	end)
	
	if ( share ) then
		netstream.Start(ply, "lpStop", msg) -- Tell the client to stop the interface
	end

	-- Share rounded bobbypin health to client
	local oldHealth = item:GetData("health", 100)
	item:SetData("health", math.Round(oldHealth))
	item:SetData("health", oldHealth, false)
	
	PLUGIN:StopSession(self)
end

local function netLag(player)
	return player:Ping() / 2000
end

-- Stared action that will start the lockpicking
function Class:StartingAction()
    local cfg = PLUGIN.CONFIG
	local ply = self.Player
	local door = self.Door

		local wep = ply:GetActiveWeapon()
		if (IsValid(wep)) then
			self.OldWep = wep:GetClass()
		end
		self.OldWepRaise = ply:IsWepRaised()
		ply:SelectWeapon( "ix_hands" )

	local time = math.max(0.1 * (30 - ply:GetCharacter():GetAttribute("lockpick", 0)), 1.2)
	ply:SetAction("@lpStarting", time)
	ply:DoStaredAction(door, function()
		if (IsValid(ply)) then
            self:Start()
			ply:SetAction()
		end
	end, time, function()
		if (IsValid(ply)) then
			ply:SetAction()
		end

		netstream.Start(ply, "lpStarting", false)
        PLUGIN:StopSession(self)
	end, cfg.MaxLookDistance)

	timer.Create("lpEnterSound", time - 1, 1, function()
		self:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
	end)

	netstream.Start(ply, "lpStarting", true, time - netLag(ply))
end


-- Stared action that will load another bobbypin
function Class:ChangePinAction()
	local ply = self.Player

	self.RotatingLock = false
	self.ChangingPin = true

	local time = math.max(0.07 * (30 - ply:GetCharacter():GetAttribute("lockpick", 0)), 1.2)
	timer.Create("lpEnterSound", time - 1, 1, function()
		self:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
	end)

	ply:SetAction("@lpChange", time, function()
		self.ChangingPin = false
		self.Freeze = false
	end)

	netstream.Start(ply, "lpChange", time - netLag(ply))
end


-- Play a lockpicking sound that can be stopped whenever we want
function Class:PlaySound(soundName, soundLevel, volume, id)
	local filter = RecipientFilter()
	filter:AddAllPlayers()
	filter:RemovePlayer( self.Player )
	
	local sound = CreateSound(self.Door, soundName, filter)
	sound:ChangeVolume(volume)
	sound:SetSoundLevel(soundLevel)
	sound:Play()
		
	if (id) then
		if ( not self.Door.LockpickSounds ) then
			self.Door.LockpickSounds = {}
		end
			
		self.Door.LockpickSounds[id] = sound
	end
end

-- Stop a lockpicking sound
function Class:StopSound(id)
	local e = self.Door
	local sounds = e.LockpickSounds

	if (sounds and sounds[id]) then
		sounds[id]:Stop()
		sounds[id] = nil
	end
end


-- Success hook
function Class:Success()
	self:StopSound("tension")
	self:PlaySound("lockpicking/unlock.wav", 50, 1)

	-- Unlock the door
	local door = self.Door

	if (IsValid(door:GetDoorPartner())) then
		door:GetDoorPartner():Fire("unlock")
	end

	door:Fire("unlock")

	-- Freeze and stop the session
	self.Freeze = true
	timer.Simple(0.5, function()
		self:Stop(true)
	end)
end


-- Fail hook
function Class:Fail()
	self:PlaySound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)
	
	-- Reinsert another bobbypin
	if (self.Item:BreakPin()) then
		self:ChangePinAction()
	else
		self:Stop()
		netstream.Start(self.Player, "lpFail")
	end
end


-- Divide an angle to send it little by little to the client ( avoid cheating, the client need to wait while rotating the lock to know the angle limit )
function Class:MakeShareTable(maxAng)
	local cfg = PLUGIN.CONFIG

	self.ShareTable = {}
	local tbl = self.ShareTable

	local angAmount = math.ceil(maxAng / -30)
	local index = 0

	for i=1, angAmount do
		local realAng = ((i - 1) * -30) + (math.max(maxAng - (i-1) * -30, -30))

		if (realAng ~= cfg.HardMaxAngle) then
			index = index + 1
			tbl[index] = {}
			tbl[index].RealAng = realAng
		end
	end

	tbl.AngAmount = index
end

-- Send an angle little by little ( avoid cheating, the client need to wait while rotating the lock to know the angle limit )
function Class:ShareAngle(maxAng)
	local cfg = PLUGIN.CONFIG
	local tbl = self.ShareTable

	if (not tbl or tbl.Done) then return end

	local ply = self.Player
	local latency = netLag(ply)

	local angAmount = tbl.AngAmount

	for i=angAmount or 0, 1, -1 do
		local ang = tbl[i]

		if (not ang.Sent) then
			local realAng = tbl[i].RealAng
			local curAng = self.LockAngle
			local limit = math.min(realAng + 30, 0)

			if (math.abs((limit - curAng) / cfg.TurningSpeed) - 0.12 > latency) then
				ang.Sent = true
				ang.SendTime = SysTime()
				netstream.Start(ply, "lpMax", self.PinAngle, realAng)

				if (i == angAmount) then
					tbl.Done = true
				end

				break
			end
		end
	end
end

-- Know the ang that have the client ( Set the angle limit to the current client angle )
function Class:GetClientMaxAng()
	local cfg = PLUGIN.CONFIG
	local tbl = self.ShareTable

	if (tbl) then
		local ply = self.Player
		local latency = netLag(ply)

		local angAmount = tbl.AngAmount
		for i=angAmount or 0, 1, -1 do
			local ang = tbl[i]
			local realAng = tbl[i].RealAng
			local isLastAng = (i == angAmount)

			if (ang.Received) then
				return realAng, isLastAng
			end

			if (ang.Sent) then
				if (SysTime() > ang.SendTime + latency) then
					ang.Received = true
					return realAng, isLastAng
				end
			end
		end

		if (angAmount == 0) then
			return cfg.HardMaxAngle, true
		end
	end
	
	return cfg.HardMaxAngle, false
end


local ZONE_UNLOCK = 1
local ZONE_WEAK_LEFT = 2
local ZONE_WEAK_RIGHT = 3
local ZONE_HARD = 4
function Class:GetLockZone()
	local ang = self.PinAngle

	if (ang > self.UnlockLimitA and ang < self.UnlockLimitB) then
		return ZONE_UNLOCK
	elseif (ang > self.WeakLimitA and ang < self.UnlockLimitA) then
		return ZONE_WEAK_LEFT
	elseif (ang < self.WeakLimitB and ang > self.UnlockLimitB) then
		return ZONE_WEAK_RIGHT
	else
		return ZONE_HARD
	end
end


function Class:GetMaxLockAngle(zone)
	local cfg = PLUGIN.CONFIG

	if (zone == ZONE_UNLOCK) then
		return cfg.UnlockMaxAngle
	elseif (zone == ZONE_WEAK_LEFT) then
		return math.min(cfg.UnlockMaxAngle * (1 - ((self.UnlockLimitA - self.PinAngle) / (cfg.WeakSize - cfg.UnlockSize))), cfg.HardMaxAngle)
	elseif (zone == ZONE_WEAK_RIGHT) then
		return math.min(cfg.UnlockMaxAngle * (1 - math.abs((self.UnlockLimitB - self.PinAngle) / (cfg.WeakSize - cfg.UnlockSize))), cfg.HardMaxAngle)
	else
		return cfg.HardMaxAngle
	end
end


-- Rotate hook
function Class:RotateLock(state, pickAng)
	local cfg = PLUGIN.CONFIG
	local ply = self.Player
	local latency = netLag(ply)
	local time = CurTime()

	if (state and not self.ChangingPin) then
		if (pickAng and self.LockAngle == 0) then
			
			self.PinAngle = pickAng

			local zone = self:GetLockZone()
			local maxAng = self:GetMaxLockAngle(zone)

			if (not self.OldPinAngle or (self.OldPinAngle ~= self.PinAngle)) then
				self:MakeShareTable(maxAng)
			end
			self.OldPinAngle = pickAng

			local ang, isLastAng = self:GetClientMaxAng()
			self.LockAngle = math.max(latency * -cfg.TurningSpeed, ang)

			-- Avoid spamming requests to know the unlock angle
			if (self.LastRotating and (time - self.LastRotating < cfg.SpamTime)) then
				self:Stop()
				return
			end

			self.LastRotating = time
			self.RotatingLock = true
		end
	else
		self.LockAngle = math.min(self.LockAngle + (latency * cfg.ReleasingSpeed), 0)
		self.RotatingLock = false
	end

	self.LastActivity = time
end



-- Check that we can continue to lockpick
function Class:StopCheck()
	local cfg = PLUGIN.CONFIG
	local ply = self.Player
	local door = self.Door
	local time = CurTime()
	
	if ( not ( IsValid(ply) and IsValid(door) and self.Item ) ) then
		self:Stop()
		return
	end

	-- Avoid afk
	if ( (time - self.LastActivity) > 20 ) then
        self:Stop(true, PLUGIN.STOP_AFK)
		return
	end

	-- Check that the player is looking the door and near from it
	if ( time > (self.NextDistCheck or 0) ) then
		if (PLUGIN:GetEntityLookedAt(ply, cfg.MaxLookDistance) ~= door) then
            self:Stop(true, PLUGIN.STOP_FAR)
            return
		end

		self.NextDistCheck = time + 0.1
	end
end

function Class:Think()
	local cfg = PLUGIN.CONFIG

	self:StopCheck()

	-- Send max angle little by little to the player
	local zone = self:GetLockZone()
	self:ShareAngle( self:GetMaxLockAngle(zone) )

	local curMaxLockAngle, isLastAng = self:GetClientMaxAng()
	local exceedMax
	
	if (self.RotatingLock and not self.ChangingPin) then
		self.LockAngle = self.LockAngle - cfg.TurningSpeed * FrameTime()
		
		-- Check if the lock is forced
        if (self.LockAngle < curMaxLockAngle) then
            self.LockAngle = curMaxLockAngle

			exceedMax = true
		end
		
        if (not self.CylinderTurned) then
            self.CylinderTurned = true

			self:PlaySound("lockpicking/cylinderturn_"..math.random(8)..".wav", 50, 1, "cylinder")
			self:PlaySound("lockpicking/cylindersqueak_"..math.random(7)..".wav", 50, 1, "squeak")
		end
		
	else
		self.LockAngle = self.LockAngle + ( cfg.ReleasingSpeed * FrameTime())
		self.LockAngle = math.min(self.LockAngle, 0)
		self.CylinderTurned = false

		self:StopSound("cylinder")
		self:StopSound("squeak")
	end

	if (exceedMax) then
        if (self.AskingSuccess and self.LockAngle == cfg.UnlockMaxAngle) then
            self:Success()
		else
			if ( not self.CylinderStopped ) then
				self.HoldTime = SysTime()
                self.CylinderStopped = true
                
				self:PlaySound("lockpicking/picktension.wav", 50, 1, "tension")
				self:PlaySound("lockpicking/cylinderstop_"..math.random(4)..".wav", 50, 1)
			end

			if ((SysTime() - self.HoldTime > (netLag(self.Player)) + 0.1)) then
				local item = self.Item

				local newHealth = item:GetData("health", 100) - (65 / item.solidity) * FrameTime()
				item:SetData("health", newHealth, false)

				if (newHealth <= 0) then
					self:Fail()
				end
			end
		end
	else
		self.CylinderStopped = false
        self.HoldTime = nil
        
		self:StopSound("tension")
	end
end


PLUGIN.SessionClass = Class



---------------------
--[[ NETWORKING ]]---
---------------------
netstream.Hook("lpRotat", function(ply, state, pickAng)
	local s = ply.LockpickSession

	if ( s ) then
		s:RotateLock(state, pickAng)
	end
end)


netstream.Hook("lpStop", function(ply)
	local s = ply.LockpickSession

	if (s) then
		s:Stop()
	end
end)


netstream.Hook("lpSuccess", function(ply)
	local s = ply.LockpickSession

	if (s) then
		s.AskingSuccess = true
	end
end)



----------------
--[[ HOOKS ]]---
----------------
function PLUGIN:Think()
	for s, _ in pairs(self.Sessions) do
		if ( s.Freeze ) then return end
		s:Think()
	end
end


local allowCommand
function PLUGIN:StartCommand(ply, cmd)
	if ( not allowCommand and ply.LockpickFreeze ) then
        cmd:SetButtons(0)
    end

    allowCommand = false
end

function PLUGIN:Move(ply, mvd)
    if ( ply.LockpickSession ) then
        return true
    end
end

function PLUGIN:PlayerSwitchWeapon(ply, oldWep, newWep)
    local allowCommand = (newWep:GetClass() == "ix_hands")

	if ( not allowCommand and ply.LockpickSession ) then
        return true
    end
end



---------------------
--[[ STOP HOOKS ]]---
---------------------
function PLUGIN:EntityRemoved(ent)
    local s = ent.LockpickSession

	if (s) then
        s:Stop()
	end
end

function PLUGIN:PlayerDeath(ply, inflictor, attacker)
    local s = ply.LockpickSession

	if (s) then
        s:Stop()
	end
end

function PLUGIN:PlayerDisconnected(ply)
    local s = ply.LockpickSession

	if (s) then
        s:Stop()
	end
end
