include("shared.lua")


function ENT:Initialize()
	self.dlight = DynamicLight( self:EntIndex() )
	self.dlight2 = DynamicLight( self:EntIndex() )
end

function ENT:Think()

	if (self:GetIsWorking()) then
		
		if ( self.dlight ) then
			self.dlight.pos = self:GetPos() + self:GetUp()*50 --+ self:GetForward()*15
			self.dlight.r = 255
			self.dlight.g = 250
			self.dlight.b = 250
			self.dlight.brightness = 8
			self.dlight.Decay = 50
			self.dlight.Size = 35
			self.dlight.style = 0
			self.dlight.DieTime = CurTime() + 1
		end

		-- if ( self.dlight2 ) then
		-- 	self.dlight2.pos = self:GetPos() + self:GetUp()*50 + self:GetForward()*-15
		-- 	self.dlight2.r = 255
		-- 	self.dlight2.g = 250
		-- 	self.dlight2.b = 250
		-- 	self.dlight2.brightness = 9
		-- 	self.dlight2.Decay = 100
		-- 	self.dlight2.Size = 25
		-- 	self.dlight2.style = 0
		-- 	self.dlight2.DieTime = CurTime() + 1
		-- end

	end

end

function ENT:AnimatedFadeOut(Color)

	local plyDist = LocalPlayer():GetPos():DistToSqr(self:GetPos())

	local DistanceAlpha = math.Clamp( math.Remap(plyDist , 260*260, 200*200, 0, Color.a ), 0, Color.a)

	return ColorAlpha( Color, DistanceAlpha )
end

local w,h = 309,217

function ENT:Draw()

	self:DrawModel()

	if (LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 270*270) then return end

	local Ang = self:GetAngles() + Angle(0,0,-30)

	Ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
	Ang:RotateAroundAxis(self:GetAngles():Up(), 180)

	cam.Start3D2D( self:LocalToWorld(Vector( 27, 17.43, 40.78 )), Ang, 0.04 )
	
	-- draw.RoundedBox(0,-170+2,-140+2, 232-4,250-4, Color(60,60,60,200))
	-- draw.RoundedBox(0,-170+4,-140+4, 232-8,250-8, Color(0,0,0,150))

	surface.SetDrawColor(self:AnimatedFadeOut(Color(127, 140, 141)))
    surface.DrawRect(0,0,w,h)

    surface.SetDrawColor(self:AnimatedFadeOut(color_black))
    surface.DrawOutlinedRect(0,0,w,h, 1)

    draw.RoundedBox(10, 10, 10, w-20, h-20, self:AnimatedFadeOut(color_black))

    if (!self:GetIsWorking()) then

		draw.SimpleTextOutlined("OFFLINE", "ixBigFont", w/2, h*0.45,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )

    else

	    draw.RoundedBox(10, 11, 11, w-22, h-22, self:AnimatedFadeOut(Color(52, 73, 94)))

	    surface.SetDrawColor(self:AnimatedFadeOut(Color(44, 62, 80)))
	    surface.DrawRect(11,20,w-22,40)

	    surface.SetDrawColor(self:AnimatedFadeOut(Color(189, 195, 199)))
	    surface.DrawRect(11,20,w-22,2)

	    surface.SetDrawColor(self:AnimatedFadeOut(Color(189, 195, 199)))
	    surface.DrawRect(11,60,w-22,2)

	    surface.SetDrawColor(self:AnimatedFadeOut(Color(44, 62, 80)))
	    surface.DrawRect(11,80,w-22,100)

	    surface.SetDrawColor(self:AnimatedFadeOut(Color(189, 195, 199)))
	    surface.DrawRect(11,80,w-22,2)

	    surface.SetDrawColor(self:AnimatedFadeOut(Color(189, 195, 199)))
	    surface.DrawRect(11,180,w-22,2)

	    surface.SetDrawColor(self:AnimatedFadeOut(Color(189, 195, 199)))
	    surface.DrawRect(11,130,w-22,2)

	    -- surface.SetDrawColor(self:AnimatedFadeOut(Color(189, 195, 199)))
	    -- surface.DrawRect(10,10,309,217)

		draw.SimpleTextOutlined("Drying Rack", "ixBigFont", w/2, 20,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )

		draw.SimpleTextOutlined("Wet Leaves: "..self:GetWetLeaves(), "ixMediumFont", w/2, 90,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )

		draw.SimpleTextOutlined("Dry Leaves: "..self:GetDryLeaves(), "ixMediumFont", w/2, 140,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )

	end

	cam.End3D2D()

end

-- function ENT:OnPopulateEntityInfo(tooltip)

-- 	local text = tooltip:AddRow("name")
-- 	text:SetImportant()
-- 	text:SetText("Drying Rack")
-- 	text:SizeToContents()

-- 	local WetLeaves = tooltip:AddRowAfter("name", "wetleaves")
--  	WetLeaves:SetBackgroundColor(Color(174, 174, 39))
-- 	WetLeaves:SetText( "Wet Leaves: "..self:GetWetLeaves())
--  	WetLeaves:SizeToContents()

-- 	local DryLeaves = tooltip:AddRowAfter("wetleaves", "dryleaves")
-- 	DryLeaves:SetBackgroundColor( Color(41, 128, 185) ) 
-- 	DryLeaves:SetText( "Dry Leaves: "..self:GetDryLeaves())
--  	DryLeaves:SizeToContents()

--  	local desc = tooltip:AddRowAfter("dryleaves", "desc")
-- 	desc:SetText( "Place the leaves here to dry them")
--  	desc:SizeToContents()

--  	tooltip:SizeToContents()

-- end