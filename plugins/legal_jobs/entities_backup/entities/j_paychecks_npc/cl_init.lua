include("shared.lua")


function ENT:Draw()

	self:DrawModel()
	
end

function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Paychecks")
	text:SizeToContents()

 	local desc = tooltip:AddRowAfter("name", "desc")
	desc:SetText( "Make your paychecks here and receive cash")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end