local PLUGIN = PLUGIN
PLUGIN.name = "Police System"
PLUGIN.desc = "Immersive and extensive system for Police Faction"
PLUGIN.author = "JohnyReaper"

ALWAYS_RAISED["weapon_policeshield"] = true
ALWAYS_RAISED["weapon_rpt_surrender"] = true
-- ALWAYS_RAISED["weapon_rpt_cuffed"] = true 
ALWAYS_RAISED["mcd_admintool"] = true


/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
////////////////                                                 ////////////////
////////////////  ░█████╗░░█████╗░███╗░░██╗███████╗██╗░██████╗░  ////////////////
////////////////  ██╔══██╗██╔══██╗████╗░██║██╔════╝██║██╔════╝░  ////////////////
////////////////  ██║░░╚═╝██║░░██║██╔██╗██║█████╗░░██║██║░░██╗░  ////////////////
////////////////  ██║░░██╗██║░░██║██║╚████║██╔══╝░░██║██║░░╚██╗  ////////////////
////////////////  ╚█████╔╝╚█████╔╝██║░╚███║██║░░░░░██║╚██████╔╝  ////////////////
////////////////  ░╚════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░░░░╚═╝░╚═════╝░  ////////////////
////////////////                                                 ////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

PLUGIN.ModelReplaceCitizen = "humans/group01"
PLUGIN.ModelReplacePolice  = "kerry/player/police_usa"

PLUGIN.PoliceRandomModels = {
	"models/kerry/player/police_usa/male_01.mdl",
	"models/kerry/player/police_usa/male_02.mdl",
	"models/kerry/player/police_usa/male_03.mdl",
	"models/kerry/player/police_usa/male_04.mdl",
	"models/kerry/player/police_usa/male_05.mdl",
	"models/kerry/player/police_usa/male_06.mdl",
	"models/kerry/player/police_usa/male_07.mdl",
	"models/kerry/player/police_usa/male_08.mdl",
	"models/kerry/player/police_usa/male_09.mdl",
}

PLUGIN.PoliceRankGroup = "NYPD" -- the name of the group that was set in the advanced rank system

PLUGIN.MaxBailValue = {
	["Inspector"] = 150,  -- $150 000
	["Bureau Chief"] = 140,
	["Assistant Chief"] = 120,
	["Deputy Chief"] = 110,
	["Sergeant"] = 100,
	["Police Officer"] = 50,
}

PLUGIN.WeaponsClass1 = {
	["arccw_ud_glock"] = true,
	["arccw_p228"] = true,
	["arccw_mw3e_anaconda"] = true,
	["arccw_makarov"] = true,
	["arccw_mw3e_p99"] = true,
	["arccw_p228"] = true,
}

PLUGIN.WeaponsClass3 = {
	["arccw_go_aug"] = true,
	["arccw_ud_870"] = true,
	["arccw_ud_m16"] = true,
	["arccw_cod4e_g36c"] = true,
}

PLUGIN.WeaponsAllowedInPrison = {
	["shiv"] = true,
}

PLUGIN.CarsWithLaptop = {
	["charger12poltdm"] = true,
	["for_crownvic_fh3tdm"] = true,
	["forcrownvicpoltdm"] = true,
	["chargersrt8poltdm"] = true,
	["fortauruspoltdm"] = true,
	["hsvw427poltdm"] = true,
	["lex_is300poltdm"] = true,
	["mereclasspoltdm"] = true,
	["mitsuevoxpoltdm"] = true,
}

-- What items can be given to evidence npc
PLUGIN.IllegalItems = {
	["cocaine_dryingrack"] = true,
	["cocaine_bag"] = true,
	["cocaine_brick"] = true,
	["cocaine_bag_empty"] = true,
	["plant_pot"] = true,
	["coca_seed"] = true,
	["coca_leaves"] = true,
	["blind_fold"] = true,
	["psychedelics_mushroom"] = true,
	["psychedelics_spores"] = true,
	["psychedelics_lysergic_acid"] = true,
	["psychedelics_box"] = true,
	["psychedelics_diethylamine"] = true,
	["psychedelics_flask"] = true,
	["psychedelics_hexane"] = true,
	["psychedelics_blotter_25sheet"] = true,
	["psychedelics_blotter_5sheet"] = true,
	["psychedelics_blotter_5sheet"] = true,
	["psychedelics_substrate"] = true,
	["psychedelics_phosphorus_pentachloride"] = true,
	["psychedelics_phosphorus_oxychloride"] = true,
	["blowtorch"] = true,
	["gasmask"] = true,
	["acetone"] = true,
	["bismuth"] = true,
	["meth_pipe_empty"] = true,
	["meth_pipe"] = true,
	["methtray_empty"] = true,
	["phosphoric"] = true,
	["meth_bag"] = true,
	["meth_freezer"] = true,
	["meth_recipe"] = true,
	["meth_stove"] = true,
	["methtray"] = true,
	["methtray_smash"] = true,
	["weed_brick"] = true,
	["weed_blunt"] = true,
	["weed_bag"] = true,
	["weed1_bag_empty"] = true,
	["bobbypin"] = true,
	["wirecutter"] = true,
	["zip_tie"] = true,
	["gun_file"] = true,
	["weed_bud"] = true,
	["drillbag"] = true,
	["duffelbag"] = true,	
}

PLUGIN.Contraband = {  --  Items that can be found by searching the prison bed
	["rag"] = 20,      --  20%
	["glass_piece"] = 15,--15%
}

PLUGIN.PoliceEQVendor = {
	{
		AItem = "pistol_box",
		APrice = 200,
		IsAmmo = true,
	},
	{
		AItem = "pistol_mag",
		APrice = 100,
		IsAmmo = true,
	},
	{
		AItem = "buckshot_box",
		APrice = 200,
		IsAmmo = true,
	},
	{
		AItem = "pistol",
		APrice = 400,
	},
	{
		AItem = "arccw_famas",
		APrice = 1000,
		Jobs = {       // If there is no this table then the item is available to any police officer
			[FACTION_SWAT] = true,
		}
	},
}

PLUGIN.PoliceCarVendor = {
	[1] = {
		CarEnt = "charger12poltdm",
		IsTaken = false,
	},
	[2] = {
		CarEnt = "for_crownvic_fh3tdm",
		Fuel = 20,
		Skin = 1,
		BodyGroups = {
			["[EM] Mirrors"] = 1,
			["[EM] Cage"] = 1,
			["Front Door Panels"] = 1,
			["Rear Door Panels"] = 1,
			["Trunk Panel"] = 1,
			["[EM] Light Bars"] = 2
		},
		IsTaken = false,
	},
	[3] = {
		CarEnt = "forcrownvicpoltdm",
		--Fuel = 15, -- commented means that the fuel tank will be full and you don't need to know its capacity
		Skin = 1,
		BodyGroups = {
			["grille leds"] = 1,
			["spotlights"] = 2,
			["trunk badge"] = 1,
		},
		IsTaken = false,
	},
	[4] = {
		CarEnt = "forcrownvicpoltdm",
		Fuel = 20,
		Skin = 2,
		BodyGroups = {
			["grille leds"] = 1,
			["spotlights"] = 2,
			["trunk badge"] = 1,
		},
		IsTaken = false,
	},

}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

