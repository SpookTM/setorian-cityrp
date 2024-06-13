include("shared.lua")


function ENT:Draw()

	self:DrawModel()
	
end

function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("City Workers Manager")
	text:SizeToContents()

 	local desc = tooltip:AddRowAfter("name", "desc")
	desc:SetText( "Get tasks as a city worker and receive payment for work done")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end