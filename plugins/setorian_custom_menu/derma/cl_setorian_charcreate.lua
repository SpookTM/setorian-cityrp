
local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("ixCharMenuPanel")
local PANEL = {}


function PANEL:Init()
-- frame:SetSize(800,550)

	-- self:SetSize(ScrW(),ScrH())
	-- self:Center()
	-- self:MakePopup()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 120 or 50

	-- self:SetTitle("")
	-- self:ShowCloseButton(false)
	-- self:SetDraggable(false)

	self.Stage = 1

	self.Heads = {}
	self.Heads.Male = {}
	self.Heads.Female = {}

	self.BlackHeads = {}
	self.BlackHeads.Male = {
		["01"] = true,
		["03"] = true,
		["70"] = true,
		["32"] = true,
		["33"] = true,
		["49"] = true,
		["69"] = true,
		["71"] = true,
		["77"] = true,
		["78"] = true,
		["90"] = true,
	}
	self.BlackHeads.Female = {
		["03"] = true,
		["45"] = true,
		["52"] = true,
		["63"] = true,
		["64"] = true,
		["66"] = true,
		["70"] = true,
	}

	for i=1, 9 do
		self.Heads.Male[i] = "models/heads/techcom/brot/male_0"..i..".mdl"
	end

	for i=10, 99 do
		self.Heads.Male[i] = "models/heads/techcom/brot/male_"..i..".mdl"
	end

	for i=1, 9 do
		self.Heads.Female[i] = "models/heads/techcom/brot/female_0"..i..".mdl"
	end

	for i=10, 74 do
		self.Heads.Female[i] = "models/heads/techcom/brot/female_"..i..".mdl"
	end

	self.payload = {}
	-- self.payload.attributes = {}

	self.NextUse = CurTime()

	self.Paint = function(s,w,h)


		//Background
	    -- surface.SetDrawColor( 44, 62, 80, 250 )
	 --    surface.SetDrawColor(24, 37, 52, 200)
	 --    -- surface.SetDrawColor(14, 27, 42, 255)
	 --    surface.DrawRect(0,0,w,h)

	 --    surface.SetDrawColor( 0,0,0,200 )
	 --    surface.SetMaterial( gradient )
		-- surface.DrawTexturedRect(0,0,w,h)

	end

	self.animationTime = 1
	self.backgroundFraction = 1

	-- main panel
	self.panel = self:AddSubpanel("main")
	self.panel:SetTitle()
	self.panel:DockPadding(0, 0,0,0)
	-- self.panel.OnSetActive = function()
	-- 	self:CreateAnimation(self.animationTime, {
	-- 		index = 2,
	-- 		target = {backgroundFraction = 1},
	-- 		easing = "outQuint",
	-- 	})
	-- end

	-- character button list
	local controlList = self.panel:Add("Panel")
	controlList:Dock(LEFT)
	controlList:SetSize(halfWidth * 0.75, halfHeight)

	local TitlePanel = controlList:Add("DPanel")
	TitlePanel:Dock(TOP)
	-- TitlePanel:DockMargin(0,0,0,0)
	TitlePanel:DockPadding(10,0,0,0)
	TitlePanel:SetTall(60)
	TitlePanel:SizeToContents()
	-- TitlePanel:SetWide(50)
	TitlePanel.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(80,80,80,200)
	    surface.DrawOutlinedRect( 0,0,w,h,1)
	end

	local TitlePanelText = TitlePanel:Add("DLabel")
	TitlePanelText:Dock(FILL)
	TitlePanelText:SetText( string.upper("Create Character") )
	TitlePanelText:SetFont("Setorian_Creator_Font1")
	TitlePanelText:SetContentAlignment(5)
	TitlePanelText:SizeToContents()

	TitlePanel:InvalidateLayout( true )
	TitlePanel:SizeToChildren( true, true )

	local back = controlList:Add("ix_Setorian_CustomButton")
	back:Dock(BOTTOM)
	back:SetText("return")
	back:SetContentAlignment(5)
	back:SizeToContents()
	back.DoClick = function()

		if (self.Stage == 1) then

			self:SlideDown()
			parent.mainPanel:Undim()

		elseif (self.Stage == 2) then

			self:Transition(self.Stage - 1)
			self.NextButton:SetText("next")

		elseif (self.Stage == 3) then

			self:Transition(self.Stage - 1)
			self.NextButton:SetText("next")

		end

	end

	self.ReturnButton = back

	self.CharacterPanel = controlList:Add("DPanel")
	self.CharacterPanel:Dock(FILL)
	self.CharacterPanel:DockMargin(0,10,0,20)
	-- self.CharacterPanel:DockPadding(10,10,10,10)
	self.CharacterPanel.Paint = function(s,w,h)
	end

	self.Character = self.CharacterPanel:Add("DModelPanel")
	self.Character:Dock(FILL)
	self.Character:SetPos(500,50)
	self.Character:SetModel("models/Humans/Group01/Male_04.mdl")
	self.Character:SetFOV( modelFOV )
	self.Character:SetMouseInputEnabled(false)
	self.Character.AnimPos = 0
	self.Character.PostDrawModel = function(me, ent)
		
        if (ent.headmodel and IsValid(ent.headmodel)) then
			ent.headmodel:DrawModel()
		end

	end
	self.Character.LayoutEntity = function( s,entity )
		entity:SetAngles(Angle(0, 45, 0))
		s:RunAnimation()
	end
	self.Character.AnimateModel = function(s, model)
		
		s.Entity:SetPos(Vector(0,0,3))
		local test = s.Entity:GetPos()
		-- s.Entity:SetPos(test + Vector(-10,10,0))

		s:CreateAnimation(animationTime * 0.3, {
			index = 1,
			target = {
				AnimPos = 40,
			},
			easing = "outQuint",

			Think = function(animation, panel)
				panel.Entity:SetPos(test + Vector(-panel.AnimPos,panel.AnimPos,0))
			end,
			OnComplete = function(animation, panel)

				panel:SetModel(model)

				panel.Entity:SetPos(Vector(0,50,3))

				panel:CreateAnimation(animationTime * 0.3, {
					index = 2,
					target = {
						AnimPos = 0,
					},
					easing = "inQuint",

					Think = function(animation, panel)

						panel.Entity:SetPos(test - Vector(-panel.AnimPos,panel.AnimPos,0))
					end
				})
			end
		})
		

	end

	local MainPanel = self.panel:Add("Panel")
	MainPanel:Dock(FILL)
	MainPanel:DockMargin(ScreenScale(70), ScrH()*0.1,0,0)
	-- MainPanel:DockPadding(20,20,20,20)
	-- MainPanel.Paint = function(s,w,h)

	-- 	surface.SetDrawColor(240,40,40, 250)
	-- 	surface.DrawRect(0, 0, w, h)

	-- end

	local infoButtons = MainPanel:Add("Panel")
	infoButtons:Dock(BOTTOM)
	infoButtons:DockMargin(0,20,0,0)
	infoButtons:SetTall(back:GetTall())


	local NextButton = infoButtons:Add("ix_Setorian_CustomButton")
	NextButton:Dock(FILL)
	NextButton:SetText("next")
	NextButton:SetContentAlignment(5)
	NextButton:SizeToContents()
	-- NextButton:SetWide(NextButton:GetWide()*2)
	NextButton.DoClick = function(s)

		if (self.Stage == 1) then

			-- if (!self.payload["model"]) then
			-- 	self:GetParent().notice:MoveToFront()
			-- 	self:GetParent():ShowNotice(3, "Please select a model")
			-- 	return false
			-- end

			if (!self.payload["gender"]) then
				self:GetParent().notice:MoveToFront()
				self:GetParent():ShowNotice(3, "Please select a gender")
				return false
			end

			self:Transition(self.Stage + 1)

		elseif (self.Stage == 2) then
			
			if (self:VerifyProgression()) then
				self:Transition(self.Stage + 1)
				self.NextButton:SetText("create")
			end

		elseif (self.Stage == 3) then
			self:SendPayload()

		end

	end

	self.NextButton = NextButton

	local ContextsPanelBG = MainPanel:Add("Panel")
	ContextsPanelBG:Dock(FILL)
	ContextsPanelBG:DockPadding(10,10,10,10)
	ContextsPanelBG.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(80,80,80,200)
	    surface.DrawOutlinedRect( 0,0,w,h,1)
	end

	local ContextsPanel = ContextsPanelBG:Add("DScrollPanel")
	ContextsPanel:Dock(FILL)
	ContextsPanel.CurrentAlpha = 255

	ContextsPanel.PaintOver = function(s,w,h)

		if (s.pnlCanvas.y < -10) then
		draw.SimpleText( "u", "ixIconsMedium", w/2, (math.cos(RealTime() * 3) * 5), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end

		if (s.pnlCanvas.y + s.pnlCanvas:GetTall() > s:GetTall()) then
		draw.SimpleText( "r", "ixIconsMedium", w/2, h-(math.cos(RealTime() * 3) * 5), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		end

	end

	self.ContextsPanel = ContextsPanel

	-- setup character creation hooks
	net.Receive("ixCharacterAuthed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local id = net.ReadUInt(32)
		local indices = net.ReadUInt(6)
		local charList = {}

		for _ = 1, indices do
			charList[#charList + 1] = net.ReadUInt(32)
		end

		ix.characters = charList

		self:SlideDown()

		if (!IsValid(self) or !IsValid(parent)) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			parent.mainPanel:Undim()

			parent.mainPanel:ResetState()

			parent:ShowNotice(2, L("charCreated"))
		elseif (id) then
			self.bMenuShouldClose = true

			net.Start("ixCharacterChoose")
				net.WriteUInt(id, 32)
			net.SendToServer()
		else
			self:SlideDown()
		end
	end)

	net.Receive("ixCharacterAuthFailed", function()

		local fault = net.ReadString()
		local args = net.ReadTable()

		parent:ShowNotice(3, L(fault, unpack(args)))
	end)
	

end

function PANEL:SendPayload()
	if (self.awaitingResponse or !self:VerifyProgression()) then
		return
	end

	self.awaitingResponse = true

	timer.Create("ixCharacterCreateTimeout", 10, 1, function()
		if (IsValid(self) and self.awaitingResponse) then
			local parent = self:GetParent()
			parent.notice:MoveToFront()

			self.awaitingResponse = false

			parent:ShowNotice(3, L("unknownError"))
		end
	end)

	-- self.payload:Prepare()

	net.Start("ixCharacterCreate")
	net.WriteUInt(table.Count(self.payload), 8)

	for k, v in pairs(self.payload) do
		net.WriteString(k)
		net.WriteType(v)
	end

	net.SendToServer()
end

function PANEL:CustomVerify(var)

	local value = self.payload[var]

	if (ix.char.vars[var].OnValidate) then
		local result = {ix.char.vars[var]:OnValidate(value, self.payload, LocalPlayer())}

		if (result[1] == false) then
			self:GetParent().notice:MoveToFront()
			self:GetParent():ShowNotice(3, L(unpack(result, 2)))
			self:GetParent().notice:MoveToFront()
			return false
		end
	end

	return true

end

function PANEL:VerifyProgression(name)

	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (name != nil and (v.category or "description") != name) then
			continue
		end

		local value = self.payload[k]

		if (!v.bNoDisplay or v.OnValidate) then
			if (v.OnValidate) then
				local result = {v:OnValidate(value, self.payload, LocalPlayer())}

				if (result[1] == false) then
					self:GetParent().notice:MoveToFront()
					self:GetParent():ShowNotice(3, L(unpack(result, 2)))
					self:GetParent().notice:MoveToFront()
					return false
				end
			end

			self.payload[k] = value
		end
	end

	return true
end

-- function PANEL:SetActiveSubpanel()
-- 	return true
-- end

function PANEL:Transition(step, noAnim)

	if (noAnim) then
		self.ContextsPanel:Clear()
		if (step == 1) then
			self:FirstStep()
			self.Stage = 1
		elseif (step == 2) then
			self:SecondStep()
			self.Stage = 2
		elseif (step == 3) then
			self:ThirdStep()
			self.Stage = 3
		end
		return
	end

	-- self.mainPanel:Clear()
	self.ContextsPanel:CreateAnimation(animationTime * 0.2, {
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


			if (step == 1) then
				self:FirstStep()
				self.Stage = 1
			elseif (step == 2) then
				self:SecondStep()
				self.Stage = 2
			elseif (step == 3) then
				self:ThirdStep()
				self.Stage = 3
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

function PANEL:FirstStep()

	self.payload["gender"] = nil


	local GenderSelector = self.ContextsPanel:Add( "DComboBox" )
	GenderSelector:Dock(TOP)
	GenderSelector:DockMargin(0,0,0,10)
	GenderSelector:SetFont("Setorian_Creator_Font1")
	GenderSelector:SetValue( "Please select a gender" )
	GenderSelector:AddChoice( "Male", false )
	GenderSelector:AddChoice( "Female", true )
	GenderSelector:SizeToContents()
	GenderSelector.OnSelect = function( s, index, value,data )
		self.payload["gender"] = (data and "Female") or "Male"
		self:RenderHeads(data)
		self.payload["model"] = nil
		self:RandomHead(data)
		-- self:RandomDefaultModel(data)

		

	end

	local ModelSelect = self.ContextsPanel:Add("Panel")
	ModelSelect:Dock(TOP) // For some reason I can't use FILL because on first open this panel won't be displayed
	ModelSelect:SetTall(ScrH()*0.55)

	self.ModelSelect = ModelSelect

	-- self:PopulateModels()

end

function PANEL:SecondStep()

	local CharDetails = {
		{
			Name = "Full Name",
			data = "name",
		},
		{
			Name = "Description",
			data = "description",
		},
		-- [3] = {
		-- 	Name = "Eye Color",
		-- 	data = "eye_color",
		-- },
		-- [4] = {
		-- 	Name = "Hair Color",
		-- 	data = "hair_color",
		-- },
		-- [5] = {
		-- 	Name = "Nationality",
		-- 	data = "nationality",
		-- },
		-- [6] = {
		-- 	Name = "Date of birth",
		-- 	data = "dob",
		-- },
	}

	local charDetailsCombo = {
		{
			Name = "Eye Color",
			data = "eye_color",
			Loop = function(s)
				for k,v in ipairs(PLUGIN.EyesColors or {}) do
				s:AddChoice( v, v )
				end
			end
		},
		{
			Name = "Hair Color",
			data = "hair_color",
			Loop = function(s)
				for k,v in ipairs(PLUGIN.HairColors or {}) do
				s:AddChoice( v, v )
				end
			end
		},
		{
			Name = "Nationality",
			data = "nationality",
			Loop = function(s)
				for k,v in ipairs(PLUGIN.Nationality or {}) do
				s:AddChoice( v, v )
				end
			end
		},
		{
			Name = "Age",
			data = "age",
			Loop = function(s)
				for i=16, 60 do
				s:AddChoice( i, i )
				end
			end
		},
		{
			Name = "Height",
			data = "height",
			Loop = function(s)

				for i=0, 50 do
				s:AddChoice( 150 + i.."cm", 150+i )
				end
				
			end
		},
		{
			Name = "Weight",
			data = "weight",
			Loop = function(s)

				for i=50, 120 do
				s:AddChoice( i.."lbs", i )
				end

			end
		},
		{
			Name = "Blood Type",
			data = "blood_type",
			Loop = function(s)

				local bloodtypes = {
					"A+", "A-",
					"B+", "B-",
					"AB+", "AB-",
					"O+", "O-",
				}

				for k, v in ipairs(bloodtypes) do
				s:AddChoice( v, v )
				end
			end
		},
	}


	for k, v in ipairs(CharDetails) do
		
	
		local FullNameDesc = self.ContextsPanel:Add( "Panel")
		FullNameDesc:Dock( TOP )
		FullNameDesc:DockMargin(0,0,0,20)
		FullNameDesc:SetTall( (v.data == "description" and 160) or 80)

		local FullNameDescTitle = FullNameDesc:Add( "ixLabel")
		FullNameDescTitle:Dock(TOP)
		FullNameDescTitle:DockMargin(0,0,0,5)
		FullNameDescTitle:SetFont("ixMenuButtonFontSmall")
		FullNameDescTitle:SetText( v.Name )
		FullNameDescTitle:SetScaleWidth(true)
		FullNameDescTitle:SetContentAlignment(4)
		FullNameDescTitle:SetPadding(5)

		local FullNameDesc_Text = FullNameDesc:Add( "DTextEntry")
		FullNameDesc_Text:Dock( FILL )
		FullNameDesc_Text:SetFont("ixMenuButtonFontSmall")
		FullNameDesc_Text:SetValue( self.payload[v.data] or "" )
		FullNameDesc_Text:SetTall(50)
		FullNameDesc_Text:SetUpdateOnType(true)
		FullNameDesc_Text:SetMultiline((v.data == "description"))
		FullNameDesc_Text.Paint = function(s,w,h)
		    surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

			surface.SetDrawColor(80,80,80,200)
		    surface.DrawOutlinedRect( 0,0,w,h,1)

		    s:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		end
		FullNameDesc_Text.AllowInput = function(s, text)


			if (v.data == "dob") then

				local strAllowedNumericCharacters = "1234567890/"

				if ( !string.find( strAllowedNumericCharacters, text, 1, true ) ) then
					return true
				end

				local Textlength = string.len(s:GetValue())
			
				if (Textlength >= 10) then
					return true
				else
					return false	
				end

			else
				return false
			end


		end
		FullNameDesc_Text.OnValueChange = function(this, text)
			self.payload[v.data] = text
		end

	end

	local DOBPnl = self.ContextsPanel:Add( "Panel")
	DOBPnl:Dock( TOP )
	DOBPnl:DockMargin(0,0,0,20)
	DOBPnl:SetTall(80)

	local DOBPnlTitle = DOBPnl:Add( "ixLabel")
	DOBPnlTitle:Dock(TOP)
	DOBPnlTitle:DockMargin(0,0,0,5)
	DOBPnlTitle:SetFont("ixMenuButtonFontSmall")
	DOBPnlTitle:SetText( "Date of birth" )
	DOBPnlTitle:SetScaleWidth(true)
	DOBPnlTitle:SetContentAlignment(4)
	DOBPnlTitle:SetPadding(5)

	local DOBPnlForCombos = DOBPnl:Add( "Panel")
	DOBPnlForCombos:Dock( FILL )
	DOBPnlForCombos:SetTall(50)

	local DOBPnl_Month = DOBPnlForCombos:Add( "DComboBox")
	DOBPnl_Month:Dock( LEFT )
	DOBPnl_Month:SetFont("ixMenuButtonFontSmall")
	DOBPnl_Month:SetSortItems(false)
	-- DOBPnl_Month:SetValue( self.payload[v.data] or "" )
	DOBPnl_Month:SetWide(ScreenScale(100))
	
	for i=1, 12 do
		DOBPnl_Month:AddChoice( i, i )
	end

	DOBPnl_Month.DoClick = function(s)
		if ( s:IsMenuOpen() ) then
			return s:CloseMenu()
		end

		s:OpenMenu()
		s.Menu:SetPos(s.Menu:GetX(),ScrH()-s.Menu:GetMaxHeight() - 20)
	end

	DOBPnl_Month.OnSelect = function( s, index, value, data )
		-- self.payload[v.data] = data
		self.dobmonth = data

		if (self.dobmonth) and (self.dobday) and (self.dobyear) then
			self.payload["dob"] = self.dobmonth .."/"..self.dobday.."/"..self.dobyear
		end

	end
	

	local DOBPnl_Days = DOBPnlForCombos:Add( "DComboBox")
	DOBPnl_Days:Dock( LEFT )
	DOBPnl_Days:SetFont("ixMenuButtonFontSmall")
	DOBPnl_Days:SetSortItems(false)
	-- DOBPnl_Month:SetValue( self.payload[v.data] or "" )
	DOBPnl_Days:SetWide(ScreenScale(100))
	
	for i=1, 30 do
		DOBPnl_Days:AddChoice( i, i )
	end

	DOBPnl_Days.DoClick = function(s)
		if ( s:IsMenuOpen() ) then
			return s:CloseMenu()
		end

		s:OpenMenu()
		s.Menu:SetPos(s.Menu:GetX(),ScrH()-s.Menu:GetMaxHeight() - 20)
	end

	DOBPnl_Days.OnSelect = function( s, index, value, data )
		-- self.payload[v.data] = data
		self.dobday = data

		if (self.dobmonth) and (self.dobday) and (self.dobyear) then
			self.payload["dob"] = self.dobmonth .."/"..self.dobday.."/"..self.dobyear
		end

	end

	local DOBPnl_Years = DOBPnlForCombos:Add( "DComboBox")
	DOBPnl_Years:Dock( LEFT )
	DOBPnl_Years:SetFont("ixMenuButtonFontSmall")
	DOBPnl_Years:SetSortItems(false)
	-- DOBPnl_Month:SetValue( self.payload[v.data] or "" )
	DOBPnl_Years:SetWide(ScreenScale(100))
	
	for i=18, 90 do
		DOBPnl_Years:AddChoice( tonumber(os.date( "%Y" , os.time() ))-i, tonumber(os.date( "%Y" , os.time() ))-i )
	end

	DOBPnl_Years.DoClick = function(s)
		if ( s:IsMenuOpen() ) then
			return s:CloseMenu()
		end

		s:OpenMenu()
		s.Menu:SetPos(s.Menu:GetX(),ScrH()-s.Menu:GetMaxHeight() - 20)
	end

	DOBPnl_Years.OnSelect = function( s, index, value, data )
		-- self.payload[v.data] = data
		self.dobyear = data

		if (self.dobmonth) and (self.dobday) and (self.dobyear) then
			self.payload["dob"] = self.dobmonth .."/"..self.dobday.."/"..self.dobyear
		end

	end

	for k, v in ipairs(charDetailsCombo) do

		local FullNameDesc = self.ContextsPanel:Add( "Panel")
		FullNameDesc:Dock( TOP )
		FullNameDesc:DockMargin(0,0,0,20)
		FullNameDesc:SetTall(80)

		local FullNameDescTitle = FullNameDesc:Add( "ixLabel")
		FullNameDescTitle:Dock(TOP)
		FullNameDescTitle:DockMargin(0,0,0,5)
		FullNameDescTitle:SetFont("ixMenuButtonFontSmall")
		FullNameDescTitle:SetText( v.Name )
		FullNameDescTitle:SetScaleWidth(true)
		FullNameDescTitle:SetContentAlignment(4)
		FullNameDescTitle:SetPadding(5)

		local FullNameDesc_Combo = FullNameDesc:Add( "DComboBox")
		FullNameDesc_Combo:Dock( FILL )
		FullNameDesc_Combo:SetFont("ixMenuButtonFontSmall")
		FullNameDesc_Combo:SetSortItems(false)
		-- FullNameDesc_Text:SetValue( self.payload[v.data] or "" )
		FullNameDesc_Combo:SetTall(50)
		-- FullNameDesc_Text:SetUpdateOnType(true)
		-- FullNameDesc_Text.Paint = function(s,w,h)
		--     surface.SetDrawColor(20,20,20,150)
		--     surface.DrawRect(0,0,w,h)

		-- 	surface.SetDrawColor(80,80,80,200)
		--     surface.DrawOutlinedRect( 0,0,w,h,1)

		--     s:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		-- end

		v.Loop(FullNameDesc_Combo)

		FullNameDesc_Combo.DoClick = function(s)
			if ( s:IsMenuOpen() ) then
				return s:CloseMenu()
			end

			s:OpenMenu()
			s.Menu:SetPos(s.Menu:GetX(),ScrH()-s.Menu:GetMaxHeight() - 20)
		end

		FullNameDesc_Combo.OnSelect = function( s, index, value, data )
			self.payload[v.data] = data
		end


	end

end

function PANEL:ThirdStep()

	local maximum = hook.Run("GetDefaultAttributePoints", LocalPlayer(), self.payload) or 10

	if (maximum < 1) then
		return
	end

	local attributes = self.ContextsPanel:Add("DPanel")
	attributes:Dock(TOP)

	local y
	local total = 0

	self.payload.attributes = {}

	-- total spendable attribute points
	local totalBar = attributes:Add("ixAttributeBar")
	totalBar:SetMax(maximum)
	totalBar:SetValue(maximum)
	totalBar:Dock(TOP)
	totalBar:DockMargin(2, 2, 2, 2)
	totalBar:SetText(L("attribPointsLeft"))
	totalBar:SetReadOnly(true)
	totalBar:SetColor(Color(20, 120, 20, 255))

	y = totalBar:GetTall() + 4

	for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
		self.payload.attributes[k] = 0

		local bar = attributes:Add("ixAttributeBar")
		bar:SetMax(maximum)
		bar:Dock(TOP)
		bar:DockMargin(2, 2, 2, 2)
		bar:SetText(L(v.name))
		bar.OnChanged = function(this, difference)
			if ((total + difference) > maximum) then
				return false
			end

			total = total + difference
			self.payload.attributes[k] = self.payload.attributes[k] + difference

			totalBar:SetValue(totalBar.value - difference)
		end

		if (v.noStartBonus) then
			bar:SetReadOnly()
		end

		y = y + bar:GetTall() + 4
	end

	attributes:SetTall(y)

end

function PANEL:RenderHeads(IsFemale)
	
	self.ModelSelect:Clear()

	local ModelSelectScroll = self.ModelSelect:Add("DScrollPanel")
	ModelSelectScroll:Dock(FILL)

	local ModelSelect_layout = ModelSelectScroll:Add("DIconLayout")
	ModelSelect_layout:Dock(FILL)
	ModelSelect_layout:SetSpaceX(2)
	ModelSelect_layout:SetSpaceY(2)

	local HeadTable = (IsFemale and self.Heads.Female) or self.Heads.Male

	for k, v in ipairs(HeadTable) do
		
		local icon = ModelSelect_layout:Add("SpawnIcon")
		icon:SetSize(90, 90)
		icon:InvalidateLayout(true)
		icon:SetModel(v)

		icon.DoClick = function(s)

			self.payload["headmodel"] = v
			self:WearPlyHead(v)

		end

		icon.PaintOver = function(this, w, h)
		if (self.payload["headmodel"] == v) then
			local color = ix.config.Get("color", color_white)

			surface.SetDrawColor(color.r, color.g, color.b, 200)

			for i = 1, 3 do
				local i2 = i * 2
				surface.DrawOutlinedRect(i, i, w - i2, h - i2)
			end
		end
	end

	end

end

function PANEL:WearPlyHead(HeadModel)

	if (IsValid(self.Character)) then

		self:ValidateBodyToHead()

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

function PANEL:RandomHead(IsFemale)

	local HeadTable = (IsFemale and self.Heads.Female) or self.Heads.Male

	local randomHead = HeadTable[ math.random( #HeadTable ) ]

	self.payload["headmodel"] = randomHead
	self:WearPlyHead(randomHead)

end

function PANEL:ValidateBodyToHead()

	if (self.payload["headmodel"]) then

		local headModel = self.payload["headmodel"]

		local ModelID =  string.sub( headModel, -6, -5 )

		local HeadTable = (self.payload["gender"] == "Female" and self.BlackHeads.Female) or self.BlackHeads.Male

		-- local faction = ix.faction.indices[1]
		local faction = ix.faction.teams["citizen"]

		-- local FracModels = citizenModels:GetModels(LocalPlayer())
		local FracModels = faction:GetModels(LocalPlayer())

		local blackModel = (self.payload["gender"] == "Female" and "models/player/citizen/female_03_headless.mdl") or "models/player/citizen/male_01_headless.mdl"
		local whiteModel = (self.payload["gender"] == "Female" and "models/player/citizen/female_01_headless.mdl") or "models/player/citizen/male_02_headless.mdl"

		if (HeadTable[ModelID]) then

			if (self.payload["model"] != blackModel) then
				self.Character:SetModel(blackModel)
				self.payload["model"] = table.KeyFromValue(FracModels,blackModel)
			end

		else

			if (self.payload["model"] != whiteModel) then
				self.Character:SetModel(whiteModel)
				self.payload["model"] = table.KeyFromValue(FracModels,whiteModel)
			end

		end

	end

end

function PANEL:PopulateModels(IsFemale)

	self.ModelSelect:Clear()

	local ModelSelectScroll = self.ModelSelect:Add("DScrollPanel")
	ModelSelectScroll:Dock(FILL)

	local ModelSelect_layout = ModelSelectScroll:Add("DIconLayout")
	ModelSelect_layout:Dock(FILL)
	ModelSelect_layout:SetSpaceX(1)
	ModelSelect_layout:SetSpaceY(1)

	local faction = ix.faction.indices[self.payload["faction"]]

	if (faction) then

		local FracModels = faction:GetModels(LocalPlayer())

		for k, v in SortedPairs(FracModels) do

			if (IsFemale) then
				if (v:find("female") or v:find("alyx") or v:find("mossman")) == nil or
				ix.anim.GetModelClass(v) != "citizen_female" then continue end
			else
				if (v:find("female") or v:find("alyx") or v:find("mossman")) != nil or
				ix.anim.GetModelClass(v) == "citizen_female" then continue end
			end

			local icon = ModelSelect_layout:Add("SpawnIcon")
			icon:SetSize(64, 128)
			icon:InvalidateLayout(true)
			icon.DoClick = function(s)
				-- payload:Set("model", k)

				self.payload["model"] = table.KeyFromValue(FracModels,s:GetModelName())

				if (self.Character:GetModel() != s:GetModelName()) then
					self.Character:AnimateModel(s:GetModelName())
				end

			end
			icon.PaintOver = function(this, w, h)
				if (self.payload["model"] == k) then
					local color = ix.config.Get("color", color_white)

					surface.SetDrawColor(color.r, color.g, color.b, 200)

					for i = 1, 3 do
						local i2 = i * 2
						surface.DrawOutlinedRect(i, i, w - i2, h - i2)
					end
				end
			end

			if (isstring(v)) then
				icon:SetModel(v)
			else
				icon:SetModel(v[1], v[2] or 0, v[3])
			end
		end

	end

end


function PANEL:RandomDefaultModel(IsFemale)

	local citizenModels = ix.faction.teams["citizen"]

	local FracModels = citizenModels:GetModels(LocalPlayer())

	local tempModels = {}

	for k, v in SortedPairs(FracModels) do

		if (IsFemale) then
			if (v:find("female") or v:find("alyx") or v:find("mossman")) == nil or
			ix.anim.GetModelClass(v) != "citizen_female" then continue end
		else
			if (v:find("female") or v:find("alyx") or v:find("mossman")) != nil or
			ix.anim.GetModelClass(v) == "citizen_female" then continue end
		end

		tempModels[#tempModels+1] = v

	end

	-- FracModels = tempModels

	local randomMdl = table.Random(tempModels)

	self.Character:AnimateModel(randomMdl)

	self.payload["model"] = table.KeyFromValue(citizenModels:GetModels(LocalPlayer()),randomMdl)

	self.Character.Entity:SetPos(Vector(0,0,3))

end

function PANEL:OnSlideUp()

	self.Stage = 1

	self.payload = {}
	self.payload["faction"] = FACTION_CITIZEN
	self.payload["gender"] = nil

	self:Transition(1, true)

	self:RandomHead()
	-- self:RandomDefaultModel()

	

end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCharacterCreateBackground", self, width, height)
	BaseClass.Paint(self, width, height)
end

vgui.Register("ixCharMenuNew", PANEL, "ixCharMenuPanel")
