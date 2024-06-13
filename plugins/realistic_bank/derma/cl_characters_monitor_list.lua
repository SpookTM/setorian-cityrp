
local PANEL = {}

function PANEL:Init()
	self:SetTitle("Accounts")
	self:SetSize(330, 240)
	self:Center()
	self:MakePopup()

	self.ScrollPanel = vgui.Create( "DScrollPanel", self )
	self.ScrollPanel:Dock( FILL )

	-- for k, v in pairs(self.v or {}) do
	-- 	self.Account = self.ScrollPanel:Add( "DButton" )
	-- 	self.Account:SetText( k )
	-- 	self.Account:Dock( TOP )
	-- 	self.Account:DockMargin( 0, 0, 0, 5 )
	-- 	self.Account.DoClick = function(s)
	-- 		-- self:RemoveFrequency(k)
	-- 	end
	-- end

	self.Tip = vgui.Create( "DLabel", self )
	self.Tip:Dock(BOTTOM)
	self.Tip:DockMargin(5, 10, 5, 0)
	self.Tip:SetZPos(2)
	self.Tip:SetContentAlignment(5)
	self.Tip:SetText( "Select an account from the list above" )

	-- self.Accounts = {}

end

function PANEL:Think()
	self:MoveToFront()
end

function PANEL:FillPanel()
	-- self.ScrollPanel:Clear()
	for client, char in ix.util.GetCharacters() do
		self.Account = self.ScrollPanel:Add( "DButton" )
		self.Account:SetText( char:GetName() )
		self.Account:Dock( TOP )
		self.Account:DockMargin( 0, 0, 0, 5 )
		self.Account.DoClick = function(s)
			-- self:RemoveFrequency(k)

			self:GetParent().ChoosenCharID = char:GetID()
			self:GetParent().ChoosenCharName = char:GetName()
			self:GetParent().ChoosePlyButton:SetText("Selected: "..char:GetName())
			LocalPlayer():Notify("You selected " .. char:GetName())
			self:Close()

		end
	end
end

-- function PANEL:AddAccountToList(bankid, ownername)
-- 	self.Accounts[bankid] = ownername
-- 	-- self:ScrollRefresh()
-- end

-- function PANEL:RemoveAccountToList(bankid)
-- 	self.Accounts[bankid] = nil
-- 	self:ScrollRefresh()
-- end

vgui.Register("ixMonitorCharacters_List", PANEL, "DFrame")
