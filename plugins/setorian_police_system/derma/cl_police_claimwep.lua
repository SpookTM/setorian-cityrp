
local animationTime = 1
DEFINE_BASECLASS("DFrame")

local PANEL = {}

function PANEL:Init()

	self:SetSize( 300, 100 )
	self:Center()
	self:MakePopup()
	self:SetTitle("")
	self:ShowCloseButton(true)
	self:SetDraggable(false)
	self.Paint = function(s,w,h)
		surface.SetDrawColor( 52, 73, 94 )
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor( 44, 62, 80 )
	    surface.DrawRect(0,0,w,24)


	    
	end

	local DoneButtonAlpha = 0
	self.DoneButton = vgui.Create( "DButton", self )
	self.DoneButton:Dock(BOTTOM)
	self.DoneButton:DockMargin(0,5,0,5)
	self.DoneButton:SetTall(30)
	self.DoneButton:SetText( "CONFIRM" )
	self.DoneButton:SetTextColor( Color( 255, 255, 255) )
	self.DoneButton:SetFont("ixSmallFont")
	self.DoneButton.DoClick = function()
		surface.PlaySound( "ui/buttonclick.wav")
	end
	self.DoneButton.Paint = function(s,w,h)
		surface.SetDrawColor( 24, 42, 60,240 )
	    surface.DrawRect(0,0,w,h)
	    surface.SetDrawColor(60,60,60,DoneButtonAlpha)
	    surface.DrawOutlinedRect(0,0,w,h)
	end
	self.DoneButton.OnCursorEntered = function()
	DoneButtonAlpha = 240
	surface.PlaySound( "ui/buttonrollover.wav")
	end
	self.DoneButton.OnCursorExited = function()
	DoneButtonAlpha = 0
	end


	self.RType = vgui.Create( "DComboBox", self )
	self.RType:Dock(FILL)
	self.RType:SetFont("ixSmallFont")
	self.RType:SetValue( "Choose Weapon" )


end

function PANEL:Populate(PlyWep)


	for k, v in pairs(PlyWep or {}) do
		self.RType:AddChoice(v,k)
	end

	self.DoneButton.DoClick = function()

		if (self.RType:GetSelectedID() == nil) then LocalPlayer():Notify("Please select a weapon") return end

		surface.PlaySound( "ui/buttonclick.wav")

		local selText, selData = self.RType:GetSelected()

		net.Start("ixPoliceSys_WepUpdate")
		net.WriteUInt(selData, 12)
		net.WriteString(self.ClassType)
		net.SendToServer()

		self:Remove()

	end
	

	if (!bDontShow) then
		self.alpha = 0
		self:SetAlpha(0)
		self:MakePopup()

		self:CreateAnimation(animationTime, {
			index = 1,
			target = {alpha = 255},
			easing = "outQuint",

			Think = function(animation, panel)
				panel:SetAlpha(panel.alpha)
			end
		})
	end
end



vgui.Register("ixPoliceSys_ClaimWeapon", PANEL, "DFrame")
-- vgui.Create("ixPoliceSys_ClaimWeapon"):Populate()
