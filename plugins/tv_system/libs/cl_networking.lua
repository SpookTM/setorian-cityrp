net.Receive("ix.tv.channel.open_ui", function(len)
    if ix.tv.channel.ui and ix.tv.channel.ui:IsValid() then
		ix.tv.channel.ui:Close()
	end

	ix.tv.channel.ui = vgui.Create("Channels")
	ix.tv.channel.ui:Populate()
end)

net.Receive("ix.tv.channel.send", function(len)
	local dataLen = net.ReadUInt( 16 );
	local data = net.ReadData( dataLen );
	data = util.Decompress( data );
	data = util.JSONToTable(data);

	ix.tv.channel.Instance(tonumber(data.charID), data)
end)

net.Receive("ix.tv.channel.sendAll", function(len)
	local dataLen = net.ReadUInt( 16 );
	local data = net.ReadData( dataLen );
	data = util.Decompress( data );
	data = util.JSONToTable(data);
	
	for charID, channel in pairs( data ) do
		ix.tv.channel.Instance(tonumber(charID), channel)
	end;
end)

net.Receive("ix.tv.channel.delete.sync", function(len)
	local charID = net.ReadInt(16);

	ix.tv.channel.Remove(charID);
end)

net.Receive("ix.tv.OnDeploy", function(len)
    ix.util.Notify("Press " .. input.LookupBinding( "+speed" ) .. " + " .. input.LookupBinding( "+use" ) .. " buttons to move up the tv.");
end)

net.Receive("ix.tv.transporting.start", function(len)
	ix.tv.transporting = true;
end)