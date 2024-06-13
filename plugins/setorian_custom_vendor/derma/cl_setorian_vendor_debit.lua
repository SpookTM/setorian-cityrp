
local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(600,450)
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

	local MainPanel = vgui.Create( "DPanel", self )
	MainPanel:Dock(FILL)
	-- RightPanel:SetWide(self:GetWide()/2)
	-- LeftPanel:DockMargin(0,0,0,0)
	MainPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(14, 27, 242, 250)
	 --    surface.DrawRect(0,0,w,h)
	end

	self.MainPanel = MainPanel

	self.CorrectPin = "0"
	self.BankAccounts = {}

	self.bankID = ""


	-- self:RenderKeyPad()
	self:RenderLoading()
end

function PANEL:RenderLoading()
	
	self.dots = ""
	self.dotsDelay = CurTime()

	self.RandomDelay = CurTime() + math.random(2,4)

	surface.PlaySound("ambient/machines/combine_terminal_idle1.wav")

	local LoadingPanel = vgui.Create( "DPanel", self.MainPanel )
	LoadingPanel:Dock(FILL)
	LoadingPanel.Paint = function(s,w,h)
			
		draw.SimpleText("Please Wait"..self.dots, "ix3D2DMediumFont", w/2, h*0.3, Color( 250,250,250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		if (self.dotsDelay < CurTime()) then
			self.dots = self.dots .. "."
			if (string.len(self.dots) == 4) then
				self.dots = ""
			end
			self.dotsDelay = CurTime() + 1
		end

		if (self.RandomDelay < CurTime()) then

			self:RenderKeyPad()

			s:Remove()
		end

	end

end


function PANEL:RenderKeyPad()

	if (table.IsEmpty(self.BankAccounts)) then
		LocalPlayer():Notify("You don't have any bank account")
		return
	end

	local NumPadPanel = vgui.Create( "DPanel", self.MainPanel )
	NumPadPanel:Dock(FILL)
	NumPadPanel:DockMargin(self:GetWide()*0.2,0,self:GetWide()*0.2,0)
	NumPadPanel.Paint = function(s,w,h)

	end

	local SelectBankAccount = vgui.Create( "DComboBox", NumPadPanel )
	SelectBankAccount:Dock(TOP)
	SelectBankAccount:DockMargin(0,15,0,0)
	SelectBankAccount:SetValue( "Select a bank account" )
	SelectBankAccount:SetFont("ixMediumFont")
	SelectBankAccount:SizeToContents()

	for k,v in ipairs(self.BankAccounts or {}) do

		SelectBankAccount:AddChoice( "Bank ID: "..v,v )

	end

	SelectBankAccount.OnSelect = function( s, index, value, bankID )
		
		local char = LocalPlayer():GetCharacter()
		local inv = char:GetInventory()

		local data = {
	        ["CardBankID"] = bankID,
	    }

	    local item = inv:HasItem("debit_card", data)

	    if (item) then
	    	self.CorrectPin = tostring(item:GetData("CardPIN",0))
	    	self.bankID = bankID
	    else
	    	LocalPlayer():Notify("You don't have a card in your inventory for the selected bank account")
	    end

	end

	-- local TipText = vgui.Create( "DLabel", NumPadPanel )
	-- TipText:Dock(TOP)
	-- TipText:DockMargin(0,15,0,0)
	-- TipText:SetFont("ix3D2DMediumFont")
	-- TipText:SetText( "Please enter a PIN" )
	-- TipText:SetContentAlignment(5)
	-- TipText:SetAutoStretchVertical(true)

	local NumPadPanelDisplay = vgui.Create( "DPanel", NumPadPanel )
	NumPadPanelDisplay:Dock(TOP)
	NumPadPanelDisplay:SetTall(50)
	NumPadPanelDisplay:DockMargin(5,10,5,0)
	NumPadPanelDisplay.Paint = function(s,w,h)
			surface.SetDrawColor(47, 54, 64)
		    surface.DrawRect(0,0,w,h)

		    // 3D effect
		    surface.SetDrawColor(40,40,40,150)
		    surface.DrawOutlinedRect(0,0,w,h,1)

		    surface.SetDrawColor(80,80,80,150)
		    surface.DrawRect(0,h-1,w,2)

	end

	local NumPadPanelDisplay_Text = vgui.Create( "DLabel", NumPadPanelDisplay )
	NumPadPanelDisplay_Text:Dock(FILL)
	NumPadPanelDisplay_Text:DockMargin(30,0,5,0)
	NumPadPanelDisplay_Text:SetContentAlignment( 6 )
	NumPadPanelDisplay_Text:SetFont("ixBigFont")
	NumPadPanelDisplay_Text:SetTextColor(Color(68, 189, 50))
	NumPadPanelDisplay_Text:SetText("")

	self.NumPadPanelDisplay_Text = NumPadPanelDisplay_Text

	local NumPadPanelgrid = vgui.Create( "ThreeGrid", NumPadPanel )
	NumPadPanelgrid:Dock(FILL)
	NumPadPanelgrid:SetWide(self:GetWide()*0.45)
	NumPadPanelgrid:DockMargin(35,15,5,10)
	-- NumPadPanelgrid:InvalidateParent(true)
	NumPadPanelgrid:SetColumns(3)
	NumPadPanelgrid:SetHorizontalMargin(12)
	NumPadPanelgrid:SetVerticalMargin(12)
	NumPadPanelgrid.Paint = function(s,w,h)
			-- surface.SetDrawColor(247, 54, 64)
		 --    surface.DrawRect(0,0,w,h)
	end

	for i = 1, 10 do

		if (i==10) then
			NumPadPanelgrid:Skip()
		end

		local but = vgui.Create( "DButton" )
		but:SetText( (i==10 and i - 10) or i )
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

			local Textlength = string.len(self.NumPadPanelDisplay_Text:GetText())

			local newText = self.NumPadPanelDisplay_Text:GetText() .. s:GetText()


			if (Textlength < 4) then
				self.NumPadPanelDisplay_Text:SetText(newText)
			end


		end
		NumPadPanelgrid:AddCell( but )

		if (i==10) then
			NumPadPanelgrid:Skip()
		end

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
			self.NumPadPanelDisplay_Text:SetText("")
			return
		end

		local noFormatToText = self.NumPadPanelDisplay_Text:GetText()


		local charDel = (string.sub( noFormatToText, string.len(noFormatToText), string.len(noFormatToText) ))

		local trimmedText = (string.sub( noFormatToText, 0, string.len(noFormatToText)-1 ))



		self.NumPadPanelDisplay_Text:SetText(trimmedText)
	
	
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

		self.NumPadPanelDisplay_Text:SetText("")
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

		if (self.NumPadPanelDisplay_Text:GetText() == self.CorrectPin) and (self.CorrectPin != "0") then

			if (self.bankID == "") then return end

			self:AlphaTo(0, 0.5, 0, function() self:Remove() end)

			self:GetParent():ProcessCart(self.bankID)
			
			surface.PlaySound("buttons/button1.wav")
		else
			surface.PlaySound("buttons/button11.wav")
			self.NumPadPanelDisplay_Text:SetText("")
		end

	end
	NumPadPanelgrid:AddCell( Acceptbut )

end

vgui.Register("ixCustomVendor_Debit", PANEL, "DFrame")


-- vgui.Create("ixCustomVendor_Debit")