ix.util.Include("sh_meta.lua", "shared")
ix.util.Include("libraries/sh_fn.lua", "shared")
ix.util.Include("libraries/cl_imgur.lua", "client")

ix.util.Include("cl_hudoverlay.lua")

PLUGIN.GlobalWeaponsData = {}
PLUGIN.GlobalCasesData = {}

function PLUGIN:InitializedPlugins()

	timer.Simple(10, function()

		local PLUGINCloth = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_clothingshop_system") or false

		if (PLUGINCloth) then

			local pacs = {
				[1] = {
					pac = "clothingstore_police_outfit",
					name = "Police Outfit",
				},
				[2] = {
					pac = "clothingstore_police_fbi_outfit",
					name = "FBI Outfit",
				},
				[3] = {
					pac = "clothingstore_swat_outfit",
					name = "SWAT Outfit",
				},
			}

			for i=1, #pacs do

				local uniqID = pacs[i].pac
				local nameFit = pacs[i].name

				local Appearance = {
					Pac = uniqID,

					BodyGroups = {
						["foot"] = 1,
						["body"] = 1,
						["leg"] = 1,
					}
				}

				local ITEM = ix.item.Register(uniqID, "base_store_clothing", false, nil, true)
		        ITEM.name = nameFit
		        ITEM.description = ""
		        ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
		        ITEM.width = 1
		        ITEM.height = 1
		        ITEM.category = "Clothing"
		        ITEM.outfitCategory = "outfit"
		        ITEM.noBusiness = true

		        for ApperaType, ApperaData in pairs(Appearance) do
		        	

		        	if (ApperaType == "BodyGroups") then

		        		ITEM.bodyGroups = {}

		        		for bodyName, bodyValue in pairs(ApperaData) do
		        			ITEM.bodyGroups[bodyName] = bodyValue
		        		end

		        	end

		        	if (ApperaType == "Pac") then
		        		ITEM.pacData = PLUGINCloth.PacDatabase[ApperaData]
		        		-- ix.pac.list["clothingstore_"..uniqueid] = self.PacDatabase[ApperaData]
		        		ix.pac.RegisterPart(uniqID,PLUGINCloth.PacDatabase[ApperaData])
		        	end

		        end

		    end
	        
	    end

	end)

	for _, v in pairs(ix.item.list) do
		if (!v.isWeapon) then continue end
		if (v.isArcCW) then continue end

		if (!PLUGIN.WeaponsClass1[v.uniqueID]) and (!PLUGIN.WeaponsClass3[v.uniqueID]) then continue end

		if CLIENT then
			function v:PopulateTooltip(tooltip)
				local serial_number = self:GetData("serial_number", 0)

				if (serial_number == 0) then return end

				local panel = tooltip:AddRowAfter("name", "serial_number")
				panel:SetBackgroundColor(Color(39, 174, 96))
				panel:SetText("Serial Number: "..serial_number)
				panel:SizeToContents()

				
			end

		end

		function v:OnInstanced(invID, x, y)

			local randNum = math.random(1, 99999)

			local amount = math.max(1, 5 - string.len(randNum))
			local number =  string.rep("", amount)..tostring(randNum)


			self:SetData("serial_number", number)

		end

		function v:OnRemoved()

			if (PLUGIN.GlobalWeaponsData[self:GetData("serial_number", "0")]) then
				PLUGIN.GlobalWeaponsData[self:GetData("serial_number", "0")] = nil
				print("Weapon ["..v:GetName().."] was removed from database")
				PLUGIN:SaveGlobalWeaponBase()
			end

		end

	end

end

