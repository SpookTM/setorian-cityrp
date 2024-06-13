local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

AccessorFunc(PANEL, "bReadOnly", "ReadOnly", FORCE_BOOL)

local default_icon = Material( "setorian_vendor/lost-items.png", "noclamp smooth")

function PANEL:Init()


	self:SetSize(970,570)

	self:Center()
	self:MakePopup()

	self:SetAlpha(0)

	self:SetTitle("")
	-- self:ShowCloseButton(false)
	self:SetDraggable(false)

	self:DockPadding(10,35,10,10)

	self.Paint = function(s,w,h)

		surface.SetDrawColor(47, 53, 66, 250)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(47, 53, 66, 250)
	    surface.DrawRect(0,0,w,30)

	    surface.SetDrawColor(44, 62, 80, 30)
	    surface.DrawRect(5,35,w-10,h-40)

	end

	self:AlphaTo(255,0.3)

	local LeftPanel = vgui.Create( "Panel", self )
	LeftPanel:Dock(LEFT)
	LeftPanel:SetWide(self:GetWide()*0.35)
	LeftPanel:DockPadding(10,10,10,10)
	LeftPanel.Paint = function(s,w,h)

	    surface.SetDrawColor(44, 62, 80, 230)
	    surface.DrawRect(0,0,w,h)


	end

	local CategoryList = vgui.Create( "DScrollPanel", LeftPanel )
	CategoryList:Dock(FILL)

	self.CategoryList = CategoryList

	local MidPanel = vgui.Create( "Panel", self )
	MidPanel:Dock(FILL)
	MidPanel:DockMargin(30,0,0,0)
	MidPanel:DockPadding(10,0,10,10)
	MidPanel.Paint = function(s,w,h)
	    surface.SetDrawColor(44, 62, 80, 230)
	    surface.DrawRect(0,0,w,h)

	end

	local HeaderPanel = vgui.Create( "Panel", MidPanel )
	HeaderPanel:Dock(TOP)
	HeaderPanel:DockMargin(0,0,0,10)
	HeaderPanel:SetTall(40)

	local TotalCost = vgui.Create( "DLabel", HeaderPanel )
	TotalCost:Dock(LEFT)
	TotalCost:SetFont("ixMediumFont")
	TotalCost:SetText( "Total Cost:" )
	TotalCost:SizeToContents()
	TotalCost:SetContentAlignment(4)

	local TotalCost_Value = vgui.Create( "DLabel", HeaderPanel )
	TotalCost_Value:Dock(LEFT)
	TotalCost_Value:DockMargin(5,0,0,0)
	TotalCost_Value:SetFont("ixMediumFont")
	TotalCost_Value:SetText( "$0" )
	TotalCost_Value:SetTextColor(Color(46, 204, 113))
	TotalCost_Value:SizeToContents()
	TotalCost_Value:SetContentAlignment(4)

	self.TotalCost = TotalCost_Value

	local ItemsInCart = vgui.Create( "DLabel", HeaderPanel )
	ItemsInCart:Dock(RIGHT)
	ItemsInCart:SetFont("ixMediumFont")
	ItemsInCart:SetText( "Items in Cart:" )
	ItemsInCart:SizeToContents()
	ItemsInCart:SetZPos(2)
	ItemsInCart:SetContentAlignment(6)

	local ItemsInCart_Value = vgui.Create( "DLabel", HeaderPanel )
	ItemsInCart_Value:Dock(RIGHT)
	ItemsInCart_Value:DockMargin(5,0,0,0)
	ItemsInCart_Value:SetFont("ixMediumFont")
	ItemsInCart_Value:SetText( "0" )
	ItemsInCart_Value:SizeToContents()
	ItemsInCart_Value:SetZPos(1)
	ItemsInCart_Value:SetContentAlignment(6)

	self.CartAmount = ItemsInCart_Value
	self.CartAmountValue = 0

	local CartScroll = vgui.Create( "DScrollPanel", MidPanel )
	CartScroll:Dock(FILL)

	local PurchaseButton = vgui.Create( "DButton", MidPanel )
	PurchaseButton:Dock(BOTTOM)
	PurchaseButton:DockMargin(80,20,80,0)
	PurchaseButton:SetTall(35)
	PurchaseButton:SetFont("Trebuchet24")
	PurchaseButton:SetText("Purchase")
	PurchaseButton.Paint = function(s,w,h)

		if (s:IsHovered()) then
			surface.SetDrawColor(39, 174, 96)
		else
	    	surface.SetDrawColor(39, 174, 96, 200)
	    end
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(20,20,20)
	    surface.DrawOutlinedRect(0,0,w,h,1)

	end
	PurchaseButton.OnCursorEntered = function(s)
		surface.PlaySound("helix/ui/rollover.wav")
	end
	PurchaseButton.DoClick = function(s)

		if (table.IsEmpty(self.ItemsInCart)) then 
			LocalPlayer():Notify("The cart is empty")
			return
		end

		surface.PlaySound("helix/ui/press.wav")

		local paymeth = vgui.Create("ixVendor_ChooseMode")
		paymeth:SetParent(self)

	end

	local CartList = CartScroll:Add("DListLayout")
	CartList:SetSize(self:GetWide() - self:GetWide()*0.35 - 70)
	-- CartList:Dock( FILL )
	CartList:DockPadding(0, 0, 0, 4)

	self.CartList = CartList


	self.ItemsInCart = {}

	self.VendorCategories = {}
	self.VendorItems = {}



	

