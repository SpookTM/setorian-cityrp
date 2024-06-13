local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")

local PANEL = {}

function PANEL:Init()

	self:SetSize( 500, 300 )
	self:Center()
	self:MakePopup()
	self:SetTitle("")
	self:DockPadding(10,20,10,0)
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self.Paint = function(s,w,h)
		surface.SetDrawColor( 52, 73, 94 )
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor( 44, 62, 80 )
	    surface.DrawRect(0,0,w,24)

	    surface.DrawOutlinedRect(0,0,w,h, 2)

	end

	self.selectedService = ""

	self:aphone_RemoveCursor()

	local OperatorTip = vgui.Create( "DLabel", self )
	OperatorTip:Dock(TOP)
	OperatorTip:DockMargin(5,5,0,5)
	OperatorTip:SetFont("Trebuchet24")
	OperatorTip:SetText( "Operator: Okay, what is going on?" )
	OperatorTip:SetAutoStretchVertical(true)
	-- Criminalrecords:SetContentAlignment(5)

	self.ChooseService = vgui.Create( "DComboBox", self )
	self.ChooseService:Dock(TOP)
	self.ChooseService:SetTall(30)
	self.ChooseService:SetFont("ixSmallBoldFont")
	self.ChooseService:SetValue( "Please select a serivce" )
	-- self.ChooseService:AddChoice( "Police" )
	-- self.ChooseService:AddChoice( "EMS" )

	for k, v in pairs(PLUGIN.Services) do
		self.ChooseService:AddChoice(k)
	end

	self.ChooseService.Paint = function(s,w,h)
		surface.SetDrawColor( 44, 62, 80 )
	    surface.DrawRect(0,0,w,h)
	end
	self.ChooseService.OnSelect = function(s, ind, text, data)

		self.selectedService = text
		self:RenderRestInfo()

	end

	local ContextsPanel = vgui.Create( "Panel", self )
	ContextsPanel:Dock( FILL )
	ContextsPanel:DockMargin(0,5,0,5)

	self.ContextsPanel = ContextsPanel

	local CloseButtonAlpha = 0
	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:Dock(BOTTOM)
	self.CloseButton:DockMargin(0,0,0,10)
	self.CloseButton:SetTall(30)
	self.CloseButton:SetText( "Cancel" )
	self.CloseButton:SetTextColor( Color( 255, 255, 255) )
	self.CloseButton:SetFont("ixSmallBoldFont")
	self.CloseButton:SetZPos(1)
	self.CloseButton.Paint = function(s,w,h)
		surface.SetDrawColor( 24, 42, 60,240 )
	    surface.DrawRect(0,0,w,h)
	    surface.SetDrawColor(120,120,120,CloseButtonAlpha)
	    surface.DrawOutlinedRect(0,0,w,h)
	end
	self.CloseButton.OnCursorEntered = function()
	CloseButtonAlpha = 240
	surface.PlaySound( "ui/buttonrollover.wav")
	end
	self.CloseButton.OnCursorExited = function()
	CloseButtonAlpha = 0
	end
	self.CloseButton.DoClick = function()
		surface.PlaySound( "ui/buttonclick.wav")
		self:Close()

	end

end

function PANEL:RenderRestInfo()

	self.ContextsPanel:Clear()

	self.wReason = ""

	local ReasonPH = vgui.Create( "DTextEntry", self.ContextsPanel )
	ReasonPH:Dock( FILL )
	-- ReasonPH:DockMargin(0,5,0,5)
	ReasonPH:SetMultiline(true)
	ReasonPH:SetText("")
	ReasonPH:SetFont("ixSmallFont")
	ReasonPH.Paint = function(s,w,h)

	    surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0, 0, w,h)
	    s:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	    
	end
	ReasonPH.OnLoseFocus = function(s)
		if (s:GetValue() != "") then
			self.wReason = s:GetValue()
		end
	end
	ReasonPH.OnEnter = function(s)
		if (s:GetValue() != "") then
			self.wReason = s:GetValue()
		end
	end

	local CloseButtonAlpha = 0
	self.SendButton = vgui.Create( "DButton", self.ContextsPanel )
	self.SendButton:Dock(BOTTOM)
	self.SendButton:DockMargin(0,5,0,0)
	self.SendButton:SetTall(30)
	self.SendButton:SetText( "Send" )
	self.SendButton:SetTextColor( Color( 255, 255, 255) )
	self.SendButton:SetFont("ixSmallBoldFont")
	self.SendButton:SetZPos(1)
	self.SendButton.Paint = function(s,w,h)
		surface.SetDrawColor( 24, 42, 60,240 )
	    surface.DrawRect(0,0,w,h)
	    surface.SetDrawColor(120,120,120,CloseButtonAlpha)
	    surface.DrawOutlinedRect(0,0,w,h)
	end
	self.SendButton.OnCursorEntered = function()
	CloseButtonAlpha = 240
	surface.PlaySound( "ui/buttonrollover.wav")
	end
	self.SendButton.OnCursorExited = function()
	CloseButtonAlpha = 0
	end
	self.SendButton.DoClick = function()
		surface.PlaySound( "ui/buttonclick.wav")
		self:Close()

		if (self.wReason == "") then
			LocalPlayer():Notify("Please type a valid reason.")
			return
		end

		net.Start("ixAPhone_SendCall")
			net.WriteString(self.selectedService)
			net.WriteString(self.wReason)
		net.SendToServer()

	end


end



vgui.Register("ixPoliceSys_PhoneApp", PANEL, "DFrame")
-- vgui.Create("ixPoliceSys_PhoneApp")
