surface.CreateFont("ix3D2DMediumFont_Smaller", {
		font = "Roboto Th",
		size = 35,
		extended = true,
		weight = 100
	})

local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("keys") or false

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(700,600)
	self:Center()
	self:MakePopup()
	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(true)
	self:SetDraggable(false)

	self.ActiveCategory = "All"

	self.Paint = function(s,w,h)

		//Background
	    -- surface.SetDrawColor( 44, 62, 80, 250 )
	    -- surface.SetDrawColor(24, 37, 52, 100)
	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(52, 73, 94, 255)
	    surface.DrawRect(5,5,w-10,h-10)

	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(5,5,w-10,5+48)

	    draw.SimpleText("Properties", "ix3D2DMediumFont", 12,5, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)


	    //property type bg

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(0,65,w,45)

	    -- draw.DrawText("Choose property's type", "ixMediumLightFont", 10,75, Color( 240,240,240 ), TEXT_ALIGN_LEFT)

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(0,5+48,w,5)


	end

	local Categories = vgui.Create( "DComboBox", self )
	Categories:Dock(TOP)
	Categories:DockMargin(0,35,5,5)
	Categories:SetTall(40)
	-- Categories:SetSize( 100, 20 )
	Categories:SetValue( "Property Type" )
	Categories:SetFont("ix3D2DMediumFont_Smaller")
	Categories:AddChoice( "All" )
	for k, v in pairs(PLUGIN.PropertiesCategories) do
	Categories:AddChoice( v )
	end
	Categories.OnSelect = function( s, index, value )
		if (self.ActiveCategory != value) then
			self.ActiveCategory = value
			self:RenderProperties(value)
		end
	end

	self.tabs = vgui.Create( "DPanel", self )
	self.tabs:Dock(TOP)
	self.tabs:SetTall(80)
	self.tabs.buttons = {}
	self.tabs.Paint = function(s,w,h)
		surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(0,0,w,5)

		surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(0,h-5,w,5)
	end

	local buttonColor = (ix.config.Get("color") or Color(140, 140, 140, 255))

	// SelectedTab
	/*
	1 - Buy
	2 - Rent
	3 - Owned
	*/
	self.selectedTab = 1


	local buybuttonTab = self.tabs:Add("ixMenuSelectionButton")
	buybuttonTab:SetText("BUY")
	buybuttonTab:SizeToContents()
	-- buybuttonTab:SetWide(self:GetWide()/3)
	buybuttonTab:SetContentAlignment(5)
	buybuttonTab:Dock(LEFT)
	buybuttonTab:DockMargin(45,0,5,10)
	-- buybuttonTab:SetPos(25, 5 )
	-- button:DockMargin(ScreenScale(30 / 3), ScreenScale(15 / 3), 0, ScreenScale(15 / 3))
	buybuttonTab:SetButtonList(self.tabs.buttons)
	buybuttonTab:SetBackgroundColor(buttonColor)
	buybuttonTab:SetSelected(true)
	buybuttonTab.OnSelected = function()
		self.selectedTab = 1
		self:RenderProperties(self.ActiveCategory)
	end
	
	local rentbuttonTab = self.tabs:Add("ixMenuSelectionButton")
	rentbuttonTab:SetText("Rent")
	rentbuttonTab:SizeToContents()
	-- rentbuttonTab:SetWide(self:GetWide()/3)
	-- rentbuttonTab:SetPos(self:GetWide()/2 - rentbuttonTab:GetWide() / 2,5)
	rentbuttonTab:SetContentAlignment(5)
	rentbuttonTab:Dock(FILL)
	rentbuttonTab:DockMargin(10,0,10,10)
	-- button:DockMargin(ScreenScale(30 / 3), ScreenScale(15 / 3), 0, ScreenScale(15 / 3))
	rentbuttonTab:SetButtonList(self.tabs.buttons)
	rentbuttonTab:SetBackgroundColor(buttonColor)
	rentbuttonTab.OnSelected = function()
		self.selectedTab = 2
		self:RenderProperties(self.ActiveCategory)
	end

	local ownedbuttonTab = self.tabs:Add("ixMenuSelectionButton")
	ownedbuttonTab:SetText("Owned")
	ownedbuttonTab:SizeToContents()
	-- ownedbuttonTab:SetWide(self:GetWide()/3)
	ownedbuttonTab:Dock(RIGHT)
	ownedbuttonTab:DockMargin(5,0,15,10)
	-- ownedbuttonTab:SetPos(self:GetWide() - ownedbuttonTab:GetWide() - 30, 5)
	ownedbuttonTab:SetContentAlignment(5)
	-- button:DockMargin(ScreenScale(30 / 3), ScreenScale(15 / 3), 0, ScreenScale(15 / 3))
	ownedbuttonTab:SetButtonList(self.tabs.buttons)
	ownedbuttonTab:SetBackgroundColor(buttonColor)
	ownedbuttonTab.OnSelected = function()
		self.selectedTab = 3
		self:RenderProperties(self.ActiveCategory)
	end

	self.mainPanel = vgui.Create( "DScrollPanel", self )
	self.mainPanel:Dock(FILL)
	self.mainPanel:DockMargin(5,5,5,5)
	self.mainPanel.CurrentAlpha = 255

	local sbar = self.mainPanel:GetVBar()
	-- sbar:DockMargin(0,0,0,0)
	sbar:SetWide(1)

	self:RenderProperties(self.ActiveCategory)
	-- self:RenderBuyTab()

