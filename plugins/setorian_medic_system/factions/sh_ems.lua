
-- Since this faction is not a default, any player that wants to become part of this faction will need to be manually
-- whitelisted by an administrator.

FACTION.name = "Emergency Medical Service"
FACTION.description = "Help people."
FACTION.color = Color(20, 120, 185)
FACTION.pay = 10 -- How much money every member of the faction gets paid at regular intervals.
FACTION.isGloballyRecognized = true -- Makes it so that everyone knows the name of the characters in this faction.
-- FACTION.weapons = {"weapon_defibrillator"}
-- Note that FACTION.models is optional. If it is not defined, it will use all the standard HL2 citizen models.

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("defibrillator", 1)
end

FACTION_EMS = FACTION.index
