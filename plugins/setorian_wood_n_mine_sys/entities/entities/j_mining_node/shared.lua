ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Nodes"
ENT.Category = "Setorian Mining System"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "NodeName" )
	-- self:NetworkVar( "Int", 0, "NodeHP" )

end