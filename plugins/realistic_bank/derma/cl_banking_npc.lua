
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
	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(52, 73, 94, 255)
	    surface.DrawRect(5,5,w-10,h-10)

	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(5,5,w-10,5+48)

	    draw.SimpleText("Bankier NPC", "ix3D2DMediumFont", 12,5, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)


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

	-- Character.PostDrawModel = function(me, ent)

	--  	if (ent.headmodel and IsValid(ent.headmodel)) then
	-- 		ent.headmodel:DrawModel()
	-- 	end


	-- 	if (!pac) then
	-- 		return
	-- 	end

	-- 	if (LocalPlayer():GetCharacter()) then
	-- 		pac.RenderOverride(ent, "opaque")
	-- 		pac.RenderOverride(ent, "translucent", true)
	-- 	end

	-- 	if (!me.pac_setup) then
    --         pac_setup = true
    --         me.pac_setup = true
    --         pac.SetupENT(ent)
    --     end

	-- end

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
	Character:SetModel("models/mossman.mdl")
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

	function Character:LayoutEntity( Entity )
	
		Entity:SetAngles(Angle(0,70,0) )
		Entity:SetPos(Vector(0,0,-10) )


	-- 	-- if (idleAnim <= 0) then
			-- Entity:ResetSequence(399)
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

		draw.SimpleText("Hello! How I can help you?", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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

	-- self:RenderOptions()

	self:DataUpdate()

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
	
	// Loan menu
	if (bMenu == 6) then

		local accountsWithLoan = {}

		for k, v in pairs(self.AccountsData) do

			if (tonumber(v.owner) == LocalPlayer():GetCharacter():GetID()) then
				if (tonumber(v.loan) > 0) then
				accountsWithLoan[v.account_id] = v.loan
				end
			end 

		end

		if (table.IsEmpty(accountsWithLoan)) then
			LocalPlayer():Notify("You don't have any loans to pay.")
			return
		end

		local loanPanel = vgui.Create("ixBanking_Loan_PayBack")
		loanPanel.Accounts = accountsWithLoan
		loanPanel:InputAccounts()
		loanPanel.MainPnl = self

		return

	elseif (bMenu == 7) then // DepositMenu
		netstream.Start("JBanking_OpenSafeBox")
		self:SlideUp(0.5)
		self:AlphaTo(0, 0.3, 0.2, function() self:Close() end)
		return
	end

	if (bMenu == 0) then
		
		self:SlideUp(0.5)
		self:AlphaTo(0, 0.3, 0.2, function() self:Close() end)
	end

	if (noAnim) then
		self.mainPanel:Clear()

		if (bMenu == 1) then
			self:RenderOptions()
		elseif (bMenu == 2) then
			self:RenderCreateAccount()
		elseif (bMenu == 3) then
			self:RenderDeleteAccount()
		elseif (bMenu == 4) then
			self:RenderLostCard()
		elseif (bMenu == 5) then
			self:RenderChangePin()
		elseif (bMenu == 8) then
			self:RenderCreateGroupAccount()
		elseif (bMenu == 9) then
			self:RenderManageGroupAccount()
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
					self:RenderCreateAccount()
				elseif (bMenu == 3) then
					self:RenderDeleteAccount()
				elseif (bMenu == 4) then
					self:RenderLostCard()
				elseif (bMenu == 5) then
					self:RenderChangePin()
				elseif (bMenu == 8) then
					self:RenderCreateGroupAccount()
				elseif (bMenu == 9) then
					self:RenderManageGroupAccount()
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
	

	// Menu = 1 is reserved for the display of selectable options [:RenderOptions()]

	local MenuButtons = {
		[1] = {
			Display = "I would like to create a new account",
			Menu = 2,
			CustomCheck = function()

				local acc_count = 0

				for k, v in pairs(self.AccountsData or {}) do

					if (tonumber(v.owner) != LocalPlayer():GetCharacter():GetID()) then
						continue
					end

					if (!tobool(v.is_groupaccount)) and (!tobool(v.is_interest)) then
						acc_count = acc_count + 1
					end

				end

				if (acc_count >= (ix.config.Get("MaxAccountPerChar", 5) + (PLUGIN.ExtraPersonalAccounts[LocalPlayer():GetUserGroup()] or 0) ) ) then
					return false
				else
					return true
				end

			end,
			CustomCheckMsg = "You can't create any more accounts"
		},
		[2] = {
			Display = "I would like to delete a one of my accounts",
			Menu = 3,
			CustomCheck = function()
				return true
			end
		},
		[3] = {
			Display = "I've lost my debit card",
			Menu = 4,
			CustomCheck = function()
				return true
			end
		},
		[4] = {
			Display = "I would like to change pin for my card",
			Menu = 5,
			CustomCheck = function()
				return true
			end
		},
		[5] = {
			Display = "I would like to repay my loan",
			Menu = 6,
			CustomCheck = function()
				return true
			end
		},
		[6] = {
			Display = "Show me my deposit box",
			Menu = 7,
			CustomCheck = function()
				return true
			end
		},
		[7] = {
			Display = "I would like to create a new group account",
			Menu = 8,
			CustomCheck = function()

				local acc_count = 0

				for k, v in pairs(self.AccountsData or {}) do

					if (tonumber(v.owner) != LocalPlayer():GetCharacter():GetID()) then
						continue
					end

					if (tobool(v.is_groupaccount)) then
						acc_count = acc_count + 1
					end

				end

				if (acc_count >= (ix.config.Get("MaxGroupAccountPerChar", 5) + (PLUGIN.ExtraGroupAccounts[LocalPlayer():GetUserGroup()] or 0)) ) then
					return false
				else
					return true
				end

			end,
			CustomCheckMsg = "You can't create any more group accounts"
		},
		[8] = {
			Display = "I would like to manage group accounts",
			Menu = 9,
			CustomCheck = function()

				local HasGroupAccont = false

				for k, v in pairs(self.AccountsData or {}) do

					if (tonumber(v.owner) != LocalPlayer():GetCharacter():GetID()) then
						continue
					end

					if (tobool(v.is_groupaccount)) then
						HasGroupAccont = true
						break
					end

				end

				return HasGroupAccont

			end,
			CustomCheckMsg = "You have no group account to manage"
		},
		[9] = {
			Display = "Goodbye",
			Menu = 0,
			CustomCheck = function()
				return true
			end
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
			if (v.CustomCheck()) then
				self:RenderMenu(v.Menu)
			else
				LocalPlayer():Notify(v.CustomCheckMsg or "You can't do that")
			end
		end
		Button1.OnCursorEntered = function()
			surface.PlaySound("helix/ui/rollover.wav")
		end

	end

end


function PANEL:RenderCreateAccount()

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
	InfoPanel:SetTall(100)
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
	InfoPanelText:SetText("You are about to create a personal bank account. \n\nPlease set a pin for your debit card.")
	InfoPanelText:SetAutoStretchVertical(true)

	local PinEntryBG = vgui.Create( "DPanel", self.mainPanel )
	PinEntryBG:Dock(TOP)
	PinEntryBG:DockMargin(ScreenScale(35),30,ScreenScale(35),0)
	PinEntryBG:SetTall(80)
	PinEntryBG.Paint = function(s,w,h)

		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)
	end

	local PinEntryText = vgui.Create( "DLabel", PinEntryBG )
	PinEntryText:Dock(TOP)
	PinEntryText:DockMargin(15,15,5,0)
	PinEntryText:SetFont("ixMediumFont")
	PinEntryText:SetTextColor(Color(20,20,20))
	PinEntryText:SetWrap(true)
	PinEntryText:SetText("Set PIN")
	PinEntryText:SetAutoStretchVertical(true)

	local PinEntry = vgui.Create( "DTextEntry", PinEntryBG )
	PinEntry:Dock( TOP )
	PinEntry:DockMargin( 15, 5, 15, 0 )
	PinEntry:SetPlaceholderText( "0000" )
	PinEntry:SetUpdateOnType(true)
	PinEntry.AllowInput = function(s, text)

		local Textlength = string.len(s:GetValue())

		local numbers = "123456789"

		if (Textlength == 4) then
			return true
		elseif ( !string.find( numbers, text, 1, true ) ) then
			return true
		else
			return false
		end

	end

	local CreateButton = vgui.Create( "DButton", self.mainPanel )
	CreateButton:SetText( "" )
	CreateButton:Dock(BOTTOM)
	CreateButton:DockMargin(ScreenScale(35),0,ScreenScale(35),15)
	CreateButton:SetTall(50)
	CreateButton.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,true,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4, (s:IsHovered() and Color(200,200,200)) or Color(240,240,240),true,true,true,false)

		draw.SimpleText("Create", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	CreateButton.DoClick = function()

		if (PinEntry:GetValue() == "") then
			LocalPlayer():Notify("Pin cannot be empty!")
			return
		end

		if (string.len(PinEntry:GetValue()) != 4) then
			LocalPlayer():Notify("Pin is too short!")
			return
		end

		netstream.Start("JBanking_CreateAccount", PinEntry:GetValue())
		self:RenderMenu(1)

		timer.Simple(1, function()
			if (!IsValid(self)) then return end
			self:DataUpdate()
		end)
		
	end
	CreateButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end
	

end

function PANEL:RenderDeleteAccount()

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
	InfoPanel:SetTall(50)
	InfoPanel.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,false,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4,  Color(240,240,240),true,true,false,false)
	end

	local InfoPanelText = vgui.Create( "DLabel", InfoPanel )
	InfoPanelText:Dock(TOP)
	InfoPanelText:DockMargin(15,15,5,0)
	InfoPanelText:SetFont("ixMediumFont")
	InfoPanelText:SetTextColor(Color(20,20,20))
	InfoPanelText:SetWrap(true)
	InfoPanelText:SetText("Please select which account do you want to delete.")
	InfoPanelText:SetAutoStretchVertical(true)


	local DScrollBG = vgui.Create( "DPanel", self.mainPanel )
	DScrollBG:Dock(FILL)
	DScrollBG:DockMargin(ScreenScale(35),10,ScreenScale(35),30)
	DScrollBG.Paint = function(s,w,h)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)
	end

	local DScroll = vgui.Create( "DScrollPanel", DScrollBG )
	DScroll:Dock(FILL)
	DScroll:DockMargin(0,15,0,15)
	-- DScroll:DockMargin(ScreenScale(35),10,ScreenScale(35),30)
	-- DScroll.Paint = function(s,w,h)
	-- 	surface.SetDrawColor(Color(0,0,0))
	-- 	surface.DrawRect(0,0,w,h)

	-- 	surface.SetDrawColor(Color(240,240,240))
	-- 	surface.DrawRect(2,2,w-4,h-4)
	-- end


	-- for i=0, 10 do

	for k, v in pairs(self.AccountsData or {}) do

		if (tonumber(v.owner) != LocalPlayer():GetCharacter():GetID()) then
			continue
		end

		-- if (LocalPlayer():GetCharacter():GetID() != tostring(v.owner)) then continue end

		local AccountBG = DScroll:Add( "DButton" )
		AccountBG:SetText( "" )
		AccountBG:Dock( TOP )
		AccountBG:DockMargin( 15, 0, 15, 10 )
		AccountBG:SetTall(40)
		AccountBG.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(180,180,180)) or Color(200,200,200))
			surface.DrawRect(2,2,w-4,h-4)
			
			draw.SimpleTextOutlined("S", "ixIconsMedium", 10, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("BANK ID: "..v.account_id, "ixMediumFont", 40, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
			draw.SimpleTextOutlined("a", "ixIconsMedium", w-10, 20, Color( 250,250,250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined( ( (tobool(v.is_groupaccount) and "Group") or (tobool(v.is_interest) and "Interest")) or "Personal", "ixMediumFont", w-40, 20, Color( 250,250,250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		AccountBG.DoClick = function()
			surface.PlaySound("helix/ui/press.wav")
			Derma_Query( "Are you sure you want to delete this account? This action cannot be undone", "Deletion warning", "Yes", function()

				netstream.Start("JBanking_DeleteAccount", v.account_id)

				timer.Simple(1, function()
					self:DataUpdate()
					timer.Simple(0.3, function()
						self:RenderMenu(3, true)
					end)
				end)

			end, "No")

		end


	end


end

function PLUGIN:GetPermissions(bankid)

    local permissions = {}

	-- Temp fix
	if (not self.AccountsData) then return {} end

    for k, v in pairs(self.AccountsData) do
        if (tonumber(v.account_id) == bankid) then
            permissions = util.JSONToTable(v.permissions) or {}
            break
        end
    end


    return permissions
    
end


function PANEL:RenderLostCard()

	self.SelectedAccount = ""
	
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
		self.SelectedAccount = nil
		self.pinbg = nil
	end
	BackButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end

	local InfoPanel = vgui.Create( "DPanel", self.mainPanel )
	InfoPanel:Dock(TOP)
	InfoPanel:DockMargin(ScreenScale(35),ScreenScale(35),ScreenScale(35),0)
	InfoPanel:SetTall(50)
	InfoPanel.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,false,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4,  Color(240,240,240),true,true,false,false)
	end

	local InfoPanelText = vgui.Create( "DLabel", InfoPanel )
	InfoPanelText:Dock(TOP)
	InfoPanelText:DockMargin(15,15,5,0)
	InfoPanelText:SetFont("ixMediumFont")
	InfoPanelText:SetTextColor(Color(20,20,20))
	InfoPanelText:SetWrap(true)
	InfoPanelText:SetText("Choose from which account you lost your card.")
	InfoPanelText:SetAutoStretchVertical(true)


	local DScrollBG = vgui.Create( "DPanel", self.mainPanel )
	DScrollBG:Dock(TOP)
	DScrollBG:SetTall(ScreenScale(63))
	DScrollBG:DockMargin(ScreenScale(35),10,ScreenScale(35),10)
	DScrollBG.Paint = function(s,w,h)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)
	end

	local DScroll = vgui.Create( "DScrollPanel", DScrollBG )
	DScroll:Dock(FILL)
	DScroll:DockMargin(0,15,0,15)


	for k, v in pairs(self.AccountsData or {}) do

		local perm = PLUGIN:GetPermissions(v.account_id)

		if (tonumber(v.owner) != LocalPlayer():GetCharacter():GetID()) and (!perm[LocalPlayer():GetCharacter():GetID()].can_getcard) then
			continue
		end

		-- if (LocalPlayer():GetCharacter():GetID() != tostring(v.owner)) then continue end

		local AccountBG = DScroll:Add( "DButton" )
		AccountBG:SetText( "" )
		AccountBG:Dock( TOP )
		AccountBG:DockMargin( 15, 0, 15, 10 )
		AccountBG:SetTall(40)
		AccountBG.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(180,180,180)) or (self.SelectedAccount == v.account_id and Color(150,150,150)) or Color(200,200,200))
			surface.DrawRect(2,2,w-4,h-4)
			
			draw.SimpleTextOutlined("S", "ixIconsMedium", 10, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("BANK ID: "..v.account_id, "ixMediumFont", 40, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
			draw.SimpleTextOutlined("a", "ixIconsMedium", w-10, 20, Color( 250,250,250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined( (tobool(v.is_groupaccount) and "Group") or "Personal", "ixMediumFont", w-40, 20, Color( 250,250,250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		AccountBG.DoClick = function()
			surface.PlaySound("helix/ui/press.wav")
			
			self.SelectedAccount = v.account_id
			self.pinbg:GetChild(0):SetText("Set PIN for a new card ["..self.SelectedAccount.."]")
			self.pinbg:GetChild(1):SetDisabled(false)

		end


	end


	local PinEntryBG = vgui.Create( "DPanel", self.mainPanel )
	PinEntryBG:Dock(TOP)
	PinEntryBG:DockMargin(ScreenScale(35),10,ScreenScale(35),0)
	PinEntryBG:SetTall(80)
	PinEntryBG.Paint = function(s,w,h)

		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)
	end

	self.pinbg = PinEntryBG

	local PinEntryText = vgui.Create( "DLabel", PinEntryBG )
	PinEntryText:Dock(TOP)
	PinEntryText:DockMargin(15,15,5,0)
	PinEntryText:SetFont("ixMediumFont")
	PinEntryText:SetTextColor(Color(20,20,20))
	PinEntryText:SetWrap(true)
	PinEntryText:SetText("Set PIN for a new card")
	PinEntryText:SetAutoStretchVertical(true)


	local PinEntry = vgui.Create( "DTextEntry", PinEntryBG )
	PinEntry:Dock( TOP )
	PinEntry:DockMargin( 15, 5, 15, 0 )
	PinEntry:SetPlaceholderText( "0000" )
	PinEntry:SetUpdateOnType(true)
	PinEntry:SetDisabled(true)
	PinEntry.AllowInput = function(s, text)

		local Textlength = string.len(s:GetValue())

		local numbers = "123456789"

		if (Textlength == 4) then
			return true
		elseif ( !string.find( numbers, text, 1, true ) ) then
			return true
		else
			return false
		end

	end


	local ChangePINButton = vgui.Create( "DButton", self.mainPanel )
	ChangePINButton:SetText( "" )
	ChangePINButton:Dock(BOTTOM)
	ChangePINButton:DockMargin(ScreenScale(35),0,ScreenScale(35),15)
	ChangePINButton:SetTall(50)
	ChangePINButton.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,true,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4, (s:IsHovered() and Color(200,200,200)) or Color(240,240,240),true,true,true,false)

		draw.SimpleText("Receive a card", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	ChangePINButton.DoClick = function()

		if (self.SelectedAccount == "") then
			LocalPlayer():Notify("Please select a account!")
			return
		end

		if (PinEntry:GetValue() == "") then
			LocalPlayer():Notify("Pin cannot be empty!")
			return
		end

		if (string.len(PinEntry:GetValue()) != 4) then
			LocalPlayer():Notify("Pin is too short!")
			return
		end

		netstream.Start("JBanking_GetNewCard", PinEntry:GetValue(), self.SelectedAccount)
		self:RenderMenu(1)
		
	end
	ChangePINButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end

end

function PANEL:RenderChangePin()

	
	local char = LocalPlayer():GetCharacter()
	local inv = char:GetInventory()

	local debitCards = inv:GetItemsByUniqueID("debit_card")


	self.SelectedCardID = ""
	
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
		self.pinbg = nil
		self:RenderMenu(1)
	end
	BackButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end

	local InfoPanel = vgui.Create( "DPanel", self.mainPanel )
	InfoPanel:Dock(TOP)
	InfoPanel:DockMargin(ScreenScale(35),ScreenScale(35),ScreenScale(35),0)
	InfoPanel:SetTall(50)
	InfoPanel.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,false,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4,  Color(240,240,240),true,true,false,false)
	end

	local InfoPanelText = vgui.Create( "DLabel", InfoPanel )
	InfoPanelText:Dock(TOP)
	InfoPanelText:DockMargin(15,15,5,0)
	InfoPanelText:SetFont("ixMediumFont")
	InfoPanelText:SetTextColor(Color(20,20,20))
	InfoPanelText:SetWrap(true)
	InfoPanelText:SetText("Select the card for which you want to change the PIN.")
	InfoPanelText:SetAutoStretchVertical(true)


	local DScrollBG = vgui.Create( "DPanel", self.mainPanel )
	DScrollBG:Dock(TOP)
	DScrollBG:SetTall(ScreenScale(63))
	DScrollBG:DockMargin(ScreenScale(35),10,ScreenScale(35),10)
	DScrollBG.Paint = function(s,w,h)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)
	end

	local DScroll = vgui.Create( "DScrollPanel", DScrollBG )
	DScroll:Dock(FILL)
	DScroll:DockMargin(0,15,0,15)


	for k, v in pairs(debitCards or {}) do

		local AccountBG = DScroll:Add( "DButton" )
		AccountBG:SetText( "" )
		AccountBG:Dock( TOP )
		AccountBG:DockMargin( 15, 0, 15, 10 )
		AccountBG:SetTall(40)
		AccountBG.Paint = function(s,w,h)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor( (s:IsHovered() and Color(180,180,180)) or Color(200,200,200))
			surface.DrawRect(2,2,w-4,h-4)
			
			draw.SimpleTextOutlined("S", "ixIconsMedium", 10, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined("BANK ID: "..v.data["CardBankID"], "ixMediumFont", 40, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
			draw.SimpleTextOutlined("a", "ixIconsMedium", w-10, 20, Color( 250,250,250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
			draw.SimpleTextOutlined(v.data["CardNumber"], "ixMediumFont", w-40, 20, Color( 250,250,250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
			
		end
		AccountBG.DoClick = function()
			surface.PlaySound("helix/ui/press.wav")
			
			self.SelectedCardID = v.data["CardNumber"]
			self.pinbg:GetChild(0):SetText("Set PIN for '"..self.SelectedCardID.."'")
			self.pinbg:GetChild(1):SetDisabled(false)

		end


	end

	local PinEntryBG = vgui.Create( "DPanel", self.mainPanel )
	PinEntryBG:Dock(TOP)
	PinEntryBG:DockMargin(ScreenScale(35),10,ScreenScale(35),0)
	PinEntryBG:SetTall(80)
	PinEntryBG.Paint = function(s,w,h)

		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)
	end

	self.pinbg = PinEntryBG

	local PinEntryText = vgui.Create( "DLabel", PinEntryBG )
	PinEntryText:Dock(TOP)
	PinEntryText:DockMargin(15,15,5,0)
	PinEntryText:SetFont("ixMediumFont")
	PinEntryText:SetTextColor(Color(20,20,20))
	PinEntryText:SetWrap(true)
	PinEntryText:SetText("Set PIN for ")
	PinEntryText:SetAutoStretchVertical(true)


	local PinEntry = vgui.Create( "DTextEntry", PinEntryBG )
	PinEntry:Dock( TOP )
	PinEntry:DockMargin( 15, 5, 15, 0 )
	PinEntry:SetPlaceholderText( "0000" )
	PinEntry:SetUpdateOnType(true)
	PinEntry:SetDisabled(true)
	PinEntry.AllowInput = function(s, text)

		local Textlength = string.len(s:GetValue())

		local numbers = "123456789"

		if (Textlength == 4) then
			return true
		elseif ( !string.find( numbers, text, 1, true ) ) then
			return true
		else
			return false
		end

	end


	local ChangePINButton = vgui.Create( "DButton", self.mainPanel )
	ChangePINButton:SetText( "" )
	ChangePINButton:Dock(BOTTOM)
	ChangePINButton:DockMargin(ScreenScale(35),0,ScreenScale(35),15)
	ChangePINButton:SetTall(50)
	ChangePINButton.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,true,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4, (s:IsHovered() and Color(200,200,200)) or Color(240,240,240),true,true,true,false)

		draw.SimpleText("Change PIN", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	ChangePINButton.DoClick = function()

		if (self.SelectedCardID == "") then
			LocalPlayer():Notify("Please select card!")
			return
		end

		if (PinEntry:GetValue() == "") then
			LocalPlayer():Notify("Pin cannot be empty!")
			return
		end

		if (string.len(PinEntry:GetValue()) != 4) then
			LocalPlayer():Notify("Pin is too short!")
			return
		end

		netstream.Start("JBanking_ChangeCardPIN", PinEntry:GetValue(), self.SelectedCardID)
		self:RenderMenu(1)
		
	end
	ChangePINButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end

	
end

function PANEL:RenderCreateGroupAccount()

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
	InfoPanel:SetTall(100)
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
	InfoPanelText:SetText("You are about to create a group bank account. \n\nPlease set a name for the group account.")
	InfoPanelText:SetAutoStretchVertical(true)

	local NameEntryBG = vgui.Create( "DPanel", self.mainPanel )
	NameEntryBG:Dock(TOP)
	NameEntryBG:DockMargin(ScreenScale(35),30,ScreenScale(35),0)
	NameEntryBG:SetTall(80)
	NameEntryBG.Paint = function(s,w,h)

		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)
	end

	local NameText = vgui.Create( "DLabel", NameEntryBG )
	NameText:Dock(TOP)
	NameText:DockMargin(15,15,5,0)
	NameText:SetFont("ixMediumFont")
	NameText:SetTextColor(Color(20,20,20))
	NameText:SetWrap(true)
	NameText:SetText("Set name")
	NameText:SetAutoStretchVertical(true)

	local NameEntry = vgui.Create( "DTextEntry", NameEntryBG )
	NameEntry:Dock( TOP )
	NameEntry:DockMargin( 15, 5, 15, 0 )
	NameEntry:SetPlaceholderText( "My new account" )

	local CreateButton = vgui.Create( "DButton", self.mainPanel )
	CreateButton:SetText( "" )
	CreateButton:Dock(BOTTOM)
	CreateButton:DockMargin(ScreenScale(35),0,ScreenScale(35),15)
	CreateButton:SetTall(50)
	CreateButton.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,true,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4, (s:IsHovered() and Color(200,200,200)) or Color(240,240,240),true,true,true,false)

		draw.SimpleText("Create", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	CreateButton.DoClick = function()

		if (NameEntry:GetValue() == "") then
			LocalPlayer():Notify("Name cannot be empty!")
			return
		end

		if (string.len(NameEntry:GetValue()) < 4) then
			LocalPlayer():Notify("Name is too short!")
			return
		end

		netstream.Start("JBanking_CreateGroupAccount", NameEntry:GetValue())
		self:RenderMenu(1)

		timer.Simple(1, function()
			if (!IsValid(self)) then return end
			self:DataUpdate()
		end)
		
	end
	CreateButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end
	
	
end


function PANEL:RenderManageGroupAccount()

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
		self.SelectedAccount = nil
		self.ManageAccontPanel = nil
	end
	BackButton.OnCursorEntered = function()
		surface.PlaySound("helix/ui/rollover.wav")
	end

	local InfoPanel = vgui.Create( "DPanel", self.mainPanel )
	InfoPanel:Dock(TOP)
	InfoPanel:DockMargin(ScreenScale(35),ScreenScale(35),ScreenScale(35),0)
	InfoPanel:SetTall(50)
	InfoPanel.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,false,false)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4,  Color(240,240,240),true,true,false,false)
	end

	local InfoPanelText = vgui.Create( "DLabel", InfoPanel )
	InfoPanelText:Dock(TOP)
	InfoPanelText:DockMargin(15,15,5,0)
	InfoPanelText:SetFont("ixMediumFont")
	InfoPanelText:SetTextColor(Color(20,20,20))
	InfoPanelText:SetWrap(true)
	InfoPanelText:SetText("Please select which account do you want to manage.")
	InfoPanelText:SetAutoStretchVertical(true)

	local AccountSelector = vgui.Create( "DComboBox", self.mainPanel )
	AccountSelector:Dock(TOP)
	AccountSelector:DockMargin(ScreenScale(35),10,ScreenScale(35),0)
	AccountSelector:SetTall(50)
	AccountSelector:SetFont("ixMediumFont")
	AccountSelector:SetTextColor(Color(20,20,20))
	AccountSelector:SetValue( "Choose an account" )

	for k, v in pairs(self.AccountsData or {}) do

		if (tonumber(v.owner) != LocalPlayer():GetCharacter():GetID()) then
			continue
		end

		if (tobool(v.is_groupaccount) == false) then
			continue
		end

		AccountSelector:AddChoice( v.group_acc_name .. " [" .. v.account_id .. "]", v.account_id )

	end

	AccountSelector.Paint = function(s,w,h)

		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)

	end
	AccountSelector.OnSelect = function( s, index, value, data )
		self.SelectedAccount = data
		self:ManageAccounts_MoreOptions(data)
	end

	local ManageAccontPanel = vgui.Create( "DPanel", self.mainPanel )
	ManageAccontPanel:Dock(FILL)
	ManageAccontPanel:DockMargin(ScreenScale(35),10,ScreenScale(35),10)
	ManageAccontPanel:DockPadding(15,10,15,10)
	ManageAccontPanel:SetAlpha(0)
	ManageAccontPanel.Paint = function(s,w,h)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(240,240,240))
		surface.DrawRect(2,2,w-4,h-4)
	end

	self.ManageAccontPanel = ManageAccontPanel
	
end

function PANEL:ManageAccounts_MoreOptions(Accountid)

	self.ManageAccontPanel:Clear()

	if (self.ManageAccontPanel:GetAlpha() == 0) then
		self.ManageAccontPanel:AlphaTo( 255, 0.5)
	end
	

	local ManageAccounts_AddUser = self.ManageAccontPanel:Add( "DButton" )
	ManageAccounts_AddUser:SetText( "" )
	ManageAccounts_AddUser:Dock( TOP )
	ManageAccounts_AddUser:DockMargin( 0, 0, 0, 10 )
	ManageAccounts_AddUser:SetTall(40)
	ManageAccounts_AddUser.Paint = function(s,w,h)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor( (s:IsHovered() and Color(180,180,180)) or Color(200,200,200))
		surface.DrawRect(2,2,w-4,h-4)
		
		draw.SimpleTextOutlined(".", "ixIconsMedium", 10, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
		draw.SimpleTextOutlined("Add character to group account", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
		
	end
	ManageAccounts_AddUser.DoClick = function()
		local addpnl = vgui.Create("ixBankManageAccounts_List")
		addpnl.bankID = Accountid
		addpnl:SetParent(self)
	end

	local ManageAccounts_DelUser = self.ManageAccontPanel:Add( "DButton" )
	ManageAccounts_DelUser:SetText( "" )
	ManageAccounts_DelUser:Dock( TOP )
	ManageAccounts_DelUser:DockMargin( 0, 0, 0, 10 )
	ManageAccounts_DelUser:SetTall(40)
	ManageAccounts_DelUser.Paint = function(s,w,h)
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor( (s:IsHovered() and Color(180,180,180)) or Color(200,200,200))
		surface.DrawRect(2,2,w-4,h-4)
		
		draw.SimpleTextOutlined("/", "ixIconsMedium", 10, 20, Color( 250,250,250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(120,120,120))
		draw.SimpleTextOutlined("Delete character from group account", "ixMediumFont", w/2, 20, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(40,40,40))
		
	end
	ManageAccounts_DelUser.DoClick = function()
		local delPnl = vgui.Create("ixBankManageAccounts_List_Del")
		delPnl.bankID = Accountid
		delPnl:SetParent(self)

		for k, v in pairs(self.AccountsData or {}) do
			if (tonumber(v.account_id) == tonumber(Accountid)) then
				delPnl.Accounts = util.JSONToTable(v.owners)
				delPnl:ScrollRefresh()
				break
			end
		end

	end

	local ManageAccounts_Users = vgui.Create( "DListView", self.ManageAccontPanel )
	ManageAccounts_Users:Dock( FILL )
	ManageAccounts_Users:AddColumn( "Owner Name" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can withdraw money" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can deposit money" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can transfer money" ).Header:SetTextColor(Color(20,20,20))
	ManageAccounts_Users:AddColumn( "Can get a card" ).Header:SetTextColor(Color(20,20,20))

	self.ManageAccounts_Users = ManageAccounts_Users

	self:FillList_ManageAccounts(Accountid)

end

function PANEL:FillList_ManageAccounts(Accountid)

	for i = 1, #self.ManageAccounts_Users:GetLines() do
		self.ManageAccounts_Users:RemoveLine( i )
	end

	for k, v in pairs(self.AccountsData or {}) do

		if (tonumber(v.owner) != LocalPlayer():GetCharacter():GetID()) then
			continue
		end

		if (tobool(v.is_groupaccount) == false) then
			continue
		end

		if (tonumber(v.account_id) != tonumber(Accountid)) then
			continue
		end

		for key, playerData in pairs(util.JSONToTable(v.owners) or {}) do

			if (key == 1) then continue end

			local permsToTable = util.JSONToTable(v.permissions)
			local permissions = permsToTable[playerData.charID]

			self.ManageAccounts_Users:AddLine( playerData.charName, 
			(tobool(permissions.can_withdraw) and "✔") or "✖", 
			(tobool(permissions.can_deposit) and "✔") or "✖", 
			(tobool(permissions.can_transfer) and "✔") or "✖", 
			(tobool(permissions.can_getcard) and "✔") or "✖" )  // ✔✖

		end

	end

end

function PANEL:FillList_ManageAccounts_Delay()

	timer.Simple(0.5, function()
	if (!self) then return end
	self:DataUpdate()
	timer.Simple(0.3, function()
		self:FillList_ManageAccounts()
	end)
end)

end

function PANEL:DataUpdate()

	PLUGIN:GetAllAccountsData(function(data)
		self.AccountsData = data
	end)

end


vgui.Register("ixBanking_NPCMenu", PANEL, "DFrame")


-- vgui.Create("ixBanking_NPCMenu")
