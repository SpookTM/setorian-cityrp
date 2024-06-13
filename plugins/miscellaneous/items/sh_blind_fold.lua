local PLUGIN = PLUGIN
ITEM.name = "Blindfold"
ITEM.description = "Black bag that can be put on someone's head."
ITEM.price = 12
ITEM.model = "models/props_junk/garbage_bag001a.mdl"
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
		and !target:GetNetVar("blindfolding")) then

			if (!target:IsRestricted()) then
				itemTable.player:NotifyLocalized("tieFirst")
				return false
			end

			itemTable.bBeingUsed = true

			client:SetAction("@blinding", 5)

			client:DoStaredAction(target, function()
				target:SetBlindfold(true)
				target:SetNetVar("blindfolding")
				target:NotifyLocalized("fblindfoldedUp")
				client:EmitSound("npc/barnacle/neck_snap1.wav", 100, 140)
				target:ScreenFade( SCREENFADE.OUT, Color( 0,0,0 ), 0.3, 1 )

				itemTable:Remove()
			end, 5, function()
				client:SetAction()

				target:SetAction()
				target:SetNetVar("blindfolding")

				itemTable.bBeingUsed = false
			end)

			target:SetNetVar("blindfolding", true)
			target:SetAction("@fBeingBlind", 5)
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
