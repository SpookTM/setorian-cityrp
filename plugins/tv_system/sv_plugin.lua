local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(.25, function()
		local id = character:GetID();

        local data = util.TableToJSON( ix.tv.channel.instances )
        data = util.Compress( data )
        local len = #data

        net.Start("ix.tv.channel.sendAll")     
            net.WriteUInt( len, 16 )
            net.WriteData( data, len )
        net.Send( client )
	end);
end;

function PLUGIN:PostPlayerLoadout(client)
    -- A timer;
    -- If player see a TV and it's working and close enough to him, then the player will hear it;
    local uniqueID = client:SteamID64() .. "ixTVCanReceiveSound"
    timer.Create(uniqueID, 0.5, 0, function()
        if not IsValid( client ) then
            timer.Remove( uniqueID )
            return;
        end;

        for _, tv in pairs( ix.tv.instances ) do
            if IsValid(tv) then
                local trace = util.TraceHull( { start = client:EyePos(), endpos = tv:GetPos(), filter = {client} } )
                if tv:GetTurned() 
                and client:GetPos():DistToSqr( tv:GetPos() ) < 100000 
                and trace.Hit and trace.Entity == tv then
                    local TvChannel = tv:GetChannel()
                    if ix.tv.CanHear[TvChannel] then
                        client.ixTVCanHear = ix.tv.CanHear[TvChannel]
                    end;
                else
                    client.ixTVCanHear = {}
                end;
            end;
        end;
    end)
end

-- Delete the character ownership from the TV if char is deleted;
function PLUGIN:CharacterDeleted( client, id )
    for k, tv in pairs( ix.tv.instances ) do
        if tv:GetOwnerID() == id then
            tv:SetOwnerID( 0 );
        end;
    end;
end;

function PLUGIN:SaveData()
	local data = {};
	for i, entity in pairs( ix.tv.instances ) do
		if entity ~= NULL then
			local buffer = {};
			buffer.position = entity:GetPos();
			buffer.angles = entity:GetAngles();
            buffer.id = entity.tvID;
            buffer.charID = entity:GetOwnerID();

			table.insert(data, buffer)
		end;
	end

    ix.data.Set("ix.tv", data)
end;

function PLUGIN:LoadData()
	for i, tv in ipairs( ix.data.Get("ix.tv", {}) ) do
		local entity = ents.Create( "ent_tv" )
		entity:SetPos( tv.position )
		entity:SetAngles( tv.angles )
        entity.tvID = tv.id;
		entity:Spawn()
        entity:SetOwnerID( tv.charID )

        ix.tv.id = tv.id;
	end;
end;

function PLUGIN:Initialize()
    -- Add tv to global ignore list;
    ix.entityplacing.ignore["ent_tv"] = true;
end;

timer.Create("ix.tv.channel.Global_stream_check", 30, 0, function()
    for charID, channel in pairs( ix.tv.channel.instances ) do
        if channel:IsStreaming() then
            channel.lastStream = os.time();
        else
            if ((channel.lastStream == 0) 
                or (channel.lastStream + ix.tv.channel.streamCheck < os.time())) and not channel:IsStreaming() then
                    ix.tv.channel.Remove(charID);
                    net.Start("ix.tv.channel.delete.sync")
                        net.WriteInt( charID, 16 )
                    net.Broadcast()
            end;
        end;
    end
end)

function PLUGIN:PlayerCanHearPlayersVoice( listener, talker )
    if not talker:Alive() then
        return false;
    end;

    return listener.ixTVCanHear and listener.ixTVCanHear[ talker ], false;
end;