
local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	self:SetSize(scrW, scrH)
	self:SetPos(0, 0)

	local text = string.utf8upper("You are under medical care")
	local text2 = string.utf8upper("You'll be awake soon")

	surface.SetFont("ixMenuButtonHugeFont")
	local textW, textH = surface.GetTextSize(text)
	local textW2, textH2 = surface.GetTextSize(text2)

	self.label = self:Add("DLabel")
	self.label:SetPaintedManually(true)
	self.label:SetPos(scrW * 0.5 - textW * 0.5, scrH * 0.5 - textH * 0.5)
	self.label:SetFont("ixMenuButtonHugeFont")
	self.label:SetText(text)
	self.label:SetAlpha(0)
	self.label:SizeToContents()

	self.label:AlphaTo(255, 2)

	self.label2 = self:Add("DLabel")
	self.label2:SetPaintedManually(true)
	self.label2:SetPos(scrW * 0.5, scrH * 0.5 + textH * 0.5)
	self.label2:SetFont("ixMenuButtonFontThick")
	-- self.label2:SetContentAlignment(5)
	self.label2:SetText(text2)
	self.label2:SetAlpha(0)
	self.label2:SetTextColor(Color(230,230,230))
	self.label2:SizeToContents()
	self.label2:SetX(scrW * 0.5 - self.label2:GetWide() * 0.5)

	self.label:AlphaTo(255, 2)
	self.label2:AlphaTo(255, 2)

	self.progress = 0

	self.NextEmsCheck = CurTime()
	self.NearestEms = 0
	self.IsNearestEms = false

	-- self:CreateAnimation(25, {
	-- 	bIgnoreConfig = true,
	-- 	target = {progress = 1},

	-- 	OnComplete = function(animation, panel)
	-- 		if (!panel:IsClosing()) then
	-- 			panel:Close()
	-- 		end
	-- 	end
	-- })

end

function PANEL:IsClosing()
	return self.bIsClosing
end

function PANEL:Close()
	self.bIsClosing = true

	self.label:AlphaTo(0, 2)
	self.label2:AlphaTo(0, 2)

	self:CreateAnimation(2, {
		index = 2,
		bIgnoreConfig = true,
		target = {progress = 0},

		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})
end

function PANEL:Paint(width, height)
	-- derma.SkinFunc("PaintDeathScreenBackground", self, width, height, self.progress)
		self.label:PaintManual()
		self.label2:PaintManual()
	-- derma.SkinFunc("PaintDeathScreen", self, width, height, self.progress)
end

vgui.Register("ixMedicHealScreen", PANEL, "Panel")
-- vgui.Create("ixStabilizedScreen")