local PLUGIN = PLUGIN
PLUGIN.name = "Custom Vendor"
PLUGIN.desc = "Custom Vendor UI for Setorian Community"
PLUGIN.author = "JohnyReaper"

-- PLUGIN.RobPoliceReq = 3

ix.config.Add("RobPoliceReq", 3, "How many police officers must be on duty to rob a vendor?", nil, {
    data = {min = 1, max = 10},
    category = "Custom Vendor"
})

ix.config.Add("VendorRobCooldown", 15, "How many minutes can you rob a vendor again?", nil, {
    data = {min = 1, max = 60},
    category = "Custom Vendor"
})

ix.config.Add("RobMoneyMin", 50, "How much money can you get when robbing a vendor? [Min Value]", function()

	local minValue = ix.config.Get("RobMoneyMin", 50)
	local maxValue = ix.config.Get("RobMoneyMax", 250)

	if (minValue > maxValue) then
		ix.config.Set("RobMoneyMin", maxValue)
	end

	end, {
    data = {min = 10, max = 100},
    category = "Custom Vendor"
})

ix.config.Add("RobMoneyMax", 250, "How much money can you get when robbing a vendor? [Max Value]", function()

	local minValue = ix.config.Get("RobMoneyMin", 50)
	local maxValue = ix.config.Get("RobMoneyMax", 250)

	if (maxValue < minValue) then
		ix.config.Set("RobMoneyMax", minValue)
	end

	end, {
    data = {min = 10, max = 1000},
    category = "Custom Vendor"
})

if (CLIENT) then

	PLUGIN.CategoryIcons = {
		["Consumables"] = "setorian_vendor/product.png",
		["Medical"]     = "setorian_vendor/heart-attack.png",
		["Bags"]        = "setorian_vendor/bag.png",
		["Weapons"]     = "setorian_vendor/rifle.png",
		["Ammunition"]  = "setorian_vendor/bullet.png",
		["Outfit"]      = "setorian_vendor/clothing.png",
		["Pacoutfit"]   = "setorian_vendor/clothing.png",
		["Clothing"]    = "setorian_vendor/clothing.png",
	}

end


