
local PLUGIN = PLUGIN

util.AddNetworkString( "PlayerJoined" )

netstream.Hook("ixWritingEdit", function(client, itemID, text, colortext)
	text = tostring(text):sub(1, PLUGIN.maxLength)

	local character = client:GetCharacter()
	local item = ix.item.instances[itemID]

	-- we don't check for entity since data can be changed in the player's inventory
	if (character and item and item.base == "base_writing") then
		local owner = item:GetData("owner", 0)

		if colortext == nil then
			if item:GetData("color") == nil then
				colortext = Color(0, 0, 0)
			else
				colortext = item:GetData("color")
			end
		end

		item:SetData("color", colortext, nil, true, true)
		
		if ((owner == 0 or owner == character:GetID()) and text:len() > 0) then
			item:SetText(text, character)
		end
	end
end)

function PLUGIN:PlayerInitialSpawn(ply, transition)
	    net.Start( "PlayerJoined" )
        net.WriteEntity( ply )
        net.Broadcast()
end
