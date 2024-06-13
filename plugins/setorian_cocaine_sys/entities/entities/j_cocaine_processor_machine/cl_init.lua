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
	text:SetText("The Processor")
	text:SizeToContents()

	local status = tooltip:AddRowAfter("name", "status")
	status:SetBackgroundColor( (self:GetIsWorking() and Color(250,250,0)) or Color(250,0,0))
	status:SetText( (self:GetIsWorking() and "The leaves will be ground in "..string.ToMinutesSeconds(self:GetWorkTime())) or "NOT WORKING")
 	status:SizeToContents()

 	local leavesInside = tooltip:AddRowAfter("status", "leaves_count")
 	leavesInside:SetBackgroundColor(Color(41, 128, 185))
	leavesInside:SetText( "Leaves in the machine: "..self:GetProcesLeaves())
 	leavesInside:SizeToContents()

 	local leavesInside = tooltip:AddRowAfter("leaves_count", "brick_ready")
 	leavesInside:SetBackgroundColor(Color(158, 158, 158))
	leavesInside:SetText( "Brick status: "..((self:GetBrickReady() and "Ready") or "Not Ready"))
 	leavesInside:SizeToContents()

 	local desc = tooltip:AddRowAfter("leaves_count", "desc")
	desc:SetText( "Place dried leaves here to produce a brick of cocaine")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end