end

function PANEL:AnimationTransition()


end

function PANEL:PrepareCategories()

	self.VendorCategories = {}

	for k, v in pairs(self.VendorItems) do

		if (self.VendorCategories[v.category]) then continue end

		self.VendorCategories[v.category] = true

	end

	self:RenderCategories()

end

function PANEL:RenderCategories()

	self.CategoryList:Clear()


	for k, v in pairs(self.VendorCategories) do

		local CategoryPanel = self.CategoryList:Add( "DButton" )
		CategoryPanel:Dock(TOP)
		CategoryPanel:DockMargin(0,0,0,10)
		CategoryPanel:SetTall(70)
		CategoryPanel:SetText("")
		CategoryPanel.CategoryID = k
		CategoryPanel.Paint = function(s,w,h)

			if (s:IsHovered()) then
				surface.SetDrawColor(52, 58, 71)
			else
		    	surface.SetDrawColor(47, 53, 66, 230)
		    end
		    surface.DrawRect(0,0,w,h)

		end
		CategoryPanel.OnCursorEntered = function(s)
			surface.PlaySound("helix/ui/rollover.wav")
		end
		CategoryPanel.DoClick = function(s)

			self:RenderCategoryItems(s.CategoryID)

		end

		local IconMat = default_icon

		if (PLUGIN.CategoryIcons[k]) then
			IconMat = Material( PLUGIN.CategoryIcons[k], "noclamp smooth")
		end

		local CategoryLogo = vgui.Create("DImage", CategoryPanel)
		CategoryLogo:Dock(LEFT)
		CategoryLogo:DockMargin(10,10,10,10)
		CategoryLogo:SetWide(CategoryPanel:GetTall()-20)	
		CategoryLogo:SetMaterial(IconMat)

		local CategoryTitle = vgui.Create( "DLabel", CategoryPanel )
		CategoryTitle:Dock(LEFT)
		CategoryTitle:SetFont("ixMediumFont")
		CategoryTitle:SetText( k )
		CategoryTitle:SizeToContents()
		CategoryTitle:SetContentAlignment(4)

	end

end

