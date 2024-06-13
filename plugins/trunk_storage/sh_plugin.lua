PLUGIN.name = "Trunk Storage"
PLUGIN.author = "Ernie"
PLUGIN.description = "Implements storage for vehicle trunks"

PLUGIN.vehicles = PLUGIN.vehicles or {}
VEHICLE_DEFINITIONS = PLUGIN.vehicles

ix.util.Include("sh_definitions.lua")

for k, v in pairs(PLUGIN.vehicles) do
	if (k and v.width and v.height) then
		ix.inventory.Register("trunk_"..k, v.width, v.height)
	else
		ErrorNoHalt("[Helix] Trunk storage for '"..k.."' is missing all inventory information!\n")
		PLUGIN.vehicles[k] = nil
	end
	ix.inventory.Register("glovebox", 1, 3, true)
end

if (SERVER) then
	function PLUGIN:PlayerSpawnedVehicle(client, ent)

		-- if (ent:GetNetVar("owner", 0) != 0) and (ix.char.loaded[ent:GetNetVar("owner", 0)]) then return true end

		local def = VEHICLE_DEFINITIONS[ent:GetModel():lower()] or VEHICLE_DEFINITIONS["default"]

		local invCheck

		if (VEHICLE_DEFINITIONS[ent:GetModel():lower()]) then
			invCheck = ent:GetModel():lower()
		else
			invCheck = "default"
		end

		if (ent:GetNetVar("trunk_id", 0) == 0 ) then

			ix.inventory.New(0, "trunk_"..invCheck, function(inventory)
				inventory.vars.isBag = true
        		inventory.vars.isContainer = true
				ent:SetNetVar("trunk_id", inventory:GetID())
				ent.trunkid = inventory:GetID()
			end)

		end

		if (ent:GetNetVar("glovebox_id", 0) == 0 ) then

			ix.inventory.New(0, "glovebox", function(inventory)
				inventory.vars.isBag = true
				ent:SetNetVar("glovebox_id", inventory:GetID())
				ent.gloveboxid = inventory:GetID()
			end)

		end

		
	end


	function PLUGIN:EntityRemoved(ent)

		if (IsValid(ent) and ent:IsVehicle() and (ent:GetClass() != "prop_vehicle_prisoner_pod") and (VEHICLE_DEFINITIONS[ent:GetModel():lower()] or VEHICLE_DEFINITIONS["default"])) then
			if (ent:GetNetVar("owner", 0) == 0) or (!ix.char.loaded[ent:GetNetVar("owner", 0)]) then
				-- Drop the items (Might cause issues)

				local inventory = ent:GetInv()

				if (inventory) and (inventory.GetItems) then
					for k, v in pairs(inventory:GetItems() or {}) do
						ix.item.Spawn(v, ent:GetPos())
					end
				end

				local inventory2 = ent:GetGloveBox()
				if (inventory2) and (inventory2.GetItems) then
					for k, v in pairs(inventory2:GetItems() or {}) do
						ix.item.Spawn(v, ent:GetPos())
					end
				end

			else
				-- Save data
				local inventory = ent:GetInv()
				local inventory2 = ent:GetGloveBox()
				local char = ix.char.loaded[ent:GetNetVar("owner", ent.ownerID or 0)]
				local data = char:GetData("wcd_trunks", {})
				local data2 = char:GetData("wcd_gloveboxes", {})

				-- -- data["wcd_trunks"] = data["wcd_trunks"] or {}
				if (inventory) then
					data[ ent:GetModel():lower() ] = inventory:GetID()
				end
				if (inventory2) then
					data2[ ent:GetModel():lower() ] = inventory2:GetID()
				end

				char:SetData("wcd_trunks", data)
				char:SetData("wcd_gloveboxes", data2)
				-- PrintTable(char:GetData("wcd_trunks", {}))
			end
		end
	end

	-- hook.Add("WCD::SpawnedVehicle", "TrunkLoadData", function(client, entity)
	-- 	if (!IsValid(entity)) then return end
	-- 	if (!entity:IsVehicle()) then return end

	-- 	local def = VEHICLE_DEFINITIONS[entity:GetModel():lower()]
	-- 	if (!def) then return end

	-- 	local char = client:GetCharacter()
	-- 	if (!char) then return end

	-- 	entity.WCDOwner = client

	-- 	local data = char:getData()
	-- 	if (data["wcd_trunks"] and data["wcd_trunks"][entity:GetModel():lower()]) then
	-- 		local old_inventory = data["wcd_trunks"][entity:GetModel():lower()]
	-- 		if (!old_inventory.id) then return end
	-- 		nut.item.restoreInv(old_inventory.id, def.width, def.height, function(inventory)
	-- 			inventory.vars.isStorage = true
	-- 			entity:setNetVar("trunk_id", inventory:getID())
	-- 			data["wcd_trunks"][entity:GetModel():lower()] = {}
	-- 			char:setData("wcd_trunk", data["wcd_trunks"])
	-- 		end)
	-- 	end
	-- end)
end
	
