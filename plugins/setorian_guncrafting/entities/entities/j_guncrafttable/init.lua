AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/dannio/fbikid/wpcrafting.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	PLUGIN:SaveGunCraftTables()

end

function ENT:Use(client)

	if (!client:IsPlayer()) then return end
	if (!client:Alive()) then return end

	net.Start("ixGunCrafting_OpenUI")
		net.WriteEntity(self)
	net.Send(client)

	
end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveGunCraftTables()
	end
end
