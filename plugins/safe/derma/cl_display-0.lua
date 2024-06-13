local BACKGROUND_COLOR = Color(0, 0, 0, 255)
local FOREGROUND_COLOR = Color(245, 245, 245, 255)

local PANEL = {}

function PANEL:Init()
    self:SetPos(20, 20)
    self:SetSize(240, 50)

    self:InitChildren()
end

function PANEL:InitChildren()
    self.label = vgui.Create("DLabel", self)
    self.label:SetSize(220, 40)
    self.label:Center()
    self.label:SetContentAlignment(5)
    self.label:SetFont("CloseCaption_Bold")
    self.label:SetTextColor(Color(0, 0, 0, 255))
    self.label:SetText("")
end

function PANEL:Update(length)
    local text = ""

    for i = 1, length do
        text = text .. "*"
    end

    self.label:SetText(text)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, BACKGROUND_COLOR)
    draw.RoundedBox(8, 1, 1, w - 2, h - 2, FOREGROUND_COLOR)
end

vgui.Register("ixSafeDisplay", PANEL, "DPanel")