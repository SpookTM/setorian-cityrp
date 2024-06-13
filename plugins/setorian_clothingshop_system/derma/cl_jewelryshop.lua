
-- local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_clothingshop_system") or false
local PLUGIN = PLUGIN

local outfitLogo = Material("jewlery_logo_setorian.png", "noclamp smooth" )

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

	self.rotationOffset = Angle(0, 180, 0)
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

	self:DockPadding(ScreenScale(45),ScrH()*0.1,0,ScrH()*0.12)

	self.Paint = function(s,w,h) 
		-- surface.SetDrawColor(200,200,200,150)
	 --    surface.DrawRect(0,0,w,h)

	end

	self.ShopPos = PLUGIN.ShopPos--Vector( 1959.9, -968.97, -12799.85 )

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

	local RotatePly = vgui.Create( "DButton", self )
	RotatePly:Dock(FILL)
	RotatePly:DockMargin(10,0,10,0)
	RotatePly:SetText("")
	RotatePly.Angles = Angle(0, LocalPlayer():GetAngles().y,LocalPlayer():GetAngles().r)
	RotatePly.Delay = CurTime()
	RotatePly.Paint = function(s,w,h)
	end

	RotatePly.DragMousePress = function(s)
		s.PressX, s.PressY = gui.MousePos()
		s.Pressed = true
	end

	RotatePly.DragMouseRelease = function(s)
		s.Pressed = false
	end

	RotatePly.Think = function(s)

		if (s.Pressed) then
			local mx = gui.MousePos()
			s.Angles = s.Angles - Angle(0, (s.PressX or mx) - mx, 0)
			s.PressX, s.PressY = gui.MousePos()

			self.FakeMdl:SetAngles(s.Angles)

		end

		
	end

	local LOGO = vgui.Create( "Panel", MainMenu )
	LOGO:Dock(TOP)
	LOGO:SetTall(ScrH()*0.14)
	LOGO.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,250)
	    surface.DrawRect(0,0,w,h)

	end

	local LogoPNG = vgui.Create( "DImage", LOGO )
	LogoPNG:SetSize(450,120)
	LogoPNG:SetPos(MainMenu:GetWide()/2 - LogoPNG:GetWide()/2,10)
	LogoPNG:SetMaterial(outfitLogo)

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

			LocalPlayer():ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0), 0.2, 0.2 )

			self:CreateAnimation(animationTime * 0.4, {
				index = 1,
				target = {ActualAlpha = 0},
				easing = "inQuint",
				bIgnoreConfig = true,

				Think = function(animation, panel)
					panel:SetAlpha(panel.ActualAlpha)
				end,

				OnComplete = function(animation, panel)
					panel:Close()
					LocalPlayer():ScreenFade( SCREENFADE.IN, Color( 0, 0, 0), 0.2, 0.2 )
				end
			})

		else

			self.CategoryIndex = 0
			self:TransitAnim()

			self:CreateAnimation(animationTime, {
				index = 3,
				target = {overviewFraction = 0},
				easing = "outQuint",
				bIgnoreConfig = true
			})

		end
		
	end

	self.ExitButton = ExitButton

	self.ChangeViewState = false	

	ix.gui.JewelryShopUI = self

	-- local ply = LocalPlayer()
	-- ply:SetEyeAngles(  Angle(0,ply:GetAngles().y,ply:GetAngles().r) )
	-- self:FakePlyModel()


	-- self:RenderCategories()

	LocalPlayer():DrawViewModel(false)

	for k, v in ipairs(player.GetAll()) do
		v:SetNoDraw(true)
	end

end

function PANEL:OnClose()
	ix.gui.JewelryShopUI = nil

	if (IsValid(self.FakeMdl)) then
		print(self.FakeMdl.headmodel)
		if (IsValid(self.FakeMdl.headmodel)) then
			self.FakeMdl.headmodel:Remove()
		end

		self.FakeMdl:Remove()
	end

	LocalPlayer():DrawViewModel(true)

	for k, v in ipairs(player.GetAll()) do
		v:SetNoDraw(false)
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

