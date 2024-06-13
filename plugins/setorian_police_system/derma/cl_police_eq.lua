

-- local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_police_system") or false
local PLUGIN = PLUGIN
local monitorTexture = Material("setorian_police/monitor.png", "noclamp smooth" )
local lapdlogo = Material("setorian_police/lapd-logo.png", "noclamp smooth" )

local gradient = Material("vgui/gradient-d")

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(ScrW(),ScrH())
	self:Center()
	self:MakePopup()
	
	self:SetAlpha(0)

	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self:DockPadding(ScreenScale(100),ScreenScale(50),ScreenScale(100),20)

	self.Paint = function(s,w,h) 
		ix.util.DrawBlur(s)

	end

	local TitlePanel = vgui.Create( "DLabel", self )
	TitlePanel:Dock(TOP)
	TitlePanel:SetFont("ixTitleFont")
	TitlePanel:SetText( "Locker: Your Name Police Departament" )
	TitlePanel:SetContentAlignment(5)
	TitlePanel:SizeToContents()

	local DataScroll = vgui.Create( "DScrollPanel", self )
	DataScroll:Dock( FILL )
	DataScroll:DockMargin(0,10,0,10)
	DataScroll.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.DataScroll = DataScroll

	local UpdateButton = vgui.Create( "ixMenuButton", self )
	UpdateButton:Dock(BOTTOM)
	UpdateButton:DockMargin(0,10,0,0)
	UpdateButton:SetFont("ix3D2DMediumFont")
	UpdateButton:SetContentAlignment(5)
	UpdateButton:SetTall(70)
	UpdateButton:SetText( "EQUIPMENT" )
	UpdateButton:SetZPos(3)
	UpdateButton.DoClick = function()

		self:RenderItems(false)

	end

	local ReturnCarButton = vgui.Create( "ixMenuButton", self )
	ReturnCarButton:Dock(BOTTOM)
	ReturnCarButton:DockMargin(0,10,0,0)
	ReturnCarButton:SetFont("ix3D2DMediumFont")
	ReturnCarButton:SetContentAlignment(5)
	ReturnCarButton:SetTall(70)
	ReturnCarButton:SetText( "AMMUNITION" )
	ReturnCarButton:SetZPos(2)
	ReturnCarButton.DoClick = function()

		self:RenderItems(true)

	end

	local CloseButton = vgui.Create( "ixMenuButton", self )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(0,10,0,0)
	CloseButton:SetFont("ix3D2DMediumFont")
	CloseButton:SetContentAlignment(5)
	CloseButton:SetTall(70)
	CloseButton:SetText( "CLOSE" )
	CloseButton:SetZPos(1)
	CloseButton.DoClick = function()

		self:AlphaTo(0, 0.3, 0, function() self:Close() end)
	end

	-- self:RenderCars()
	self:AlphaTo(255, 0.5)

	local TipText = vgui.Create( "DLabel", self.DataScroll )
	TipText:Dock(TOP)
	TipText:DockMargin(0,10,0,0)
	TipText:SetFont("ixSubTitleFont")
	TipText:SetText( "Please select a category below" )
	TipText:SetContentAlignment(5)
	TipText:SizeToContents()

	self.TipText = TipText

	ix.gui.PoliceEQUI = self

end

function PANEL:OnClose()
	ix.gui.PoliceEQUI = nil
end