--[[ ix.command.Add("trunk", {
	description = "Opens the trunk of the vehicle you are looking at",
	adminOnly = false,
	OnRun = function(self, client)
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
		-- if (!VEHICLE_DEFINITIONS[ent:GetModel():lower()]) then
		-- 	return client:NotifyLocalized("noTrunk")
		-- end
		local def = VEHICLE_DEFINITIONS[ent:GetModel():lower()] or VEHICLE_DEFINITIONS["default"]

		-- Check action criteria
		if (dist > 16384) then
			return client:NotifyLocalized("tooFar")
		end
		if (ent:IsTrunkLocked()) then
			ent:EmitSound("doors/default_locked.wav")
			return client:NotifyLocalized("trunkLocked")
		end
		
		-- Perform action
		local inventory = ent:GetInv()
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

		-- client:SetAction("Opening...", .7, function()					
		-- 	local inventory = ent:GetInv()
			
		-- 	inventory:Sync(client)
		-- 	netstream.Start(client, "trunkOpen", ent, inventory:GetID())
		-- 	ent:EmitSound(def.trunkSound or "items/ammocrate_open.wav")
		-- end)
	end
})--]] 

-- nut.command.add("locktrunk", {
-- 	adminOnly = false,
-- 	syntax = "",
-- 	onRun = function(client, arguments)
-- 		local trace = client:GetEyeTraceNoCursor()
-- 		local ent = trace.Entity
-- 		local dist = ent:GetPos():DistToSqr(client:GetPos())

-- 		-- Valdiate vehicle
-- 		if (!ent or !ent:IsValid()) then
-- 			return nil
-- 		end
-- 		if (!ent:IsVehicle()) then
-- 			return client:notifyLocalized("invalidVehicle")
-- 		end
-- 		if (!VEHICLE_DEFINITIONS[ent:GetModel():lower()]) then
-- 			return client:notifyLocalized("noTrunk")
-- 		end

-- 		local def = VEHICLE_DEFINITIONS[ent:GetModel():lower()]

-- 		-- Check action criteria
-- 		if (dist > 16384) then
-- 			return client:notifyLocalized("tooFar")
-- 		end

-- 		if (ent.WCDOwner ~= client and ent.EntityOwner ~= client) then
-- 			return client:notifyLocalized("notOwner")
-- 		end

-- 		-- Perform action
-- 		ent:LockTrunk(true)
-- 		ent:EmitSound(def.lockSound or "doors/default_locked.wav")
-- 		client:notifyLocalized("lockTrunk")
-- 	end
-- })

-- nut.command.add("unlocktrunk", {
-- 	adminOnly = false,
-- 	syntax = "",
-- 	onRun = function(client, arguments)
-- 		local trace = client:GetEyeTraceNoCursor()
-- 		local ent = trace.Entity
-- 		local dist = ent:GetPos():DistToSqr(client:GetPos())

-- 		-- Valdiate vehicle
-- 		if (!ent or !ent:IsValid()) then
-- 			return nil
-- 		end
-- 		if (!ent:IsVehicle()) then
-- 			return client:notifyLocalized("invalidVehicle")
-- 		end
-- 		if (!VEHICLE_DEFINITIONS[ent:GetModel():lower()]) then
-- 			return client:notifyLocalized("noTrunk")
-- 		end

-- 		local def = VEHICLE_DEFINITIONS[ent:GetModel():lower()]
-- 		-- Check action criteria
-- 		if (dist > 16384) then
-- 			return client:notifyLocalized("tooFar")
-- 		end

-- 		if (ent.WCDOwner ~= client and ent.EntityOwner ~= client) then
-- 			return client:notifyLocalized("notOwner")
-- 		end

-- 		-- Perform action
-- 		ent:LockTrunk(false)
-- 		ent:EmitSound(def.unlockSound or "items/ammocrate_open.wav")
-- 		client:notifyLocalized("unlockTrunk")
-- 	end
-- })

-- Miscellanous functions for easy interaction

local VEHICLE = FindMetaTable("Entity")

function VEHICLE:LockTrunk(locked)
	assert(isbool(locked), "Expected bool, got", type(locked))
	if (self:IsValid() and self:IsVehicle() and (VEHICLE_DEFINITIONS[self:GetModel():lower()] or VEHICLE_DEFINITIONS["default"]) ) then
		self:setNetVar("trunk_locked", locked)
		return true
	end
	return false	
end

function VEHICLE:IsTrunkLocked()
	if (self:IsValid() and self:IsVehicle()) then
		return self:isLocked()
		-- if (VEHICLE_DEFINITIONS[self:GetModel():lower()]) then
		-- 	return self:getNetVar("trunk_locked", false)
		-- end
	end
	return true	
end

function VEHICLE:GetInv()
	-- print(self:GetNetVar("trunk_id", 0))
	if (self:IsValid() and self:IsVehicle()) then-- and (VEHICLE_DEFINITIONS[self:GetModel():lower()] or VEHICLE_DEFINITIONS["default"]) ) then
		return ix.item.inventories[self:GetNetVar("trunk_id", self.trunkid or 0)]
	end
end

function VEHICLE:GetGloveBox()
	-- print(self:GetNetVar("glovebox_id", 0))
	if (self:IsValid() and self:IsVehicle() ) then
		return ix.item.inventories[self:GetNetVar("glovebox_id", self.gloveboxid or 0)]
	end
end

function VEHICLE:GetMoney()
	return self.money or 0
end