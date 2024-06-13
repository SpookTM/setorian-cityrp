include("shared.lua")


function ENT:Initialize()	
	self.SmokeTimer = CurTime()
	self.emitter = ParticleEmitter(self.Entity:GetPos())
	self.emitter2 = ParticleEmitter(self.Entity:GetPos())
	self.emitter3 = ParticleEmitter(self.Entity:GetPos())
	self.emitter4 = ParticleEmitter(self.Entity:GetPos())
end

local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
local color_green = Color(0, 255, 0, 255)
local color_red = Color(255, 50, 50, 255)
local color_blue = Color(0, 0, 255, 255)

local burnMaterial = ix.util.GetMaterial("sprites/glow04_noz")

function ENT:Draw()

	self:DrawModel()


	for i = 1, 4 do

		local position = self:GetPos() + self:GetUp() * 35.5 + self:GetForward() * (-1.5 + (i-1)*3.35) + self:GetRight() * 15.7

		local colorState = (i==1 and ((self:Get1BurnerOn() and color_green) or color_red)) or (i==2 and ((self:Get2BurnerOn() and color_green) or color_red)) or (i==3 and ((self:Get3BurnerOn() and color_green) or color_red)) or (i==4 and ((self:Get4BurnerOn() and color_green) or color_red))

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position, 5, 5, colorState)

	end

	local Ang = self:GetAngles()
	local Pos = self:GetPos()
	
	-- Ang:RotateAroundAxis(self:GetAngles():Forward(), 90)

	-- local L_F1_Pos = self:GetPos()+(self:GetRight()*6.25)+(self:GetUp()*39.5)+(self:GetForward()*-6.5);
	-- render.DrawSprite(L_F1_Pos, 4, 4, Color(255, 255, 100, 255));

	
	cam.Start3D2D(self:LocalToWorld(Vector( -12.97, 12.84, 39 )), Ang, 0.07)

		surface.SetDrawColor(ColorAlpha(color_blue,math.abs(math.cos(RealTime() * 3) * 140) + 165))
		-- surface.DrawRect(0,0,150,50)

		surface.SetMaterial(burnMaterial)
		if (self:Get1BurnerOn()) then
			surface.DrawTexturedRect(30,32,120,120)
		end

		if (self:Get3BurnerOn()) then
			surface.DrawTexturedRect(36,225,100,100)
		end

		if (self:Get2BurnerOn()) then
			surface.DrawTexturedRect(222,32,120,120)
		end

		if (self:Get4BurnerOn()) then
			surface.DrawTexturedRect(216,210,130,130)
		end

	cam.End3D2D()

	Ang:RotateAroundAxis(self:GetAngles():Forward(), 90)

	cam.Start3D2D(self:LocalToWorld(Vector( -1.55, -16.16, 34.4 )), Ang, 0.05)
		draw.SimpleText("1", "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("2", "DermaLarge", 67, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("3", "DermaLarge", 135, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("4", "DermaLarge", 202, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()

end

ENT.PopulateEntityInfo = true


function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Stove")
	text:SizeToContents()


 	local desc = tooltip:AddRowAfter("name", "desc")
	desc:SetText( "Stove prepared for cooking meth")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end

function ENT:Think()
	
	if (!self:GetIsWorking()) then return end
	self.SmokeTimer = self.SmokeTimer or 0
	if self.SmokeTimer > CurTime() then return end

	self.SmokeTimer = CurTime() + math.Rand(0.02,0.1)  --0.0150
	
	if (self:Get1BurnEnt()) and (self:Get1BurnEnt() != NULL) and (self:Get1BurnerOn()) then

		local vOffset = self:Get1BurnEnt():GetPos()+(self:Get1BurnEnt():GetUp()*10); -- random pos near entity pos
		local vNormal = (vOffset - self:Get1BurnEnt():GetPos()):GetNormalized() + (self:Get1BurnEnt():GetUp()*2) + (self:Get1BurnEnt():GetRight() * 0.5) + (self:Get1BurnEnt():GetForward() * 0.5) -- get direction vector from ent position to random spot

		
		self.emitter:SetPos(vOffset)  -- update emitter position
		local particle = self.emitter:Add("particle/smokesprites_000"..math.random(1,9), vOffset) -- add new particle to emitter
		particle:SetVelocity( vNormal * math.Rand( 5,15) )
	    particle:SetDieTime( 0.6 )
		particle:SetStartAlpha(math.Rand(50, 150))
	    particle:SetStartSize(math.Rand(5,10))
	    particle:SetEndSize( math.Rand(10, 20))
	    particle:SetRoll( math.Rand( -0.2, 0.2 ) )
	    particle:SetColor( 120, 200, 120 )
	end

	if (self:Get2BurnEnt()) and (self:Get2BurnEnt() != NULL) and (self:Get2BurnerOn()) then

		local vOffset = self:Get2BurnEnt():GetPos()+(self:Get2BurnEnt():GetUp()*10); -- random pos near entity pos
		local vNormal = (vOffset - self:Get2BurnEnt():GetPos()):GetNormalized() + (self:Get2BurnEnt():GetUp()*2) + (self:Get2BurnEnt():GetRight() * 0.5) + (self:Get2BurnEnt():GetForward() * 0.5) -- get direction vector from ent position to random spot

		
		self.emitter:SetPos(vOffset)  -- update emitter position
		local particle = self.emitter:Add("particle/smokesprites_000"..math.random(1,9), vOffset) -- add new particle to emitter
		particle:SetVelocity( vNormal * math.Rand( 5,15) )
	    particle:SetDieTime( 0.6 )
		particle:SetStartAlpha(math.Rand(50, 150))
	    particle:SetStartSize(math.Rand(5,10))
	    particle:SetEndSize( math.Rand(10, 20))
	    particle:SetRoll( math.Rand( -0.2, 0.2 ) )
	    particle:SetColor( 120, 200, 120 )
	end

	if (self:Get3BurnEnt()) and (self:Get3BurnEnt() != NULL) and (self:Get3BurnerOn()) then

		local vOffset = self:Get3BurnEnt():GetPos()+(self:Get3BurnEnt():GetUp()*10); -- random pos near entity pos
		local vNormal = (vOffset - self:Get3BurnEnt():GetPos()):GetNormalized() + (self:Get3BurnEnt():GetUp()*2) + (self:Get3BurnEnt():GetRight() * 0.5) + (self:Get3BurnEnt():GetForward() * 0.5) -- get direction vector from ent position to random spot

		
		self.emitter:SetPos(vOffset)  -- update emitter position
		local particle = self.emitter:Add("particle/smokesprites_000"..math.random(1,9), vOffset) -- add new particle to emitter
		particle:SetVelocity( vNormal * math.Rand( 5,15) )
	    particle:SetDieTime( 0.6 )
		particle:SetStartAlpha(math.Rand(50, 150))
	    particle:SetStartSize(math.Rand(5,10))
	    particle:SetEndSize( math.Rand(10, 20))
	    particle:SetRoll( math.Rand( -0.2, 0.2 ) )
	    particle:SetColor( 120, 200, 120 )
	end

	if (self:Get4BurnEnt()) and (self:Get4BurnEnt() != NULL) and (self:Get4BurnerOn()) then

		local vOffset = self:Get4BurnEnt():GetPos()+(self:Get4BurnEnt():GetUp()*10); -- random pos near entity pos
		local vNormal = (vOffset - self:Get4BurnEnt():GetPos()):GetNormalized() + (self:Get4BurnEnt():GetUp()*2) + (self:Get4BurnEnt():GetRight() * 0.5) + (self:Get4BurnEnt():GetForward() * 0.5) -- get direction vector from ent position to random spot

		
		self.emitter:SetPos(vOffset)  -- update emitter position
		local particle = self.emitter:Add("particle/smokesprites_000"..math.random(1,9), vOffset) -- add new particle to emitter
		particle:SetVelocity( vNormal * math.Rand( 5,15) )
	    particle:SetDieTime( 0.6 )
		particle:SetStartAlpha(math.Rand(50, 150))
	    particle:SetStartSize(math.Rand(5,10))
	    particle:SetEndSize( math.Rand(10, 20))
	    particle:SetRoll( math.Rand( -0.2, 0.2 ) )
	    particle:SetColor( 120, 200, 120 )
	end

end