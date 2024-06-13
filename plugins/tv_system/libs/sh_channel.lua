ix.tv = ix.tv or {};
ix.tv.instances = ix.tv.instances or {};
ix.tv.matrixes = ix.tv.matrixes or 0;
ix.tv.id = ix.tv.id or 0;
ix.tv.CanHear = ix.tv.CanHear or {}

ix.tv.channel = ix.tv.channel or {};
ix.tv.channel.instances = ix.tv.channel.instances or {}

--- Minimum length of the channel name;
ix.tv.channel.name_min = 2;

--- Maximum length of the channel name;
ix.tv.channel.name_max = 20;

--- Minimum length of the channel title;
ix.tv.channel.title_min = 3

--- Maximum length of the channel title;
ix.tv.channel.title_max = 40;

--- Minimum length of the topic;
ix.tv.channel.topic_min = 5;

--- Maximum length of the topic;
ix.tv.channel.topic_max = 80;

--- Maximum time of the non-stream time;
--- To prevent channels from being forever non-streamed.
ix.tv.channel.streamCheck = 300;

function ix.tv.channel.New(uniqueID, data)
	local channel = setmetatable({}, ix.meta.channel)
    channel.charID = uniqueID
    channel.name = data.name or "Unknown channel"
    channel.title = data.title or "Unknown title"
    channel.topic = data.topic or "Unknown topic"
    channel.lastStream = os.time();

    return channel
end

function ix.tv.channel.Instance(uniqueID, data)
    if not data then data = {} end;
    data.name = data.name or "Unknown channel"
    data.title = data.title or "Unknown title"
    data.topic = data.topic or "Unknown topic"
    data.lastStream = os.time();

    if uniqueID then
        local channel = ix.tv.channel.New(uniqueID, data)
        ix.tv.channel.instances[ uniqueID ] = channel;

        return channel;
    end;
end;

function ix.tv.channel.Get( charID )
    return ix.tv.channel.instances[ charID ];
end;

function ix.tv.channel.Remove( charID )
    if ix.tv.channel.Get( charID ) then
        ix.tv.channel.instances[ charID ] = nil;
    end;
end;

function ix.tv.channel.CanCreate( charID, data )
    local name, title, topic = data.name, data.title, data.topic;

    if name and title and topic and charID then
        name = name:Trim();
        title = title:Trim();
        topic = topic:Trim();

        local nameLen, titleLen, topicLen = name:len(), title:len(), topic:len()

        if nameLen < ix.tv.channel.name_min then
            return false, "You can't create a channel, because name is too short."
        end;
        if nameLen > ix.tv.channel.name_max then
            return false, "You can't create a channel, because name is too long."
        end;

        if titleLen < ix.tv.channel.title_min then
            return false, "You can't create a channel, because title is too short."
        end;
        if titleLen > ix.tv.channel.title_max then
            return false, "You can't create a channel, because title is too long."
        end;

        if topicLen < ix.tv.channel.topic_min then
            return false, "You can't create a channel, because topic is too short."
        end;
        if topicLen > ix.tv.channel.topic_max then
            return false, "You can't create a channel, because topic is too long."
        end;

        if ix.tv.channel.Get( charID ) then
            return true, "You've successfully saved channel named '" .. name .. "'"
        else
            return true, "You've successfully created channel named '" .. name .. "'"
        end;

    end;

    return false, "You can't create a channel!";
end;

if CLIENT then
    local scrW, scrH = ScrW(), ScrH();

    function ix.tv.channel.DrawStreamOverlay()
        local client = LocalPlayer()
        local char = client:GetCharacter();
        if not (
            char and char:GetID() and ix.tv.channel.Get(char:GetID())
            and client:GetActiveWeapon() ~= NULL and client:GetActiveWeapon():GetClass() == "tv_camera"
        ) then
            return;
        end;
        local dataHeight = 120;
        local channel = ix.tv.channel.Get(char:GetID());
    
        surface.SetDrawColor(170, 50, 50, 100)
        surface.DrawRect(0, scrH - dataHeight, scrW, dataHeight)
        
        surface.SetFont( "Trebuchet24" )
        local nameW = surface.GetTextSize(channel.name);
        surface.SetTextColor( 255, 255, 255 )
        surface.SetTextPos( scrW - nameW - 8, 8 ) 
        surface.DrawText(channel.name)

        draw.SimpleText(channel.title, "Channel_big_title", 10, scrH - dataHeight + 8)
        draw.SimpleText(channel.topic, "Channel_big_topic", 11, scrH - dataHeight + 70)
    end;

    --- Draw no signal screen;
    --- @param w number Width
    --- @param h number Height
    function ix.tv.channel.DrawNoSignal(w, h)
        cam.Start2D()
            surface.SetDrawColor(50, 50, 255)
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText("NO SIGNAL", "CloseCaption_Bold", w * 0.4, h * 0.415)
        cam.End2D()
    end;
end;