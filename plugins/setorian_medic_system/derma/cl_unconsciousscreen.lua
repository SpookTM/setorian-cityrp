
local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	self:SetSize(scrW, scrH)
	self:SetPos(0, 0)

	local text = string.utf8upper("You are unconscious")
	local text2 = string.utf8upper("No EMS Online")

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

function PANEL:Think()
	-- self.label:SetAlpha(((self.progress - 0.3) / 0.3) * 255)

	if (self:IsClosing()) then return end

	if (!LocalPlayer():Alive()) or (!LocalPlayer():GetLocalVar("ragdoll")) then
		self:Close()
	end

	if (self.NextEmsCheck > CurTime()) then return end

	self.NearestEms = 0

	local scrW = ScrW()

	for client, character in ix.util.GetCharacters() do
		
		if (client == LocalPlayer()) then continue end
		if (!client:Alive()) then continue end
		if (character:GetFaction() != FACTION_EMS) then continue end

		local locPos = LocalPlayer():GetPos()
		local emsPos = client:GetPos()
-- print(locPos:DistToSqr(emsPos))
		if (self.NearestEms > 0 and locPos:Distance(emsPos) < self.NearestEms) or (self.NearestEms == 0) then
			self.NearestEms = locPos:Distance(emsPos)
		end

	end
	
	local convertUnit = math.floor( self.NearestEms * ( 1 / 16 ) * 10 ) / 10

	local NewText = (self.NearestEms == 0 and "No EMS Online") or "Nearest EMS: "..convertUnit.."'"
	self.label2:SetText(string.utf8upper(NewText))
	self.label2:SizeToContents()
	self.label2:SetX(scrW * 0.5 - self.label2:GetWide() * 0.5)

	self.NextEmsCheck = CurTime() + 1

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

vgui.Register("ixUnconsciousScreen", PANEL, "Panel")
-- vgui.Create("ixUnconsciousScreen")