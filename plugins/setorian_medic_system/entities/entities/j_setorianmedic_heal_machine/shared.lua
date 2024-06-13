ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Healing Machine"
ENT.Category = "Setorian Medic System"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "WorkStatus")

end