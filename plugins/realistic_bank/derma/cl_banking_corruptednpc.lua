
local PLUGIN = PLUGIN
-- local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(ScrW(),ScrH())
	self:Center()
	self:MakePopup()
	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)


	self.Paint = function(s,w,h)

		//Background
	    -- surface.SetDrawColor( 44, 62, 80, 250 )
	    -- surface.SetDrawColor(24, 37, 52, 100)
	    surface.SetDrawColor(47, 54, 64, 255)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(53, 59, 72, 255)
	    surface.DrawRect(5,5,w-10,h-10)

	    surface.SetDrawColor(47, 54, 64, 255)
	    surface.DrawRect(5,5,w-10,5+48)

	    draw.SimpleText("Corrupted Bankier", "ix3D2DMediumFont", 12,5, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)


	    //property type bg

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(0,65,w,45)

	    -- draw.DrawText("Choose property's type", "ixMediumLightFont", 10,75, Color( 240,240,240 ), TEXT_ALIGN_LEFT)

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(0,5+48,w,5)


	end

	local modelFOV = (ScrW() > ScrH() * 1.8) and 41 or 21

	local char = LocalPlayer():GetCharacter()

	local plyModel = char:GetModel()

	local Character = vgui.Create( "ixModelPanel", self )
	Character:Dock(RIGHT)
	Character:SetWide(ScreenScale(160))
	-- Character:SetPos( self:GetWide()/2 - Character:GetWide()*1.7, 150)
	Character:SetModel(plyModel or "models/Humans/Group01/Male_04.mdl")
	Character:SetFOV(modelFOV)
	Character:SetMouseInputEnabled(false)
	Character.enableHook = true
	Character.PaintModel = Character.Paint
	-- Character.PaintOver = function(s,w,h)
	-- 	surface.SetDrawColor(14, 27, 42, 50)
	--     surface.DrawRect(0,0,w,h)
	-- end

	Character.Entity:SetPos(Vector(0,0,-10))
	Character.LayoutEntity = function( s, entity )
	
		local scrW, scrH = ScrW(), ScrH()
		local xRatio = gui.MouseX() / scrW
		local yRatio = gui.MouseY() / scrH
		local x, _ = s:LocalToScreen(s:GetWide() / 2)
		local xRatio2 = x / scrW
		local entity = s.Entity

		entity:SetPoseParameter("head_pitch", yRatio*90 - 30)
		entity:SetPoseParameter("head_yaw", (xRatio - xRatio2)*90 - 5)
		entity:SetAngles(Angle(0,20,0))
		entity:SetIK(false)

		if (s.copyLocalSequence) then
			entity:SetSequence(LocalPlayer():GetSequence())
			entity:SetPoseParameter("move_yaw", 360 * LocalPlayer():GetPoseParameter("move_yaw") - 180)
		end

		s:RunAnimation()
	end

	Character.Entity:SetSkin( char:GetData("skin", 0) )
	for bodygroup, value in pairs (char:GetData("groups", {})) do
		Character.Entity:SetBodygroup( bodygroup, value )
	end

	timer.Simple(0.2, function()

		if (char:GetHeadmodel() and string.find(char:GetHeadmodel(), "models") and char:GetHeadmodel() != NULL and char:GetHeadmodel() != "" and char:GetHeadmodel() != nil) then
			self:WearPlyHead(char:GetHeadmodel())
		end

		local inv = char:GetInventory()

		if (inv) then

			for k, v in pairs(inv:GetItems()) do

				if (v:GetData("equip")) then
					if (v.pacData) then
						self:WearPac(v.uniqueID)
					end
				end
			end
		end
	end)

	self.PlyCharacter = Character


	////

	local Character = vgui.Create( "DModelPanel", self )
	Character:Dock(LEFT)
	Character:SetWide(ScreenScale(160))
	Character:SetModel("models/gman_high.mdl")
	Character:SetFOV(modelFOV)
	Character:SetAnimated(true)
	Character:SetMouseInputEnabled(false)
	Character.PaintModel = Character.Paint
	-- Character.PaintOver = function(s,w,h)
	-- 	surface.SetDrawColor(14, 27, 42, 50)
	--     surface.DrawRect(0,0,w,h)
	-- end

	
	-- if (idleAnim <= 0) then
	-- 	idleAnim = Character.Entity:SelectWeightedSequence(ACT_BUSY_QUEUE)
	-- end

	function Character:LayoutEntity( Entity )
	
		Entity:SetAngles(Angle(0,70,0) )
		Entity:SetPos(Vector(0,0,-10) )


	-- 	-- if (idleAnim <= 0) then
			Entity:ResetSequence(Entity:LookupSequence("tiefidget"))
	-- 	-- end

		
		Character:RunAnimation()	
		return
	end


	self.NPCCharacter = Character

	local GreetingMsg = vgui.Create( "DPanel", self )
	GreetingMsg:Dock(TOP)
	GreetingMsg:SetTall(self:GetTall()*0.05)
	GreetingMsg:DockMargin(0,39,20,20)
	GreetingMsg.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,false,true)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4, Color(240,240,240),true,true,false,true)

		draw.SimpleText("What do you want from me?", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end


	local MainPanel = vgui.Create( "DPanel", self )
	MainPanel:Dock(FILL)
	MainPanel:DockMargin(0,0,20,30)
	MainPanel.CurrentAlpha = 255
	MainPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(214, 27, 42, 50)
	 --    surface.DrawRect(0,0,w,h)
	end

	self.mainPanel = MainPanel


	self:SlideDown(0.5)
	self:AlphaTo(255, 0.3, 0.2, function() self:RenderMenu(1) end)

end

function PANEL:WearPlyHead(HeadModel)

	if (HeadModel == "") then return end

	if (IsValid(self.PlyCharacter)) then

		if (IsValid(self.PlyCharacter.Entity.headmodel)) then
			self.PlyCharacter.Entity.headmodel:SetModel(HeadModel)
		else

			local ent = self.PlyCharacter.Entity

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

	if (itemTable) then

		if (itemTable.pacAdjust) then
			pacData = table.Copy(pacData)
			pacData = itemTable:pacAdjust(pacData, self.PlyCharacter.Entity)
		end

		if (itemTable.bodyGroups) then
			
			for k, v in pairs(itemTable.bodyGroups) do
				local index = self.PlyCharacter.Entity:FindBodygroupByName(k)

				if (index > -1) then
					self.PlyCharacter.Entity:SetBodygroup(index, v)
				end
			end
			
		end

	end

	if (isfunction(self.PlyCharacter.Entity.AttachPACPart)) then
		self.PlyCharacter.Entity:AttachPACPart(pacData, LocalPlayer(), false)
		

	else
		pac.SetupENT(self.PlyCharacter.Entity)
		
		timer.Simple(0.1, function()
			if (IsValid(self.PlyCharacter.Entity) and isfunction(self.PlyCharacter.Entity.AttachPACPart)) then
				self.PlyCharacter.Entity:AttachPACPart(pacData, LocalPlayer(), false)
			end

		end)
	end

	

end

function PANEL:RenderMenu(bMenu, noAnim)

	if (bMenu == 0) then
		
		self:SlideUp(0.5)
		self:AlphaTo(0, 0.3, 0.2, function() self:Close() end)
	end

	if (noAnim) then
		self.mainPanel:Clear()

		if (bMenu == 1) then
			self:RenderOptions()
		elseif (bMenu == 2) then
			self:CleanMoneyMenu()
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


				if (bMenu == 1) then
					self:RenderOptions()
				elseif (bMenu == 2) then
					self:CleanMoneyMenu()
				end


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

end


function PANEL:RenderOptions()


	local MenuButtons = {
		[1] = {
			Display = "I would like you to clean that money",
			Menu = 2,
		},
		[2] = {
			Display = "Goodbye",
			Menu = 0,
		},
	}
	
	for k, v in SortedPairs(MenuButtons) do

		local Button1 = vgui.Create( "DButton", self.mainPanel )
		Button1:SetText( "" )
		Button1:Dock(TOP)
		Button1:DockMargin(ScreenScale(35),(k == 1 and ScreenScale(35)) or 20,ScreenScale(35),0)
		Button1:SetTall(50)
		Button1.Paint = function(s,w,h)
			draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,true,false)
			draw.RoundedBoxEx(25, 2,2,w-4,h-4, (s:IsHovered() and Color(200,200,200)) or Color(240,240,240),true,true,true,false)

			draw.SimpleText(v.Display, "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Button1.DoClick = function()
			self:RenderMenu(v.Menu)
		end
		Button1.OnCursorEntered = function()
			surface.PlaySound("helix/ui/rollover.wav")
		end

	end

end

function PANEL:CleanMoneyMenu()

	local char = LocalPlayer():GetCharacter()
	local inv = char:GetInventory()

	local foundBag = false

	local moneyCount = 0

	local splitforNPC = 58

	for k, v in pairs(inv:GetItems()) do
		if (v.uniqueID != "duffelbag") then continue end

		moneyCount = moneyCount + (5000 * v:getStacks())

	end

	splitforNPC = math.Round(splitforNPC - math.min(25,moneyCount/2500),0)

	if (moneyCount == 0) then
		self:RenderMenu(1, true)
		LocalPlayer():Notify("You don't have any money bags")
		return
	end

	local BackButton = vgui.Create( "DButton", self.mainPanel )
	BackButton:SetText( "" )
	BackButton:Dock(BOTTOM)
	BackButton:DockMargin(ScreenScale(35),0,ScreenScale(35),50)
	BackButton:SetTall(50)
	BackButton.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,true,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4, (s:IsHovered() and Color(200,200,200)) or Color(240,240,240),true,true,true,false)

		draw.SimpleText("Back", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	BackButton.DoClick = function()
		self:RenderMenu(1)
	end
	BackButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end

	local InfoPanel = vgui.Create( "DPanel", self.mainPanel )
	InfoPanel:Dock(TOP)
	InfoPanel:DockMargin(ScreenScale(35),ScreenScale(35),ScreenScale(35),0)
	InfoPanel:SetTall(80)
	InfoPanel.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,false,true)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4,  Color(240,240,240),true,true,false,true)
	end

	local InfoPanelText = vgui.Create( "DLabel", InfoPanel )
	InfoPanelText:Dock(TOP)
	InfoPanelText:DockMargin(15,15,5,0)
	InfoPanelText:SetFont("ixMediumFont")
	InfoPanelText:SetTextColor(Color(20,20,20))
	InfoPanelText:SetWrap(true)
	InfoPanelText:SetText("Money in the bags: "..ix.currency.Get(moneyCount).."\nIn this case, we'll split them like this: For me "..splitforNPC.."%, for you "..100 - splitforNPC.."%.")
	InfoPanelText:SetAutoStretchVertical(true)

	local AgreeButton = vgui.Create( "DButton", self.mainPanel )
	AgreeButton:SetText( "" )
	AgreeButton:Dock(BOTTOM)
	AgreeButton:DockMargin(ScreenScale(35),0,ScreenScale(35),15)
	AgreeButton:SetTall(50)
	AgreeButton.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,true,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4, (s:IsHovered() and Color(200,200,200)) or Color(240,240,240),true,true,true,false)

		draw.SimpleText("Agree", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	AgreeButton.DoClick = function()

		netstream.Start("JBanking_CleanMoney")
		self:RenderMenu(1)
		
	end
	AgreeButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end

end


vgui.Register("ixBanking_CorruptedNPCMenu", PANEL, "DFrame")

-- vgui.Create("ixBanking_CorruptedNPCMenu")