local function AttachPart(client, uniqueID)
	local itemTable = ix.item.list[uniqueID]
	local pacData = ix.pac.list[uniqueID]

	if (pacData) then
		if (itemTable and itemTable.pacAdjust) then
			pacData = table.Copy(pacData)
			pacData = itemTable:pacAdjust(pacData, client)
		end

		if (isfunction(client.AttachPACPart)) then
			client:AttachPACPart(pacData)
		else
			pac.SetupENT(client)

			timer.Simple(0.1, function()
				if (IsValid(client) and isfunction(client.AttachPACPart)) then
					client:AttachPACPart(pacData)
				end
			end)
		end
	end
end

function PANEL:FakePlyModel()

	local ply = LocalPlayer()

	self.FakeMdl = ClientsideModel(ply:GetModel())
	self.FakeMdl:SetPos(self.ShopPos)--ply:GetPos())
	self.FakeMdl:SetAngles( Angle(0, ply:GetAngles().y,ply:GetAngles().r) )
	self.FakeMdl:Spawn()
	self.FakeMdl:SetSequence(2)--ply:GetSequence())
	self.FakeMdl.Pacs = {}
	self.FakeMdl.PacsTemp = {}

	if (!isfunction(self.FakeMdl.AttachPACPart)) then
		pac.SetupENT(self.FakeMdl)
	end

	for k, v in pairs(PLUGIN.Jewelry) do
		self.FakeMdl.Pacs[v.CategoryName] = {}
	end

	local char = LocalPlayer():GetCharacter()
	local inv = char:GetInventory()

	local items = inv:GetItems()

	for _, v in pairs(items) do

		local itemTable = ix.item.instances[v.id]

		if (self.FakeMdl.Pacs[v.outfitCategory] and itemTable:GetData("equip")) then
			self.FakeMdl.Pacs[v.outfitCategory][v.uniqueID] = true
		end

	end

	if (char:GetHeadmodel() and string.find(char:GetHeadmodel(), "models") and char:GetHeadmodel() != NULL and char:GetHeadmodel() != "" and char:GetHeadmodel() != nil) then
		self:WearPlyHead(char:GetHeadmodel())
	end

	-- local pacCloth = self.PlyPacsData

	-- for slotName, Pacs in pairs(pacCloth) do

	-- 	self.FakeMdl.Pacs[slotName] = Pacs

	-- end

	-- for pacItem, _ in pairs(ply:GetParts()) do
	-- 	self:WearPac(pacItem)
	-- end

	-- PrintTable(self.FakeMdl.Pacs)

end

function PANEL:WearPlyHead(HeadModel)

	if (HeadModel == "") then return end

	if (IsValid(self.FakeMdl)) then

		if (IsValid(self.FakeMdl.headmodel)) then
			self.FakeMdl.headmodel:SetModel(HeadModel)
		else

			local ent = self.FakeMdl

			local CHeadModel = ClientsideModel(HeadModel, RENDERGROUP_BOTH)

			if (CHeadModel) then
				-- CHeadModel:SetParent(ent)
				-- CHeadModel:AddEffects(EF_BONEMERGE)
				-- CHeadModel:SetNoDraw(true)
				CHeadModel:InvalidateBoneCache()
				CHeadModel:SetParent(ent)
				CHeadModel:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
				CHeadModel:SetupBones()
				-- CHeadModel:SetNoDraw(true)
				ent.headmodel = CHeadModel
				
			end
		end


	end

end


function PANEL:GetOverviewInfo(origin, angles, fov)
	local originAngles = Angle(0, angles.yaw, angles.roll)
	local target = LocalPlayer():GetObserverTarget()
	local fraction = self.overviewFraction
	local bDrawPlayer = false
	local forward = originAngles:Forward() * 58 - originAngles:Right() * -10
	forward.z = 0

	local newOrigin

	local oldOrigin = origin

	-- if (IsValid(target)) then
		-- newOrigin = target:GetPos() + forward
	-- else
		origin = self.ShopPos + forward + originAngles:Up() * 40
		-- origin = origin - LocalPlayer():OBBCenter() * 0.6 + forward

		if (self.ChangeViewState) then

			local NewData = self.ViewData

			newOrigin = origin + originAngles:Forward() * NewData.VFor - originAngles:Right() * NewData.VRight - originAngles:Up() * NewData.VUp
		else
			newOrigin = origin
		end

	local newAngles = originAngles + self.rotationOffset
	newAngles.pitch = 5
	newAngles.roll = 0


	return LerpVector(fraction, origin, newOrigin),  newAngles , 90, bDrawPlayer
