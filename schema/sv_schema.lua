local clear_ents = {
	["ix_item"] = true,
	["ix_money"] = true
}

function Schema:ShutDown()
	for _, v in ipairs(ents.GetAll()) do
		if (clear_ents[v:GetClass()]) then
			v:Remove()
		end
	end
end

function Schema:OnPlayerHitGround( pl )
    local vel = pl:GetVelocity()
    pl:SetVelocity(Vector( - (vel.x * 1), - (vel.y*1), 0))
end

function Schema:PlayerLoadedCharacter( ply, curChar, prevChar )
	timer.Simple(0, function()
		if (IsValid(ply)) then
			local position = curChar:GetData("pos")

			if (position) then
				if (position[3] and position[3]:lower() == game.GetMap():lower()) then
					ply:SetPos(position[1].x and position[1] or ply:GetPos())
					ply:SetEyeAngles(position[2].p and position[2] or Angle(0, 0, 0))
				end

				curChar:SetData("pos", nil)
			end
		end
	end)
end

function Schema:SearchPlayer(client, target)
	if (!target:GetCharacter() or !target:GetCharacter():GetInventory()) then
		return false
	end

	local name = hook.Run("GetDisplayedName", target) or target:Name()
	local inventory = target:GetCharacter():GetInventory()

	ix.storage.Open(client, inventory, {
		entity = target,
		name = name
	})

	return true
end

function Schema:PlayerUse(client, entity)
	if (!client:IsRestricted() and entity:IsPlayer() and entity:IsRestricted() and !entity:GetNetVar("untying")) then
		entity:SetAction("@beingUntied", 5)
		entity:SetNetVar("untying", true)

		client:SetAction("@unTying", 5)

		client:DoStaredAction(entity, function()
			entity:SetRestricted(false)
			entity:SetNetVar("untying")
		end, 5, function()
			if (IsValid(entity)) then
				entity:SetNetVar("untying")
				entity:SetAction()
			end

			if (IsValid(client)) then
				client:SetAction()
			end
		end)
	end
end

function Schema:PlayerLoadout(client)
	client:SetNetVar("restricted")
end

function Schema:CharacterVarChanged(character, key, oldValue, value)
	local client = character:GetPlayer()
	if (key == "name") then
		local factionTable = ix.faction.Get(client:Team())

		if (factionTable.OnNameChanged) then
			factionTable:OnNameChanged(client, oldValue, value)
		end
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team())

	if (factionTable.runSounds and client:IsRunning()) then
		client:EmitSound(factionTable.runSounds[foot])
		return true
	end

	client:EmitSound(soundName)
	return true
end

function Schema:PlayerSpawn(a)
	a:SetCanZoom( false )
end

function Schema:OnNPCKilled(npc, attacker, inflictor)
	if (IsValid(npc.ixPlayer)) then
		hook.Run("PlayerDeath", npc.ixPlayer, inflictor, attacker)
	end
end

function Schema:CanPlayerJoinClass(client, class, info)
	if (client:IsRestricted()) then
		client:Notify("You cannot change classes when you are restrained!")

		return false
	end
end

function Schema:PlayerSpawnObject(client)
	if (client:IsRestricted()) then
		return false
	end
end

function Schema:PlayerSpray(client)
	return true
end

ix.log.AddType("mapEntRemoved", function(client, index, model)
	return string.format("%s has removed map entity #%d (%s).", client:Name(), index, model)
end)