if (SERVER) then

	util.AddNetworkString("ixPoliceSys_OpenWepUI")
	util.AddNetworkString("ixPoliceSys_WepUpdate")

	util.AddNetworkString("ixPoliceSys_OpenEQUI")

	util.AddNetworkString("ixPoliceSys_OpenLaptopUI")

	util.AddNetworkString("ixPoliceSys_RequestData")
	util.AddNetworkString("ixPoliceSys_RenderPersonProfile")

	util.AddNetworkString("ixPoliceSys_RemoveCuffedItem")

	util.AddNetworkString("ixPoliceSys_OpenGarageUI")
	util.AddNetworkString("ixPoliceSys_Update_GarageCars")
	util.AddNetworkString("ixPoliceSys_TakePoliceCar")
	util.AddNetworkString("ixPoliceSys_ReturnPoliceCar")

	util.AddNetworkString("ixPoliceSys_BuyExtraItem")

	util.AddNetworkString("ixPoliceSys_CreateNewCase")
	util.AddNetworkString("ixPoliceSys_SyncCases")
	util.AddNetworkString("ixPoliceSys_UpdateCase")
	util.AddNetworkString("ixPoliceSys_CloseCase")
	util.AddNetworkString("ixPoliceSys_ClaimCase")
	util.AddNetworkString("ixPoliceSys_SendCaseInUse")

	net.Receive( "ixPoliceSys_RenderPersonProfile", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		if (!client:isPolice()) then return end
		-- if (!char:GetData("IsPoliceOfficer", false)) then return end

		local target = net.ReadEntity()

		if (!target) then return end
		if (!target:IsPlayer()) then return end

		local targetChar = target:GetCharacter()

		if (!targetChar) then return end

		local RealisticPoliceFil = file.Read("realistic_police/record/"..targetChar:GetID()..".txt", "DATA") or ""
	    local CompressTable = util.Compress(RealisticPoliceFil)

	    net.Start("ixPoliceSys_RenderPersonProfile")
	        net.WriteInt(CompressTable:len(), 32)
	        net.WriteData(CompressTable, CompressTable:len())
	        net.WriteEntity(target)
	    net.Send(client)

	end)

	net.Receive( "ixPoliceSys_CreateNewCase", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end
		if (!client:isPolice()) then return end
		-- if (!char:GetData("IsPoliceOfficer", false)) then return end

		local randNum = math.random(1, 99999)

		local amount = math.max(1, 5 - string.len(randNum))
		local CaseID =  string.rep("", amount)..tostring(randNum)

		while(PLUGIN.GlobalCasesData[CaseID]) do

			randNum = math.random(1, 99999)

			amount = math.max(1, 5 - string.len(randNum))
			CaseID =  string.rep("1", amount)..tostring(randNum)

		end

		CaseID = tonumber(CaseID)

		-- PLUGIN.GlobalCasesData[#PLUGIN.GlobalCasesData + 1] = {
		PLUGIN.GlobalCasesData[CaseID] = {
			CTitle = "New Case",
			CCreateTime = math.floor(os.time()),
			CSubBy = char:GetName(),
			Brief = "Write something about this case here",
			Details = {
				["Evidences"] = {},
				["Officers"] = {},
				["Suspects"] = {},
				["Victims"] = {},
			}
		}


		local PoliceOfficers = {}

		for Otherclient, character in ix.util.GetCharacters() do

			if (Otherclient == client) then continue end

			if (!Otherclient:isPolice()) then continue end
			-- if (!character:GetData("IsPoliceOfficer", false)) then continue end

			PoliceOfficers[#PoliceOfficers+1] = Otherclient

		end

		local dataToJson = util.TableToJSON(PLUGIN.GlobalCasesData)

		net.Start("ixPoliceSys_SyncCases")
			net.WriteString(dataToJson)
		net.Send(PoliceOfficers)

		net.Start("ixPoliceSys_RequestData")
			net.WriteString(dataToJson)
			net.WriteString("cases")
		net.Send(client)

		client:Notify("Case create successfully")

	end)

	net.Receive( "ixPoliceSys_UpdateCase", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		if (!client:isPolice()) then return end
		-- if (!char:GetData("IsPoliceOfficer", false)) then return end

		local CaseID = net.ReadUInt(17)

		if (!PLUGIN.GlobalCasesData[CaseID]) then 
			client:Notify("Case with the given id does not exist")
		return end

		local CaseNewDataJSON = net.ReadString()

		local CaseNewData = util.JSONToTable(CaseNewDataJSON)

		if (!istable(CaseNewData)) then 
			client:Notify("Invalid case data")
		return end

		PLUGIN.GlobalCasesData[CaseID] = CaseNewData

		-- PrintTable(PLUGIN.GlobalCasesData)

		client:Notify("Changes were saved successfully")

	end)

	net.Receive( "ixPoliceSys_CloseCase", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		if (!client:isPolice()) then return end
		-- if (!char:GetData("IsPoliceOfficer", false)) then return end

		local CaseID = net.ReadUInt(17)


		if (!PLUGIN.GlobalCasesData[CaseID]) then 
			client:Notify("Case with the given id does not exist")
		return end

		-- table.remove(PLUGIN.GlobalCasesData, CaseID)
		PLUGIN.GlobalCasesData[CaseID] = nil

		local PoliceOfficers = {}

		for Otherclient, character in ix.util.GetCharacters() do

			if (Otherclient == client) then continue end

			if (!Otherclient:isPolice()) then continue end
			-- if (!character:GetData("IsPoliceOfficer", false)) then continue end

			PoliceOfficers[#PoliceOfficers+1] = Otherclient

		end

		local dataToJson = util.TableToJSON(PLUGIN.GlobalCasesData)

		net.Start("ixPoliceSys_SyncCases")
			net.WriteString(dataToJson)
		net.Send(PoliceOfficers)

		client:Notify("The case was closed successfully")

	end)

	net.Receive( "ixPoliceSys_ClaimCase", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		if (!client:isPolice()) then return end
		-- if (!char:GetData("IsPoliceOfficer", false)) then return end

		local StateProf = net.ReadBool()
		local CaseID = net.ReadUInt(17)

		if (!PLUGIN.GlobalCasesData[CaseID]) then 
			client:Notify("Case with the given id does not exist")
		return end

		local PoliceOfficers = {}

		for Otherclient, character in ix.util.GetCharacters() do

			if (Otherclient == client) then continue end
			if (!Otherclient:isPolice()) then continue end
			-- if (!character:GetData("IsPoliceOfficer", false)) then continue end

			PoliceOfficers[#PoliceOfficers+1] = Otherclient

		end

		net.Start("ixPoliceSys_SendCaseInUse")
			net.WriteBool(StateProf)
			net.WriteUInt(CaseID, 17)
		net.Send(PoliceOfficers)

	end)

	net.Receive( "ixPoliceSys_RequestData", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local RequestType = net.ReadString()

		local dataToJson

		if (RequestType == "guns") then
			dataToJson = util.TableToJSON(PLUGIN.GlobalWeaponsData)
		elseif (RequestType == "cases") then
			dataToJson = util.TableToJSON(PLUGIN.GlobalCasesData)
		end

		net.Start("ixPoliceSys_RequestData")
			net.WriteString(dataToJson)
			net.WriteString(RequestType)
		net.Send(client)

	end)

	net.Receive( "ixPoliceSys_WepUpdate", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local inv = char:GetInventory()

		if (!inv) then return end

		local itemID = net.ReadUInt(12)

		local menuType = net.ReadString()

		local wepsType = {}

		if (menuType == "class1") then
			wepsType = PLUGIN.WeaponsClass1
		elseif (menuType == "class3") then
			wepsType = PLUGIN.WeaponsClass3
		elseif (menuType == "removenumbers") then
			local MergedTable = PLUGIN.WeaponsClass1

			for k, v in pairs(PLUGIN.WeaponsClass3) do
				MergedTable[k] = v
			end

			wepsType = MergedTable
		else
			client:Notify("Invalid class table")
			return
		end

		local item = inv:GetItemByID(itemID)

		if (item) then

			if (!wepsType[item.uniqueID]) then
				client:Notify("You cannot register or remove the serial number from this weapon")
				return
			end

			if (!item.isWeapon) then 
				client:Notify("Item is not a weapon")
			return end
			if (item:GetData("claimed", false)) and (menuType != "removenumbers") then 
				client:Notify("This weapon has already been registered or does not have a serial number")
			return end

			item:SetData("claimed", char:GetID())

			if (menuType == "removenumbers") then
				item:SetData("serial_number", "0")
				client:Notify("You removed the serial number")
			else

				if (item:GetData("serial_number", "0") == "0") then
					local randNum = math.random(1, 99999)

					local amount = math.max(1, 5 - string.len(randNum))
					local number =  string.rep("", amount)..tostring(randNum)


					item:SetData("serial_number", number)

				end

				PLUGIN.GlobalWeaponsData[item:GetData("serial_number", "0")] = {
					ItemName = item:GetName(),
					ItemModel = item:GetModel(),
					Owner = item:GetData("claimed"),
					OwnerName = char:GetName()
				}

				PLUGIN:SaveGlobalWeaponBase()

			
				client:Notify("You registered the weapon")
			end
		end

	end)

	net.Receive( "ixPoliceSys_BuyExtraItem", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end
		if (!client:isPolice()) then return end

		local itemID = net.ReadUInt(8)

		local VendorData = PLUGIN.PoliceEQVendor[itemID]

		if (VendorData.Jobs) then
			if (!VendorData.Jobs[char:GetFaction()]) then
				client:NotifyLocalized("noPerm")
				return
			end
		end

		if (char:GetMoney() >= VendorData.APrice) then

			local itemData = ix.item.list[VendorData.AItem]

			if (!itemData) then
				client:Notify("This item doesn't exists")
				return
			end

			local itemPrice = VendorData.APrice

			local inv = char:GetInventory()

			local isSuce, errormsg = inv:Add(VendorData.AItem)

			if (!isSuce) then
                client:Notify(errormsg)
                return false
            end

            char:SetMoney(char:GetMoney() - itemPrice)

            client:Notify("You have purchased the "..itemData.name.." for "..ix.currency.Get(itemPrice))

		else
			client:Notify("You can't afford this item")
		end

	end)


	net.Receive( "ixPoliceSys_TakePoliceCar", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end
		if (!client:isPolice()) then return end
		-- if (!char:GetData("IsPoliceOfficer", false)) then return end


		if table.Count(ix_policespawner_platforms) < 1 then
			client:Notify("There are no platforms spawned")
			return false
		end

		if IsValid(client.TakenCar) then
			client:Notify("You already picked up the police car")
			return false
		end

		local selected_car = net.ReadUInt(6)

		local car_data = PLUGIN.PoliceCarVendor[selected_car]

		if (!car_data) then
			client:Notify("Car data doesn't exists")
		return end

		if (car_data.IsTaken) then
			client:Notify("This car is already taken")
		return end

		for k,v in pairs(ix_policespawner_platforms) do 
			if k:GetClass() == "j_police_spawner_platform" then

				if(!k:CheckCollision()) then continue end

				local CarClass = car_data.CarEnt
				local CarTable = list.Get( "Vehicles" )[ CarClass ]
				local CarE = ents.Create( "prop_vehicle_jeep" );

				for i, v in pairs( CarTable.KeyValues ) do
					CarE:SetKeyValue( i, v );
				end

				CarE:SetPos( k:GetPos() )
				CarE:SetAngles( k:GetAngles() );
				CarE:SetModel( CarTable.Model )

				CarE:Spawn()
	            CarE:Activate()
	            CarE:SetCustomCollisionCheck(true)

	            CarE:SetVehicleClass(CarClass)

				CarE:SetSkin( car_data.Skin or 0 )
				CarE.TakenSlot = selected_car
				CarE.PoliceOfficer = client

				for k, v in pairs(car_data.BodyGroups or {}) do
	        		
	        		local bodyID = CarE:FindBodygroupByName( k )

	        		if (bodyID) then
	        			CarE:SetBodygroup(bodyID,v)
	        		end

	        	end

	        	CarE:CallOnRemove("release_slot", function(ent)

					local car_data = PLUGIN.PoliceCarVendor[ent.TakenSlot]
					if (car_data) then
						car_data.IsTaken = false

						if (car_data.Fuel) then
							car_data.Fuel = ent:VC_fuelGet(false)
						end

					end

					if (IsValid(ent.PoliceOfficer)) then
						ent.PoliceOfficer.TakenCar = nil
					end

				end)

				CarE.VehicleName = CarClass
				CarE.VehicleTable = CarTable
				-- CarE:Spawn()
				-- CarE:Activate()

				CarE:CPPISetOwner(client)

				if (car_data.Fuel) then
					timer.Simple(1,function()
					if (!IsValid(CarE)) then return end
					CarE:VC_fuelSet(car_data.Fuel)
					end)
				end

				car_data.IsTaken = true

				-- gamemode.Call("PlayerSpawnedVehicle", client, CarE) 
				hook.Call("PlayerSpawnedVehicle", nil, client, CarE)

				client.TakenCar = CarE

				local CarsTable = PLUGIN:PrepareCarVendorData()

				if (CarsTable) then

					net.Start("ixPoliceSys_OpenGarageUI")

					net.WriteUInt(#CarsTable, 6)

					for k, v in ipairs(CarsTable) do
						
						net.WriteString(v.CarModel)
						net.WriteString(v.CarName)
						net.WriteBool(v.CarTaken)

					end

					net.Send(client)

					client:Notify("You successfully spawned a police vehicle.")

				end

				return

			end

		end

		client:Notify("Spawn failed. No available parking space.")

	end)

	net.Receive( "ixPoliceSys_ReturnPoliceCar", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		if (!IsValid(client.TakenCar)) then
			client:Notify("You don't have a vehicle to give away")
			return false
		end

		local CarDist = client:GetPos():DistToSqr(client.TakenCar:GetPos())

		if (CarDist > 4000*4000) then
			client:Notify("The vehicle is too far away")
			return false
		end

		client.TakenCar:Remove()
		client.TakenCar = nil

		client:Notify("You successfully returned the police vehicle.")

	end)

	net.Receive( "ixPoliceSys_Update_GarageCars", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local CarsTable = PLUGIN:PrepareCarVendorData()

		-- local TblToJson = util.TableToJSON(CarsTable)
		-- net.Start("ixPoliceSys_OpenGarageUI")
		-- net.WriteString(TblToJson)

		if (CarsTable) then
			net.Start("ixPoliceSys_OpenGarageUI")

			net.WriteUInt(#CarsTable, 6)

			for k, v in ipairs(CarsTable) do
				
				net.WriteString(v.CarModel)
				net.WriteString(v.CarName)
				net.WriteBool(v.CarTaken)

			end

			net.Send(client)

			client:Notify("The list has been updated successfully")
		end


	end)

	//86400
	timer.Create("PayFine_Checker", 3600, 0, function()
	    print("[Setorian Police System] Checking whether players have paid their fines")


	    for client, character in ix.util.GetCharacters() do

	    	if (!character:GetData("FineToPay")) then continue end
	    	if (table.IsEmpty(character:GetData("FineToPay"))) then continue end
			
	    	if (character:GetData("FineToPay")[1] <= os.time()) then

	    		client:Notify("You haven't paid the fine within 7 days of receiving it so you are wanted")

	    		character:SetWanted("Failure to pay fines")

	    		character:SetData("FineToPay", nil)

	    		local Table = {
	                Date = os.date("%d/%m/%Y", os.time()),
	                Motif = "Failure to pay fines", 
	            }
	            
	            -- Add autaumatically a penalty on the criminal record  
	            Realistic_Police.AddCriminalRecord(client, Table)

	    		print("[Setorian Police System] "..character:GetName().." failed to pay fines")

	    	else

	    		local TimeString = os.date( "%H:%M:%S - %m/%d/%Y" , character:GetData("FineToPay")[1] )

	    		print("[Setorian Police System] "..character:GetName().." - Need pay before: "..TimeString)

	    	end

		end

		print("[Setorian Police System] Checking Finished")

	end)

	function PLUGIN:PrepareCarVendorData()

		local CarsTable = {}

		for k, v in ipairs(PLUGIN.PoliceCarVendor) do

			local carTable = list.Get( "Vehicles" )[ v.CarEnt ]

			if (!carTable) then
				ErrorNoHalt("Vehicle with class: "..v.CarEnt.." cannot be found. It has probably not been installed on the server")
				return false
			end

			CarsTable[#CarsTable+1] = {
				CarName = carTable.Name,
				CarModel = carTable.Model,
				CarTaken = v.IsTaken
			}

		end

		return CarsTable

	end

	function PLUGIN:LoadData()
		// Ents
		self:LoadJREvidenceNPC()
		self:LoadJRPoliceLocker()
		self:LoadJRGarageNPC()
		self:LoadRTicketNPC()
		self:LoadJRGaragePlatform()
		self:LoadJRPrisonBeds()
		self:LoadJREqNPC()

		// Database
		self:LoadGlobalWeaponBase()
		self:LoadGlobalCasesBase()

	end

	function PLUGIN:SaveData()
		// Ents
		self:SaveJREvidenceNPC()
		self:SaveJRPoliceLocker()
		self:SaveJRFBILocker()
		self:SaveJRSwatLocker()
		self:SaveJRGarageNPC()
		self:SaveJRTicketNPC()
		self:SaveJRGaragePlatform()
		self:SaveJRPrisonBeds()
		self:SaveJREqNPC()
		
		// Database
		self:SaveGlobalWeaponBase()
		self:SaveGlobalCasesBase()
	
	end

	function PLUGIN:SaveGlobalWeaponBase()

		local data = PLUGIN.GlobalWeaponsData or {}

		ix.data.Set("jr_police_weapon_database", data)

	end

	function PLUGIN:LoadGlobalWeaponBase()

		local data = ix.data.Get("jr_police_weapon_database") or {}

		PLUGIN.GlobalWeaponsData = data

	end

	function PLUGIN:SaveGlobalCasesBase()

		local data = PLUGIN.GlobalCasesData or {}

		ix.data.Set("jr_police_cases_database", data)

	end

	function PLUGIN:LoadGlobalCasesBase()

		local data = ix.data.Get("jr_police_cases_database") or {}

		PLUGIN.GlobalCasesData = data

	end

	function PLUGIN:SaveJREvidenceNPC()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_police_evidence_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_evidence_npcs", data)

	end

	function PLUGIN:LoadJREvidenceNPC()
		for _, v in ipairs(ix.data.Get("jr_evidence_npcs") or {}) do
			local npc = ents.Create("j_police_evidence_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

	function PLUGIN:SaveJREqNPC()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_police_eq_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_eq_npcs", data)

	end

	function PLUGIN:LoadJREqNPC()
		for _, v in ipairs(ix.data.Get("jr_eq_npcs") or {}) do
			local npc = ents.Create("j_police_eq_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

	function PLUGIN:SaveJRGarageNPC()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_police_garage_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_garage_npcs", data)

	end

	function PLUGIN:LoadJRGarageNPC()
		for _, v in ipairs(ix.data.Get("jr_garage_npcs") or {}) do
			local npc = ents.Create("j_police_garage_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

	function PLUGIN:SaveJRTicketNPC()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_police_fine_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_ticket_npcs", data)

	end

	function PLUGIN:LoadRTicketNPC()
		for _, v in ipairs(ix.data.Get("jr_ticket_npcs") or {}) do
			local npc = ents.Create("j_police_fine_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

	function PLUGIN:SaveJRGaragePlatform()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_police_spawner_platform")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_garage_platforms", data)

	end

	
	function PLUGIN:LoadJRGaragePlatform()

		ix_policespawner_platforms = ix_policespawner_platforms or {}

		for _, v in ipairs(ix.data.Get("jr_garage_platforms") or {}) do
			local entity = ents.Create("j_police_spawner_platform")

			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()


			local phys = entity:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
			ix_policespawner_platforms[entity] = true
			
		end
	end

	function PLUGIN:SaveJRPrisonBeds()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_policestuff_jailbed")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_prison_beds", data)

	end

	function PLUGIN:LoadJRPrisonBeds()
		for _, v in ipairs(ix.data.Get("jr_prison_beds") or {}) do
			local entity = ents.Create("j_policestuff_jailbed")

			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()

			local phys = entity:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
		end
	end

	function PLUGIN:SaveJRPoliceLocker()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_policestuff_locker")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_police_lockers", data)

	end

	function PLUGIN:SaveJRFBILocker()

		local data = {}

		for _, v in ipairs(ents.FindByClass("j_policestuff_locker_fbi")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_fbi_lockers", data)

	end

	function PLUGIN:SaveJRSwatLocker()

		local data = {}

		for _, v in ipairs(ents.FindByClass("j_policestuff_locker_swat")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_swat_lockers", data)

	end

	function PLUGIN:LoadJRPoliceLocker()
		for _, v in ipairs(ix.data.Get("jr_police_lockers") or {}) do
			local locker = ents.Create("j_policestuff_locker")

			locker:SetPos(v[1])
			locker:SetAngles(v[2])
			locker:Spawn()

			local phys = locker:GetPhysicsObject()

			if (IsValid(phys)) then
				phys:EnableMotion(false)
			end
			
		end

		for _, v in ipairs(ix.data.Get("jr_fbi_lockers") or {}) do
			local locker = ents.Create("j_policestuff_locker_fbi")

			locker:SetPos(v[1])
			locker:SetAngles(v[2])
			locker:Spawn()

			local phys = locker:GetPhysicsObject()

			if (IsValid(phys)) then
				phys:EnableMotion(false)
			end
			
		end

		for _, v in ipairs(ix.data.Get("jr_swat_lockers") or {}) do
			local locker = ents.Create("j_policestuff_locker_swat")

			locker:SetPos(v[1])
			locker:SetAngles(v[2])
			locker:Spawn()

			local phys = locker:GetPhysicsObject()

			if (IsValid(phys)) then
				phys:EnableMotion(false)
			end
			
		end

	end

	function PLUGIN:OnReloaded()

		self:LoadGlobalWeaponBase()
		print("Weapon database restored after reload")

		self:LoadGlobalCasesBase()
		print("Cases database restored after reload")
		-- PrintTable(PLUGIN.GlobalWeaponsData)

	end

	-- function PLUGIN:PlayerSpawnedVehicle(client, entity)
	-- 	-- entity:SetNetVar("ownerName", client:GetCharacter():GetName())
	-- 	entity:keysOwn(client)

	-- 	if (simfphys) and (simfphys.IsCar(entity)) then
	-- 		entity:SetNetVar("simf_veh_class",entity.VehicleName)
	-- 	end

	-- end

	function PLUGIN:PlayerButtonDown( client, key )

		if (!client:InVehicle()) then return end

		if (IsValid(client:GetVehicle())) then

			if IsValid(client:GetVehicle():GetParent()) then 
				if (!self.CarsWithLaptop[client:GetVehicle():GetParent().VehicleName]) then return end
			else
				if (!self.CarsWithLaptop[client:GetVehicle().VehicleName]) then return end
			end

		end

		if (key == KEY_B) then
			
			-- local char = client:GetCharacter()
			if (!client:isPolice()) then return end
			-- if (!char:GetData("IsPoliceOfficer", false)) then return end

			if (!client.ixPoliceDuty) then
				client:Notify("You can't do it because you're not on duty.")
				return
			end

			net.Start("ixPoliceSys_OpenLaptopUI")
			net.Send(client)

		end

	end

	function PLUGIN:PlayerEnteredVehicle( client, veh )
		
		if (!IsValid(client)) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		if ( !IsValid( veh ) or !veh:IsVehicle() ) then return end
		if (!client:isPolice()) then return end
		-- if (!char:GetData("IsPoliceOfficer", false)) then return end

		if (!client.ixPoliceDuty) then return end

		if IsValid(client:GetVehicle():GetParent()) then 
			if (!self.CarsWithLaptop[client:GetVehicle():GetParent().VehicleName]) then return end
		else
			if (!self.CarsWithLaptop[client:GetVehicle().VehicleName]) then return end
		end
		
		if ((client.PoliceTabletReminder or 0) < CurTime()) then
			client:PrintMessage( HUD_PRINTTALK, "Press B to open the police laptop." )
			client.PoliceTabletReminder = CurTime() + 3
		end
		
	end 

	function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)

		local PLUGINEmergency = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_aphone_app") or false

		if (currentChar and currentChar:GetFaction() == FACTION_POLICE) or (character and character:GetFaction() == FACTION_POLICE) then

			client.ixPoliceDuty = false

			local char

			if (currentChar) then
				char = currentChar
			elseif (character) then
				char = character
			else
				return
			end

			local inv = char:GetInventory()

			local faction = ix.faction.indices[FACTION_CITIZEN]
			-- local modelReplace2 = self.ModelReplaceCitizen
			-- local modelReplace1 = self.ModelReplacePolice

			local armorsItems = {
	        	["police_armor"] = true,
	        	["police_badge"] = true,
	        	["police_helmet"] = true,
	        	["clothingstore_police_ouffit"] = true,
	        	["clothingstore_police_fbi_outfit"] = true,
	        	["clothingstore_swat_outfit"] = true,
	        }

	        for armorID, _ in pairs(armorsItems) do

	        	local armorItem = inv:HasItem(armorID)
	        	
		        if (!client.ixPoliceDuty) and (armorItem) then
		        	armorItem:Remove()
		        end

	        end

			char.vars.faction = faction.uniqueID
			char:SetFaction(faction.index)

			if (faction.OnTransferred) then
				faction:OnTransferred(char)
			end

			-- currentChar:SetModel(currentChar:GetModel():gsub(modelReplace1, modelReplace2))

			if (PLUGINEmergency) then
				PLUGINEmergency:CheckForEmergencyUI(client)
			end

		-- elseif (character and character:GetFaction() == FACTION_POLICE) then

		-- 	client.ixPoliceDuty = false

		-- 	local faction = ix.faction.indices[FACTION_CITIZEN]
		-- 	local modelReplace2 = self.ModelReplaceCitizen
		-- 	local modelReplace1 = self.ModelReplacePolice

		-- 	character.vars.faction = faction.uniqueID
		-- 	character:SetFaction(faction.index)

		-- 	if (faction.OnTransferred) then
		-- 		faction:OnTransferred(character)
		-- 	end

		-- 	character:SetModel(character:GetModel():gsub(modelReplace1, modelReplace2))

		-- 	if (PLUGINEmergency) then
		-- 		PLUGINEmergency:CheckForEmergencyUI(client)
		-- 	end

		end



		client:SetNetVar("PoliceOfficer_Net", character:GetData("IsPoliceOfficer", false))

		if (!client:GetNetVar("PoliceOfficer_Net", false)) then
			client:SetNetVar("PoliceOfficer_Net", character:GetData("IsPoliceFBI", false))
		end

		if (!client:GetNetVar("PoliceOfficer_Net", false)) then
			client:SetNetVar("PoliceOfficer_Net", character:GetData("IsPoliceSWAT", false))
		end

		if (client.TakenCar) then

			client.TakenCar:Remove()
			client.TakenCar = nil

		end

		ModernCarDealer:RefreshPlayerVehicle(client)

		if (currentChar) then
			if (currentChar:GetData("rpt_arrest_time")) then
				currentChar:SetData("rpt_arrest_time", client:GetNWInt("rpt_arrest_time") - CurTime())
			end
		end

		

		-- if (character) then
		-- 	if (character:GetData("WeaponRPT")) then
		-- 		client.WeaponRPT = character:GetData("WeaponRPT")

		-- 		-- client:StripWeapons()
		-- 	 --    -- Cuff the Player 
		-- 	 --    client:Give("weapon_rpt_cuffed")

		-- 	elseif (!character:GetData("WeaponRPT")) then
		-- 		client.WeaponRPT = {}
		-- 	end
		-- end

		

		if (character) then
			if (character:GetData("rpt_arrest_time")) then

				client.WeaponRPT["Cuff"] = true
				-- print("arrest time", character:GetData("rpt_arrest_time"))
				Realistic_Police.ArresPlayer(client,character:GetData("rpt_arrest_time"))

				if (character:GetData("rpt_arrest_bailerdata")) then

					table.insert(RPTTableBailer, {
	                    vEnt = client, 
	                    vName = character:GetName(),
	                    vMotif = character:GetData("rpt_arrest_bailerdata").vMotif,
	                    vPrice = character:GetData("rpt_arrest_bailerdata").vPrice,
	                    vModel = client:GetModel(),
	                })

				end

			elseif (!character:GetData("rpt_arrest_time")) then

				if (client:GetNWInt("rpt_arrest_time")) then

					client:SetNWInt("rpt_arrest_time", 0)
					
					Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneCuffed, client)

			        -- UnCuff the Player ( For give weapons )
			        client.WeaponRPT["Cuff"] = false

			        client.WeaponRPT = {}
			        character:SetData("WeaponRPT", nil)

			        if timer.Exists("rpt_timerarrest"..client:EntIndex()) then
				        -- Remove the arrest timer 
				        timer.Remove("rpt_timerarrest"..client:EntIndex())
				    end

				    RPTTableBailer = RPTTableBailer or {}
					for k,v in pairs(RPTTableBailer) do 
						if not IsValid(RPTTableBailer[k]["vEnt"]) or not timer.Exists("rpt_timerarrest"..RPTTableBailer[k]["vEnt"]:EntIndex()) then 
							RPTTableBailer[k] = nil 
						end 
					end 


				end

			end
		end

		-- local inv = character:GetInventory()

		-- for k, v in pairs(inv:GetItems()) do

		-- 	if (!v.isWeapon) then continue end
		-- 	if (PLUGIN.RegisterIgnoreWeapons[v.uniqueID]) then continue end
		-- 	if (!v:GetData("claimed", false)) then continue end
		-- 	if (v:GetData("serial_number", 0) == 0) then continue end
		-- 	if (PLUGIN.GlobalWeaponsData[v:GetData("serial_number", 0)]) then continue end

		-- 	PLUGIN.GlobalWeaponsData[v:GetData("serial_number", 0)] = {
		-- 		ItemName = v:GetName(),
		-- 		ItemModel = v:GetModel(),
		-- 		Owner = v:GetData("claimed"),
		-- 		OwnerName = character:GetName()
		-- 	}

		-- end

	end

	function PLUGIN:CanPlayerUseCharacter(client, character)

		if client.WeaponRPT["Cuff"] then 
			return false, "You can't switch character if you are cuffed"
		end

	end

	function PLUGIN:PostPlayerLoadout(client)

		local character = client:GetCharacter()

		if (character:GetData("rpt_arrest_time")) then

			timer.Simple(1, function()

				client:StripWeapons()
		        Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneCuffed, client)
		        client.WeaponRPT["Cuff"] = false 
		        client:Give("ix_hands")

		    end)

		end

	end

	function PLUGIN:OnCharacterDisconnect(client, character)

		if (character:GetData("rpt_arrest_time")) then
			character:SetData("rpt_arrest_time", client:GetNWInt("rpt_arrest_time") - CurTime())
		end
	
	end

	function PLUGIN:CanPlayerEquipItem(client, item)

		if (item.isWeapon) then

			if client.WeaponRPT["Cuff"] then
				client:Notify("You can't equip this weapon when you're cuffed")
				return false
			end

			if timer.Exists("rpt_timerarrest"..client:EntIndex()) then
				if (!self.WeaponsAllowedInPrison[item.uniqueID]) then
					client:Notify("You can't equip this weapon in prison")
					return false
				end
			end


			if (self.WeaponsClass1[item.uniqueID]) or (self.WeaponsClass3[item.uniqueID]) then

				if (item:GetData("claimed", false) == false) then
					client:Notify("Use your gun license to register your gun before use or remove the serial number")
					return false
				end

			end

		end

	end

end

if (CLIENT) then

	net.Receive("ixPoliceSys_RemoveCuffedItem", function()

		if (IsValid(ix.hud.cuffMenu)) then
			local itemID = net.ReadUInt(8)

			ix.hud.cuffMenu.ListItem[itemID]:Remove()

		end


	end)

	net.Receive( "ixPoliceSys_RenderPersonProfile", function( len, client )

		local RPTNumber = net.ReadInt(32)
	    local RPTInformationDecompress = util.Decompress(net.ReadData(RPTNumber)) or {}
	    local RPTCriminalRecord = util.JSONToTable(RPTInformationDecompress)
	    local RPTEntity = net.ReadEntity()

	    local profilePnl = vgui.Create("ixPoliceSys_PersonProfile")
	    profilePnl:PopulateScroll(RPTEntity, RPTCriminalRecord)

	end)

	WeaponsDataBase = {}
	CasesDataBase = {}

	CasesInUse = {}

	net.Receive( "ixPoliceSys_RequestData", function( len, client )

		local dataJson = net.ReadString()

		local RequestType = net.ReadString()

		local RequestedTable = util.JSONToTable(dataJson)

		if (RequestType == "guns") then
			WeaponsDataBase = RequestedTable
		elseif (RequestType == "cases") then
			CasesDataBase = RequestedTable
		end

		if (IsValid(ix.gui.PolicePDA)) then

			if (RequestType == "guns") then
				ix.gui.PolicePDA:GunsLoaded()
			elseif (RequestType == "cases") then
				ix.gui.PolicePDA:CasesLoaded()
			end

		end

	end)

	net.Receive( "ixPoliceSys_SyncCases", function( len, client )

		local dataJson = net.ReadString()
		local RequestedTable = util.JSONToTable(dataJson)
		CasesDataBase = RequestedTable

	end)

	net.Receive( "ixPoliceSys_SendCaseInUse", function( len )

		if (!LocalPlayer():Alive()) then return end

		local StateProf = net.ReadBool()

		local CaseID = net.ReadUInt(17)

		CasesInUse[CaseID] = StateProf

	end)

	net.Receive( "ixPoliceSys_OpenLaptopUI", function( len )

		if (IsValid(ix.gui.PolicePDA)) then
			ix.gui.PolicePDA:Remove()
		end

		vgui.Create("ixPolice_LaptopMenu")

	end)

	net.Receive( "ixPoliceSys_OpenEQUI", function( len )

		if (IsValid(ix.gui.PoliceEQUI)) then
			ix.gui.PoliceEQUI:Remove()
		end

		vgui.Create("ixPolice_EQMenu")

	end)

	net.Receive( "ixPoliceSys_OpenWepUI", function( len )

		local client = LocalPlayer()
		local char = client:GetCharacter()

		local inv = char:GetInventory()

		local menuType = net.ReadString()

		local wepsType

		if (menuType == "class1") then
			wepsType = PLUGIN.WeaponsClass1
		elseif (menuType == "class3") then
			wepsType = PLUGIN.WeaponsClass3
		elseif (menuType == "removenumbers") then
			local MergedTable = PLUGIN.WeaponsClass1

			for k, v in pairs(PLUGIN.WeaponsClass3) do
				MergedTable[k] = v
			end

			wepsType = MergedTable
		else
			LocalPlayer():Notify("Invalid class table")
			return
		end

		local weps = {}

		for k, v in pairs(inv:GetItems()) do

			if (!v.isWeapon) then continue end
			if (!wepsType[v.uniqueID]) then continue end
			if (v:GetData("claimed", false)) and (menuType != "removenumbers") then continue end

			weps[k] = v:GetName()

		end

		if (table.IsEmpty(weps)) then
			if (menuType == "removenumbers") then
				client:Notify("You don't have weapons that can be removed the serial number")
			else
				client:Notify("You don't have weapons that can be registered")
			end
		else

			if (IsValid(ix.gui.menu)) then
				ix.gui.menu:Remove()
			end

			local claimPnl = vgui.Create("ixPoliceSys_ClaimWeapon")
			claimPnl.ClassType = menuType
			claimPnl:Populate(weps)
			
		end


	end)


	net.Receive( "ixPoliceSys_OpenGarageUI", function( len )

		-- local CarsTable = net.ReadString()

		-- local JsonToTbl = util.JSONToTable(CarsTable)

		local CarsTable = {}

		local CarsAmount = net.ReadUInt(6)

		if (!CarsAmount) then return end
		if (CarsAmount == 0) then return end

		for i=1, CarsAmount do

			local CarExtraInfo = PLUGIN.PoliceCarVendor[i]

			CarsTable[i] = {
				CarModel	= net.ReadString(),
				CarName	    = net.ReadString(),
				CarTaken	= net.ReadBool(),
				Skin        = CarExtraInfo.Skin,
				BodyGroups  = CarExtraInfo.BodyGroups,
				Fuel        = CarExtraInfo.Fuel
			}
		end

		local noAnim = false

		if (IsValid(ix.gui.PoliceGarageUI)) then
			ix.gui.PoliceGarageUI:Remove()
			noAnim = true
		end

		local garageUI = vgui.Create("ixPolice_GarageMenu")
		garageUI:RenderCars(CarsTable, noAnim)

	end)

	function PLUGIN:InitPostEntity()
		self.staticSound = CreateSound(LocalPlayer(), "dradio/radio_static.wav" )
		print(self.staticSound)
	end

end

ix.char.RegisterVar("wanted", {
	field = "wanted",
	fieldType = ix.type.text,
	default = "none",
	bNoDisplay = true,
})

ix.command.Add("CharSetPolice", {
	description = "Gives the player the permission to use police stuff",
	arguments = ix.type.character,
	adminOnly = true,
	OnRun = function(self, client, target)

		-- local target = client:GetCharacter()

		if(!target) then
			client:NotifyLocalized("charNoExist")
			return false
		end

		local targetPly = target:GetPlayer()
		
		target:SetData("IsPoliceOfficer", (!target:GetData("IsPoliceOfficer", false)))
		
		if (target:GetData("IsPoliceOfficer", false)) then
			client:Notify(target:GetName().." became a police officer")
			targetPly:Notify("You became a police officer")
		else
			client:Notify(target:GetName().." is no longer a police officer")
			targetPly:Notify("You are no longer a police officer")
		end

		targetPly:SetNetVar("PoliceOfficer_Net", target:GetData("IsPoliceOfficer", false))

	end
})

ix.command.Add("CharSetSWAT", {
	description = "Gives the player the permission to use swat stuff",
	arguments = ix.type.character,
	adminOnly = true,
	OnRun = function(self, client, target)

		-- local target = client:GetCharacter()

		if(!target) then
			client:NotifyLocalized("charNoExist")
			return false
		end

		local targetPly = target:GetPlayer()
		
		target:SetData("IsPoliceSWAT", (!target:GetData("IsPoliceSWAT", false)))
		
		if (target:GetData("IsPoliceSWAT", false)) then
			client:Notify(target:GetName().." became a SWAT")
			targetPly:Notify("You became a SWAT")
		else
			client:Notify(target:GetName().." is no longer a SWAT")
			targetPly:Notify("You are no longer a SWAT")
		end

		targetPly:SetNetVar("PoliceOfficer_Net", target:GetData("IsPoliceSWAT", false))

	end
})

ix.command.Add("CharSetFBI", {
	description = "Gives the player the permission to use FBI stuff",
	arguments = ix.type.character,
	adminOnly = true,
	OnRun = function(self, client, target)

		-- local target = client:GetCharacter()

		if(!target) then
			client:NotifyLocalized("charNoExist")
			return false
		end

		local targetPly = target:GetPlayer()
		
		target:SetData("IsPoliceFBI", (!target:GetData("IsPoliceFBI", false)))
		
		if (target:GetData("IsPoliceFBI", false)) then
			client:Notify(target:GetName().." became the FBI")
			targetPly:Notify("You became the FBI")
		else
			client:Notify(target:GetName().." is no longer the FBI")
			targetPly:Notify("You are no longer the FBI")
		end

		targetPly:SetNetVar("PoliceOfficer_Net", target:GetData("IsPoliceFBI", false))

	end
})

ix.command.Add("Wanted", {
	description = "Sets the status of the wanted",
	arguments = {
		ix.type.character,
		ix.type.text
	},
	OnRun = function(self, client, target, reason)

		local char = client:GetCharacter()

		-- if (char:GetData("IsPoliceOfficer", false)) then
		if (client:isPolice()) then

			if (!client.ixPoliceDuty) then
				client:Notify("You can't do it because you're not on duty.")
				return
			end

			if(!target) then
				client:NotifyLocalized("charNoExist")
				return false
			end

			local targetPly = target:GetPlayer()

			if (!reason) or (reason == "") then
				reason = "none"
			end

			

			if (targetPly:isWanted()) then
				
				if (reason == "none") then
					client:Notify(target:GetName().." is no longer wanted")

				else
					client:Notify("You changed wanted reason for "..target:GetName().." Reason: "..reason)
					
				end

			else

				if (reason == "none") then
					client:Notify("Please enter a valid reason")
				return end

				client:Notify("You wanted "..target:GetName().." Reason: "..reason)

			end

			target:SetWanted(reason)

		else
			client:Notify("You are not a police officer.")
		end

	end
})

ix.command.Add("UnWanted", {
	description = "Sets the status of the wanted",
	arguments = ix.type.character,
	OnRun = function(self, client, target, reason)

		local char = client:GetCharacter()

		-- if (char:GetData("IsPoliceOfficer", false)) then
		if (client:isPolice()) then

			if (!client.ixPoliceDuty) then
				client:Notify("You can't do it because you're not on duty.")
				return
			end

			if(!target) then
				client:NotifyLocalized("charNoExist")
				return false
			end

			local targetPly = target:GetPlayer()


			if (targetPly:isWanted()) then
				client:Notify(target:GetName().." is no longer wanted")

				target:SetWanted("none")

			else
				client:Notify(target:GetName().." is not wanted")
			end


		else
			client:Notify("You are not a police officer.")
		end

	end
})