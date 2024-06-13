local PLUGIN = PLUGIN
PLUGIN.name = "Cocaine System"
PLUGIN.description = "Adds cocaine system"
PLUGIN.author = "JohnyReaper"

ix.util.Include("sh_meta.lua", "shared")
ix.util.Include("cl_hooks.lua", "client")

ix.config.Add("BatteryLifeTime", 300, "For how many seconds will the battery power the lamp?", nil, {
	data = {min = 60, max = 3600},
	category = "Cocaine System"
})

ix.config.Add("CocaineProcessTime", 10, "In how many minutes will the processor create a brick of cocaine", nil, {
	data = {min = 1, max = 60},
	category = "Cocaine System"
})

ix.config.Add("PlantGrowthTime", 20, "How many minutes does a plant need to grow fully?", nil, {
	data = {min = 1, max = 60},
	category = "Cocaine System"
})

ix.config.Add("PlantGrowthTimeOffset", 2, "Offset makes the time to full grow of the plant and can be longer or shorter by this variable" , nil, {
	data = {min = 0, max = 4},
	category = "Cocaine System"
})

ix.config.Add("DryingTime", 10, "After how long will the leaves be dry in the dryer? [In minutes]", nil, {
	data = {min = 1, max = 60},
	category = "Cocaine System"
})

ix.config.Add("CocaDuration", 7, "Duration in minutes of effect after cocaine use", nil, {
	data = {min = 1, max = 20},
	category = "Cocaine System"
})

function PLUGIN:Move(ply, mv)

	if (ply:GetVelocity():Length() > 10) then
		if (ply.IsCuttingBrick) then
			ply:SetAction(false)
			ply.IsCuttingBrick = false
		end
	end

end

if (SERVER) then

	function PLUGIN:Think() //char:SetData("OverDoseCocaine", char:GetData("OverDoseCocaine", 0) + 1)

		for client, char in ix.util.GetCharacters() do
			
			if (char:GetData("OverDoseCocaine", 0) > 0) then

				if (client.OverDoseCocaineTimer or 0) < CurTime() then

					char:SetData("OverDoseCocaine", char:GetData("OverDoseCocaine", 0) - 1)
					client.OverDoseCocaineTimer = CurTime() + (ix.config.Get("CocaDuration", 7) * 2)

				end

			end

		end

	end

	function PLUGIN:PlayerDeath(client, inflictor, attacker)
		if (client:IsCocaineDrugged()) then
			client:GetCharacter():SetData("OverDoseCocaine", 0)
			client.OverDoseCocaineTimer = CurTime()
			client:SetCocaineDrugged(false)
		end
	end

	function PLUGIN:PlayerDisconnected(client)
		if (client:IsCocaineDrugged()) then
		    client:SetCocaineDrugged(false)
		end
	end

	function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)

		if (client:IsCocaineDrugged()) then
			client:SetCocaineDrugged(false)
		end

	    client.OverDoseCocaineTimer = CurTime() + ix.config.Get("CocaDuration", 7)
	end

end