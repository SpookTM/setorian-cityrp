include("shared.lua")


function ENT:Initialize()
end

function ENT:Draw()

	self:DrawModel()

end

ENT.PopulateEntityInfo = true

local growStatus = {
	[1] = "Sprout",
	[2] = "Seedling",
	[3] = "Vegetative",
	[4] = "Flowering",
	[5] = "Ripening",
	[6] = "Ready to harvest",
	[7] = "Dying",
}

local waterStatus = {
	[0] = "Drowning",
	[1] = "Drowning",
	[2] = "Very well-hydrated",
	[3] = "Well-hydrated",
	[4] = "Hydrated",
	[5] = "Poorly hydrated",
	[6] = "Residual hydration",
	[7] = "Drying",
	[8] = "Drying",
}


function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Coca Pot")
	text:SizeToContents()

	local growColor = math.Round((self:GetGrowStatus() * 135) / 7) + 39

	local GrowStatus = tooltip:AddRowAfter("name", "lifeTime")
 	GrowStatus:SetBackgroundColor(Color(174, growColor, 39))
	GrowStatus:SetText( "Growth Stage: "..(growStatus[self:GetGrowStatus()] or "Unknown"))
 	GrowStatus:SizeToContents()


 	local waterColor = math.Round((self:GetWaterLevel() * 110) / 7) + 40

	local WaterLvl = tooltip:AddRowAfter("lifeTime", "status")
	WaterLvl:SetBackgroundColor( Color(41, waterColor, 185) )  // 150 - 40
	WaterLvl:SetText( "Water status: "..(waterStatus[self:GetWaterLevel()] or "Unknown"))
 	WaterLvl:SizeToContents()

 	local desc = tooltip:AddRowAfter("lifeTime", "desc")
	desc:SetText( "Make sure the plant has a light source and is well watered")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end