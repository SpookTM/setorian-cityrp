local PANEL = {}

function PANEL:Init()
	self.text = self:Add("ixLabel")
	self.text:Dock(TOP)
	self.text:SetText("")
    self.text:SetFont("Channel_labels")
	self.text:DockMargin(0, 5, 0, 5)
    self.text:SetTextColor(Color(30, 30, 30))

    self.entry = self:Add("CTextEntry")
    self.entry:Dock(TOP)
    self.entry:DockMargin(5, 0, 5, 0)
    self.entry:SizeToContents()

	self:InvalidateLayout( true )
    self:SizeToChildren( true, true )
end

function PANEL:SetTitle(text)
	self.text:SetText(text, 5)
	self.text:SizeToContents()
end;

function PANEL:SetDisabled(bool)
    self.entry:SetDisabled(true)
end;

function PANEL:SetValue( str )
    self.entry:SetText( str )
end;

function PANEL:GetValue()
    return self.entry:GetValue()
end;

function PANEL:Paint(w, h) end;

vgui.Register("CEntryPanel", PANEL, "EditablePanel")