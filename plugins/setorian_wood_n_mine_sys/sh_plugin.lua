local PLUGIN = PLUGIN
PLUGIN.name = "Wood 'n' Mining System"
PLUGIN.desc = "Immersive and extensive lumberjack and miner system"
PLUGIN.author = "JohnyReaper"

PLUGIN.fuel = {
	["wood"] = 90,
	["wood_log"] = 60,
	["ore_coal"] = 120,
}

PLUGIN.FurnaceRecipes = {
	{
		InputID = "ore_copper",
		InputAmmount = 5,
		Output  = "ore_copperingot",
		OutputTime = 25
	},
	{
		InputID = "ore_silver",
		InputAmmount = 5,
		Output  = "ore_silveringot",
		OutputTime = 30
	},
	{
		InputID = "ore_gold",
		InputAmmount = 5,
		Output  = "ore_goldingot",
		OutputTime = 45
	},
}

ix.config.Add("nodeRespawn", 60, "After what time (in seconds) will the node be respawn?", nil, {
	data = {min = 10, max = 600},
	category = "Mining System"
})

ix.config.Add("treeRespawn", 60, "After what time (in seconds) will the tree be respawn?", nil, {
	data = {min = 10, max = 600},
	category = "Wood System"
})

ix.config.Add("BigtreeRespawn", 90, "After what time (in seconds) will the big tree be respawn?", nil, {
	data = {min = 10, max = 600},
	category = "Wood System"
})

ix.config.Add("TreeHealth", 8, "Tree health (number of hits to fell it)." , nil, {
	data = {min = 1, max = 16},
	category = "Wood System"
})

ix.config.Add("BigTreeHealth", 10, "Big tree health (number of hits to fell it)." , nil, {
	data = {min = 1, max = 20},
	category = "Wood System"
})

ix.config.Add("miningChance", 30, "What are the chances (%) of mining the ore?.", nil, {
	data = {min = 1, max = 100},
	category = "Mining System"
})


