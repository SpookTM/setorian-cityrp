
local PLUGIN = PLUGIN
-- local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

local monitorTexture = Material("setorian_banking/monitor.png", "noclamp smooth" )

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(1000,800)
	self:Center()
	self:MakePopup()
	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self.Paint = function(s,w,h) 
		surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(40,10,w-80,h-200)

	    surface.SetDrawColor(52, 73, 94, 255)
	    surface.DrawRect(50,45,w-100,h-265)

        surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(45,45,w-90,20)

	    draw.SimpleText(os.date( "%H:%M"), "ix3D2DSmallFont", 52,40, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
	    draw.SimpleText("Bank OS", "ix3D2DSmallFont", w-52,40, Color( 240,240,240 ), TEXT_ALIGN_RIGHT,TEXT_ALIGN_RIGHT)


	end
	self.PaintOver = function(s,w,h)

		//Background

		

		surface.SetDrawColor( 255,255,255 )
	    surface.SetMaterial( monitorTexture )
		surface.DrawTexturedRect(0,0,w,h)

	    

	    -- surface.SetDrawColor(52, 73, 94, 255)
	    -- surface.DrawRect(5,5,w-10,h-10)

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(5,5,w-10,5+48)

	    -- draw.SimpleText("", "ix3D2DMediumFont", 12,5, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)


	    //property type bg

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(0,65,w,45)

	    -- draw.DrawText("Choose property's type", "ixMediumLightFont", 10,75, Color( 240,240,240 ), TEXT_ALIGN_LEFT)

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(0,5+48,w,5)


	end


	local InsideMonitor = vgui.Create( "DPanel", self )
	InsideMonitor:Dock(FILL)
	InsideMonitor:DockMargin(40,10,38,208)
	InsideMonitor:DockPadding(5,20,5,5)
	InsideMonitor.Paint = function(s,w,h)
		-- surface.SetDrawColor(44, 62, 80, 255)
	 --    surface.DrawRect(0,0,w,h)

		-- surface.SetDrawColor(52, 73, 94, 255)
	 --    surface.DrawRect(5,5,w-10,h-10)

	 --    surface.SetDrawColor(44, 62, 80, 255)
	 --    surface.DrawRect(5,5,w-10,20)

	 --    draw.SimpleText(os.date( "%H:%M"), "ix3D2DSmallFont", 8,0, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
	 --    draw.SimpleText("Bank OS", "ix3D2DSmallFont", w-8,0, Color( 240,240,240 ), TEXT_ALIGN_RIGHT,TEXT_ALIGN_RIGHT)

	end

	self.MainPanel = InsideMonitor
	
	surface.PlaySound("buttons/lightswitch2.wav")
	self:LoginAnimation()
	-- self:RenderMenu()

end

function PANEL:LoginAnimation()

	local WelcomeMsg = vgui.Create( "DLabel", self.MainPanel )
	WelcomeMsg:Dock(TOP)
	WelcomeMsg:DockMargin(0,130,0,0)
	WelcomeMsg:SetFont("ix3D2DMediumFont")
	WelcomeMsg:SetContentAlignment(5)
	WelcomeMsg:SetText( "Loading")
	WelcomeMsg:SetAlpha(0)
	WelcomeMsg:SetAutoStretchVertical(true)

	WelcomeMsg:AlphaTo(255, 1)

	local speed = 0.5
	local barStatus = 0
	
	local LoadingPanel = vgui.Create( "DPanel", self.MainPanel )
	LoadingPanel:Dock(TOP)
	LoadingPanel:DockMargin(200,30,200,0)
	LoadingPanel:SetAlpha(0)
	LoadingPanel.Loading = false
	LoadingPanel.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20)
	    surface.DrawRect(0,0,w,h)

	    if (s.Loading) then
		    barStatus = math.Clamp(barStatus + speed * FrameTime(), 0, 1)
		end

	    surface.SetDrawColor(20,200,20)
	    surface.DrawRect(2,2,(w-4) * barStatus,h-4)

	    if (barStatus == 1) and (s.Loading) then
			self:TransitionAnim()
			s.Loading = false
		end

	end

	LoadingPanel:AlphaTo(255, 1,0.5, function() 
		LoadingPanel.Loading = true
	end)

	self.LoadingPanel = LoadingPanel


	local CloseButton = vgui.Create( "ixMenuButton", self.MainPanel )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(15,10,15,15)
	CloseButton:SetFont("ix3D2DMediumFont")
	CloseButton:SetContentAlignment(5)
	CloseButton:SetTall(70)
	CloseButton:SetText( "Cancel" )
	CloseButton.DoClick = function()

		self:AlphaTo(0, 0.3, 0, function() self:Close() end)
	end

end

function PANEL:TransitionAnim()

	self.MainPanel:AlphaTo(0, 0.2,0, function() 
		-- self.MainPanel:Clear()
		self:RenderMenu()

		self.MainPanel:AlphaTo(255, 0.2)
	end)

end

function PANEL:RenderMenu()

	self.MainPanel:Clear()

	-- self.MainPanel:AlphaTo(0, 0.2,0, function() 
	-- 	self.MainPanel:Clear()

	-- 	self.MainPanel:AlphaTo(255, 0.2)
	-- end)

	surface.PlaySound("buttons/lightswitch2.wav")

	local ContextPanel = vgui.Create( "DPanel", self.MainPanel )
	ContextPanel:Dock(FILL)
	ContextPanel:DockMargin(15,15,15,15)
	ContextPanel:SetAlpha(0)
	ContextPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(220,20,20)
	 --    surface.DrawRect(0,0,w,h)

	end

	ContextPanel:AlphaTo(255, 1)


	local WelcomeMsg = vgui.Create( "DLabel", ContextPanel )
	WelcomeMsg:Dock(TOP)
	WelcomeMsg:DockMargin(0,10,0,30)
	WelcomeMsg:SetFont("ix3D2DMediumFont")
	WelcomeMsg:SetContentAlignment(5)
	WelcomeMsg:SetText( "Welcome "..LocalPlayer():GetCharacter():GetName())
	WelcomeMsg:SetAutoStretchVertical(true)

	local MenuButtons = {
		["Create Interst Account"] = function() 
			self:RenderInterestAccount()
		end,
		["Give out loan"] = function() 
			self:RenderGiveLoan()
		end,
		["Give a safe deposit box"] = function() 
			self:RenderGiveSafetyBox() 
		end,
	}

	for k, v in pairs(MenuButtons) do
		local MenuButton = vgui.Create( "ixMenuButton", ContextPanel )
		MenuButton:Dock(TOP)
		MenuButton:DockMargin(0,10,0,0)
		MenuButton:SetFont("ix3D2DMediumFont")
		MenuButton:SetContentAlignment(5)
		MenuButton:SetTall(70)
		MenuButton:SetText( k )
		-- MenuButton:SetAutoStretchVertical(true)
		MenuButton.DoClick = function()
			v()
		end
	end
	
	local CloseButton = vgui.Create( "ixMenuButton", ContextPanel )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(0,10,0,0)
	CloseButton:SetFont("ix3D2DMediumFont")
	CloseButton:SetContentAlignment(5)
	CloseButton:SetTall(70)
	CloseButton:SetText( "Log out" )
	CloseButton.DoClick = function()

		self:AlphaTo(0, 0.3, 0, function() self:Close() end)
	end

end

function PANEL:RenderInterestAccount()

	self.MainPanel:Clear()

	surface.PlaySound("buttons/lightswitch2.wav")

	local ContextPanel = vgui.Create( "DPanel", self.MainPanel )
	ContextPanel:Dock(FILL)
	ContextPanel:DockMargin(15,15,15,15)
	ContextPanel:SetAlpha(255)
	ContextPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(220,20,20)
	 --    surface.DrawRect(0,0,w,h)

	end

	local WelcomeMsg = vgui.Create( "DLabel", ContextPanel )
	WelcomeMsg:Dock(TOP)
	WelcomeMsg:DockMargin(0,10,0,30)
	WelcomeMsg:SetFont("ix3D2DMediumFont")
	WelcomeMsg:SetContentAlignment(5)
	WelcomeMsg:SetText( "Creating Interest Account")
	WelcomeMsg:SetAutoStretchVertical(true)

	local BackButton = vgui.Create( "ixMenuButton", ContextPanel )
	BackButton:Dock(BOTTOM)
	BackButton:DockMargin(0,10,0,0)
	BackButton:SetFont("ix3D2DMediumFont")
	BackButton:SetContentAlignment(5)
	BackButton:SetTall(70)
	BackButton:SetText( "Back" )
	BackButton:SetZPos(1)
	BackButton.DoClick = function()
		self:RenderMenu()
		self.ChoosePlyButton = nil
		self.ChoosenBankID = nil
		self.ChoosenCharName = nil
	end

	local ChoosePlyButton = vgui.Create( "ixMenuButton", ContextPanel )
	ChoosePlyButton:Dock(TOP)
	ChoosePlyButton:DockMargin(0,10,0,0)
	ChoosePlyButton:SetFont("ix3D2DMediumFont")
	ChoosePlyButton:SetContentAlignment(5)
	ChoosePlyButton:SetTall(70)
	ChoosePlyButton:SetText( "Choose Player" )
	self.ChoosePlyButton = ChoosePlyButton
	self.ChoosenCharID = ""
	self.ChoosenCharName = ""
	ChoosePlyButton.DoClick = function()
		local charactersList = vgui.Create("ixMonitorCharacters_List")
		charactersList:FillPanel()
		charactersList:SetParent(self)
	end

	local SetPinText = vgui.Create( "DLabel", ContextPanel )
	SetPinText:Dock(TOP)
	SetPinText:DockMargin(0,10,0,0)
	SetPinText:SetFont("ix3D2DMediumFont")
	SetPinText:SetContentAlignment(5)
	SetPinText:SetText( "Set PIN")
	SetPinText:SetAutoStretchVertical(true)

	local PinEntry = vgui.Create( "DTextEntry", ContextPanel )
	PinEntry:Dock( TOP )
	PinEntry:DockMargin( 350, 10, 350, 0 )
	PinEntry:SetPlaceholderText( "0000" )
	PinEntry:SetUpdateOnType(true)
	PinEntry.AllowInput = function(s, text)

		local Textlength = string.len(s:GetValue())

		local numbers = "123456789"

		if (Textlength == 4) then
			return true
		elseif ( !string.find( numbers, text, 1, true ) ) then
			return true
		else
			return false
		end

	end

	local CreateButton = vgui.Create( "ixMenuButton", ContextPanel )
	CreateButton:Dock(BOTTOM)
	CreateButton:DockMargin(0,10,0,0)
	CreateButton:SetFont("ix3D2DMediumFont")
	CreateButton:SetContentAlignment(5)
	CreateButton:SetTall(70)
	CreateButton:SetText( "Create" )
	CreateButton:SetZPos(2)
	CreateButton.DoClick = function()
		
		if (PinEntry:GetValue() == "") then
			LocalPlayer():Notify("Pin cannot be empty!")
			return
		end

		if (string.len(PinEntry:GetValue()) != 4) then
			LocalPlayer():Notify("Pin is too short!")
			return
		end

		netstream.Start("JBanking_CreateInterestAccount", PinEntry:GetValue(), self.ChoosenCharID, self.ChoosenCharName)
		self:RenderMenu()

	end

end

function PANEL:RenderGiveSafetyBox()
	
	self.MainPanel:Clear()

	surface.PlaySound("buttons/lightswitch2.wav")

	local ContextPanel = vgui.Create( "DPanel", self.MainPanel )
	ContextPanel:Dock(FILL)
	ContextPanel:DockMargin(15,15,15,15)
	ContextPanel:SetAlpha(255)
	ContextPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(220,20,20)
	 --    surface.DrawRect(0,0,w,h)

	end

	local WelcomeMsg = vgui.Create( "DLabel", ContextPanel )
	WelcomeMsg:Dock(TOP)
	WelcomeMsg:DockMargin(0,10,0,10)
	WelcomeMsg:SetFont("ix3D2DMediumFont")
	WelcomeMsg:SetContentAlignment(5)
	WelcomeMsg:SetText( "Give a Safety Deposit Box")
	WelcomeMsg:SetAutoStretchVertical(true)

	local BackButton = vgui.Create( "ixMenuButton", ContextPanel )
	BackButton:Dock(BOTTOM)
	BackButton:DockMargin(0,0,0,0)
	BackButton:SetFont("ix3D2DMediumFont")
	BackButton:SetContentAlignment(5)
	BackButton:SetTall(70)
	BackButton:SetText( "Back" )
	BackButton:SetZPos(1)
	BackButton.DoClick = function()
		self:RenderMenu()
		self.ChoosePlyButton = nil
		self.ChoosenBankID = nil
		self.ChoosenBoxType = nil
	end


	local ChoosePlyButton = vgui.Create( "ixMenuButton", ContextPanel )
	ChoosePlyButton:Dock(TOP)
	ChoosePlyButton:DockMargin(0,10,0,0)
	ChoosePlyButton:SetFont("ix3D2DMediumFont")
	ChoosePlyButton:SetContentAlignment(5)
	ChoosePlyButton:SetTall(70)
	ChoosePlyButton:SetText( "Choose bank account" )
	self.ChoosePlyButton = ChoosePlyButton
	self.ChoosenBankID = ""
	self.ChoosenBoxType = 0
	ChoosePlyButton.DoClick = function()

		local accountslist = vgui.Create("ixMonitorAccounts_List")
		accountslist:SetParent(self)

		PLUGIN:GetAllAccountsData(function(data)

			for k, v in pairs(data) do
				-- if (tonumber(v.account_id) == self.BankNumber) then continue end
				
				accountslist:AddAccountToList(v.account_id, v.owner_name)

			end

			accountslist:ScrollRefresh()

		end)

	end


	local BoxType = vgui.Create( "DComboBox", ContextPanel )
	BoxType:Dock(TOP)
	BoxType:DockMargin(210,5,210,0)
	BoxType:SetTall(100)
	BoxType:SetValue( "Select Box Type" )
	BoxType:SetFont("ix3D2DMediumFont")
	BoxType:AddChoice( "3x3 - $150" ) // index 1
	BoxType:AddChoice( "4x4 - $350" ) // index 2
	BoxType.OnSelect = function( s, index, value )
		self.ChoosenBoxType = index
	end

	local GiveButton = vgui.Create( "ixMenuButton", ContextPanel )
	GiveButton:Dock(BOTTOM)
	GiveButton:DockMargin(0,10,0,0)
	GiveButton:SetFont("ix3D2DMediumFont")
	GiveButton:SetContentAlignment(5)
	GiveButton:SetTall(70)
	GiveButton:SetText( "Give a deposit box" )
	GiveButton:SetZPos(2)
	GiveButton.DoClick = function()

		if (self.ChoosenBankID == "") then
			LocalPlayer():Notify("Please choose a account")
			return
		end

		if (self.ChoosenBoxType == 0) then
			LocalPlayer():Notify("Please choose box type")
			return
		end

		netstream.Start("JBanking_GiveSafeBox", tonumber(self.ChoosenBankID), self.ChoosenBoxType)
		self:RenderMenu()

	end

end

function PANEL:RenderGiveLoan()

	self.MainPanel:Clear()

	surface.PlaySound("buttons/lightswitch2.wav")

	local ContextPanel = vgui.Create( "DPanel", self.MainPanel )
	ContextPanel:Dock(FILL)
	ContextPanel:DockMargin(15,15,15,15)
	ContextPanel:SetAlpha(255)
	ContextPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(220,20,20)
	 --    surface.DrawRect(0,0,w,h)

	end

	local WelcomeMsg = vgui.Create( "DLabel", ContextPanel )
	WelcomeMsg:Dock(TOP)
	WelcomeMsg:DockMargin(0,10,0,10)
	WelcomeMsg:SetFont("ix3D2DMediumFont")
	WelcomeMsg:SetContentAlignment(5)
	WelcomeMsg:SetText( "Give out a loan")
	WelcomeMsg:SetAutoStretchVertical(true)

	local BackButton = vgui.Create( "ixMenuButton", ContextPanel )
	BackButton:Dock(BOTTOM)
	BackButton:DockMargin(0,0,0,0)
	BackButton:SetFont("ix3D2DMediumFont")
	BackButton:SetContentAlignment(5)
	BackButton:SetTall(70)
	BackButton:SetText( "Back" )
	BackButton:SetZPos(1)
	BackButton.DoClick = function()
		self:RenderMenu()
		self.ChoosePlyButton = nil
		self.ChoosenBankID = nil
	end


	local ChoosePlyButton = vgui.Create( "ixMenuButton", ContextPanel )
	ChoosePlyButton:Dock(TOP)
	ChoosePlyButton:DockMargin(0,10,0,0)
	ChoosePlyButton:SetFont("ix3D2DMediumFont")
	ChoosePlyButton:SetContentAlignment(5)
	ChoosePlyButton:SetTall(70)
	ChoosePlyButton:SetText( "Choose bank account" )
	self.ChoosePlyButton = ChoosePlyButton
	self.ChoosenBankID = ""
	ChoosePlyButton.DoClick = function()

		local accountslist = vgui.Create("ixMonitorAccounts_List")
		accountslist:SetParent(self)

		PLUGIN:GetAllAccountsData(function(data)

			for k, v in pairs(data) do
				-- if (tonumber(v.account_id) == self.BankNumber) then continue end
				
				accountslist:AddAccountToList(v.account_id, (tobool(v.is_groupaccount) and "Group Account") or v.owner_name)

			end

			accountslist:ScrollRefresh()

		end)

	end



	local SetLoanText = vgui.Create( "ixLabel", ContextPanel )
	SetLoanText:Dock(TOP)
	SetLoanText:DockMargin(0,0,0,0)
	SetLoanText:SetFont("ix3D2DMediumFont")
	SetLoanText:SetContentAlignment(5)
	SetLoanText:SetText( "Set Amount")
	-- SetLoanText:SetPadding(2)
	SetLoanText:SetScaleWidth(true)
	SetLoanText:SizeToContents()
	-- SetLoanText:SetAutoStretchVertical(true)

	local Slider = vgui.Create( "DNumSlider", ContextPanel )
	Slider:Dock(TOP)
	Slider:DockMargin(200,10,310,0)
	Slider:SetMin( 500 )
	Slider:SetMax( 20000 )
	Slider:SetDecimals( 0 )
	Slider:SetValue(500)

	local PayBackText = vgui.Create( "ixLabel", ContextPanel )
	PayBackText:Dock(TOP)
	PayBackText:DockMargin(0,0,0,0)
	PayBackText:SetFont("ix3D2DMediumFont")
	PayBackText:SetContentAlignment(5)
	PayBackText:SetText( "Days to pay back")
	-- PayBackText:SetPadding(2)
	PayBackText:SetScaleWidth(true)
	PayBackText:SizeToContents()
	-- PayBackText:SetAutoStretchVertical(true)

	local Slider2 = vgui.Create( "DNumSlider", ContextPanel )
	Slider2:Dock(TOP)
	Slider2:DockMargin(200,10,310,0)
	Slider2:SetMin( 1 )
	Slider2:SetMax( 30 )
	Slider2:SetDecimals( 0 )
	Slider2:SetValue(1)

	local GiveButton = vgui.Create( "ixMenuButton", ContextPanel )
	GiveButton:Dock(BOTTOM)
	GiveButton:DockMargin(0,10,0,0)
	GiveButton:SetFont("ix3D2DMediumFont")
	GiveButton:SetContentAlignment(5)
	GiveButton:SetTall(70)
	GiveButton:SetText( "Give out a loan" )
	GiveButton:SetZPos(2)
	GiveButton.DoClick = function()

		if (self.ChoosenBankID == "") then
			LocalPlayer():Notify("Please choose a account")
			return
		end

		netstream.Start("JBanking_GiveALoan", tonumber(self.ChoosenBankID), math.Round(Slider:GetValue()), math.Round(Slider2:GetValue()))
		self:RenderMenu()

	end

end

vgui.Register("ixBanking_MonitorMenu", PANEL, "DFrame")



