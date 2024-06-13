local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(600,500)
	self:Center()
	self:MakePopup()
	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(true)
	self:SetDraggable(false)


	self.Paint = function(s,w,h)

		//Background
	    -- surface.SetDrawColor( 44, 62, 80, 250 )
	    -- surface.SetDrawColor(24, 37, 52, 100)
	    surface.SetDrawColor(47, 54, 64)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(53, 59, 72)
	    surface.DrawRect(5,5,w-10,h-10)

	    surface.SetDrawColor(47, 54, 64)
	    surface.DrawRect(0,0,w,25)


	end

	-- self:RenderNewMenu()

	self.TransferTo = ""

	local LogInPanel = vgui.Create( "ixBanking_ATMMenu_LogIn", self )
	LogInPanel:Dock(FILL)
	LogInPanel:SetZPos(99)

	self.LogInPanel = LogInPanel

end

function PANEL:FormatDigit(val)

		local formated = ""
		local words = string.Explode( "", val )
		local newWords = {}

		for k, v in pairs(words) do
			
			newWords[#newWords + 1] = v

			if (k%4 == 0) then
				newWords[#newWords + 1] = " "
			end

		end

		return table.concat(newWords)

	end

function PANEL:RenderNewMenu()

	self.balance = 0
	-- self.balanceAnimation = 0
	PLUGIN:GetAllAccountsData(function(data)

		for k, v in pairs(data) do
			if (tonumber(v.account_id) == self.BankNumber) then
					self.balance = tonumber(v.money)
					-- self.balanceAnimation = v.money
				break
			end
		end

	end)

	local LeftPanel = vgui.Create( "DPanel", self )
	LeftPanel:Dock(LEFT)
	LeftPanel:SetWide(self:GetWide()*0.45)
	LeftPanel:SetAlpha(0)
	LeftPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(14, 27, 42, 250)
	 --    surface.DrawRect(0,0,w,h)
	end

	LeftPanel:AlphaTo(255, 0.5, 0, nil)

	local PlayerInfoPanel = vgui.Create( "DPanel", LeftPanel )
	PlayerInfoPanel:Dock(TOP)
	PlayerInfoPanel:SetTall(self:GetTall()*0.4)
	-- LeftPanel:DockMargin(0,0,0,0)
	PlayerInfoPanel.Paint = function(s,w,h)
	end

	local plyInfo = {
		[1] = {
			name = "card holder",
			value = LocalPlayer():GetName(),
		},
		[2] = {
			name = "card number",
			value = self:FormatDigit(self.CardNumber),
		},
		[3] = {
			name = "bank number",
			value = self.BankNumber,
		},
	}

	for k, v in pairs(plyInfo) do
		local PlayerInfo = vgui.Create( "DPanel", PlayerInfoPanel )
		PlayerInfo:Dock(TOP)
		PlayerInfo:SetTall((self:GetTall()*0.4)/3.3)
		PlayerInfo:DockMargin(5,0,0,5)
		PlayerInfo.Paint = function(s,w,h)
			-- surface.SetDrawColor(214, 227, 42, 250)
		 --    surface.DrawRect(0,0,w,h)

		draw.SimpleText(v.value, "Trebuchet24", 20, 10, Color( 230,230,230 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(string.upper(v.name), "Trebuchet18", 20, 30, Color( 93, 99, 112 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end

	local OptionsPanel = vgui.Create( "DPanel", LeftPanel )
	OptionsPanel:Dock(TOP)
	OptionsPanel:DockMargin(0,10,0,0)
	OptionsPanel:SetTall(self:GetTall()*0.5)
	OptionsPanel.buttons = {}
	OptionsPanel.Paint = function(s,w,h)
	end

	self.OperationType = 0

	local ButtonsAtm = {
		[1] = {
			name = "Withdraw",
			func = function()
				self.OperationType = 1
			end,
		},
		[2] = {
			name = "Deposit",
			func = function()
				self.OperationType = 2
			end,
		},
		[3] = {
			name = "Transfer",
			func = function()
				self.TransferTo = ""
				local accountslist = vgui.Create("ixATMAccounts_List")
				accountslist:SetParent(self)

				PLUGIN:GetAllAccountsData(function(data)

					for k, v in pairs(data) do
						if (tonumber(v.account_id) == self.BankNumber) then continue end
						
						accountslist:AddAccountToList(v.account_id, v.owner_name)

					end

					accountslist:ScrollRefresh()

				end)

				self.OperationType = 3

			end,
		}
	}

	local buttonColor = (ix.config.Get("color") or Color(140, 140, 140, 255))

	for k, v in pairs(ButtonsAtm) do
		local ButtonAtm = OptionsPanel:Add("ixMenuSelectionButton")
		ButtonAtm:SetText(v.name)
		ButtonAtm:SizeToContents()
		-- ButtonAtm:SetContentAlignment(5)
		ButtonAtm:Dock(TOP)
		ButtonAtm:DockMargin(5,0,5,15)
		ButtonAtm:SetButtonList(OptionsPanel.buttons)
		ButtonAtm:SetBackgroundColor(buttonColor)
		ButtonAtm.OnSelected = function()
			v.func()
		end
	end

	local RightPanel = vgui.Create( "DPanel", self )
	RightPanel:Dock(RIGHT)
	RightPanel:SetWide(self:GetWide()/2)
	RightPanel:SetAlpha(0)
	RightPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(14, 27, 242, 250)
	 --    surface.DrawRect(0,0,w,h)
	end

	RightPanel:AlphaTo(255, 0.5, 0, nil)

	local Balance = vgui.Create( "DPanel", RightPanel )
	Balance:Dock(TOP)
	Balance:SetTall(100)
	-- Balance:DockMargin(5,0,0,5)
	Balance.Paint = function(s,w,h)
			-- surface.SetDrawColor(214, 227, 42, 250)
		 --    surface.DrawRect(0,0,w,h)

		draw.SimpleText(ix.currency.Get(self.balance), "Trebuchet24", 20, 10, Color( 68, 189, 50 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(string.upper("balance"), "Trebuchet18", 20, 30, Color( 93, 99, 112 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	
		if (self.TransferTo != "") and (self.OperationType == 3) then
			draw.SimpleText("Transfer to "..self.TransferTo, "Trebuchet24", 20, 60, Color( 220,220,220 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

	end

	local NumPadPanel = vgui.Create( "DPanel", RightPanel )
	NumPadPanel:Dock(FILL)
	-- Balance:SetTall(50)
	-- Balance:DockMargin(5,0,0,5)
	NumPadPanel.Paint = function(s,w,h)
			-- surface.SetDrawColor(214, 227, 42, 250)
		 --    surface.DrawRect(0,0,w,h)

	end

	local NumPadPanelDisplay = vgui.Create( "DPanel", NumPadPanel )
	NumPadPanelDisplay:Dock(TOP)
	NumPadPanelDisplay:SetTall(50)
	NumPadPanelDisplay:DockMargin(5,0,25,0)
	NumPadPanelDisplay.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64)
		    surface.DrawRect(0,0,w,h)

		    // 3D effect
		    surface.SetDrawColor(40,40,40,150)
		    surface.DrawOutlinedRect(0,0,w,h,1)

		    surface.SetDrawColor(80,80,80,150)
		    surface.DrawRect(0,h-1,w,2)

		    draw.SimpleText("$", "DermaLarge", 10, h/2, Color( 73, 79, 92 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	end

	local NumPadPanelDisplay_Text = vgui.Create( "DLabel", NumPadPanelDisplay )
	NumPadPanelDisplay_Text:Dock(FILL)
	NumPadPanelDisplay_Text:DockMargin(30,0,5,0)
	NumPadPanelDisplay_Text:SetContentAlignment( 6 )
	NumPadPanelDisplay_Text:SetFont("ixBigFont")
	NumPadPanelDisplay_Text:SetTextColor(Color(68, 189, 50))
	NumPadPanelDisplay_Text:SetText("0")
	NumPadPanelDisplay_Text.noFormat = "0"
	NumPadPanelDisplay_Text.DotMark = ""
	NumPadPanelDisplay_Text.NumbersAfterDot = ""

	self.NumPadPanelDisplay_Text = NumPadPanelDisplay_Text

	local NumPadPanelgrid = vgui.Create( "ThreeGrid", NumPadPanel )
	NumPadPanelgrid:Dock(FILL)
	NumPadPanelgrid:SetWide(self:GetWide()*0.45)
	NumPadPanelgrid:DockMargin(5,15,25,10)
	-- NumPadPanelgrid:InvalidateParent(true)
	NumPadPanelgrid:SetColumns(3)
	NumPadPanelgrid:SetHorizontalMargin(12)
	NumPadPanelgrid:SetVerticalMargin(12)
	NumPadPanelgrid.Paint = function(s,w,h)
			-- surface.SetDrawColor(247, 54, 64)
		 --    surface.DrawRect(0,0,w,h)
	end

	for i = 1, 9 do
		local but = vgui.Create( "DButton" )
		but:SetText( i )
		but:SetFont("ixBigFont")
		but:SetSize( 150, 45 )
		but.Paint = function(s,w,h)
			surface.SetDrawColor(73, 79, 92)
		    surface.DrawRect(0,0,w,h)

		    // 3D effect
		    surface.SetDrawColor(0,0,0,250)
		    surface.DrawOutlinedRect(0,0,w,h,1)

		    surface.SetDrawColor(100,100,100,150)
		 	
		 	if (input.IsMouseDown(MOUSE_LEFT) and s:IsHovered()) then
		 		surface.DrawRect(0,h-1,w,2)
		 	else
		   		surface.DrawRect(0,0,w,2)
			end

		end
		but.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")

			local Textlength = string.len(self.NumPadPanelDisplay_Text.noFormat)

			local newText = ""

			if (self.NumPadPanelDisplay_Text.DotMark == ".") then
				local Textlength2 = string.len(self.NumPadPanelDisplay_Text.NumbersAfterDot)

				if (Textlength2 < 2) then

					self.NumPadPanelDisplay_Text.NumbersAfterDot = self.NumPadPanelDisplay_Text.NumbersAfterDot .. i

				end

			else
				
				newText = (self.NumPadPanelDisplay_Text.noFormat == "0" and i) or self.NumPadPanelDisplay_Text.noFormat .. i

			end

			local noFormat = tonumber(self.NumPadPanelDisplay_Text.noFormat)

			if (newText == "") then
				noFormat = tonumber(self.NumPadPanelDisplay_Text.noFormat)
				newText = self.NumPadPanelDisplay_Text.noFormat
			else
				noFormat = tonumber(newText)
			end



			if (Textlength < 10) then
				self.NumPadPanelDisplay_Text.noFormat = newText
				self.NumPadPanelDisplay_Text:SetText(self:FormatMoney(noFormat) .. self.NumPadPanelDisplay_Text.DotMark .. self.NumPadPanelDisplay_Text.NumbersAfterDot)
			end


		end
		NumPadPanelgrid:AddCell( but )
	end

	local ExtraNumButtons = {
		[1] = {
			display = ".",
			func = function(v)

				local Textlength = string.len(self.NumPadPanelDisplay_Text.noFormat)

				if (Textlength < 10) then

					if (self.NumPadPanelDisplay_Text.DotMark == "") then
						self.NumPadPanelDisplay_Text.DotMark = "."
					end

					self.NumPadPanelDisplay_Text:SetText(self:FormatMoney(tonumber(self.NumPadPanelDisplay_Text.noFormat)) .. self.NumPadPanelDisplay_Text.DotMark .. self.NumPadPanelDisplay_Text.NumbersAfterDot)
				end
			end,
		},
		[2] = {
			display = "0",
			func = function(v)

				local Textlength = string.len(self.NumPadPanelDisplay_Text.noFormat)

				if (self.NumPadPanelDisplay_Text.noFormat == 0) and (self.NumPadPanelDisplay_Text.DotMark == "") then
					return false
				end

				local newText = ""

				if (self.NumPadPanelDisplay_Text.DotMark == ".") then
					local Textlength2 = string.len(self.NumPadPanelDisplay_Text.NumbersAfterDot)

					if (Textlength2 < 2) then

						self.NumPadPanelDisplay_Text.NumbersAfterDot = self.NumPadPanelDisplay_Text.NumbersAfterDot .. v.display

					end

				else
					
					newText = self.NumPadPanelDisplay_Text.noFormat .. v.display

				end

				local noFormat = tonumber(self.NumPadPanelDisplay_Text.noFormat)

				if (newText == "") then
					noFormat = tonumber(self.NumPadPanelDisplay_Text.noFormat)
					newText = self.NumPadPanelDisplay_Text.noFormat
				else
					noFormat = tonumber(newText)
				end



				if (Textlength < 10) then
					self.NumPadPanelDisplay_Text.noFormat = newText
					self.NumPadPanelDisplay_Text:SetText(self:FormatMoney(noFormat) .. self.NumPadPanelDisplay_Text.DotMark .. self.NumPadPanelDisplay_Text.NumbersAfterDot)
				end


			end,
		},
		[3] = {
			display = "00",
			func = function(v)

				local Textlength = string.len(self.NumPadPanelDisplay_Text.noFormat)

				if (self.NumPadPanelDisplay_Text.noFormat == 0) and (self.NumPadPanelDisplay_Text.DotMark == "") then
					return false
				end

				local newText = ""

				if (self.NumPadPanelDisplay_Text.DotMark == ".") then
					local Textlength2 = string.len(self.NumPadPanelDisplay_Text.NumbersAfterDot)

					if (Textlength2 < 1) then

						self.NumPadPanelDisplay_Text.NumbersAfterDot = self.NumPadPanelDisplay_Text.NumbersAfterDot .. v.display

					end

				else
					
					newText = self.NumPadPanelDisplay_Text.noFormat .. v.display

				end

				local noFormat = tonumber(self.NumPadPanelDisplay_Text.noFormat)

				if (newText == "") then
					noFormat = tonumber(self.NumPadPanelDisplay_Text.noFormat)
					newText = self.NumPadPanelDisplay_Text.noFormat
				else
					noFormat = tonumber(newText)
				end



				if (Textlength < 9) then
					self.NumPadPanelDisplay_Text.noFormat = newText
					self.NumPadPanelDisplay_Text:SetText(self:FormatMoney(noFormat) .. self.NumPadPanelDisplay_Text.DotMark .. self.NumPadPanelDisplay_Text.NumbersAfterDot)
				end

			end,
		}
	}


	for k, v in pairs(ExtraNumButtons) do
		local but = vgui.Create( "DButton" )
		but:SetText( v.display )
		but:SetFont("ixBigFont")
		but:SetSize( 150, 45 )
		but.Paint = function(s,w,h)
			surface.SetDrawColor(73, 79, 92)
		    surface.DrawRect(0,0,w,h)

		    // 3D effect
		    surface.SetDrawColor(0,0,0,250)
		    surface.DrawOutlinedRect(0,0,w,h,1)

		    surface.SetDrawColor(100,100,100,150)
		 	
		 	if (input.IsMouseDown(MOUSE_LEFT) and s:IsHovered()) then
		 		surface.DrawRect(0,h-1,w,2)
		 	else
		   		surface.DrawRect(0,0,w,2)
			end

		end
		but.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")

			v.func(v)

		end
		NumPadPanelgrid:AddCell( but )
	end

	local Cancelbut = vgui.Create( "DButton" )
	Cancelbut:SetText( "Cancel" )
	Cancelbut:SetFont("ixMediumFont")
	Cancelbut:SetSize( 200, 45 )
	Cancelbut.Paint = function(s,w,h)
		surface.SetDrawColor(232, 65, 24)
	    surface.DrawRect(0,0,w,h)

	    // 3D effect
	    surface.SetDrawColor(0,0,0,250)
	    surface.DrawOutlinedRect(0,0,w,h,1)

	    surface.SetDrawColor(100,100,100,150)
	 	
	 	if (input.IsMouseDown(MOUSE_LEFT) and s:IsHovered()) then
	 		surface.DrawRect(0,h-1,w,2)
	 	else
	   		surface.DrawRect(0,0,w,2)
		end

	end
	Cancelbut.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		local Textlength = string.len(self.NumPadPanelDisplay_Text:GetValue())

		if (Textlength <= 1) then
			self.NumPadPanelDisplay_Text.noFormat = "0"
			self.NumPadPanelDisplay_Text:SetText("0")
			return
		end

		local noFormatToText = self.NumPadPanelDisplay_Text.noFormat

		if (self.NumPadPanelDisplay_Text.DotMark == ".") then

			noFormatToText = self.NumPadPanelDisplay_Text.NumbersAfterDot

		end

		local charDel = (string.sub( noFormatToText, string.len(noFormatToText), string.len(noFormatToText) ))

		-- local trimmedText = string.TrimRight(noFormatToText, charDel)
		local trimmedText = (string.sub( noFormatToText, 0, string.len(noFormatToText)-1 ))

		local noFormat = tonumber(trimmedText)

		if (self.NumPadPanelDisplay_Text.DotMark == ".") then
			noFormat = tonumber(self.NumPadPanelDisplay_Text.noFormat)

			self.NumPadPanelDisplay_Text.NumbersAfterDot = trimmedText

			if (self.NumPadPanelDisplay_Text.NumbersAfterDot == "") then
				self.NumPadPanelDisplay_Text.DotMark = ""
				trimmedText = self.NumPadPanelDisplay_Text.noFormat
			end

		end

		self.NumPadPanelDisplay_Text.noFormat = (self.NumPadPanelDisplay_Text.DotMark == "." and self.NumPadPanelDisplay_Text.noFormat) or trimmedText
		self.NumPadPanelDisplay_Text:SetText(self:FormatMoney(noFormat) .. self.NumPadPanelDisplay_Text.DotMark .. self.NumPadPanelDisplay_Text.NumbersAfterDot)
	
	end
	NumPadPanelgrid:AddCell( Cancelbut )

	local Clearbut = vgui.Create( "DButton" )
	Clearbut:SetText( "Clear" )
	Clearbut:SetFont("ixMediumFont")
	Clearbut:SetSize( 200, 45 )
	Clearbut.Paint = function(s,w,h)
		surface.SetDrawColor(230, 126, 34)
	    surface.DrawRect(0,0,w,h)

	    // 3D effect
	    surface.SetDrawColor(0,0,0,250)
	    surface.DrawOutlinedRect(0,0,w,h,1)

	    surface.SetDrawColor(140,140,140,150)
	 	
	 	if (input.IsMouseDown(MOUSE_LEFT) and s:IsHovered()) then
	 		surface.DrawRect(0,h-1,w,2)
	 	else
	   		surface.DrawRect(0,0,w,2)
		end

	end
	Clearbut.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		self.NumPadPanelDisplay_Text.DotMark = ""
		self.NumPadPanelDisplay_Text.NumbersAfterDot = ""

		self.NumPadPanelDisplay_Text.noFormat = "0"
		self.NumPadPanelDisplay_Text:SetText("0")
	end
	NumPadPanelgrid:AddCell( Clearbut )

	local Acceptbut = vgui.Create( "DButton" )
	Acceptbut:SetText( "Accept" )
	Acceptbut:SetFont("ixMediumFont")
	Acceptbut:SetSize( 200, 45 )
	Acceptbut.Paint = function(s,w,h)
		surface.SetDrawColor(39, 174, 96)
	    surface.DrawRect(0,0,w,h)

	    // 3D effect
	    surface.SetDrawColor(0,0,0,250)
	    surface.DrawOutlinedRect(0,0,w,h,1)

	    surface.SetDrawColor(140,140,140,150)
	 	
	 	if (input.IsMouseDown(MOUSE_LEFT) and s:IsHovered()) then
	 		surface.DrawRect(0,h-1,w,2)
	 	else
	   		surface.DrawRect(0,0,w,2)
		end

	end
	Acceptbut.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		if (self.NumPadPanelDisplay_Text.DotMark == "." and self.NumPadPanelDisplay_Text.NumbersAfterDot == "") or (self.NumPadPanelDisplay_Text.noFormat == "0") then
			LocalPlayer():Notify("The specified number cannot be zero.")
			return
		end

		if (self.OperationType == 0) then
			LocalPlayer():Notify("Please select the operation type on the left panel.")
			return
		end

		local value = self.NumPadPanelDisplay_Text.noFormat .. self.NumPadPanelDisplay_Text.DotMark .. self.NumPadPanelDisplay_Text.NumbersAfterDot

		local valueNumber = tonumber(value)

		if (self.OperationType == 1) then

			netstream.Start("ixJRBanking_Withdraw", tonumber(self.BankNumber), valueNumber)

		elseif (self.OperationType == 2) then

			netstream.Start("ixJRBanking_Deposit", tonumber(self.BankNumber), valueNumber)

		elseif (self.OperationType == 3) then

			netstream.Start("ixJRBanking_Transfer", tonumber(self.BankNumber), tonumber(self.TransferTo), valueNumber)

		end

		self:UpdateBalance()

		self.NumPadPanelDisplay_Text.DotMark = ""
		self.NumPadPanelDisplay_Text.NumbersAfterDot = ""

		self.NumPadPanelDisplay_Text.noFormat = "0"
		self.NumPadPanelDisplay_Text:SetText("0")

	end
	NumPadPanelgrid:AddCell( Acceptbut )


end

function PANEL:UpdateBalance()
//self.balanceAnimation

	timer.Simple(0.3, function()

		if (!IsValid(self)) then return end

		local NewBalance = self.balance
		self.CurBalance = self.balance
		self.NewBalance = self.balance

		PLUGIN:GetAllAccountsData(function(data)

			for k, v in pairs(data) do
				if (tonumber(v.account_id) == self.BankNumber) then
						-- self.balance = tonumber(v.money)
						self.NewBalance = tonumber(v.money)

					break
				end
			end

		end)

		timer.Simple(0.1, function()

			self:CreateAnimation(1, {
				index = 1,
				target = {
					CurBalance = self.NewBalance,
				},
				easing = "outQuint",

				Think = function(animation, panel)
					panel.balance = math.Round(panel.CurBalance)
				end,
			})


		end)

	end)

end

function PANEL:FormatMoney(val)

	local negative = val < 0

    val = tostring(math.abs(val))
    local dp = string.find(val, "%.") or #val + 1

    for i = dp - 4, 1, -3 do
        val = val:sub(1, i) .. "," .. val:sub(i + 1)
    end

    -- Make sure the amount is padded with zeroes
    if val[#val - 1] == "." then
        val = val .. "0"
    end


	return val

end

vgui.Register("ixBanking_ATMMenu", PANEL, "DFrame")


-- vgui.Create("ixBanking_ATMMenu")