local sw, sh = ScrW(), ScrH();

local PANEL = {}

function PANEL:Init()
    gui.EnableScreenClicker(true);

	self:Place(450, 400)

	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);

    self.leftPanel = self:Add("Panel")
    self.leftPanel:Dock(LEFT)
    self.leftPanel:SetWide( 175 )
    self.leftPanel.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 255))
    end;

    self.info = self:Add("Panel")
    self.info:Dock(FILL)
    self.info:DockMargin(25, 10, 25, 10)
end

function PANEL:Populate()
    self.buttons = self.leftPanel:Add("Panel")
    self.buttons:SetWide( self.leftPanel:GetWide() )
    self.buttons:SetPos(0, 190)
    self.buttons:SetTall(220)

    local channel = ix.tv.channel.Get( LocalPlayer():GetCharacter():GetID() )

    local manageChannel = self.buttons:Add("CButton")
    manageChannel:Dock(TOP)
    manageChannel:SetText("Save")
    manageChannel:SizeToContents()
    manageChannel.DoClick = function( button )
        if Channel_cooldown and Channel_cooldown > CurTime() then
            ix.util.Notify("You can't do this another " .. math.Round(Channel_cooldown - CurTime()) .. " seconds.")
            return;
        end;
        net.Start("ix.tv.channel.create")
            net.WriteTable({
                name = self.channelName:GetValue(),
                title = self.channelTitle:GetValue(),
                topic = self.channelTopic:GetValue()
            })
        net.SendToServer()

        Channel_cooldown = CurTime() + 5;
    end;

    local deleteChannel = self.buttons:Add("CButton")
    deleteChannel:Dock(TOP)
    deleteChannel:SetText("Delete")
    deleteChannel:SizeToContents()

    deleteChannel.DoClick = function( button )
        if Channel_cooldown and Channel_cooldown > CurTime() then
            ix.util.Notify("You can't do this another " .. math.Round(Channel_cooldown - CurTime()) .. " seconds.")
            return;
        end;

        if channel then
            net.Start("ix.tv.channel.delete")
            net.SendToServer()

            timer.Simple(0, function()
                self:Refresh()
            end);
        end;

        Channel_cooldown = CurTime() + 5;
    end;

    local closeButton = self.buttons:Add("CButton")
    closeButton:Dock(TOP)
    closeButton:SetText("Exit")
    closeButton:SizeToContents()

    closeButton.DoClick = function( button )
        self:Close();
    end;

    self.channelName = self.info:Add("CEntryPanel")
    self.channelName:Dock(TOP)
    self.channelName:SetTitle("Channel name")

    self.channelTitle = self.info:Add("CEntryPanel")
    self.channelTitle:Dock(TOP)
    self.channelTitle:SetTitle("Channel title")

    self.channelTopic = self.info:Add("CEntryPanel")
    self.channelTopic:Dock(TOP)
    self.channelTopic:SetTitle("Channel topic")

    self:Refresh()
end;

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(245, 245, 245, 255))
end;

function PANEL:Refresh()
    local channel = ix.tv.channel.Get( LocalPlayer():GetCharacter():GetID() )
    self.channelName:SetValue(channel and channel.name or "")
    self.channelTitle:SetValue(channel and channel.title or "")
    self.channelTopic:SetValue(channel and channel.topic or "")
end;

vgui.Register("Channels", PANEL, "EditablePanel")