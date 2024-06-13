ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Stretcher"
ENT.Category = "Setorian Medic System"

ENT.Spawnable = true

ENT.bNoPersist = true

function ENT:GetEntityMenu(client)
	local options = {}
	
	options["Take off the patient"] = true
	options["Reset positions"] = true
	options["Put in the ambulance"] = true

	return options
end