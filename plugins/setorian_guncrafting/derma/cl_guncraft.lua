
-- local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_guncrafting") or false
local PLUGIN = PLUGIN

local outfitLogo = Material("haven_clothing.png", "noclamp smooth" )

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(ScrW(),ScrH())
	self:Center()
	self:MakePopup()
	
	self:SetAlpha(0)
	self.ActualAlpha = 0

	self.rotationOffset = Angle(0, 0, 0)
	self.bCharacterOverview = false
	self.bOverviewOut = false
	self.overviewFraction = 0

	self.AddVector = Vector(0,0,0)

	self.bClosing = false

	self.CategoryIndex = 0

	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self:DockPadding(ScreenScale(45),ScrH()*0.1,ScreenScale(25),ScrH()*0.12)

	self.Paint = function(s,w,h) 
		-- surface.SetDrawColor(200,200,200,150)
	 --    surface.DrawRect(0,0,w,h)

	end

	self.ShopPos = Vector( 1959.9, -968.97, -12799.85 )

	self:CreateAnimation(animationTime, {
		index = 1,
		target = {ActualAlpha = 255},
		easing = "outQuint",
		bIgnoreConfig = true,

		Think = function(animation, panel)
			panel:SetAlpha(panel.ActualAlpha)
		end

	})


	local MainMenu = vgui.Create( "DPanel", self )
	MainMenu:Dock(LEFT)
	MainMenu:SetWide(450)
	MainMenu.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,h)

	end

	local IngredientsMenu = vgui.Create( "DPanel", self )
	IngredientsMenu:Dock(RIGHT)
	IngredientsMenu:SetWide(300)
	IngredientsMenu.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,240)
	    surface.DrawRect(0,0,w,h)

	end

	local IngredientsTitle = vgui.Create( "Panel", IngredientsMenu )
	IngredientsTitle:Dock(TOP)
	IngredientsTitle:SetTall(ScrH()*0.06)
	IngredientsTitle.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,h)

	end

	local IngredientsTitle_Text = vgui.Create( "DLabel", IngredientsTitle )
	IngredientsTitle_Text:Dock(FILL)
	IngredientsTitle_Text:DockMargin(0,0,0,0)
	IngredientsTitle_Text:SetFont("GunCraftUI_Font1")
	IngredientsTitle_Text:SetText( string.upper( "Requirements" ) )
	-- IngredientsTitle_Text:SetTall(200)
	IngredientsTitle_Text:SetContentAlignment(5)

	local IngredientsList = vgui.Create( "Panel", IngredientsMenu )
	IngredientsList:Dock(FILL)
	IngredientsList:DockMargin(2,2,2,2)

	self.IngredientsList = IngredientsList

	local LOGO = vgui.Create( "Panel", MainMenu )
	LOGO:Dock(TOP)
	LOGO:SetTall(ScrH()*0.14)
	LOGO.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,h)

	end

	-- local LogoPNG = vgui.Create( "DImage", LOGO )
	-- LogoPNG:SetSize(270,150)
	-- LogoPNG:SetPos(MainMenu:GetWide()/2 - LogoPNG:GetWide()/2,-5)
	-- LogoPNG:SetMaterial(outfitLogo)

	local MainContent = vgui.Create( "DScrollPanel", MainMenu )
	MainContent:SetPos(0,LOGO:GetTall() + 5)
	MainContent:SetSize(450,ScrH()*0.59)
	MainContent:SetAlpha(0)
	MainContent.ActualAlpha = 0

	local sbar = MainContent:GetVBar()
	sbar:SetWide(5)

	self.MainContent = MainContent

	MainContent:CreateAnimation(1, {
		index = 1,
		target = {ActualAlpha = 255},
		easing = "linear",
		bIgnoreConfig = true,

		Think = function(animation, panel)
			panel:SetAlpha(panel.ActualAlpha)
		end

	})

	-- MainContent:SlideDown(1)

	local ExitButton = vgui.Create( "ixMenuButton", MainMenu )
	ExitButton:Dock(BOTTOM)
	ExitButton:DockMargin(0,5,0,5)
	ExitButton:SetFont("ixMenuButtonFontThick")
	ExitButton:SetText("EXIT")
	ExitButton:SetAutoStretchVertical(true)
	ExitButton:SetContentAlignment(5)
	ExitButton.CloseMode = true

	ExitButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		if (s.CloseMode) then
			-- LocalPlayer():ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0), 0.2, 0.2 )

			self:CreateAnimation(animationTime * 0.5, {
				index = 1,
				target = {ActualAlpha = 0},
				easing = "outQuint",
				bIgnoreConfig = true,

				Think = function(animation, panel)
					panel:SetAlpha(panel.ActualAlpha)
				end

			})

			self:CreateAnimation(animationTime * 0.5, {
				index = 3,
				target = {overviewFraction = 0},
				easing = "outQuint",
				bIgnoreConfig = true,

				OnComplete = function(animation, panel)
					panel:Close()
					
				end
			})

		else

			self.CategoryIndex = 0
			self:TransitAnim()

			if (IsValid(self.FakeMdl)) then
				self.FakeMdl:Remove()
			end
			
			-- self:CreateAnimation(animationTime, {
			-- 	index = 3,
			-- 	target = {overviewFraction = 0},
			-- 	easing = "outQuint",
			-- 	bIgnoreConfig = true
			-- })

		end
		
	end

	self.ExitButton = ExitButton

	self.ChangeViewState = false	

	ix.gui.SetorianGunCraftingUI = self

	self:CreateAnimation(animationTime, {
		index = 3,
		target = {overviewFraction = 1},
		easing = "outQuint",
		bIgnoreConfig = true,
	})


	-- local ply = LocalPlayer()
	-- ply:SetEyeAngles(  Angle(0,ply:GetAngles().y,ply:GetAngles().r) )
	-- self:FakePlyModel()


	-- self:RenderCategories()


