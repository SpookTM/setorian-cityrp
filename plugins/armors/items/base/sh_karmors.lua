ITEM.name = "Armor"
ITEM.model = Model("models/tnb/items/shirt_rebelbag.mdl")
ITEM.width = 2
ITEM.height = 2
ITEM.description = "..."
ITEM.price = 25
ITEM.category = "Armors"
ITEM.hitgroups = 2
ITEM.outfitCategory = "chest"
local max = 100

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end

    function ITEM:PopulateTooltip(tooltip)
		if (self:GetData("equip")) then
			local name = tooltip:GetRow("name")
			name:SetBackgroundColor(derma.GetColor("Success", tooltip))
		end

		if (self:GetData("durability", 100)) then
			local durability = tooltip:AddRow("durability")
			durability:SetBackgroundColor(derma.GetColor("Warning", tooltip))
			durability:SetText("Durability: "..self:GetData("durability", 100))
			durability:SetHeight(3)
			durability:SetExpensiveShadow(0.5)
			durability:SizeToContents()
		end

		if (self:GetData("kevlar", 100)) then
			local kevlar = tooltip:AddRow("kevlar")
			kevlar:SetBackgroundColor(derma.GetColor("Warning", tooltip))
			kevlar:SetText("Kevlar's durability: "..self:GetData("kevlar", 100))
			kevlar:SetHeight(3)
			kevlar:SetExpensiveShadow(0.5)
			kevlar:SizeToContents()
		end
    end
end

function ITEM:OnInstanced()
	self:SetData("durability", 100)
	self:SetData("kevlar", 100)
end

ITEM.functions.Equip = {
	name = "Equip",
    icon = "icon16/tick.png",
    OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and item:GetData("durability", 100) > 0 and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
    end,
	OnRun = function(item)
        local ply = item.player
        local item = item
        local char = ply:GetCharacter()

		for _, v in pairs(char:GetInventory():GetItems()) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if ((v.outfitCategory == item.outfitCategory) and item:GetData("equip")) then
					ply:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
					return false
				end
			end
		end

        ply:AddPart(item.uniqueID, item)
        item:SetData("equip", true)

        return false
	end
}

ITEM.functions.EquipUn = {
	name = "Unequip",
    icon = "icon16/cross.png",
    OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
    end,
	OnRun = function(item)
        local ply = item.player
        local item = item
        local char = ply:GetCharacter()

        ply:RemovePart(item.uniqueID)
        item:SetData("equip", false)

        return false
	end
}

ITEM.functions.Kevlar = {
	name = "Repair",
	tip = "equipTip",
	icon = "icon16/bullet_wrench.png",
	OnRun = function(item)
		local client = item.player
		local has_remnabor = client:GetCharacter():GetInventory():HasItem("sewing")
		
		if has_remnabor then
			has_remnabor:Remove()
			item:SetData("durability", math.Clamp(item:GetData("durability", max) + 25, 0, max))
		else
			client:Notify("Repair is not possible")
		end	

		has_remnabor = nil
		
		return false
	end,
	OnCanRun = function(item)
		if item:GetData("durability", max) >= max then return false end
		
		if not item.player:GetCharacter():GetInventory():HasItem("sewing") then
			return false
		end
		
		return true
	end
}

ITEM.functions.Repair = {
	name = "Change kevlar",
	tip = "equipTip",
	icon = "icon16/bullet_wrench.png",
	OnRun = function(item)
		local client = item.player
		local has_kevlar = client:GetCharacter():GetInventory():HasItem("kevlar_plate")
		
		if has_kevlar then
			has_kevlar:Remove()
			item:SetData("kevlar", 100)
		else
			client:Notify("It is impossible to insert the plate")
		end	

		has_kevlar = nil
		
		return false
	end,
	OnCanRun = function(item)
		if item:GetData("kevlar", max) >= max then return false end
		
		if not item.player:GetCharacter():GetInventory():HasItem("kevlar_plate") then
			return false
		end
		
		return true
	end
}

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			owner:Notify("To move this thing you need to take it off!")
		end

		return false
	end

	return true
end

function ITEM:OnEquipped()
end

function ITEM:OnUnequipped()
end