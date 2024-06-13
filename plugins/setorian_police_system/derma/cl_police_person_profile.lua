

local animationTime = 1
DEFINE_BASECLASS("DFrame")

local PANEL = {}

function PANEL:Init()

	self:SetSize( 400, 500 )
	self:Center()
	self:MakePopup()
	self:SetTitle("test")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self.Paint = function(s,w,h)
		surface.SetDrawColor( 52, 73, 94 )
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor( 44, 62, 80 )
	    surface.DrawRect(0,0,w,24)

	    surface.DrawOutlinedRect(0,0,w,h, 2)

	end

	local CloseButtonAlpha = 0
	local DoneButtonAlpha = 0
	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:Dock(BOTTOM)
	self.CloseButton:DockMargin(0,5,0,5)
	self.CloseButton:SetTall(30)
	self.CloseButton:SetText( "Close" )
	self.CloseButton:SetTextColor( Color( 255, 255, 255) )
	self.CloseButton:SetFont("ixSmallFont")
	self.CloseButton:SetZPos(1)
	self.CloseButton.Paint = function(s,w,h)
		surface.SetDrawColor( 24, 42, 60,240 )
	    surface.DrawRect(0,0,w,h)
	    surface.SetDrawColor(120,120,120,CloseButtonAlpha)
	    surface.DrawOutlinedRect(0,0,w,h)
	end
	self.CloseButton.OnCursorEntered = function()
	CloseButtonAlpha = 240
	surface.PlaySound( "ui/buttonrollover.wav")
	end
	self.CloseButton.OnCursorExited = function()
	CloseButtonAlpha = 0
	end
	self.CloseButton.DoClick = function()
		surface.PlaySound( "ui/buttonclick.wav")
		self:Close()
	end

	self.WantedButton = vgui.Create( "DButton", self )
	self.WantedButton:Dock(BOTTOM)
	self.WantedButton:DockMargin(0,5,0,5)
	self.WantedButton:SetTall(30)
	self.WantedButton:SetText( "Wanted person" )
	self.WantedButton:SetTextColor( Color( 255, 255, 255) )
	self.WantedButton:SetFont("ixSmallFont")
	self.WantedButton:SetZPos(2)
	self.WantedButton.DoClick = function()
		surface.PlaySound( "ui/buttonclick.wav")
	end
	self.WantedButton.Paint = function(s,w,h)
		surface.SetDrawColor( 24, 42, 60,240 )
	    surface.DrawRect(0,0,w,h)
	    surface.SetDrawColor(120,120,120,DoneButtonAlpha)
	    surface.DrawOutlinedRect(0,0,w,h)
	end
	self.WantedButton.OnCursorEntered = function()
	DoneButtonAlpha = 240
	surface.PlaySound( "ui/buttonrollover.wav")
	end
	self.WantedButton.OnCursorExited = function()
	DoneButtonAlpha = 0
	end

	local Criminalrecords = vgui.Create( "DLabel", self )
	Criminalrecords:Dock(TOP)
	Criminalrecords:DockMargin(0,5,0,5)
	Criminalrecords:SetFont("Trebuchet24")
	Criminalrecords:SetText( "Criminal Records" )
	Criminalrecords:SetAutoStretchVertical(true)
	Criminalrecords:SetContentAlignment(5)

	DataScroll = vgui.Create( "DScrollPanel", self )
	DataScroll:Dock( TOP )
	DataScroll:SetTall(self:GetTall()*0.5)
	-- DataScroll:DockMargin(0,5,0,0)
	-- DataScroll:DockPadding(5,5,5,5)
	DataScroll.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.DataScroll = DataScroll

	local RecordsTip = vgui.Create( "DLabel", self )
	RecordsTip:Dock(TOP)
	RecordsTip:DockMargin(0,2,0,5)
	RecordsTip:SetFont("ixSmallFont")
	RecordsTip:SetText( "You can modify records in the computer" )
	RecordsTip:SetAutoStretchVertical(true)
	RecordsTip:SetContentAlignment(5)

	local WantedStatus = vgui.Create( "DLabel", self )
	WantedStatus:Dock(TOP)
	WantedStatus:DockMargin(0,10,0,5)
	WantedStatus:SetFont("Trebuchet24")
	WantedStatus:SetText( "Wanted Status" )
	WantedStatus:SetAutoStretchVertical(true)
	WantedStatus:SetContentAlignment(5)

	local WantedStatusPnl = self:Add( "Panel")
	WantedStatusPnl:Dock(TOP)
	WantedStatusPnl:DockMargin(5,0,5,0)
	WantedStatusPnl:SetTall(40)
	WantedStatusPnl:SetZPos(2)
	-- CustomImage.Paint = function(s,w,h)
	-- 	surface.SetDrawColor(40,40,40,150)
	--     surface.DrawRect(0,0,w,h)

	-- end

	local WantedStatus_Text = WantedStatusPnl:Add( "ixLabel")
	WantedStatus_Text:Dock(LEFT)
	-- WantedStatus_Text:SetWide(self:GetWide()/2)
	WantedStatus_Text:SetFont("ixSmallFont")
	WantedStatus_Text:SetText( "Wanted Reason:" )
	WantedStatus_Text:SetContentAlignment(4)
	WantedStatus_Text:SetPadding(5)
	WantedStatus_Text:SizeToContents()
	WantedStatus_Text:SetMouseInputEnabled(false)

	self.wReason = ""

	local WantedStatusPH = vgui.Create( "DTextEntry", WantedStatusPnl )
	WantedStatusPH:Dock( FILL )
	WantedStatusPH:DockMargin(0,5,0,5)
	-- WantedStatusPH:SetWide(self:GetWide()/2 - 20)
	WantedStatusPH:SetText("")
	WantedStatusPH:SetFont("ixSmallFont")
	WantedStatusPH.Paint = function(s,w,h)

	    surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0, 0, w,h)
	    s:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	    
	end
	WantedStatusPH.OnLoseFocus = function(s)
		if (s:GetValue() != "") then
			self.wReason = s:GetValue()
		end
	end
	WantedStatusPH.OnEnter = function(s)
		if (s:GetValue() != "") then
			self.wReason = s:GetValue()
		end
	end

	self.WantedStatusPH = WantedStatusPH

