
-- local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("ixcraft_setorian") or false
local PLUGIN = PLUGIN

local outfitLogo = Material("haven_clothing.png", "noclamp smooth" )

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(1200,700)
	self:Center()
	self:MakePopup()

	self.bClosing = false

	self:SetAlpha(0)
	self.ActualAlpha = 0

	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(true)
	self:SetDraggable(false)

	self:CreateAnimation(animationTime * 0.5, {
		index = 1,
		target = {ActualAlpha = 255},
		easing = "outQuint",
		bIgnoreConfig = true,

		Think = function(animation, panel)
			panel:SetAlpha(panel.ActualAlpha)
		end

	})


	self.Paint = function(s,w,h)

		ix.util.DrawBlur(s)

		surface.SetDrawColor(50,50,50,230)
	    surface.DrawRect(0,0,w,h)

	    draw.SimpleText("Crafting Table", "ixSmallFont", 5, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	end

	ix.gui.SetorianCraftingUI = self

	local MainContent = vgui.Create( "DPanel", self )
	MainContent:Dock(FILL)
	MainContent:DockPadding(5,5,5,5)
	MainContent.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

	end

	local LeftColumn = vgui.Create( "Panel", MainContent )
	LeftColumn:Dock(LEFT)
	LeftColumn:SetWide(self:GetWide()*0.25)

	local MiddleColumn = vgui.Create( "Panel", MainContent )
	MiddleColumn:Dock(FILL)
	MiddleColumn:DockMargin(10,0,10,0)
	MiddleColumn.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)
	end
	self.MiddleColumn = MiddleColumn

	local MiddleTip = vgui.Create( "DLabel", MiddleColumn )
	MiddleTip:Dock(FILL)
	MiddleTip:SetFont("ixMenuButtonLabelFont")
	MiddleTip:SetContentAlignment(5)
	MiddleTip:SetText( "Please select a category" )
	MiddleTip:SizeToContents()
	MiddleTip:SetMouseInputEnabled(false)

	local RightColumn = vgui.Create( "Panel", MainContent )
	RightColumn:Dock(RIGHT)
	RightColumn:SetWide(self:GetWide()*0.37)
	RightColumn:DockPadding(10,10,10,5)
	RightColumn.Paint = function(s,w,h)
		surface.SetDrawColor(60,60,60,100)
	    surface.DrawRect(0,0,w,h)
	end

	self.RightColumn = RightColumn

	local CategoryList = vgui.Create( "DScrollPanel", LeftColumn )
	CategoryList:Dock(FILL)
	CategoryList:DockMargin(0,0,0,5)
	CategoryList.buttons = {}
	CategoryList.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)
	end

	self.CategoryList = CategoryList

	self.queueNumber = 0
	self.queueItems = {}
	self.processqueueitem = nil

	local QueueText = vgui.Create( "DLabel", LeftColumn )
	QueueText:Dock(BOTTOM)
	QueueText:SetFont("ixMenuButtonLabelFont")
	QueueText:SetContentAlignment(5)
	QueueText:SetText( "Crafting Queue: "..self.queueNumber.."/12" )
	QueueText:SizeToContents()
	QueueText:SetMouseInputEnabled(false)
	self.QueueText = QueueText

	local QueuePnl = vgui.Create( "DPanel", self )
	QueuePnl:Dock(BOTTOM)
	QueuePnl:DockMargin(0,5,0,5)
	QueuePnl:SetTall(80)
	QueuePnl:SetZPos(2)
	QueuePnl.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

	end

	local List = QueuePnl:Add( "DIconLayout" )
	List:Dock( FILL )
	List:DockMargin(5,5,5,5)
	List:SetSpaceY( 5 )
	List:SetSpaceX( 5 )

	-- List.Paint = function(s,w,h)

	-- 	surface.SetDrawColor(20,220,20,250)
	--     surface.DrawRect(0,0,w,h)

	-- end

	self.QueueList = List

	-- local ListItem = List:Add( "DPanel" ) -- Add DPanel to the DIconLayout
	-- ListItem:SetSize( 80, 60 ) -- Set the size of it

	local ClaimItemsButton = vgui.Create( "ixMenuButton", self)
	ClaimItemsButton:Dock(BOTTOM)
	ClaimItemsButton:DockMargin(0,0,0,5)
	ClaimItemsButton:SetZPos(1)
	ClaimItemsButton:SetFont("ixMenuButtonFontThick")
	ClaimItemsButton:SetText("Claim Items")
	ClaimItemsButton:SetAutoStretchVertical(true)
	ClaimItemsButton:SetContentAlignment(5)
	ClaimItemsButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		if (table.IsEmpty(self.queueItems)) then
			LocalPlayer():Notify("The queue is empty")
			return
		end

		net.Start("ixSetorianCraft_ClaimItems")
			net.WriteEntity(self.table)
		net.SendToServer()

	end
	
	//Init
	self:RenderCategories()

	-- PrintTable(PLUGIN.craft.recipes)

