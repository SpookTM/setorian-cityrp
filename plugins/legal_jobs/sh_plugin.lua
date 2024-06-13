PLUGIN.name = "Legal Jobs"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = "Adds legitimate money making activities"

ALWAYS_RAISED["msystem_wep_controller"] = true
ALWAYS_RAISED["msystem_wep_hook"] = true

if (SERVER) then

	util.AddNetworkString("ixLegalJobs_OpenUI_CityWorkerNPC")

	util.AddNetworkString("ixLegalJobs_CityWorker.Become")
	util.AddNetworkString("ixLegalJobs_CityWorker.Quit")
	util.AddNetworkString("ixLegalJobs_CityWorker.ReceiverPaycheck")
	
	util.AddNetworkString("ixLegalJobs_TowTruck.PayFine")

	util.AddNetworkString("ixLegalJobs_GarbageTruck.Spawn")
	util.AddNetworkString("ixLegalJobs_GarbageTruck.Return")

	util.AddNetworkString("ixLegalJobs_FinalizePayCheck")

	function PLUGIN:LoadData()
		self:LoadJRDumpsters()
		self:LoadJRGaragePlatform()
	end

	function PLUGIN:SaveData()
		self:SaveJRDumpsters()
		self:SaveJRGarbageSpawners()
	end

	function PLUGIN:SaveJRDumpsters()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_ix_dumpster")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_garbage_dumpsters", data)

	end

	
	function PLUGIN:LoadJRDumpsters()

		for _, v in ipairs(ix.data.Get("jr_garbage_dumpsters") or {}) do
			local entity = ents.Create("j_ix_dumpster")

			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()
	
		end
	end

	function PLUGIN:SaveJRGarbageSpawners()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_gtruck_spawner_platform")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_garbage_truck_spawners", data)

	end

	function PLUGIN:LoadJRGaragePlatform()

		ix_garbagetruckspawner_platforms = ix_garbagetruckspawner_platforms or {}

		for _, v in ipairs(ix.data.Get("jr_garbage_truck_spawners") or {}) do
			local entity = ents.Create("j_gtruck_spawner_platform")

			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()


			local phys = entity:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
			ix_garbagetruckspawner_platforms[entity] = true
			
		end
	end

	function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)

		if (client.TakenGarbageTruck) then

			client.TakenGarbageTruck:Remove()
			client.TakenGarbageTruck = nil

		end

	end

	function PLUGIN:PlayerChangedTeam( client, oldTeam, newTeam )

		if (newTeam != FACTION_TRASHCOLLECT) then
			if (client.TakenGarbageTruck) then

				client.TakenGarbageTruck:Remove()
				client.TakenGarbageTruck = nil

			end
		end

	end

	function PLUGIN:CanPlayerHoldObject(client, entity)

		local trashModels = {
			["models/sligwolf/garbagetruck/sw_trashbag_1.mdl"] = true,
			["models/sligwolf/garbagetruck/sw_trashbag_2.mdl"] = true,
			["models/sligwolf/garbagetruck/sw_trashbag_3.mdl"] = true,
		}

		if (entity:GetClass() == "prop_physics") then
			if (trashModels[entity:GetModel()]) then
				return false
			end
		end

	end

	-- function PLUGIN:MSystem:Fine:Sent(pPlayer,pTowed,IntPrice)
	hook.Add( "MSystem:Fine:Sent", "LegalJobs_SentFine_ExtraFunc", function(pPlayer,pTowed,IntPrice) 

		-- pPlayer:GetCharacter():SetMoney(pPlayer:GetCharacter():GetMoney() + math.Round(IntPrice * 0.03, 0))

		pPlayer:GetCharacter():SetData("Paycheck_money_towtruck", pPlayer:GetCharacter():GetData("Paycheck_money_towtruck",0) + math.Round(IntPrice * 0.03, 0))

		local char = pTowed:GetCharacter()

        local ticket_data = os.time() + 604800
        
        local FineData = char:GetData("FineToPay") or {}

        FineData[#FineData+1] = ticket_data

        char:SetData("FineToPay", FineData)

	end)

	net.Receive( "ixLegalJobs_GarbageTruck.Spawn", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		if (char:GetFaction() != FACTION_TRASHCOLLECT) then return end

		if table.Count(ix_garbagetruckspawner_platforms) < 1 then
			client:Notify("There are no platforms spawned")
			return false
		end

		if (IsValid(client.TakenGarbageTruck)) then
			client:Notify("You already picked up the garbage truck.")
			return false
		end

		for k,v in pairs(ix_garbagetruckspawner_platforms) do 
			if k:GetClass() == "j_gtruck_spawner_platform" then

				if (!k:CheckCollision()) then continue end

				local CarClass = "sligwolf_garbagetruck"
				local CarTable = list.Get( "Vehicles" )[ CarClass ]
				local CarE = ents.Create( "prop_vehicle_jeep" );

				for i, v in pairs( CarTable.KeyValues ) do
					CarE:SetKeyValue( i, v );
				end

				CarE:SetPos( k:GetPos() )
				CarE:SetAngles( k:GetAngles() );
				CarE:SetModel( CarTable.Model );
				CarE.GarbagePly = client

				CarE:Spawn();
				CarE:Activate();

				CarE:SetCustomCollisionCheck(true)

	            CarE:SetVehicleClass(CarClass)

	            CarE.VehicleName = CarClass
				CarE.VehicleTable = CarTable

				CarE:CPPISetOwner(client)

				-- gamemode.Call("PlayerSpawnedVehicle", client, CarE) 
				hook.Call("PlayerSpawnedVehicle", nil, client, CarE)


				client.TakenGarbageTruck = CarE

				client:Notify("You successfully spawned a garbage truck.")

				return

			end

		end

		client:Notify("Spawn failed. No available parking space.")

	end)

	net.Receive( "ixLegalJobs_GarbageTruck.Return", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		if (!IsValid(client.TakenGarbageTruck)) then
			client:Notify("You don't have a vehicle to give away")
			return false
		end

		client.TakenGarbageTruck:Remove()
		client.TakenGarbageTruck = nil

		client:Notify("You successfully returned the garbage truck.")

	end)

	net.Receive("ixLegalJobs_TowTruck.PayFine", function( len, client )

		if (!client) then return end
		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		local inv = char:GetInventory()

		local itemDataCheck = {
			CarTicket = true,
		}

		local TicketItem = inv:HasItem("ticket", itemDataCheck)

		local FinePrice = TicketItem:GetData("ticket_price", 0)
		local PayData = TicketItem:GetData("ticket_data", 0)
		local CarEnt = TicketItem:GetData("CarEnt")

		if (char:GetMoney() >= FinePrice) then
		
			char:SetMoney(char:GetMoney() - FinePrice)

			local NewFineData = {}

			for k, v in ipairs(char:GetData("FineToPay")) do

				if (v != PayData) then
					NewFineData[#NewFineData+1] = v
				end

			end

			char:SetData("FineToPay",NewFineData)

			if (IsValid(CarEnt)) then

				MSystem:NetStart("RemoveTowFine", { ent = CarEnt:EntIndex() }, client)

				CarEnt:Fire("TurnOn")
				CarEnt:Fire("Lock")
				CarEnt.tblTowFine = nil

			end

			TicketItem:Remove()

		end

	end)

	net.Receive( "ixLegalJobs_FinalizePayCheck", function( len, client )

		if (!client) then return end
		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		local inv = char:GetInventory()

		local HasItem = inv:HasItem("paycheck")

		if (HasItem) then

			local PayValue = HasItem:GetData("Check_Money",0)

			client:Notify("You cashed a $"..PayValue.." paycheck")

			char:SetMoney(char:GetMoney() + PayValue)

			HasItem:Remove()

		end

		-- if (char:GetData("Paycheck_money",0) > 0) then

		-- 	-- local PayValue = char:GetData("Paycheck_money",0)

		-- 	-- local bSuccess, error = inv:Add("paycheck", 1, {
		--     --     ["Check_Money"] = ,
		--     --     ["Check_Date"] = ,
		--     --     ["Check_Name"] = ,
		--     --     ["Check_Memo"] = ,
		--     -- })

		-- 	-- if (bSuccess) then

		-- 	-- 	Caller:Notify("You cashed a $"..PayValue.." paycheck")

		-- 	-- 	char:SetData("Paycheck_money",0)
		-- 	-- else
		-- 	-- 	Caller:Notify(error)
		-- 	-- end

		-- else
		-- 	Caller:Notify("You don't have a check to cash")
		-- end

	end)

	net.Receive( "ixLegalJobs_CityWorker.Become", function( len, client )

		if (!client) then return end
		if (!client:Alive()) then return end

		local JobType = net.ReadUInt(8)

		-- local NPCEnt = net.ReadEntity()

		-- if (!NPCEnt) or (NPCEnt:GetClass() != "j_cityworker_npc") then
		-- 	return
		-- end

		-- if (client:GetPos():DistToSqr(NPCEnt:GetPos()) > 500*500) then
		-- 	client:Notify("You are too far away from the NPC")
		-- 	return
		-- end

		local char = client:GetCharacter()

		local jobName = team.GetName(JobType)

		if (char:GetFaction() == JobType) then
			client:Notify("You are already a "..jobName)
			return
		end

		if (char:GetFaction() != FACTION_CITIZEN) then
			client:Notify("Your faction does not support this. You must be in Citizen faction to become a "..jobName)
			return
		end

		local faction = ix.faction.indices[JobType]

		char.vars.faction = faction.uniqueID
		char:SetFaction(faction.index)

		if (faction.OnTransferred) then
			faction:OnTransferred(char)
		end

		local worker_sweps = { 
			[FACTION_CITYWORKER] = {"cityworker_pliers", "cityworker_shovel", "cityworker_wrench" },
			[FACTION_TOWTRUCKER] = {"msystem_wep_controller" }
		}

		for k, v in ipairs(worker_sweps[JobType] or {}) do
			client:Give( v )
		end

		client:Notify("You became a "..jobName)

	end)

	net.Receive( "ixLegalJobs_CityWorker.Quit", function( len, client )

		if (!client) then return end
		if (!client:Alive()) then return end

		-- local NPCEnt = net.ReadEntity()

		-- if (!NPCEnt) or (NPCEnt:GetClass() != "j_cityworker_npc") then
		-- 	return
		-- end

		-- if (client:GetPos():DistToSqr(NPCEnt:GetPos()) > 500*500) then
		-- 	client:Notify("You are too far away from the NPC")
		-- 	return
		-- end

		local char = client:GetCharacter()

		-- if (char:GetFaction() != FACTION_CITYWORKER) then
		-- 	client:Notify("You are not a city worker")
		-- 	return
		-- end

		local faction = ix.faction.indices[FACTION_CITIZEN]

		char.vars.faction = faction.uniqueID
		char:SetFaction(faction.index)

		if (faction.OnTransferred) then
			faction:OnTransferred(char)
		end

		local worker_sweps = { "cityworker_pliers", "cityworker_shovel", "cityworker_wrench", "msystem_wep_controller", "msystem_wep_hook" }

		for k, v in ipairs(worker_sweps) do
			client:StripWeapon( v )
		end

		if (IsValid(client.TakenGarbageTruck)) then
			client.TakenGarbageTruck:Remove()
			client.TakenGarbageTruck = nil
		end


		client:Notify("You no longer work in this job")

	end)

	net.Receive( "ixLegalJobs_CityWorker.ReceiverPaycheck", function( len, client )

		if (!client) then return end
		if (!client:Alive()) then return end

		local PayCheckType = net.ReadString()

		local PaycheckMemo = {
			["Paycheck_money_citywork"] = "City Works",
			["Paycheck_money_towtruck"] = "Vehicle towing",
			["Paycheck_money_taxidriver"] = "Taxi transportation",
			["Paycheck_money_garbagecollector"] = "Garbage collection",
		}

		-- local NPCEnt = net.ReadEntity()

		-- if (!NPCEnt) or (NPCEnt:GetClass() != "j_cityworker_npc") then
		-- 	return
		-- end

		-- if (client:GetPos():DistToSqr(NPCEnt:GetPos()) > 500*500) then
		-- 	client:Notify("You are too far away from the NPC")
		-- 	return
		-- end

		local char = client:GetCharacter()
		local inv = char:GetInventory()

		if (char:GetData(PayCheckType,0) > 0) then

			local PayValue = char:GetData(PayCheckType,0)

			local formatTime = "%m/%d/%Y"

			local bSuccess, error = inv:Add("paycheck", 1, {
		        ["Check_Money"] = PayValue,
		        ["Check_Date"] = ix.date.GetFormatted(formatTime),
		        ["Check_Name"] = client:GetCharacter():GetName(),
		        ["Check_Memo"] = PaycheckMemo[PayCheckType],
		    })

			if (bSuccess) then

				client:Notify("You receive a paycheck for $"..PayValue)

				char:SetData(PayCheckType,0)
			else
				client:Notify(error)
			end

		else
			client:Notify("You haven't earned any money to receive a paycheck")
		end

	end)

end

-- if (CLIENT) then

-- 	net.Receive( "ixLegalJobs_OpenUI_CityWorkerNPC", function(  )

-- 		local NPCEnt = net.ReadEntity()

-- 		if (!NPCEnt) or (NPCEnt:GetClass() != "j_cityworker_npc") then
-- 			return
-- 		end

-- 		if (LocalPlayer():GetPos():DistToSqr(NPCEnt:GetPos()) > 500*500) then
-- 			LocalPlayer():Notify("You are too far away from the terminal")
-- 			return
-- 		end

-- 		local pnl = vgui.Create("ixLegalJobs_CityWorkerNPCMenu")
-- 		pnl.NPCEnt = NPCEnt

-- 	end)

-- end