local panel = FindMetaTable("Panel");

function panel:Place(w, h, x, y)
    local sW, sH = ScrW(), ScrH()
    local positions = (x and y and x + y >= 0)

    w = math.Clamp(w, 10, 1920);
    h = math.Clamp(h, 10, 1080);
    self:SetSize( sW * (w / 1920), sH * (h / 1080) )

    x = positions and math.Clamp(x, 0, 1.25) or 0;
    y = positions and math.Clamp(y, 0, 1.25) or 0;
    self:SetPos( sW * x, sH * y )
    if not positions then self:Center() end
end;

function panel:Close()
	gui.EnableScreenClicker(false);
	self:AlphaTo(0, .2, 0, function()
        self:SetVisible(false);
        self:Remove()
    end)
end;