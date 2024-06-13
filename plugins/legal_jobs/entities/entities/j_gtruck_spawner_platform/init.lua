AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/hunter/plates/plate3x5.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	self:SetMaterial( "models/props_combine/metal_combinebridge001" )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	ix_garbagetruckspawner_platforms = ix_garbagetruckspawner_platforms or {}
	ix_garbagetruckspawner_platforms[self] = true

	PLUGIN:SaveJRGarbageSpawners()

end

function ENT:CheckCollision(pos)

	local hitVector = self:GetPos()

	local check = true

	local pos1 = self:LocalToWorld(Vector( 66.93, -114.47, 1.5 ))
	local pos2 = self:LocalToWorld(Vector( -66.72, 115.34, 10 ))

	for k, v in pairs( ents.FindInBox( pos1,pos2 ) ) do
		if (v == self) then continue end
		if (v:IsWeapon()) then continue end

		if (v:IsPlayer() or v:IsNPC() or v:IsVehicle() or v:GetClass() == "prop_physics") then
			check = false
			break
		end
	

		-- if (v:GetClass() == "physgun_beam") then continue end
		-- if (v:GetClass() == "info_player_start") then continue end

		-- if (check) then
		-- 	check = false
		-- end
	end

	return check

end

function ENT:OnRemove()
  	ix_garbagetruckspawner_platforms[self] = nil

  	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRGarbageSpawners()
	end

end
