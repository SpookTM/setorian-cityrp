local PLUGIN = PLUGIN

-- Cache for our weed ents so we don't have to loop through a full ent picker
PLUGIN.weedEnts = PLUGIN.weedEnts or {
	["ix_weed_lamp"] = {},
	["ix_weed_plant"] = {}
}

local iHeightTollerance = 1
local iDistanceTollerance = 15000
function PLUGIN:checkLampIsSufficient(ePlant, eLamp)
	local vPlantPos = ePlant:GetPos()
	local vLampPos = eLamp:GetPos()

	if ((vLampPos.z - vPlantPos.z) < iHeightTollerance) then
		return false
	end

	if (vPlantPos:DistToSqr(vLampPos) > iDistanceTollerance) then
		return false
	end

	return true
end

function PLUGIN:findLightSource(ePlant)
	for eLamp, _ in next, self.weedEnts["ix_weed_lamp"] do
		if (self:checkLampIsSufficient(ePlant, eLamp)) then
			ePlant:SetLightSource(eLamp)
		end
	end
end

function PLUGIN:checkLightSource(ePlant, eLamp)
	if (self:checkLampIsSufficient(ePlant, eLamp)) then
		return
	end

	ePlant:SetLightSource(nil)
end