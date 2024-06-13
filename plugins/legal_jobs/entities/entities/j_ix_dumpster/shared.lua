ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Dumpster"
ENT.Category = "IX: Legal Jobs"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar("Bool", 0, "FullTrash")
	self:NetworkVar("Int", 0, "SpawnTimer")
	
end