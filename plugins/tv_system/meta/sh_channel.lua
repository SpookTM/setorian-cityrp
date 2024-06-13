local channel = ix.meta.channel or {}

channel.__index = channel

--- Channel character ID to block character from creating multiple channels;
channel.charID = 0;

--- Channel name is name of the current channel used by player;
channel.name = "Unknown channel";

--- Channel title is title of current news used for info;
channel.title = "";

--- Small topic of current news above title;
channel.topic = "";

--- Last stream time;
channel.lastStream = 0;

function channel:__tostring()
	return "Channel[" .. self:GetID() .. "][" .. self:Name() .. "]"
end

function channel:__eq( objectOther )
	return self:GetID() == objectOther:GetID()
end

function channel:GetID()
	return self.charID;
end

function channel:Name()
    return self.name;
end;

--- Is channel is actually streaming now;
function channel:IsStreaming()
	local owner = ix.char.loaded[ self.charID ];

	if owner then
		local client = owner:GetPlayer()
		if client and client:Alive() then
			local weapon = client:GetActiveWeapon();
			local weaponClass = weapon and weapon ~= NULL and weapon:GetClass() == "tv_camera" 
			local camPos = weaponClass and weapon:GetPos() + weapon:GetForward() * 38 + weapon:GetUp() * 15 + weapon:GetRight() * 5
			local isWalled = weaponClass and util.TraceHull( { start = camPos, endpos = weapon:GetPos() + weapon:GetForward() * 50, filter = {client, weapon} } )

			return 
			weaponClass 
			and (isWalled and not isWalled.Hit) 
			and {vector =  camPos, angles = client:EyeAngles()};
		end;
	end;

	return false;
end;

if SERVER then
	function channel:SendTo( client )
		local data = util.TableToJSON( self )
		data = util.Compress( data )
		local len = #data

		net.Start("ix.tv.channel.send")
			net.WriteUInt( len, 16 )
            net.WriteData( data, len )
		if client then net.Send( client ) else net.Broadcast() end;
	end;
end;

ix.meta.channel = channel