function PANEL:RenderItems(isAmmo)

	self.DataScroll:Clear()

	if (!IsValid(self.TipText)) then
		self.TipText:Remove()
	end

	self.Prices = {}

	for k, v in ipairs(PLUGIN.PoliceEQVendor) do

		if (!v.IsAmmo) then v.IsAmmo = false end
		if (isAmmo != v.IsAmmo) then continue end

		if (v.Jobs) then
			if (!v.Jobs[LocalPlayer():GetCharacter():GetFaction()]) then continue end
		end

		local itemData = ix.item.list[v.AItem]

		if (!itemData) then continue end

		local model = itemData.model
		local name = itemData.name
		local desc = itemData.description

		local ProfilePanel = vgui.Create( "Panel", self.DataScroll )
		ProfilePanel:Dock(TOP)
		ProfilePanel:DockMargin(0,0,0,10)
		ProfilePanel:DockPadding(10,10,10,10)
		ProfilePanel:SetTall(150)
		ProfilePanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local BGPanel = vgui.Create("DPanel", ProfilePanel)
		BGPanel:Dock(LEFT)
		BGPanel:DockMargin(0,0,0,40)
		BGPanel:DockPadding(3,3,3,3)
		BGPanel:SetWide(100)
		BGPanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end
		
		local RPTItemModel = vgui.Create( "SpawnIcon", BGPanel )
        RPTItemModel:Dock(FILL)
        RPTItemModel:DockMargin(2,2,2,2)
        RPTItemModel:SetModel( model or "models/error.mdl" )
        RPTItemModel:SetTooltip(false)
        RPTItemModel:SetMouseInputEnabled(false)
        function RPTItemModel:LayoutEntity( ent ) 
        end
        RPTItemModel.PaintOver = function(s)
        end

        local ItemName = vgui.Create( "DLabel", ProfilePanel )
		ItemName:Dock(TOP)
		ItemName:DockMargin(10,10,0,0)
		ItemName:SetFont("ixMediumFont")
		ItemName:SetText( name )
		ItemName:SetContentAlignment(4)
		ItemName:SizeToContents()

		local itemPrice = v.APrice

		local ItemPrice = vgui.Create( "DLabel", ProfilePanel )
		ItemPrice:Dock(TOP)
		ItemPrice:DockMargin(10,5,0,0)
		ItemPrice:SetFont("ixGenericFont")
		ItemPrice.iPrice = itemPrice
		ItemPrice:SetTextColor( (LocalPlayer():GetCharacter() and LocalPlayer():GetCharacter():GetMoney() >= itemPrice and Color(120,240,120)) or Color(255,120,120) )
		ItemPrice:SetText( ix.currency.Get(itemPrice) )
		ItemPrice:SetContentAlignment(4)
		ItemPrice:SizeToContents()

		self.Prices[#self.Prices + 1] = ItemPrice

		local ItemDesc = vgui.Create( "DLabel", ProfilePanel )
		ItemDesc:Dock(FILL)
		ItemDesc:DockMargin(10,5,0,0)
		ItemDesc:SetFont("ixGenericFont")
		ItemDesc:SetText( desc )
		ItemDesc:SetContentAlignment(7)
		ItemDesc:SizeToContents()

		local BuyItem = vgui.Create( "ixMenuButton", ProfilePanel )
		-- BuyItem:Dock(BOTTOM)
		-- BuyItem:DockMargin(10,10,0,0)
		BuyItem:SetSize(100, 40)
		BuyItem:SetPos(10,105)
		BuyItem:SetFont("ixSmallFont")
		BuyItem:SetContentAlignment(5)
		-- BuyItem:SetTall(30)
		BuyItem:SetText( L("buy") )
		BuyItem.DoClick = function()

			net.Start("ixPoliceSys_BuyExtraItem")
				net.WriteUInt(k,8)
			net.SendToServer()

			timer.Simple(0.2, function()
				if (!self) or (!IsValid(self)) then return end
				self:CheckPrices()
			end)

		end


	end

end

function PANEL:CheckPrices()

	for k, v in ipairs(self.Prices) do
		v:SetTextColor( (LocalPlayer():GetCharacter() and LocalPlayer():GetCharacter():GetMoney() >= v.iPrice and Color(120,240,120)) or Color(255,120,120) )
	end

end

vgui.Register("ixPolice_EQMenu", PANEL, "DFrame")

-- vgui.Create("ixPolice_EQMenu")

