local PLUGIN = PLUGIN

PLUGIN.name = "Safe"
PLUGIN.author = "Xemon"
PLUGIN.description = "Provides the ability to store items in safes."

function PLUGIN:InitializedPlugins()
	ix.inventory.Register("safe", 5, 5)
end

if SERVER then
	resource.AddFile("sound/safe/click.wav")

    util.AddNetworkString("ixSafePassword");

    function PLUGIN:SaveData()
        if (!ix.shuttingDown) then
            self:Save()
        end
    end

    function PLUGIN:Save()
		local data = {}

		for _, v in ipairs(ents.FindByClass("ix_safe")) do
			if hook.Run("CanSaveSafe", v, v:GetInventory()) ~= false and v.password and v.password ~= "" then
				local inventory = v:GetInventory()

				if inventory then
					data[#data + 1] = {
						pos = v:GetPos(),
						angles = v:GetAngles(),
						inv = inventory:GetID(),
						password = v.password,
						money = v:GetMoney()
					}
				end
			else
				local index = v:GetID()

				local query = mysql:Delete("ix_items")
					query:Where("inventory_id", index)
				query:Execute()

				query = mysql:Delete("ix_inventories")
					query:Where("inventory_id", index)
				query:Execute()

				v:Remove()
			end
		end

		self:SetData(data)
    end

    function PLUGIN:LoadData()
		local data = self:GetData()

		if not data then return end

		for _, v in ipairs(data) do
			local inventoryID = tonumber(v.inv)

			if (!inventoryID or inventoryID < 1) then
				ErrorNoHalt(string.format(
					"[Helix] Attempted to restore safe inventory with invalid inventory ID '%i'\n",
					inventoryID))

				continue
			end

			local entity = ents.Create("ix_safe")
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:SetModel("models/sterling/fbikid_safe.mdl")
			entity.initialized = true
			entity:Spawn()
			entity:SetSolid(SOLID_VPHYSICS)
			entity:PhysicsInit(SOLID_VPHYSICS)
			entity:SetUseType(SIMPLE_USE)
			entity.receivers = {}

			entity.password = v.password
			entity.Sessions = {}

			if v.money then
				entity:SetMoney(v.money)
			end

			ix.inventory.Restore(inventoryID, 5, 5, function(inventory)
				inventory.vars.isBag = true
				inventory.vars.isContainer = true

				if IsValid(entity) then
					entity:SetInventory(inventory)
				end
			end)

			local physObject = entity:GetPhysicsObject()

			if IsValid(physObject) then
				physObject:EnableMotion()
				physObject:Wake()
			end
		end
    end

    function PLUGIN:SafeSpawned(safe)
	    ix.inventory.New(0, "safe", function(inventory)
            inventory.vars.isBag = true
			inventory.vars.isContainer = true

            safe:SetInventory(inventory)
        end)	

        -- self:Save()
    end

    function PLUGIN:SafeRemoved(safe, inventory)
        self:Save()
    end

    net.Receive("ixSafePassword", function(len, client)
		if (client.ixNextContainerPassword or 0) > RealTime() then
			return
		end

        local entity = net.ReadEntity()
        local password = net.ReadString()
		local dist = entity:GetPos():DistToSqr(client:GetPos())

		if not entity or not IsValid(entity) then return end
		if not password or not isstring(password) then return end

		if dist < 16384 then
			if entity.password == password then
				entity:OpenInventory(client)
			else
				client:Notify("Incorrect password! Try again later")
			end
		end

    end)
else
    net.Receive("ixSafePassword", function(len)
        local entity = net.ReadEntity()

		local menu = vgui.Create("ixSafe")
		menu.entity = entity
    end)
end

properties.Add("safe_setpassword", {
	MenuLabel = "Set Password",
	Order = 400,
	MenuIcon = "icon16/lock_edit.png",

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_safe") then return false end
		if not client:IsAdmin() then return false end
		if (!gamemode.Call("CanProperty", client, "safe_setpassword", entity)) then return false end

		return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Enter safe password (numbers only)", "", "", function(text)
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local password = net.ReadString()

		entity.Sessions = {}

		if (password:len() > 0 and password:len() <= 12 and tonumber(password) ~= nil) then
			entity.password = password

			-- client:NotifyLocalized("containerPassword", password)
			client:Notify(string.format("You've set safe password to %s", password))
		else
			client:Notify("Invalid password (1-12 length and only numbers)")
			-- client:NotifyLocalized("containerPasswordRemove")
		end

		PLUGIN:Save()

		-- local inventory = entity:GetInventory()

        -- to change
		-- ix.log.Add(client, "containerPassword", name, inventory:GetID(), password:len() != 0)
	end
})
