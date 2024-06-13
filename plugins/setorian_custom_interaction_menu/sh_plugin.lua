PLUGIN.name = "Setorian Interaction UI"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = ""

ix.option.Add("interactionmenukey", ix.type.string, "n", {
	category = "Setorian",
	phrase = "Interaction Key",
	description = "Set the key for the interaction menu. Type any lowercase character to assign the menu to a key.",
	OnChanged = function(oldValue, value)

		if (isnumber(tonumber(value))) then
			LocalPlayer():Notify("Number entered, restored to default value")
	    	ix.option.Set("interactionmenukey", "n")
		end

	    if (string.len(value) > 1) then
	    	LocalPlayer():Notify("More than one character was entered. Restored the value to the 'n' letter")
	    	ix.option.Set("interactionmenukey", "n")
	    end
	    
	end
})

if (CLIENT) then
	PLUGIN.KeysData = {
		["a"] = KEY_A,
		["b"] = KEY_B,
		["c"] = KEY_C,
		["d"] = KEY_D,
		["e"] = KEY_E,
		["f"] = KEY_F,
		["g"] = KEY_G,
		["h"] = KEY_H,
		["i"] = KEY_I,
		["j"] = KEY_J,
		["k"] = KEY_K,
		["l"] = KEY_L,
		["m"] = KEY_M,
		["n"] = KEY_N,
		["o"] = KEY_O,
		["p"] = KEY_P,
		["q"] = KEY_Q,
		["r"] = KEY_R,
		["s"] = KEY_S,
		["t"] = KEY_T,
		["u"] = KEY_U,
		["v"] = KEY_V,
		["w"] = KEY_W,
		["x"] = KEY_X,
		["y"] = KEY_Y,
		["z"] = KEY_Z,
	}
end


