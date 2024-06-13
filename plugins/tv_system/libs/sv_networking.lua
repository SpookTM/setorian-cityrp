util.AddNetworkString("ix.tv.channel.open_ui")
util.AddNetworkString("ix.tv.channel.create")
util.AddNetworkString("ix.tv.channel.send")
util.AddNetworkString("ix.tv.channel.sendAll")
util.AddNetworkString("ix.tv.channel.delete")
util.AddNetworkString("ix.tv.channel.delete.sync")
util.AddNetworkString("ix.tv.OnDeploy")
util.AddNetworkString("ix.tv.transporting.start")
util.AddNetworkString("ix.tv.transporting.finish")

net.Receive("ix.tv.channel.create", function(len, client)
    if client.channelCreateCD and client.channelCreateCD > CurTime() then
        return;
    end;

    local charID = client:GetCharacter():GetID();
    local channel = net.ReadTable();
    local canCreate, reason = ix.tv.channel.CanCreate( charID, channel );

    if canCreate then
        channel = ix.tv.channel.Instance(charID, channel)

        channel:SendTo();

        local uniqueID = client:SteamID64() .. "ixTVCanTranslateSound";

        timer.Create(uniqueID, 0.5, 0, function()
            local channel = ix.tv.channel.Get( charID );

            if not IsValid( client ) or not channel then
                if ix.tv.CanHear[ charID ] then 
                    ix.tv.CanHear[charID] = nil;
                end;
                timer.Remove(uniqueID)
                return;
            end;

            local position = client:EyePos();

            if channel:IsStreaming() then
                for _, talker in ipairs(player.GetAll()) do
                    if not ix.tv.CanHear[ charID ] then
                        ix.tv.CanHear[ charID ] = {};
                    end;
                    ix.tv.CanHear[ charID ][ talker ] = talker:GetPos():DistToSqr( position ) < 6000
                end;
            end;
        end)
    end;

    client.channelCreateCD = CurTime() + 5;

    client:Notify(reason)
end)

net.Receive("ix.tv.channel.delete", function(len, client)
    if client.channelCreateCD and client.channelCreateCD > CurTime() then
        return;
    end;

    local charID = client:GetCharacter():GetID()
    local channel = ix.tv.channel.Get( charID )
    
    if channel then
        ix.tv.channel.Remove( charID )

        net.Start("ix.tv.channel.delete.sync")
            net.WriteInt( charID, 16 )
        net.Broadcast()

        client:Notify("You've successfully deleted your channel")
    end;

    client.channelCreateCD = CurTime() + 5;
end)

-- Check if player accepted or declined replacement.
net.Receive("ix.tv.transporting.finish", function(len, client)
	local result = net.ReadBool()
    local obbMaxs = net.ReadVector()
    local yaw = net.ReadFloat()
    local furniture = client:GetLocalVar("furniture", NULL);

	if result then
        if furniture and IsValid(furniture) then        
            local trace = client:GetEyeTrace()
            local position = trace.HitPos + trace.HitNormal * obbMaxs.z;

            local entity = ents.Create( "ent_tv" )
            entity:SetPos( position )
            entity:SetAngles( Angle(0, yaw, 0) )
            entity.tvID = furniture.tvID;
            entity:Spawn()
            entity:SetOwnerID( furniture:GetOwnerID() )

            entity:Touch( client )
            
            furniture:Remove();
            client:SetLocalVar("furniture");
        end;
    else
        if furniture then
    		furniture:SetCollisionGroup( 8 )
        end;
	end;
end)