include("shared.lua")


function ENT:Initialize()
end

function ENT:Draw()

	self:DrawModel()

end

function ENT:Think()

end

ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)
	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Hospital Machine")
	text:SizeToContents()

	local status = tooltip:AddRowAfter("name", "status")
	status:SetBackgroundColor( (self:GetWorkStatus() and Color(250,250,0)) or Color(250,0,0))
	status:SetText( (self:GetWorkStatus() and "WORKING") or "NOT WORKING")
 	status:SizeToContents()

 	local desc = tooltip:AddRowAfter("status", "desc")
	desc:SetText( "Place the patient you want to treat and then turn on the machine")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end
