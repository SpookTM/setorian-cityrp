
local firstLoad = false

-- selection menu button
DEFINE_BASECLASS("ixMenuButton")
local PANEL = {}

function PANEL:Init()
	self.backgroundColor = color_white
	self.bganim = 0
	self:SetFont("Setorian_Creator_Font1")
end

function PANEL:PaintBackground(w,h)
	
	surface.SetDrawColor(20,20,20,150)
    surface.DrawRect(0,0,w,h)

    if (self:IsEnabled()) then

	    if (self:IsHovered()) then
			self.bganim = Lerp(FrameTime() * 5, self.bganim, 1)
		else
			self.bganim = Lerp(FrameTime() * 5, self.bganim, 0)
		end

		surface.SetDrawColor( 64, 115, 158, self.bganim * 200 )
		surface.DrawRect(0,0,w,h)

	end

	surface.SetDrawColor(80,80,80,200)
    surface.DrawOutlinedRect( 0,0,w,h,1)

end


vgui.Register("ix_Setorian_CustomButton", PANEL, "ixMenuButton")

local setorianLogo = ix.util.GetMaterial("Setorian_long1.png")

local gradient = surface.GetTextureID("vgui/gradient-d")
local audioFadeInTime = 2
local animationTime = 0.5
local matrixZScale = Vector(1, 1, 0.0001)
DEFINE_BASECLASS("ixSubpanelParent")

PANEL = {}

function PANEL:Init()
	self:SetSize(self:GetParent():GetSize())
	self:SetPos(0, 0)

	self.childPanels = {}
	self.subpanels = {}
	self.activeSubpanel = ""

	self.currentDimAmount = 0
	self.currentY = 0
	self.currentScale = 1
	self.currentAlpha = 255
	self.targetDimAmount = 255
	self.targetScale = 0
end

function PANEL:Dim(length, callback)
	length = length or animationTime
	self.currentDimAmount = 0

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = self.targetDimAmount,
			currentScale = self.targetScale
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnDim()
end

function PANEL:Undim(length, callback)
	length = length or animationTime
	self.currentDimAmount = self.targetDimAmount

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = 0,
			currentScale = 1
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnUndim()
end

function PANEL:OnDim()
end

function PANEL:OnUndim()
end

