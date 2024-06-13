ITEM.name = "Placable Items"
ITEM.description = "Because why the fuck isn't this in by default?"
ITEM.category = "Placeable"
ITEM.model = "models/player/skeleton.mdl" -- Because I'm 💀

ITEM.functions.Place = {
	OnCanRun = function(itemTable)
		if (!itemTable.entityclass) then return false end
		
		if (itemTable.place_limit) then
			local client = itemTable.player

			-- I hate these loops, if only Helix had an ent picker 🙄
			local iCount = 0
			for k, v in next, ents.FindByClass(itemTable.entityclass) do
				if (v:GetNetVar("ownerID") != itemTable.playerID) then continue  end

				iCount = iCount + 1
			end

			if (iCount >= itemTable.place_limit) then 
				ix.util.Notify("You have reached the limit of placing this item", client)
				return false 
			end
		end

		return true
	end,
	OnRun = function(itemTable)
		local client = itemTable.player 

		local vSpawnPos = {
			start = client:GetShootPos(),
			endpos = client:GetShootPos() + client:GetAimVector() * 100,
			filter = client
		}
		vSpawnPos = util.TraceLine(vSpawnPos).HitPos

		local eEnt = ents.Create(itemTable.entityclass)
		eEnt:SetPos(vSpawnPos)
		eEnt:Spawn()

		eEnt.bPlaceableItem = true
		eEnt.itemTable = itemTable

		if (not IsValid(eEnt)) then
			return false
		end

		eEnt:SetNetVar("ownerID", itemTable.playerID)
		eEnt:SetNetVar("owner", client)

		return true
	end
}