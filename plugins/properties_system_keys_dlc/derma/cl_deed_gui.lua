
surface.CreateFont("Deed_SmallFont", {
		font = "Roboto",
		size = 11,
		extended = true,
		weight = 700
	})

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

local background = Material("properties_sys/deed.png", "noclamp smooth")

function PANEL:Init()
-- frame:SetSize(800,550)

	self:SetSize(500,700)
	self:Center()
	self:MakePopup()


	self:SetTitle("")
	self:ShowCloseButton(true)

	self.FullName = ""
	self.Date = ""
	self.Type = ""

	self.Paint = function(s,w,h)

		surface.SetDrawColor( 255,255,255 )
	    surface.SetMaterial( background )
		surface.DrawTexturedRect(0,0,w,h)

		surface.SetDrawColor( 60, 60, 60)
		surface.DrawOutlinedRect(0, 0, w, h, 3)

		// Full Name
		draw.SimpleText(self.FullName, "ixGenericFont", 160, 293, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

		// MM/DD/YY
		draw.SimpleText(self.Date, "ixGenericFont", 220, 330, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

		// Type
		draw.SimpleText(self.Type, "ixGenericFont", 215, 370, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

		//Deed Information
		draw.SimpleText(self.FullName, "Deed_SmallFont", 20, h - 223, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

		// Bottom x
		draw.SimpleText(self.FullName, "DermaDefault", 90, h - 100, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	--      surface.SetDrawColor( 0,0,0, 250 )
	--     surface.DrawRect(50,50,w-100,50)

	end




end

function PANEL:Populate(type,owner,date)
	self.FullName = owner
	self.Date = date
	self.Type = type
end

vgui.Register("ix_deedGUI", PANEL, "DFrame")


