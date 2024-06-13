include("shared.lua")


function ENT:Initialize()
end

function ENT:Draw()

	self:DrawModel()
	
end

ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Dumpster")
	text:SizeToContents()

	local fullText = "Looks like it's full and ready to be emptied"
	local emptyText = "It is empty. Wait until it is full to empty it with the garbage truck"

 	local desc = tooltip:AddRowAfter("name", "desc")
	desc:SetText( (self:GetFullTrash() and fullText) or emptyText)
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end