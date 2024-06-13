if (SERVER) then return end

local PANEL = {}

local PLUGIN = PLUGIN

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(850,570)
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

	   draw.SimpleText("Preview", "ix3D2DSmallFont", 12,1, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)

	  
	end

	self.ImageView = ""

	local RenderView = vgui.Create( "DPanel", self )
	RenderView:Dock(FILL)
	RenderView:DockMargin(2,0,2,2)
	RenderView.Paint = function(s,w,h)

		if (self.ImageView != "") then

			

		-- local x, y = self:GetPos()
		
		-- local old = DisableClipping( true ) -- Avoid issues introduced by the natural clipping of Panel rendering
		-- render.RenderView( {
		-- 	origin = self.VectorView,
		-- 	angles = self.AngleView,
		-- 	x = x+6, 
		-- 	y = y+26,
		-- 	w = w, 
		-- 	h = h,
		-- 	drawviewmodel = false
		-- } )
		-- DisableClipping( old )



			surface.SetDrawColor( 255,255,255 )
		    surface.SetMaterial( self.ImageView )
			surface.DrawTexturedRect(0,0,w,h)


		else
			draw.SimpleText("No preview", "DermaLarge", w/2,h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

	end

end

function PANEL:SetImage(img)

	if (!img) or (img == NULL) or (img == "") then self.ImageView = "" return end

	local CustomImage = Material("nil")

	PLUGIN:GetImgur(img,function(mat)
		CustomImage = mat
	end)

	self.ImageView = CustomImage or ""
	
end


vgui.Register("ixPropertiesMenu_preview", PANEL, "DFrame")
-- vgui.Create("ixPropertiesMenu_preview")
    