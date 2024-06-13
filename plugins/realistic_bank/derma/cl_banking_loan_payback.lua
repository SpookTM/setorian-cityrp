
local PANEL = {}

function PANEL:Init()
	self:SetTitle("Repay a loan")
	self:SetSize(330, 120)
	self:Center()
	self:MakePopup()


	-- local DermaNumSlider = vgui.Create( "DNumSlider", self )
	-- DermaNumSlider:Dock(TOP)
	-- DermaNumSlider:DockMargin(10,15,0,0)
	-- DermaNumSlider:SetText( "Repayment amount" )
	-- DermaNumSlider:SetMin( 500 )
	-- DermaNumSlider:SetMax( 20000 )
	-- DermaNumSlider:SetDecimals( 0 )

	self.Accounts = {}
	self.AccountChoosen = ""

	local AccountsBox = vgui.Create( "DComboBox", self )
	AccountsBox:Dock(TOP)
	AccountsBox:DockMargin(5,0,5,0)
	AccountsBox:SetValue( "Select a account" )
	AccountsBox.OnSelect = function( s, index, value, data )
		self.AccountChoosen = data
		print(self.AccountChoosen)
		print(tonumber(self.AccountChoosen))
	end

	self.AccountsBox = AccountsBox

	local MainDock = vgui.Create( "DPanel", self )
	MainDock:Dock(FILL)
	MainDock:DockMargin(10,10,10,0)
	MainDock.Paint = function(s,w,h)

	 	draw.SimpleText("$", "DermaDefault", w * 0.42, h/2 - 1,  Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	local Tip = vgui.Create( "DLabel", MainDock )
	Tip:Dock(LEFT)
	Tip:DockMargin(5, 0, 5, 0)
	Tip:SetWide(self:GetWide()/2)
	-- Tip:SetZPos(2)
	Tip:SetContentAlignment(4)
	Tip:SetText( "Repayment amount" )

	local TextEntry = vgui.Create( "DTextEntry", MainDock )
	TextEntry:Dock( RIGHT )
	-- TextEntry
	TextEntry:SetWide(self:GetWide()/2)
	TextEntry:SetNumeric(true)
	
	self.money = TextEntry	

	local AcceptButton = vgui.Create( "DButton", self )
	AcceptButton:SetText( "Pay" )
	AcceptButton:Dock( BOTTOM )
	AcceptButton:DockMargin( 10, 10, 10, 5 )
	AcceptButton.DoClick = function(s)
		netstream.Start("ixJRBanking_PayLoan", tonumber(self.AccountChoosen), tonumber(self.money:GetValue()))
		self.MainPnl:DataUpdate()
		self:Close()

	end

end

function PANEL:InputAccounts()

	for k, v in pairs(self.Accounts) do
		self.AccountsBox:AddChoice( k .. " - " .. ix.currency.Get(v), k )
	end

end

function PANEL:Think()
	if (!self.AccountsBox:IsMenuOpen()) then
		self:MoveToFront()
	end
end


vgui.Register("ixBanking_Loan_PayBack", PANEL, "DFrame")
-- vgui.Create("ixBanking_Loan_PayBack")