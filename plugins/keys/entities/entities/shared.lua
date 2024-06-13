ENT.PrintName = "Keys"
ENT.ClassName = "ix_keys"
ENT.Type = "anim"
ENT.Spawnable = false

function ENT:Initialize()
    self:SetModel("models/spartex117/key.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysWake()
end