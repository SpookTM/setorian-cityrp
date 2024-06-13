include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:OnPopulateEntityInfo(container)
	local name = container:AddRow("name")
	name:SetImportant()
	name:SetText(self.PrintName)
	name:SizeToContents()

	local notice = container:AddRow("name")
	notice:SetText("Place above plants from a reasonable distance to supply light")
	notice:SizeToContents()
end