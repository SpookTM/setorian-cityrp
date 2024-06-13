local BACKGROUND_COLOR = Color(0, 0, 0, 255)
local FOREGROUND_COLOR = Color(245, 245, 245, 255)

local KEYS = {
    "_,@",
    "ABC",
    "DEF",
    "GHI",
    "JKL",
    "MNO",
    "PQRS",
    "TUV",
    "WXYZ",
    "Cancel",
    "",
    "Enter"
}

local PANEL = {}

function PANEL:Init()
    self:SetPos(25, 90)
    self:SetSize(240, 240)

    self:InitChildren()
end

function PANEL:InitChildren()
    self.keys = {}
    local x, y = 0, 0

    for k, v in pairs(KEYS) do
        local key = self:AddKey(k, v)
        key:SetPos(x, y)
        
        table.insert(self.keys, key)

        x = x + 80

        if (k % 3) == 0 then
            x = 0
            y = y + 60
        end
    end
end

function PANEL:AddKey(number, text)
    local parent = self:GetParent()

    if tonumber(number) > 9 then
        if number == 10 then
            number = "CANCEL"
        elseif number == 11 then
            number = 0
        else
            number = "ENTER"
        end
    end

    local key = vgui.Create("ixSafeKey", self)
    key:SetSize(70, 50)
    key:SetFont("CloseCaption_Bold")
    key:SetTextColor(Color(0, 0, 0, 255))
    key:SetContentAlignment(4)
    key:SetText("")

    if tonumber(number) ~= nil then
        key:SetText("  " .. tostring(number))
    end

    key.DoClick = function()
        surface.PlaySound("safe/click.wav")
        LocalPlayer():EmitSound("safe/click.wav", nil, nil, 1, CHAN_STATIC)

        parent:Input(number)
    end

    key.secondary = vgui.Create("DLabel", key)
    key.secondary:SetPos(0, 0)
    key.secondary:SetSize(70, 50)
    -- key.secondary:SetFont("Trebuchet18")
    key.secondary:SetTextColor(Color(0, 0, 0, 255))
    key.secondary:SetContentAlignment(6)
    key.secondary:SetText(text .. "   ")

    key.secondary.Paint = function(self, w, h) end

    return key
end

function PANEL:Paint(w, h)
    -- draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
end

vgui.Register("ixSafeKeyboard", PANEL, "DPanel")

local PANEL = {}

function PANEL:Paint(w, h)
    local color = self:IsDown() and Color(240, 240, 240, 240) or FOREGROUND_COLOR

    draw.RoundedBox(8, 0, 0, w, h, BACKGROUND_COLOR)
    draw.RoundedBox(8, 1, 1, w - 2, h - 2, color)
end

vgui.Register("ixSafeKey", PANEL, "DButton")