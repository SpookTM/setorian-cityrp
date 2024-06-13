local PLUGIN = PLUGIN
local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

local function InventoryToolTip(tooltip, ItemName, ItemDesc)
	local name = tooltip:AddRow("name")
	name:SetImportant()
	name:SetText(ItemName)
	name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
	name:SizeToContents()

	local description = tooltip:AddRow("description")
	description:SetText(ItemDesc or "")
	description:SizeToContents()

end

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(600,525)
	self:Center()
	self:MakePopup()
	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetAlpha(0)
	self:AlphaTo(255, 0.2)

	self:SetTitle("")
	self:ShowCloseButton(true)
	self:SetDraggable(false)

	self.coowners = {}

	self.Paint = function(s,w,h)

		//Background
	    -- surface.SetDrawColor( 44, 62, 80, 250 )
	    -- surface.SetDrawColor(24, 37, 52, 100)
	    surface.SetDrawColor(47, 54, 64)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(53, 59, 72)
	    surface.DrawRect(5,5,w-10,h-10)

	    surface.SetDrawColor(47, 54, 64)
	    surface.DrawRect(0,0,w,25)


	end

	local ButtonsPnl = vgui.Create( "Panel", self )
	ButtonsPnl:Dock(TOP)
	ButtonsPnl:SetTall(self:GetTall()*0.11)
	ButtonsPnl:DockPadding(10,5,10,5)
	ButtonsPnl.buttons = {}
	ButtonsPnl.Paint = function(s,w,h)
		surface.SetDrawColor(47, 54, 64)
	    surface.DrawRect(0,0,w,h)
	end

	local buttonColor = (ix.config.Get("color") or Color(140, 140, 140, 255))

	local productsBut = ButtonsPnl:Add("ixMenuSelectionButton")
	productsBut:SetText("PRODUCTS")
	productsBut:SizeToContents()
	-- buybuttonTab:SetWide(self:GetWide()/3)
	productsBut:SetContentAlignment(5)
	productsBut:Dock(LEFT)
	-- productsBut:DockMargin(45,0,5,10)
	-- buybuttonTab:SetPos(25, 5 )
	-- button:DockMargin(ScreenScale(30 / 3), ScreenScale(15 / 3), 0, ScreenScale(15 / 3))
	productsBut:SetButtonList(ButtonsPnl.buttons)
	productsBut:SetBackgroundColor(buttonColor)
	productsBut:SetSelected(true)
	productsBut.OnSelected = function()
		self:PopulateProducts()
	end
	self.productsBut = productsBut

	local manageBut = ButtonsPnl:Add("ixMenuSelectionButton")
	manageBut:SetText("MANAGEMENT")
	manageBut:SizeToContents()
	-- buybuttonTab:SetWide(self:GetWide()/3)
	manageBut:SetContentAlignment(5)
	manageBut:Dock(RIGHT)
	-- productsBut:DockMargin(45,0,5,10)
	-- buybuttonTab:SetPos(25, 5 )
	-- button:DockMargin(ScreenScale(30 / 3), ScreenScale(15 / 3), 0, ScreenScale(15 / 3))
	manageBut:SetButtonList(ButtonsPnl.buttons)
	manageBut:SetBackgroundColor(buttonColor)
	manageBut.OnSelected = function()
		self:PopulateManage()
	end

	local ContextPanel = vgui.Create( "Panel", self )
	ContextPanel:Dock(FILL)
	ContextPanel:DockPadding(7,7,7,5)
	ContextPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(47, 54, 64)
	    -- surface.DrawOutlinedRect(0,0,w,h,2)
	end
	-- 	surface.SetDrawColor(147, 154, 64)
	--     surface.DrawRect(0,0,w,h)
	-- end

	self.MainPanel = ContextPanel

	-- self:PopulateProducts()

	ix.gui.BusinessCashUI = self

end

function PANEL:OnClose()
	ix.gui.BusinessCashUI = nil
end

local color_DarkGrey = Color(20,20,20)

