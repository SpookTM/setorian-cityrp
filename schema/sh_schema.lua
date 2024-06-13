// Discord     :       Spook™#0308

Schema.name = "Setorian City RP"
Schema.author = "Spook"
Schema.description = ""

function Schema:GetGameDescription()
	return "*Setorian - CITY RP*" 
end

// -- Libs -- //
ix.util.Include('libs/thirdparty/sh_netstream2.lua', 'shared')

// -- Schema -- //
ix.util.Include('cl_schema.lua', 'client')
ix.util.Include('sv_schema.lua', 'server')
ix.util.Include('sh_hooks.lua', 'shared')
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_voices.lua")
// -- Config -- //
ix.util.Include('sh_things.lua', 'shared')
ix.util.Include('sh_commands.lua', 'shared')