end

function PANEL:RenderProperties(category, noAnim)

	if (noAnim) then
		self.mainPanel:Clear()

		if (self.selectedTab == 1) then
			self:RenderBuyTab(category)
		elseif (self.selectedTab == 2) then
			self:RenderRentTab(category)
		elseif (self.selectedTab == 3) then
			self:RenderOwnedTab(category)
		end
	
	else

	-- self.mainPanel:Clear()
		self.mainPanel:CreateAnimation(animationTime * 0.2, {
			index = 1,
			target = {
				CurrentAlpha = 0,
			},
			easing = "outQuint",

			Think = function(animation, panel)
				panel:SetAlpha(panel.CurrentAlpha)
			end,
			OnComplete = function(animation, panel)

				panel:Clear()


				if (self.selectedTab == 1) then
					self:RenderBuyTab(category)
				elseif (self.selectedTab == 2) then
					self:RenderRentTab(category)
				elseif (self.selectedTab == 3) then
					self:RenderOwnedTab(category)
				end

				-- self:PropertiesContent(category)


				panel:CreateAnimation(animationTime * 0.3, {
					index = 2,
					target = {
						CurrentAlpha = 255,
					},
					easing = "inQuint",

					Think = function(animation, panel)

						panel:SetAlpha(panel.CurrentAlpha)
					end,
				})
			end
		})

	end

-- PrintTable(self.Properties)

	-- for i=0, 3 do


end