function PANEL:PopulateProducts()

	self.MainPanel:Clear()

	local LockPnl

	local ScrollPanel = vgui.Create( "ThreeGrid", self.MainPanel )
	ScrollPanel:Dock( FILL )
	ScrollPanel:DockMargin(0,0,-5,0)
	-- ScrollPanel:InvalidateParent(true)
	ScrollPanel:SetWide(self:GetWide()-25)  // -25 -30

	ScrollPanel:SetColumns(4)
	ScrollPanel:SetHorizontalMargin(7)
	ScrollPanel:SetVerticalMargin(7)
	ScrollPanel.NextUpdate = CurTime()
	ScrollPanel.Think = function(s)
		
		if (s.NextUpdate < CurTime()) then
			LockPnl:SetVisible(self.cashEnt:GetIsLock())
		end

	end
	ScrollPanel.Paint = function(s,w,h)
	end

	self.ScrollPanel = ScrollPanel

	-- if (!self.items) or (table.IsEmpty(self.items)) then return end

	--[[ {
		IName = "Test Name",
		IDesc = "Test Desc",
		IModel = "models/props_c17/FurnitureCouch001a.mdl",
		IPrice = 250,
		IStock = 1,
	}--]] 

	for k, v in pairs(self.items or {}) do
	-- for i=1, 10 do

		if (v.IStock <= 0) then continue end
		
		local ItemPanel = self.ScrollPanel:Add( "DButton" )
		ItemPanel:Dock( TOP )
		ItemPanel:DockMargin( 0, 0, 0, 15 )
		ItemPanel:SetTall(120)
		ItemPanel:SetText("")
		ItemPanel:SetHelixTooltip(function(tooltip)
			InventoryToolTip(tooltip, v.IName, v.IDesc)
		end)
		ItemPanel.Paint = function(s,w,h)

		//Background
		    surface.SetDrawColor(40,40,40,150)
		    surface.DrawRect(0,0,w,h)

		    if (s:IsHovered()) then
		    	surface.SetDrawColor(39, 174, 96,150)
		    	surface.DrawOutlinedRect(0,0,w,h,3)
		    end

		end
		ItemPanel.DoClick = function(s)

			Derma_Query("Are you sure you want to purchase "..v.IName.."?", "Purchase", "Confirm", function()

				self.SelectedBuyItem = k

				local paymeth = vgui.Create("ixVendor_ChooseMode")
				paymeth:SetParent(self)

				-- net.Start("ixBCashR_Buy")
				-- 	net.WriteEntity(self.cashEnt)
				-- 	net.WriteString(k)
				-- net.SendToServer()
	           
	        end, "Cancel", function()
	        end)

		end

		self.ScrollPanel:AddCell(ItemPanel)

		local SpawnI = vgui.Create( "SpawnIcon" , ItemPanel ) -- SpawnIcon
		SpawnI:SetSize(100,100)
		SpawnI:SetPos(ItemPanel:GetWide()/2 - SpawnI:GetWide()/2,ItemPanel:GetTall()/2 - SpawnI:GetTall()/2)
		SpawnI:SetModel(v.IModel or "models/Items/item_item_crate.mdl" )
		SpawnI:SetTooltip(false)
		SpawnI:SetMouseInputEnabled(false)

		local ItemPriceBG = vgui.Create( "DPanel", ItemPanel )
		ItemPriceBG:Dock(BOTTOM)
		ItemPriceBG:DockMargin(5,0,5,5)
		ItemPriceBG:SetTall(22)
		ItemPriceBG:SetMouseInputEnabled(false)
		ItemPriceBG.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,200)
		    surface.DrawRect(0,0,w,h)
		end

		local ItemPrice = ItemPriceBG:Add( "ixLabel")
		-- local ItemPrice = ItemPriceBG:Add( "DButton")
		ItemPrice:Dock(FILL)
		ItemPrice:SetFont("ixItemDescFont")
		ItemPrice:SetText( "$"..v.IPrice )
		ItemPrice:SetContentAlignment(5)
		-- ItemPrice:SetPadding(5)
		ItemPrice:SetMouseInputEnabled(false)
		ItemPrice.NextUpdate = CurTime()
		ItemPrice.Think = function(s)

			if (s.NextUpdate < CurTime()) then

				local char = LocalPlayer():GetCharacter()

				if (tonumber(char:GetMoney()) >= tonumber(v.IPrice)) then
					s:SetTextColor(Color(46, 204, 113))
				else
					s:SetTextColor(Color(250,120,120))
				end

				s.NextUpdate = CurTime() + 1
			end

		end
		

		ItemPanel.DoRightClick = function(s)

			local char = LocalPlayer():GetCharacter()

			if (char:GetID() == self.cashEnt:GetOwnerCharID()) or (self.coowners[char:GetID()] and self.coowners[char:GetID()].CanSetPrice) or (cashEnt.coowners[char:GetID()] and self.coowners[char:GetID()].CanRemoveItem) then

				local Menu = DermaMenu()

				if (char:GetID() == self.cashEnt:GetOwnerCharID()) or (self.coowners[char:GetID()] and self.coowners[char:GetID()].CanSetPrice) then

					Menu:AddOption( "Set Price", function()

						ItemPriceBG:SetMouseInputEnabled(true)
						ItemPrice:SetMouseInputEnabled(true)

						local EditText = ItemPrice:Add( "DTextEntry")
						EditText:Dock(FILL)
						EditText:SetFont("ixItemDescFont")
						EditText:SetText( v.IPrice )
						EditText:SetNumeric(true)
						EditText.OnValueChange = function(s, value)

							if (tonumber(value) > 4294967295) then
								value = 4294967295
							end

							v.IPrice = value
							ItemPrice:SetText( "$"..v.IPrice )
							ItemPriceBG:SetMouseInputEnabled(false)
							ItemPrice:SetMouseInputEnabled(false)

							net.Start("ixBCashR_SetPrice")
								net.WriteEntity(self.cashEnt)
								net.WriteString(k)
								net.WriteUInt(v.IPrice, 32)
							net.SendToServer()

							s:Remove()
						end
						EditText.OnLoseFocus = function( s )
							ItemPriceBG:SetMouseInputEnabled(false)
							ItemPrice:SetMouseInputEnabled(false)
							s:Remove()
						end
						
					end):SetIcon( "icon16/money_dollar.png" )

				end

				if (char:GetID() == self.cashEnt:GetOwnerCharID()) or (self.coowners[char:GetID()] and self.coowners[char:GetID()].CanRemoveItem) then

					Menu:AddOption( "Remove one item from stock", function()

						net.Start("ixBCashR_ItemManage")
							net.WriteEntity(self.cashEnt)
							net.WriteBool(false)
							net.WriteString(k)
						net.SendToServer()


					end):SetIcon( "icon16/cross.png" )

				end

				Menu:Open()

			end

		end


		-- ItemPrice.DoClick = function(s)

		-- 	local EditText = ItemPrice:Add( "DTextEntry")
		-- 	EditText:Dock(FILL)
		-- 	EditText:SetFont("ixItemDescFont")
		-- 	EditText:SetText( v.IPrice )
		-- 	EditText:SetNumeric(true)
		-- 	EditText.OnValueChange = function(s, value)
		-- 		v.IPrice = value
		-- 		ItemPrice:SetText( "$"..v.IPrice )
		-- 		s:Remove()
		-- 	end
		-- 	EditText.OnLoseFocus = function( s )
		-- 		s:Remove()
		-- 	end

		-- end

		local ItemStock = ItemPanel:Add( "ixLabel")
		ItemStock:SetContentAlignment(6)
		ItemStock:SetFont("ixItemDescFont")
		ItemStock:SetText( "x"..v.IStock )
		ItemStock:SetMouseInputEnabled(false)
		ItemStock:SizeToContents()
		ItemStock:SetPos(ItemPanel:GetWide() - ItemStock:GetWide() - 3, 2)


	end

	-- if (self.cashEnt:GetIsLock()) then

		LockPnl = self.MainPanel:Add( "DPanel" )
		LockPnl:SetPos(2,2)
		LockPnl:SetSize(self:GetWide()*0.98,self:GetTall()*0.8)
		LockPnl:SetVisible(self.cashEnt:GetIsLock())
		-- LockPnl.NextUpdate = CurTime()
		-- LockPnl.Think = function(s)
		-- 	print(self.cashEnt:GetIsLock())
		-- 	if (s.NextUpdate < CurTime()) then
		-- 		s:SetVisible(self.cashEnt:GetIsLock())
		-- 	end

		-- end
		LockPnl.Paint = function(s,w,h)
				
			ix.util.DrawBlur(s)

			draw.SimpleTextOutlined("P", "ixIconsBig", w/2, h*0.4, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(120,120,120))

		end

		local LockPnlText = vgui.Create( "DLabel", LockPnl )
		LockPnlText:Dock(FILL)
		LockPnlText:SetFont("ixMediumFont")
		LockPnlText:SetText( "The Cash register is locked" )
		LockPnlText:SetContentAlignment(5)

	-- end

