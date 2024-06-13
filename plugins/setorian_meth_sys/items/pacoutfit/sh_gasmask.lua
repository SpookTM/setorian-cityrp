ITEM.name = "Respirator"
ITEM.description = "A Gas-mask type Respirator that protects you from bad airs."
ITEM.model = "models/gmod4phun/w_contagion_gasmask.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.isGasMask = true
ITEM.price = 250
ITEM.category = "Outfit"
ITEM.outfitCategory = "gasmask"
ITEM.exRender = false
ITEM.bDropOnDeath = true

ITEM.pacData = {
	[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "3ae2ba693b0944d1c958c6edc8911e43a01a96a5a0f2e31da30c05c747cc56bd",
				["NoLighting"] = false,
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Materials"] = "",
				["Name"] = "",
				["LevelOfDetail"] = 0,
				["NoTextureFiltering"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TargetEntityUID"] = "",
				["Alpha"] = 1,
				["Material"] = "",
				["Invert"] = false,
				["ForceObjUrl"] = false,
				["Bone"] = "head",
				["Angles"] = Angle(-0.47049263119698, -78.68327331543, -90.213653564453),
				["AngleOffset"] = Angle(0, 0, 0),
				["BoneMerge"] = false,
				["Color"] = Vector(1, 1, 1),
				["Position"] = Vector(1.68359375, -3.690673828125, -0.049591064453125),
				["ClassName"] = "model2",
				["Brightness"] = 1,
				["Hide"] = false,
				["NoCulling"] = false,
				["Scale"] = Vector(1, 1, 1),
				["LegacyTransform"] = false,
				["EditorExpand"] = false,
				["Size"] = 1,
				["ModelModifiers"] = "",
				["Translucent"] = false,
				["BlendMode"] = "",
				["EyeTargetUID"] = "",
				["Model"] = "models/gmod4phun/w_contagion_gasmask_equipped.mdl",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "c9f7f1a7097977d185a6805a98a0b0ecfe34aba4d40125723c3eb181ae1f17f6",
		["Hide"] = false,
		["TargetEntityUID"] = "",
		["EditorExpand"] = true,
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "my outfit",
		["Duplicate"] = false,
		["ClassName"] = "group",
	},
},

}

local txtTable = {
	{math.huge, "txtCond0"},
	{75, "txtCond1"},
	{50, "txtCond2"},
	{25, "txtCond3"},
	{0.1, "txtCond4"}
}


if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end

	-- function ITEM:PopulateTooltip(tooltip)
	-- 	local filter = tonumber(self:getFilter()) or 0

	-- 	local fineHealthText = "ERROR"

	-- 	for _, b in pairs(txtTable) do
	-- 		if (b[1] > self:getHealth()) then
	-- 			fineHealthText = L(b[2])
	-- 		end
	-- 	end

	-- 	local panel = tooltip:AddRowAfter("name", "gasmaskstatus")
	-- 	panel:SetBackgroundColor((filter <= 0 and Color (192, 57, 43) or Color(39, 174, 96)))
	-- 	panel:SetText("Filter: " ..  L(filter <= 0 and "txtFail" or "txtFunc"))
	-- 	panel:SizeToContents()

	-- 	local panel2 = tooltip:AddRowAfter("gasmaskstatus", "gasmaskhp")
	-- 	panel2:SetBackgroundColor(derma.GetColor("Warning", tooltip))
	-- 	panel2:SetText("Condition: "..fineHealthText .. "(" ..self:getHealth() .. "%)")
	-- 	panel2:SizeToContents()
	-- end
end

function ITEM:isEquipped()
	return self:GetData("equip", false)
end

function ITEM:getHealth()
	return self:GetData("health", ix.config.Get("gasmask_health", 100))
end

function ITEM:damageHealth(amount)
	self:SetData("health", math.max(0, self:getHealth() - amount))
end

function ITEM:getFilter()
	return self:GetData("filter", ix.config.Get("gasmask_filter", 600))
end

function ITEM:damageFilter(amount)
	self:SetData("filter", math.max(0, self:getFilter() - amount))
end

local function playerGasmask(client, item, bool)
	local char = client:GetCharacter()

	if (bool) then
		client.ixGasMaskItem = item
		client:AddPart(item.uniqueID, item)

		netstream.Start(client, "ixMaskOn", item:GetID(), item:getHealth()) 
	else
		client.ixGasMaskItem = nil
		client:RemovePart(item.uniqueID)
		client.previousWep = client:GetActiveWeapon():GetClass()
		client:Give( "badair_gasmask_holster" )
		client:SelectWeapon("badair_gasmask_holster")
		timer.Simple( 1, function() 
			if (!client:Alive()) then return end
			client:StripWeapon("badair_gasmask_holster")
			client:SelectWeapon(client.previousWep)
			client.previousWep = nil
		end )

		netstream.Start(client, "ixMaskOff")
	end

	item:SetData("equip", bool)
	if (!bool) then
	client:EmitSound("gmod4phun/gasmask/unprone.wav", 80)
	end

	client:ScreenFade(1, Color(0, 0, 0, 255), 1, 0)
end

// external use
function ITEM:EquipMask(client, item, bool)

	item.player = client
	return playerGasmask(client, item, bool)


end	

ITEM:Hook("drop", function(item)
	if (item:isEquipped()) then
		local client = item.player
		
		playerGasmask(client, item, false)
	end
end)

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "unequipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)		
		playerGasmask(item.player, item, false)

		return false
	end,
	OnCanRun = function(item)
		return (!IsValid(item.entity) and item:isEquipped())
	end
}

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		local client = item.player

		if (client.nutGasMaskItem) then
			client:NotifyLocalized("maskEquipped")

			return false
		end

		-- INITIALIZE TEMP MASKVARS
		client:Give( "badair_gasmask_deploy" )
		client:SelectWeapon("badair_gasmask_deploy")
		client.previousWep = client:GetActiveWeapon():GetClass()
		item.player:EmitSound("gmod4phun/gasmask/goprone_03.wav", 80)
		timer.Simple( 1.2, function() 
			if (!client:Alive()) then return end
			playerGasmask(client, item, true)
			client:StripWeapon("badair_gasmask_deploy")
			client:SelectWeapon(client.previousWep)
			client.previousWep = nil
		end )

		return false
	end,
	OnCanRun = function(item)
		return (!IsValid(item.entity) and !item:isEquipped())
	end
}

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
	self:SetData("equip", false)
end