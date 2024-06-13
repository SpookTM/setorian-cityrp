local INTERFACE = {}
INTERFACE.DrawBlur = true
INTERFACE.HideFalloutHud = true

INTERFACE.borderW = 0
INTERFACE.borderH = 0

INTERFACE.infoHeight = 0
INTERFACE.buttonHeight = 0
INTERFACE.infoValues = {}

function INTERFACE:Init()
	if ( fo.ui.interface ) then
		fo.ui.interface:Remove()
	end
	fo.ui.interface = self

	fo.ui.BlurBackground(self, true)
	fo.ui.HideHUD(self, true)
	self:SetSize(sW(), sH())

	fo.ui.LockCursor()
end

function INTERFACE:OnRemove()
	fo.ui.UnlockCursor()
	self:OnRemoved()
end

function INTERFACE:OnRemoved()
end

function INTERFACE:FixInfoPanelsX()
	for _, p in pairs(self.infoValues) do
		if ( IsValid(p) ) then
			p:SetEndPosition()
		end
	end
end

-- Border sizing
function INTERFACE:SetBorderSize(w, h)
	self.borderW = w
	self.borderH = h

	self:FixInfoPanelsX()
end

function INTERFACE:GetBorderSize()
	return self.borderW, self.borderH
end

function INTERFACE:GetBorderWide()
	return self.borderW
end

function INTERFACE:GetBorderTall()
	return self.borderH
end

local yScrMargin = 42
local xScrMargin = 42
local xBorderMargin = 26
local yBorderMargin = 28

local lineHeight = 2
local fadeWidth = 30

-- Borders fades materials
--local fadeToTop = Material("forp/ui/interface/shared/line/fade_to_top.png")
--local fadeToRight = Material("forp/ui/interface/shared/line/fade_to_right.png")




function INTERFACE:Paint(w, h)
	local Schemacolor = ix.config.Get("color")

	surface.SetDrawColor( Schemacolor )

	-- Paint borders
	if ( self.borderW >= fadeWidth and self.borderH >= fadeWidth ) then
		local vSolidWidth = self.borderW - fadeWidth
		local hSolidWidth = self.borderH - fadeWidth

		surface.DrawRect( xScrMargin, sH() - yScrMargin - hSolidWidth, lineHeight, hSolidWidth)
		surface.DrawRect( xScrMargin, sH() - yScrMargin - hSolidWidth - fadeWidth, lineHeight, fadeWidth )

		surface.DrawRect( xScrMargin, sH() - yScrMargin, vSolidWidth, lineHeight)
		surface.DrawRect( xScrMargin + vSolidWidth, sH() - yScrMargin, fadeWidth, lineHeight )
	end

	-- Method to draw the main object
	self:DrawMain()
end

function INTERFACE:DrawMain()
end

local elementOffset = 30
local textElement = "forpLabel"
local buttonElement = "forpButton"

function INTERFACE:AddInfoTab(title, value)
	local titleP = self:Add(textElement)

		local titleH = titleP:GetTall()
		titleP:SetText(title or "")
		titleP:SetPos(xScrMargin + lineHeight + xBorderMargin, sH() - yScrMargin - lineHeight - yBorderMargin - self.infoHeight - titleH)

	local valueP = self:Add(textElement)
	
		table.insert(self.infoValues, valueP)
		-- Move value panel just before the end of the info border
		valueP.SetEndPosition = function(this)
			local parent = this:GetParent()

			local y = select(2, this:GetPos())
			this:SetPos(xScrMargin + lineHeight + self.borderW - this:GetWide(), y)
		end
		valueP.OnTextChanged = valueP.SetEndPosition

		local valueH = valueP:GetTall()
		valueP:SetText(value or "")
		valueP:SetPos(0, sH() - yScrMargin - lineHeight - yBorderMargin - self.infoHeight - valueH)
		valueP:SetEndPosition()

	-- Update info height
	self.infoHeight = self.infoHeight +  ( math.max(titleH, valueH) + elementOffset )

	return titleP, valueP
end

function INTERFACE:AddButton(title)
	local buttonP = self:Add(buttonElement)
	
		-- Move button panel before the end of the screen
		buttonP.SetEndPosition = function(this)
			local parent = this:GetParent()

			local y = select(2, this:GetPos())
			this:SetPos(sW() - xScrMargin - lineHeight - this:GetWide(), y)
		end
		buttonP.OnTextChanged = buttonP.SetEndPosition

		local buttonH = buttonP:GetTall()
		buttonP:SetText(title or "")
		buttonP:SetPos(0, sH() - yScrMargin - lineHeight - yBorderMargin - self.buttonHeight - buttonH)
		buttonP:SetEndPosition()

	-- Update info height
	self.buttonHeight = self.buttonHeight +  ( buttonH + elementOffset )

	return buttonP
end

vgui.Register("forpInterface", INTERFACE, "Panel")