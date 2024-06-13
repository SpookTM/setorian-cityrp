include("shared.lua")
	
function ENT:Initialize()
	self.Created = CurTime()
	self.emitter = ParticleEmitter(self.Entity:GetPos())

	self.emitter2 = ParticleEmitter(self.Entity:GetPos())

end

function ENT:OnRemove()
	
	if !(self.emitter == nil) then
		self.emitter:Finish()
	end

	if !(self.emitter2 == nil) then
		self.emitter2:Finish()
	end
	
end

function ENT:Draw()

	self:DrawModel()

end

function ENT:Think()

	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 700*700 then
	self.SmokeTimer = self.SmokeTimer or 0

	if (!self:GetIsWorking()) then return end

	if self.SmokeTimer > CurTime() then return end

	if (!self.emitter) then
		self.emitter = ParticleEmitter(self.Entity:GetPos())
	end

	if (!self.emitter2) then
		self.emitter2 = ParticleEmitter(self.Entity:GetPos())
	end

	self.SmokeTimer = CurTime() + math.Rand(0.0125,0.0150)  --0.0150

	local vOffset = self:GetPos() + Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(-3, 3)) + (self:GetUp()*34) + (self:GetRight()) + (self:GetForward()*-1)
	local vNormal = (vOffset - self:GetPos()):GetNormalized() + (self:GetUp()) + (self:GetRight()*5) + (self:GetForward())

	local particlee = self.emitter:Add("particles/fire1", vOffset)
	particlee:SetVelocity( vNormal * math.Rand( 3,6) )
    particlee:SetDieTime(0.5)
    particlee:SetStartAlpha(math.Rand(50, 150))
    particlee:SetStartSize(math.Rand(5,15))
    particlee:SetEndSize( math.Rand(2, 5))
    particlee:SetRoll( math.Rand( -0.2, 0.2 ) )
    particlee:SetColor(255, math.random(128,255), 0)

    vOffset = self:GetPos() + Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(-3, 3)) + (self:GetUp()*54) + (self:GetRight()*-4) + (self:GetForward()*-0.3)
	vNormal = (vOffset - self:GetPos()):GetNormalized() + (self:GetUp()*3) + (self:GetRight()) + (self:GetForward())

	local particleSmoker = self.emitter2:Add("particles/smokey", vOffset)
	particleSmoker:SetVelocity( vNormal * math.Rand( 3,6) )
    particleSmoker:SetDieTime(2)
    particleSmoker:SetStartAlpha(math.Rand(50, 150))
    particleSmoker:SetStartSize(math.Rand(3,5))
    particleSmoker:SetEndSize( math.Rand(2, 5))
    particleSmoker:SetRoll( math.Rand( -0.2, 0.2 ) )
    particleSmoker:SetColor(200,200,200)
	
	end
	
end