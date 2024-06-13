AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/props_vtmb/safe.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self:SetCooldown(0)
	self:SetAutoClose(0)

	self.NextTick = CurTime()


	self.MoneyPos = {
		[1] = Vector( -10, -10, 7 ),
		[2] = Vector( -10, 10, 7 ),
		[3] = Vector( 10, -10, 7 ),
		[4] = Vector( 10, 10, 7 ),
		[5] = Vector( -10, -10, 17 ),
		[6] = Vector( -10, 10, 17 ),
		[7] = Vector( 10, -10, 17 ),
		[8] = Vector( 10, 10, 17 ),
	}



	self.MoneySpawned = {}

	PLUGIN:SaveJRBankingSafe()
end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRBankingSafe()
	end
end

function ENT:Think()

	if (self:GetAutoClose() > 0) then

		if (self.NextTick < CurTime()) then

			self:SetAutoClose(math.max(0, self:GetAutoClose() - 1))

			self.NextTick = CurTime() + 1
		end

	end

	if (self:GetCooldown() > 0) then

		if (self.NextTick < CurTime()) then

			self:SetCooldown(math.max(0, self:GetCooldown() - 1))

			self.NextTick = CurTime() + 1
		end

	end

end

function ENT:GenerateMoney()

	local howMany = math.random(1,8)

	for i = 1, howMany do

		local randomAng = math.random(0,360)

		local MoneyStack = ents.Create("j_banking_moneystack");
		MoneyStack:SetPos(self:LocalToWorld(self.MoneyPos[i]) )
		MoneyStack:SetAngles(self:GetAngles() + Angle(0,randomAng,0):SnapTo( "y", 90 ))
		MoneyStack:Spawn()

		self.MoneySpawned[#self.MoneySpawned + 1] = MoneyStack

		self:DeleteOnRemove(MoneyStack)

	end

end

function ENT:RemoveLeftMoney()

	for k, v in pairs(self.MoneySpawned) do

		if (!IsValid(v)) then continue end
		v:Remove()

	end

	self.MoneySpawned = {}

end

function ENT:StartDrilling()

	local DrillEnt = ents.Create("j_banking_drill");
	DrillEnt:SetPos(self:GetPos() + self:GetAngles():Forward()*31 + self:GetAngles():Right() * -12.4 + self:GetAngles():Up() * 14.5 )
	DrillEnt:SetAngles(self:GetAngles() + Angle(0,90,0))
	DrillEnt:SetParent(self)
	DrillEnt:Spawn()

	DrillEnt.Safe = self

	self:DeleteOnRemove(DrillEnt)

end

-- function ENT:StartTouch(ent)

	-- if (ent:GetClass() != "ix_item") then return end
	-- local itemTable = ent:GetItemTable()
	-- if (itemTable.uniqueID != "drillbag") then return end

	-- self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1,3)..".wav", 60)

	-- self:StartDrilling()
	-- ent:Remove()

-- end

function ENT:DoorOpen()

	self:SetBodygroup(1, 1)
	self:DrawShadow()

	self:SetAutoClose(30)

	self:GenerateMoney()

	self:EmitSound("doors/wood_move1.wav")

	timer.Simple(32, function()

		if (!IsValid(self)) then return end

		self:DoorClose()

	end)

end


function ENT:DoorClose()

	self:SetBodygroup(1, 0)
	self:DrawShadow()

	self:RemoveLeftMoney()

	self:SetCooldown(18000)

	self:EmitSound("doors/wood_stop1.wav")

end