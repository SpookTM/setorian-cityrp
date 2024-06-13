ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Pot"
ENT.Category = "Setorian Meth"

ENT.Spawnable = false

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "CookLevel" )
	self:NetworkVar( "Int", 1, "Actone" )
	self:NetworkVar( "Int", 2, "Bismuth" )
	self:NetworkVar( "Int", 3, "Hydrogen" )
	self:NetworkVar( "Int", 4, "Phosphoric" )

end
