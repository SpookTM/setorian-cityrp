local PLUGIN = PLUGIN
PLUGIN.name = "Meth System"
PLUGIN.description = "Adds meth system"
PLUGIN.author = "JohnyReaper"
PLUGIN.MethRecipe =  {
	["Acetone"] = math.random(1,9),
	["Bismuth"] = math.random(1,4)*10,
	["Hydrogen"] = math.random(10,30),
	["Phosphoric"] = math.random(1,10),
}

ix.util.Include("sh_gasmask.lua", "shared")

ALWAYS_RAISED["dmod_methpipe"] = true

ix.config.Add("FreezerLifeTime", 600, "For how many seconds will the battery power the freezer?", nil, {
	data = {min = 60, max = 3600},
	category = "Meth System"
})

ix.config.Add("MethCookTime", 15, "How long in minutes does the meth have to cook to reach a cooking level of 100?", nil, {
	data = {min = 1, max = 60},
	category = "Meth System"
})

ix.config.Add("MethFreezeTime", 20, "How long in minutes does meth have to freeze in the freezer?", nil, {
	data = {min = 1, max = 60},
	category = "Meth System"
})

if (CLIENT) then

	surface.CreateFont("ixArchitexFont", {
		font = "Architext",
		size = 30,
		extended = true,
		antialias = true,
		weight = 1000
	})

	surface.CreateFont("ixArchitexFont2", {
		font = "Architext",
		size = 26,
		extended = true,
		antialias = true,
		weight = 1000
	})

	surface.CreateFont("ixArchitexFont3", {
		font = "Architext",
		size = 26,
		extended = true,
		antialias = true,
		weight = 700
	})

end

if (SERVER) then

	util.AddNetworkString("ixMethUpdateRecipe")

	function PLUGIN:PlayerInitialSpawn(ply)

		net.Start("ixMethUpdateRecipe")
			net.WriteTable(PLUGIN.MethRecipe)
		net.Send(ply)

	end

	function PLUGIN:OnReloaded()
		timer.Simple(0.5, function()
			net.Start("ixMethUpdateRecipe")
				net.WriteTable(PLUGIN.MethRecipe)
			net.Broadcast()
		end)
	end

else

	net.Receive( "ixMethUpdateRecipe", function( len, client )
		PLUGIN.MethRecipe = net.ReadTable()
	end)

end

function PLUGIN:Move(ply, mv)

	if (ply:GetVelocity():Length() > 10) then
		if (ply.IsSmashingMeth) then
			ply:SetAction(false)
			ply.IsSmashingMeth = false
		end
	end

end