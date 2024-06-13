ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Drill"
ENT.Category = "IX: Banking"

ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Progress" )
	self:NetworkVar( "Bool", 0, "Jammed" )

end