
local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}


function PANEL:Init()


	self:SetSize(400,100)

	self:Center()
	self:MakePopup()



	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self:DockPadding(10,10,10,10)

	self.Paint = function(s,w,h)

		surface.SetDrawColor(47, 53, 66, 250)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(44, 62, 80, 130)
	    surface.DrawRect(5,5,w-10,h-10)

	end

	local Header = vgui.Create( "DLabel", self )
	Header:Dock(TOP)
	Header:DockMargin(0,0,0,5)
	Header:SetFont("ixMediumFont")
	Header:SetText( "Select Payment Method" )
	Header:SizeToContents()
	Header:SetContentAlignment(5)

	local CashButton = vgui.Create( "DButton", self )
	CashButton:Dock(LEFT)
	CashButton:SetWide(self:GetWide() / 3 - 10)
	CashButton:SetFont("Trebuchet24")
	CashButton:SetText("CASH")
	CashButton.Paint = function(s,w,h)

		if (s:IsHovered()) then
			surface.SetDrawColor(149, 165, 166, 200)
		else
	    	surface.SetDrawColor(127, 140, 141, 230)
	    end
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(50,50,50)
	    surface.DrawOutlinedRect(0,0,w,h,3)

	end
	CashButton.OnCursorEntered = function(s)
		surface.PlaySound("helix/ui/rollover.wav")
	end
	CashButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		self:GetParent():ProcessCart()
		self:Close()
		
	end

	local DebitButton = vgui.Create( "DButton", self )
	DebitButton:Dock(LEFT)
	DebitButton:DockMargin(5,0,5,0)
	DebitButton:SetWide(self:GetWide() / 3 - 10)
	DebitButton:SetFont("Trebuchet24")
	DebitButton:SetText("DEBIT")
	DebitButton.Paint = function(s,w,h)

		if (s:IsHovered()) then
			surface.SetDrawColor(149, 165, 166, 200)
		else
	    	surface.SetDrawColor(127, 140, 141, 230)
	    end
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(50,50,50)
	    surface.DrawOutlinedRect(0,0,w,h,3)

	end
	DebitButton.OnCursorEntered = function(s)
		surface.PlaySound("helix/ui/rollover.wav")
	end
	DebitButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		self:GetParent():ProcessDebit()
		self:Close()

	end

	local CancelButton = vgui.Create( "DButton", self )
	CancelButton:Dock(LEFT)
	CancelButton:SetWide(self:GetWide() / 3 - 10)
	CancelButton:SetFont("Trebuchet24")
	CancelButton:SetText("CANCEL")
	CancelButton.Paint = function(s,w,h)

		if (s:IsHovered()) then
			surface.SetDrawColor(231, 26, 20, 200)
		else
	    	surface.SetDrawColor(231, 46, 40, 230)
	    end
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(50,50,50)
	    surface.DrawOutlinedRect(0,0,w,h,3)

	end
	CancelButton.OnCursorEntered = function(s)
		surface.PlaySound("helix/ui/rollover.wav")
	end
	CancelButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")
		self:Close()
	end

end

vgui.Register("ixVendor_ChooseMode", PANEL, "DFrame")
-- vgui.Create("ixVendor_ChooseMode")