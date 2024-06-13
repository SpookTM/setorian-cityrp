local PANEL = {}

local frame_background = Color(20, 20, 20)
local frame_header_background = Color(40, 40, 40)
local red_button_hovered = Color(189, 32, 0)
local red_button = Color(138, 23, 0)
local gray_button = Color(35, 35, 35)

function PANEL:Init()
	self:SetSize(ScrW() * 0.3, ScrH() * 0.196)
	self:SetTitle("")
    self:SetDraggable(false)
	self:Center()
	self:MakePopup()
    self.Paint = function(self, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, frame_background)
        draw.RoundedBoxEx(6, 0, 0, w, 30, frame_header_background, true, true, false, false)
        draw.DrawText("Typewriter Machine", "TypewriterTitleFont", w * 0.5, 8, color_white, TEXT_ALIGN_CENTER)
    end

    self.btnClose:Hide()
    self.FrameClose = self:Add("DButton")
    self.FrameClose:SetSize(50, 30)
    self.FrameClose:SetText("X")
    self.FrameClose:SetFont("TypewriterGeneralFont")
    self.FrameClose:SetColor(color_white)

	function self.FrameClose.PerformLayout(this,w, h)
		this:SetPos(self:GetWide() - w)
	end

    function self.FrameClose:Paint(w,h)
	    if self:IsHovered() then
			draw.RoundedBoxEx(6, 0, 0, w, h, red_button_hovered, false, true)
		else
			draw.RoundedBoxEx(6, 0, 0, w, h, red_button, false, true)
		end
    end

	function self.FrameClose.DoClick()
		self:Close()
	end

	self:SetAlpha(0)

	timer.Simple(0.05, function()
		if not self or not IsValid(self) then return end
		local x,y = self:GetPos()
		self:SetPos(x + 50, y + 50)
		self:MoveTo(x, y, 0.3, 0, -1)
		self:AlphaTo(255, 0.3, 0.15)
	end)

    self.OpenText = self:Add("DLabel")
    self.OpenText:SetZPos(1)
    self.OpenText:Dock(TOP)
    self.OpenText:DockMargin(0, 10, 0, 10)
    self.OpenText:SetText("Use this Typewriter to turn a Google Doc into an in-game item in your inventory.")
    self.OpenText:SetContentAlignment(5)
    self.OpenText:SetFont("TypewriterGeneralFont")

	self.Title = self:Add("DTextEntry")
	self.Title:SetZPos(2)
	self.Title:Dock(TOP)
	self.Title:SetPlaceholderText("Document Title")

	self.Body = self:Add("DTextEntry")
	self.Body:SetZPos(3)
	self.Body:DockMargin(0, 15, 0, 0)
	self.Body:Dock(TOP)
	self.Body:SetPlaceholderText("Document Body (Google Doc Link)")

    self.QuantityPanel = self:Add("DPanel")
    self.QuantityPanel:SetZPos(4)
    self.QuantityPanel:Dock(TOP)
    self.QuantityPanel:DockMargin(10, 10, 0, 0)
    self.QuantityPanel:SetSize(self:GetWide(), 30)
    self.QuantityPanel:SetPaintBackground(false)

    self.OpenText = self.QuantityPanel:Add("DLabel")
    self.OpenText:Dock(LEFT)
    self.OpenText:SetText("How many copies would you like? (Max " .. ix.config.Get("MaxQuantityAmount") .. ")")
    self.OpenText:SetContentAlignment(4)
    self.OpenText:SetFont("TypewriterGeneralFont")
    self.OpenText:SizeToContents()

    self.Amount = self.QuantityPanel:Add("DNumberWang")
	self.Amount:DockMargin(20, 0, 0, 0)
	self.Amount:Dock(LEFT)
	self.Amount:SetValue(1)
    self.Amount:SetMin(1)
    self.Amount:SetMax(ix.config.Get("MaxQuantityAmount"))

	self.CreateButton = self:Add("DButton")
	self.CreateButton:SetZPos(5)
	self.CreateButton:Dock(BOTTOM)
    self.CreateButton:SetSize(self:GetWide() * 0.95, 30)
    self.CreateButton:SetColor(color_white)
    self.CreateButton:SetFont("TypewriterGeneralFont")
	self.CreateButton:SetText("Create Document")
    self.CreateButton.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, gray_button)
        else
            draw.RoundedBox(0, 0, 0, w, h, red_button)
        end
    end

	self.CreateButton.DoClick = function(btn)
        net.Start("MascoType::CreateDocumentInv")
        net.WriteString(self.Title:GetText())
        net.WriteString(self.Body:GetText())
        net.WriteInt(self.Amount:GetValue(), 32)
        net.SendToServer()

		self:Close()
	end
end

vgui.Register("ixTypewriter", PANEL, "DFrame")