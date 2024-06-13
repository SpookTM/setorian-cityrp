local PLUGIN = PLUGIN
-- local PLUGIN = ix.plugin.Get("setorian_custom_vendor")

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

AccessorFunc(PANEL, "bReadOnly", "ReadOnly", FORCE_BOOL)

local default_icon = Material( "setorian_vendor/lost-items.png", "noclamp smooth")
local mouse_lmb = Material( "gui/lmb.png", "noclamp smooth", "noclamp smooth")
local mouse_rmb = Material( "gui/rmb.png", "noclamp smooth")
local mouse_e = Material( "gui/e.png", "noclamp smooth")

local gridTexture = Material( "gui/noicon.png", "noclamp smooth")

local color_lightWhite = Color(236,240,240)
local color_DarkGrey = Color(20,20,20)
local color_gray = Color(120,130,140)
local color_green = Color(46, 204, 113)

function PANEL:Init()


	-- self:SetSize(970,570)
	self:SetSize(ScrW()*0.3,ScrH()*0.7)
	self:SetPos(ScrW()*0.1, ScrH()*0.5 - self:GetTall()/2)

	-- self:Center()
	self:MakePopup()

	self:SetAlpha(0)
	self.ActualAlpha = 0
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	-- self:DockPadding(10,35,10,10)
	self:DockPadding(5,5,5,5)

	self.Paint = function(s,w,h)

		-- surface.SetDrawColor(47, 53, 66, 150)
	    -- surface.DrawRect(0,0,w,h)

	    -- surface.SetDrawColor(47, 53, 66, 250)
	    -- surface.DrawRect(0,0,w,30)

	    -- surface.SetDrawColor(44, 62, 80, 30)
	    -- surface.DrawRect(5,35,w-10,h-40)

	end

	-- self:AlphaTo(255,0.3)

	self:CreateAnimation(animationTime, {
		index = 1,
		target = {ActualAlpha = 255},
		easing = "outQuint",
		bIgnoreConfig = true,

		Think = function(animation, panel)
			panel:SetAlpha(panel.ActualAlpha)
		end

	})

	local TitlePnl = vgui.Create( "Panel", self )
	TitlePnl:Dock(TOP)
	-- TitlePnl:DockMargin(0,0,3,0)
	TitlePnl:SetTall(self:GetTall()*0.12)
	TitlePnl.Paint = function(s,w,h)
	    
	    draw.RoundedBox(8, 0,0,w,h, color_lightWhite)

	    ix.util.DrawText("Wallet", w-115,h-12, color_gray, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

	    -- draw.RoundedBox(8, w-25,0,50,20, color_DarkGrey)

	    -- surface.SetDrawColor(20,20,20)
	    -- surface.DrawRect(0,0,40,50)

	end

	local TitlePnl_Text = vgui.Create( "DLabel", TitlePnl )
	TitlePnl_Text:Dock(FILL)
	TitlePnl_Text:DockMargin(5,5,5,5)
	TitlePnl_Text:SetText("")
	TitlePnl_Text:SetFont("ixMediumFont")
	TitlePnl_Text:SetMultiline(true)
	TitlePnl_Text:SetContentAlignment(7)
	TitlePnl_Text:SetTextColor(color_DarkGrey)

	self.title = TitlePnl_Text

	local WalletPnl = vgui.Create( "DPanel", TitlePnl )
	WalletPnl:SetSize(100,30)
	WalletPnl:SetPos(self:GetWide()-120,TitlePnl:GetTall()-38)
	WalletPnl.Paint = function(s,w,h)
		-- clipping_handler.clip:Scissor2D(w,h)
		draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
		ix.util.DrawText(ix.currency.Get(LocalPlayer():GetCharacter():GetMoney()), 5, 5, color_lightWhite)
		-- clipping_handler.clip()
	end

	local BottomTips = vgui.Create( "Panel", self )
	BottomTips:Dock(BOTTOM)
	BottomTips:DockMargin(0,5,0,0)
	BottomTips:SetTall(35)
	BottomTips:SetZPos(1)
	-- BottomTips.Paint = function(s,w,h)
	--     surface.SetDrawColor(236,240,240)
	--     surface.DrawRect(0,0,w,h)
   	-- end

   	self.BottomTips = BottomTips

   	BottomTips.MouseLMB  = vgui.Create( "DLabel", BottomTips )
   	BottomTips.MouseLMB:Dock(LEFT)
   	BottomTips.MouseLMB:SetWide(self:GetWide()*0.33)
   	BottomTips.MouseLMB:SetText("SELECT")
   	BottomTips.MouseLMB:SetFont("ixGenericFont")
   	BottomTips.MouseLMB:SetContentAlignment(5)
   	BottomTips.MouseLMB.Paint = function(s,w,h)
	    draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
	    surface.SetDrawColor( color_white )
		surface.SetMaterial(mouse_lmb)
		surface.DrawTexturedRect(5,5,24,24)
   	end

   	BottomTips.MouseRMB  = vgui.Create( "DLabel", BottomTips )
   	BottomTips.MouseRMB:Dock(FILL)
   	BottomTips.MouseRMB:DockMargin(5,0,5,0)
   	-- BottomTips.MouseRMB:SetWide(self:GetWide()*0.31)
   	BottomTips.MouseRMB:SetText("")
   	BottomTips.MouseRMB:SetFont("ixGenericFont")
   	BottomTips.MouseRMB:SetContentAlignment(5)
   	BottomTips.MouseRMB.Paint = function(s,w,h)
	    draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
	    surface.SetDrawColor( color_white )
		surface.SetMaterial(mouse_rmb)
		surface.DrawTexturedRect(5,5,24,24)
   	end

   	BottomTips.EKEY  = vgui.Create( "DLabel", BottomTips )
   	BottomTips.EKEY:Dock(RIGHT)
   	BottomTips.EKEY:SetWide(self:GetWide()*0.33)
   	BottomTips.EKEY:SetText("CLOSE")
   	BottomTips.EKEY:SetFont("ixGenericFont")
   	BottomTips.EKEY:SetContentAlignment(5)
   	BottomTips.EKEY.Paint = function(s,w,h)
	    draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
	    surface.SetDrawColor( color_white )
		surface.SetMaterial(mouse_e)
		surface.DrawTexturedRect(5,5,24,24)
   	end

   	self.BottomTips = BottomTips

   	local BottomTipsIcons = vgui.Create( "Panel", self )
	BottomTipsIcons:Dock(BOTTOM)
	BottomTipsIcons:DockMargin(0,5,0,0)
	-- BottomTipsIcons:DockPadding(5,0,5,0)
	BottomTipsIcons:SetTall(30)
	BottomTipsIcons:SetZPos(2)

	BottomTipsIcons.BUYBG  = vgui.Create( "DPanel", BottomTipsIcons )
   	BottomTipsIcons.BUYBG:Dock(LEFT)
   	BottomTipsIcons.BUYBG:DockPadding(5,0,5,0)
   	BottomTipsIcons.BUYBG:SetWide(200)
   	BottomTipsIcons.BUYBG.Paint = function(s,w,h)
	    draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
	end

   	BottomTipsIcons.BUYICON  = vgui.Create( "DLabel", BottomTipsIcons.BUYBG )
   	-- BottomTipsIcons.BUYICON:Dock(LEFT)
   	-- BottomTipsIcons.BUYICON:DockMargin(0,0,3,0)
   	BottomTipsIcons.BUYICON:SetPos(5,0)
   	BottomTipsIcons.BUYICON:SetText("^")
   	BottomTipsIcons.BUYICON:SetFont("ixSmallTitleIcons")
   	BottomTipsIcons.BUYICON:SetContentAlignment(5)
   	BottomTipsIcons.BUYICON:SizeToContents()

	BottomTipsIcons.BUYTEXT  = vgui.Create( "DLabel", BottomTipsIcons.BUYBG )
   	BottomTipsIcons.BUYTEXT:Dock(FILL)
   	BottomTipsIcons.BUYTEXT:SetText("PURCHASABLE")
   	BottomTipsIcons.BUYTEXT:SetFont("ixGenericFont")
   	BottomTipsIcons.BUYTEXT:SetContentAlignment(5)
   	BottomTipsIcons.BUYTEXT:SizeToContents()

   	BottomTipsIcons.SELLBG  = vgui.Create( "DPanel", BottomTipsIcons )
   	BottomTipsIcons.SELLBG:Dock(RIGHT)
   	BottomTipsIcons.SELLBG:DockPadding(5,0,5,0)
   	BottomTipsIcons.SELLBG:SetWide(200)
   	BottomTipsIcons.SELLBG.Paint = function(s,w,h)
	    draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
	end

   	BottomTipsIcons.SELLICON  = vgui.Create( "DLabel", BottomTipsIcons.SELLBG )
   	-- BottomTipsIcons.SELLICON:Dock(RIGHT)
   	-- BottomTipsIcons.SELLICON:DockMargin(5,0,0,0)
   	BottomTipsIcons.SELLICON:SetPos(BottomTipsIcons.SELLBG:GetWide()-25,0)
   	BottomTipsIcons.SELLICON:SetText("8")
   	BottomTipsIcons.SELLICON:SetFont("ixSmallTitleIcons")
   	BottomTipsIcons.SELLICON:SetContentAlignment(5)
   	BottomTipsIcons.SELLICON:SizeToContents()

	BottomTipsIcons.SELLTEXT  = vgui.Create( "DLabel", BottomTipsIcons.SELLBG )
   	BottomTipsIcons.SELLTEXT:Dock(FILL)
   	BottomTipsIcons.SELLTEXT:SetText("SELLABLE")
   	BottomTipsIcons.SELLTEXT:SetFont("ixGenericFont")
   	BottomTipsIcons.SELLTEXT:SetContentAlignment(5)
   	BottomTipsIcons.SELLTEXT:SizeToContents()
   	

   	local grid = vgui.Create("ThreeGrid", self)
	grid:Dock(FILL)
	grid:DockMargin(4, 10, 3, 4)
	-- grid:DockPadding(0,0,0,0)
	grid:InvalidateParent(true)
	-- grid.PaintOver = function(s,w,h)
	-- 	clipping_handler.clip:Scissor2D(w,h)
	-- --     surface.SetDrawColor(236,240,240)
	-- --     surface.DrawRect(0,0,w,h)
	-- 	clipping_handler.clip()
   	-- end

   	grid.ActualAlpha = 0
	grid:SetColumns(2)
	grid:SetHorizontalMargin(4)
	grid:SetVerticalMargin(4)

	self.grid = grid

	local sbar = grid:GetVBar()
	sbar:DockPadding(0,0,0,0)
	sbar:SetWide(5)

	local function sign( num )
		return num > 0
	end
	
	local function getBiggerPos( signOld, signNew, old, new )
		if signOld != signNew then return new end
		if signNew then
			return math.max(old, new)
		else
			return math.min(old, new)
		end
	end

	local tScroll = 0
	local newerT = 0

	function sbar:AddScroll( dlta )
	
		self.Old_Pos = nil
		self.Old_Sign = nil

		local OldScroll = self:GetScroll()

		dlta = dlta * 30
		
		local anim = self:NewAnimation( 0.5, 0, 0.25 )
		anim.StartPos = OldScroll
		anim.TargetPos = OldScroll + dlta + tScroll
		tScroll = tScroll + dlta

		local ctime = RealTime() -- does not work correctly with CurTime, when in single player game and in game menu (then CurTime get stuck). I think RealTime is better.
		local doing_scroll = true
		newerT = ctime
		
		anim.Think = function( anim, pnl, fraction )
			local nowpos = Lerp( fraction, anim.StartPos, anim.TargetPos )
			if ctime == newerT then
				self:SetScroll( getBiggerPos( self.Old_Sign, sign(dlta), self.Old_Pos, nowpos ) )
				tScroll = tScroll - (tScroll * fraction)
			end
			if doing_scroll then -- it must be here. if not, sometimes scroll get bounce.
				self.Old_Sign = sign(dlta)
				self.Old_Pos = nowpos
			end
			if ctime != newerT then doing_scroll = false end
		end

		return math.Clamp( self:GetScroll() + tScroll, 0, self.CanvasSize ) != self:GetScroll()

	end

	local fakegrid = vgui.Create("ThreeGrid", self)
	fakegrid:Dock(FILL)
	fakegrid:SetZPos(-1)
	fakegrid:DockMargin(4, 10, 3, 4)
	fakegrid:InvalidateParent(true)
	-- grid.PaintOver = function(s,w,h)
	-- 	clipping_handler.clip:Scissor2D(w,h)
	-- --     surface.SetDrawColor(236,240,240)
	-- --     surface.DrawRect(0,0,w,h)
	-- 	clipping_handler.clip()
   	-- end

   	fakegrid.ActualAlpha = 0
	fakegrid:SetColumns(2)
	fakegrid:SetHorizontalMargin(4)
	fakegrid:SetVerticalMargin(4)

	for i=1, 6 do
		local CategoryPanel = fakegrid:Add( "DPanel" )
		-- CategoryPanel:Dock(TOP)
		-- CategoryPanel:DockMargin(0,0,0,10)
		CategoryPanel:DockPadding(5,5,5,10)
		CategoryPanel:SetTall(160)
		CategoryPanel.Paint = function(s,w,h)

		    surface.SetDrawColor( ColorAlpha(color_lightWhite,220 ))
			surface.SetMaterial(gridTexture)
			surface.DrawTexturedRect(0,0,w,h)


		end
		fakegrid:AddCell(CategoryPanel)
	end

	-- for i=1, 10 do
	-- 	local pnl = vgui.Create("DButton")
	-- 	pnl:SetTall(150)
	-- 	pnl:SetText(i)
	-- 	pnl.AnimB = 0
	-- 	pnl.OnCursorEntered = function(s)
	-- 		LocalPlayer():EmitSound("Helix.Whoosh")
	-- 	end
	-- 	pnl.Paint = function(s,w,h)

	-- 		-- local old = DisableClipping( true )

	-- 		if (s:IsHovered()) then
	-- 			s.AnimB = math.Clamp(s.AnimB + 5 * FrameTime(), 0, 1)
	-- 		else
	-- 			s.AnimB = math.Clamp(s.AnimB - 5 * FrameTime(), 0, 1)
	-- 	    end

	-- 		surface.SetDrawColor( color_white )
	-- 		surface.SetMaterial(gridTexture)
	-- 		surface.DrawTexturedRect(0,0,w,h)

	-- 		surface.SetDrawColor(ColorAlpha(color_white, 255 * s.AnimB))
	-- 		surface.DrawOutlinedRect(0,0,w,h)

	-- 		-- DisableClipping( old )

	-- 	end
	-- 	grid:AddCell(pnl)
	-- end

	-- local LeftPanel = vgui.Create( "Panel", self )
	-- LeftPanel:Dock(LEFT)
	-- LeftPanel:SetWide(self:GetWide()*0.35)
	-- LeftPanel:DockPadding(10,10,10,10)
	-- LeftPanel.Paint = function(s,w,h)

	--     surface.SetDrawColor(44, 62, 80, 230)
	--     surface.DrawRect(0,0,w,h)


	-- end

	-- local CategoryList = vgui.Create( "DScrollPanel", LeftPanel )
	-- CategoryList:Dock(FILL)

	-- self.CategoryList = CategoryList

	-- local MidPanel = vgui.Create( "Panel", self )
	-- MidPanel:Dock(FILL)
	-- MidPanel:DockMargin(30,0,0,0)
	-- MidPanel:DockPadding(10,0,10,10)
	-- MidPanel.Paint = function(s,w,h)
	--     surface.SetDrawColor(44, 62, 80, 230)
	--     surface.DrawRect(0,0,w,h)

	-- end

	-- local HeaderPanel = vgui.Create( "Panel", MidPanel )
	-- HeaderPanel:Dock(TOP)
	-- HeaderPanel:DockMargin(0,0,0,10)
	-- HeaderPanel:SetTall(40)

	-- local TotalCost = vgui.Create( "DLabel", HeaderPanel )
	-- TotalCost:Dock(LEFT)
	-- TotalCost:SetFont("ixMediumFont")
	-- TotalCost:SetText( "Total Cost:" )
	-- TotalCost:SizeToContents()
	-- TotalCost:SetContentAlignment(4)

	-- local TotalCost_Value = vgui.Create( "DLabel", HeaderPanel )
	-- TotalCost_Value:Dock(LEFT)
	-- TotalCost_Value:DockMargin(5,0,0,0)
	-- TotalCost_Value:SetFont("ixMediumFont")
	-- TotalCost_Value:SetText( "$0" )
	-- TotalCost_Value:SetTextColor(Color(46, 204, 113))
	-- TotalCost_Value:SizeToContents()
	-- TotalCost_Value:SetContentAlignment(4)

	-- self.TotalCost = TotalCost_Value

	-- local ItemsInCart = vgui.Create( "DLabel", HeaderPanel )
	-- ItemsInCart:Dock(RIGHT)
	-- ItemsInCart:SetFont("ixMediumFont")
	-- ItemsInCart:SetText( "Items in Cart:" )
	-- ItemsInCart:SizeToContents()
	-- ItemsInCart:SetZPos(2)
	-- ItemsInCart:SetContentAlignment(6)

	-- local ItemsInCart_Value = vgui.Create( "DLabel", HeaderPanel )
	-- ItemsInCart_Value:Dock(RIGHT)
	-- ItemsInCart_Value:DockMargin(5,0,0,0)
	-- ItemsInCart_Value:SetFont("ixMediumFont")
	-- ItemsInCart_Value:SetText( "0" )
	-- ItemsInCart_Value:SizeToContents()
	-- ItemsInCart_Value:SetZPos(1)
	-- ItemsInCart_Value:SetContentAlignment(6)

	-- self.CartAmount = ItemsInCart_Value
	-- self.CartAmountValue = 0

	-- local CartScroll = vgui.Create( "DScrollPanel", MidPanel )
	-- CartScroll:Dock(FILL)

	-- local PurchaseButton = vgui.Create( "DButton", MidPanel )
	-- PurchaseButton:Dock(BOTTOM)
	-- PurchaseButton:DockMargin(80,20,80,0)
	-- PurchaseButton:SetTall(35)
	-- PurchaseButton:SetFont("Trebuchet24")
	-- PurchaseButton:SetText("Purchase")
	-- PurchaseButton.Paint = function(s,w,h)

	-- 	if (s:IsHovered()) then
	-- 		surface.SetDrawColor(39, 174, 96)
	-- 	else
	--     	surface.SetDrawColor(39, 174, 96, 200)
	--     end
	--     surface.DrawRect(0,0,w,h)

	--     surface.SetDrawColor(20,20,20)
	--     surface.DrawOutlinedRect(0,0,w,h,1)

	-- end
	-- PurchaseButton.OnCursorEntered = function(s)
	-- 	surface.PlaySound("helix/ui/rollover.wav")
	-- end
	-- PurchaseButton.DoClick = function(s)

	-- 	if (table.IsEmpty(self.ItemsInCart)) then 
	-- 		LocalPlayer():Notify("The cart is empty")
	-- 		return
	-- 	end

	-- 	surface.PlaySound("helix/ui/press.wav")

	-- 	local paymeth = vgui.Create("ixVendor_ChooseMode")
	-- 	paymeth:SetParent(self)

	-- end

	-- local CartList = CartScroll:Add("DListLayout")
	-- CartList:SetSize(self:GetWide() - self:GetWide()*0.35 - 70)
	-- -- CartList:Dock( FILL )
	-- CartList:DockPadding(0, 0, 0, 4)

	-- self.CartList = CartList


	self.ItemsInCart = {}

	self.VendorCategories = {}
	self.VendorItems = {}

	self.IsClosing = false
	self.overviewFraction = 0
	self.bOverviewOut = false
	self.rotationOffset = Angle(0,-15,0)
	
	self.CategoryItemsRendered = true

end

-- function PANEL:GetOverviewInfo(origin, angles, fov)
-- 	local entity = self.entity
-- 	local originAngles = Angle(0, angles.yaw, angles.roll)
-- 	local target = LocalPlayer():GetObserverTarget()
-- 	local fraction = self.overviewFraction
-- 	local bDrawPlayer = false
-- 	local forward = originAngles:Forward() * 58 - originAngles:Right() * -10
-- 	forward.z = 0

-- 	local newOrigin

-- 	local oldOrigin = origin

-- 	-- if (IsValid(target)) then
-- 		-- newOrigin = target:GetPos() + forward
-- 	-- else
-- 		origin = self.ShopPos + forward + originAngles:Up() * 40
-- 		-- origin = origin - LocalPlayer():OBBCenter() * 0.6 + forward

-- 		if (self.ChangeViewState) then

-- 			local NewData = self.ViewData

-- 			newOrigin = origin + originAngles:Forward() * NewData.VFor - originAngles:Right() * NewData.VRight - originAngles:Up() * NewData.VUp
-- 		else
-- 			newOrigin = origin
-- 		end

-- 	local newAngles = originAngles + self.rotationOffset
-- 	newAngles.pitch = 5
-- 	newAngles.roll = 0


-- 	return LerpVector(fraction, origin, newOrigin),  newAngles , 90, bDrawPlayer
-- end

-- function PANEL:OnMousePressed(key)
-- print(key)
-- 	if (self.CategoryItemsRendered) then

-- 		if (key == MOUSE_RIGHT) then
-- 			self:RenderCategories()
-- 		end

-- 	end
-- 	return true
-- end

function PANEL:OnKeyCodePressed(key)

	if (key == KEY_E or key == KEY_TAB) and (!self.IsClosing) then
		
		self:CharAnimation(true)
	end
end

function PANEL:CharAnimation(bClose)

	local length = animationTime or 1

	if (bClose) then

		self.IsClosing = true

		self:SetMouseInputEnabled(false)
		self:SetKeyBoardInputEnabled(false)

		self:CreateAnimation(animationTime, {
			index = 1,
			target = {ActualAlpha = 0},
			easing = "outQuint",
			bIgnoreConfig = true,

			Think = function(animation, panel)
				panel:SetAlpha(panel.ActualAlpha)
			end

		})

		self:CreateAnimation(length, {
			index = 3,
			target = {overviewFraction = 0},
			easing = "outQuint",
			bIgnoreConfig = true,

			OnComplete = function(animation, panel)

				panel:Remove()

				net.Start("ixVendorClose")
				net.SendToServer()

				if (IsValid(ix.gui.vendorEditor)) then
					ix.gui.vendorEditor:Remove()
				end
			end

		})


	else
		self:CreateAnimation(length, {
			index = 3,
			target = {overviewFraction = 1},
			easing = "outQuint",
			bIgnoreConfig = true
		})

		self.bOverviewOut = false
		self.bCharacterOverview = true
	end

end

function PANEL:GetOverviewInfo(origin, angles, fov)
	local originAngles = Angle(0, angles.yaw, angles.roll)
	local target = LocalPlayer():GetObserverTarget()
	local fraction = self.overviewFraction
	local bDrawPlayer = ((fraction > 0.2) or (!self.bOverviewOut and (fraction > 0.2))) and !IsValid(target)
	local forward = originAngles:Forward() * -12 - originAngles:Right() * 20 + originAngles:Up() * 18
	-- forward.z = 0

	local newOrigin

	if (IsValid(target)) then
		newOrigin = target:GetPos() + forward
	else
		newOrigin = origin - LocalPlayer():OBBCenter() * 0.6 + forward
	end

	local newAngles = originAngles + self.rotationOffset
	newAngles.pitch = 10
	newAngles.roll = 0

	return LerpVector(fraction, origin, newOrigin), LerpAngle(fraction, angles, newAngles), Lerp(fraction, fov, 90), bDrawPlayer
end

function PANEL:AnimationTransition(pnl, OpenCategoryItems, CategoryID)

	if (pnl.IsAnimated) then return end

	pnl.ActualAlpha = 255
	pnl.IsAnimated = true

	local length = animationTime or 1

	pnl:CreateAnimation(length * 0.2, {
		index = 1,
		target = {ActualAlpha = 0},
		easing = "outQuint",
		bIgnoreConfig = true,

		Think = function(animation, panel)
			panel:SetAlpha(panel.ActualAlpha)
		end,

		OnComplete = function(animation, panel)

			-- func()
			if (OpenCategoryItems) then
				self:RenderCategoryItems(CategoryID)
			else
				self:RenderCategories()
			end

			panel:CreateAnimation(length * 0.2, {
				index = 2,
				target = {ActualAlpha = 255},
				easing = "inQuint",
				bIgnoreConfig = true,
				Think = function(animation, panel)
					panel:SetAlpha(panel.ActualAlpha)
				end,
				OnComplete = function(animation, panel)
					panel.IsAnimated = false
				end
			})

		end

	})

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

	-- self.CategoryList:Clear()
	self.grid:Clear()

	self.BottomTips.MouseLMB:SetText("SELECT")
	self.BottomTips.MouseRMB:SetText( (self.entity:GetCanBeRob() and "THREAT") or "")
	self.BottomTips.EKEY:SetText("CLOSE")

	self.CategoryItemsRendered = false

	for k, v in pairs(self.VendorCategories) do

		local CategoryPanel = self.grid:Add( "DButton" )
		-- CategoryPanel:Dock(TOP)
		-- CategoryPanel:DockMargin(0,0,0,10)
		CategoryPanel:DockPadding(5,5,5,10)
		CategoryPanel:SetTall(160)
		CategoryPanel:SetText("")
		CategoryPanel.AnimB = 0
		CategoryPanel.CategoryID = k
		CategoryPanel.Paint = function(s,w,h)

			-- if (s:IsHovered()) then
			-- 	surface.SetDrawColor(52, 58, 71)
			-- else
		    -- 	surface.SetDrawColor(47, 53, 66, 230)
		    -- end
		    -- surface.DrawRect(0,0,w,h)

		    if (s:IsHovered()) then
				s.AnimB = math.Clamp(s.AnimB + 5 * FrameTime(), 0, 1)
			else
				s.AnimB = math.Clamp(s.AnimB - 5 * FrameTime(), 0, 1)
		    end

		    surface.SetDrawColor( ColorAlpha(color_lightWhite , (255 * s.AnimB)) )
			surface.SetMaterial(gridTexture)
			surface.DrawTexturedRect(0,0,w,h)

		    surface.SetDrawColor(ColorAlpha(color_white, 255 * s.AnimB))
			surface.DrawOutlinedRect(0,0,w,h)

		end
		CategoryPanel.OnCursorEntered = function(s)
			-- surface.PlaySound("helix/ui/rollover.wav")
			LocalPlayer():EmitSound("Helix.Whoosh")
		end
		CategoryPanel.DoClick = function(s)

			-- self:RenderCategoryItems(s.CategoryID)

			self:AnimationTransition(self.grid, true, s.CategoryID)

		end

		self.grid:AddCell(CategoryPanel)

		local IconMat = default_icon

		if (PLUGIN.CategoryIcons[k]) then
			IconMat = Material( PLUGIN.CategoryIcons[k], "noclamp smooth")
		end

		local CategoryLogo = vgui.Create("DImage", CategoryPanel)
		CategoryLogo:Dock(FILL)
		CategoryLogo:DockMargin(70,10,70,5)
		CategoryLogo:SetWide(CategoryPanel:GetTall()-20)
		CategoryLogo:SetMaterial(IconMat)

		local CategoryTitle = vgui.Create( "DLabel", CategoryPanel )
		CategoryTitle:Dock(BOTTOM)
		-- CategoryTitle:DockMargin(0,0,0,5)
		CategoryTitle:SetFont("ixMediumFont")
		CategoryTitle:SetText( k )
		CategoryTitle:SizeToContents()
		CategoryTitle:SetContentAlignment(5)

	end

	-- local CategoriesCount = table.Count(self.VendorCategories)
	-- local fakeButtonsCount = 6 - CategoriesCount

	-- if (fakeButtonsCount > 0) then
	-- 	for i=1, fakeButtonsCount do
	-- 		local CategoryPanel = self.grid:Add( "DPanel" )
	-- 		-- CategoryPanel:Dock(TOP)
	-- 		-- CategoryPanel:DockMargin(0,0,0,10)
	-- 		CategoryPanel:DockPadding(5,5,5,10)
	-- 		CategoryPanel:SetTall(160)
	-- 		CategoryPanel.Paint = function(s,w,h)

	-- 		    surface.SetDrawColor( ColorAlpha(color_lightWhite,220 ))
	-- 			surface.SetMaterial(gridTexture)
	-- 			surface.DrawTexturedRect(0,0,w,h)


	-- 		end
	-- 		self.grid:AddCell(CategoryPanel)
	-- 	end
	-- end

end

function PANEL:RenderCategoryItems(SCategory)

	-- self.CategoryList:Clear()
	self.grid:Clear()

	self.CategoryItemsRendered = true
	self.HoverOnItem = false

	self.BottomTips.MouseRMB:SetText("BACK")

	-- surface.PlaySound("helix/ui/press.wav")

	-- local ReturnPanel = self.grid:Add( "DButton" )
	-- ReturnPanel:Dock(TOP)
	-- ReturnPanel:DockMargin(0,0,0,10)
	-- ReturnPanel:SetTall(70)
	-- ReturnPanel:SetText("")
	-- ReturnPanel.Paint = function(s,w,h)

	-- 	if (s:IsHovered()) then
	-- 		surface.SetDrawColor(52, 58, 71)
	-- 	else
	--     	surface.SetDrawColor(47, 53, 66, 230)
	--     end
	--     surface.DrawRect(0,0,w,h)

	-- end
	-- ReturnPanel.OnCursorEntered = function(s)
	-- 	surface.PlaySound("helix/ui/rollover.wav")
	-- end
	-- ReturnPanel.DoClick = function(s)
	-- 	self:RenderCategories()
	-- end



	-- local ReturnIamge = vgui.Create( "DLabel", ReturnPanel )
	-- ReturnIamge:Dock(LEFT)
	-- ReturnIamge:DockMargin(20,10,25,10)
	-- ReturnIamge:SetFont("ixIconsBig")
	-- ReturnIamge:SetText( "s" )
	-- ReturnIamge:SizeToContents()
	-- ReturnIamge:SetContentAlignment(4)

	-- local ReturnTitle = vgui.Create( "DLabel", ReturnPanel )
	-- ReturnTitle:Dock(LEFT)
	-- ReturnTitle:SetFont("ixMediumFont")
	-- ReturnTitle:SetText( "Return" )
	-- ReturnTitle:SizeToContents()
	-- ReturnTitle:SetContentAlignment(4)


	for k, v in pairs(self.VendorItems) do

		if (v.category != SCategory) then continue end

		local items = self.entity.items
		local data = items[k]
		local stocks = self.entity:GetStock(k)

		local CanBuy = data[VENDOR_MODE] == VENDOR_BUYONLY
		local CanSell = data[VENDOR_MODE] == VENDOR_SELLONLY
		local BothMode = data[VENDOR_MODE] == VENDOR_SELLANDBUY

		local ItemPanel = self.grid:Add( "DButton" )
		-- ItemPanel:Dock(TOP)
		-- ItemPanel:DockMargin(0,0,0,10)
		ItemPanel:DockPadding(5,5,5,5)
		ItemPanel:SetTall(160)
		ItemPanel:SetText("")
		ItemPanel.AnimB = 0
		-- ItemPanel:SetTooltip(v.desc)
		ItemPanel:SetHelixTooltip(function(tooltip)
			local title = tooltip:AddRow("name")
			title:SetImportant()
			title:SetText(v.name)
			title:SizeToContents()
			title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

			local description = tooltip:AddRow("description")
			description:SetText(v.desc)
			description:SizeToContents()
		end)
		ItemPanel.Paint = function(s,w,h)

			-- surface.SetDrawColor(color_lightWhite)
		    -- surface.DrawRect(0,0,w,h)


		    if (s:IsHovered()) then
				s.AnimB = math.Clamp(s.AnimB + 5 * FrameTime(), 0, 1)
			else
				s.AnimB = math.Clamp(s.AnimB - 5 * FrameTime(), 0, 1)
		    end

		    -- surface.SetDrawColor(ColorAlpha(color_DarkGrey, 255 * s.AnimB))
			-- surface.DrawOutlinedRect(0,0,w,h)

			-- draw.RoundedBox(4, 0,0,w,h, ColorAlpha(color_DarkGrey, 255 * s.AnimB))

			draw.RoundedBox(4, 0,0,w,h, ColorAlpha(color_lightWhite , 200 +  (55 * s.AnimB)))

		    -- draw.RoundedBox(8, w-105,h-35, 100, 30, color_DarkGrey)

		end
		ItemPanel.PaintOver = function(s,w,h)

		-- 	draw.RoundedBox(8, w-105,h-35, 100, 30, color_DarkGrey)
			if (BothMode) or (CanSell) then
				draw.SimpleText("^", "ixSmallTitleIcons", w-5, 5, color_green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end
			if (BothMode) or (CanBuy) then
				draw.SimpleText("8", "ixSmallTitleIcons", w-8, (BothMode and 35) or 5, color_green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end
			-- ix.util.DrawText("^", w-5, 5, color_green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, "ixSmallTitleIcons")
		end

		self.grid:AddCell(ItemPanel)
		ItemPanel.OnCursorEntered = function(s)
			LocalPlayer():EmitSound("Helix.Whoosh")
			self.BottomTips.MouseLMB:SetText("BUY")
			self.BottomTips.MouseRMB:SetText("SELL")
			self.HoverOnItem = true
		end
		ItemPanel.OnCursorExited = function(s)
			self.BottomTips.MouseLMB:SetText("SELECT")
			self.BottomTips.MouseRMB:SetText("BACK")
			self.HoverOnItem = false
		end
		ItemPanel.DoClick = function(s)

			if (self:GetReadOnly()) then
				LocalPlayer():Notify("You are in edit mode")
				return
			end
			-- print("buyed")

			if (CanSell or BothMode) then

				local paymeth = vgui.Create("ixVendor_ChooseMode")
				paymeth:SetParent(self)

				self.SelectedBuyItem = k

				-- net.Start("ixVendorTrade")
				-- 	net.WriteString(k)
				-- 	net.WriteBool(false)
				-- net.SendToServer()
			end

		end
		ItemPanel.DoRightClick = function(s)

			if (self:GetReadOnly()) then
				LocalPlayer():Notify("You are in edit mode")
				return
			end

			if (CanBuy or BothMode) then
				net.Start("ixVendorTrade")
					net.WriteString(k)
					net.WriteBool(true)
				net.SendToServer()
			end
		end

		-- 	local Menu = DermaMenu()

		-- 	if (CanSell or BothMode) then

		-- 		local stock = stocks or 5

		-- 		local purshaseButtonChild, purshaseButton = Menu:AddSubMenu( "Add to cart")
		-- 		purshaseButton:SetIcon( "icon16/cart.png" )	

		-- 		if (stock > 0) then

		-- 			for i=1, math.min(stock, 5) do
		-- 				local AddCart = purshaseButtonChild:AddOption( "Add x"..i, function() 

		-- 					self:AddToCart(k, v.price, i)

		-- 					self:RenderCategoryItems(SCategory)

		-- 				end)
		-- 				AddCart:SetIcon( "icon16/cart_add.png" )	
		-- 			end

		-- 		else
		-- 			local outstock = purshaseButtonChild:AddOption( "Out of Stock" )
		-- 			outstock:SetIcon( "icon16/cancel.png" )

		-- 		end

		-- 	end


		-- 	if (CanBuy or BothMode) then

		-- 		local itemCount = LocalPlayer():GetCharacter():GetInventory():GetItemCount(k)

		-- 		local sellButtonChild, sellButton = Menu:AddSubMenu( "Sell item")
		-- 		sellButton:SetIcon( "icon16/money_dollar.png" )	

		-- 		if (itemCount > 0) then

		-- 			for i=1, math.min(itemCount, 5) do
		-- 				local SellItem = sellButtonChild:AddOption( "Sell x"..i, function() 

		-- 					net.Start("ixVendorTrade_Extd_Sell")
		-- 						net.WriteUInt( i, 6 )
		-- 						net.WriteString(k)
		-- 					net.SendToServer()

		-- 					self:RenderCategoryItems(SCategory)

		-- 				end)
		-- 				SellItem:SetIcon( "icon16/money_add.png" )	
		-- 			end

		-- 		else
		-- 			local notItem = sellButtonChild:AddOption( "You don't have this item" )
		-- 			notItem:SetIcon( "icon16/cancel.png" )
		-- 		end

		-- 	end
			
		-- 	Menu:Open()

		-- end

		local ItemImage = vgui.Create("SpawnIcon", ItemPanel)
		-- ItemImage:Dock(FILL)
		-- ItemImage:DockMargin(50,10,50,10)
		ItemImage:SetSize(ItemPanel:GetTall(),ItemPanel:GetTall() - 10)
		ItemImage:SetPos(self:GetWide()*0.24 - ItemImage:GetWide()/2,5 + ItemImage:GetTall()/2-ItemPanel:GetTall()/2)
		-- ItemImage:SetWide(ItemPanel:GetTall()-20)	
		ItemImage:SetModel( v.model )
		ItemImage:SetTooltip(false)
		ItemImage:SetMouseInputEnabled(false)

		local ItemTitle = vgui.Create( "DLabel", ItemPanel )
		ItemTitle:SetPos(5,5)
		ItemTitle:SetFont("ixMediumFont")
		ItemTitle:SetText( v.name )
		ItemTitle:SetTextColor(color_DarkGrey)
		ItemTitle:SizeToContents()
		ItemTitle:SetContentAlignment(7)

		local ItemPriceBG = vgui.Create( "DPanel", ItemPanel )
		ItemPriceBG:SetPos(ItemPanel:GetWide()-105,ItemPanel:GetTall()-35)
		ItemPriceBG:SetSize(100,30)
		ItemPriceBG.Paint = function(s,w,h)
			draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
		end

		local ItemPrice = vgui.Create( "DLabel", ItemPriceBG )
		ItemPrice:Dock(FILL)
		ItemPrice:SetFont("ixMediumFont")
		ItemPrice:SetTextColor(Color(46, 204, 113))
		ItemPrice:SetText( "$"..v.price )
		ItemPrice:SizeToContents()
		ItemPrice:SetContentAlignment(5)
		ItemPrice.NextUpdate = CurTime() + 0.1
		ItemPrice.Think = function(s)

			if (s.NextUpdate < CurTime()) then

				local char = LocalPlayer():GetCharacter()

				if (tonumber(char:GetMoney()) >= tonumber(v.price)) or (CanBuy) then
					s:SetTextColor(Color(46, 204, 113))
				else
					s:SetTextColor(Color(250,120,120))
				end


				s.NextUpdate = CurTime() + 1
			end

		end
		-- ItemPrice.Paint = function(s,w,h)
		-- 	draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
		-- end


		if (stocks) and (stocks == 0) then
			self:RenderOutStock(ItemPanel)
		end

		if (stocks) and (stocks > 0) then

			local ItemStocksBG = vgui.Create( "DPanel", ItemPanel )
			ItemStocksBG:SetPos(5,ItemPanel:GetTall()-35)
			ItemStocksBG:SetSize(100,30)
			ItemStocksBG.Paint = function(s,w,h)
				draw.RoundedBox(8, 0,0,w,h, color_DarkGrey)
			end

			local ItemStocks = vgui.Create( "DLabel", ItemStocksBG )
			ItemStocks:Dock(FILL)
			ItemStocks:SetFont("ixMediumFont")
			-- ItemStocks:SetTextColor(Color(46, 204, 113))
			ItemStocks:SetText( stocks )
			ItemStocks:SizeToContents()
			ItemStocks:SetContentAlignment(5)

		end

	end

	-- local ItemsCount = 0

	-- for k, v in pairs(self.VendorItems) do

	-- 	if (v.category != SCategory) then continue end

	-- 	ItemsCount = ItemsCount + 1

	-- end

	-- local fakeButtonsCount = 6 - ItemsCount

	-- if (fakeButtonsCount > 0) then
	-- 	for i=1, fakeButtonsCount do
	-- 		local CategoryPanel = self.grid:Add( "DPanel" )
	-- 		-- CategoryPanel:Dock(TOP)
	-- 		-- CategoryPanel:DockMargin(0,0,0,10)
	-- 		CategoryPanel:DockPadding(5,5,5,10)
	-- 		CategoryPanel:SetTall(160)
	-- 		CategoryPanel.Paint = function(s,w,h)

	-- 		    surface.SetDrawColor( ColorAlpha(color_lightWhite,220 ))
	-- 			surface.SetMaterial(gridTexture)
	-- 			surface.DrawTexturedRect(0,0,w,h)


	-- 		end
	-- 		self.grid:AddCell(CategoryPanel)
	-- 	end
	-- end

end

function PANEL:RenderOutStock(panel)

	local OutStockPanel = vgui.Create( "Panel", panel )
	OutStockPanel:Dock(FILL)
	OutStockPanel.Paint = function(s,w,h)

	    surface.SetDrawColor(10,10,10, 130)
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

	local item = self.VendorItems[self.SelectedBuyItem]

	if (!item) then return end

	local itemPrice = item.price


	if (bankID == 0) then

		if (LocalPlayer():GetCharacter():GetMoney() < itemPrice) then
			LocalPlayer():NotifyLocalized("canNotAfford")
			return
		end
	
	end

	
	net.Start("ixVendorTrade_Buy")
		net.WriteString(self.SelectedBuyItem)
		net.WriteUInt(bankID, 20)
	net.SendToServer()

	-- local BuyedItems = {}
	-- local ItemsAmount = {}

	-- for k, v in pairs(self.ItemsInCart) do
	-- 	BuyedItems[#BuyedItems+1] = k
	-- 	ItemsAmount[#ItemsAmount+1] = v.amount
	-- end

	-- local len = #BuyedItems

	-- net.Start("ixVendorTrade_Extd_Buy")
	-- 	net.WriteUInt( len, 6 )
	-- 	for i = 1, len do
	-- 		net.WriteString(BuyedItems[i])
	-- 	end
	-- 	for i = 1, len do
	-- 		net.WriteUInt(ItemsAmount[i], 7 )
	-- 	end
	-- 	net.WriteUInt(bankID, 20)
	-- net.SendToServer()

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

function PANEL:RobTheVendor()
	
	net.Start("ixVendorTrade_Rob")
	net.SendToServer()

	self:CharAnimation(false)

end

function PANEL:OnRemove()

	self:CharAnimation(false)

	-- net.Start("ixVendorClose")
	-- net.SendToServer()

	-- if (IsValid(ix.gui.vendorEditor)) then
	-- 	ix.gui.vendorEditor:Remove()
	-- end
end

function PANEL:Think()
	local entity = self.entity

	if (!IsValid(entity)) then
		self:Remove()

		return
	end

end

function PANEL:UpdateTitleAndFont(Title,TitleFont)
	self.title:SetText(Title)
	self.title:SetFont(TitleFont)
end

function PANEL:Setup(entity)
	self.entity = entity

	for k, _ in SortedPairs(entity.items) do
		self:addItem(k, "selling")
	end

	self.BottomTips.MouseRMB:SetText( (self.entity:GetCanBeRob() and "THREAT") or "")

	self.title:SetText(self.entity:GetTitleStore())
	self.title:SetFont(self.entity:GetTitleFont())

	self:PrepareCategories()
	self:CharAnimation()

end

vgui.Register("ixVendor", PANEL, "DFrame")
-- vgui.Create("ixVendor")
