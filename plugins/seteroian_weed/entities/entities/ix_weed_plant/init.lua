include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()
	self:SetModel("models/base/weedplant.mdl")--"models/weedpot/weedpot_empty.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local physObj = self:GetPhysicsObject()
	if (IsValid(physObj)) then
		physObj:EnableMotion(true)
		physObj:Wake()
	end

	self.iNextThink = 0
end

function ENT:Use(pPlayer)
	local character = pPlayer:GetCharacter()
	local inventory = character:GetInventory()

	if (self:GetDead()) then
		ix.util.Notify("You have cleared the dead plant out of the pot", pPlayer)

		self:Reset()
	elseif (self:GetReadyForHarvest()) then
		local iBuds = self:GetBuds()

		local iHarvested = 0
		for i = 1, self:GetBuds() do
			if (inventory:Add("weed_bud")) then
				self:SetBuds(self:GetBuds() - 1)

				iHarvested = iHarvested + 1
			end
		end

		if (iHarvested == 0) then
			ix.util.Notify("You do not have inventory space to harvest" , pPlayer)
		elseif (iHarvested != iBuds) then
			ix.util.Notify("You harvested " .. iHarvested .. " weed buds. Clear some space to harvest the rest" , pPlayer)
		else
			ix.util.Notify("You harvested " .. iHarvested .. " weed buds" , pPlayer)
		end

		if (self:GetBuds() == 0) then
			self:Reset()
		end
	end
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())

	if (self:Health() <= 0) then
		self:Remove()
	end
end

function ENT:Reset()
	self:SetStage(WEED_PLANT_EMPTY)

	self:SetDead(false)
	self:SetGrowing(false)
	self:SetReadyForHarvest(false)
	self:SetHasSeeds(false)

	self:SetStartTime(0)
	self:SetWaterLevel(0)
	self:SetLightExposure(0)
	self:SetLife(100)
	self:SetProgress(0)
	self:SetBuds(0)
end

local iThinkDelay = 1
function ENT:Think()
	if (self.iNextThink > CurTime()) then return end
	self.iNextThink = CurTime() + iThinkDelay

	if (self:GetDead() == true or self:GetReadyForHarvest() == true or not self:GetHasSeeds()) then return end

	local iWater = self:GetWaterLevel()

	local iLifeImpact = 0
	if (iWater == 0 or not IsValid(self:GetLightSource())) then
		iLifeImpact = -1
	else
		iLifeImpact = 0.5
	end
	self:SetLife(math.Clamp(self:GetLife() + iLifeImpact, 0, 100))

	if (self:GetLife() == 0) then
		self:SetDead(true)
		return
	end

	self:SetWaterLevel(math.Clamp(self:GetWaterLevel() - (iThinkDelay / self.iWaterEvaporateTicks * 100), 0, 100))

	if (iLifeImpact > 0 and self:GetLife() == 100) then
		local iProgress = math.Clamp(self:GetProgress() + (iThinkDelay / self.iProcessTicks * 100), 0, 100)
		self:SetProgress(iProgress)
	end

	if (self:GetProgress() >= 50) then
		self:SetStage(WEED_PLANT_STAGE2)
	end

	if (self:GetProgress() == 100) then
		self:SetStage(WEED_PLANT_FINISHED)
		self:SetReadyForHarvest(true)
	end
end

function ENT:OnStageUpdated(_, iOldStage, iStage)
	if (not self.tBodyGroups[iStage]) then return end

	-- self:SetModel(self.tModels[iStage])
	self:SetBodygroup(self:FindBodygroupByName("stem"), self.tBodyGroups[iStage])

	if (iStage == WEED_PLANT_STAGE1) then
		self:SetStartTime(CurTime())
	elseif (iStage == WEED_PLANT_FINISHED) then
		self:SetBuds(5)
	end
end

function ENT:OnItemUse(itemTable, sItemID)
	if (self:GetStage() == WEED_PLANT_EMPTY and sItemID != "weed_pot_soil") then return false end

	if (sItemID == "weed_pot_soil" and self:GetStage() == WEED_PLANT_EMPTY) then
		self:SetStage(WEED_PLANT_READY)
	elseif (sItemID == "weed_water") then
		self:SetWaterLevel(100)
		self.iLastRefil = CurTime()
	elseif (sItemID == "weed_seed") then
		if (self:GetHasSeeds()) then return false end

		self:SetHasSeeds(true)
		self:SetStage(WEED_PLANT_STAGE1)
	else
		return false
	end

	return true
end