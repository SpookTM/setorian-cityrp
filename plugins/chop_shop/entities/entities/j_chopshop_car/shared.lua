ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Car"
ENT.Category = "IX: Chop Shop"

ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "MainProgress" )
	self:NetworkVar( "Int", 1, "CurrentProgress" )

	self:NetworkVar( "Vector", 0, "CurProgresPos" )

	self:NetworkVar( "Entity", 0, "Dismantler" )
	self:NetworkVar( "Bool", 0, "DestroyFade" )
	
end