if (SERVER) then

	util.AddNetworkString("ixVendorTrade_Buy")

	util.AddNetworkString("ixVendorTrade_Extd_Buy")
	util.AddNetworkString("ixVendorTrade_Extd_Sell")
	util.AddNetworkString("ixVendorTrade_ClearCart")

	util.AddNetworkString("ixVendorTrade_Rob")

	util.AddNetworkString("ixVendor_UpdateTitle")

	util.AddNetworkString("ixVendorTrade_RobEdit")

	local PLUGINVendor = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("vendor") or false
	local PLUGINBank = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

	if (!PLUGINVendor) then
		ErrorNoHalt( "Custom Vendor Plugin doesn't work without default Vendor plugin" )
		return
	end

	local PLUGIN = PLUGIN

	function PLUGINVendor:SaveData()
		local data = {}

		for _, entity in ipairs(ents.FindByClass("ix_vendor")) do
			local bodygroups = {}

			for _, v in ipairs(entity:GetBodyGroups() or {}) do
				bodygroups[v.id] = entity:GetBodygroup(v.id)
			end

			data[#data + 1] = {
				name = entity:GetDisplayName(),
				description = entity:GetDescription(),
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				skin = entity:GetSkin(),
				canrob = entity:GetCanBeRob(),
				title = entity:GetTitleStore(),
				titlefont = entity:GetTitleFont(),
				bodygroups = bodygroups,
				bubble = entity:GetNoBubble(),
				items = entity.items,
				factions = entity.factions,
				classes = entity.classes,
				money = entity.money,
				scale = entity.scale
			}
		end

		self:SetData(data)
	end

	function PLUGIN:SaveData()
		PLUGINVendor:SaveData()
	end

	function PLUGINVendor:LoadData()
		for _, v in ipairs(self:GetData() or {}) do
			local entity = ents.Create("ix_vendor")
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:Spawn()

			entity:SetModel(v.model)
			entity:SetSkin(v.skin or 0)
			entity:SetSolid(SOLID_BBOX)
			entity:PhysicsInit(SOLID_BBOX)

			entity:DropToFloor()

			local physObj = entity:GetPhysicsObject()

			if (IsValid(physObj)) then
				-- physObj:EnableMotion(false)
				physObj:Wake()
			end

			entity:SetNoBubble(v.bubble)
			entity:SetDisplayName(v.name)
			entity:SetDescription(v.description)
			entity:SetCanBeRob(v.canrob)
			entity:SetTitleStore(v.title)
			entity:SetTitleFont(v.titlefont)

			for id, bodygroup in pairs(v.bodygroups or {}) do
				entity:SetBodygroup(id, bodygroup)
			end

			local items = {}

			for uniqueID, data in pairs(v.items) do
				items[tostring(uniqueID)] = data
			end

			entity.items = items
			entity.factions = v.factions or {}
			entity.classes = v.classes or {}
			entity.money = v.money
			entity.scale = v.scale or 0.5
		end
	end

	-- function PLUGIN:LoadData()
	-- 	PLUGINVendor:LoadData()
	-- end

	net.Receive("ixVendor_UpdateTitle", function(len, client)

		if (!CAMI.PlayerHasAccess(client, "Helix - Manage Vendors", nil)) then
			return
		end

		local entity = client.ixVendor

		if (!IsValid(entity)) then
			return
		end

		local UpTitle = net.ReadString()

		if (UpTitle == "") or (!UpTitle) then return end
		
		local IsFont = net.ReadBool()

		if (IsFont) then
			entity:SetTitleFont(UpTitle)
		else
			entity:SetTitleStore(UpTitle)
		end

		net.Start("ixVendor_UpdateTitle")
			net.WriteString(entity:GetTitleStore())
			net.WriteString(entity:GetTitleFont())
		net.Send(client)

	end)

	net.Receive("ixVendorTrade_RobEdit", function(len, client)

		if (!CAMI.PlayerHasAccess(client, "Helix - Manage Vendors", nil)) then
			return
		end

		local entity = client.ixVendor

		if (!IsValid(entity)) then
			return
		end

		local canBeRob = net.ReadBool()

		entity:SetCanBeRob(canBeRob)


	end)

	net.Receive("ixVendorTrade_Rob", function(len, client)

		local entity = client.ixVendor

		if (!IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 192) then
			return
		end

		if (!entity:GetCanBeRob()) then
			return
		end

		if (!string.find(client:GetActiveWeapon():GetClass(),"arccw_")) then
			client:Notify("You don't have a firearm to threat the vendor")
			return
		end

		if (!client:IsWepRaised()) then
			client:Notify("Raise the weapon to threat the vendor")
			return
		end

		if (entity.robCoolDown or 0) > CurTime() then
			client:Notify("This vendor was already robbed some time ago")
			return
		end

		local policeAmmount = 0

		for client, character in ix.util.GetCharacters() do
			if (client:isPolice()) then
				if (client.ixPoliceDuty) then
					policeAmmount = policeAmmount + 1
				end
			end
		end

		-- if (policeAmmount < ix.config.Get("RobPoliceReq", 3)) then
		-- 	client:Notify("Not enough police officers on duty")
		-- 	return
		-- end

		local fearSound = "vo/npc/male01/startle0"..math.random(1,2)..".wav"
		local helpSound = "vo/npc/male01/help01.wav"
		local model = entity:GetModel()

		if (model:find("female") or model:find("alyx") or model:find("mossman")) != nil or ix.anim.GetModelClass(model) == "citizen_female" then
			fearSound = "vo/npc/female01/startle0"..math.random(1,2)..".wav"
			helpSound = "vo/npc/female01/help01.wav"
		end

		entity:EmitSound(fearSound)

		local sequence = entity:LookupSequence("Fear_Reaction")

		entity.nextAnimCheck = CurTime() + 10

		entity:ResetSequence( sequence )
		entity:SetPlaybackRate( 1 )
		entity:SetSequence( sequence )

		
		entity.IsRobbing = true

		client:EmitSound("physics/rubber/rubber_tire_strain"..math.random(1,3)..".wav")

		client:EmitSound("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav")

		client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND, true)

		net.Start("ixVendorTrade_Rob")
		net.Send(client)

		client.IsRobbingVendor = true
		client:SetAction("Robbing...", 5) -- for displaying the progress bar
		client:DoStaredAction(entity, function()
			client:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav", 60)
			client.IsRobbingVendor = false

			local minValue = ix.config.Get("RobMoneyMin", 50)
			local maxValue = ix.config.Get("RobMoneyMax", 250)
			
			entity.robCoolDown = CurTime() + (ix.config.Get("VendorRobCooldown", 15)*60)

			local char = client:GetCharacter()
			char:SetMoney(char:GetMoney() + math.random(minValue, maxValue))
			client:Notify("You robbed the vendor")

			entity:SetAnim()
			entity.IsRobbing = false
			entity:EmitSound(helpSound)

		end, 5, function()
			client:SetAction()
			client.IsRobbingVendor = false
			entity:SetAnim()
			entity.IsRobbing = false
			entity:EmitSound(helpSound)
		end)


	end)

	function PLUGIN:PlayerSwitchWeapon(client, oldW, newW) 
		if (client.IsRobbingVendor) then
			client:SetAction()
			client.IsRobbingVendor = false
			entity.IsRobbing = false
			if (client.ixVendor) and (IsValid(client.ixVendor)) then
				client.ixVendor:SetAnim()
			end
		end
	end

	function PLUGIN:CanPlayerTradeWithVendor(client, entity, uniqueID, isSellingToVendor)
		if (entity.IsRobbing) then
			return false
		end
	end


	net.Receive("ixVendorTrade_Buy", function(length, client)
		if ((client.ixVendorTry or 0) < CurTime()) then
			client.ixVendorTry = CurTime() + 0.33
		else
			return
		end

		local entity = client.ixVendor

		if (!IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 192) then
			return
		end

		local itemID = net.ReadString()

		local bankID = net.ReadUInt(20)

		local price = entity:GetPrice(itemID, false)
		-- local itemData = entity.items[itemID]
		-- local itemPrice = itemData.[VENDOR_PRICE]

		if (hook.Run("CanPlayerTradeWithVendor", client, entity, itemID, false) != false) then

			if (bankID != 0) then

				if (tonumber(PLUGINBank:GetAccountMoney(bankID)) < price) then
			        client:Notify("You don't have enough money in your account.")
			        return
			    end

			else

				if (!client:GetCharacter():HasMoney(price)) then
					return client:NotifyLocalized("canNotAfford")
				end

			end

			local stock = entity:GetStock(itemID)

			if (stock and stock < 1) then
				client:NotifyLocalized("vendorNoStock")
				return
			end


			if (bankID != 0) then
				PLUGINBank:UpdateBalance(bankID, PLUGINBank:GetAccountMoney(bankID) - price)
			else
				client:GetCharacter():TakeMoney(price)
			end

			local name = L(ix.item.list[itemID].name, client)

			client:NotifyLocalized("businessPurchase", name, ix.currency.Get(price))

			entity:GiveMoney(price)

			if (!client:GetCharacter():GetInventory():Add(itemID)) then
				ix.item.Spawn(itemID, client)
			end

			entity:TakeStock(itemID)

			PLUGIN:SaveData()
			hook.Run("CharacterVendorTraded", client, entity, itemID, false)

		end

	end)

	net.Receive("ixVendorTrade_Extd_Buy", function(length, client)
		if ((client.ixVendorTry or 0) < CurTime()) then
			client.ixVendorTry = CurTime() + 0.33
		else
			return
		end

		local entity = client.ixVendor

		if (!IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 192) then
			return
		end

		local TableLen = net.ReadUInt(6)

		local BuyedItems = {}
		local ItemsAmount = {}

		local ShopCart = {}

		for i=1, TableLen do
			BuyedItems[#BuyedItems+1] = net.ReadString()
		end

		for i=1, TableLen do
			ItemsAmount[#ItemsAmount+1] = net.ReadUInt(7)
		end

		for i=1, TableLen do
			ShopCart[#ShopCart+1] = {
				uniqueID = BuyedItems[i],
				amount = ItemsAmount[i]
			}
		end

		local bankID = net.ReadUInt(20)

		local totalcost = 0
		local totalamount = 0

		for k, v in ipairs(ShopCart) do
			
			if (entity.items[v.uniqueID] and
				hook.Run("CanPlayerTradeWithVendor", client, entity, v.uniqueID, false) != false) then
				local priceTotal = entity:GetPrice(v.uniqueID, false) * v.amount


				if (bankID != 0) then

					if (tonumber(PLUGINBank:GetAccountMoney(bankID)) < priceTotal) then
				        client:Notify("You don't have enough money in your account.")
				        return
				    end

				else

					if (!client:GetCharacter():HasMoney(priceTotal)) then
						return client:NotifyLocalized("canNotAfford")
					end

				end

				for i=1, v.amount do

					local price = entity:GetPrice(v.uniqueID, false)


					if (bankID != 0) then

						if (tonumber(PLUGINBank:GetAccountMoney(bankID)) < price) then
					        client:Notify("You don't have enough money in your account.")
					        break
					    end

					else

						if (!client:GetCharacter():HasMoney(price)) then
							client:NotifyLocalized("canNotAfford")
							break
						end

					end

					local stock = entity:GetStock(v.uniqueID)

					if (stock and stock < 1) then
						client:NotifyLocalized("vendorNoStock")
						break
					end

					totalcost = totalcost + price
					totalamount = totalamount + 1

					if (bankID != 0) then
						PLUGINBank:UpdateBalance(bankID, PLUGINBank:GetAccountMoney(bankID) - price)
					else
						client:GetCharacter():TakeMoney(price)
					end

					entity:GiveMoney(price)

					if (!client:GetCharacter():GetInventory():Add(v.uniqueID)) then
						ix.item.Spawn(v.uniqueID, client)
					end

					entity:TakeStock(v.uniqueID)

				end

				PLUGINVendor:SaveData()
				hook.Run("CharacterVendorTraded", client, entity, v.uniqueID, false)
			else
				client:NotifyLocalized("vendorNoTrade")

				net.Start("ixVendorTrade_ClearCart")
				net.Send(client)

				return
			end

		end

		client:NotifyLocalized("businessPurchase", totalamount.." items", ix.currency.Get(totalcost))

		net.Start("ixVendorTrade_ClearCart")
		net.Send(client)

	end)


	net.Receive("ixVendorTrade_Extd_Sell", function(length, client)
		if ((client.ixVendorTry or 0) < CurTime()) then
			client.ixVendorTry = CurTime() + 0.33
		else
			return
		end

		local entity = client.ixVendor

		if (!IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 192) then
			return
		end

		local sellamount = net.ReadUInt(6)
		local uniqueID = net.ReadString()


		if (entity.items[uniqueID] and
			hook.Run("CanPlayerTradeWithVendor", client, entity, uniqueID, true) != false) then
			local totalcost = 0

			local name = L(ix.item.list[uniqueID].name, client)

			for i=1, sellamount do
				local price = entity:GetPrice(uniqueID, true)

				local found = false
				

				if (!entity:HasMoney(price)) then
					return client:NotifyLocalized("vendorNoMoney")
				end

				local stock, max = entity:GetStock(uniqueID)

				if (stock and stock >= max) then
					return client:NotifyLocalized("vendorMaxStock")
				end

				local invOkay = true

				for _, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
					if (v.uniqueID == uniqueID and v:GetID() != 0 and ix.item.instances[v:GetID()] and v:GetData("equip", false) == false) then
						invOkay = v:Remove()
						found = true

						break
					end
				end

				if (!found) then
					return
				end

				if (!invOkay) then
					client:GetCharacter():GetInventory():Sync(client, true)
					return client:NotifyLocalized("tellAdmin", "trd!iid")
				end

				client:GetCharacter():GiveMoney(price)
				entity:TakeMoney(price)
				entity:AddStock(uniqueID)

				totalcost = totalcost + price

			end

			client:NotifyLocalized("businessSell", name, ix.currency.Get(totalcost))

			PLUGINVendor:SaveData()
			hook.Run("CharacterVendorTraded", client, entity, uniqueID, true)
		else
			client:NotifyLocalized("vendorNoTrade")
		end

	end)

else

	function PLUGIN:CalcView(client, origin, angles, fov)
		-- local view = self.BaseClass:CalcView(client, origin, angles, fov) or {}

		local shopMenu = ix.gui.vendor
	
		if (IsValid(shopMenu) and shopMenu:IsVisible()) then
			local view = {}

			local newOrigin, newAngles, newFOV, bDrawPlayer = shopMenu:GetOverviewInfo(origin, angles, fov)

			view.drawviewer = bDrawPlayer
			view.fov = newFOV
			view.origin = newOrigin
			view.angles = newAngles

			return view

		end

		
	end

	function PLUGIN:VGUIMousePressed(pnl, mouse)

		local shopUI = ix.gui.vendor

		if (!pnl) or (!IsValid(pnl)) then return end

		if (shopUI) and IsValid(shopUI) then

			if (mouse == MOUSE_RIGHT) then
				if (shopUI.CategoryItemsRendered) and (!shopUI.HoverOnItem) then
					-- shopUI:RenderCategories()
					shopUI:AnimationTransition(shopUI.grid, false)
				elseif (!shopUI:GetReadOnly()) and (shopUI.entity) and (shopUI.entity:GetCanBeRob()) then
						shopUI.Query = true

						Derma_Query(
						    "Are you sure you want to rob a vendor?",
						    "Rob the Vendor",
						    "Yes",
						    function() 
						    	shopUI:RobTheVendor()
						    	shopUI.Query = false
						    end,
							"No",
							function()
								shopUI.Query = false
							end
						)
					-- end

				end

			end
		end
	end

	net.Receive("ixVendor_UpdateTitle", function(len, client)

		local title = net.ReadString()
		local titleFont = net.ReadString()

		if (IsValid(ix.gui.vendor)) then
			ix.gui.vendor:UpdateTitleAndFont(title, titleFont)
		end

	end)

	net.Receive("ixVendorTrade_Rob", function(len, client)

		if (IsValid(ix.gui.vendor)) then
			ix.gui.vendor:CharAnimation(true)
		end

	end)

	net.Receive("ixVendorTrade_ClearCart", function(length, client)

		if (IsValid(ix.gui.vendor)) then
			ix.gui.vendor:ClearCart()
		end

	end)


end