PLUGIN.Interaction_Functions = {
	[1] = {
		Name = "Frisk",
		Icon = Material("setorian_interaction_menu/magnifying-glass.png", "noclamp smooth"),
		Func = function(client)

			if (client:GetCharacter()) then

				-- local eyeTrace = client:GetEyeTrace()

				local eyeTrace = util.TraceLine( {
					start = client:EyePos(),
					endpos = client:EyePos() + client:GetForward() * 100,
					filter = function( ent ) return ( ent != client ) end
				} )

				local eyeEnt = eyeTrace.Entity

				local char = client:GetCharacter()
				-- local inv = char:GetInventory()
				-- local invItems = inv:GetItems()

				if (eyeEnt:IsPlayer()) then
					
					if (client:GetPos():DistToSqr(eyeEnt:GetPos()) < 5000) then

						if (eyeEnt.WhoWantFrisk) or (client.WhoWantFrisk) then
							client:NotifyLocalized("notNow")
							return
						end

						if (eyeEnt.WantsFrisk) or (client.WantsFrisk) then
							client:NotifyLocalized("notNow")
							return
						end

						local eyechar = eyeEnt:GetCharacter()

						eyeEnt.WhoWantFrisk = client
						client.WantsFrisk = eyeEnt

						timer.Create( "FriskChecker_"..eyechar:GetID(), 30, 1, function() 
							
							if IsValid(client) then
								client:Notify("Frisk Request timed out")
								client.WantsFrisk = nil
							end

							if (IsValid(eyeEnt)) then
								eyeEnt.WhoWantFrisk = nil
								eyeEnt:Notify("Frisk Request timed out")
							end

						end)

						netstream.Start(client, "SetorianExtras_Frisk_OpenWaitUI", eyechar:GetName())
						netstream.Start(eyeEnt, "SetorianExtras_Frisk_OpenAcceptUI", char:GetName())

						return
					else
						client:Notify("You're standing too far away to do that.")
						return
					end
				else
					client:Notify("Invalid entity.")
				end
				
			end

		end
	},
	[2] = {
		Name = "Give Money",
		Icon = Material("setorian_interaction_menu/money-bag.png", "noclamp smooth"),
		Func = function(client)
			if (client:GetCharacter()) then

				local eyeTrace = client:GetEyeTrace()

				local eyeEnt = eyeTrace.Entity

				if (eyeEnt:IsPlayer()) then
					
					if (client:GetPos():DistToSqr(eyeEnt:GetPos()) < 5000) then
						netstream.Start(client, "SetorianExtras_GiveMoney")
						return
					else
						client:Notify("You're standing too far away to do that.")
						return
					end
				else
					client:Notify("Invalid entity.")
				end
				
			end
		end
	},
	[3] = {
		Name = "Introduce",
		Icon = Material("setorian_interaction_menu/chat.png", "noclamp smooth"),
		Func = function(client)
			if (client:GetCharacter()) then
				net.Start("ixRecognizeMenu")
				net.Send(client)
			end
		end
	},
	[4] = {
		Name = "Search Body",
		Icon = Material("setorian_interaction_menu/hand.png", "noclamp smooth"),
		Func = function(client)
			
			local eyeTrace = client:GetEyeTrace()

			local entity = eyeTrace.Entity

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
	        	client:Notify("You're standing too far away to do that")
	        	return false
	        end

			if (entity:GetClass() == "prop_ragdoll" and entity.ixInventory and !ix.storage.InUse(entity.ixInventory)) then
				ix.storage.Open(client, entity.ixInventory, {
					entity = entity,
					name = "Corpse",
					searchText = "@searchingCorpse",
					searchTime = ix.config.Get("corpseSearchTime", 1)
				})
			elseif (entity:GetClass() == "prop_ragdoll") then

				if (!entity.ixInventory) then
					client:Notify("This is not a lootable corpse.")
				elseif (ix.storage.InUse(entity.ixInventory)) then
					client:Notify("Someone else is looting these corpse.")
				end

			else
				client:Notify("Invalid entity.")
			end

		end
	},
	[5] = {
		Name = "Check Pulse",
		Icon = Material("setorian_interaction_menu/heart-attack.png", "noclamp smooth"),
		Func = function(client)

			local eyeTrace = client:GetEyeTrace()

			local entity = eyeTrace.Entity

			if (entity:GetClass() != "prop_ragdoll") then return end

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
	        	client:Notify("You're standing too far away to do that")
	        	return false
	        end

			if (entity:GetClass() == "prop_ragdoll") then


				client:SetAction("Checking...", 1)

		        client:DoStaredAction(entity, function()
					
					local text = "Pulse rate of the person: %s"
					local textToNotify

					local pulse

					local PulseName = {
						[1] = "Strong",
						[2] = "Good",
						[3] = "Weak",
						[4] = "No pulse"
					}

					if (entity.ixPlayer) then

						local bodyPly = entity.ixPlayer

						if (bodyPly.ixIsDying) then

							pulse = PulseName[bodyPly:GetNetVar("ply_pulse", 1)]
							textToNotify = string.format(text, pulse)

						else
							textToNotify = "This person is conscious and will get up soon"
						end

					else

						pulse = PulseName[4]
						textToNotify = string.format(text, pulse)

					end


					client:Notify(textToNotify)

				end, 1, function()
					client:SetAction()
				end)

			end

			
		end
	},
	[6] = {
		Name = "Paramedic",
		Icon = Material("setorian_interaction_menu/doctor.png", "noclamp smooth"),
		Func = function(client)


			local eyeTrace = client:GetEyeTrace()

			local entity = eyeTrace.Entity

			if (client:GetCharacter():GetFaction() != FACTION_EMS) then
				client:Notify("You are not EMS")
				return false
			end

			if (entity:GetClass() != "prop_ragdoll") then return end

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
	        	client:Notify("You're standing too far away to do that")
	        	return false
	        end

			if (entity:GetClass() == "prop_ragdoll") then

				if (entity.ixPlayer) then

					local bodyPly = entity.ixPlayer

					if (bodyPly.ixIsDying) then
						netstream.Start(client, "SetorianExtras_OpenMedicUI")
					else
						client:Notify("This person is conscious and will get up soon")
					end

				end

			end
			
		end
	},
	[7] = {
		Name = "Trunk",
		Icon = Material("setorian_interaction_menu/trunk-open.png", "noclamp smooth"),
		Func = function(client)

			local TrunkPlugin = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("trunk_storage") or false

			if (!TrunkPlugin) then return end

			local trace = client:GetEyeTraceNoCursor()
			local ent = trace.Entity
			local dist = ent:GetPos():DistToSqr(client:GetPos())

			-- Validate vehicle
			if (!ent or !ent:IsValid()) then
				return
			end
			if (!ent:IsVehicle()) then
				return client:NotifyLocalized("invalidVehicle")
			end

			local def = TrunkPlugin.vehicles[ent:GetModel():lower()] or TrunkPlugin.vehicles["default"]

			-- Check action criteria
			if (dist > 16384) then
				return client:NotifyLocalized("tooFar")
			end
			if (ent:isLocked()) then
				ent:EmitSound("doors/default_locked.wav")
				return client:NotifyLocalized("trunkLocked")
			end
			
			-- Perform action
			local inventory = ent:GetInv()
			PrintTable(inventory)
			local name = def.name
			ix.storage.Open(client, inventory, {
				name = name,
				entity = ent,
				searchTime = ix.config.Get("containerOpenTime", 0.7),
				-- data = {money = ent:GetMoney()},
				OnPlayerClose = function()
					ix.log.Add(client, "closeContainer", name, inventory:GetID())
				end
			})
			
		end
	},

}

// Libs
ix.util.Include("thirdparty/cl_drawarc.lua")
ix.util.Include("thirdparty/cl_threegrid.lua")

// UI
ix.util.Include("cl_setorian_interaction_menu.lua")

// Functions
ix.util.Include("sh_givemoney_func.lua")
ix.util.Include("sh_frisk_func.lua")

if (SERVER) then

	local PLUGIN = PLUGIN

	netstream.Hook("SetorianInteraction_Choosen", function(ply, num_choosen)

		if (!ply:Alive()) then return end
		if (!ply:GetCharacter()) then return end
        
        if (PLUGIN.Interaction_Functions[num_choosen]) then
			PLUGIN.Interaction_Functions[num_choosen].Func(ply)
		else
			client:Notify("Action doesn't exist")
		end

    end)

end