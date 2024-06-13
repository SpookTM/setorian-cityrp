AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:Initialize()
	
	self:SetModel("models/freeman/microphone_full.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phy = self:GetPhysicsObject()

	if phys:InVaild() then 

		phys:Wake()
	end
end