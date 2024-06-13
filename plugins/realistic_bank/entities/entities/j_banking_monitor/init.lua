AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

-- function ENT:SpawnFunction( ply, tr, ClassName )
-- 	if ( !tr.Hit ) then return end

-- 	local SpawnPos = tr.HitPos + tr.HitNormal * 50
-- 	local SpawnAng = ply:EyeAngles()
-- 	SpawnAng.p = 0
-- 	SpawnAng.y = SpawnAng.y + 270
-- 	local ent = ents.Create( ClassName )
-- 	ent:SetPos(SpawnPos)
-- 	ent:SetAngles(SpawnAng)
-- 	ent:Spawn()
-- 	return ent
-- end


function ENT:Initialize()

	self:SetModel("models/props/cs_office/computer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	PLUGIN:SaveJRBankingMonitors()
	

end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRBankingMonitors()
	end
end


function ENT:Use( call, act )

    if (!call:IsPlayer()) then return end

    if (call:GetCharacter():GetFaction() != PLUGIN.BankierFaction) then
    	call:Notify("You are not a bankier")
    	return
    end

    netstream.Start(call, "Jbanking_OpenMonitor_UI")

end

