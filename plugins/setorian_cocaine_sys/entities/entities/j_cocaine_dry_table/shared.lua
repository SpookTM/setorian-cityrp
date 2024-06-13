ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Drying Rack"
ENT.Category = "Setorian Cocaine"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "WetLeaves" )
	self:NetworkVar( "Int", 1, "DryLeaves" )

	self:NetworkVar( "Bool", 0, "IsWorking" )

end


function ENT:GetEntityMenu(client)
	local options = {}
	
	options["Turn On/Off"] = true
	options["Put the wet leaves"] = true
	options["Collect the dry leaves"] = true

	return options
end