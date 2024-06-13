local PLUGIN = PLUGIN
ITEM.name = "Zip Tie"
ITEM.description = "An orange zip-tie used to restrict people."
ITEM.price = 8
ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.factions = {FACTION_MPF, FACTION_OTA}
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:GetCharacter()
		and !target:GetNetVar("tying") and !target:IsRestricted()) then
			itemTable.bBeingUsed = true

			client:EmitSound("physics/plastic/plastic_barrel_strain"..math.random(1, 3)..".wav")
			client:SetAction("@tying", 5)

			client:DoStaredAction(target, function()
				target:SetRestricted(true)
				target:SetNetVar("tying")
				target:NotifyLocalized("fTiedUp")

				PLUGIN:ApplyZipTieBones(target)
				client:EmitSound("npc/barnacle/neck_snap1.wav", 100, 140)

				itemTable:Remove()
			end, 5, function()
				client:SetAction()

				target:SetAction()
				target:SetNetVar("tying")

				itemTable.bBeingUsed = false
			end)

			target:SetNetVar("tying", true)
			target:SetAction("@fBeingTied", 5)
		else
			itemTable.player:NotifyLocalized("plyNotValid")
		end

		return false
	end,
	OnCanRun = function(itemTable)
		return !IsValid(itemTable.entity) or itemTable.bBeingUsed
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	return !self.bBeingUsed
end