end

function PANEL:PopulateScroll(p, RPTCriminalRecord)
	local RpRespX, RpRespY = ScrW(), ScrH()
	
	if (p:isWanted()) then
		self.WantedStatusPH:SetText(p:getWantedReason())
		self.WantedButton:SetText( "Unwanted person" )
	end

	self.WantedButton.DoClick = function(s)
		surface.PlaySound( "ui/buttonclick.wav")

		if (self.wReason == "") and (!p:isWanted()) then
			LocalPlayer():Notify("Give a reason for the wanted person")
			return
		end

		if (p:isWanted()) and (p:GetCharacter()) then
            -- RunConsoleCommand("say", "/unwanted "..p:GetCharacter():GetName())
            ix.command.Send("unwanted", p:GetCharacter():GetName())
            self.WantedStatusPH:SetText("")
            self.wReason = ""
        else 
        	ix.command.Send("wanted", p:GetCharacter():GetName(), self.wReason)
            -- RunConsoleCommand("say", "/wanted \""..p:GetCharacter():GetName().."\" "..self.wReason)
        end

        self.WantedButton:SetText( (p:isWanted() and "Wanted person") or "Unwanted person" )

        print("blah \"cudzyslow\"")
	end


	if (p:GetCharacter()) then  
        self.DataScroll:Clear()
        timer.Simple(0.5, function() 
            if istable(RPTCriminalRecord) then 
                for k,v in pairs(RPTCriminalRecord) do 
                    local DPanel = vgui.Create("DPanel", self.DataScroll)
                    DPanel:SetSize(0,RpRespY*0.05 + ( (RpRespX * 0.01) * ( (string.len(v.Motif.." ("..v.Date..")")/44) - 1) ))
                    DPanel:Dock(TOP)
                    DPanel:DockMargin(0,5,0,0)
                    DPanel.Paint = function(self,w,h) 
                        if self:IsHovered() then 
                            surface.SetDrawColor( Realistic_Police.Colors["black240"] )
                            surface.DrawRect( 5, 0, w-10, h )
                        else 
                            surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                            surface.DrawRect( 5, 0, w-10, h )
                        end 
                    end

                    local descriptionLabel = vgui.Create("RichText", DPanel)
                    descriptionLabel:SetSize(self:GetWide()-10, RpRespY*0.05 + ( (RpRespX * 0.011) * ( (string.len(v.Motif.." ("..v.Date..")")/44) - 1) ) )
                    descriptionLabel:SetPos(10, 10)
                    descriptionLabel:SetVerticalScrollbarEnabled(false)
                    descriptionLabel:InsertColorChange(240, 240, 240, 255)
                    descriptionLabel:AppendText(v.Motif.." ("..v.Date..")")
                    function descriptionLabel:PerformLayout(w, h)
                        descriptionLabel:SetContentAlignment(5)
                        self:SetFontInternal("rpt_font_7")
                    end

                end
            end
        end)
    end
	

end


vgui.Register("ixPoliceSys_PersonProfile", PANEL, "DFrame")
-- vgui.Create("ixPoliceSys_PersonProfile")