end

function PANEL:OnClose()
	ix.gui.SetorianCraftingUI = nil


end

function PANEL:RenderCategories()

	local renderedCategories = {
		["Crafting"] = true
	}

	self.CategoryList:Clear()

	local buttonColor = (ix.config.Get("color") or Color(140, 140, 140, 255))

	local CategoryButton = vgui.Create( "ixMenuSelectionButton", self.CategoryList )
	CategoryButton:Dock(TOP)
	CategoryButton:DockMargin(0,0,0,5)
	CategoryButton:SetFont("ixMediumFont")
	CategoryButton:SetText("Crafting")
	CategoryButton:SizeToContents()
	-- CategoryButton:SetTall(CategoryButton:GetTall() + 10)
	CategoryButton:SetButtonList(self.CategoryList.buttons)
	CategoryButton:SetBackgroundColor(buttonColor)
	CategoryButton.OnSelected = function(s)
		self:RenderItems(s:GetValue())
		self:ClearDetails()
	end

	for k, v in SortedPairs(PLUGIN.craft.recipes) do

		if (v.postHooks) then

			if (v.postHooks.OnCanSee) then
				if (!v.postHooks.OnCanSee(v, LocalPlayer())) then continue end
			end

			if (v.postHooks.OnCanCraft) then
				if (!v.postHooks.OnCanCraft(v, LocalPlayer())) then continue end
			end

		end

		if (renderedCategories[v.category]) then continue end

		local CategoryButton = vgui.Create( "ixMenuSelectionButton", self.CategoryList )
		CategoryButton:Dock(TOP)
		CategoryButton:DockMargin(0,0,0,2)
		CategoryButton:SetFont("ixMediumFont")
		CategoryButton:SetText(v.category)
		CategoryButton:SizeToContents()
		-- CategoryButton:SetTall(CategoryButton:GetTall() + 10)
		CategoryButton:SetButtonList(self.CategoryList.buttons)
		CategoryButton:SetBackgroundColor(buttonColor)
		CategoryButton.OnSelected = function(s)
			self:RenderItems(s:GetValue())
			self:ClearDetails()
		end

		renderedCategories[v.category] = true

	end


end

function PANEL:RenderItems(categoryName)

	local selectedCategory = string.lower(categoryName)

	self.MiddleColumn:Clear()

	local searchBar = vgui.Create("ixIconTextEntry", self.MiddleColumn)
	searchBar:Dock(TOP)
	searchBar.OnEnter = function(s)
	   	self:RenderRecipes(selectedCategory, s:GetValue())
	end

	local ItemsScroll = vgui.Create( "DScrollPanel", self.MiddleColumn )
	ItemsScroll:Dock(FILL)
	ItemsScroll.Paint = function(s,w,h)
	end

	self.ItemsScroll = ItemsScroll

	self:RenderRecipes(selectedCategory, "")

end

function PANEL:CheckRecipeReq(recipeData)

	local check = true

	local char = LocalPlayer():GetCharacter()
	local inv  = char:GetInventory()

	if (recipeData.requirements) then

		for k, v in SortedPairs(recipeData.requirements or {}) do

			local itemTable = ix.item.list[k]

			if (!itemTable) then continue end

			local itemCount = inv:GetItemCount(k)

			if (itemCount < v) then
				return false
			end

		end

	end

	if (recipeData.tools) then

		for k, v in SortedPairs(recipeData.tools or {}) do

			local itemTable = ix.item.list[v]

			if (!itemTable) then continue end

			local hasItem = inv:HasItem(v)

			if (!hasItem) then
				return false
			end

		end

	end

	if (recipeData.flag) then

		if (!char:HasFlags(recipeData.flag)) then
			return false
		end

	end

	return true

