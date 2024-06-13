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

	   draw.SimpleText("Rent price", "ix3D2DSmallFont", 12,1, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)

	   draw.SimpleText("How much will it cost to rent per hour?", "DermaDefault", w/2,45, Color( 240,240,240 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	   draw.SimpleText("Write a price below", "DermaDefault", w/2,60, Color( 240,240,240 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	end

	self.RentTime = vgui.Create( "DTextEntry", self )
	self.RentTime:SetPos( 30, 85 )
	self.RentTime:SetSize( self:GetWide()-70, 20 )
	-- self.RentTime:SetText( "Rent Time [In hours]" )
	-- self.RentTime.OnValueChanged = function( s, value )
		-- self.Price =  math.Round(value) * 1

	-- end

	self.AcceptButton = vgui.Create( "ixMenuButton", self )
	self.AcceptButton:SetFont("ix3D2DSmallFont")
	self.AcceptButton:SetText( "Set" )
	self.AcceptButton:SetContentAlignment(5)
	self.AcceptButton:SetPos( 25, 120 )
	self.AcceptButton:SetSize( self:GetWide()-60, 30 )
	self.AcceptButton.DoClick = function(pnl)
        netstream.Start("ixPropeties_SetRentPrice", self.sName, self.RentTime:GetValue())
        self:GetParent():DataUpdate(true) 
        self:Close()
    end
	self.AcceptButton.Paint = function(s,w,h)
		
	 	surface.SetDrawColor(44, 62, 80)
	    surface.DrawRect(0,0,w,h)
		s:PaintBackground(w, h)

	end

end


vgui.Register("ixPropertiesMenu_rent_price", PANEL, "DFrame")
-- vgui.Create("ixPropertiesMenu_rent_price")
    