end

function PANEL:ChangeView()

	-- if (self.CategoryIndex == 0) then return end

	self.ChangeViewState = true

	local DefaultData = {
		VFor = 0,
		VRight = 0,
		VUp = 0
	}

	self.ViewData = PLUGIN.Jewelry[self.CategoryIndex].ViewVector or DefaultData

	self:CreateAnimation(animationTime, {
		index = 3,
		target = {overviewFraction = 1},
		easing = "outQuint",
		bIgnoreConfig = true
	})

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
				self:RenderClothes()
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

	self:ResetPlyLook()

	for k, v in ipairs(PLUGIN.Jewelry) do

		if (v.Gender) then
			if (v.Gender == "male") and (LocalPlayer():IsFemale()) then continue end
			if (v.Gender == "female") and (!LocalPlayer():IsFemale()) then continue end
		end

		local CategoryButton = vgui.Create( "ixMenuButton", self.MainContent )
		CategoryButton:Dock(TOP)
		CategoryButton:DockMargin(0,0,0,5)
		CategoryButton:SetFont("ixMenuButtonFontThick")
		CategoryButton:SetText(v.CategoryName)
		CategoryButton:SetAutoStretchVertical(true)
		CategoryButton:SetContentAlignment(5)
		CategoryButton.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")
			
			self.CategoryIndex = k
			self:TransitAnim()
			self:ChangeView()

		end

	end

end

