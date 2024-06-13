function PLUGIN:OnEntityCreated(eEnt)
	local sClass = eEnt:GetClass()
	if (not self.weedEnts[sClass]) then return end

	self.weedEnts[sClass][eEnt] = true
end

function PLUGIN:EntityRemoved(eEnt)
	local sClass = eEnt:GetClass()
	if (not self.weedEnts[sClass]) then return end

	self.weedEnts[sClass][eEnt] = nil
end

local iNextTick = 0
local iThinkDelay = 1
function PLUGIN:Think()
	if (iNextTick > CurTime()) then return end
	iNextTick = CurTime() + iThinkDelay

	for ePlant, _ in next, self.weedEnts["ix_weed_plant"] do
		if (not IsValid(ePlant)) then
			self.weedEnts["ix_weed_plant"][ePlant] = nil
			continue
		end

		local iStage = ePlant:GetStage()
		if (iStage <= WEED_PLANT_EMPTY or ePlant:GetReadyForHarvest() or ePlant:GetDead()) then
			continue
		end

		local eLamp = ePlant:GetLightSource()
		if (eLamp == nil or not IsValid(eLamp)) then	
			self:findLightSource(ePlant)
		else
			self:checkLightSource(ePlant, eLamp)
		end
	end
end