if (SERVER) then

	util.AddNetworkString("ixFurnace_OpenUI")
	util.AddNetworkString("ixFurnace_AddFuel")
	util.AddNetworkString("ixFurnace_RemoveFuel")
	util.AddNetworkString("ixFurnace_AddInput")
	util.AddNetworkString("ixFurnace_RemoveInput")
	util.AddNetworkString("ixFurnace_TakeOutput")

	net.Receive( "ixFurnace_AddFuel", function( len, client )

		local furnaceEnt = net.ReadEntity()

		if (!IsValid(furnaceEnt)) then return end
		if (furnaceEnt:GetClass() != "j_mining_furnace") then return end

		local itemID = net.ReadUInt(12)

		local char = client:GetCharacter()

		if (!char) then return end

		local inv = char:GetInventory()

		local foundItem = inv:GetItemByID(itemID)

		if (!furnaceEnt.FuelItem) then

			furnaceEnt.FuelItem = foundItem.uniqueID
			furnaceEnt:SetFuelCount(1)

			furnaceEnt:SetWorkTime(furnaceEnt:GetWorkTime() + PLUGIN.fuel[foundItem.uniqueID])

			foundItem:Remove()

		else

			if (furnaceEnt.FuelItem == foundItem.uniqueID) then
				furnaceEnt:SetFuelCount(furnaceEnt:GetFuelCount() + 1)

				furnaceEnt:SetWorkTime(furnaceEnt:GetWorkTime() + PLUGIN.fuel[foundItem.uniqueID])

				foundItem:Remove()

			end

		end

		


	end)

	net.Receive( "ixFurnace_RemoveFuel", function( len, client )

		local furnaceEnt = net.ReadEntity()

		if (!IsValid(furnaceEnt)) then return end
		if (furnaceEnt:GetClass() != "j_mining_furnace") then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local inv = char:GetInventory()

		if (furnaceEnt.FuelItem) then

			if (furnaceEnt:GetFuelCount() > 0) then

				furnaceEnt:SetFuelCount(furnaceEnt:GetFuelCount() - 1)

				furnaceEnt:SetWorkTime( math.max( furnaceEnt:GetWorkTime() - PLUGIN.fuel[furnaceEnt.FuelItem], 0) )

				if (!inv:Add(furnaceEnt.FuelItem)) then
		            ix.item.Spawn(furnaceEnt.FuelItem, client)
		        end

			end

			if (furnaceEnt:GetFuelCount() <= 0) then
				furnaceEnt.FuelItem = nil
			end

		end

	end)

	net.Receive( "ixFurnace_AddInput", function( len, client )

		local furnaceEnt = net.ReadEntity()

		if (!IsValid(furnaceEnt)) then return end
		if (furnaceEnt:GetClass() != "j_mining_furnace") then return end

		local itemID = net.ReadUInt(12)

		local char = client:GetCharacter()

		if (!char) then return end

		local inv = char:GetInventory()

		local foundItem = inv:GetItemByID(itemID)

		if (!furnaceEnt.InputItem) then

			furnaceEnt.InputItem = foundItem.uniqueID
			furnaceEnt:SetInputCount(1)

			foundItem:Remove()

		else

			if (furnaceEnt.InputItem == foundItem.uniqueID) then
				furnaceEnt:SetInputCount(furnaceEnt:GetInputCount() + 1)

				foundItem:Remove()

			end

		end

		-- if (table.IsEmpty(furnaceEnt.OutputData)) then
			local outputData = PLUGIN:FindRecipe(foundItem.uniqueID, furnaceEnt:GetInputCount())

			if (outputData) then
				furnaceEnt.OutputData = outputData
			
				furnaceEnt:SetMeltTime(outputData.MeltTime)

			end

		-- end

		


	end)

	net.Receive( "ixFurnace_RemoveInput", function( len, client )

		local furnaceEnt = net.ReadEntity()

		if (!IsValid(furnaceEnt)) then return end
		if (furnaceEnt:GetClass() != "j_mining_furnace") then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local inv = char:GetInventory()

		if (furnaceEnt.InputItem) then

			if (furnaceEnt:GetInputCount() > 0) then

				furnaceEnt:SetInputCount(furnaceEnt:GetInputCount() - 1)

				if (!inv:Add(furnaceEnt.InputItem)) then
		            ix.item.Spawn(furnaceEnt.InputItem, client)
		        end

		        if (!table.IsEmpty(furnaceEnt.OutputData) and furnaceEnt:GetOutputCount() == 0) then

		        	local outputData = PLUGIN:FindRecipe(furnaceEnt.InputItem, furnaceEnt:GetInputCount())

					if (outputData) then
						furnaceEnt.OutputData = outputData
					
						furnaceEnt:SetMeltTime(outputData.MeltTime)

					else
						furnaceEnt:SetMeltTime(0)
						furnaceEnt.OutputData = {}
					end

		        end

			end

			if (furnaceEnt:GetInputCount() <= 0) then
				furnaceEnt.InputItem = nil
			end

		end

	end)

	net.Receive( "ixFurnace_TakeOutput", function( len, client )

		local furnaceEnt = net.ReadEntity()

		if (!IsValid(furnaceEnt)) then return end
		if (furnaceEnt:GetClass() != "j_mining_furnace") then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local inv = char:GetInventory()

		if (!table.IsEmpty(furnaceEnt.OutputData)) then

			if (furnaceEnt:GetOutputCount() > 0) then

				furnaceEnt:SetOutputCount(furnaceEnt:GetOutputCount() - 1)

				if (!inv:Add(furnaceEnt.OutputData.OutputID)) then
		            ix.item.Spawn(furnaceEnt.OutputData.OutputID, client)
		        end

			end

			if (furnaceEnt:GetOutputCount() <= 0) then
				
				if (furnaceEnt.InputItem) then 

					local outputData = PLUGIN:FindRecipe(furnaceEnt.InputItem, furnaceEnt:GetInputCount())

					if (outputData) then
						furnaceEnt.OutputData = outputData
					
						furnaceEnt:SetMeltTime(outputData.MeltTime)

					else
						furnaceEnt:SetMeltTime(0)
						furnaceEnt.OutputData = {}
					end

				else
					furnaceEnt.OutputData = {}
				end

			end

		end

	end)

	function PLUGIN:FindRecipe(ItemuniqueID, ItemsAmount)

		local data = false

		for k, v in ipairs(self.FurnaceRecipes or {}) do

			if (v.InputID != ItemuniqueID) then continue end

			if (ItemsAmount >= v.InputAmmount) then

				data = {
					NeededIngre = v.InputID,
					NeededAmount = v.InputAmmount,
					OutputID = v.Output,
					MeltTime = v.OutputTime,
				}


				break
			end
			
		end

		return data

	end

	function PLUGIN:LoadData()
		// Ents
		self:LoadSMineNodes()
		self:LoadSTree()
		self:LoadSBigTree()

	end

	function PLUGIN:SaveData()
		// Ents
		self:SaveSMineNodes()
		self:SaveSTree()
		self:SaveSBigTree()
	
	end

	function PLUGIN:SaveSMineNodes()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_mining_node")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_mining_nodes", data)

	end

	function PLUGIN:SaveSTree()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_lumberjack_tree")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_wooding_trees", data)

	end

	function PLUGIN:SaveSBigTree()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_lumberjack_bigtree")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_wooding_bigtrees", data)

	end

	function PLUGIN:LoadSMineNodes()
		for _, v in ipairs(ix.data.Get("jr_mining_nodes") or {}) do
			local entity = ents.Create("j_mining_node")

			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()
			
		end
	end

	function PLUGIN:LoadSTree()
		for _, v in ipairs(ix.data.Get("jr_wooding_trees") or {}) do
			local entity = ents.Create("j_lumberjack_tree")

			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()

			local phys = entity:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
		end
	end

	function PLUGIN:LoadSBigTree()
		for _, v in ipairs(ix.data.Get("jr_wooding_bigtrees") or {}) do
			local entity = ents.Create("j_lumberjack_bigtree")

			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()

			local phys = entity:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
		end
	end

end

if (CLIENT) then

	net.Receive( "ixFurnace_OpenUI", function( len, client )

		local tableEnt = net.ReadEntity()

		local bytes = net.ReadUInt( 16 )
		local compressedJson = net.ReadData( bytes )
		local DecompressJson = util.Decompress( compressedJson )

		local furnaceData = util.JSONToTable(DecompressJson)

		local localInventory = LocalPlayer():GetCharacter():GetInventory()
		local furnaceUI = vgui.Create("ixFurnaceView")

		furnaceUI.FurnaceEnt = tableEnt

		furnaceUI:PopulateData(furnaceData)

		if (localInventory) then
			furnaceUI:SetLocalInventory(localInventory)
		end

	end)

end