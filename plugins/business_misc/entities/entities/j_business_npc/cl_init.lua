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
	text:SetText("Business Certifications")
	text:SizeToContents()

    local panel = tooltip:AddRowAfter("name", "description")
    -- panel:SetBackgroundColor(Color(230, 126, 34))
    panel:SetText("You can purchase a certificate for your business here to legalize it.")
    panel:SizeToContents()


 	tooltip:SizeToContents()

end