function PANEL:RenderCategoryItems(SCategory)

	self.CategoryList:Clear()

	-- surface.PlaySound("helix/ui/press.wav")

	local ReturnPanel = self.CategoryList:Add( "DButton" )
	ReturnPanel:Dock(TOP)
	ReturnPanel:DockMargin(0,0,0,10)
	ReturnPanel:SetTall(70)
	ReturnPanel:SetText("")
	ReturnPanel.Paint = function(s,w,h)

		if (s:IsHovered()) then
			surface.SetDrawColor(52, 58, 71)
		else
	    	surface.SetDrawColor(47, 53, 66, 230)
	    end
	    surface.DrawRect(0,0,w,h)

	end
	ReturnPanel.OnCursorEntered = function(s)
		surface.PlaySound("helix/ui/rollover.wav")
	end
	ReturnPanel.DoClick = function(s)
		self:RenderCategories()
	end

	local ReturnIamge = vgui.Create( "DLabel", ReturnPanel )
	ReturnIamge:Dock(LEFT)
	ReturnIamge:DockMargin(20,10,25,10)
	ReturnIamge:SetFont("ixIconsBig")
	ReturnIamge:SetText( "s" )
	ReturnIamge:SizeToContents()
	ReturnIamge:SetContentAlignment(4)

	local ReturnTitle = vgui.Create( "DLabel", ReturnPanel )
	ReturnTitle:Dock(LEFT)
	ReturnTitle:SetFont("ixMediumFont")
	ReturnTitle:SetText( "Return" )
	ReturnTitle:SizeToContents()
	ReturnTitle:SetContentAlignment(4)


	for k, v in pairs(self.VendorItems) do

		if (v.category != SCategory) then continue end

		local items = self.entity.items
		local data = items[k]
		local stocks = self.entity:GetStock(k)

		local CanBuy = data[VENDOR_MODE] == VENDOR_BUYONLY
		local CanSell = data[VENDOR_MODE] == VENDOR_SELLONLY
		local BothMode = data[VENDOR_MODE] == VENDOR_SELLANDBUY

		local ItemPanel = self.CategoryList:Add( "DButton" )
		ItemPanel:Dock(TOP)
		ItemPanel:DockMargin(0,0,0,10)
		ItemPanel:SetTall(70)
		ItemPanel:SetText("")
		ItemPanel:SetTooltip(v.desc)
		ItemPanel.Paint = function(s,w,h)

			if (s:IsHovered()) then
				surface.SetDrawColor(52, 58, 71)
			else
		    	surface.SetDrawColor(47, 53, 66, 230)
		    end
		    surface.DrawRect(0,0,w,h)

		end
		ItemPanel.OnCursorEntered = function(s)
			surface.PlaySound("helix/ui/rollover.wav")
		end
		ItemPanel.DoClick = function(s)

			if (self:GetReadOnly()) then
				LocalPlayer():Notify("You are in edit mode")
				return
			end

			local Menu = DermaMenu()

			if (CanSell or BothMode) then

				local stock = stocks or 5

				local purshaseButtonChild, purshaseButton = Menu:AddSubMenu( "Add to cart")
				purshaseButton:SetIcon( "icon16/cart.png" )	

				if (stock > 0) then

					for i=1, math.min(stock, 5) do
						local AddCart = purshaseButtonChild:AddOption( "Add x"..i, function() 

							self:AddToCart(k, v.price, i)

							self:RenderCategoryItems(SCategory)

						end)
						AddCart:SetIcon( "icon16/cart_add.png" )	
					end

				else
					local outstock = purshaseButtonChild:AddOption( "Out of Stock" )
					outstock:SetIcon( "icon16/cancel.png" )

				end

			end


			if (CanBuy or BothMode) then

				local itemCount = LocalPlayer():GetCharacter():GetInventory():GetItemCount(k)

				local sellButtonChild, sellButton = Menu:AddSubMenu( "Sell item")
				sellButton:SetIcon( "icon16/money_dollar.png" )	

				if (itemCount > 0) then

					for i=1, math.min(itemCount, 5) do
						local SellItem = sellButtonChild:AddOption( "Sell x"..i, function() 

							net.Start("ixVendorTrade_Extd_Sell")
								net.WriteUInt( i, 6 )
								net.WriteString(k)
							net.SendToServer()

							self:RenderCategoryItems(SCategory)

						end)
						SellItem:SetIcon( "icon16/money_add.png" )	
					end

				else
					local notItem = sellButtonChild:AddOption( "You don't have this item" )
					notItem:SetIcon( "icon16/cancel.png" )
				end

			end
			
			Menu:Open()

		end

		local ItemImage = vgui.Create("SpawnIcon", ItemPanel)
		ItemImage:Dock(LEFT)
		ItemImage:DockMargin(10,10,10,10)
		ItemImage:SetWide(ItemPanel:GetTall()-20)	
		ItemImage:SetModel( v.model )
		ItemImage:SetTooltip(false)
		ItemImage:SetMouseInputEnabled(false)

		local ItemTitle = vgui.Create( "DLabel", ItemPanel )
		ItemTitle:Dock(LEFT)
		ItemTitle:SetFont("ixMediumFont")
		ItemTitle:SetText( v.name )
		ItemTitle:SizeToContents()
		ItemTitle:SetContentAlignment(4)

		local ItemPrice = vgui.Create( "DLabel", ItemPanel )
		ItemPrice:Dock(RIGHT)
		ItemPrice:DockMargin(0,0,10,0)
		ItemPrice:SetFont("ixMediumFont")
		ItemPrice:SetTextColor(Color(46, 204, 113))
		ItemPrice:SetText( "$"..v.price )
		ItemPrice:SizeToContents()
		ItemPrice:SetContentAlignment(6)


		-- if (stocks == 0) then
		-- 	self:RenderOutStock(ItemPanel)
		-- end

	end

