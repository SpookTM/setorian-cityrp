include("shared.lua")

ENT.PopulateEntityInfo = true

function ENT:Draw()
	self:DrawModel()
end

function ENT:OnPopulateEntityInfo(container)
	local name = container:AddRow("name")
	name:SetImportant()
	name:SetText(self.PrintName)
	name:SizeToContents()

	if (self:GetStage() == WEED_PLANT_EMPTY) then
		local notice = container:AddRow("name")
		notice:SetText("Add Soil to begin")
		notice:SetBackgroundColor(Color(255, 123, 0))
		notice:SizeToContents()
		
		return
	end

	local bDead = self:GetDead()
	if (bDead) then
		local harvest = container:AddRow("seeds")
		harvest:SetText("Plant has died")
		harvest:SetBackgroundColor(Color(255, 0, 0))
		harvest:SizeToContents()

		return
	end

	local bReadyForHarvest = self:GetReadyForHarvest()
	if (bReadyForHarvest) then
		local harvest = container:AddRow("seeds")
		harvest:SetText("Ready to be harvested (" .. self:GetBuds() .. ")")
		harvest:SetBackgroundColor(Color(0, 255, 0))
		harvest:SizeToContents()

		return
	end

	local bSeeds = self:GetHasSeeds()
	if (not bSeeds) then
		local seeds = container:AddRow("seeds")
		seeds:SetText("Seeds required")
		seeds:SetBackgroundColor(Color(255, 0, 0))
		seeds:SizeToContents()
	end

	local bGrowing = self:CanGrow()
	local growing = container:AddRow("growing")
	if (bGrowing) then
		growing:SetText("Growing")
		growing:SetBackgroundColor(Color(7, 214, 24))
	else
		growing:SetText("Not Growing")
		growing:SetBackgroundColor(Color(255, 0, 0))
	end

	local lightSource = container:AddRow("lightSource")
	if (IsValid(self:GetLightSource())) then
		lightSource:SetText("Receiving Light")
		lightSource:SetBackgroundColor(Color(7, 214, 24))
	else
		lightSource:SetText("Not Receiving Light")
		lightSource:SetBackgroundColor(Color(255, 123, 0))
	end
	lightSource:SizeToContents()

	local iWater = math.Round(self:GetWaterLevel())
	local waterLevel = container:AddRow("waterLevel")
	waterLevel:SetText("Water: " .. iWater .. "%")
	waterLevel:SizeToContents()

	local iLife = self:GetLife()
	local life = container:AddRow("life")
	life:SetText("Life: " .. iLife .. "%")
	life:SizeToContents()

	local iProgress = self:GetProgress()
	local progress = container:AddRow("progress")
	progress:SetText("Progress: " .. math.Round(iProgress) .. "%")
	progress:SizeToContents()
end	