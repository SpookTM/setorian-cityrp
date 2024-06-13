local PANEL = {}

function PANEL:Init()
    self.hoverColor = Color(255, 100, 100)
    self.defaultColor = Color(100, 100, 100)

    self:SetTextColor( self.defaultColor )
    self:SetFont('Channel_buttons')
    self:DockMargin(0, 8, 0, 8)
end;

function PANEL:Paint(w, h)
    local hover = self:IsHovered();

    if hover then
        self:SetTextColor( self.hoverColor )
    else
        self:SetTextColor( self.defaultColor )
    end;
end;

vgui.Register("CButton", PANEL, "DButton")