end

function PANEL:ProcessCart(BankID)

	local bankID = BankID or 0

	net.Start("ixBCashR_Buy")
		net.WriteEntity(self.cashEnt)
		net.WriteString(self.SelectedBuyItem)
		net.WriteUInt(bankID, 20)
	net.SendToServer()

end

function PANEL:ProcessDebit()

	local PLUGINBank = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

	if (PLUGINBank) then

		local UserAccounts = {}

		PLUGINBank:GetAllAccountsData(function(data)
			
			for k, v in pairs(data) do
				
				if (tonumber(v.owner) != LocalPlayer():GetCharacter():GetID()) then
					continue
				end

				UserAccounts[#UserAccounts+1] = tonumber(v.account_id)

			end

			local DebitPanel = vgui.Create("ixCustomVendor_Debit")
			DebitPanel.BankAccounts = UserAccounts
			DebitPanel:SetParent(self)

		end)
	else
		client:Notify("No bank plugin. Please contact to the administrator")
	end


end

function PANEL:PopulateManage()

	self.MainPanel:Clear()

	local char = LocalPlayer():GetCharacter()

	if (char:GetID() != self.cashEnt:GetOwnerCharID()) and (!self.coowners[char:GetID()]) then

		local NoPermText = vgui.Create( "DLabel", self.MainPanel )
		NoPermText:Dock(FILL)
		NoPermText:DockMargin(0,5,0,5)
		NoPermText:SetFont("ixMediumFont")
		NoPermText:SetText( "Cash register can only be managed by \nthe owner and authorized persons" )
		NoPermText:SizeToContents()
		NoPermText:SetAutoStretchVertical(true)
		NoPermText:SetContentAlignment(5)

	else

		local TotalFundText = vgui.Create( "DLabel", self.MainPanel )
		TotalFundText:Dock(TOP)
		TotalFundText:DockMargin(0,5,0,0)
		TotalFundText:SetFont("ixMediumFont")
		TotalFundText:SetText( "All the funds in the cash: $"..self.cashEnt:GetFunds() )
		TotalFundText:SizeToContents()
		TotalFundText:SetAutoStretchVertical(true)
		TotalFundText:SetContentAlignment(5)
		TotalFundText.NextUpdate = CurTime()
		TotalFundText.Think = function(s)

			if (s.NextUpdate < CurTime()) then
				s:SetText( "All the funds in the cash: $"..self.cashEnt:GetFunds() )
				s.NextUpdate = CurTime() + 1
			end

		end

		local BankIDText = vgui.Create( "DLabel", self.MainPanel )
		BankIDText:Dock(TOP)
		BankIDText:DockMargin(0,5,0,15)
		BankIDText:SetFont("ixMediumFont")
		BankIDText:SetText( "Bank Account: "..self.cashEnt:GetBankID() )
		BankIDText:SizeToContents()
		BankIDText:SetAutoStretchVertical(true)
		BankIDText:SetContentAlignment(5)
		BankIDText.NextUpdate = CurTime()
		BankIDText.Think = function(s)

			if (s.NextUpdate < CurTime()) then

				local val = (self.cashEnt:GetBankID() == 0 and "Not set up") or self.cashEnt:GetBankID()

				s:SetText( "Bank Account: "..val )
				s.NextUpdate = CurTime() + 1
			end

		end

		local LockUnlockCash = self.MainPanel:Add( "DButton" )
		LockUnlockCash:SetText( "" )
		LockUnlockCash:Dock( TOP )
		LockUnlockCash:DockMargin( 0, 0, 0, 10 )
		LockUnlockCash:SetTall(40)
		LockUnlockCash.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(100,100,100)) or Color(83, 92, 104))
			surface.DrawRect(1,1,w-2,h-2)
			
			// P Q
			draw.SimpleTextOutlined((self.cashEnt:GetIsLock() and "Q") or "P", "ixIconsMedium", 13, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined((self.cashEnt:GetIsLock() and "Unlock Cash Register") or "Lock Cash Register", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		LockUnlockCash.DoClick = function()
			if (char:GetID() == self.cashEnt:GetOwnerCharID()) then
				net.Start("ixBCashR_SetLock")
					net.WriteEntity(self.cashEnt)
				net.SendToServer()
			else
				LocalPlayer():NotifyLocalized("notNow")
			end
		end

		local TakeOutFund = self.MainPanel:Add( "DButton" )
		TakeOutFund:SetText( "" )
		TakeOutFund:Dock( TOP )
		TakeOutFund:DockMargin( 0, 0, 0, 10 )
		TakeOutFund:SetTall(40)
		TakeOutFund.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(100,100,100)) or Color(83, 92, 104))
			surface.DrawRect(1,1,w-2,h-2)
			
			// P Q
			draw.SimpleTextOutlined("8", "ixIconsMedium", 12, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("Take out Funds", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		TakeOutFund.DoClick = function()
			if (char:GetID() == self.cashEnt:GetOwnerCharID()) or (self.coowners[char:GetID()] and self.coowners[char:GetID()].CanTakeFunds) then
				if (self.cashEnt:GetFunds() > 0) then
					net.Start("ixBCashR_Withdraw")
						net.WriteEntity(self.cashEnt)
					net.SendToServer()
				else
					LocalPlayer():Notify("No funds to withdraw")
				end
			else
				LocalPlayer():NotifyLocalized("notNow")
			end
		end

		local SetBankID = self.MainPanel:Add( "DButton" )
		SetBankID:SetText( "" )
		SetBankID:Dock( TOP )
		SetBankID:DockMargin( 0, 0, 0, 10 )
		SetBankID:SetTall(40)
		SetBankID.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(100,100,100)) or Color(83, 92, 104))
			surface.DrawRect(1,1,w-2,h-2)
			
			// P Q
			draw.SimpleTextOutlined("]", "ixIconsMedium", 8, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("Set Bank Account", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		SetBankID.DoClick = function()
			if (char:GetID() == self.cashEnt:GetOwnerCharID()) then

				Derma_StringRequest(
					"Set Bank Account", 
					"Set up of a bank account to be used for sales proceeds",
					"",
					function(text)

						local val = string.Trim(text)

						if (val) and (val != "") and (string.len(val) > 0) then
							net.Start("ixBCashR_SetBankID")
								net.WriteEntity(self.cashEnt)
								net.WriteString(val)
							net.SendToServer()
						end

					end,
					function(text) end
				)
				
			else
				LocalPlayer():NotifyLocalized("notNow")
			end
		end

		local ManageAccounts_AddUser = self.MainPanel:Add( "DButton" )
		ManageAccounts_AddUser:SetText( "" )
		ManageAccounts_AddUser:Dock( TOP )
		ManageAccounts_AddUser:DockMargin( 0, 0, 0, 10 )
		ManageAccounts_AddUser:SetTall(40)
		ManageAccounts_AddUser.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(100,100,100)) or Color(83, 92, 104))
			surface.DrawRect(1,1,w-2,h-2)
			
			draw.SimpleTextOutlined(".", "ixIconsMedium", 10, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("Grant permission to manage", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		ManageAccounts_AddUser.DoClick = function()
			if (char:GetID() == self.cashEnt:GetOwnerCharID()) then
				self:AddNewChar()
			else
				LocalPlayer():NotifyLocalized("notNow")
			end
		end

		local ManageAccounts_DelUser = self.MainPanel:Add( "DButton" )
		ManageAccounts_DelUser:SetText( "" )
		ManageAccounts_DelUser:Dock( TOP )
		ManageAccounts_DelUser:DockMargin( 0, 0, 0, 10 )
		ManageAccounts_DelUser:SetTall(40)
		ManageAccounts_DelUser.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(100,100,100)) or Color(83, 92, 104))
			surface.DrawRect(1,1,w-2,h-2)
			
			draw.SimpleTextOutlined("/", "ixIconsMedium", 10, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("Revoke permission to manage", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		ManageAccounts_DelUser.DoClick = function()
			if (char:GetID() == self.cashEnt:GetOwnerCharID()) then
				self:RemoveChars()
			else
				LocalPlayer():NotifyLocalized("notNow")
			end
			-- local delPnl = vgui.Create("ixBankManageAccounts_List_Del")
			-- delPnl.bankID = Accountid
			-- delPnl:SetParent(self)

			-- for k, v in pairs(self.AccountsData or {}) do
			-- 	if (tonumber(v.account_id) == tonumber(Accountid)) then
			-- 		delPnl.Accounts = util.JSONToTable(v.owners)
			-- 		delPnl:ScrollRefresh()
			-- 		break
			-- 	end
			-- end

		end

		local AddNewItem = self.MainPanel:Add( "DButton" )
		AddNewItem:SetText( "" )
		AddNewItem:Dock( TOP )
		AddNewItem:DockMargin( 0, 0, 0, 10 )
		AddNewItem:SetTall(40)
		AddNewItem.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(100,100,100)) or Color(83, 92, 104))
			surface.DrawRect(1,1,w-2,h-2)
			
			draw.SimpleTextOutlined("I", "ixIconsMedium", 12, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("Add a new item", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		AddNewItem.DoClick = function()
			self:AddNewItemPnl()
		end

		local PermList = self.MainPanel:Add( "DButton" )
		PermList:SetText( "" )
		PermList:Dock( TOP )
		PermList:DockMargin( 0, 0, 0, 10 )
		PermList:SetTall(40)
		PermList.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(100,100,100)) or Color(83, 92, 104))
			surface.DrawRect(1,1,w-2,h-2)
			
			draw.SimpleTextOutlined("E", "ixIconsMedium", 10, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("Co-owners", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		PermList.DoClick = function()
			self:OpenCoOwners()
		end
	end
	-- local ManageAccounts_Users = vgui.Create( "DListView", self.MainPanel )
	-- ManageAccounts_Users:Dock( FILL )
	-- ManageAccounts_Users:AddColumn( "Name" ).Header:SetTextColor(Color(20,20,20))
	-- ManageAccounts_Users:AddColumn( "Can take out funds" ).Header:SetTextColor(Color(20,20,20))
	-- ManageAccounts_Users:AddColumn( "Can set prices" ).Header:SetTextColor(Color(20,20,20))
	-- ManageAccounts_Users:AddColumn( "Can add items" ).Header:SetTextColor(Color(20,20,20))
	-- ManageAccounts_Users:AddColumn( "Can add add to the stock" ).Header:SetTextColor(Color(20,20,20))
	-- ManageAccounts_Users:AddColumn( "Can remove items" ).Header:SetTextColor(Color(20,20,20))

	-- ManageAccounts_Users:AddLine( "John doe", "✔", "✖", "✖", "✔" )  // ✔✖


end

function PANEL:AddNewItemPnl()

	local AddOwnerPnl = self.MainPanel:Add( "DFrame" )
	AddOwnerPnl:SetPos(3,5)
	AddOwnerPnl:SetTitle("Grant permission")
	AddOwnerPnl:SetDraggable(false)
	AddOwnerPnl:SetSizable(false)
	AddOwnerPnl:SetSize(self:GetWide()*0.98,self:GetTall()*0.8)
	-- AddOwnerPnl.Paint = function(s,w,h)
	-- 	surface.SetDrawColor(47, 54, 64)
	--     surface.DrawRect(0,0,w,h)
	-- end

	local ScrollPanel = vgui.Create( "ThreeGrid", AddOwnerPnl )
	ScrollPanel:Dock( FILL )
	ScrollPanel:DockMargin(0,0,0,0)
	ScrollPanel:SetWide(AddOwnerPnl:GetWide()-15)

	ScrollPanel:SetColumns(4)
	ScrollPanel:SetHorizontalMargin(5)
	ScrollPanel:SetVerticalMargin(5)
	ScrollPanel.Paint = function(s,w,h)
	end

	local char = LocalPlayer():GetCharacter()
	local inv = char:GetInventory()

	for k, v in pairs(inv:GetItems()) do

		local ItemPanel = ScrollPanel:Add( "DButton" )
		ItemPanel:Dock( TOP )
		-- ItemPanel:DockMargin( 0, 0, 0, 15 )
		ItemPanel:SetTall(100)
		ItemPanel:SetText("")
		ItemPanel:SetHelixTooltip(function(tooltip)
			InventoryToolTip(tooltip, v.name, v.description)
		end)
		ItemPanel.DoClick = function(s,w,h)
			net.Start("ixBCashR_ItemManage")
				net.WriteEntity(self.cashEnt)
				net.WriteBool(true)
				net.WriteUInt(k, 14)
			net.SendToServer()
			AddOwnerPnl:Close()
		end
		ItemPanel.Paint = function(s,w,h)

		//Background
		    surface.SetDrawColor(40,40,40,150)
		    surface.DrawRect(0,0,w,h)

		    if (s:IsHovered()) then
		    	surface.SetDrawColor(39, 174, 96,150)
		    	surface.DrawOutlinedRect(0,0,w,h,3)
		    end

		end

		ScrollPanel:AddCell(ItemPanel)

		local SpawnI = vgui.Create( "SpawnIcon" , ItemPanel ) -- SpawnIcon
		SpawnI:SetSize(100,100)
		SpawnI:SetPos(ItemPanel:GetWide()/2 - SpawnI:GetWide()/2,ItemPanel:GetTall()/2 - SpawnI:GetTall()/2)
		SpawnI:SetModel(v.model or "models/Items/item_item_crate.mdl" )
		SpawnI:SetTooltip(false)
		SpawnI:SetMouseInputEnabled(false)

		local ItemNameBG = vgui.Create( "DPanel", ItemPanel )
		ItemNameBG:Dock(BOTTOM)
		ItemNameBG:DockMargin(5,0,5,5)
		ItemNameBG:SetTall(22)
		ItemNameBG:SetMouseInputEnabled(false)
		ItemNameBG.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,200)
		    surface.DrawRect(0,0,w,h)
		end

		local ItemName = ItemNameBG:Add( "ixLabel")
		ItemName:Dock(FILL)
		ItemName:SetFont("ixItemDescFont")
		ItemName:SetText( v.name )
		ItemName:SetContentAlignment(5)
		-- ItemPrice:SetPadding(5)
		ItemName:SetMouseInputEnabled(false)
		
	end

end

function PANEL:OpenCoOwners()

	local CoOwnerPnl = self.MainPanel:Add( "DFrame" )
	CoOwnerPnl:SetPos(3,5)
	CoOwnerPnl:SetTitle("Co-Owners")
	CoOwnerPnl:SetDraggable(false)
	CoOwnerPnl:SetSizable(false)
	CoOwnerPnl:SetSize(self:GetWide()*0.98,self:GetTall()*0.8)

	local ManageAccounts_Users = vgui.Create( "DListView", CoOwnerPnl )
	ManageAccounts_Users:Dock( FILL )
	ManageAccounts_Users:AddColumn( "Name" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can take out funds" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can set prices" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can add items" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can add add to the stock" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can remove items" ).Header:SetTextColor(Color(20,20,20))


	for k, v in pairs(self.coowners or {}) do

		ManageAccounts_Users:AddLine( v.OwnerName, (v.CanSetPrice and "✔") or "✖", (v.CanTakeFunds and "✔") or "✖", (v.CanAddItems and "✔") or "✖", (v.CanAddStock and "✔") or "✖", (v.CanRemoveItem and "✔") or "✖" )

	end


end

function PANEL:AddNewChar()

	local AddOwnerPnl = self.MainPanel:Add( "DFrame" )
	AddOwnerPnl:SetPos(3,5)
	AddOwnerPnl:SetTitle("Grant permission")
	AddOwnerPnl:SetDraggable(false)
	AddOwnerPnl:SetSizable(false)
	AddOwnerPnl:SetSize(self:GetWide()*0.98,self:GetTall()*0.8)

	self.SelectedChar = ""
	self.SelectedOptions = {}


	local AccountSelector = vgui.Create( "DComboBox", AddOwnerPnl )
	AccountSelector:Dock(TOP)
	-- AccountSelector:DockMargin(0,0,0,10)
	AccountSelector:SetTall(50)
	AccountSelector:SetValue( "Choose a character" )

	for client, character in ix.util.GetCharacters() do
		if (client == LocalPlayer()) then continue end

		AccountSelector:AddChoice( character:GetName(), character:GetID() )

	end
	AccountSelector.OnSelect = function( s, index, value, data )
		self.SelectedChar = data
		self.SelectedOptions["OwnerName"] = value
	end

	self.AccountSelector = AccountSelector

	local options = {
		["CanSetPrice"] = "Can the user set product prices?",
		["CanTakeFunds"] = "Can the user withdraw money from the cash register?",
		["CanAddItems"] = "Can the user add new products?",
		["CanAddStock"] = "Can the user replenish the stock?",
		["CanRemoveItem"] = "Can the user delete products?",
	}

	
		-- ["CanSetPrice"] = 0,
		-- ["CanTakeFunds"] = 0,
		-- ["CanAddItems"] = 0,
		-- ["CanAddStock"] = 0,
		-- ["CanRemoveItem"] = 0,
	-- }


	for k, v in pairs(options) do

		local CheckBoxOptions = AddOwnerPnl:Add( "DCheckBoxLabel" )
		CheckBoxOptions:Dock(TOP)
		CheckBoxOptions:DockMargin(10,0,0,10)
		CheckBoxOptions:SetText(v)
		CheckBoxOptions:SizeToContents()
		CheckBoxOptions.OnChange = function( s, state )
			self.SelectedOptions[k] = state
		end

	end

	local Accept = AddOwnerPnl:Add( "DButton" )
	Accept:SetText( "Grant permission" )
	Accept:Dock(BOTTOM)
	Accept:DockMargin(5, 10, 5, 10)
	Accept.DoClick = function(s)
		net.Start("ixBCashR_PermissionsManage")
			net.WriteEntity(self.cashEnt)
			net.WriteBool(true)
			net.WriteUInt(self.SelectedChar, 12)
			PLUGIN:SentNetTable(self.SelectedOptions)
		net.SendToServer()
		AddOwnerPnl:Close()
	end

end

function PANEL:RemoveChars()

	local AddOwnerPnl = self.MainPanel:Add( "DFrame" )
	AddOwnerPnl:SetPos(3,5)
	AddOwnerPnl:SetTitle("Revoke permission")
	AddOwnerPnl:SetDraggable(false)
	AddOwnerPnl:SetSizable(false)
	AddOwnerPnl:SetSize(self:GetWide()*0.98,self:GetTall()*0.8)

	local ScrollPanel = vgui.Create( "DScrollPanel", AddOwnerPnl )
	ScrollPanel:Dock( FILL )

	for k, v in pairs(self.coowners or {}) do

		local Account = ScrollPanel:Add( "DButton" )
		Account:SetText( v.OwnerName )
		Account:Dock( TOP )
		Account:DockMargin( 0, 0, 0, 5 )
		Account.DoClick = function(s)

			Derma_Query("Are you sure you want to delete this person?", "Delete Co-owner", "Yes", function()

				net.Start("ixBCashR_PermissionsManage")
					net.WriteEntity(self.cashEnt)
					net.WriteBool(false)
					net.WriteUInt(k, 12)
				net.SendToServer()
				
				AddOwnerPnl:Close()
	           
	        end, "No", function()
	        end)
			
		end

	end

end

vgui.Register("ixSetorian_CashRegUI", PANEL, "DFrame")


-- vgui.Create("ixSetorian_CashRegUI")