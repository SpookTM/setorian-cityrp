ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Pot"
ENT.Category = "Setorian Cocaine"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "WaterLevel" )
	self:NetworkVar( "Int", 1, "GrowStatus" )
	self:NetworkVar( "Int", 2, "Leaves" )

end


function ENT:GetEntityMenu(client)
	local options = {}
	
	options["Water it (needed water item)"] = true
	options["Collect one leaf"] = true
	options["Collect five leaves"] = true
	options["Collect all the leaves"] = true

	return options
end