function PANEL:RenderBuyTab(category)

	for k, v in pairs(self.Properties or {}) do
		if (category != "All") then
			if (v.category != category) then continue end
		end

		if (!v.is_buy) then
			continue
		end

		if (tostring(v.owner) != '0') then continue end

		-- if (self.selectedTab == 2) then
		-- 	print(v.owner, v.rent_status)
		-- 	if ((tostring(v.owner) != '0') or ((tostring(v.owner) != '0') and (!v.rent_status)) ) then continue end
		-- end

		local buymethod = ""
		if (v.is_buy) then
			buymethod = buymethod .. "buyable"
		end
		if (v.is_rent) then
			if (buymethod != "") then buymethod = buymethod .. ", " end
			buymethod = buymethod .. "rentable"
		end

		local panelBG = vgui.Create( "DPanel", self.mainPanel )
		panelBG:Dock(TOP)
		panelBG:DockMargin(0,0,0,10)
		panelBG:SetTall(230)
		panelBG.Paint = function(s,w,h)
			surface.SetDrawColor(44, 62, 80, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText(v.name or "Unknown", "ix3D2DMediumFont", w/2, 0, Color( 240,240,240 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)

		    -- draw.SimpleText("9", "ixIconsBig", 0, 0, Color( 52, 73, 94 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		local InfoBG = vgui.Create( "DPanel", panelBG )
		InfoBG:Dock(TOP)
		InfoBG:DockMargin(10,70,10,0)
		InfoBG:SetTall(55)
		InfoBG.Paint = function(s,w,h)
		end

		local MoneyInfo = vgui.Create( "DPanel", InfoBG )
		MoneyInfo:Dock(LEFT)
		MoneyInfo:SetWide(self:GetWide()/2 - 40)
		MoneyInfo.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText( "6", "ixIconsBig", 5, 5, Color( 240,240,240 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		    -- draw.SimpleText( , "ixMediumLightFont", w-10, h/2, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local MoneyInfoText = vgui.Create( "ixLabel", MoneyInfo )
		MoneyInfoText:Dock(FILL)
		MoneyInfoText:DockMargin(60,0,5,0)
		MoneyInfoText:SetText(ix.currency.Get(v.price))
		MoneyInfoText:SetFont("ixMediumLightFont")
		MoneyInfoText:SetContentAlignment(6)


		local OwnerInfo = vgui.Create( "DPanel", InfoBG )
		OwnerInfo:Dock(RIGHT)
		OwnerInfo:SetWide(self:GetWide()/2 - 40)
		OwnerInfo.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText( "/", "ixIconsBig", 5, 5, Color( 240,240,240 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		    draw.SimpleText( "City", "ixMediumLightFont", w-10, h/2, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local ButtonsBG = vgui.Create( "DPanel", panelBG )
		ButtonsBG:Dock(TOP)
		ButtonsBG:DockMargin(10,5,10,0)
		ButtonsBG:SetTall(55)
		ButtonsBG.Paint = function(s,w,h)
		end

		local ViewButton = vgui.Create( "ixMenuButton", ButtonsBG )
		ViewButton:Dock(LEFT)
		ViewButton:SetWide(self:GetWide()/2 - 40)
		ViewButton:SetFont("ix3D2DMediumFont_Smaller")
		ViewButton:SetText("View Property")
		ViewButton.DoClick = function(pnl)
	        vgui.Create("ixPropertiesMenu_preview"):SetImage(v.preview)
	    end
		
		local BuyButton = vgui.Create( "ixMenuButton", ButtonsBG )
		BuyButton:Dock(RIGHT)
		BuyButton:SetContentAlignment(6)
		BuyButton:SetWide(self:GetWide()/2 - 40)
		BuyButton:SetFont("ix3D2DMediumFont_Smaller")
		BuyButton:SetText("Buy Property")
		BuyButton.DoClick = function(pnl)
	        netstream.Start("ixPropeties_Buy", v.name)
	        self:DataUpdate()
	    end

		local ExtraInfo = vgui.Create("ixLabel", panelBG)
		ExtraInfo:Dock(BOTTOM)
		ExtraInfo:DockMargin(0,0,0,5)
		ExtraInfo:SetText("Property buy methods: " .. buymethod)
		ExtraInfo:SetFont("ixMediumLightFont")
		ExtraInfo:SetContentAlignment(5)
		ExtraInfo:SetTextColor(Color(255, 255, 255, 255))
		-- ExtraInfo:SetBackgroundColor(Color(200, 30, 30, 255))
		ExtraInfo:SetPadding(8)
		ExtraInfo:SetScaleWidth(true)
		ExtraInfo:SizeToContents()

	end

end

function PANEL:RenderRentTab(category)

	for k, v in pairs(self.Properties or {}) do
		if (category != "All") then
			if (v.category != category) then continue end
		end

		if (!v.is_rent) and (tostring(v.owner) == '0') then
			continue
		end

		if (!v.rent_status) and (tostring(v.owner) != '0') then
			continue
		end

		if (tostring(v.tenant) != '0') then continue end

		-- if (self.selectedTab == 2) then
		-- 	print(v.owner, v.rent_status)
			-- if ((tostring(v.owner) != '0') or ((tostring(v.owner) != '0') and (!v.rent_status)) ) then continue end
		-- end

		local buymethod = ""
		if (v.is_buy) then
			buymethod = buymethod .. "buyable"
		end
		if (v.is_rent) or (v.rent_status) then
			if (buymethod != "") then buymethod = buymethod .. ", " end
			buymethod = buymethod .. "rentable"
		end

		local panelBG = vgui.Create( "DPanel", self.mainPanel )
		panelBG:Dock(TOP)
		panelBG:DockMargin(0,0,0,10)
		panelBG:SetTall(230)
		panelBG.Paint = function(s,w,h)
			surface.SetDrawColor(44, 62, 80, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText(v.name or "Unknown", "ix3D2DMediumFont", w/2, 0, Color( 240,240,240 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)

		    -- draw.SimpleText("9", "ixIconsBig", 0, 0, Color( 52, 73, 94 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		local InfoBG = vgui.Create( "DPanel", panelBG )
		InfoBG:Dock(TOP)
		InfoBG:DockMargin(10,70,10,0)
		InfoBG:SetTall(55)
		InfoBG.Paint = function(s,w,h)
		end

		local MoneyInfo = vgui.Create( "DPanel", InfoBG )
		MoneyInfo:Dock(LEFT)
		MoneyInfo:SetWide(self:GetWide()/2 - 40)
		MoneyInfo.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText( "6", "ixIconsBig", 5, 5, Color( 240,240,240 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		    -- draw.SimpleText( , "ixMediumLightFont", w-10, h/2, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local MoneyInfoText = vgui.Create( "ixLabel", MoneyInfo )
		MoneyInfoText:Dock(FILL)
		MoneyInfoText:DockMargin(60,0,5,0)
		MoneyInfoText:SetText(ix.currency.Get(v.price_rent) .. " / Hour")
		MoneyInfoText:SetFont("ixMediumLightFont")
		MoneyInfoText:SetContentAlignment(6)


		local OwnerInfo = vgui.Create( "DPanel", InfoBG )
		OwnerInfo:Dock(RIGHT)
		OwnerInfo:SetWide(self:GetWide()/2 - 40)
		OwnerInfo.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText( "/", "ixIconsBig", 5, 5, Color( 240,240,240 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		    draw.SimpleText( (v.owner_name != "" and v.owner_name) or "City", "ixMediumLightFont", w-10, h/2, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end


		local ButtonsBG = vgui.Create( "DPanel", panelBG )
		ButtonsBG:Dock(TOP)
		ButtonsBG:DockMargin(10,5,10,0)
		ButtonsBG:SetTall(55)
		ButtonsBG.Paint = function(s,w,h)
		end

		local ViewButton = vgui.Create( "ixMenuButton", ButtonsBG )
		ViewButton:Dock(LEFT)
		ViewButton:SetWide(self:GetWide()/2 - 40)
		ViewButton:SetFont("ix3D2DMediumFont_Smaller")
		ViewButton:SetText("View Property")
		ViewButton.DoClick = function(pnl)
	        vgui.Create("ixPropertiesMenu_preview"):SetImage(v.preview)
	    end

		local RentButton = vgui.Create( "ixMenuButton", ButtonsBG )
		RentButton:Dock(RIGHT)
		RentButton:SetContentAlignment(6)
		RentButton:SetWide(self:GetWide()/2 - 40)
		RentButton:SetFont("ix3D2DMediumFont_Smaller")
		RentButton:SetText("Rent Property")
		RentButton.DoClick = function(pnl)
			local rentMenu = vgui.Create("ixPropertiesMenu_rent")
			rentMenu.Price = tonumber(v.price_rent)
			-- rentMenu
			rentMenu:SetParent(self)
			rentMenu.sName = v.name
	        -- netstream.Start("ixPropeties_Buy", v.name)
	        -- self:DataUpdate()
	    end

		local ExtraInfo = vgui.Create("ixLabel", panelBG)
		ExtraInfo:Dock(BOTTOM)
		ExtraInfo:DockMargin(0,0,0,5)
		ExtraInfo:SetText("Property buy methods: " .. buymethod)
		ExtraInfo:SetFont("ixMediumLightFont")
		ExtraInfo:SetContentAlignment(5)
		ExtraInfo:SetTextColor(Color(255, 255, 255, 255))
		-- ExtraInfo:SetBackgroundColor(Color(200, 30, 30, 255))
		ExtraInfo:SetPadding(8)
		ExtraInfo:SetScaleWidth(true)
		ExtraInfo:SizeToContents()

	end

end

function PANEL:RenderOwnedTab(category)

	for k, v in pairs(self.Properties or {}) do
		if (category != "All") then
			if (v.category != category) then continue end
		end

		if (v.owner != tostring(LocalPlayer():GetCharacter():GetID())) then
			continue
		end

		

		local panelBG = vgui.Create( "DPanel", self.mainPanel )
		panelBG:Dock(TOP)
		panelBG:DockMargin(0,0,0,10)
		panelBG:SetTall(320)
		panelBG.Paint = function(s,w,h)
			surface.SetDrawColor(44, 62, 80, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText(v.name or "Unknown", "ix3D2DMediumFont", w/2, 0, Color( 240,240,240 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)

		    -- draw.SimpleText("9", "ixIconsBig", 0, 0, Color( 52, 73, 94 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		local InfoBG = vgui.Create( "DPanel", panelBG )
		InfoBG:Dock(TOP)
		InfoBG:DockMargin(10,70,10,0)
		InfoBG:SetTall(55)
		InfoBG.Paint = function(s,w,h)
		end

		local MoneyInfo = vgui.Create( "DPanel", InfoBG )
		MoneyInfo:Dock(LEFT)
		MoneyInfo:SetWide(self:GetWide()/2 - 40)
		MoneyInfo.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText( "6", "ixIconsBig", 5, 5, Color( 240,240,240 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		    -- draw.SimpleText( , "ixMediumLightFont", w-10, h/2, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local MoneyInfoText = vgui.Create( "ixLabel", MoneyInfo )
		MoneyInfoText:Dock(FILL)
		MoneyInfoText:DockMargin(60,0,5,0)
		MoneyInfoText:SetText( (!v.rent_status and "Not rentable") or ix.currency.Get(v.price_rent) .. " / Hour")
		MoneyInfoText:SetFont("ixMediumLightFont")
		MoneyInfoText:SetContentAlignment(6)


		local OwnerInfo = vgui.Create( "DPanel", InfoBG )
		OwnerInfo:Dock(RIGHT)
		OwnerInfo:SetWide(self:GetWide()/2 - 40)
		OwnerInfo.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText( "?", "ixIconsBig", 5, 5, Color( 240,240,240 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		    -- draw.SimpleText("tenant", "ixMediumLightFont", w-10, h/2, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local OwnerInfoText = vgui.Create( "ixLabel", OwnerInfo )
		OwnerInfoText:Dock(FILL)
		OwnerInfoText:DockMargin(60,0,5,0)
		OwnerInfoText:SetText( (!v.rent_status and "Not rentable") or (v.tenant_name != "" and v.tenant_name) or "No one is renting")
		OwnerInfoText:SetFont("ixMediumLightFont")
		OwnerInfoText:SetContentAlignment(6)

		local ButtonsBG = vgui.Create( "DPanel", panelBG )
		ButtonsBG:Dock(TOP)
		ButtonsBG:DockMargin(10,5,10,0)
		ButtonsBG:SetTall(55)
		ButtonsBG.Paint = function(s,w,h)
		end

		local CollectInfo = vgui.Create( "DPanel", ButtonsBG )
		CollectInfo:Dock(LEFT)
		CollectInfo:SetWide(self:GetWide()/2 - 40)
		CollectInfo.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64, 255)
		    surface.DrawRect(0,0, w, h)

		    draw.SimpleText( "8", "ixIconsBig", 5, 5, Color( 240,240,240 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		    
		end

		local CollectInfoText = vgui.Create( "ixLabel", CollectInfo )
		CollectInfoText:Dock(FILL)
		CollectInfoText:DockMargin(60,0,5,0)
		CollectInfoText:SetText( "Earned: "..ix.currency.Get(v.rentcollect))
		CollectInfoText:SetFont("ixMediumLightFont")
		CollectInfoText:SetContentAlignment(6)


		local SellButton = vgui.Create( "ixMenuButton", ButtonsBG )
		SellButton:Dock(RIGHT)
		SellButton:SetContentAlignment(6)
		SellButton:SetWide(self:GetWide()/2 - 40)
		SellButton:SetFont("ix3D2DMediumFont_Smaller")
		SellButton:SetText("Sell Property")
		SellButton.DoClick = function(pnl)
	        netstream.Start("ixPropeties_Sell", v.name)
	        self:DataUpdate()
	    end
	
	    local ExtraInfoBG = vgui.Create( "DPanel", panelBG )
		ExtraInfoBG:Dock(TOP)
		ExtraInfoBG:DockMargin(10,5,10,0)
		ExtraInfoBG:SetTall(55)
		ExtraInfoBG.Paint = function(s,w,h)
		end

		local ViewButton = vgui.Create( "ixMenuButton", ExtraInfoBG )
		ViewButton:Dock(LEFT)
		ViewButton:SetWide(self:GetWide()/2 - 40)
		ViewButton:SetFont("ix3D2DMediumFont_Smaller")
		ViewButton:SetText("View Property")
		ViewButton.DoClick = function(pnl)
	        vgui.Create("ixPropertiesMenu_preview"):SetImage(v.preview)
	    end


		local CollectButton = vgui.Create( "ixMenuButton", ExtraInfoBG )
		CollectButton:Dock(RIGHT)
		CollectButton:SetContentAlignment(6)
		CollectButton:SetWide(self:GetWide()/2 - 40)
		CollectButton:SetFont("ix3D2DMediumFont_Smaller")
		CollectButton:SetText("Collect Money")
		CollectButton.DoClick = function(pnl)
			if (v.rentcollect > 0) then
		        netstream.Start("ixPropeties_Collect", v.name)
		        self:DataUpdate(true)
		    end
	    end

		local ExtraButtonsBG = vgui.Create( "DPanel", panelBG )
		ExtraButtonsBG:Dock(TOP)
		ExtraButtonsBG:DockMargin(10,5,10,0)
		ExtraButtonsBG:SetTall(55)
		ExtraButtonsBG.Paint = function(s,w,h)
		end

		local SetRent = vgui.Create( "ixMenuButton", ExtraButtonsBG )
		SetRent:Dock(LEFT)
		SetRent:SetWide(self:GetWide()/2 - 40)
		SetRent:SetFont("ix3D2DMediumFont_Smaller")
		SetRent:SetText( (v.rent_status and "Make unrentable") or "Make rentable")
		SetRent.DoClick = function(s)
			netstream.Start("ixPropeties_MakeRentable", v.name, !v.rent_status)
			self:DataUpdate(true) 
		end

		local RentPriceB = vgui.Create( "ixMenuButton", ExtraButtonsBG )
		RentPriceB:Dock(RIGHT)
		RentPriceB:SetContentAlignment(6)
		RentPriceB:SetWide(self:GetWide()/2 - 40)
		RentPriceB:SetFont("ix3D2DMediumFont_Smaller")
		RentPriceB:SetText("Set rent price")
		RentPriceB:SetEnabled(v.rent_status)
		RentPriceB.DoClick = function(pnl)
	        local rentMenu = vgui.Create("ixPropertiesMenu_rent_price")
			rentMenu:SetParent(self)
			rentMenu.sName = v.name
	    end

	end

end

function PANEL:DataUpdate(noAnim)

	local noAnim = noAnim or false

	PLUGIN:RequestData(function(data)
		if (self) and (IsValid(self)) then
			self.Properties = data
		end
	end)

	if (noAnim) then
		timer.Simple(0.1, function()
			self:RenderProperties(self.ActiveCategory,noAnim)
		end)
	else
		self:RenderProperties(self.ActiveCategory)
	end

end


vgui.Register("ixPropertiesMenu", PANEL, "DFrame")



-- PLUGIN:RequestData(function(data)
--     frame = vgui.Create("ixPropertiesMenu")
--     -- print("===")
--     -- PrintTable(data)
--     frame.Properties = data
--     -- frame:RenderBuyTab()
--     -- for k,v in ipairs(data) do
--     --     frame.AllHouses:AddProperty(v)
--     -- end
-- end)

-- vgui.Create("ixPropertiesMenu")