end

function PANEL:RenderRecipes(categoryName, searchP)

	local findSearch

	if (searchP != "") then
		findSearch = searchP
	end

	self.ItemsScroll:Clear()
	
	for k, v in SortedPairs(PLUGIN.craft.recipes) do

		if (string.lower(v.category) == categoryName) then

			if (findSearch) then
				if (!string.find(string.lower(v.name), string.lower(findSearch))) then continue end
			end

			if (v.postHooks) then

				if (v.postHooks.OnCanSee) then
					if (!v.postHooks.OnCanSee(v, LocalPlayer())) then continue end
				end

				if (v.postHooks.OnCanCraft) then
					if (!v.postHooks.OnCanCraft(v, LocalPlayer())) then continue end
				end

			end

			// rgb(39, 174, 96)
			//rgb(192, 57, 43)
			local RecipePnl = vgui.Create( "DButton", self.ItemsScroll )
			RecipePnl:Dock(TOP)
			RecipePnl:DockMargin(0,0,0,5)
			RecipePnl:SetTall(70)
			RecipePnl:SetText("")
			RecipePnl.Paint = function(s,w,h)
				surface.SetDrawColor((self:CheckRecipeReq(v) and Color(39, 174, 96,150)) or Color(192, 57, 43,150))
			    surface.DrawRect(0,0,w,h)

			end
			RecipePnl.DoClick = function(s)

				local recipedata = {
					recipeid = k,
					name = v.name,
					desc = v.description,
					req  = v.requirements,
					tools = v.tools
				}

				self:RenderDetails(recipedata)

			end

			local RecipeModel = vgui.Create( "SpawnIcon" , RecipePnl )
			RecipeModel:Dock(LEFT)
			RecipeModel:SetWide(RecipePnl:GetTall())
			RecipeModel:SetModel( v.model or "models/error.mdl" )
			RecipeModel:SetTooltip(false)
			RecipeModel:SetMouseInputEnabled(false)
			RecipeModel.PaintOver = function(s)
			end

			local RecipeName = vgui.Create( "DLabel", RecipePnl )
			RecipeName:Dock(FILL)
			RecipeName:SetFont("ixMenuButtonLabelFont")
			RecipeName:SetContentAlignment(4)
			RecipeName:SetText( v.name or "Unknown" )
			RecipeName:SizeToContents()
			RecipeName:SetMouseInputEnabled(false)

		end

	end

end

function PANEL:ClearDetails()
	self.RightColumn:Clear()
end

