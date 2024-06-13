if (SERVER) then return end

local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(350,170)
	self:Center()
	self:MakePopup()
	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(true)
	self:SetDraggable(true)

	self.Price = 0

	self.Paint = function(s,w,h)

	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(52, 73, 94, 255)
	    surface.DrawRect(5,5,w-10,h-10)

	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(5,5,w-10,20)

	    //RentTime BG
	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(25,80,w-60,30)

	   draw.SimpleText("Rent", "ix3D2DSmallFont", 12,1, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)

	   draw.SimpleText("How long would you like to rent the property for?", "DermaDefault", w/2,45, Color( 240,240,240 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	   draw.SimpleText(s.Price.." tokens per hour", "DermaDefault", w/2,60, Color( 240,240,240 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	end

	self.RentTime = vgui.Create( "DNumSlider", self )
	self.RentTime:SetPos( 30, 80 )
	self.RentTime:SetSize( self:GetWide()-60, 30 )
	self.RentTime:SetText( "Rent Time [In hours]" )
	self.RentTime:SetMin( 1 )
	self.RentTime:SetMax( 10 )
	self.RentTime:SetDecimals( 0 )
	self.RentTime:SetValue(1)
	self.RentTime:GetTextArea():SetEditable(false)
	self.RentTime.OnValueChanged = function( s, value )
		-- self.Price =  math.Round(value) * 1
		-- if IsValid(self.AcceptButton) then
		-- 	self.AcceptButton:SetText("Rent ["..ix.currency.Get( math.Round(value) * self.Price ).." in total]")
		-- end
	end

	self.AcceptButton = vgui.Create( "ixMenuButton", self )
	self.AcceptButton:SetFont("ix3D2DSmallFont")
	self.AcceptButton:SetText( "Rent" )
	self.AcceptButton:SetContentAlignment(5)
	self.AcceptButton:SetPos( 25, 120 )
	self.AcceptButton:SetSize( self:GetWide()-60, 30 )
	self.AcceptButton.DoClick = function(pnl)
        self:GetParent():DataUpdate()
        netstream.Start("ixPropeties_Rent", self.sName, math.Round(self.RentTime:GetValue()))
        self:Close()
    end
	self.AcceptButton.Paint = function(s,w,h)
		
	 	surface.SetDrawColor(44, 62, 80)
	    surface.DrawRect(0,0,w,h)
		s:PaintBackground(w, h)

	end

end


vgui.Register("ixPropertiesMenu_rent", PANEL, "DFrame")
-- vgui.Create("ixPropertiesMenu_rent")
    