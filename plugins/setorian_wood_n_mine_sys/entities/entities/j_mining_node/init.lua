AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

util.AddNetworkString("NodeOre_Spawn")

function ENT:Initialize()

	self:SetModel("models/fbkid/work/coalrock.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

		timer.Simple(1, function()

			if (!IsValid(self)) then return end
			if (!phys:IsValid()) then return end

			phys:EnableMotion(false)
		end)

	end

	PLUGIN:SaveSMineNodes()
	self:SetNodeName("Coal")
	self.nodeHP = 200

	self.Respawning = false

	self:RandomNode()

end

function ENT:RandomNode()

	local nodes = {
		"coal",
		"gold",
		"silver",
		"copper"
	}

	local randomNode = nodes[ math.random( #nodes ) ]

	self:SetModel("models/fbkid/work/"..randomNode.."rock.mdl")

	local niceName = randomNode:utf8sub(1, 1):utf8upper() .. randomNode:utf8sub(2)

	self:SetNodeName(niceName)

end

function ENT:RespawnNode()

	self:RandomNode()

	local spawnTime = ix.config.Get("nodeRespawn", 60)

	if (self.Respawning) then
		timer.Simple( spawnTime, function() 
			if IsValid(self) then
				if (self.Respawning) then
				
				self.nodeHP = 200
				self.Respawning = false
				-- self:SetMaterial()
				-- self:SetCollisionGroup(0)
				-- self:SetPos(self:GetPos() + Vector(0,0,300))
				self:RemoveAllDecals() 
				
				end
				
			end
		end)
	end
	
end

function ENT:MineOre(ply, dmg)

	if (self.Respawning) then return end

	self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav")

	self.nodeHP = math.Clamp(self.nodeHP - dmg, 0, 100)

	local chance = ix.config.Get("miningChance", 30) / 100

	if (math.random() < chance) then

		local itemID = "ore_" .. string.lower(self:GetNodeName())

		local char = ply:GetCharacter()
		local inv  = char:GetInventory()

		if (!inv:Add(itemID)) then
            ix.item.Spawn(itemID, ply)
        end

		ply:Notify("You have successfully mined one ore")


	end

	if (self.nodeHP <= 0) then
		
		-- self:SetMaterial("Models/effects/vol_light001");
		-- self:SetCollisionGroup(10)
		
		self.Respawning = true
		-- self:SetPos(self:GetPos() + Vector(0,0,-300))

		timer.Simple(0, function()
	        net.Start("NodeOre_Spawn")
	            net.WriteEntity(self)
	        net.Broadcast()
	    end)

		local phys = self:GetPhysicsObject()
	
		if phys:IsValid() then
			phys:EnableMotion(false)
		end

		self:RespawnNode()

	end

end


function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveSMineNodes()
	end
end
