AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/props_c17/Lockers001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self.faction = FACTION_EMS

	PLUGIN:SaveJREMSLocker()

end

function ENT:Use(client) 

	if (!client:GetCharacter()) then return end

	local char = client:GetCharacter()

	if (char:GetFaction() != FACTION_CITIZEN) and (char:GetFaction() != self.faction) then
		client:Notify("Your faction does not support this. You must be in Citizen faction to use this.")
		return
	end

	local faction = ix.faction.indices[self.faction]

	local bHasWhitelist = client:HasWhitelist(faction.index)

	if (!bHasWhitelist) then
		return client:Notify("You are not on the whitelist")
	end

	if (char:GetData("IsEMS", false)) then

		self:EmitSound("items/ammocrate_open.wav")

		client:SetAction("Changing outfit...", 3)

		client:DoStaredAction(self, function()

			self:EmitSound("physics/cardboard/cardboard_box_break3.wav", 65)

			self:ChangeFaction(client)


		end, 3, function()
			client:SetAction()
		end)

	else
		client:Notify("You are not the EMS.")
	end

end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJREMSLocker()
	end
end

function ENT:ChangeFaction(client)

	local char = client:GetCharacter()

	local faction

	local modelReplace1
	local modelReplace2

	if (char:GetFaction() == self.faction) then
		faction = ix.faction.indices[FACTION_CITIZEN]
		modelReplace2 = PLUGIN.ModelReplaceCitizen
		modelReplace1 = PLUGIN.ModelReplacePolice
		client.ixEMSDuty = false

		client:StripWeapon("weapon_defibrillator")
		

	else
		faction = ix.faction.indices[self.faction]
		modelReplace1 = PLUGIN.ModelReplaceCitizen
		modelReplace2 = PLUGIN.ModelReplacePolice
		client.ixEMSDuty = true

		client:Give("weapon_defibrillator")
		

	end


	if (faction) then
		local bHasWhitelist = client:HasWhitelist(faction.index)

		if (bHasWhitelist) then
			char.vars.faction = faction.uniqueID
			char:SetFaction(faction.index)

			if (faction.OnTransferred) then
				faction:OnTransferred(char)
			end

			-- char:SetModel(char:GetModel():gsub(modelReplace1, modelReplace2))

			local inv = char:GetInventory()

			


			

	        local armorsItems = {
	        	["clothingstore_police_fbi_outfit"] = true,
	        }

	        for armorID, _ in pairs(armorsItems) do

	        	local armorItem = inv:HasItem(armorID)
	        	
	        	if (client.ixPoliceDuty) and (!armorItem) then

					if (!inv:Add(armorID,1)) then
		                ix.item.Spawn(armorID, client)
		            end

		        elseif (!client.ixPoliceDuty) and (armorItem) then
		        	armorItem:Remove()
		        end

	        end


			client:Notify("You have changed your outfit")

			local PLUGINEmergency = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_aphone_app") or false

			if (PLUGINEmergency) then
				PLUGINEmergency:CheckForEmergencyUI(client)
			end

			if (client.ixPoliceDuty) then
				client:Notify("You have received additional equipment")
			end

		else
			return client:Notify("You are not on the whitelist")
		end
	end

end