end

function PANEL:RenderOutStock(panel)

	local OutStockPanel = vgui.Create( "Panel", panel )
	OutStockPanel:SetPos(0,0)
	OutStockPanel:SetSize(self:GetWide()*0.35 - 20, 70)
	OutStockPanel.Paint = function(s,w,h)

	    surface.SetDrawColor(10,10,10, 230)
	    surface.DrawRect(0,0,w,h)

	end

	local OutStockPanel_Text = vgui.Create( "DLabel", OutStockPanel )
	OutStockPanel_Text:Dock(FILL)
	OutStockPanel_Text:SetFont("ixMediumFont")
	OutStockPanel_Text:SetText( "Out of Stock" )
	OutStockPanel_Text:SizeToContents()
	OutStockPanel_Text:SetContentAlignment(5)

end

function PANEL:SellItem(uniqueID, count)


end

function PANEL:AddToCart(uniqueID, price, count)

	surface.PlaySound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav")

	if (self.ItemsInCart[uniqueID]) then
		self.ItemsInCart[uniqueID].amount = self.ItemsInCart[uniqueID].amount + count
		self.ItemsInCart[uniqueID].itemPanel.ItemAmount:SetText( "x"..self.ItemsInCart[uniqueID].amount )
		self.ItemsInCart[uniqueID].itemPanel.ItemAmount:SizeToContents()
		self.ItemsInCart[uniqueID].itemPanel.ItemRemoveB.DoClick = function(s)

			if (self.ItemsInCart[uniqueID].amount > 1) then

				local RemoveMenu = DermaMenu()

				RemoveMenu:AddOption("Remove 1 item", function()
					self:RemoveFromCart(uniqueID, 1)
				end)

				for i=2, self.ItemsInCart[uniqueID].amount do

					RemoveMenu:AddOption("Remove "..i.." items", function()
						self:RemoveFromCart(uniqueID, i)
					end)

				end

				RemoveMenu:Open()

			else
				self:RemoveFromCart(uniqueID, 1)
			end

		end
	else

		local item = self.CartList:Add("DPanel")
		item:SetTall(70)
		item:DockMargin(0,0,0,10)
		item.Paint = function(s,w,h)
		    surface.SetDrawColor(47, 53, 66, 230)
		    surface.DrawRect(0,0,w,h)

		end

		self.ItemsInCart[uniqueID] = {
			price = price,
			itemPanel = item,
			amount = count
		}

	
		local ItemImage = vgui.Create("SpawnIcon", item)
		ItemImage:Dock(LEFT)
		ItemImage:DockMargin(10,10,10,10)
		ItemImage:SetWide(item:GetTall()-20)	
		ItemImage:SetModel( self.VendorItems[uniqueID].model )
		ItemImage:SetTooltip(false)
		ItemImage:SetMouseInputEnabled(false)

		local ItemTitle = vgui.Create( "DLabel", item )
		ItemTitle:Dock(LEFT)
		ItemTitle:SetFont("ixMediumFont")
		ItemTitle:SetText( self.VendorItems[uniqueID].name )
		ItemTitle:SizeToContents()
		ItemTitle:SetContentAlignment(4)

		local ItemRemoveB = item:Add( "DButton" )
		ItemRemoveB:Dock(RIGHT)
		ItemRemoveB:DockMargin(0,20,10,20)
		ItemRemoveB:SetWide(30)
		ItemRemoveB:SetFont("Trebuchet24")
		ItemRemoveB:SetText("×")
		ItemRemoveB.Paint = function(s,w,h)

			if (s:IsHovered()) then
				surface.SetDrawColor(255,0,0)
			else
		    	surface.SetDrawColor(255,120,120, 230)
		    end
		    surface.DrawRect(0,0,w,h)

		end
		ItemRemoveB.DoClick = function(s)

			if (count > 1) then

				local RemoveMenu = DermaMenu()

				RemoveMenu:AddOption("Remove 1 item", function()
					self:RemoveFromCart(uniqueID, 1)
				end)

				for i=2, self.ItemsInCart[uniqueID].amount do

					RemoveMenu:AddOption("Remove "..i.." items", function()
						
						self:RemoveFromCart(uniqueID, i)

					end)

				end

				RemoveMenu:Open()

			else
				self:RemoveFromCart(uniqueID, 1)
			end

		end

		item.ItemRemoveB = ItemRemoveB

		local ItemAmount = vgui.Create( "DLabel", item )
		ItemAmount:Dock(RIGHT)
		ItemAmount:DockMargin(0,0,10,0)
		ItemAmount:SetFont("ixMediumFont")
		ItemAmount:SetText( "x"..count )
		ItemAmount:SizeToContents()
		ItemAmount:SetContentAlignment(6)

		item.ItemAmount = ItemAmount

		local ItemPrice = vgui.Create( "DLabel", item )
		ItemPrice:Dock(RIGHT)
		ItemPrice:DockMargin(0,0,10,0)
		ItemPrice:SetFont("ixMediumFont")
		ItemPrice:SetTextColor(Color(46, 204, 113))
		ItemPrice:SetText( "$"..price )
		ItemPrice:SizeToContents()
		ItemPrice:SetContentAlignment(6)




		self.CartList:InvalidateLayout()

	end

	self:CalculateCost()

