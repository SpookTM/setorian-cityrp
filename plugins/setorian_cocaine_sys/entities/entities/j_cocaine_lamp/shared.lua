ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Lamp"
ENT.Category = "Setorian Cocaine"

ENT.Spawnable = true


function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "IsWorking" )
	self:NetworkVar( "Int", 0, "LifeTime" )

end


function ENT:GetEntityMenu(client)
	local options = {}
	
	options["Turn On/Off"] = true
	options["Replace Battery"] = true

	return options
end

