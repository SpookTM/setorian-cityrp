local PANEL = {}

function PANEL:Init()
	local size = ScrH() * 0.7
	self:SetSize(size, size)
	self:Center()
end

vgui.Register("SetorianCryptoFrame", PANEL, "DFrame")

