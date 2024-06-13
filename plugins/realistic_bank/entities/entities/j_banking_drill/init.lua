AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")


function ENT:Initialize()

	self:SetModel("models/props_junk/watermelon01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)

	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self.Drill = ents.Create("prop_dynamic")
	self.Drill:SetModel("models/monmonstar/pd2_drill/drill_small.mdl")
	self.Drill:SetPos(self:GetPos())
	self.Drill:SetAngles(self:GetAngles() + Angle(0,90,0))
	self.Drill:SetParent(self)
	self.Drill:Spawn()
	self.Drill:Activate()
	self:DeleteOnRemove(self.Drill)

	self:SetJammed(false)
	self:SetProgress(120)

	self.NoJam = 2

	self.NextTick = CurTime()

	self:WorkSound()

end

function ENT:Think()

	if (!self:GetJammed()) then
		self:VisualEffect()
	end


	if (self:GetProgress() > 0) and (!self:GetJammed()) then

		if (self.NextTick < CurTime()) then

			self:SetProgress(math.max(0, self:GetProgress() - 1))

			if (self:GetProgress() == 0) then

				if (self.Safe) then
					self.Safe:DoorOpen()
				end

				self:Remove()
			end

			if (math.random() < 0.2) then

				if (self.NoJam > 0) then
					self.NoJam = self.NoJam - 1
				else

					self:SetJammed(true)
					self.NoJam = 3

					if self.sound then
						self.sound:Stop()
					end

					self:EmitSound("ambient/machines/spindown.wav",60)

				end

			end


			self.NextTick = CurTime() + 1
		end

	end

end


function ENT:VisualEffect()
	local effectData = EffectData();	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos() + (self:GetUp()*7) + (self:GetRight() * -10) + (self:GetForward() * 0.1) );
	effectData:SetScale(0.1);
	effectData:SetMagnitude(2)
	util.Effect("ElectricSpark", effectData, true, true);
end;

function ENT:Use(act, client)

	if (!client) then return end
	if (!client:Alive()) then return end
	if (!client:GetCharacter()) then return end

	if (!self:GetJammed()) then return end

	client:SetAction("Reparing...", 2) -- for displaying the progress bar
	client:DoStaredAction(self, function()

		self:SetJammed(false)

		if self.sound then
			self.sound:PlayEx(1, 100)
		end

		self:EmitSound("ambient/machines/spinup.wav",60)

	end, 2, function()
		client:SetAction()
	end)

end

function ENT:WorkSound()
    self.sound = CreateSound(self, Sound("ambient/machines/spin_loop.wav"))
    self.sound:SetSoundLevel(60)
	self.sound:PlayEx(1, 100)
end

function ENT:OnRemove()
    if self.sound then
        self.sound:Stop()
    end
end