end

function PANEL:OnClose()
	ix.gui.SetorianGunCraftingUI = nil

	if (IsValid(self.FakeMdl)) then
		self.FakeMdl:Remove()
	end

end

function PANEL:UpdateExitButton(CloseMode)

	if (CloseMode) then
		self.ExitButton:SetText("EXIT")
	else
		self.ExitButton:SetText("RETURN")
	end

	self.ExitButton.CloseMode = CloseMode

end



function PANEL:WeaponModel(ent, model)

	if (IsValid(self.FakeMdl)) then
		self.FakeMdl:Remove()
	end

	self.FakeMdl = ClientsideModel(model)
	self.FakeMdl:SetPos(ent:GetPos() + ent:GetAngles():Up()*34)
	self.FakeMdl:SetAngles( ent:GetAngles() + Angle(0,90,-90) )
	self.FakeMdl:Spawn()

end

function PANEL:GetOverviewInfo(origin, angles, fov)
	local originAngles = Angle(0, angles.yaw, angles.roll)
	local target = LocalPlayer():GetObserverTarget()
	local fraction = self.overviewFraction
	local bDrawPlayer = false
	local forward = originAngles:Forward() * -5 + originAngles:Up() * 230
	forward.z = 0

	local newOrigin = self.TableEnt:GetPos() + self.TableEnt:GetAngles():Forward() * 25 + self.TableEnt:GetAngles():Right() * 5 + self.TableEnt:GetAngles():Up() * 80


	local newAngles = self.TableEnt:GetAngles()  + Angle(60,180,0)



	return LerpVector(fraction, origin, newOrigin), LerpAngle(fraction, angles, newAngles), 90, bDrawPlayer
end



function PANEL:TransitAnim()

	self.MainContent:CreateAnimation(animationTime * 0.3, {
		index = 1,
		target = {ActualAlpha = 0},
		easing = "outQuint",
		bIgnoreConfig = true,

		Think = function(animation, panel)
			panel:SetAlpha(panel.ActualAlpha)
		end,

		OnComplete = function(animation, panel)

			self:UpdateExitButton(self.CategoryIndex == 0)
			panel:Clear()

			if (self.CategoryIndex == 0) then
				self:RenderCategories()
				self.ChangeViewState = false
			else
				self:RenderWeapons()
			end

			panel:CreateAnimation(animationTime * 0.3, {
				index = 2,
				target = {ActualAlpha = 255},
				easing = "inQuint",
				bIgnoreConfig = true,

				Think = function(animation, panel)
					panel:SetAlpha(panel.ActualAlpha)
				end


			})

		end	

	})

end

