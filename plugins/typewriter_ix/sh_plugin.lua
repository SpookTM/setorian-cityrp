PLUGIN.name = "Typewriters"
PLUGIN.author = "Masco"
PLUGIN.desc = "Typewriters with Google Docs implementation."

MascoTypeWriter = MascoTypeWriter or {}

-------------------
-- Helix Include --
-------------------

ix.util.Include("sv_plugin.lua")
ix.util.Include("derma/cl_paper.lua")
ix.util.Include("derma/cl_typewriter.lua")
ix.util.Include("derma/cl_fonts.lua")

--------------------------
-- Helix Configurations --
--------------------------

ix.config.Add("MaxQuantityAmount", 10, "Maximum amount of documents that can be made at once.", nil, {
	data = {min = 0, max = 10},
	category = "Typewriters"
})

ix.config.Add("AntiSpamTime", 60, "Amount of time players have to wait between Typewriter uses.", nil, {
	data = {min = 0, max = 600},
	category = "Typewriters"
})