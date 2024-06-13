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
	
	-- Ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
	Ang:RotateAroundAxis(self:GetAngles():Right(), 180)
	
	if (LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 300*300) then
		cam.Start3D2D( self:GetPos() + Ang:Up()*3 + Ang:Forward() * 6, Ang, 0.07 )

		draw.SimpleTextOutlined("Deposit Box", "ixBigFont", 0, -40,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )


		if (self:GetCooldown() > 0) then

			draw.SimpleTextOutlined("Cooldown", "ixBigFont", 0, 0,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )
			draw.SimpleTextOutlined(PLUGIN:NiceFormatTime(self:GetCooldown()), "ix3D2DMediumFont", 0, 34,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )
		else
			draw.SimpleTextOutlined( ( PLUGIN:EnoughPolice() and "F") or "G", "ixIconsMedium", -105, 0,  self:AnimatedFadeOut( (PLUGIN:EnoughPolice() and Color(46, 204, 113)) or Color(231, 76, 60) ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )
			draw.SimpleTextOutlined("Enough Police officers", "ix3D2DSmallFont", -75, 0,  self:AnimatedFadeOut(Color(250,250,250)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, self:AnimatedFadeOut(Color(25, 25, 25, 100)) )
	
		end


		cam.End3D2D()
	end

end