function PANEL:RenderCategories()

	for k, v in ipairs(PLUGIN.Recipes) do

		local CategoryButton = vgui.Create( "ixMenuButton", self.MainContent )
		CategoryButton:Dock(TOP)
		CategoryButton:DockMargin(0,0,0,5)
		CategoryButton:SetFont("ixMenuButtonFontThick")
		CategoryButton:SetText(v.RName)
		CategoryButton:SetAutoStretchVertical(true)
		CategoryButton:SetContentAlignment(5)
		CategoryButton.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")
			
			self.CategoryIndex = k
			self:TransitAnim()

		end

	end

end

function PANEL:RenderWeapons()

	if (self.CategoryIndex == 0) then self:RenderCategories() return end

	local ply = LocalPlayer()


	local CategoryTable = PLUGIN.Recipes[self.CategoryIndex]
	for k, v in SortedPairs(CategoryTable.Weapons or {}) do

		local WepItemButton = vgui.Create( "ixMenuButton", self.MainContent )
		WepItemButton:Dock(TOP)
		WepItemButton:DockPadding(10,0,10,0)
		WepItemButton:SetText("")
		WepItemButton:SetAutoStretchVertical(true)
		WepItemButton:SetContentAlignment(5)
		WepItemButton.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")
			
			Derma_Query(
			    "Are you sure you want to craft this item?",
			    "Crafting confirmation",
			    "Yes",
			    function()

			    	net.Start("ixGunCrafting_CraftWep")
					net.WriteString(k)
					net.WriteUInt(self.CategoryIndex, 8)
					net.SendToServer()

			    end,
				"No"
			)

		end
		WepItemButton.OnCursorEntered = function(s)

			DEFINE_BASECLASS("ixMenuButton")
			BaseClass.OnCursorEntered(s)

			if (self.CategoryIndex == 0) then return end

			local itemTable = ix.item.list[v.result]

			if (!itemTable) then return end

			self:DisplayReq(v.req, (v.level or 0))
			self:WeaponModel(self.TableEnt, itemTable.model)

		end

		WepItemButton.OnCursorExited = function(s)

			DEFINE_BASECLASS("ixMenuButton")
			BaseClass.OnCursorExited(s)

			self:DisplayReq()
		end



		local WepName = vgui.Create( "DLabel", WepItemButton )
		WepName:Dock(FILL)
		WepName:SetFont("GunCraftUI_Font1")
		WepName:SetContentAlignment(5)
		WepName:SetText( k )
		WepName:SizeToContents()
		WepName:SetMouseInputEnabled(false)


	end


end

function PANEL:DisplayReq(reqs, level)

	self.IngredientsList:Clear()

	if (level and level != 0) then
		local IngredientPnl = vgui.Create( "Panel", self.IngredientsList )
		IngredientPnl:Dock(TOP)
		IngredientPnl:DockMargin(0,0,0,10)

		local IngredientText = vgui.Create( "DLabel", IngredientPnl )
		IngredientText:Dock(FILL)
		IngredientText:DockMargin(0,0,5,0)
		IngredientText:SetFont("GunCraftUI_Font1")
		IngredientText:SetText( "GUN CRAFTING" )
		IngredientText:SetContentAlignment(5)

		local IngredientValue = vgui.Create( "DLabel", IngredientPnl )
		IngredientValue:Dock(RIGHT)
		IngredientValue:SetFont("GunCraftUI_Font1")
		IngredientValue:SetText( level )
		IngredientValue:SetContentAlignment(5)
	end

	for k, v in pairs(reqs or {}) do

		local IngredientPnl = vgui.Create( "Panel", self.IngredientsList )
		IngredientPnl:Dock(TOP)
		IngredientPnl:DockMargin(0,0,0,10)

		local IngredientText = vgui.Create( "DLabel", IngredientPnl )
		IngredientText:Dock(FILL)
		IngredientText:DockMargin(0,0,5,0)
		IngredientText:SetFont("GunCraftUI_Font1")
		IngredientText:SetText( string.upper( k ) )
		IngredientText:SetContentAlignment(5)

		local IngredientValue = vgui.Create( "DLabel", IngredientPnl )
		IngredientValue:Dock(RIGHT)
		IngredientValue:SetFont("GunCraftUI_Font1")
		IngredientValue:SetText( "x" .. v )
		IngredientValue:SetContentAlignment(5)
		
	end

end


vgui.Register("ixSetorianGunCraftUI", PANEL, "DFrame")

if (IsValid(ix.gui.SetorianGunCraftingUI)) then
	ix.gui.SetorianGunCraftingUI:Close()
end

-- vgui.Create("ixClotShopUI")