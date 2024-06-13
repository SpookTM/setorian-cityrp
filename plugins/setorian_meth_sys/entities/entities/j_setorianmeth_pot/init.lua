AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/props_c17/metalPot001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self:SetCookLevel(0)
	self:SetActone(0)
	self:SetBismuth(0)
	self:SetHydrogen(0)
	self:SetPhosphoric(0)

	self.meth = 0
	self.Progress = ix.config.Get("MethCookTime", 15)*60
	self.CurProgress = 0
	
	self.NextSound = CurTime()
	self.NextSound2 = CurTime()

	self.IsWorking = false

	self.CurRecipe = PLUGIN.MethRecipe
	-- self.CurRecipe = {
	-- 	["Acetone"] = 3,
	-- 	["Bismuth"] = 20,
	-- 	["Hydrogen"] = 15,
	-- 	["Phosphoric"] = 5,
	-- }

end

function ENT:Think()

	if (self.NextSound < CurTime()) and (self.IsWorking) then

		self:EmitSound("ambient/levels/canals/toxic_slime_gurgle"..math.random(2,8)..".wav")
		self.NextSound = CurTime() + math.random(0.85,2)

	end

	if (self.NextSound2 < CurTime()) and (self.IsWorking) then

		self:EmitSound("ambient/levels/canals/toxic_slime_sizzle"..math.random(1,4)..".wav")
		self.NextSound2 = CurTime() + math.random(4,16)

	end

end

function ENT:Explode()

	local vPoint = self:GetPos()

	util.BlastDamage( self, self, vPoint, 100, 50 )
	
	local effectdata = EffectData()
	effectdata:SetStart(vPoint + self:GetUp() * 3)
	effectdata:SetOrigin( vPoint + self:GetUp() * 3 )
	-- effectdata:SetMagnitude( 1 )
	effectdata:SetScale(1)
	util.Effect( "Explosion", effectdata,  true, true )
	self:Remove()

end

function ENT:Process()

	if (self:GetParent() and (IsValid(self:GetParent())) and self:GetParent():GetIsWorking()) then

		if (self.BurnerIndex) then

			if (self.BurnerIndex == 1 and self:GetParent():Get1BurnerOn()) or (self.BurnerIndex == 2 and self:GetParent():Get2BurnerOn()) or (self.BurnerIndex == 3 and self:GetParent():Get3BurnerOn()) or (self.BurnerIndex == 4 and self:GetParent():Get4BurnerOn()) then

				self.ExplodeChance = 0

				local acV = self:GetActone()
				local bsV = self:GetBismuth()
				local hyV = self:GetHydrogen()
				local phV = self:GetPhosphoric()

				print(acV,self.CurRecipe["Acetone"])

				local diffAc = math.abs(acV - self.CurRecipe["Acetone"])/100
				local diffBs = math.abs(bsV - self.CurRecipe["Bismuth"])/100
				local diffHy = math.abs(hyV - self.CurRecipe["Hydrogen"])/100
				local diffPh = math.abs(phV - self.CurRecipe["Phosphoric"])/100

				self.ExplodeChance = diffPh + diffHy + diffBs + diffAc

				if (self:GetCookLevel() >= 100) then
					self.ExplodeChance = self.ExplodeChance + 0.01
				end
				print(self.ExplodeChance)
				-- if (math.random() < self.ExplodeChance) then
				-- 	self:Explode()
				-- end

				if (self:GetCookLevel() < 100) then
					self.CurProgress = math.Clamp(self.CurProgress + 1, 0, self.Progress)
					self.meth = math.Round((math.ceil((self.CurProgress * 100) / self.Progress) * (1-self.ExplodeChance)),0)
					self:CheckCookLevel()
				end

				self.IsWorking = true
			else
				self.IsWorking = false
			end
		else
			self.IsWorking = false
		end
		
	else
		self.IsWorking = false
	end

end

function ENT:CheckCookLevel()

	self:SetCookLevel( math.ceil((self.CurProgress * 100) / self.Progress) )

end

function ENT:Use(act, client)

	if (!client:IsPlayer()) then return end

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	self.oldParent = self:GetParent()
	local oldPos = self:GetPos()

	self:SetParent(NULL)
	self:SetPos(oldPos)

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	client:SetAction("Taking...", 1)
	client:DoStaredAction(self, function()
		client:EmitSound("physics/cardboard/cardboard_box_break3.wav", 60)
		
		local itemData = {
			acetone = self:GetActone(),
			bismuth = self:GetBismuth(),
			hydrogen = self:GetHydrogen(),
			phosphoric = self:GetPhosphoric(),
			cook_level = self:GetCookLevel(),
			meth_level = self.meth,
		}

		if (!inv:Add("meth_pot",1,itemData)) then 
			client:Notify("You don't have enough space in your inventory")
			return false
		end
		self:Remove()
	end, 1, function()
		client:SetAction()
		self:SetParent(self.oldParent)
		self:SetPos(oldPos)
	end)

	-- timer.Simple(1.1, function()
	-- 	if (!self) or (!IsValid(self)) then return end
	-- 	self:SetParent(self.oldParent)
	-- 	print(self:GetParent())
	-- end)

end

function ENT:OnRemove()

	if (self.oldParent) then
		if (self.BurnerIndex) then
			if (self.BurnerIndex == 1) then
				self.oldParent:Set1BurnEnt(NULL)
			elseif (self.BurnerIndex == 2) then
				self.oldParent:Set2BurnEnt(NULL)
			elseif (self.BurnerIndex == 3) then
				self.oldParent:Set3BurnEnt(NULL)
			elseif (self.BurnerIndex == 4) then
				self.oldParent:Set4BurnEnt(NULL)
			end
		end
	end

end

function ENT:Setup(CLevel,Ac,Bis,Hydr,Pho)
	self:SetCookLevel(CLevel)
	self:SetActone(Ac)
	self:SetBismuth(Bis)
	self:SetHydrogen(Hydr)
	self:SetPhosphoric(Pho)
end