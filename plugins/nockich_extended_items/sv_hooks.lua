function PLUGIN:PlayerUse(client, eEnt)
	if (not eEnt.bPlaceableItem) then return end
	if (not eEnt.itemTable) then return end

	if (client:KeyDown(IN_DUCK) and eEnt:GetNetVar("owner") == client) then
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		
		if (inventory:Add(eEnt.itemTable.uniqueID)) then
			eEnt:Remove()

			return false
		end
	end
end

function PLUGIN:EntityRemoved(eEnt)
	if (not eEnt.bPlaceableItem) then return end
	if (not eEnt.itemTable) then return end
end