function PANEL:RenderDetails(recipeData)

	self.RightColumn:Clear()

	local RecipeTitle = vgui.Create( "DLabel", self.RightColumn )
	RecipeTitle:Dock(TOP)
	RecipeTitle:DockMargin(0,10,0,40)
	RecipeTitle:SetFont("ix3D2DMediumFont")
	RecipeTitle:SetContentAlignment(5)
	RecipeTitle:SetText( recipeData.name or "Unknown" )
	RecipeTitle:SizeToContents()
	RecipeTitle:SetMouseInputEnabled(false)

	local RecipeDescText = vgui.Create( "DLabel", self.RightColumn )
	RecipeDescText:Dock(TOP)
	RecipeDescText:DockMargin(0,0,0,5)
	RecipeDescText:SetFont("ixMenuButtonLabelFont")
	RecipeDescText:SetContentAlignment(4)
	RecipeDescText:SetText( "Description:")
	RecipeDescText:SizeToContents()
	RecipeDescText:SetMouseInputEnabled(false)

	local RecipeDesc = vgui.Create( "DLabel", self.RightColumn )
	RecipeDesc:Dock(TOP)
	RecipeDesc:DockMargin(5,0,0,5)
	RecipeDesc:SetFont("ixSmallFont")
	RecipeDesc:SetContentAlignment(7)
	RecipeDesc:SetText( recipeData.desc )
	RecipeDesc:SetWrap(true)
	RecipeDesc:SetTall(100)
	RecipeDesc:SetMouseInputEnabled(false)

	local CraftMaterialsText = vgui.Create( "DLabel", self.RightColumn )
	CraftMaterialsText:Dock(TOP)
	CraftMaterialsText:DockMargin(0,5,0,2)
	CraftMaterialsText:SetFont("ixMenuButtonLabelFont")
	CraftMaterialsText:SetContentAlignment(4)
	CraftMaterialsText:SetText( "Crafting Materials:")
	CraftMaterialsText:SizeToContents()
	CraftMaterialsText:SetMouseInputEnabled(false)

	local CraftMaterialsPnl = vgui.Create( "DPanel", self.RightColumn )
	CraftMaterialsPnl:Dock(FILL)
	CraftMaterialsPnl:DockMargin(0,0,0,5)
	CraftMaterialsPnl.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

	end

	local CraftMaterialScroll = vgui.Create( "DScrollPanel", CraftMaterialsPnl )
	CraftMaterialScroll:Dock(FILL)
	CraftMaterialScroll:DockMargin(5,5,5,5)
	CraftMaterialScroll.Paint = function(s,w,h)
	end

	local char = LocalPlayer():GetCharacter()
	local inv = char:GetInventory()

	local itemQuantity = 1

	for k, v in SortedPairs(recipeData.tools or {}) do

		local itemTable = ix.item.list[v]

		if (!itemTable) then continue end

		local MaterialPnl = vgui.Create( "DPanel", CraftMaterialScroll )
		MaterialPnl:Dock(TOP)
		MaterialPnl:DockMargin(0,0,0,5)
		MaterialPnl:SetTall(40)
		MaterialPnl.Paint = function(s,w,h)
			surface.SetDrawColor( (inv:HasItem(v) and Color(39, 174, 96,150)) or Color(192, 57, 43,150))
		    surface.DrawRect(0,0,w,h)

		end
		MaterialPnl.ChangeNumbers = function(s)
		end

		local MaterialPnlText = vgui.Create( "DLabel", MaterialPnl )
		MaterialPnlText:Dock(FILL)
		MaterialPnlText:DockMargin(5,0,0,0)
		MaterialPnlText:SetFont("ixMenuButtonLabelFont")
		MaterialPnlText:SetContentAlignment(4)
		MaterialPnlText:SetText( itemTable.name or "Unknown" )
		MaterialPnlText:SizeToContents()
		MaterialPnlText:SetMouseInputEnabled(false)
		
	end

	for k, v in SortedPairs(recipeData.req or {}) do

		local itemTable = ix.item.list[k]

		if (!itemTable) then continue end

		-- local itemCount = inv:GetItemCount(k)

		local MaterialPnl = vgui.Create( "DPanel", CraftMaterialScroll )
		MaterialPnl:Dock(TOP)
		MaterialPnl:DockMargin(0,0,0,5)
		MaterialPnl:SetTall(40)
		MaterialPnl.Paint = function(s,w,h)
			surface.SetDrawColor( (inv:GetItemCount(k) < (v*itemQuantity) and Color(192, 57, 43,150)) or Color(39, 174, 96,150))
		    surface.DrawRect(0,0,w,h)

		end
		MaterialPnl.ChangeNumbers = function(s, itemQuantity)
			s:GetChild(0):SetText( itemTable.name .. " ["..inv:GetItemCount(k).."/"..(v*itemQuantity).."]" or "Unknown" )
		end

		local MaterialPnlText = vgui.Create( "DLabel", MaterialPnl )
		MaterialPnlText:Dock(FILL)
		MaterialPnlText:DockMargin(5,0,0,0)
		MaterialPnlText:SetFont("ixMenuButtonLabelFont")
		MaterialPnlText:SetContentAlignment(4)
		MaterialPnlText:SetText( itemTable.name .. " ["..inv:GetItemCount(k).."/"..(v*itemQuantity).."]" or "Unknown" )
		MaterialPnlText:SizeToContents()
		MaterialPnlText:SetMouseInputEnabled(false)
		MaterialPnlText.NextCheck = CurTime()
		MaterialPnlText.Think = function(s)

			if (s.NextCheck < CurTime()) then

				s:SetText( itemTable.name .. " ["..inv:GetItemCount(k).."/"..(v*itemQuantity).."]" or "Unknown" )
				s.NextCheck = CurTime() + 0.5

			end

		end
		
	end

	local CraftQuantityPnl = vgui.Create( "Panel", self.RightColumn )
	CraftQuantityPnl:Dock(BOTTOM)
	CraftQuantityPnl:DockMargin(0,0,0,5)
	CraftQuantityPnl:SetZPos(2)
	CraftQuantityPnl:SetTall(30)

	local CraftQuantityPnlText = vgui.Create( "DLabel", CraftQuantityPnl )
	CraftQuantityPnlText:Dock(LEFT)
	CraftQuantityPnlText:DockMargin(0,0,15,0)
	CraftQuantityPnlText:SetFont("ixMenuButtonLabelFont")
	CraftQuantityPnlText:SetContentAlignment(4)
	CraftQuantityPnlText:SetText( "Crafting Quantity:")
	CraftQuantityPnlText:SizeToContents()
	CraftQuantityPnlText:SetMouseInputEnabled(false)

	local CraftQuantityPnlText_TE = vgui.Create( "DNumberWang", CraftQuantityPnl )
	CraftQuantityPnlText_TE:Dock( FILL )
	CraftQuantityPnlText_TE:SetFont("ixMediumFont")
	CraftQuantityPnlText_TE:SetValue( 1 )
	CraftQuantityPnlText_TE:SetMin(1)
	CraftQuantityPnlText_TE:SetMax(10)
	CraftQuantityPnlText_TE:SetDecimals(0)
	CraftQuantityPnlText_TE:SetDisabled(true)
	CraftQuantityPnlText_TE.Paint = function(s,w,h)
		
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

	    s:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))

	end
	CraftQuantityPnlText_TE.OnValueChanged = function(s, val)

		itemQuantity = val

		for k, v in pairs(CraftMaterialScroll:GetCanvas():GetChildren() or {}) do
			v:ChangeNumbers(itemQuantity)
		end

	end
	-- CraftQuantityPnlText_TE.OnEnter = function( s )
	-- 	chat.AddText( s:GetValue() )
	-- end

	local CraftItemBtn = vgui.Create( "ixMenuButton", self.RightColumn)
	CraftItemBtn:Dock(BOTTOM)
	-- ClaimItemsButton:DockMargin(0,0,0,0)
	CraftItemBtn:SetZPos(1)
	CraftItemBtn:SetFont("ixMenuButtonLabelFont")
	CraftItemBtn:SetText("Craft")
	CraftItemBtn:SetAutoStretchVertical(true)
	CraftItemBtn:SetContentAlignment(5)
	CraftItemBtn.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		net.Start("ixSetorianCraft_AddToQueue")
			net.WriteEntity(self.table)
			net.WriteString(recipeData.recipeid)
			net.WriteUInt(itemQuantity, 4)
		net.SendToServer()

		-- timer.Simple(0.1, function()
		-- 	self:RenderDetails(recipeData)
		-- end)

	end

