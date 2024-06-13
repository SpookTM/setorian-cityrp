include("shared.lua")

function ENT:Draw()

	self:DrawModel()


end

ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Business Phone")
	text:SizeToContents()

    local panel = tooltip:AddRowAfter("name", "description")
    panel:SetBackgroundColor(Color(230, 126, 34))
    panel:SetText("Phone used for business calls")
    panel:SizeToContents()


 	tooltip:SizeToContents()

end
