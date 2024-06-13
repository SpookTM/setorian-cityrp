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

	PLUGIN:SaveJRPoliceLocker()

end

function ENT:Use(client) 

	if (!client:GetCharacter()) then return end

	local char = client:GetCharacter()

	if (char:GetFaction() != FACTION_CITIZEN) and (char:GetFaction() != FACTION_POLICE) then
		client:Notify("Your faction does not support this. You must be in Citizen faction to use this.")
		return
	end

	local faction = ix.faction.indices[FACTION_POLICE]

	local bHasWhitelist = client:HasWhitelist(faction.index)

	if (!bHasWhitelist) then
		return client:Notify("You are not on the whitelist")
	end

	if (char:GetData("IsPoliceOfficer", false)) then

		self:EmitSound("items/ammocrate_open.wav")

		client:SetAction("Changing outfit...", 3)

		client:DoStaredAction(self, function()

			self:EmitSound("physics/cardboard/cardboard_box_break3.wav", 65)

			self:ChangeFaction(client)


		end, 3, function()
			client:SetAction()
		end)

	else
		client:Notify("You are not a police officer.")
	end

end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRPoliceLocker()
	end
end

function ENT:ChangeFaction(client)

	local char = client:GetCharacter()

	local faction

	local modelReplace1
	local modelReplace2

	if (char:GetFaction() == FACTION_POLICE) then
		faction = ix.faction.indices[FACTION_CITIZEN]
		modelReplace2 = PLUGIN.ModelReplaceCitizen
		modelReplace1 = PLUGIN.ModelReplacePolice
		client.ixPoliceDuty = false

		client:StripWeapon("weapon_rpt_handcuff")
		client:StripWeapon("weapon_rpt_finebook")
		client:StripWeapon("weapon_rpt_stungun")
		client:StripWeapon("dradio")
		client:StripWeapon("arccw_ud_glock")

	else
		faction = ix.faction.indices[FACTION_POLICE]
		modelReplace1 = PLUGIN.ModelReplaceCitizen
		modelReplace2 = PLUGIN.ModelReplacePolice
		client.ixPoliceDuty = true

		client:Give("weapon_rpt_handcuff")
		client:Give("weapon_rpt_finebook")
		client:Give("weapon_rpt_stungun")
		client:Give("dradio")
		client:Give("arccw_ud_glock")

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

			local badge_Data = {
				officer_name = char:GetName(),
			}

			local badge_item = inv:HasItem("police_badge")


			if (client.ixPoliceDuty) and (!badge_item) then

				if (!inv:Add("police_badge",1,badge_Data)) then
	                ix.item.Spawn("police_badge", client, nil, Angle(0,0,0),badge_Data)
	            end

	        elseif (!client.ixPoliceDuty) and (badge_item) then
	        	badge_item:Remove()
	        end

	        local armorsItems = {
	        	["police_armor"] = true,
	        	["police_helmet"] = true,
	        	["clothingstore_police_outfit"] = true,
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
