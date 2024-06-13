ITEM.name = "Gloves"
ITEM.model = "models/props_lab/box01a.mdl"

ITEM.functions.EquipUn = {
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:SetData("equip", false)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true
	end
}

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		item:SetData("equip", true)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true
	end
}