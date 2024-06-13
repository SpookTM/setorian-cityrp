Setorian = Setorian or {}
Setorian.Crypto = {}
Setorian.Crypto.Config = {}
Setorian.Crypto.Translation = {}
Setorian.Crypto.Core = {}
Setorian.Crypto.Database = {}
Setorian.Crypto.Icons = {}
Setorian.Crypto.Tokens = {}
Setorian.Crypto.Users = {}

print("Loading Setorian | Crypto")

local path = "setorian_crypto/"
if SERVER then
	local files, folders = file.Find(path .. "*", "LUA")
	
	for _, folder in SortedPairs(folders, true) do
		print("Loading folder:", folder)
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        AddCSLuaFile(path .. folder .. "/" .. File)
	        include(path .. folder .. "/" .. File)
	    end
	
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sv_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end
	
	    for b, File in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        AddCSLuaFile(path .. folder .. "/" .. File)
	    end
	end
end

if CLIENT then
	local files, folders = file.Find(path .. "*", "LUA")
	
	for _, folder in SortedPairs(folders, true) do
		print("Loading folder:", folder)
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end

	    for b, File in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end
	end
end

Setorian.Crypto.Core.RefreshAllTokenData()

timer.Create("Setorian:Crypto:RefreshData", Setorian.Crypto.Config.RefreshSpeed, 0, Setorian.Crypto.Core.RefreshAllTokenData)

print("Loaded Setorian | Crypto")