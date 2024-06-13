local LABEL = {}
AccessorFunc(LABEL, "autoSizeToContents", "AutoSizeToContents", FORCE_BOOL)
LABEL.autoSizeToContents = true



function LABEL:Init()
	local Schemacolor = ix.config.Get("color")
	self:SetFont("Trebuchet24")
	self:SetTextColor( Schemacolor )
end

function LABEL:Think()
	self.BaseClass.Think(self)

	if ( self.OnThink ) then
		self:OnThink()
	end
end

function LABEL:SetText(text)
    self.BaseClass.SetText(self, text)

    if ( self.autoSizeToContents ) then
        self:SizeToContents()
	end

	if ( self.OnTextChanged ) then
		self:OnTextChanged()
	end
end

function LABEL:FadeIn(speed)
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

function LABEL:FadeOut(speed)
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

vgui.Register("forpLabel", LABEL, "DLabel")