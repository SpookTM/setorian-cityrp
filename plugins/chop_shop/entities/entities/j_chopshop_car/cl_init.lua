include("shared.lua")


function ENT:Initialize()

	local modelboundsMin, modelboundsMax = self:GetModelBounds()

	self.center = self:OBBCenter() --modelboundsMax - modelboundsMin

	self.HighPoint = self:OBBCenter().z

	self.FadeValue = 1

end

function ENT:Think()

	if (self:GetDestroyFade()) then
		self.FadeValue = math.Clamp(self.FadeValue - 3 * FrameTime(), 0, 1)

		self:SetColor( ColorAlpha(self:GetColor(), 255 * self.FadeValue) ) 
		self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	end

end

local bg_color = Color(20,20,20,150)
local progress_color = Color(39, 174, 96)

local text_color = Color(250,250,250)

local localplayer = localplayer or LocalPlayer()

function ENT:Draw()

	self:DrawModel()

	if (localplayer:GetPos():DistToSqr(self:GetPos()) < 200000) then

		local Ang = self:GetAngles()
		-- local Pos = self:GetPos()
		local Pos = (self.center and self:LocalToWorld(self.center)) or self:GetPos()

		-- print(self.center, self:LocalToWorld(self.center), self:GetPos())
		
		local drawPos = (self:LocalToWorld(self:GetCurProgresPos()) + Vector( 0,0,20 )):ToScreen()
		
		cam.Start3D2D(Pos + Ang:Up() * (self.HighPoint), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.1 )
			
			surface.SetDrawColor(bg_color)
			surface.DrawRect(-172,-58,344,115)

			surface.SetDrawColor(progress_color)
			surface.DrawRect(-170,-55,340 * (self:GetMainProgress()/100),110)

			draw.SimpleText(self:GetMainProgress().."%", "ix3D2DFont", 0,0, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			

		cam.End3D2D()

	end

end

local animProgress = 0

local function DrawHelpPoints()
	
	local car = Entity(localplayer:GetLocalVar("DismantleCar"))--localplayer:GetEyeTrace().Entity    

    local PlayerPos = localplayer:GetPos()

    local FadePos = PlayerPos:DistToSqr(car:LocalToWorld(car:GetCurProgresPos())) / 15000

    local FadeColor = math.Clamp(255 / FadePos, 0, 255)

    local drawPos = car:LocalToWorld(car:GetCurProgresPos()):ToScreen()

    animProgress = Lerp(10 * FrameTime(), animProgress, car:GetCurrentProgress())

    if (car:GetCurrentProgress() >= 100) then
    	animProgress = 0
    end
    
    -- surface.SetDrawColor(progress_color)
	-- surface.DrawRect(drawPos.x - 55, drawPos.y - 55,110,110)
	draw.SimpleTextOutlined( string.upper("dismantle here"), "ixMediumFont", drawPos.x, drawPos.y + 35, ColorAlpha(text_color, FadeColor), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, bg_color)
	draw.SimpleTextOutlined( "n", "ixIconsBig", drawPos.x, drawPos.y, ColorAlpha(text_color, FadeColor), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, bg_color)
	draw.SimpleTextOutlined( math.Round(animProgress).."%", "ixMediumFont", drawPos.x, drawPos.y - 35, ColorAlpha(text_color, FadeColor), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, bg_color)
   
end

local PLUGIN = PLUGIN

function JChopShop_RendersHUDs()
        localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
        if (!IsValid(localplayer)) then return end

		if (!localplayer:GetCharacter()) then return end

		-- if (localplayer:GetEyeTrace().Hit and localplayer:GetEyeTrace().Entity and IsValid(localplayer:GetEyeTrace().Entity) and localplayer:GetEyeTrace().Entity:GetClass() == "j_chopshop_car") then	
	    if (localplayer:GetLocalVar("DismantleCar")) and IsValid(Entity(localplayer:GetLocalVar("DismantleCar"))) and (Entity(localplayer:GetLocalVar("DismantleCar")):GetClass() == "j_chopshop_car") and (localplayer:GetPos():DistToSqr(Entity(localplayer:GetLocalVar("DismantleCar")):GetPos()) < 100000) then
	        DrawHelpPoints()
		end
end

hook.Add("HUDPaintBackground", "DrawHelpPointsForCarShops", JChopShop_RendersHUDs)