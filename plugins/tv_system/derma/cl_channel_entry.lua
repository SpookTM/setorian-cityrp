local PANEL = {}

local sw, sh = ScrW(), ScrH();

function PANEL:Init()
	self:SetFont("Channel_labels")
	self:SetUpdateOnType( true )
    self:SetTall(30)
end;

function PANEL:Paint( w, h )
	local placeholder, text = self:GetPlaceholderText(), self:GetText()
	local disabled = self:GetDisabled();

    draw.RoundedBox(0, 0, 0, w, h, Color(230, 230, 230, disabled and 70 or 255))
	self:DrawTextEntryText( not disabled and Color(0, 0, 0) or Color(200, 200, 200), Color(0, 0, 0), Color(0, 0, 0) )

	if placeholder and text:len() == 0 then
        draw.SimpleText(placeholder, "Channel_labels", sw * 0.001, sh * -0.002, Color(255, 255, 255, self:GetDisabled() and 25 or 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    end

end;

vgui.Register( 'CTextEntry', PANEL, 'DTextEntry' )