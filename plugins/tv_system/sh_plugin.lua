PLUGIN.name = "TVs"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "TV and broadcast system."

-- Include all meta files.
for k, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	ix.util.Include( "meta/" .. v )
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

-- Channel interface access flag;
local channelFlag = "N"

ix.flag.Add(channelFlag, "Access to channel creation menu.", function(client, isGiven)
	if (isGiven) then
		client:Give("tv_camera")
		client:SelectWeapon("tv_camera")
	else
		client:StripWeapon("tv_camera")
	end
end)

ix.config.Set("allowVoice", true)

ix.command.Add("Channel", {
	description = "Manage your channel.",
	OnCheckAccess = function(command, client)
		return client:GetCharacter():HasFlags(channelFlag);
	end,
	OnRun = function(self, client)
		net.Start("ix.tv.channel.open_ui")
		net.Send(client)
	end
})