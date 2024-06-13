
-- local PLUGIN = PLUGIN

local function GetAmountByName(String)
    local Amount = 0 
    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if v.Name == String then 
            Amount = v.Price
            break
        end 
    end 
    return Amount 
end

local function RPTGetCategory()
    local Table = {}
    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if v.Vehicle == false then 
            if not table.HasValue(Table, v.Category) then 
                table.insert(Table, v.Category)
            end 
        end 
    end
    return Table 
end 


local function RPTGetFineByCategory(String)
    local Table = {}
    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if String == v.Category and v.Vehicle == false then 
            Table[#Table + 1] = v 
        end 
    end
    return Table 
end 

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

local scrw = ScrW()
local scrh = ScrH()

function PANEL:Init()


	self:SetSize(600,640)
	-- self:SetPos(scrw/2 - self:GetWide()/2,scrh)
	self:Center()
	self:MakePopup()

	self:SetTitle("")

	self:ShowCloseButton(false)

	self.Paint = function(s,w,h)

		//Background
	    surface.SetDrawColor(44, 62, 80)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(52, 73, 94)
	    surface.DrawRect(4,28,w-8,h-32)

	end

	local WindowTitle = self:Add( "ixLabel")
	WindowTitle:SetPos(2,2)
	WindowTitle:SetWide(self:GetWide())
	WindowTitle:SetFont("ixSmallBoldFont")
	WindowTitle:SetText( "Edit Charges" )
	WindowTitle:SetContentAlignment(4)
	WindowTitle:SetPadding(5)
	WindowTitle:SetMouseInputEnabled(false)

	self.WindowTitle = WindowTitle

	local DataScroll = vgui.Create( "DScrollPanel", self )
	DataScroll:Dock( FILL )
	DataScroll:DockMargin(5,5,5,5)
	DataScroll.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.DataScroll = DataScroll

	local RpRespX, RpRespY = ScrW(), ScrH()

	local TableFiningSytem = {}
    local DButton1 = {}
    local RPTMoney = 0

	for k,v in pairs(RPTGetCategory()) do 
        DButton1[k] = vgui.Create("DButton", DataScroll)
        DButton1[k]:SetSize(0,50)
        DButton1[k]:SetText("")
        DButton1[k]:SetFont("rpt_font_7")
        DButton1[k]:SetTextColor(Realistic_Police.Colors["white"])
        DButton1[k]:Dock(TOP)
        DButton1[k].Extend = false 
        DButton1[k].FineName = v 
        DButton1[k]:DockMargin(0,5,0,0)
        DButton1[k].Paint = function(s,w,h) 
            if s:IsHovered() then 
                surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                surface.DrawRect( 5, 0, w-10, h )
                surface.SetDrawColor(Realistic_Police.Colors["gray100"])
                surface.DrawOutlinedRect( 5, 0, w-10, h )
                surface.SetDrawColor(Realistic_Police.Colors["gray100"])
                surface.DrawOutlinedRect( 5, 0, w-10, RpRespY*0.05 )
            else 
                surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                surface.DrawRect( 5, 0, w-10, h )
                surface.SetDrawColor(Realistic_Police.Colors["gray100"])
                surface.DrawOutlinedRect( 5, 0, w-10, h )
                surface.SetDrawColor(Realistic_Police.Colors["gray100"])
                surface.DrawOutlinedRect( 5, 0, w-10, RpRespY*0.05 )
            end 
            draw.DrawText("Category : "..v, "rpt_font_7", s:GetWide()/2.05, 15,  Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
        local ParentDScrollPanel = {}
        DButton1[k].DoClick = function()
            if not DButton1[k].Extend then 
                DButton1[k]:SetSize(0,#RPTGetFineByCategory(DButton1[k].FineName) * RpRespY*0.054 + RpRespY*0.06 )
                DButton1[k]:SlideDown(0.5)
                DButton1[k].Extend = true 

                ParentDScrollPanel[k] = vgui.Create("DScrollPanel", DButton1[k])
                ParentDScrollPanel[k]:SetPos(RpRespX*0.0034, RpRespY*0.051)
                ParentDScrollPanel[k]:SetSize(self:GetWide()-50, #RPTGetFineByCategory(DButton1[k].FineName) * RpRespY*0.054 + RpRespY*0.06 )
                ParentDScrollPanel[k]:SlideDown(0.5)
                ParentDScrollPanel[k].Paint = function() end 
                ParentDScrollPanel[k]:GetVBar():SetSize(0,0)

                local DButtonScroll = {}
                for id, v in pairs( RPTGetFineByCategory(DButton1[k].FineName) ) do 
                    DButtonScroll[id] = vgui.Create("DButton", ParentDScrollPanel[k])
                    DButtonScroll[id]:SetSize(0,RpRespY*0.05)
                    DButtonScroll[id]:SetText("")
                    DButtonScroll[id]:SetFont("rpt_font_7")
                    DButtonScroll[id]:SetTextColor(Realistic_Police.Colors["white"])
                    DButtonScroll[id]:Dock(TOP)
                    DButtonScroll[id]:DockMargin(3,4,0,0)
                    DButtonScroll[id].Paint = function(s,w,h) 
                        if s:IsHovered() then 
                            surface.SetDrawColor( Realistic_Police.Colors["gray50"] )
                            surface.DrawRect( 0, 0, w, h )
                            surface.SetDrawColor(Realistic_Police.Colors["gray60"])
                            surface.DrawOutlinedRect( 0, 0, w, RpRespY*0.05 )
                        else 
                            surface.SetDrawColor( Realistic_Police.Colors["gray50"] )
                            surface.DrawRect( 0, 0, w, h )
                            surface.SetDrawColor(Realistic_Police.Colors["gray60"])
                            surface.DrawOutlinedRect( 0, 0, w, RpRespY*0.05 )
                        end 
                        draw.DrawText("  "..(v.Name or ""), "rpt_font_7", DButtonScroll[id]:GetWide()/2.05, RpRespY*0.013,  Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER)
                    end
                    DButtonScroll[id].DoClick = function()
                        
                    	if (self.ChargesList[v.Name]) then
                    		LocalPlayer():Notify("Charge already exists")
                    		return
                    	end

                    	self:ChargesEditing(v.Name)

                    end 
                    
                end 
            else 
                DButton1[k].Extend = false 
                DButton1[k]:SizeTo(DButton1[k]:GetWide(), RpRespY*0.05, 0.5, 0, -1, function()
                    ParentDScrollPanel[k]:Remove()
                end )
            end 
        end 
    end 

    local TotalFine = self:Add( "ixLabel")
	TotalFine:Dock( BOTTOM )
	TotalFine:DockMargin(10,0,0,0)
	TotalFine:SetFont("ixSmallBoldFont")
	TotalFine:SetText( "Total fine: $0" )
	TotalFine.Fine = 0
	TotalFine:SetZPos(4)
	TotalFine:SetContentAlignment(4)
	TotalFine:SetMouseInputEnabled(false)
	TotalFine:SizeToContents()

	self.TotalFine = TotalFine

	local List = self:Add( "DIconLayout" )
	List:Dock( BOTTOM )
	List:DockMargin(5,5,5,5)
	List:SetSize(600,300)
	List:SetSpaceY( 5 )
	List:SetSpaceX( 5 )
	List:SetZPos(3)

	List.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.List = List

	self.ChargesList = {}

	local ConfirmButton = self:Add( "DButton" )
	ConfirmButton:Dock(BOTTOM)
	ConfirmButton:DockMargin(5,0,5,5)
	ConfirmButton:SetTall(40)
	ConfirmButton:SetZPos(2)
	ConfirmButton:SetText("CONFIRM")
	ConfirmButton:SetFont("ixSmallBoldFont")
	ConfirmButton.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	    if (s:IsHovered()) then
	    	surface.SetDrawColor(100,100,100,150)
	    	surface.DrawOutlinedRect(0,0,w,h,2)
	    end
	end
	ConfirmButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		if (self:GetParent()) and (self.PersonTable) then
			
			self:GetParent().PersonCaseData["Suspects"].People[self.PersonTable].Chargers = self.ChargesList
			self:GetParent():CalculateFineValue(self.ProfilePanel, self:GetParent().PersonCaseData["Suspects"].People[self.PersonTable].Chargers)

		end

		self:Close()

	end

	local CloseButton = self:Add( "DButton" )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(5,0,5,5)
	CloseButton:SetTall(40)
	CloseButton:SetZPos(1)
	CloseButton:SetText("CANCEL")
	CloseButton:SetFont("ixSmallBoldFont")
	CloseButton.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	    if (s:IsHovered()) then
	    	surface.SetDrawColor(100,100,100,150)
	    	surface.DrawOutlinedRect(0,0,w,h,2)
	    end
	end
	CloseButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")
		self:Close()

		if (self:GetParent()) then
			self:GetParent().IsModified = false
		end
 
	end

	

end

function PANEL:CheckForCharges()

	if (!table.IsEmpty(self.Charges)) then

		for text, charges in pairs(self.Charges) do
			self:AddCharge(text, charges)
		end

	end

end

function PANEL:ChargesEditing(text)

	local ChargeText = text

	local Amount = GetAmountByName(text)

	local ChargesPnl = self:Add( "DPanel" )
	ChargesPnl:SetSize(300,150)
	ChargesPnl:SetPos(self:GetWide()/2 - ChargesPnl:GetWide()/2, self:GetTall()/2 - ChargesPnl:GetTall()/2)
	ChargesPnl:DockPadding(10,10,10,10)
	ChargesPnl.Paint = function(s,w,h)
		surface.SetDrawColor(44, 62, 80)
	    surface.DrawRect(0,0,w,h)
	end

	local ItemLabel = ChargesPnl:Add( "ixLabel")
	ItemLabel:Dock(TOP)
	ItemLabel:SetFont("ixSmallFont")
	ItemLabel:SetText( text .. " ($"..Amount..")" )
	ItemLabel:SetContentAlignment(5)
	ItemLabel:SizeToContents()

	local ChargeNumSlider = vgui.Create( "DNumSlider", ChargesPnl )
	ChargeNumSlider:Dock(TOP)
	ChargeNumSlider:SetTall(50)
	ChargeNumSlider:SetText( "Charge Count" )
	ChargeNumSlider:SetMin( 1 )
	ChargeNumSlider:SetDefaultValue ( 1 )
	ChargeNumSlider:SetMax( 10 )
	ChargeNumSlider:SetDecimals( 0 )

	local SubmitButton = ChargesPnl:Add( "DButton" )
	SubmitButton:Dock(BOTTOM)
	SubmitButton:SetTall(20)
	SubmitButton:SetZPos(2)
	SubmitButton:SetText("Submit")
	SubmitButton.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	    if (s:IsHovered()) then
	    	surface.SetDrawColor(100,100,100,150)
	    	surface.DrawOutlinedRect(0,0,w,h,2)
	    end
	end
	SubmitButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")
		
		self:AddCharge(ChargeText, math.Round(ChargeNumSlider:GetValue(), 0), index)

		ChargesPnl:Remove()
 
	end

	local CloseButton = ChargesPnl:Add( "DButton" )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(0,5,0,5)
	CloseButton:SetTall(20)
	CloseButton:SetZPos(1)
	CloseButton:SetText("Cancel")
	CloseButton.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	    if (s:IsHovered()) then
	    	surface.SetDrawColor(100,100,100,150)
	    	surface.DrawOutlinedRect(0,0,w,h,2)
	    end
	end
	CloseButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")
		
		ChargesPnl:Remove()
 
	end

end

function PANEL:AddCharge(text, charges)

	self.ChargesList[text] = charges

	local Amount = GetAmountByName(text)

	local fine = Amount * charges

	self.TotalFine.Fine = self.TotalFine.Fine + fine
	self.TotalFine:SetText( "Total fine: $"..self.TotalFine.Fine )
	

	local ListItem = self.List:Add( "DButton" )
	ListItem:SetSize( 80, 40 )
	ListItem:SetText("")
	ListItem.Fine = fine
	ListItem.Paint = function(s,w,h)
		
		surface.SetDrawColor(40,40,40,100)
	    surface.DrawRect(0,0,w,h)

	end
	ListItem.DoClick = function(s)

		Derma_Query(
		    "Are you sure about that?",
		    "Delete confirmation",
		    "Yes",
		    function()

		    	s:Remove()
		    	self.List:InvalidateLayout()

		    	self.TotalFine.Fine = self.TotalFine.Fine - s.Fine
				self.TotalFine:SetText( "Total fine: $"..self.TotalFine.Fine )

		    	self.ChargesList[text] = nil

		    end,
			"No",
			function() end
		)

	end


	local ItemLabel = ListItem:Add( "ixLabel")
	ItemLabel:SetPos(10,ListItem:GetTall()*0.25)
	ItemLabel:SetFont("ixSmallFont")
	ItemLabel:SetText( text .. " ( x"..charges.." )" )
	ItemLabel:SetContentAlignment(5)
	ItemLabel:SetMouseInputEnabled(false)
	ItemLabel:SizeToContents()

	ListItem:InvalidateLayout( true )
	ListItem:SizeToChildren(true, false)

	ListItem:SetWide(ListItem:GetWide() + 10)

end


vgui.Register("ixPoliceStuff_ChargesEditing", PANEL, "DFrame")

-- vgui.Create("ixPoliceStuff_ChargesEditing")