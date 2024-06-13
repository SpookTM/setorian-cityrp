ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Stove"
ENT.Category = "Setorian Meth"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "1BurnerOn" )
	self:NetworkVar( "Bool", 1, "2BurnerOn" )
	self:NetworkVar( "Bool", 2, "3BurnerOn" )
	self:NetworkVar( "Bool", 3, "4BurnerOn" )

	self:NetworkVar( "Bool", 4, "IsWorking" )

	self:NetworkVar( "Entity", 0, "1BurnEnt" )
	self:NetworkVar( "Entity", 1, "2BurnEnt" )
	self:NetworkVar( "Entity", 2, "3BurnEnt" )
	self:NetworkVar( "Entity", 3, "4BurnEnt" )

end


function ENT:GetEntityMenu(client)
	local options = {}

	options["Burner #1 [On/Off]"] = true
	options["Burner #2 [On/Off]"] = true
	options["Burner #3 [On/Off]"] = true
	options["Burner #4 [On/Off]"] = true

	return options
end