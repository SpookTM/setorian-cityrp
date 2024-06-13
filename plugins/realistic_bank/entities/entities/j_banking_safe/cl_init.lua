include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()
end

function ENT:AnimatedFadeOut(Color)

	local plyDist = LocalPlayer():GetPos():DistToSqr(self:GetPos())

	local DistanceAlpha = math.Clamp( math.Remap(plyDist , 260*260, 200*200, 0, Color.a ), 0, Color.a)

	return ColorAlpha( Color, DistanceAlpha )
end

function ENT:Draw()
	self:DrawModel()


	local Ang = self:GetAngles()
	local Pos = self:GetPos();
	
	Ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
	Ang:RotateAroundAxis(self:GetAngles():Up(), 90)
	
	if (LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 300*300)then	
		cam.Start3D2D( self:GetPos() + Ang:Up()*21 + Ang:Right() * -40, Ang, 0.07 )

		if (self:GetAutoClose() > 0) then

			draw.SimpleTextOutlined("Closing in", "ixBigFont", 0, -80,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )
			draw.SimpleTextOutlined(string.ToMinutesSeconds( self:GetAutoClose() ), "ix3D2DFont", 0, 0,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )


		elseif (self:GetCooldown() > 0) then
			
			draw.SimpleTextOutlined("Cooldown", "ixBigFont", 0, 40,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )
			draw.SimpleTextOutlined(PLUGIN:NiceFormatTime(self:GetCooldown()), "ix3D2DMediumFont", 0, 70,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )

		else

			draw.SimpleTextOutlined( ( PLUGIN:EnoughPolice() and "F") or "G", "ixIconsBig", -205, 120,  self:AnimatedFadeOut( (PLUGIN:EnoughPolice() and Color(46, 204, 113)) or Color(231, 76, 60) ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )
			draw.SimpleTextOutlined("Enough Police officers", "ix3D2DMediumFont", -165, 120,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )

		end

		cam.End3D2D()
	end

end
