ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Freezer"
ENT.Category = "Setorian Meth"

ENT.Spawnable = true


function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "IsWorking" )
	self:NetworkVar( "Bool", 1, "IsOpened" )
	self:NetworkVar( "Int", 0, "LifeTime" )
	self:NetworkVar( "Int", 1, "Trays" )
	self:NetworkVar( "Int", 2, "ReadyTrays" )

end


function ENT:GetEntityMenu(client)
	local options = {}
	
	options["Turn On/Off"] = true
	options["Replace Battery"] = true
	options["Open/Close Doors"] = true
	options["Put the tray"] = true
	options["Collect frozen tray"] = true

	return options
end