end

function PANEL:CheckQueue(queueList)

	for k, v in ipairs(queueList) do

		local recipeTable = PLUGIN.craft.recipes[v.recipeID]
		
		self:AddItemToQueue(recipeTable)

	end

	for k, v in ipairs(queueList) do

		local itemList = self.queueItems[k]

		if (CurTime() >= v.craftFinish) then
			itemList:FinishCrafting()
			itemList.BarAnim = 1
		else

			local timeLeft =  5 - (v.craftFinish - CurTime())

			timeLeft = timeLeft / 5

			itemList.BarAnim = timeLeft

			break

		end

	end

end

function PANEL:CleanQueue()

	local itemsToDelete = {}

	for k, v in ipairs(self.queueItems) do

		if (v.Finished) then

			itemsToDelete[#itemsToDelete+1] = k
			v:Remove()

		end

	end

	for k, v in SortedPairs(itemsToDelete, true) do
		table.remove(self.queueItems, v)
	end

	self.queueNumber = self.queueNumber - #itemsToDelete
	self.QueueText:SetText( "Crafting Queue: "..self.queueNumber.."/12" )

end

function PANEL:AddItemToQueue(recipeTable)

	if (self.queueNumber >= 12) then
		LocalPlayer():Notify("The queue is full.")
		return
	end

	local recipeID = recipeTable.uniqueID

	self.queueNumber = self.queueNumber + 1
	self.QueueText:SetText( "Crafting Queue: "..self.queueNumber.."/12" )

	local ListItem = self.QueueList:Add( "DButton" )
	ListItem:SetSize( 70, 70 )
	ListItem:SetText("")
	ListItem.recipeTable = recipeTable
	ListItem.BarAnim = 0
	-- ListItem.NextTick = CurTime()
	-- ListItem.Progress = 0
	ListItem.Finished = false
	ListItem.PaintOver = function(s,w,h)

		if (self.processqueueitem == s) then
			s.BarAnim = math.Clamp(s.BarAnim + 0.2 * RealFrameTime(), 0, 1)
	    	-- s.BarAnim = Lerp(0.1, s.BarAnim, s.BarAnim)
	    end

	    if (s.BarAnim == 1) and (!s.Finished) then
	    	s:FinishCrafting()
	    end

		surface.SetDrawColor(46, 204, 113,50)
	    surface.DrawRect(0,70 - 70 * s.BarAnim,w,h)

		draw.SimpleTextOutlined( math.Round(s.BarAnim * 100, 0).."%", "ixSmallFont", w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(20,20,20))

		if (s:IsHovered()) and (!s.Finished) and (s.BarAnim == 0) then
			draw.SimpleTextOutlined("G", "ixIconsBig", w/2, h/2, Color( 250,120,120, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(20,20,20, 50))
		end

	end
	-- ListItem.Think = function(s)

	-- 	if (self.processqueueitem == s) and (!s.Finished) then
	-- 		if (s.NextTick < CurTime()) then
	-- 			s.Progress = s.Progress + 1
	-- 			s.NextTick = CurTime() + 1

	-- 			if (s.Progress == 5) then
	-- 		    	s:FinishCrafting()
	-- 		    end

	-- 		end
	-- 	end

	-- end
	ListItem.DoClick = function(s,w,h)

		if (!s:IsHovered()) then return end
		if (s.Finished) then return end
		if (s.BarAnim != 0) then return end

		surface.PlaySound("helix/ui/press.wav")

		for k, v in ipairs(self.queueItems) do

			if (v == s) then

				net.Start("ixSetorianCraft_RemoveFromQueue")
					net.WriteEntity(self.table)
					net.WriteUInt(k, 4)
				net.SendToServer()

				table.remove(self.queueItems, k)
				s:Remove()

				self.queueNumber = self.queueNumber - 1
				self.QueueText:SetText( "Crafting Queue: "..self.queueNumber.."/12" )

				break

			end

		end

	end
	ListItem.FinishCrafting = function(s)

		s.Finished = true
		self.processqueueitem = nil

		for k, v in ipairs(self.queueItems) do

			if (v.Finished) then continue end
			if (v == s) then continue end

			if (!self.processqueueitem) then
				self.processqueueitem = v
				break
			end
			
		end

	end

	self.queueItems[#self.queueItems+1] = ListItem

	if (!self.processqueueitem) then
		self.processqueueitem = ListItem
	end

	local RecipeModel = vgui.Create( "SpawnIcon" , ListItem )
	RecipeModel:SetPos(5,5)
	RecipeModel:SetSize(60,60)
	RecipeModel:SetModel( recipeTable.model or "models/error.mdl" )
	RecipeModel:SetTooltip(false)
	RecipeModel:SetMouseInputEnabled(false)
	RecipeModel.PaintOver = function(s)
	end

end

vgui.Register("ixSetorianCraftingUI", PANEL, "DFrame")

if (IsValid(ix.gui.SetorianCraftingUI)) then
	ix.gui.SetorianCraftingUI:Close()
end

-- vgui.Create("ixSetorianCraftingUI")