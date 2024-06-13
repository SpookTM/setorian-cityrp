ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Deposit Boxes"
ENT.Category = "IX: Banking"

ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Cooldown" )
	self:NetworkVar( "Bool", 0, "LockPicking" )

end