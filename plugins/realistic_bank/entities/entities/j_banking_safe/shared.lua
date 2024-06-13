ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Safe"
ENT.Category = "IX: Banking"

ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Cooldown" )
	self:NetworkVar( "Int", 1, "AutoClose" )

end