function PANEL:RenderClothes()

	if (self.CategoryIndex == 0) then self:RenderCategories() return end

	local ply = LocalPlayer()


	local CategoryTable = PLUGIN.Jewelry[self.CategoryIndex]

	-- for k, v in ipairs(PLUGIN.Clothes) do
	for k, v in SortedPairsByMemberValue(CategoryTable.ShopItems or {}, "price") do

		if (v.Gender) then
			if (v.Gender == "male") and (LocalPlayer():IsFemale()) then continue end
			if (v.Gender == "female") and (!LocalPlayer():IsFemale()) then continue end
		end

		local ClotheItemButton = vgui.Create( "ixMenuButton", self.MainContent )
		ClotheItemButton:Dock(TOP)
		ClotheItemButton:DockPadding(10,0,10,0)
		ClotheItemButton:SetText("")
		ClotheItemButton:SetAutoStretchVertical(true)
		ClotheItemButton:SetContentAlignment(5)
		ClotheItemButton.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")
			
			Derma_Query(
			    "Are you sure you want to purchase this jewelry?",
			    "Purchase confirmation",
			    "Yes",
			    function()

			  --   	if (PLUGIN.Clothes[self.CategoryIndex].BodyGroupName == "Skin") then

					-- 	if (ply:GetSkin() == v.bg) then
					-- 		LocalPlayer():Notify("You already own this clothing")
					-- 		return
					-- 	end

					-- else

					-- 	if (ply:GetBodygroup(ply:FindBodygroupByName( PLUGIN.Clothes[self.CategoryIndex].BodyGroupName )) == v.bg) then
					-- 		LocalPlayer():Notify("You already own this clothing")
					-- 		return
					-- 	end

					-- end

			    	net.Start("ixClothingShop_BuyJewelry")
					net.WriteString(k)
					net.WriteUInt(self.CategoryIndex, 8)
					net.SendToServer()

			    end,
				"No"
			)

		end
		ClotheItemButton.OnCursorEntered = function(s)

			DEFINE_BASECLASS("ixMenuButton")
			BaseClass.OnCursorEntered(s)

			if (self.CategoryIndex == 0) then return end

			if (v.CompleteOutfit) then
				for slotName, Pacs in pairs(self.FakeMdl.Pacs or {}) do

					for pacName, _ in pairs(Pacs or {}) do

						self:RemovePac(pacName)
					end

				end
			end

			self:PreviewItem(v.Appearance)

			-- if (PLUGIN.Clothes[self.CategoryIndex].BodyGroupName == "Skin") then

			-- 	self.FakeMdl:SetSkin(v.bg)

			-- else

			-- 	self.FakeMdl:SetBodygroup(self.FakeMdl:FindBodygroupByName( PLUGIN.Clothes[self.CategoryIndex].BodyGroupName ), v.bg)

			-- end

		end


		local ClothName = vgui.Create( "DLabel", ClotheItemButton )
		ClothName:Dock(FILL)
		ClothName:SetFont("ClothUI_Font1")
		ClothName:SetContentAlignment(4)
		ClothName:SetText( k )
		ClothName:SizeToContents()
		ClothName:SetMouseInputEnabled(false)

		-- local priceText

		-- if (PLUGIN.Clothes[self.CategoryIndex].BodyGroupName == "Skin") then
		-- 	priceText = (ply:GetSkin() == v.bg and "OWNED") or "$"..v.price
		-- else
		-- 	priceText = (ply:GetBodygroup(ply:FindBodygroupByName( PLUGIN.Clothes[self.CategoryIndex].BodyGroupName )) == v.bg and "OWNED") or "$"..v.price
		-- end

		local ClothPrice = vgui.Create( "DLabel", ClotheItemButton )
		ClothPrice:Dock(RIGHT)
		ClothPrice:SetFont("ClothUI_Font1")
		ClothPrice:SetContentAlignment(6)
		ClothPrice:SetText( "$"..v.price )
		ClothPrice:SizeToContents()
		ClothPrice:SetMouseInputEnabled(false)
		ClothPrice.NextCheck = CurTime() + 0.5
		ClothPrice.ActualAlpha = 0
		ClothPrice:SetAlpha(0)

		ClothPrice:CreateAnimation(1, {
			index = 1,
			target = {ActualAlpha = 255},
			easing = "inQuint",
			bIgnoreConfig = true,

			Think = function(animation, panel)
				panel:SetAlpha(panel.ActualAlpha)
			end

		})

		-- ClothPrice.Think = function(s)

		-- 	if (self.CategoryIndex == 0) then return end

		-- 	if (s.NextCheck < CurTime()) then

		-- 		local priceText
		-- 		local ply = LocalPlayer()

		-- 		if (PLUGIN.Clothes[self.CategoryIndex].BodyGroupName == "Skin") then
		-- 			priceText = (ply:GetSkin() == v.bg and "OWNED") or "$"..v.price
		-- 		else
		-- 			priceText = (ply:GetBodygroup(ply:FindBodygroupByName( PLUGIN.Clothes[self.CategoryIndex].BodyGroupName )) == v.bg and "OWNED") or "$"..v.price
		-- 		end
				
		-- 		s:SetText( priceText )
		-- 		s.NextCheck = CurTime() + 0.5

		-- 	end

		-- end

	end


end


function PANEL:WearPac(pacName)

	local itemTable = ix.item.list[pacName]
	local pacData = PLUGIN.PacDatabase[pacName] or ix.pac.list[pacName]

	if (!pacData) then return end

	if (itemTable and itemTable.pacAdjust) then
		pacData = table.Copy(pacData)
		pacData = itemTable:pacAdjust(pacData, LocalPlayer())
	end

	if (isfunction(self.FakeMdl.AttachPACPart)) then
		self.FakeMdl:AttachPACPart(pacData)
	else
		pac.SetupENT(self.FakeMdl)

		timer.Simple(0.1, function()
			if (IsValid(self.FakeMdl) and isfunction(self.FakeMdl.AttachPACPart)) then
				self.FakeMdl:AttachPACPart(pacData)
			end
		end)
	end

	if (self.CategoryIndex == 0) then return end

	local slotName = PLUGIN.Jewelry[self.CategoryIndex].CategoryName

	self.FakeMdl.Pacs[slotName][pacName] = true

end

