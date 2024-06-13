local PANEL = {}

local frame_background = Color(20, 20, 20)
local frame_header_background = Color(40, 40, 40)
local red_button_hovered = Color(189, 32, 0)
local red_button = Color(138, 23, 0)

function PANEL:Init()
	self:SetSize(ScrW() * 0.6, ScrH() * 0.90)
	self:SetTitle("")
    self:SetDraggable(false)
	self:Center()
	self:MakePopup()
    self.Paint = function(self, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, frame_background)
        draw.RoundedBoxEx(6, 0, 0, w, 30, frame_header_background, true, true, false, false)
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
end

function PANEL:SetDocument(item)
	self:SetTitle(item:GetData("DocumentName", item.name))

	local body = item:GetData("DocumentBody", "INVALID")

	self.document = self:Add("DHTML")
	self.document:SetZPos(1)
	self.document:Dock(FILL)
    local exploded = string.Explode("/", body, false)
    exploded[#exploded] = "preview"

    self.document:OpenURL(string.Implode("/", exploded))
end

vgui.Register("ixDocument", PANEL, "DFrame")