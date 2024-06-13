include("shared.lua")


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

	Ang:RotateAroundAxis(self:GetAngles():Right(), -90)
	Ang:RotateAroundAxis(self:GetAngles():Forward(), 90)

	if (LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 300*300)then	
		cam.Start3D2D( self:GetPos() + Ang:Right() * -10 + Ang:Up() * 8.45, Ang, 0.1 )
		
		surface.SetDrawColor(self:AnimatedFadeOut(Color(47, 53, 66)))
	    surface.DrawRect(-240,-10,480,70)

	    surface.SetDrawColor(self:AnimatedFadeOut(Color(44, 62, 80, 230)))
	    surface.DrawRect(-240,-5,480,60)

		draw.DrawText("SWAT LOCKER", "ix3D2DMediumFont", 0,0, self:AnimatedFadeOut(Color(255,255,255)), TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end

end
