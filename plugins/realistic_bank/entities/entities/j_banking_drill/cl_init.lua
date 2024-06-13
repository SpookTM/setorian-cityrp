include("shared.lua")


function ENT:Initialize()

	self.drillBon = self:GetChildren()[1]:LookupBone( "Bit" )

-- self:GetChildren()[1]:ManipulateBonePosition(self.drillBon, Vector(50,0,0))
	

end

function ENT:Think()

	if (self:GetJammed()) then return end
	
	if (self.drillBon) then
		self:GetChildren()[1]:ManipulateBoneAngles( self.drillBon, Angle(RealTime()*500,0,0) )
	end

end


function ENT:Draw()
	-- self:DrawModel()

	local Ang = self:GetAngles()
	local Pos = self:GetPos();
	
	Ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
	Ang:RotateAroundAxis(self:GetAngles():Forward(), -30)

	local progress = math.Remap(self:GetProgress(), 0, 120, 0, 80)
	
	if (LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 300*300)  then	
		cam.Start3D2D( self:GetPos() + Ang:Up() * -4.75 + Ang:Right() * -2 + Ang:Forward() * -5, Ang, 0.07 )
		-- draw.SimpleTextOutlined("Closing in", "ixBigFont", 0, 0,  Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100) )

		-- draw.RoundedBox(0, -100, 0, 50, 20, Color(255,25,25))

		surface.SetDrawColor(52, 73, 94)
		surface.DrawRect(-70,-45,108,85)

		draw.SimpleTextOutlined( (self:GetJammed() and "JAMMED") or "DRILLING", "ixSmallFont", -15, -15, (self:GetJammed() and Color( 255 ,math.abs(math.cos(RealTime() * 4) * 255),math.abs(math.cos(RealTime() * 4) * 255))) or Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100) )

		draw.SimpleTextOutlined( string.ToMinutesSeconds(self:GetProgress()), "ixSmallFont", -15, 23, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100) )


		surface.SetDrawColor(44, 62, 80)
		surface.DrawRect(-55-1,0-1,80+2,10+2)

		surface.SetDrawColor(39, 174, 96)
		surface.DrawRect(-55,0,80 - progress,10)

		cam.End3D2D()
	end

end