function PANEL:RemovePac(pacName)

	local pacData = PLUGIN.PacDatabase[pacName] or ix.pac.list[pacName]

	if (pacData) then

		if (isfunction(self.FakeMdl.RemovePACPart)) then
			self.FakeMdl:RemovePACPart(pacData)
		else
			pac.SetupENT(self.FakeMdl)
		end

		if (self.CategoryIndex == 0) then return end

		local slotName = PLUGIN.Jewelry[self.CategoryIndex].CategoryName

		self.FakeMdl.Pacs[slotName][pacName] = nil
	end

end

function PANEL:ResetPlyLook()

	local ply = LocalPlayer()

	if (self.FakeMdl:GetModel() != ply:GetModel()) then
		self.FakeMdl:SetModel(ply:GetModel())
		self.FakeMdl:SetSequence(2)
	end

	for i = 0, (ply:GetNumBodyGroups() - 1) do
		self.FakeMdl:SetBodygroup(i, ply:GetBodygroup(i))
	end

	self.FakeMdl:SetSkin(ply:GetSkin())


	for slotName, Pacs in pairs(self.FakeMdl.Pacs or {}) do

		for pacName, _ in pairs(Pacs or {}) do

			self:RemovePac(pacName)
		end

	end

	for pacItem, _ in pairs(ply:GetParts()) do
		self:WearPac(pacItem)
	end

	local char = LocalPlayer():GetCharacter()
	local inv = char:GetInventory()

	local items = inv:GetItems()

	for _, v in pairs(items) do

		local itemTable = ix.item.instances[v.id]

		if (self.FakeMdl.Pacs[v.outfitCategory] and itemTable:GetData("equip")) then
			self.FakeMdl.Pacs[v.outfitCategory][v.uniqueID] = true
		end

	end

	-- self:RestorePacTemp()
	-- for slotName, Pacs in pairs(self.FakeMdl.Pacs or {}) do

	-- 	for pacName, _ in pairs(Pacs or {}) do

	-- 		if (!ply:GetParts()[pacName]) then
	-- 			self:RemovePac(pacName)
	-- 		end

	-- 	end

	-- end

end

function PANEL:PreviewItem(ItemTable)

	local ply = LocalPlayer()

	if (ItemTable.BodyGroups) then

		for bgName, bgV in pairs(ItemTable.BodyGroups) do

			self.FakeMdl:SetBodygroup( ply:FindBodygroupByName(bgName), bgV)

		end

	end

	if (ItemTable.Pac) then
		local slotName = PLUGIN.Jewelry[self.CategoryIndex].CategoryName

		for pacName, _ in pairs(self.FakeMdl.Pacs[slotName] or {}) do

			self:RemovePac(pacName)

		end

		-- for pacName, _ in pairs(ItemTable.Pacs) do

			-- if (ply:GetParts()[pacName]) then continue end
			-- if (self.FakeMdl.Pacs[slotName][pacName]) then continue end

		self:WearPac(ItemTable.Pac)
			
		-- end

	end

	if (ItemTable.ModelData) then

		if (ItemTable.ModelData.ModelReplace) then

			local ModelToReplace = ItemTable.ModelData.PModel

			if (string.find(ply:GetModel(), ItemTable.ModelData.ModelReplace)) then

				local ModelNumber = string.match( ply:GetModel(), ItemTable.ModelData.ModelReplace.."%d" )

				local StartPos, EndPos = string.find(ItemTable.ModelData.PModel, ItemTable.ModelData.ModelReplace)

				ModelToReplace = string.sub( ItemTable.ModelData.PModel, 1, StartPos - 1 ) .. ModelNumber .. string.sub( ItemTable.ModelData.PModel, EndPos + 2 )

			end

			self.FakeMdl:SetModel(ModelToReplace)



		else
			self.FakeMdl:SetModel(ItemTable.ModelData.PModel)
		end

		self.FakeMdl:SetSkin(0)
		self.FakeMdl:SetSequence(2)

	end

	if (ItemTable.Skin) then
		self.FakeMdl:SetSkin(ItemTable.Skin)
	end

end

vgui.Register("ixJeweShopUI", PANEL, "DFrame")

if (IsValid(ix.gui.JewelryShopUI)) then
	ix.gui.JewelryShopUI:Close()
end

-- vgui.Create("ixClotShopUI")