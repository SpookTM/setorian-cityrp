
local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)

	if (ix.gui.BusinessPhoneUI) then
		ix.gui.BusinessPhoneUI:Close()
	end
	
	self:SetSize(500,450)
	self:Center()
	self:MakePopup()

	self:SetKeyboardInputEnabled(false)

	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(true)
	self:SetDraggable(false)

	self:SetAlpha(0)
	self:AlphaTo(255, 0.5)

	self.already_num = {}

	self.phoneEnt = LocalPlayer():GetLocalVar("BPhone_Ent")

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

	local Screen = vgui.Create( "DPanel", self )
	Screen:Dock(TOP)
	Screen:DockMargin(10,5,10,5)
	Screen:SetTall(self:GetTall()*0.1)
	Screen.Paint = function(s,w,h)

		surface.SetDrawColor(37, 44, 54)
	    surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(0,0,0,150)
	    surface.DrawOutlinedRect(0,0,w,h,1)

	    surface.SetDrawColor(80,80,80,250)
	    surface.DrawRect(0,h-1,w,2)

	    draw.SimpleText(os.date( "%H:%M"), "ixSmallFont", w-5, 5, Color( 123, 129, 142 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	    -- draw.SimpleText((self.phoneEnt and self.phoneEnt:GetPhoneNumber()), "ixSmallFont", w-5, h-5, Color( 123, 129, 142 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

	end

	if (self.phoneEnt) then
		local numberPhone = vgui.Create( "DButton", self )
		numberPhone:SetText( self.phoneEnt:GetPhoneNumber() )
		numberPhone:SetFont("ixSmallFont")
		numberPhone:SizeToContents()
		numberPhone:SetPos(self:GetWide() - numberPhone:GetWide() -15,Screen:GetTall()+10)
		numberPhone:SetTextColor(Color( 123, 129, 142 ))
		numberPhone:SetTooltip("Click to copy")
		numberPhone.Paint = function(s,w,h) end
		numberPhone.DoClick = function(s)

			LocalPlayer():Notify("Number has been copied")
			SetClipboardText(s:GetText())

		end
	end

	local ScreenDisplayer = vgui.Create( "DLabel", Screen )
	ScreenDisplayer:Dock(FILL)
	ScreenDisplayer:DockMargin(10,0,5,0)
	ScreenDisplayer:SetContentAlignment( 4 )
	ScreenDisplayer:SetFont("ixMonoMediumFont")
	ScreenDisplayer:SetTextColor(Color(39, 174, 96))
	ScreenDisplayer:SetText("Status: Waiting for Call")

	self.ScreenDisplayer = ScreenDisplayer
	
	local MainPanel = vgui.Create( "DPanel", self )
	MainPanel:Dock(FILL)
	MainPanel.Paint = function(s,w,h)
	end

	self.MainPanel = MainPanel

	local RightPnl = vgui.Create( "DPanel", self )
	RightPnl:Dock(RIGHT)
	RightPnl:DockMargin(10,5,10,10)
	RightPnl:SetWide(self:GetWide()*0.3)
	RightPnl.Paint = function(s,w,h)

		surface.SetDrawColor(42, 49, 59)
	    surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(20,20,20,150)
	    surface.DrawOutlinedRect(0,0,w,h,1)

	    surface.SetDrawColor(80,80,80,250)
	    surface.DrawRect(0,h-1,w,2)
	end

	self.RightPnl = RightPnl

	local LastCallsPnl = vgui.Create( "Panel", RightPnl )
	LastCallsPnl:Dock(TOP)
	LastCallsPnl:DockMargin(5,5,5,5)
	LastCallsPnl.Paint = function(s,w,h)

		surface.SetDrawColor(Color(53, 59, 72))
	    surface.DrawRect(0,0,w,h)
	end
	

	local LastCallsTitle = vgui.Create( "DLabel", LastCallsPnl )
	LastCallsTitle:Dock(FILL)
	-- LastCallsTitle:DockMargin(5,5,5,0)
	LastCallsTitle:SetContentAlignment( 5 )
	LastCallsTitle:SetFont("ixSmallFont")
	LastCallsTitle:SetTextColor(color_white)
	LastCallsTitle:SetText("Latest Calls")

	-- self:RenderLatestCalls()
	self:RenderKeyPad()


	for k, v in ipairs(player.GetHumans()) do
        if LocalPlayer() == v or !v:aphone_GetNumber() then continue end
        self.already_num[v:aphone_GetNumber()] = v
    end

    -- for k, v in ipairs(ents.FindByClass( "j_business_phone" )) do
    -- 	if (v == self.phoneEnt) then continue end
    --     self.already_num[v:GetPhoneNumber()] = v
    -- end

    -- PrintTable(self.already_num)
	ix.gui.BusinessPhoneUI = self

	

end

function PANEL:OnClose()
	ix.gui.BusinessPhoneUI = nil

	net.Start("ixBPhone_CloseUI")
	net.SendToServer()

	if (self.IsCalled) then
		self:end_call(LocalPlayer())
	end
end

function PANEL:Think()

	if (self.phoneEnt) and (IsValid(self.phoneEnt)) then
		if (LocalPlayer():GetPos():DistToSqr(self.phoneEnt:GetPos()) > 150*150) then
			self:Close()
		end
	else
		self:Close()
	end

end

function PANEL:RenderLatestCalls()

	-- local test = {
	-- 	"+33 12312334",
	-- 	"+33 12345678",
	-- 	"+33 68194062",
	-- }

	for k,v in ipairs(self.lastCalls or {}) do

		local LastCall = vgui.Create( "DLabel", self.RightPnl )
		LastCall:Dock(TOP)
		LastCall:DockMargin(5,5,5,0)
		LastCall:SetContentAlignment( 5 )
		LastCall:SetFont("ixGenericFont")
		LastCall:SetTextColor(color_white)
		LastCall:SetText(v)
		
	end
	

end

function PANEL:RenderStatus(statusID)
	
	local status = {
		[1] = "Status: Waiting for Call",
		[2] = "Status: Calling to "..aphone.FormatNumber(self.NumPadPanelDisplay_Text.number),
		[3] = "Status: Called to "..(self.CalledNumber or "Unknown"),
		[4] = "Status: Call Canceled",
		[5] = "Status: Answered from "..(self.CalledNumber or "Unknown"),
	}
	
	if (statusID == 2 or statusID == 3 or statusID == 5) then
		self.IsCalled = true
		self.Acceptbut:SetText("End")
	elseif (statusID == 4) then
		self.IsCalled = false
		self.Acceptbut:SetText("Call")
		surface.PlaySound("buttons/button11.wav")
		self.ScreenDisplayer:SetTextColor(Color(255,120,120))
		timer.Simple(1, function()
			if (!self) or (!IsValid(self)) then return end
			if (self.IsCalled) then return end
			self:RenderStatus(1)
			self.ScreenDisplayer:SetTextColor(Color(39, 174, 96))
		end)
	else
		self.IsCalled = false
		self.Acceptbut:SetText("Call")
	end


	self.ScreenDisplayer:SetText(status[statusID])

end

function PANEL:RenderKeyPad()

	local NumPadPanel = vgui.Create( "DPanel", self.MainPanel )
	NumPadPanel:Dock(FILL)
	NumPadPanel:DockMargin(5,0,0,0)
	NumPadPanel.Paint = function(s,w,h)
	end

	-- local TipText = vgui.Create( "DLabel", NumPadPanel )
	-- TipText:Dock(TOP)
	-- TipText:DockMargin(0,15,0,0)
	-- TipText:SetFont("ix3D2DMediumFont")
	-- TipText:SetText( "Please enter a phone number:" )
	-- TipText:SetContentAlignment(5)
	-- TipText:SetAutoStretchVertical(true)

	local NumPadPanelDisplay = vgui.Create( "DPanel", NumPadPanel )
	NumPadPanelDisplay:Dock(TOP)
	NumPadPanelDisplay:SetTall(50)
	NumPadPanelDisplay:DockMargin(5,8,5,0)
	NumPadPanelDisplay.Paint = function(s,w,h)
		surface.SetDrawColor(47, 54, 64)
	    surface.DrawRect(0,0,w,h)

	    // 3D effect
	    surface.SetDrawColor(40,40,40,150)
	    surface.DrawOutlinedRect(0,0,w,h,1)

	    surface.SetDrawColor(80,80,80,150)
	    surface.DrawRect(0,h-1,w,2)

	    -- draw.SimpleText("+33", "DermaLarge", 10, h/2, Color( 73, 79, 92 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	end

	local NumPadPanelDisplay_Text = vgui.Create( "DLabel", NumPadPanelDisplay )
	NumPadPanelDisplay_Text:Dock(FILL)
	NumPadPanelDisplay_Text:DockMargin(30,0,5,0)
	NumPadPanelDisplay_Text:SetContentAlignment( 6 )
	NumPadPanelDisplay_Text:SetFont("ixBigFont")
	NumPadPanelDisplay_Text:SetTextColor(Color(250,250,250))
	NumPadPanelDisplay_Text:SetText("")
	NumPadPanelDisplay_Text.number = ""

	self.NumPadPanelDisplay_Text = NumPadPanelDisplay_Text

	local NumPadPanelgrid = vgui.Create( "ThreeGrid", NumPadPanel )
	NumPadPanelgrid:Dock(FILL)
	NumPadPanelgrid:SetWide(self:GetWide()*0.5)
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

			local Textlength = string.len(self.NumPadPanelDisplay_Text.number)

			local newText = self.NumPadPanelDisplay_Text.number .. s:GetText()

			if (Textlength < 8) then
				self.NumPadPanelDisplay_Text.number = newText
				self.NumPadPanelDisplay_Text:SetText(aphone.FormatNumber(self.NumPadPanelDisplay_Text.number))
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

		local Textlength = string.len(self.NumPadPanelDisplay_Text.number)

		if (Textlength <= 1) then
			self.NumPadPanelDisplay_Text.number = ""
			self.NumPadPanelDisplay_Text:SetText("")
			return
		end

		local noFormatToText = self.NumPadPanelDisplay_Text.number


		local charDel = (string.sub( noFormatToText, string.len(noFormatToText), string.len(noFormatToText) ))

		local trimmedText = (string.sub( noFormatToText, 0, string.len(noFormatToText)-1 ))

		self.NumPadPanelDisplay_Text.number = trimmedText

		self.NumPadPanelDisplay_Text:SetText(aphone.FormatNumber(self.NumPadPanelDisplay_Text.number))
	
	
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

		self.NumPadPanelDisplay_Text.number = ""
		self.NumPadPanelDisplay_Text:SetText("")
	end
	NumPadPanelgrid:AddCell( Clearbut )

	local Acceptbut = vgui.Create( "DButton" )
	Acceptbut:SetText( "Call" )
	Acceptbut:SetFont("ixMediumFont")
	Acceptbut:SetSize( 200, 45 )
	Acceptbut.Paint = function(s,w,h)
		surface.SetDrawColor( (self.IsCalled and Color(174, 39, 96)) or Color(39, 174, 96))
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

		if (self.IsCalled) then
			self:end_call(LocalPlayer())
			self:RenderStatus(4)
		else

			if IsValid(self.already_num[self.NumPadPanelDisplay_Text:GetText()]) then

				net.Start("aphone_Phone")
	                net.WriteUInt(1, 4)
	                net.WriteEntity(self.already_num[self.NumPadPanelDisplay_Text:GetText()])
	            net.SendToServer()

	            self:RenderStatus(2)

	            self.CalledNumber = aphone.FormatNumber(self.NumPadPanelDisplay_Text.number)

				surface.PlaySound("ambient/machines/keyboard7_clicks_enter.wav")
			else
				surface.PlaySound("buttons/button16.wav")
			end

			self.NumPadPanelDisplay_Text.number = ""
			self.NumPadPanelDisplay_Text:SetText("")

		end

	end
	self.Acceptbut = Acceptbut
	NumPadPanelgrid:AddCell( Acceptbut )

end

function PANEL:end_call(ply)
	net.Start("ixBPhone_EndCall")
	net.SendToServer()
	-- if ply.aphoneCallID then
	-- 	local t = aphone.Call.Table[ply.aphoneCallID]

	-- 	if !t then
	-- 		ply.aphoneCallID = nil
	-- 		return
	-- 	end

	-- 	aphone.Call.Table[ply.aphoneCallID] = nil

	-- 	if IsValid(t.ent1) then
	-- 		t.ent1.aphone_PVS = nil
	-- 		t.ent1.aphoneCallID = nil
	-- 	end

	-- 	if IsValid(t.ent2) then
	-- 		t.ent2.aphone_PVS = nil
	-- 		t.ent2.aphoneCallID = nil
	-- 	end

	-- 	net.Start("aphone_Phone")
	-- 		net.WriteUInt(5, 4)
	-- 	net.Send({t.ent1, t.ent2})
	-- end
end


vgui.Register("ixBusinessPhoneUI", PANEL, "DFrame")


-- vgui.Create("ixBusinessPhoneUI")