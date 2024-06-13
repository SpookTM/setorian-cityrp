local PLUGIN = PLUGIN

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Weed Plant"
ENT.Category = "Setorian"
ENT.Author = "Nockich"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_BOTH

-- Based on 1 second per tick, 900 is 15 minutes
ENT.iProcessTicks = 600
ENT.iWaterEvaporateTicks = 180

-- ENUM's, dunno if helix has a system for this
WEED_PLANT_EMPTY = 1
WEED_PLANT_READY = 2
WEED_PLANT_STAGE1 = 3
WEED_PLANT_STAGE2 = 4
WEED_PLANT_FINISHED = 5

ENT.tBodyGroups = {
	[WEED_PLANT_EMPTY] = 0,
	[WEED_PLANT_READY] = 0,
	[WEED_PLANT_STAGE1] = 3,
	[WEED_PLANT_STAGE2] = 5,
	[WEED_PLANT_FINISHED] = 7,
}

ENT.tModels = {
	[WEED_PLANT_EMPTY] = "models/weedpot/weedpot_empty.mdl",
	[WEED_PLANT_READY] = "models/weedpot/weedpot_full.mdl",
	[WEED_PLANT_STAGE1] = "models/weedpot/weedpot_stage1.mdl",
	[WEED_PLANT_STAGE2] = "models/weedpot/weedpot_stage2.mdl",
	[WEED_PLANT_FINISHED] = "models/weedpot/weedpot_stage3.mdl",
}

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Stage")

	self:NetworkVar("Bool", 0, "Dead")
	self:NetworkVar("Bool", 1, "Growing")
	self:NetworkVar("Bool", 2, "ReadyForHarvest")
	self:NetworkVar("Bool", 3, "HasSeeds")

	self:NetworkVar("Entity", 0, "LightSource")

	self:NetworkVar("Float", 0, "StartTime")
	self:NetworkVar("Float", 1, "WaterLevel")
	self:NetworkVar("Float", 2, "LightExposure")
	self:NetworkVar("Float", 3, "Life")
	self:NetworkVar("Float", 4, "Progress")
	self:NetworkVar("Float", 5, "Buds")

	if (SERVER) then
		self:NetworkVarNotify("Stage", self.OnStageUpdated)

		self:SetStage(WEED_PLANT_EMPTY)
		self:SetLife(100)
	end
end 

function ENT:CanGrow()
	if (self:GetHasSeeds() == true and self:GetWaterLevel() > 0 and IsValid(self:GetLightSource()) and self:GetLife() == 100) then
		return true
	end

	return false
end