function PANEL:Paint(width, height)
	local amount = self.currentDimAmount
	local bShouldScale = self.currentScale != 1
	local matrix

	local imgW = math.max(ScrW()/6, 120)
	local imgH = math.max(ScrH()/4.32, 150)

	surface.SetDrawColor( 255,255,255 )
    surface.SetMaterial( setorianLogo )
	surface.DrawTexturedRect(ScrW()-imgW, ScrH()-imgH,imgW,imgH)

	if (!firstLoad) then
		ix.util.DrawText("Z", 100, ScrH() - 140, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "ixIconsMedium")
		ix.util.DrawText("Load any character to get outfits", 135, ScrH() - 138, Color(200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "ixMenuMiniFont")
	end

	if (IsDownloadingWorkshop) then
		ix.util.DrawText("T", 100, ScrH() - 80, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "ixIconsMedium")
		ix.util.DrawText("Some addons are still downloading", 135, ScrH() - 78, Color(200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "ixMenuMiniFont")
	end

	-- draw child panels with scaling if needed
	if (bShouldScale) then
		matrix = Matrix()
		matrix:Scale(matrixZScale * self.currentScale)
		matrix:Translate(Vector(
			ScrW() * 0.6 - (ScrW() * self.currentScale * 0.6),
			ScrH() * 0.5 - (ScrH() * self.currentScale * 0.5),
			1
		))

		cam.PushModelMatrix(matrix)
		self.currentMatrix = matrix
	end

	BaseClass.Paint(self, width, height)

	if (bShouldScale) then
		cam.PopModelMatrix()
		self.currentMatrix = nil
	end

	-- if (amount > 0) then
	-- 	local color = Color(0, 0, 0, amount)

	-- 	surface.SetDrawColor(color)
	-- 	surface.DrawRect(0, 0, width, height)
	-- end

end

vgui.Register("ixCharMenuPanel", PANEL, "ixSubpanelParent")




PANEL = {}


local glowMaterial = Material("helix/gui/radial-gradient.png", "noclamp smooth")


AccessorFunc(PANEL, "bUsingCharacter", "UsingCharacter", FORCE_BOOL)



function PANEL:Init()


	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = ScrW() * 0.5
	local halfPadding = padding * 0.5
	local bHasCharacter = #ix.characters > 0

	local parent = self:GetParent()

	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:DockPadding(padding, padding, padding, padding)

	self.payload = {}
	self.payload.attributes = {}

	self.NextUse = CurTime()

	self.SelectedChar = 0

	-- self.Paint = function(s,w,h)


	-- 	//Background
	--     -- surface.SetDrawColor( 44, 62, 80, 250 )
	--     -- surface.SetDrawColor(24, 37, 52, 200)
	--     -- -- surface.SetDrawColor(14, 27, 42, 255)
	--     -- surface.DrawRect(0,0,w,h)

	--     surface.SetDrawColor( 0,0,0,200 )
	--     surface.SetMaterial( gradient )
	-- 	surface.DrawTexturedRect(0,0,w,h)

	-- end

	-- (width-(ScrW()/6),height-(ScrH()/6)+40,ScrW()/6,ScrH()/6)

	-- local SetorianLogo = self:Add("DImage")
	-- SetorianLogo:SetMaterial(setorianLogo)
	-- SetorianLogo:SetPos( ScrW()-(ScrW()/6) , ScrH()-(ScrH()/6)+40 )
	-- SetorianLogo:SetSize(ScrW()/6,ScrH()/6)


	local ButtonsList = self:Add( "Panel")
	ButtonsList:Dock(LEFT)
	ButtonsList:DockMargin(0,halfWidth*0.25,0,0)
	ButtonsList:SetWide(halfWidth/2)

	self.mainButtonList = ButtonsList

	self.continueButton = self.mainButtonList:Add("ix_Setorian_CustomButton")
	self.continueButton:Dock(TOP)
	self.continueButton:DockMargin(0,0,0,5)
	self.continueButton:SetContentAlignment(5)
	self.continueButton:SetText("continue")
	self.continueButton:SizeToContents()
	self.continueButton.DoClick = function(s)
		
		if (self.SelectedChar == 0) then 

			local maximum = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 5)
			-- don't allow creation if we've hit the character limit
			if (#ix.characters >= maximum) then
				self:GetParent():ShowNotice(3, L("maxCharacters"))
				return
			end

			self:Dim()

			parent.newCharacterPanel:SetActiveSubpanel("faction", 0)
			parent.newCharacterPanel:SlideUp()

		return end

		if (LocalPlayer():GetCharacter() and self.SelectedChar == LocalPlayer():GetCharacter():GetID()) then
			-- LocalPlayer():NotifyLocalized("usingChar")
			parent:ShowNotice(3, L("usingChar"))
			return
		end

		net.Start("ixCharacterChoose")
			net.WriteUInt(self.SelectedChar, 32)
		net.SendToServer()

		firstLoad = true

	end

	self.deletebutton = self.mainButtonList:Add("ix_Setorian_CustomButton")
	self.deletebutton:Dock(TOP)
	self.deletebutton:DockMargin(0,0,0,5)
	self.deletebutton:SetContentAlignment(5)
	self.deletebutton:SetText("delete")
	self:UpdateDeleteButton()
	self.deletebutton:SizeToContents()
	self.deletebutton.DoClick = function(s)
		
		if (self.SelectedChar == 0) then return end

		local id = self.SelectedChar

		local character = ix.char.loaded[id]

		if (!character) then
			return
		end

		parent:ShowNotice(1, L("deleteComplete", character:GetName()))

		net.Start("ixCharacterDelete")
			net.WriteUInt(id, 32)
		net.SendToServer()

	end

	local newsButton = self.mainButtonList:Add("ix_Setorian_CustomButton")
	newsButton:Dock(TOP)
	newsButton:DockMargin(0,0,0,5)
	newsButton:SetContentAlignment(5)
	newsButton:SetText("news")
	newsButton:SizeToContents()
	newsButton.DoClick = function(s)
		gui.OpenURL( "https://setorian.com/" )
	end

	self.returnButton = self.mainButtonList:Add("ix_Setorian_CustomButton")
	self.returnButton:Dock(TOP)
	self.returnButton:DockMargin(0,0,0,5)
	self.returnButton:SetContentAlignment(5)
	self:UpdateReturnButton()
	-- self.returnButton:SetFont("Metro_Font2")
	-- self.returnButton:DockMargin(10,15,15,10)
	self.returnButton.DoClick = function(s)

		for _, v in pairs(self.CharactersFrame:GetChildren()) do
			if (IsValid(v)) then
				v:Remove()
			end
		end

		if (self.bUsingCharacter) then
			parent:Close()
		else
			RunConsoleCommand("disconnect")
		end
	end

	local CharSelList = self:Add( "Panel")
	CharSelList:Dock(BOTTOM)
	CharSelList:DockPadding(ScrW()*0.2,0,ScrW()*0.1,0)
	CharSelList:SetTall(ScreenScale(18))

	self.CharSelList = CharSelList

	local CharactersFrame = self:Add( "Panel")
	CharactersFrame:Dock(FILL)
	CharactersFrame:DockMargin(20,0,0,0)
	CharactersFrame.CanUse = true
	CharactersFrame.Middle = 1
	-- CharactersFrame.Paint = function(s,w,h)

		
		
	-- end
	CharactersFrame.MoveChilds = function(s,move)

		if (move != "left") and (move != "right") then return end

		if (!s.CanUse) then return end
		
		local width = ScrW()*0.2

		local offset = (move == "right" and -width) or width

		if (move == "left") then
			if (self.CharSelBut_Panel:GetChild( 0 ):GetX() == (self.CharSelList:GetTall() + 30)) then return end
		end

		if (move == "right") then
			if (self.CharSelBut_Panel:GetChild( #self.CharSelBut_Panel:GetChildren()-1 ):GetX() == (self.CharSelList:GetTall() + 30)) then return end
		end

		s.CanUse = false

		local offsetMiddle

		if (move == "left") then
			offsetMiddle = -1
		else
			offsetMiddle = 1
		end

		s.Middle = math.Clamp(s.Middle + offsetMiddle, 0, #s:GetChildren()-1)

		local leftSide
		local rightSide


		if (move == "right") then
			if (s.Middle - 2) >= 0 then
				leftSide = s:GetChild( s.Middle - 2)
			end
			if (s.Middle + 1) < #s:GetChildren() then
				rightSide = s:GetChild( math.min(#s:GetChildren()-1, s.Middle + 1))
			end

			if (leftSide) then
				leftSide:AlphaTo(0, 0.5, 0, function() leftSide:SetVisible(false) end)
			end

			-- if (rightSide) then
			-- 	rightSide:SetVisible(true)
			-- 	rightSide:AlphaTo(255, 0.5)
			-- end


		elseif (move == "left") then
			if (s.Middle - 1) >= 0 then
				leftSide = s:GetChild( s.Middle - 1)
			end
			if (s.Middle + 2) < #s:GetChildren() then
				rightSide = s:GetChild( s.Middle + 2)
			end

			if (leftSide) then
				leftSide:SetVisible(true)
				leftSide:AlphaTo(255, 0.5)
			end

			-- if (rightSide) then
			-- 	rightSide:AlphaTo(0, 0.5, 0, function() rightSide:SetVisible(false) end)
			-- end

		end

		self.SelectedChar = s:GetChild( s.Middle).CharID

		if (self.SelectedChar == 0) then
			self.continueButton:SetText("create")
		else
			self.continueButton:SetText("continue")
		end

		for k, v in pairs(s:GetChildren()) do
			v:MoveTo(v:GetX() + offset, v:GetY(), 0.5,0,-1,function() s.CanUse = true end)

		end

	end

	self.CharactersFrame = CharactersFrame

	-- CharSelList:DockMargin(0,halfWidth*0.25,0,0)
	-- CharSelList:SetWide(halfWidth/2)

	-- self:OnUndim()

	self:RenderControlPanels()
	self:RenderCharactersPanels()

end

function PANEL:OnCharacterDeleted(character)

	if (#ix.characters == 0) then
		self:ResetState()
	else
		
		if (self.CharactersFrame.Middle == #self.CharactersFrame:GetChildren()-1) then

			local CharToDelete = self.CharactersFrame:GetChild( self.CharactersFrame.Middle )

			local ControlToDelete = self.CharSelBut_Panel:GetChild( #self.CharSelBut_Panel:GetChildren()-1 )

			CharToDelete:AlphaTo(0, 0.5, 0, function() CharToDelete:Remove() end)
			ControlToDelete:AlphaTo(0, 0.5, 0, function() ControlToDelete:Remove() end)
			self.CharSelBut_Panel:MoveChilds("left")
			self.CharactersFrame:MoveChilds("left")

		else

			local CharToDelete = self.CharactersFrame:GetChild( self.CharactersFrame.Middle )

			local ControlToDelete = self.CharSelBut_Panel:GetChild( self.CharSelBut_Panel.Middle-1 )

			CharToDelete:AlphaTo(0, 0.5, 0, function() CharToDelete:Remove() end)
			ControlToDelete:AlphaTo(0, 0.5, 0, function() ControlToDelete:Remove() end)
			-- self.CharSelBut_Panel:MoveChilds("left",self.CharSelBut_Panel.Middle)
			-- self.CharactersFrame:MoveChilds("left",self.CharactersFrame.Middle)

			self:FillEmptySpace(self.CharactersFrame.Middle)

		end

	end

end

function PANEL:ResetState()

	self.SelectedChar = 0
	self:RenderControlPanels()
	self:RenderCharactersPanels()

	self.CharactersFrame.Middle = 1
	

end

function PANEL:FillEmptySpace(limit)

	if (!limit) then return end

	if (self.CharactersFrame.CanUse) then
		self.CharactersFrame.CanUse = false

		self.SelectedChar = self.CharactersFrame:GetChild( self.CharactersFrame.Middle+1).CharID

		local offset = ScrW()*0.2

		for k, v in pairs(self.CharactersFrame:GetChildren()) do

			if (k <= limit+1) then continue end

			v:MoveTo(v:GetX() - offset, v:GetY(), 0.5,0,-1,function() self.CharactersFrame.CanUse = true end)

		end
	end

	if (self.CharSelBut_Panel.CanUse) then
		self.CharSelBut_Panel.CanUse = false

		local offset = (self.CharSelList:GetTall() + 30)

		for k, v in pairs(self.CharSelBut_Panel:GetChildren()) do

			if (k <= limit) then continue end

			v:MoveTo(v:GetX() - offset, 0, 0.5,0,-1,function() self.CharSelBut_Panel.CanUse = true end)

			v.IsToggled = 1

			if (k == self.CharSelBut_Panel.Middle+1) then
				v.IsToggled = 0
			end

		end
	end

end

function PANEL:RenderControlPanels()
	
	self.CharSelList:Clear()
	
	local LeftButton = self.CharSelList:Add("DButton")
	LeftButton:Dock(LEFT)
	LeftButton:DockMargin(0,0,30,0)
	LeftButton:SetWide(ScreenScale(25))
	LeftButton:SetContentAlignment(5)
	LeftButton:SetText("s")
	LeftButton:SetFont("ixIconsMenuButton")
	LeftButton.OnCursorEntered = function()
		LocalPlayer():EmitSound("Helix.Rollover")
	end
	LeftButton.DoClick = function(s)

		self.CharSelBut_Panel:MoveChilds("left")
		self.CharactersFrame:MoveChilds("left")

	end


	local CharSelBut_Panel = self.CharSelList:Add( "Panel")
	CharSelBut_Panel:Dock(LEFT)
	-- CharSelBut_Panel:DockMargin(0,0,30,0)
	CharSelBut_Panel:SetWide(self.CharSelList:GetTall() * 3 + 30*2)
	CharSelBut_Panel.CanUse = true
	CharSelBut_Panel.Middle = 2
	CharSelBut_Panel.MoveChilds = function(s,move, limit)

		if (move != "left") and (move != "right") then return end

		if (!s.CanUse) then return end
		

		local offset = (move == "right" and -(self.CharSelList:GetTall() + 30)) or (self.CharSelList:GetTall() + 30)

		if (move == "left") then
			if (s:GetChild( 0 ):GetX() == (self.CharSelList:GetTall() + 30)) then return end
		end

		if (move == "right") then
			if (s:GetChild( #s:GetChildren()-1 ):GetX() == (self.CharSelList:GetTall() + 30)) then return end
		end

		s.CanUse = false

		local offsetMiddle

		if (move == "left") then
			offsetMiddle = -1
		else
			offsetMiddle = 1
		end

		s.Middle = math.Clamp(s.Middle + offsetMiddle, 1, #s:GetChildren())

		-- print(self.Middle)

		for k, v in pairs(s:GetChildren()) do

			if (limit) and (move == "right") then
				if (k <= limit) then continue end
			end

			v:MoveTo(v:GetX() + offset, 0, 0.5,0,-1,function() s.CanUse = true end)

			v.IsToggled = 1

			if (k == s.Middle) then
				v.IsToggled = 0
			end

		end

	end

	self.CharSelBut_Panel = CharSelBut_Panel

	-- for i=0,4 do
	for i = 0, (#ix.characters) do

		local CharSelBut = CharSelBut_Panel:Add("DButton")

		CharSelBut:SetSize(self.CharSelList:GetTall(),self.CharSelList:GetTall())
		CharSelBut:SetX((#ix.characters == 0 and (self.CharSelList:GetTall() + 30)) or ((self.CharSelList:GetTall() + 30)*i) )
		CharSelBut:SetText( (i == 0 and "I") or "")
		CharSelBut:SetFont("ixIconsMenuButton")
		CharSelBut.bganim = 1
		CharSelBut.IsToggled = (i==1 and 0) or 1

		CharSelBut.OnCursorEntered = function()
			LocalPlayer():EmitSound("Helix.Rollover")
		end
		CharSelBut.Paint = function(s,w,h)

			local alpha = 50

			if (s:GetDisabled()) then
				alpha = 10
			elseif (s.Depressed) then
				alpha = 180
			elseif (s.Hovered) then
				alpha = 75
			end



			surface.SetDrawColor(30, 30, 30, alpha)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(0, 0, 0, 180)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetDrawColor(180, 180, 180, 2)
			surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

			if (i == 0) then return end

			-- if (s:IsHovered()) then
			-- 	s.bganim = Lerp(FrameTime() * 5, s.bganim, 0)
			-- else
				s.bganim = Lerp(FrameTime() * 5, s.bganim, s.IsToggled)
			-- end

			local scal = s.bganim * ScreenScale(2)

			surface.SetDrawColor(64, 115, 158, 255)
			surface.DrawRect(w*0.2 + scal,w*0.2 + scal,w-((w*0.2)*2+scal*2),h-((w*0.2)*2+scal*2))

		end

	end

	local RightButton = self.CharSelList:Add("DButton")
	RightButton:Dock(LEFT)
	RightButton:SetContentAlignment(5)
	RightButton:DockMargin(30,0,0,0)
	RightButton:SetWide(ScreenScale(25))
	RightButton:SetText("t")
	RightButton:SetFont("ixIconsMenuButton")
	RightButton.OnCursorEntered = function()
		LocalPlayer():EmitSound("Helix.Rollover")
	end
	RightButton.DoClick = function(s)

		self.CharSelBut_Panel:MoveChilds("right")
		self.CharactersFrame:MoveChilds("right")

	end

end

function PANEL:RenderCharactersPanels()
	
	self.CharactersFrame:Clear()

	local Character = self.CharactersFrame:Add( "ixModelPanel")
	Character:SetSize(ScrW()*0.2,ScrH()-self:GetPadding()*2)
	Character:SetPos( (#ix.characters == 0 and Character:GetWide()) or 0,0)
	Character.PanelPos = Character:GetX()
	Character:SetModel("models/Humans/Group01/Male_0"..math.random(1,9)..".mdl")
	Character.CurrentAlpha = Character:GetAlpha()
	Character:SetFOV(35)
	Character:SetMouseInputEnabled(false)
	Character.CharID = 0

	Character.PaintOver = function(s,w,h)

		draw.SimpleText( "Select to create a new one", "ixSmallTitleFont", w/2, h-70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	end

	local sequence = Character.Entity:SelectWeightedSequence(ACT_BUSY_QUEUE)

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


	function Character:LayoutEntity( entity ) 
		entity:SetAngles(Angle(0, 45, 0))
		entity:SetPos(Vector(0,0,5))
		entity:SetIK(false)
		
		entity:SetMaterial("models/debug/debugwhite")
		entity:SetColor(Color(0,50,0,255))

		
	end

	
	-- for i=1, 3 do
	-- loop backwards to preserve order since we're docking to the bottom
	for i = 1, #ix.characters do

		local id = ix.characters[i]
		local character = ix.char.loaded[id]

		if (!character or character:GetID() == ignoreID) then
			continue
		end

		if (i == 1) then
			self.SelectedChar = character:GetID()
		end

		local Character = self.CharactersFrame:Add( "ixModelPanel")
		Character:SetSize(ScrW()*0.2,ScrH()-self:GetPadding()*2)
		Character:SetPos( Character:GetWide() * i,0)
		Character.PanelPos = Character:GetX()
		Character.DrawModel = function(self)
			local brightness = self.brightness * 0.4
			local brightness2 = self.brightness * 1.5

			render.SetStencilEnable(false)
			render.SetColorMaterial()
			render.SetColorModulation(1, 1, 1)
			render.SetModelLighting(0, brightness2, brightness2, brightness2)

			for i = 1, 4 do
				render.SetModelLighting(i, brightness, brightness, brightness)
			end

			local fraction = (brightness / 1) * 0.1

			render.SetModelLighting(5, fraction, fraction, fraction)

			-- Excecute Some stuffs
			if (self.enableHook) then
				hook.Run("DrawHelixModelView", self, self.Entity)
			end

			self.Entity:DrawModel()
			self:PostDrawModel(self.Entity)

			if (self.enableHook) then
				hook.Run("PostDrawHelixModelView", self, self.Entity)
			end
		end
		Character:SetModel(character:GetModel())
		Character.CurrentAlpha = Character:GetAlpha()
		Character:SetFOV(35)
		Character:SetMouseInputEnabled(false)
		Character.CharID = character:GetID()
		Character.PaintModel = Character.Paint
		Character.PaintOver = function(s,w,h)

			-- surface.SetDrawColor(30, 30 * i , 30, 150)
			-- surface.DrawRect(0, 0, w, h)

			draw.SimpleText( character:GetName() or "", "ixSmallTitleFont", w/2, h-70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

		
		end
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

		if (!isfunction(Character.Entity.AttachPACPart)) then
			pac.SetupENT(Character.Entity)
		end

		local sequence = Character.Entity:SelectWeightedSequence(ACT_BUSY_QUEUE)
	
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

		Character.Entity:SetSkin( character:GetData("skin", 0) )
		for bodygroup, value in pairs (character:GetData("groups", {})) do
			Character.Entity:SetBodygroup( bodygroup, value )
		end

		if (character:GetHeadmodel() and string.find(character:GetHeadmodel(), "models") and character:GetHeadmodel() != NULL and character:GetHeadmodel() != "" and character:GetHeadmodel() != nil) then
			self:WearPlyHead(character:GetHeadmodel(), Character)
		end


		function Character:LayoutEntity( entity ) 
			entity:SetAngles(Angle(0, 45, 0))
			entity:SetPos(Vector(0,0,5))
			entity:SetIK(false)

			entity:InvalidateBoneCache()
			entity:SetupBones()

			self:RunAnimation()

		end

		timer.Simple(0.2, function()

			local inv = character:GetInventory()
			-- print(character:GetInventory())

			if (inv) then
				-- PrintTable(inv:GetItems())
				for k, v in pairs(inv:GetItems()) do
					-- print(v)
					if (v:GetData("equip")) then
						if (v.pacData) then
							-- PrintTable(v.pacData)
							self:WearPac(v.uniqueID, Character)
						end
					end
				end
			end

			-- local pacCloth = character:GetData("clothingstore_pacs", {})

			-- for pacCategory, pacData in pairs(pacCloth) do

			-- 	for pacName, _ in pairs(pacData or {}) do

			-- 		self:WearPac(pacName, Character)

			-- 	end

			-- end

		end)

	end
	
end

function PANEL:WearPlyHead(HeadModel, CharModel)

	if (HeadModel == "") then return end

	if (IsValid(CharModel)) then

		if (IsValid(CharModel.Entity.headmodel)) then
			CharModel.Entity.headmodel:SetModel(HeadModel)
		else

			local ent = CharModel.Entity

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


function PANEL:WearPac(pacName, charPanel)

	local itemTable = ix.item.list[pacName]
	local pacData = ix.pac.list[pacName]

	if (!pacData) then return end

	-- local IsBoneMerge, BoneMergeModel, BoneMergeModifiers = self:CheckForBoneMerge(pacData)

	-- if (IsBoneMerge) then
	-- 	self:WearBoneMerge(BoneMergeModel,BoneMergeModifiers,charPanel.Entity)
	-- else

		if (itemTable) then

			if (itemTable.pacAdjust) then
				pacData = table.Copy(pacData)
				pacData = itemTable:pacAdjust(pacData, charPanel.Entity)
			end

			if (itemTable.bodyGroups) then
				
				for k, v in pairs(itemTable.bodyGroups) do
					local index = charPanel.Entity:FindBodygroupByName(k)

					if (index > -1) then
						charPanel.Entity:SetBodygroup(index, v)
					end
				end
				
			end

		end

		if (isfunction(charPanel.Entity.AttachPACPart)) then
			charPanel.Entity:AttachPACPart(pacData)
			-- print("jest funkcja")

		else
			pac.SetupENT(charPanel.Entity)
			-- print("byl setup")
			timer.Simple(0.1, function()
				if (IsValid(charPanel.Entity) and isfunction(charPanel.Entity.AttachPACPart)) then
					charPanel.Entity:AttachPACPart(pacData)
				end

			end)
		end

	-- end

end

function PANEL:CheckForBoneMerge(pacData)

	for k, v in ipairs(pacData[1].children) do

		for i,j in pairs(v) do
			if (j.BoneMerge) then
				return true, j.Model, j.ModelModifiers
				-- print(j.Model)
			end
			-- if (i == "BoneMerge") and (j == true) then
			-- 	print("mamy bonegomerga")
			-- 	print(i.BoneMerge)
			-- end
		end
		
	end

end

function PANEL:WearBoneMerge(model, Modifiers, ent)

	-- ent:InvalidateBoneCache()
	-- ent:SetupBones()

	local mods = string.Explode(";",Modifiers)

	local bodyGroups = {}
	
	for k, v in ipairs(mods) do
		local bodyTable =  string.Split( v, "=" ) 

		bodyGroups[bodyTable[1]] = bodyTable[2]

		-- for i, j in ipairs(bodyTable) do
			
		-- end

	end

	-- PrintTable(bodyGroups)


	local b = ClientsideModel(model, RENDERGROUP_BOTH)
	if !b then return end
	b:SetModel(model)
	-- for k, v in pairs(bodyGroups) do
		b:SetBodygroup(1,1)
	-- end
	b:InvalidateBoneCache()
	b:SetParent(ent)
	b:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	b:SetupBones()
	b:SetNoDraw(true)



end

function PANEL:RenderPlyWeapon()

	if (IsValid(self.Character)) then

		local client = LocalPlayer()

		if (IsValid(self.Character.Entity.weapon)) then
			self.Character.Entity.weapon:Remove()
		end

		if (client and client:Alive() and IsValid(client:GetActiveWeapon())) then
			local weapon = client:GetActiveWeapon()
			local weapModel = ClientsideModel(weapon:GetModel(), RENDERGROUP_BOTH)

			local ent = self.Character.Entity

			if (weapModel) then
				weapModel:SetParent(ent)
				weapModel:AddEffects(EF_BONEMERGE)
				weapModel:SetSkin(weapon:GetSkin())
				weapModel:SetColor(weapon:GetColor())
				weapModel:SetNoDraw(true)
				ent.weapon = weapModel

			end
		end

	end

end

function PANEL:SetPacOutfit( uniqueID, charPanel )

	local itemTable = ix.item.list[uniqueID]
	local pacData = ix.pac.list[uniqueID]

    if (pacData) then

        local pac_setup = pac_setup

        -- self.Character.PostDrawModel = function(me, ent)
        local ent = charPanel.Entity

        if (!pac) then
            return end

        if (charPanel.pac_setup) then
        	-- print("dziala")
            ent:AttachPACPart(pacData)
        end

        
        -- PrintTable(ent.pac_outfits)

            -- return false
        -- end

    end
end


function PANEL:UpdateDeleteButton()
	if (#ix.characters == 0) then
		self.deletebutton:SetDisabled(true)
	else
		self.deletebutton:SetDisabled(false)
	end
end

function PANEL:UpdateReturnButton(bValue)
	if (bValue != nil) then
		self.bUsingCharacter = bValue
	end

	self.returnButton:SetText(self.bUsingCharacter and "return" or "leave")
	self.returnButton:SizeToContents()
end

function PANEL:OnDim()
	-- disable input on this panel since it will still be in the background while invisible - prone to stray clicks if the
	-- panels overtop slide out of the way
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	-- local PLUGINWS = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("workshop_downloader") or false

	-- if (PLUGINWS) then
	-- 	if (!IsDownloadingWorkshop) and (!firstLoad) then
	-- 		PLUGINWS:checkWorkshop()
	-- 	end
	-- end

	for i=0,2 do
		if (!IsValid(self.CharactersFrame:GetChild(i))) then continue end
		self.CharactersFrame:GetChild(i):SetVisible(false)
	end

end

function PANEL:OnUndim()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	for i=0,2 do
		if (!IsValid(self.CharactersFrame:GetChild(i))) then continue end
		self.CharactersFrame:GetChild(i):SetVisible(true)
	end

	-- we may have just deleted a character so update the status of the return button
	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:UpdateReturnButton()
end

function PANEL:OnClose()
	for _, v in pairs(self:GetChildren()) do
		if (IsValid(v)) then
			v:SetVisible(false)
		end
	end

end

function PANEL:Populate()

	-- self:MakePopup()


end



-- function PANEL:Paint(width, height)
-- 	-- derma.SkinFunc("PaintCharacterCreateBackground", self, width, height)
-- 	BaseClass.Paint(self, width, height)

-- 	surface.SetDrawColor( 230,230,230 )
--     surface.SetMaterial( setorianLogo )
-- 	surface.DrawTexturedRect(width-(ScrW()/6),height-(ScrH()/6)+40,ScrW()/6,ScrH()/6)

-- end

vgui.Register("ixCharMenuMain", PANEL, "ixCharMenuPanel")
-- ix.gui.characterMenu = vgui.Create("ixCharMenu")