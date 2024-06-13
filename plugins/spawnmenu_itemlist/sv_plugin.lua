util.AddNetworkString('MenuItemSpawn')
util.AddNetworkString('MenuItemGive')

net.Receive('MenuItemSpawn', function(len, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item SpawnMenu", nil)) then return end

	local uniqueID = net.ReadString()
	if (ix.item.list[uniqueID]) then
		local vStart = client:GetShootPos()
		local data = {}

		data.start = vStart
		data.endpos = vStart + (client:GetAimVector() * 2048)
		data.filter = client

		local trace = util.TraceLine(data)
		local angles = (trace.HitPos - client:GetPos()):Angle()
		angles.r = 0
		angles.p = 0
		angles.y = angles.y + 180

		ix.item.Spawn(uniqueID, trace.HitPos, function(item, entity)
			entity:SetPos(trace.HitPos - trace.HitNormal * entity:OBBMins().z)

			client:Notify("You have spawned a " .. item.name .. ".")

			undo.Create("ixItem")
				undo.AddEntity(entity)
				undo.SetPlayer(client)
				undo.SetCustomUndoText('Undone ' .. item:GetName())
			undo.Finish()

			client:AddCleanup("ixItems", entity)
		end, angles)
	end
end)

net.Receive('MenuItemGive', function(len, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item SpawnMenu", nil)) then return end

	local uniqueID = net.ReadString()
	local itemTable = ix.item.list[uniqueID]

	if (itemTable) then
		local quantity = net.ReadBool() and (itemTable.maxQuantity or 16) or 1
		local result, message = client:GetCharacter():GetInventory():Add(uniqueID, 1, {quantity = quantity})

		if (!result) then
			client:NotifyLocalized(message)
			return
		end

		client:Notify("You have given "..client:Name().." a " .. itemTable.name .. ".")
	end

	itemTable = nil
end)