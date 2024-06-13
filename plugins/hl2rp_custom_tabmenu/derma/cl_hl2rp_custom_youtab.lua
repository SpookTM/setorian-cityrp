
local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

local dollar = Material("hl2rp_custom_tab_menu/dollar.png", "noclamp smooth")

local thrist = Material("hl2rp_custom_tab_menu/water.png")
local food = Material("hl2rp_custom_tab_menu/pizza.png", "noclamp smooth")
local hp = Material("hl2rp_custom_tab_menu/heart.png", "noclamp smooth")

local sprint = Material("hl2rp_custom_tab_menu/run.png", "noclamp smooth")

function PANEL:Init()
-- frame:SetSize(800,550)

	self:Dock(FILL)
	-- self:Center()
	-- self:MakePopup()
	local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self.Paint = function(s,w,h)


		//Background
	    -- surface.SetDrawColor( 44, 62, 80, 250 )
	    -- surface.SetDrawColor(24, 37, 52, 100)
	    -- surface.SetDrawColor(14, 27, 42, 255)
	    -- surface.DrawRect(0,0,w,h)


	end

	-- local modelFOV = (ScrW() > ScrH() * 1.8) and 40 or 30

	-- local char = LocalPlayer():GetCharacter()

	-- local plyModel = char:GetModel()

	local CharPnl = vgui.Create( "ixModelPanel", self )
	CharPnl:Dock(LEFT)
	CharPnl:SetWide(ScreenScale(200))
	-- Character:SetPos( self:GetWide()/2 - Character:GetWide()*1.7, 150)
	-- Character:SetModel(plyModel or "models/Humans/Group01/Male_04.mdl")
	-- Character:SetFOV(modelFOV)
	-- Character.enableHook = true
	-- Character:SetMouseInputEnabled(false)
	-- Character.PaintModel = Character.Paint
	-- Character.PaintOver = function(s,w,h)
	-- 	surface.SetDrawColor(14, 27, 42, 50)
	--     surface.DrawRect(0,0,w,h)
	-- end

	-- Character.Entity:SetPos(Vector(0,0,-10))

	-- Character.Entity:SetSkin( char:GetData("skin", 0) )
	-- for bodygroup, value in pairs (char:GetData("groups", {})) do
	-- 	Character.Entity:SetBodygroup( bodygroup, value )
	-- end

	self.CharPnl = CharPnl


	local CharPnlInfo = vgui.Create( "ixModelPanel", CharPnl )
	CharPnlInfo:Dock(FILL)
	CharPnlInfo:SetZPos(2)

	-- ix.gui.characterpanelmodel = Character

	local suppress = {}
	hook.Run("CanCreateCharacterInfo", suppress)


	local NameAndDesc = vgui.Create( "DPanel", CharPnlInfo )
	NameAndDesc:Dock(TOP)
	NameAndDesc:DockMargin(50,ScreenScale(140),50,0)
	NameAndDesc:SetTall(50)
	NameAndDesc.Paint = function(s,w,h)
		surface.SetDrawColor(50,50,50, 230)
	    surface.DrawRect(0,ScreenScale(20),w,h)

	    //top bar
	    surface.SetDrawColor(40,40,40,250)
	    -- surface.DrawRect(0,0,w,54)
	    surface.DrawRect(0,0,w,ScreenScale(20))
	end

	if (!suppress.name) then
		self.name = NameAndDesc:Add("ixLabel")
		self.name:Dock(TOP)
		self.name:DockMargin(0, 0, 0, 0)
		self.name:SetFont("ixMenuButtonFont")
		self.name:SetContentAlignment(5)
		self.name:SetTextColor(color_white)
		self.name:SetPadding(8)
		self.name:SetScaleWidth(true)
		self.name:SetText(LocalPlayer():GetCharacter():GetName())
		self.name:SizeToContents()
	end
	
	if (!suppress.description) then
		self.description = NameAndDesc:Add("DLabel")
		self.description:Dock(TOP)
		self.description:DockMargin(10, 5, 10, 8)
		self.description:SetFont("ixMenuButtonFontSmall")
		self.description:SetTextColor(color_white)
		self.description:SetContentAlignment(5)
		-- self.description:SetTextInset(10,5)
		self.description:SetMouseInputEnabled(true)
		self.description:SetCursor("hand")

		-- self.description.Paint = function(this, width, height)
		-- 	surface.SetDrawColor(50,50,50, 230)
		-- 	surface.DrawRect(0, 0, width, height)
		-- end

		self.description.OnMousePressed = function(this, code)
			if (code == MOUSE_LEFT) then
				ix.command.Send("CharDesc")

				if (IsValid(ix.gui.menu)) then
					ix.gui.menu:Remove()
				end
			end
		end

		-- self.description.SizeToContents = function(this)
		-- 	if (this.bWrap) then
		-- 		-- sizing contents after initial wrapping does weird things so we'll just ignore (lol)
		-- 		return
		-- 	end

		-- 	local width, height = this:GetContentSize()

		-- 	if (width > self:GetWide()) then
		-- 		this:SetWide(self:GetWide())
		-- 		this:SetTextInset(16, 8)
		-- 		this:SetWrap(true)
		-- 		this:SizeToContentsY()
		-- 		this:SetTall(this:GetTall()) -- eh

		-- 		-- wrapping doesn't like middle alignment so we'll do top-center
		-- 		self.description:SetContentAlignment(8)
		-- 		this.bWrap = true
		-- 	else
		-- 		this:SetSize(width + 16, height)
		-- 	end
		-- end

		local WrappedDesc = ix.util.WrapText(LocalPlayer():GetCharacter():GetDescription(), 380, "ixMenuButtonFontSmall")

		local WrappedDescString = string.Trim(table.concat( WrappedDesc, "\n"))

		self.description:SetText(WrappedDescString)
		self.description:SizeToContents()

	end

	NameAndDesc:InvalidateLayout( true )
	NameAndDesc:SizeToChildren( true, true )

	NameAndDesc:SetTall(NameAndDesc:GetTall()+5)

	if (!suppress.money) then
	local MoneyPanel = vgui.Create( "DPanel", CharPnlInfo )
		MoneyPanel:SetPos(5,5)
		MoneyPanel:SetSize(300,40)
		MoneyPanel.Paint = function(this, width, height)
			surface.SetDrawColor( 250,250,250 )
		    surface.SetMaterial( dollar )
			surface.DrawTexturedRect(0,0,40,40)
		end

		self.Money = MoneyPanel:Add("ixLabel")
		self.Money:Dock(LEFT)
		self.Money:DockMargin(40, 0, 0, 0)
		self.Money:SetFont("ixMenuMiniFont")
		self.Money:SetContentAlignment(4)
		self.Money:SetTextColor(color_white)
		self.Money:SetPadding(8)
		self.Money:SetScaleWidth(true)
		self.Money:SetText(ix.currency.Get(LocalPlayer():GetCharacter():GetMoney()))
		self.Money:SizeToContents()
	end


	local faction = ix.faction.indices[LocalPlayer():GetCharacter():GetFaction()]

	local formatTime = "%A, %B %d, %Y. %H:%M"

	local InventoryPanel = vgui.Create( "DPanel", self )
	InventoryPanel:Dock(TOP)
	InventoryPanel:DockMargin(15,0,0,0)
	-- InventoryPanel:SetSize(300,40)
	InventoryPanel:SetTall(ScreenScale(150))
	InventoryPanel.Paint = function(s, w, h)
		surface.SetDrawColor(50,50,50, 230)
		surface.DrawRect(0, 0, w, h)


		//top bar
	    surface.SetDrawColor(40,40,40,250)
	    -- surface.DrawRect(0,0,w,50)
	    surface.DrawRect(0,0,w,ScreenScale(17))

	    draw.SimpleText("Inventory", "ixMenuButtonFont", 5, 5, Color( 250, 250, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)


	 --    //bottom bar
	 --    surface.SetDrawColor(40,40,40,250)
	 --    surface.DrawRect(0,h-40,w,40)

	 --    if (!suppress.faction) then
		--     draw.SimpleText(L("faction") .. ": " ..faction.name, "ixMenuButtonFontSmall", ScreenScale(150/3), h-5, Color( 250, 250, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		-- end

	 --    if (!suppress.time) then
		--     draw.SimpleText(ix.date.GetFormatted(formatTime), "ixMenuButtonFontSmall", ScreenScale(150/3) * 4, h-5, Color( 250, 250, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		-- end

	end

	//Inventory

	local canvas = InventoryPanel:Add("DTileLayout")
	local canvasLayout = canvas.PerformLayout
	canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
	canvas:SetBorder(0)
	canvas:SetSpaceX(2)
	canvas:SetSpaceY(2)
	canvas:Dock(FILL)
	canvas:DockMargin(2,ScreenScale(17),2,250)

	ix.gui.menuInventoryContainer = canvas

	local panel = canvas:Add("ixInventory")
	panel:SetPos(0, 0)
	panel:SetDraggable(false)
	panel:SetSizable(false)
	panel:SetTitle(nil)
	panel.bNoBackgroundBlur = true
	panel.childPanels = {}

	local inventory = LocalPlayer():GetCharacter():GetInventory()

	if (inventory) then
		panel:SetInventory(inventory)
	end

	ix.gui.inv1 = panel

	if (ix.option.Get("openBags", true)) then
		for _, v in pairs(inventory:GetItems()) do
			if (!v.isBag) then
				continue
			end

			v.functions.View.OnClick(v)
		end
	end

	canvas.PerformLayout = canvasLayout
	-- canvas:Layout()

	InventoryPanel:SetTall(panel:GetTall() + ScreenScale(17) + 40)

	local InventoryBottomBar = vgui.Create( "DPanel", InventoryPanel )
	InventoryBottomBar:Dock(BOTTOM)
	-- InventoryBottomBar:DockMargin(ScreenScale(50),0,0,0)
	InventoryBottomBar:SetTall(ScreenScale(13))
	InventoryBottomBar.Paint = function(s, w, h)
		surface.SetDrawColor(40,40,40,250)
	    surface.DrawRect(0,0,w,h)

        if (!suppress.faction) then
		    draw.SimpleText(L("faction") .. ": " ..faction.name, "ixMenuButtonFontSmall", ScreenScale(60), 5, Color( 250, 250, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

	    if (!suppress.time) then
		    draw.SimpleText(ix.date.GetFormatted(formatTime), "ixMenuButtonFontSmall", ScreenScale(50) * 4, 5, Color( 250, 250, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

	end
	InventoryBottomBar:MoveToFront()


	local CharStatsPanel = vgui.Create( "DPanel", self )
	CharStatsPanel:Dock(FILL)
	CharStatsPanel:DockMargin(15,ScreenScale(10),0,0)
	-- CharStatsPanel:SetTall(200)
	CharStatsPanel.Paint = function(s, w, h)
		surface.SetDrawColor(50,50,50, 230)
		surface.DrawRect(0, 0, w, h)

		//top bar
	    surface.SetDrawColor(40,40,40,250)
	    surface.DrawRect(0,0,w,ScreenScale(17))

	    draw.SimpleText("Statistics", "ixMenuButtonFont", ScreenScale(60), 5, Color( 250, 250, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

	    draw.SimpleText("Attributes", "ixMenuButtonFont", ScreenScale(50) * 5, 5, Color( 250, 250, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)


	end


	-- local thirstVal = math.Round(1 - LocalPlayer():GetHungerPercent(), 2) * 100
	local thirstVal = math.Clamp(LocalPlayer():GetThirst(), 0, 100)
	local hungerVal = math.Clamp(LocalPlayer():GetHunger(), 0, 100)
	local plyhp = LocalPlayer():Health()

	-- print(thirstVal)
	-- print(LocalPlayer():GetThirst() / 100)

	local StatsPanel = vgui.Create( "DPanel", CharStatsPanel )
	StatsPanel:Dock(LEFT)
	StatsPanel:DockMargin(0,ScreenScale(17),0,0)
	StatsPanel:SetWide(ScreenScale(190))
	StatsPanel.Paint = function(s, w, h)


		surface.SetDrawColor( 52, 152, 219 )
	    surface.SetMaterial( thrist )
		surface.DrawTexturedRect(10,10,ScreenScale(12),ScreenScale(12))

		surface.SetDrawColor(30,30,30)
		surface.DrawRect(55, ScreenScale(9), w - 165, 10)

		// GetHungerPercent
		surface.SetDrawColor(52, 152, 219)
		surface.DrawRect(55, ScreenScale(9), ( (thirstVal * (w - 165) /100)), 10)

		draw.SimpleText(thirstVal, "ixMenuButtonFontSmall", w-60, ScreenScale(9)-1, Color( 250, 250, 250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


		surface.SetDrawColor( 230, 126, 34 )
	    surface.SetMaterial( food )
		surface.DrawTexturedRect(10,10 + ScreenScale(12) + 10,ScreenScale(12),ScreenScale(12))

		surface.SetDrawColor(30,30,30)
		surface.DrawRect(55, ScreenScale(25), w - 165, 10)

		// GetHungerPercent
		surface.SetDrawColor(230, 126, 34)
		surface.DrawRect(55, ScreenScale(25), ( (hungerVal * (w - 165)) /100), 10)

		draw.SimpleText(hungerVal, "ixMenuButtonFontSmall", w-60, ScreenScale(25) - 1 , Color( 250, 250, 250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


		surface.SetDrawColor( 230,120,120 )
	    surface.SetMaterial( hp )
		surface.DrawTexturedRect(10,10 + ScreenScale(12)*2 + 20,ScreenScale(12),ScreenScale(12))
	

		surface.SetDrawColor(30,30,30)
		surface.DrawRect(55, ScreenScale(40), w - 165, 10)

		// GetHungerPercent
		surface.SetDrawColor(230, 120,120)
		surface.DrawRect(55, ScreenScale(40), ( (plyhp * (w - 165)) /LocalPlayer():GetMaxHealth()), 10)

		draw.SimpleText(plyhp, "ixMenuButtonFontSmall", w-60, ScreenScale(40) - 1, Color( 250, 250, 250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


	end

	local AttribPanel = vgui.Create( "DScrollPanel", CharStatsPanel )
	AttribPanel:Dock(RIGHT)
	AttribPanel:DockMargin(0,ScreenScale(17) + 5,0,5)
	AttribPanel:SetWide(ScreenScale(190))
	-- AttribPanel.Paint = function(s, w, h)
	-- 	s:NoClipping(true)
	-- 	surface.SetDrawColor(50,50,50, 230)
	-- 	surface.DrawRect(0, -5, w, h+10)
	-- 	s:NoClipping(false)
	-- end
	-- 	surface.SetDrawColor(50,250,50, 230)
	-- 	surface.DrawRect(0, 0, w, h)

	-- end

	for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do

		local value = LocalPlayer():GetCharacter():GetAttribute(k, 0)
		local maximum = v.maxValue or ix.config.Get("maxAttributes", 100)

		local atrbIcon

		if (v.menuIcon) then
		atrbIcon = Material(v.menuIcon, "noclamp smooth")
		end

		SkillPanel = AttribPanel:Add( "DPanel" )
		SkillPanel:Dock( TOP )
		SkillPanel:DockMargin( 0,0,0, 5 )
		SkillPanel:SetTall(40)
		SkillPanel:SetHelixTooltip(function(tooltip)
				local name = tooltip:AddRow("name")
			    name:SetImportant()
			    name:SetText(v.name)
			    name:SizeToContents()

			    local desc = tooltip:AddRow("name", "desc")
			    desc:SetText(v.description)
			    desc:SizeToContents()

			    tooltip:SizeToContents()
			end)
		SkillPanel.Paint = function(s,w,h)
		
		-- surface.SetDrawColor(50,250,50, 230)
		-- surface.DrawRect(0, 0, w, h)

		-- if (atrbIcon) then
			surface.SetDrawColor( 255,255,255 )
		    surface.SetMaterial( atrbIcon or sprint)
			surface.DrawTexturedRect(5,5,ScreenScale(12),ScreenScale(12))
		-- end

		surface.SetDrawColor(30,30,30)
		surface.DrawRect(ScreenScale(12) + 15, h/2 - 5, w-(ScreenScale(12) + 20), 10)

		surface.SetDrawColor(230,230,230)
		surface.DrawRect(ScreenScale(12) + 15, h/2 - 5, ( (value * (w-(ScreenScale(12) + 20))) /maximum), 10)

		end

	end

end

function PANEL:CreateCharMdl(char)

	local modelFOV = (ScrW() > ScrH() * 1.8) and 40 or 30

	-- local char = LocalPlayer():GetCharacter()

	local plyModel = char:GetModel()

	if (self.Character) then
		self.Character:Remove()
	end

	local Character = vgui.Create( "DModelPanel", self.CharPnl )
	Character:Dock(FILL)
	Character:SetZPos(1)
	-- Character:SetPos(0,0)
	-- Character:SetSize(ScreenScale(200), self:GetParent():GetTall())
	-- Character:SetWide(ScreenScale(200))
	-- Character:SetPos( self:GetWide()/2 - Character:GetWide()*1.7, 150)
	Character:SetModel(plyModel or "models/Humans/Group01/Male_04.mdl")
	Character:SetFOV(modelFOV)
	-- Character.enableHook = true
	Character:SetMouseInputEnabled(false)
	Character.PaintModel = Character.Paint
	-- Character.PaintOver = function(s,w,h)
	-- 	surface.SetDrawColor(14, 27, 42, 50)
	--     surface.DrawRect(0,0,w,h)
	-- end
	Character.PostDrawModel = function(me, ent)

		if (ent.headmodel and IsValid(ent.headmodel)) then
			ent.headmodel:DrawModel()
		end

		if (!pac) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			pac.RenderOverride(ent, "opaque")
			pac.RenderOverride(ent, "translucent", true)
		end

		if (!me.pac_setup) then
            pac_setup = true
            me.pac_setup = true
            pac.SetupENT(ent)
        end

	end
	Character.LayoutEntity = function(self) 
		local scrW, scrH = ScrW(), ScrH()
		local xRatio = gui.MouseX() / scrW
		local yRatio = gui.MouseY() / scrH
		local x, _ = self:LocalToScreen(self:GetWide() / 2)
		local xRatio2 = x / scrW
		local entity = self.Entity

		entity:SetPoseParameter("head_pitch", yRatio*90 - 30)
		entity:SetPoseParameter("head_yaw", (xRatio - xRatio2)*90 - 5)
		entity:SetAngles(Angle(0, 45, 0))
		entity:SetIK(false)


		self:RunAnimation()
	end

	Character.Entity:SetPos(Vector(0,0,-10))

	local sequence = Character.Entity:LookupSequence("idle_unarmed")

	if (sequence <= 0) then
		sequence = Character.Entity:SelectWeightedSequence(ACT_IDLE)
	end
	
	if (sequence > 0) then
		Character.Entity:ResetSequence(sequence)
	else
		local found = false

		for _, v in ipairs(Character.Entity:GetSequenceList()) do
			if ((v:lower():find("idle") or v:lower():find("fly")) and v != "idlenoise") then
				Character.Entity:ResetSequence(v)
				found = true

				break
			end
		end

		if (!found) then
			Character.Entity:ResetSequence(4)
		end
	end

	Character.Entity:SetSkin( char:GetData("skin", 0) )
	for bodygroup, value in pairs (char:GetData("groups", {})) do
		Character.Entity:SetBodygroup( bodygroup, value )
	end

	self.Character = Character
	ix.gui.characterpanelmodel = Character

end

function PANEL:Update(character)
	if (!character) then
		return
	end

	local faction = ix.faction.indices[character:GetFaction()]
	local class = ix.class.list[character:GetClass()]

	self:CreateCharMdl(character)

	if (self.name) then
		self.name:SetText(character:GetName())

		self.name:SizeToContents()
	end

	if (self.description) then

		local WrappedDesc = ix.util.WrapText(LocalPlayer():GetCharacter():GetDescription(), 380, "ixMenuButtonFontSmall")

		local WrappedDescString = string.Trim(table.concat( WrappedDesc, "\n"))

		self.description:SetText(WrappedDescString)
		self.description:SizeToContents()
	end


	if (self.Money) then
		self.Money:SetText(ix.currency.Get(character:GetMoney()))
		self.Money:SizeToContents()
	end

	
	if (character:GetHeadmodel() and string.find(character:GetHeadmodel(), "models") and character:GetHeadmodel() != NULL and character:GetHeadmodel() != "" and character:GetHeadmodel() != nil) then
		self:WearPlyHead(character:GetHeadmodel())
	end

	self.Character.Entity:SetSkin( character:GetData("skin", 0) )
	for bodygroup, value in pairs (character:GetData("groups", {})) do
		self.Character.Entity:SetBodygroup( bodygroup, value )
	end

	-- 

	-- self:RemovePacs()

	timer.Simple(0.1, function()
		if (!self) or (!IsValid(self)) then return end
		self:HandlePAC()
	end)

	-- timer.Simple(0.1, function()

		-- local inv = character:GetInventory()
		-- -- print(character:GetInventory())

		-- if (inv) then
		-- 	-- PrintTable(inv:GetItems())
		-- 	for k, v in pairs(inv:GetItems()) do
		-- 		-- print(v)
		-- 		if (v:GetData("equip")) then
		-- 			if (v.pacData) then
		-- 				-- PrintTable(v.pacData)
		-- 				self:WearPac(v.uniqueID, self.Character)
		-- 			end
		-- 		end
		-- 	end
		-- end
	-- end)

	-- hook.Run("UpdateCharacterInfo", self.characterInfo, character)

	-- self.characterInfo:SizeToContents()

	-- hook.Run("UpdateCharacterInfoCategory", self, character)
end

function PANEL:WearPlyHead(HeadModel)

	if (HeadModel == "") then return end

	if (IsValid(self.Character)) then

		if (IsValid(self.Character.Entity.headmodel)) then
			self.Character.Entity.headmodel:SetModel(HeadModel)
		else

			local ent = self.Character.Entity

			local CHeadModel = ClientsideModel(HeadModel, RENDERGROUP_BOTH)

			if (CHeadModel) then
				-- CHeadModel:SetParent(ent)
				-- CHeadModel:AddEffects(EF_BONEMERGE)
				-- CHeadModel:SetNoDraw(true)
				CHeadModel:InvalidateBoneCache()
				CHeadModel:SetParent(ent)
				CHeadModel:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
				CHeadModel:SetupBones()
				CHeadModel:SetNoDraw(true)
				ent.headmodel = CHeadModel
				
			end
		end


	end

end

function PANEL:WearPac(pacName)

	local itemTable = ix.item.list[pacName]
	local pacData = ix.pac.list[pacName]

	if (!pacData) then return end
	if (!IsValid(self.Character.Entity)) then return end
	if (itemTable) then

		if (itemTable.pacAdjust) then
			pacData = table.Copy(pacData)
			pacData = itemTable:pacAdjust(pacData, self.Character.Entity)
		end

		if (itemTable.bodyGroups) then
			
			for k, v in pairs(itemTable.bodyGroups) do
				local index = self.Character.Entity:FindBodygroupByName(k)

				if (index > -1) then
					self.Character.Entity:SetBodygroup(index, v)
				end
			end
			
		end

	end

	if (isfunction(self.Character.Entity.AttachPACPart)) then
		self.Character.Entity:AttachPACPart(pacData, LocalPlayer(), false)
		

	else
		pac.SetupENT(self.Character.Entity)
		
		timer.Simple(0.1, function()
			if (IsValid(self.Character.Entity) and isfunction(self.Character.Entity.AttachPACPart)) then
				self.Character.Entity:AttachPACPart(pacData, LocalPlayer(), false)
			end

		end)
	end

	

end

function PANEL:RemoveOutFits()

    local pac_setup = pac_setup

    -- self.Character.PostDrawModel = function(me, ent)

    if (!IsValid(self.Character.Entity)) then return end

    for i = 0, (self.Character.Entity:GetNumBodyGroups() - 1) do
		self.Character.Entity:SetBodygroup(i, 0)
	end

    if (!pac) then
        return end

    if (self.Character.pac_setup) then
        -- pac_setup = true
        -- pac.SetupENT(ent)


        for k, oldOutf in pairs( self.Character.Entity.pac_outfits or {} ) do
        	-- print("usuwanie", k)
        	if (isfunction(self.Character.Entity.RemovePACPart)) then
	            self.Character.Entity:RemovePACPart( oldOutf:ToTable(), false )
            else
				pac.SetupENT(self.Character.Entity)
			end

        end

    end
    
    -- print(table.Count(ent.pac_outfits or {}))

    -- return false
    -- end

    
end


function PANEL:RemoveOutFits2(uniqueID)

	local pacData = ix.pac.list[uniqueID]

	if (pacData) then
		if (isfunction(self.Character.Entity.RemovePACPart)) then
			self.Character.Entity:RemovePACPart(pacData)
		else
			pac.SetupENT(self.Character.Entity)
		end
	end

end

function PANEL:SetPacOutfit2( uniqueID )

	local itemTable = ix.item.list[uniqueID]
	local pacData = ix.pac.list[uniqueID]

	if (!IsValid(self.Character.Entity)) then return end

    if (pacData) then

        local pac_setup = pac_setup

        -- self.Character.PostDrawModel = function(me, ent)
        local ent = self.Character.Entity

            if (!pac) then
            return end

            if (itemTable.bodyGroups) then
			
				for k, v in pairs(itemTable.bodyGroups) do
					local index = self.Character.Entity:FindBodygroupByName(k)

					if (index > -1) then
						self.Character.Entity:SetBodygroup(index, v)
					end
				end
				
			end

            if (self.Character.pac_setup) then
                ent:AttachPACPart(pacData, LocalPlayer())
            end

            return false
        -- end

    end
end


function PANEL:HandlePAC()

	local parts = LocalPlayer():GetParts()

	self:RemoveOutFits()

	for k2, _ in pairs(parts) do

		self:SetPacOutfit2(k2)
	end


end


-- function PANEL:Paint(width, height)
-- 	derma.SkinFunc("PaintCharacterCreateBackground", self, width, height)
-- 	BaseClass.Paint(self, width, height)
-- end

vgui.Register("ixCustomYouTAB", PANEL, "DFrame")

hook.Add("CreateMenuButtons", "ixCustomYOU", function(tabs)
	-- if (hook.Run("BuildBusinessMenu") != false) then
		tabs["overview"] = {
			bDefault = true,
			Create = function(info, container)
				container.OverViewPanel = container:Add("ixCustomYouTAB")
				ix.gui.youtab = container.OverViewPanel
			end,
			OnSelected = function(info, container)
				container.OverViewPanel:Update(LocalPlayer():GetCharacter())
			end,
		}
	-- end
end)