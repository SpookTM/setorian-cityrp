include("shared.lua")


function ENT:Initialize()
end

function ENT:Draw()

	self:DrawModel()
	
end


ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)

	local panel = tooltip:AddRow("name")
	panel:SetText(self:GetDealerName())
	panel:SetImportant()
 	panel:SizeToContents()
	 	
 	local desc = tooltip:AddRowAfter("name", "desc")
 	if (LocalPlayer() == self:GetLookingForPly()) then
 		desc:SetText("I will buy from you: "..self:GetDealerTypeName().." for "..ix.currency.Get(self:GetDealerPrice()))
 	else
		desc:SetText("Stranger suspicious guy.")
	end
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end