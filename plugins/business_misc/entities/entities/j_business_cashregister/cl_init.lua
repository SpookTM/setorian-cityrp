include("shared.lua")

function ENT:Draw()

	self:DrawModel()


end

ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Cash Register")
	text:SizeToContents()

    local panel = tooltip:AddRowAfter("name", "description")
    panel:SetBackgroundColor(Color(230, 126, 34))
    panel:SetText("You can purchase items here")
    panel:SizeToContents()


 	tooltip:SizeToContents()

end
