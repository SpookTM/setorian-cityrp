PLUGIN.name = "Item List"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = "Adds a Q-menu tab for all items."

CAMI.RegisterPrivilege({
	Name = "Helix - Item SpawnMenu",
	MinAccess = "superadmin"
})

cleanup.Register("ixItems")

ix.util.Include("sv_plugin.lua")

if (CLIENT) then
	local PLUGIN = PLUGIN

	local icons = {
		["Ammunition"] = "attach",
		["Armored Clothing"] = "shield",
		["Cards"] = "vcard",
		["Clothing"] = "user_suit",
		["Communication"] = "transmit",
		["Consumables"] = "cake",
		["Crafting"] = "add",
		["Deployables"] = "arrow_down",
		["Filters"] = "weather_clouds",
		["Gasmasks"] = "user_gray",
		["Ingredients"] = "package_add",
		["Junk"] = "bin_closed",
		["Literature"] = "book",
		["Medical"] = "heart_add",
		["Miscellaneous"] = "box",
		["Outfit"] = "user_add",
		["Permits"] = "report",
		["Raw Materials"] = "cog",
		["Remains"] = "bullet_red",
		["Reusables"] = "arrow_rotate_clockwise",
		["Storage"] = "briefcase",
		["Union Branded Items"] = "asterisk_yellow",
		["Tools"] = "wrench_orange",
		["Weapons"] = "gun"
	}

	spawnmenu.AddContentType("ixItem", function(container, item)
		if (!item.name) then return end

		local slot = vgui.Create("Panel", container)
		slot:SetSize(100, 100)
		slot.Paint = function(t, w, h)
			local hovered

			if (t:IsHovered() or t.icon and t.icon:IsHovered()) then
				hovered = ix.config.Get("color")
			end

			derma.SkinFunc("PaintButton2", t, w, h, hovered)
		end

		local icon = slot:Add('SpawnIcon')
		slot.icon = icon

		icon:SetSize(92, 92 * 1.4)
		icon:SetZPos(1)
		icon:Dock(FILL)
		icon:DockMargin(5, 5, 5, 10)
		icon:InvalidateLayout(true)
		icon:SetModel(item:GetModel(), item:GetSkin())

		icon:SetHelixTooltip(function(tooltip)
			ix.hud.PopulateItemTooltip(tooltip, item)
		end)

		icon.OnMousePressed = function(this, code)
			if !(CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Item SpawnMenu", nil)) then return end

			if (code == MOUSE_LEFT) then
				net.Start("MenuItemSpawn")
					net.WriteString(item.uniqueID)
				net.SendToServer()

				surface.PlaySound("ui/buttonclickrelease.wav")
			elseif (code == MOUSE_RIGHT) then
				local menu = DermaMenu()

				local give_self = menu:AddSubMenu("Give self")

				if (item.isStackable) then
					give_self:AddOption("Stack x" .. (item.maxQuantity or 16), function()
						net.Start("MenuItemGive")
							net.WriteString(item.uniqueID)
							net.WriteBool(true)
						net.SendToServer()
					end)
				end

				give_self:AddOption("One", function()
					net.Start("MenuItemGive")
						net.WriteString(item.uniqueID)
						net.WriteBool(false)
					net.SendToServer()
				end)

				menu:AddSpacer()

				local copy = menu:AddSubMenu("Copy to Clipboard")
				copy:AddOption("Model", function() SetClipboardText(item.model) end)
				copy:AddOption("ItemID", function() SetClipboardText(item.uniqueID) end)

				menu:Open()			
			end
		end

		icon.Paint = function(t, w, h) end
		icon.PaintOver = function(t, w, h) end

		if (IsValid(container)) then
			container:Add(slot)
		end

		return slot
	end)

	spawnmenu.AddCreationTab("Items", function()
		local base = vgui.Create("SpawnmenuContentPanel")
		local tree = base.ContentNavBar.Tree
		local categories = {}

		vgui.Create("ItemSearchBar", base.ContentNavBar)

		for _, v in SortedPairsByMemberValue(ix.item.list, "category") do
			if (!categories[v.category]) then
				categories[v.category] = true

				local node = tree:AddNode(L(v.category), icons[v.category] and ("icon16/" .. icons[v.category] .. ".png") or "icon16/brick.png")

				node.DoPopulate = function(self)
					if (self.Container) then return end

					self.Container = vgui.Create("ContentContainer", base)
					self.Container:SetVisible(false)
					self.Container:SetTriggerSpawnlistChange(false)

					for _, itemTable in SortedPairsByMemberValue(ix.item.list, "name") do
						if (itemTable.category == v.category) then
							spawnmenu.CreateContentIcon("ixItem", self.Container, itemTable)
						end
					end
				end

				node.DoClick = function(self)
					self:DoPopulate()
					base:SwitchPanel(self.Container)
				end
			end
		end

		local FirstNode = tree:Root():GetChildNode(0)

		if (IsValid(FirstNode)) then
			FirstNode:InternalDoClick()
		end

		PLUGIN:PopulateContent(base, tree, nil)

		return base
	end, "icon16/script_key.png")

	timer.Simple(0, function()
		RunConsoleCommand("spawnmenu_reload")
	end)
end