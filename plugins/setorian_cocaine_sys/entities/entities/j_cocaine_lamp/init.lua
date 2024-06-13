AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/props_c17/light_floodlight02_off.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	-- PLUGIN:SaveGunCraftTables()

	self:SetIsWorking(false)
	self:SetLifeTime(0)

	self.NextTick = CurTime()

	local LampEffect1 = ents.Create("prop_dynamic");
	LampEffect1:SetModel("models/effects/vol_light64x256.mdl")
	LampEffect1:SetPos(self:GetPos() + self:GetAngles():Up()*80 + self:GetAngles():Forward() * -5 + self:GetAngles():Right() * 12 )
	LampEffect1:SetAngles(self:GetAngles() + Angle(-50,0,0))
	LampEffect1:SetParent(self)
	LampEffect1:SetModelScale(0.3)
	LampEffect1:DrawShadow(false)
	LampEffect1:SetRenderMode(RENDERMODE_NONE)
	LampEffect1:SetColor(Color(255,120,120, 1))
	LampEffect1:Spawn();

	self.LampEffect1 = LampEffect1

	local LampEffect2 = ents.Create("prop_dynamic");
	LampEffect2:SetModel("models/effects/vol_light64x256.mdl")
	LampEffect2:SetPos(self:GetPos() + self:GetAngles():Up()*80 + self:GetAngles():Forward() * -5 + self:GetAngles():Right() * -16 )
	LampEffect2:SetAngles(self:GetAngles() + Angle(-60,-10,0))
	LampEffect2:SetParent(self)
	LampEffect2:SetModelScale(0.3)
	LampEffect2:DrawShadow(false)
	LampEffect2:SetRenderMode(RENDERMODE_NONE)
	LampEffect2:SetColor(Color(255,120,120, 1))
	LampEffect2:Spawn();

	self.LampEffect2 = LampEffect2

end

function ENT:Think()

	if (self:GetIsWorking()) then
		if (self.NextTick < CurTime()) then

			self:SetLifeTime( math.max(self:GetLifeTime() - 1, 0) )

			if (self:GetLifeTime() <= 0) then
				self:DisableMachine()
			end

			self.NextTick = CurTime() + 1

		end
	end

end

function ENT:LetsFindPot(potEnt)

	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()
	local startpos = self:GetPos()
	local dir = self:GetForward()
	local len = 100

	local FoundEnts = ents.FindAlongRay( startpos, startpos + dir * len, mins, maxs )

	for k, v in ipairs(FoundEnts) do
		if (v == potEnt) then
			return true
		end
	end

	return false

end

function ENT:ReplaceBattery(client)

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local batteryPower = ix.config.Get("BatteryLifeTime", 300)

	if (self:GetLifeTime() >= batteryPower) then
		client:Notify("Cannot be replaced if new battery is still installed")
		return
	end

	local item = inv:HasItem("lamp_battery")

	if (item) then

		self:SetLifeTime(batteryPower)
		self:EmitSound("physics/metal/metal_grenade_impact_soft"..math.random(1,3)..".wav")
		client:Notify("The battery has been replaced")

		item:Remove()

	else
		client:Notify("You don't have battery in your inventory")
	end

end

function ENT:EnableLampEffect(curState)

	if (curState) then

		self.LampEffect1:SetRenderMode(RENDERMODE_TRANSCOLOR)
		self.LampEffect2:SetRenderMode(RENDERMODE_TRANSCOLOR)

	else

		self.LampEffect1:SetRenderMode(RENDERMODE_NONE)
		self.LampEffect2:SetRenderMode(RENDERMODE_NONE)

	end
end

function ENT:MachineSwitch(client)

	local CurState = self:GetIsWorking()

	if (CurState) then

		self:EmitSound("buttons/lever4.wav")
		self:StopWorkSound()

	else

		self:EmitSound("buttons/lever8.wav")

		if (self:GetLifeTime() <= 0) then
			client:Notify("Cannot start because there is no power supply. Install a new battery")
			return
		end

		self:StartWorkSound()

	end

	self:SetIsWorking(!CurState)

	self:EnableLampEffect(!CurState)

end

function ENT:DisableMachine()

	self:StopWorkSound()
	self:SetIsWorking(false)
	self:EnableLampEffect(false)

end

function ENT:OnOptionSelected(client, option, data)

	if (option == "Turn On/Off") then
		self:MachineSwitch(client)
	elseif (option == "Replace Battery") then
		self:ReplaceBattery(client)
	end

end


function ENT:OnRemove()

	self:StopWorkSound()

end

function ENT:StartWorkSound()

	if (self.Worksound) then
		self.Worksound:PlayEx(1, 100)
	else
	    self.Worksound = CreateSound(self, Sound("ambient/machines/power_transformer_loop_2.wav"))
	    self.Worksound:SetSoundLevel(60)
		self.Worksound:PlayEx(1, 100)
	end
end

function ENT:StopWorkSound()
	if self.Worksound then
        self.Worksound:Stop()
    end
end