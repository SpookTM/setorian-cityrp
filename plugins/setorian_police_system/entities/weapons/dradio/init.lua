
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

resource.AddFile("sound/dradio/radio_on.wav")
resource.AddFile("sound/dradio/radio_off.wav")
resource.AddFile("sound/dradio/radio_static.wav")
resource.AddFile("materials/resource/fonts/digital-7.ttf")
local nets = {
	"dradio_edit",
	"dradio_adjustfrequency",
	"dradio_updatefrequency",
	"dradio_networkfrequency",
	"dradio_clearfrequency",
	"dradio_sendMessage",
}

for k,v in pairs(nets) do
	util.AddNetworkString(v)
end

local function checkfrequency(ply, team, increase)
		ply.frequency = ply.frequency or math.random(1, 999)
		local team = team or ply:GetCharacter():GetFaction()
		for k,v in pairs(RADIO.RADIOCHANNELS) do
		if v.frequency == ply.frequency then
			if not table.HasValue(v.teams, team) then
				if increase then
					ply.frequency = v.frequency + .001
					ply.oldfrequency = ply.frequency
				else
					ply.frequency = v.frequency - .001
					ply.oldfrequency = ply.frequency
				end
			end
		end
	end
	ply.frequency = math.Clamp(ply.frequency or 0, 0, 999.999)
end

net.Receive("dradio_adjustfrequency", function(len, ply)

	local freq = net.ReadFloat()
	local increase = net.ReadBool()
	local wep = ply:GetActiveWeapon()
	if !IsValid(wep) or IsValid(wep) and wep:GetClass() != "dradio" then return end
	if not wep:GetNWBool("editting") then return end
	freq = math.Round(freq, 3)
	wep:SendWeaponAnim(ACT_VM_DRAW_DEPLOYED)
	timer.Create("dradio_animstop", 1.8, 1, function()
		if IsValid(wep) and wep:GetClass() == "dradio" and wep:GetNWBool("editting") then
			wep:SendWeaponAnim(ACT_VM_RELOAD)
		end
	end )
	ply.frequency = freq
	ply.oldfrequency = freq
	checkfrequency(ply, ply:Team(), increase)

	net.Start("dradio_updatefrequency")
	net.WriteDouble(ply.frequency)
	net.Send(ply)

end)

net.Receive("dradio_edit", function(len,ply)

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == "dradio" then
		if wep:GetNWBool("editting")  then
			wep:SendWeaponAnim(ACT_VM_IDLE_LOWERED)
			wep:SetNWBool("editting", false)
			timer.Simple(1, function()
				if IsValid(wep) and wep:GetClass() == "dradio" and not wep:GetNWBool("editting") then
					wep:SendWeaponAnim(ACT_VM_IDLE)
				end
			end)
		else
			wep:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			wep:SetNWBool("editting", true)
		end
	end

end)

function SWEP:Initialize()

	self:SetNWBool("editting", false)
	self:SetNWBool("power", RADIO.SpawnActive)
	if not RADIO.SpawnActive and IsValid(self:GetOwner()) then
		local owner = self:GetOwner()
		owner:ChatPrint("NO POWER")
		owner.frequency = 0
		net.Start("dradio_networkfrequency")
		net.WriteDouble(owner.frequency)
		net.WriteEntity(owner)
		net.Broadcast()
	end
	self:SetHoldType("slam")
end

function SWEP:PrimaryAttack()
	if self:GetNWBool("editting") then return end
	local ply = self:GetOwner()
	self.radioTime = self.radioTime or CurTime() - .5
	if self.radioTime + .5 < CurTime() then
		if self:GetNWBool("power") then
			self:SetNWBool("power", false)
			ply.oldfrequency = ply.frequency
			ply.frequency = 0
			net.Start("dradio_networkfrequency")
			net.WriteDouble(ply.frequency)
			net.WriteEntity(ply)
			net.Broadcast()
		else
			self:SetNWBool("power", true)
			ply.frequency = ply.oldfrequency or 127.40
			--checkfrequency(ply)
		end
		self.radioTime = CurTime()
		net.Start("dradio_updatefrequency")
		net.WriteDouble(ply.frequency)
		net.Send(ply)
	end

end

local function CheckForRadio(ply)

	if ply:Alive() and ply.frequency and ply.frequency != 0 and not ply:HasWeapon("dradio") then
		ply.frequency = 0
		net.Start("dradio_clearfrequency")
		net.Send(ply)
	end

end

--CHANGE THIS BACK TO INIT SPAWN
hook.Add("PlayerInitialSpawn", "CheckRadioFrequency", function(ply)
	ply.frequency = 0
	ply:SetAllowWeaponsInVehicle(RADIO.AllowWeaponsInVehicles)
	timer.Create(tostring(ply) .. " radio check", 5, 0, function()
		if IsValid(ply) then
			CheckForRadio(ply)
		end
	end )

end)

hook.Add("PlayerDisconnected", "CheckRadioFrequency", function(ply)

	if timer.Exists(tostring(ply) .. " radio check") then
		timer.Destroy(tostring(ply) .. " radio check")
	end

end)

hook.Add("OnPlayerChangedTeam", "CheckFrequency", function(ply, before, after)

	checkfrequency(ply, after)

end)



function SWEP:Deploy()
	local ply = self:GetOwner()
	ply.frequency = ply.frequency or math.random(1, 999)
	net.Start("dradio_updatefrequency")
	net.WriteDouble(ply.frequency)
	net.Send(ply)
	self:SendWeaponAnim(ACT_VM_DRAW)
	local slen = self:SequenceDuration(ACT_VM_DRAW) * 10
	timer.Simple(slen, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	end)
	self:SetHoldType("slam")

end


local function sendfrequency(receiver, sender)

	net.Start("dradio_networkfrequency")
	net.WriteDouble(sender.frequency)
	net.WriteEntity(sender)
	net.Send(receiver)

end

hook.Add("PlayerCanHearPlayersVoice", "RadioListen", function(listener, speaker)


	if speaker:Alive() and speaker.frequency and speaker.frequency != 0 and listener.frequency != 0 and speaker.frequency == listener.frequency  then

		if RADIO and RADIO.WhileHolding and IsValid(speaker:GetActiveWeapon()) and speaker:GetActiveWeapon():GetClass() == "dradio"  then
			sendfrequency(listener, speaker)
			return true

		elseif RADIO and not RADIO.WhileHolding then
			sendfrequency(listener, speaker)
			return true
		end

	end

end)


hook.Add("PlayerSay", "RRadioTextChat", function( speaker, text, teamChat )
	local command = RADIO.ChatCommand .. " "
	if string.Left(text, 3) == command  then
		net.Start("dradio_sendMessage")
		net.WriteString(text)
		net.WriteDouble(speaker.frequency)
		net.WriteEntity(speaker)
		net.Broadcast()
		return ""
	end


end)