end

function PANEL:RemoveFromCart(uniqueID, count)

	surface.PlaySound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav")

	if (self.ItemsInCart[uniqueID]) then

		self.ItemsInCart[uniqueID].amount = math.max(self.ItemsInCart[uniqueID].amount - count,0)

		if (self.ItemsInCart[uniqueID].amount == 0) then

			self.ItemsInCart[uniqueID].itemPanel:Remove()
			self.ItemsInCart[uniqueID] = nil
			self.CartList:InvalidateLayout()
			self:CalculateCost()
			return
		end

		self.ItemsInCart[uniqueID].itemPanel.ItemAmount:SetText( "x"..self.ItemsInCart[uniqueID].amount )
		self.ItemsInCart[uniqueID].itemPanel.ItemAmount:SizeToContents()
		self.ItemsInCart[uniqueID].itemPanel.ItemRemoveB.DoClick = function(s)

			if (self.ItemsInCart[uniqueID].amount > 1) then

				local RemoveMenu = DermaMenu()

				RemoveMenu:AddOption("Remove 1 item", function()
					self:RemoveFromCart(uniqueID, 1)
				end)

				for i=2, self.ItemsInCart[uniqueID].amount do

					RemoveMenu:AddOption("Remove "..i.." items", function()
						self:RemoveFromCart(uniqueID, i)
					end)

				end

				RemoveMenu:Open()

			else
				self:RemoveFromCart(uniqueID, 1)
			end

		end

	end
	self:CalculateCost()

