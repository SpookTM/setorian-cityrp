include("shared.lua")

function ENT:Draw()

	self:DrawModel()


end

ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Meth Pot")
	text:SizeToContents()


 	local cook_level = self:GetCookLevel()

    local panel = tooltip:AddRowAfter("description", "cook_level")
    panel:SetBackgroundColor(Color(230, 126, 34))
    panel:SetText("Cook Level: "..cook_level.."%")
    panel:SizeToContents()

    local panel = tooltip:AddRowAfter("cook_level", "ingre_title")
    panel:SetBackgroundColor(Color(39, 174, 96))
    panel:SetText("Ingredients: ")
    panel:SizeToContents()

    local acetoneValue = self:GetActone()
    local bismuthValue = self:GetBismuth()
    local hydrogenValue = self:GetHydrogen()
    local phosphoricValue = self:GetPhosphoric()

    local panel = tooltip:AddRowAfter("ingre_title", "AcetoneText")
    -- panel:SetBackgroundColor(Color(230, 126, 34))
    panel:SetText("- Acetone "..acetoneValue.."%")
    panel:SizeToContents()

    local panel = tooltip:AddRowAfter("AcetoneText", "BismuthText")
    panel:SetText("- Bismuth "..bismuthValue.."%")
    panel:SizeToContents()
    
    local panel = tooltip:AddRowAfter("BismuthText", "hydrogenText")
    panel:SetText("- Hydrogen Peroxide "..hydrogenValue.."%")
    panel:SizeToContents()
    
    local panel = tooltip:AddRowAfter("hydrogenText", "phosphoricText")
    panel:SetText("- Phosphoric Acid "..phosphoricValue.."%")
    panel:SizeToContents()

    local panel = tooltip:AddRowAfter("phosphoricText", "tip")
    panel:SetBackgroundColor(Color(230, 126, 34))
    panel:SetText("Press 'E' to take it")
    panel:SizeToContents()

 	tooltip:SizeToContents()

end
