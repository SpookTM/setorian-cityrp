local BUTTON = {}
AccessorFunc(BUTTON, "autoSizeToContents", "AutoSizeToContents", FORCE_BOOL)
BUTTON.autoSizeToContents = true

AccessorFunc(BUTTON, "Selected", "Selected", FORCE_BOOL)
AccessorFunc(BUTTON, "greyedColor", "GreyedColor", FORCE_BOOL)
AccessorFunc(BUTTON, "color", "NoGreyedColor", FORCE_BOOL)



function BUTTON:Init()
	local Schemacolor = ix.config.Get("color")
	self:SetFont("Trebuchet24")

	self:SetTextColor( Schemacolor )
	self.greyedColor = self.greyedColor or fo.ui.GetHUDGreyColor()
end

function BUTTON:SetText(text)
    self.BaseClass.SetText(self, text)

    if ( self.autoSizeToContents ) then
        self:SizeToContents()
	end

	if ( self.OnTextChanged ) then
		self:OnTextChanged()
	end
end

function BUTTON:Paint(w, h)
	if ( self.Greyed ) then return end

	if ( self.Hovered or self.Selected ) then
		local r, g, b = self:GetTextColor().r, self:GetTextColor().g, self:GetTextColor().b

		surface.SetDrawColor(Color(r,g,b,10))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(Color(r,g,b,245))
		surface.DrawRect(0, 0, w, 2)
		surface.DrawRect(0, h-2, w, 2)
		surface.DrawRect(0, 0, 2, h)
		surface.DrawRect(w-2, 0, 2, h)
	end
end

function BUTTON:Think()
	if (self.animation) then
		self.animation:Run()
	end

	if ( not self.Greyed ) then
		if ( self.Hovered and not self.CallHover ) then
			self.CallHover = true
			self:OnHover()
		elseif ( not self.Hovered and self.CallHover ) then
			self.CallHover = false
		end
	end
	
	self.BaseClass.Think(self)
end

function BUTTON:FadeIn(speed)
	self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
		panel:SetAlpha(delta * 255)
		
		alpha = (delta * 255)
		
		if (animation.Finished) then
			self.animation = nil
		end
	end)

	if (self.animation) then
		self.animation:Start(speed)
	end
	
	self:SetVisible(true)
end

function BUTTON:FadeOut(speed)
	self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
		panel:SetAlpha(255 - (delta * 255))
		
		if (animation.Finished) then
			self.animation = nil
		end
	end)
	
	if (self.animation) then
		self.animation:Start(speed)
	end
end

function BUTTON:SetGreyed(state)
	self.Greyed = state

	if ( state ) then
		self:SetTextColor( self.greyedColor )
	else
		self:SetTextColor( self.color )
	end
end

function BUTTON:GetGreyed()
	return self.Greyed or false
end

function BUTTON:OnMouseReleased(key)
	if ( self.Greyed ) then return end

	self:MouseCapture(false)
	
	if ( not self.Hovered ) then
		surface.PlaySound("forp/ui_menu_cancel.wav")
	end

	if ( key == MOUSE_LEFT and self.DoClick and self.Hovered ) then
		surface.PlaySound("forp/ui_menu_ok.wav")
		self:DoClick()
	end
end

function BUTTON:OnHover()
	surface.PlaySound("forp/ui_menu_focus.wav")
end

vgui.Register("forpButton", BUTTON, "DButton")