end

function PANEL:ClearCart()

	self.CartList:Clear()
	self.ItemsInCart = {}
	self:CalculateCost()

end

function PANEL:CalculateCost()

	local InCart = 0
	local CartCost = 0

	self.CartAmountValue = 0

	for k, v in pairs(self.ItemsInCart) do

		InCart = InCart + v.amount
		CartCost = CartCost + (v.amount * v.price)

	end


	self.TotalCost:SetText( "$"..CartCost )
	self.TotalCost:SizeToContents()
	self.CartAmount:SetText(InCart)
	self.CartAmount:SizeToContents()

	self.CartAmountValue = CartCost

end

function PANEL:ProcessCart(BankID)

	local bankID = BankID or 0


	if (bankID == 0) then

		if (LocalPlayer():GetCharacter():GetMoney() < self.CartAmountValue) then
			LocalPlayer():NotifyLocalized("canNotAfford")
			return
		end
	
	end

	
	local BuyedItems = {}
	local ItemsAmount = {}

	for k, v in pairs(self.ItemsInCart) do
		BuyedItems[#BuyedItems+1] = k
		ItemsAmount[#ItemsAmount+1] = v.amount
	end

	local len = #BuyedItems

	net.Start("ixVendorTrade_Extd_Buy")
		net.WriteUInt( len, 6 )
		for i = 1, len do
			net.WriteString(BuyedItems[i])
		end
		for i = 1, len do
			net.WriteUInt(ItemsAmount[i], 7 )
		end
		net.WriteUInt(bankID, 20)
	net.SendToServer()

end

function PANEL:ProcessDebit()

	local PLUGINBank = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

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



end

function PANEL:addItem(uniqueID, listID)

	local entity = self.entity
	local items = entity.items
	local data = items[uniqueID]

	if (!data) then return end
	if (!data[VENDOR_MODE]) then return end

	local itemsTable = ix.item.list[uniqueID]

	local ItemData = {}

	ItemData.name = itemsTable.name or "Unknown"
	ItemData.category = itemsTable.category or "Misc"
	ItemData.model = itemsTable.model or "models/error.mdl"
	ItemData.desc = itemsTable.description or ""
	ItemData.price = data[VENDOR_PRICE] or 0

	self.VendorItems[uniqueID] = ItemData

	if (self:GetReadOnly()) then
		self:PrepareCategories()
	end

end

function PANEL:removeItem(uniqueID, listID)

	if (self.VendorItems[uniqueID]) then
		self.VendorItems[uniqueID] = nil
	end

	if (self:GetReadOnly()) then
		self:PrepareCategories()
	end

end

function PANEL:OnRemove()
	net.Start("ixVendorClose")
	net.SendToServer()

	if (IsValid(ix.gui.vendorEditor)) then
		ix.gui.vendorEditor:Remove()
	end
end

function PANEL:Think()
	local entity = self.entity

	if (!IsValid(entity)) then
		self:Remove()

		return
	end

end

function PANEL:Setup(entity)
	self.entity = entity

	for k, _ in SortedPairs(entity.items) do
		self:addItem(k, "selling")
	end

	self:PrepareCategories()

end

vgui.Register("ixVendor", PANEL, "DFrame")
-- vgui.Create("ixVendor")