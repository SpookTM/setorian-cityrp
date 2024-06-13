
local PLUGIN = PLUGIN

local PANEL = {}

AccessorFunc(PANEL, "bEditable", "Editable", FORCE_BOOL)
AccessorFunc(PANEL, "itemID", "ItemID", FORCE_NUMBER)

surface.CreateFont( "defaultx", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local colors = {
	[1] = { r = 0, g = 0, b = 0},
	[2] = { r = 0, g = 0, b = 255},
	[3] = { r = 255, g = 0, b = 0},
	[4] = { r = 0, g = 200, b = 0},
	[5] = { r = 255, g = 255, b = 0}
}

local drawcolor

function PANEL:Init()
	if (IsValid(PLUGIN.panel)) then
		PLUGIN.panel:Remove()
	end

	self:SetSize(ScrW() * 0.4, ScrH() * 0.6)
	self:Center()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self.Paint = nil
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(true)

	self.texcior = self:Add("Panel")
	self.texcior:Dock(LEFT)
	self.texcior:SetWide(ScrW() * 0.3)
	self.texcior.Paint = function( self, pw, ph )
		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(Material("pngegg.png"))
		surface.DrawTexturedRect( 0, 0, pw, ph )
    end

	self.close = self:Add("DButton")
	self.close:Dock(TOP)
	self.close:DockMargin(ScrW() * 0.01, ScrH() * 0.05, ScrW() * 0.01, 0)
	self.close:SetText(L("close"))
	self.close.DoClick = function()
		if (self.bEditable) then
			netstream.Start("ixWritingEdit", self.itemID, self.text:GetValue():sub(1, PLUGIN.maxLength), drawcolor)
		end

		self:Close()
	end
	self.close.Paint = function( self, pw, ph )
		surface.SetDrawColor( 40, 59, 67 )
		surface.DrawRect(0, 0, pw, ph)
	end

	self.text = self.texcior:Add("DTextEntry")
	self.text:SetMultiline(true)
	self.text:SetEditable(false)
	self.text:SetDisabled(true)
	self.text:SetFont("defaultx")
	self.text:Dock(FILL)
	self.text:SetPaintBackground(false)
	self.text:DockMargin(ScrW() * 0.085, ScrH() * 0.015, ScrW() * 0.045, ScrH() * 0.015)


	self:MakePopup()

	self.container = self:Add("Panel")
	self.container:Dock(TOP)
	self.container:SetHeight(ScrH() * 0.023)
	self.container:DockMargin(ScrW() * 0.022, ScrH() * 0.05, ScrW() * 0.0245, 0)
	self.container.Paint = function( self, pw, ph )
        surface.SetDrawColor( Color( 255, 255, 255 ) )
        surface.DrawOutlinedRect( 0, 0, pw, ph )
    end
	local i = 0

	for k, v in pairs( colors ) do
		self.kolorek = self.container:Add("DButton")
		self.kolorek:SetSize( 14, 14)
		self.kolorek:SetText("")
		if i == 0 then
			self.kolorek:SetPos(5, 5)
		else
			self.kolorek:SetPos(i*17 + 5, 5)
		end
		self.kolorek.Paint = function( self, pw, ph )
        	surface.SetDrawColor( Color( v.r, v.g, v.b ) )
        	surface.DrawRect( 0, 0, pw, ph )
			surface.SetDrawColor( Color( 255, 255, 255 ) )
			surface.DrawOutlinedRect(0, 0, pw, ph)
		end
		self.kolorek.DoClick = function()
			self.text:SetTextColor(Color( v.r, v.g, v.b))
			drawcolor = Color(v.r, v.g, v.b)
		end
		i = i + 1
	end


	self.bEditable = false
	PLUGIN.panel = self
end

function PANEL:Think()
	local text = self.text:GetValue()

	if (text:len() > PLUGIN.maxLength) then
		local newText = text:sub(1, PLUGIN.maxLength)

		self.text:SetValue(newText)
		self.text:SetCaretPos(newText:len())

		surface.PlaySound("common/talk.wav")
	end
end

function PANEL:SetEditable(bValue)
	bValue = tobool(bValue)

	if (bValue == self.bEditable) then
		return
	end

	if (bValue) then
		self.close:SetText(L("save"))
		self.text:SetEditable(true)
		self.text:SetDisabled(false)
	else
		self.close:SetText(L("close"))
		self.text:SetEditable(true)
		self.text:SetDisabled(false)
	end

	self.bEditable = true
end

function PANEL:SetText(text, textcolor)
	self.text:SetValue(text)
	self.text:SetTextColor(textcolor)
end

function PANEL:OnRemove()
	PLUGIN.panel = nil
end

vgui.Register("ixPaper", PANEL, "DFrame")
