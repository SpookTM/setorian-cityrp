local BACKGROUND_COLOR = Color(0, 0, 0, 255)
local FOREGROUND_COLOR = Color(245, 245, 245, 255)

local PANEL = {}

function PANEL:Init()
    self:SetSize(280, 350)
    self:Center()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetDraggable(true)
    self:MakePopup()

    self:InitChildren()
end

function PANEL:InitChildren()
    self.display = vgui.Create("ixSafeDisplay", self)
    self.keyboard = vgui.Create("ixSafeKeyboard", self)

    self.password = ""
end

function PANEL:Input(key)
    if key == "ENTER" then
        self:Close()

        if not self.entity or not IsValid(self.entity) then return end

        net.Start("ixSafePassword")
            net.WriteEntity(self.entity)
            net.WriteString(self.password)
        net.SendToServer()
        
        return
    end
    
    if key == "CANCEL" then
        if #self.password == 0 then
            self:Close()

            return
        end

        self.password = string.sub(self.password, 1, #self.password - 1)
    elseif #self.password < 12 then
        self.password = self.password .. key
    end

    self.display:Update(#self.password)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, BACKGROUND_COLOR)
    draw.RoundedBox(8, 1, 1, w - 2, h - 2, FOREGROUND_COLOR)
end

vgui.Register("ixSafe", PANEL, "DFrame")