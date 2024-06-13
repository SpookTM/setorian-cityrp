AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

util.AddNetworkString("WoodTree_Spawn")


function ENT:Initialize()

	self:SetModel("models/unioncity2/props_foliage/oaktree_a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

		timer.Simple(0.2, function()

			if (!IsValid(self)) then return end
			if (!phys:IsValid()) then return end

			phys:EnableMotion(false)
		end)

	end

	PLUGIN:SaveSTree()

	self.health = ix.config.Get("TreeHealth", 8)

	self.Respawning = false

end

function ENT:RespawnTree()

	local spawnTime = ix.config.Get("treeRespawn", 60)

	if (self.Respawning) then
		timer.Simple( spawnTime, function() 
			if IsValid(self) then
				if (self.Respawning) then
				
				self.health = ix.config.Get("TreeHealth", 8)
				self.Respawning = false

				self:DrawShadow(true)
				self:RemoveAllDecals() 
				
				end
				
			end
		end)
	end
	
end

function ENT:CutTree(ply, dmg)

	if (self.Respawning) then return end

	local hitSounds = {
	"physics/wood/wood_strain1.wav",
	"physics/wood/wood_strain3.wav",
	"physics/wood/wood_strain4.wav",
	"physics/wood/wood_strain5.wav",
	"physics/wood/wood_plank_break4.wav",
	"physics/wood/wood_plank_break3.wav",
	"physics/wood/wood_plank_break2.wav",
	"physics/wood/wood_plank_break1.wav",
	}


	self:EmitSound(hitSounds[ math.random( #hitSounds ) ])

	self.health = math.max(self.health - 1, 0)

	if (self.health <= 0) then
		
		self.Respawning = true
		
		self:DrawShadow(false)

		ix.item.Spawn("wood_log", self:GetPos() + Vector(0,0,30), function(item, entity)

			constraint.NoCollide( self, entity)


		end)
		ix.item.Spawn("wood_log", self:GetPos() + Vector(0,0,87), function(item, entity)

			constraint.NoCollide( self, entity)

		end)

		local breakSounds = {
		"physics/wood/wood_box_break2.wav",
		"physics/wood/wood_furniture_break2.wav",
		"physics/wood/wood_furniture_break2.wav",
		}
		self:EmitSound(breakSounds[ math.random( #breakSounds ) ])

		timer.Simple(0, function()
	        net.Start("WoodTree_Spawn")
	            net.WriteEntity(self)
	        net.Broadcast()
	    end)

		local phys = self:GetPhysicsObject()
	
		if phys:IsValid() then
			phys:EnableMotion(false)
		end


		self:RespawnTree()

	end

end


function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveSTree()
	end
end
