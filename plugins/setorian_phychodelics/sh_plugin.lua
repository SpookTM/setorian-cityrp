
PLUGIN.name = "Psychedelics Mod"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = "Adds support for Psychedelics Mod"

if SERVER then

	local psychs_ents = {
		["psychedelics_diethylamine"] = true,
		["psychedelics_flask"] = true,
		["psychedelics_hexane"] = true,
		["psychedelics_lysergic_acid"] = true,
		["psychedelics_substrate"] = true,
		["psychedelics_blotter_1sheet"] = true,
		["psychedelics_blotter_25sheet"] = true,
		["psychedelics_blotter_5sheet"] = true,
		["psychedelics_blotter_sheet"] = true,
		["psychedelics_phosphorus_oxychloride"] = true,
		["psychedelics_phosphorus_pentachloride"] = true,
		["psychedelics_spores"] = true,
	}

	function PLUGIN:CanPlayerHoldObject(client, entity)
		if (psychs_ents[entity:GetClass()]) then return true end
	end

	function PLUGIN:PlayerLoadedCharacter(ply, char, prevChar)

		ply:SetNWInt("psychedelicsSellMoney", 0)

		net.Start("psychedelicsDeathS")
			net.ReadEntity(ply)
		net.Send(ply)

		net.Start("psychedelicsDeathL")
			net.ReadEntity(ply)
		net.Send(ply)

	end

end