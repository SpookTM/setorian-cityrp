
local PLUGIN = PLUGIN

PLUGIN.name = "Better Crafting"
PLUGIN.author = "wowm0d"
PLUGIN.description = "Adds a better crafting solution to helix."
PLUGIN.license = [[
Copyright 2020 wowm0d
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
]]
PLUGIN.readme = [[
Adds a better crafting solution to helix.
---
> The better crafting plugin is a fully featured and robust crafting system.
Recipes are put into the /recipes/ folder and crafting stations are put into the /stations/ folder.

When creating recipes you can add hooks to before and after any action, example:
```lua
RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
```
This will check for a unique crafting station within range called workbench - this hook is called after every other check inside OnCanCraft is made, if you want to hook this before OnCanCraft you would use PreHook instead of PostHook. This hooking feature allows you to literally do anything within your recipes. Available hooks are `"OnCanCraft", "OnCanSee", "OnCraft"` they all have the recipeTable and client as arguments.
Recipe Format:
```lua
RECIPE.name = "RecipeName"
RECIPE.description = "HoverDescription"
RECIPE.model = "UIDisplayModel"
RECIPE.category = "UICraftingCategory"
RECIPE.requirements = {
	["item_uniqueID"] = 1,
	["item_uniqueID"] = 2 -- number is amount required
}
RECIPE.results = {
	["item_uniqueID"] = 1,
	["item_uniqueID"] = {1, 2, 5}, -- table of amounts to choose from
	["item_uniqueID"] = {["min"] = 1, ["max"] = 10} -- table of min and max value
}
RECIPE.tools = {"item_uniqueID", "item_uniqueID"}
RECIPE.flag = "F" -- flag to restrict visibility and a requirement
```
Station Format:
```lua
STATION.name = "HoverName"
STATION.description = "HoverDescription"
STATION.model = "WorldModel"
```

## Preview
![Menu](https://i.imgur.com/UxzQ3kz.png)
If you like this plugin and want to see more consider getting me a coffee. https://ko-fi.com/wowm0d

Support for this plugin can be found here: https://discord.gg/mntpDMU
]]

ix.util.Include("cl_hooks.lua", "client")
ix.util.Include("sh_hooks.lua", "shared")

ix.util.Include("meta/sh_recipe.lua", "shared")
ix.util.Include("meta/sh_station.lua", "shared")

if (SERVER) then
	util.AddNetworkString("ixSetorianCraft_UI")
	util.AddNetworkString("ixSetorianCraft_AddToQueue")
	util.AddNetworkString("ixSetorianCraft_RemoveFromQueue")
	util.AddNetworkString("ixSetorianCraft_ClaimItems")

	net.Receive( "ixSetorianCraft_AddToQueue", function( len, client )

		local tableEnt = net.ReadEntity()
		local recipeID = net.ReadString()

		local itemQuantity = net.ReadUInt(4)


		if (!IsValid(tableEnt)) then return end
		if (!string.find( tableEnt:GetClass(), "ix_station" )) then return end

		if (!PLUGIN.craft.recipes[recipeID]) then
			print("Recipe Data doesn't exists")
			return
		end

		if (tableEnt.QueueItems) and (!table.IsEmpty(tableEnt.QueueItems)) then

			if (#tableEnt.QueueItems + itemQuantity) > 12 then
				itemQuantity = 12 - #tableEnt.QueueItems
			end

		end

		local char = client:GetCharacter()
		local inv  = char:GetInventory()

		local recipeData = PLUGIN.craft.recipes[recipeID]

		if (recipeData.tools) then

			for k, v in SortedPairs(recipeData.tools or {}) do

				local itemTable = ix.item.list[v]

				if (!itemTable) then continue end

				local hasItem = inv:HasItem(v)

				if (!hasItem) then
					client:Notify("You don't have enough ingredients to craft this item")
					return false
				end

			end

		end

		if (recipeData.flag) then

			if (!char:HasFlags(recipeData.flag)) then
				client:Notify("You don't have a flag that would allow you to carft this item")
				return false
			end

		end

		if (recipeData.requirements) then

			for k, v in SortedPairs(recipeData.requirements or {}) do

				local itemTable = ix.item.list[k]

				if (!itemTable) then continue end

				local itemCount = inv:GetItemCount(k)

				if (itemCount < (v*itemQuantity)) then
					client:Notify("You don't have enough ingredients to craft this item")
					return false
				end

			end

			for k, v in SortedPairs(recipeData.requirements or {}) do

				for i=1, (v*itemQuantity) do

					local item = inv:HasItem(k)

					if (item) then
						item:Remove()
					end

				end

			end

		end

		for i=1, itemQuantity do

			local tabPos = #tableEnt.QueueItems+1

			tableEnt.QueueItems[tabPos] = {
				recipeID = recipeID,
				craftStart = CurTime() + (5*(tabPos-1)),
				craftFinish = CurTime() + (5*tabPos)
			}
		end

		client:Notify("Item has been added to the crafting queue")

		net.Start("ixSetorianCraft_AddToQueue")
			net.WriteString(recipeID)
			net.WriteUInt(itemQuantity,4)
		net.Send(client)


	end)

	net.Receive( "ixSetorianCraft_RemoveFromQueue", function( len, client )

		local tableEnt = net.ReadEntity()

		local queueID = net.ReadUInt(4)


		if (!IsValid(tableEnt)) then return end
		if (!string.find( tableEnt:GetClass(), "ix_station" )) then return end

		if (!tableEnt.QueueItems[queueID]) then
			print("There is no item on the given queue position")
			return
		end

		local recipeID = tableEnt.QueueItems[queueID].recipeID

		if (!PLUGIN.craft.recipes[recipeID]) then
			print("Recipe Data doesn't exists")
			return
		end

		local recipeData = PLUGIN.craft.recipes[recipeID]

		if (recipeData.requirements) then

			local char = client:GetCharacter()
			local inv  = char:GetInventory()

			for k, v in SortedPairs(recipeData.requirements or {}) do

				local resultItem = k

				for i=1, v do

					if (!inv:Add(resultItem)) then
			            ix.item.Spawn(resultItem, client)
			        end

			    end

			end

		end


		table.remove(tableEnt.QueueItems, queueID)

		client:Notify("Item has been removed from the crafting queue")

	end)


	net.Receive( "ixSetorianCraft_ClaimItems", function( len, client )

		local tableEnt = net.ReadEntity()

		if (!IsValid(tableEnt)) then return end
		if (!string.find( tableEnt:GetClass(), "ix_station" )) then return end

		local itemsToDelete = {}

		for k, v in ipairs(tableEnt.QueueItems) do

			if (CurTime() < v.craftFinish) then continue end

			local recipeID = v.recipeID

			-- PLUGIN.craft.CraftRecipe(client, recipeID)

			if (!PLUGIN.craft.recipes[recipeID]) then
				print("Recipe Data doesn't exists")
				return
			end

			local recipeData = PLUGIN.craft.recipes[recipeID]

			local char = client:GetCharacter()
			local inv  = char:GetInventory()

			for uniqueID, amount in SortedPairs(recipeData.results) do
				if (istable(amount)) then
					if (amount["min"] and amount["max"]) then
						amount = math.random(amount["min"], amount["max"])
					else
						amount = amount[math.random(1, #amount)]
					end
				end

				for i = 1, amount do
					if (!inv:Add(uniqueID)) then
						ix.item.Spawn(uniqueID, client)
					end
				end
			end

			itemsToDelete[#itemsToDelete+1] = k
			
		end

		for k, v in SortedPairs(itemsToDelete, true) do
			table.remove(tableEnt.QueueItems, v)
		end


		-- tableEnt.QueueItems = nil

		client:Notify("You have received the crafted items")

		net.Start("ixSetorianCraft_ClaimItems")
		net.Send(client)

	end)

end