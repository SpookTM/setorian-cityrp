
-- Since this faction is not a default, any player that wants to become part of this faction will need to be manually
-- whitelisted by an administrator.

FACTION.name = "FBI"
FACTION.description = "Very angry policemen that have a tendency to injure people."
FACTION.color = Color(20, 120, 185)
FACTION.pay = 10 -- How much money every member of the faction gets paid at regular intervals.
FACTION.weapons = {
"weapon_pistol", "weapon_rpt_handcuff", "weapon_rpt_finebook", "weapon_rpt_stungun", "dradio"
}
FACTION.isGloballyRecognized = true -- Makes it so that everyone knows the name of the characters in this faction.

-- Note that FACTION.models is optional. If it is not defined, it will use all the standard HL2 citizen models.

FACTION_FBI = FACTION.index
