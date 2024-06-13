AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/medicmod/radio/radio.mdl") // "models/medicmod/stretcher/stretcher.mdl"
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )

	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()
		
	end

	self.NextTick = CurTime()

	self.Healing = false
	self:SetWorkStatus(false)

	self:WorkingSound()

end

function ENT:PlaceRagdollOn(ragdoll)


	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
	
	ragdoll.HealMachine = self

	ragdoll:CallOnRemove("ixMedicSystem_MachineFixer", function(ragdoll)

		if (IsValid(ragdoll.HealMachine)) then

			ragdoll.HealMachine.Healing = false
			ragdoll.HealMachine:SetWorkStatus(false)

			ragdoll.HealMachine.HealPly = nil

			if ragdoll.HealMachine.pSound then
		        ragdoll.HealMachine.pSound:Stop()
		    end

		end

	end)

	
	self.Healing = true

	local NewPos = self:GetPos()+self:GetAngles():Up() * 40+self:GetAngles():Forward()*14

	local NewAng = Angle(0,self:GetAngles().Yaw,0)

	local OldPos = ragdoll:GetPos()
	local OldAng = ragdoll:GetAngles()
	local physcount = ragdoll:GetPhysicsObjectCount()



	for i = 0, physcount - 1 do

		local phys = ragdoll:GetPhysicsObjectNum( i ) 
		local relpos = phys:GetPos()-OldPos

		local relang = phys:GetAngles()-OldAng

		phys:SetPos(NewPos+relpos)
		phys:SetAngles(NewAng)



	end


	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(0), 0, false, false )


end

function ENT:Use(ply)

	if (!ply:IsPlayer()) then return end

	if (!self.Healing) then
		ply:Notify("Place the patient before turning on the machine")
		return
	end

	if (self:GetWorkStatus()) then
		ply:Notify("The machine is already working")
		return
	end

	self:EmitSound("ambient/machines/thumper_startup1.wav")

	self.pSound:PlayEx(1, 100)

	self:SetWorkStatus(true)

	if (self.HealPly) then
		self:StartHeal(self.HealPly)
	end

end

function ENT:StartHeal(client)

	if (!client:Alive()) then return end
	if (!client:GetCharacter()) then return end

	PLUGIN:ResetPlayerConditions(client)

	net.Start("ixPlayerHeal")
	net.Send(client)

	local entity = client.ixRagdoll

	entity.ixWakingUp = true
	entity:CallOnRemove("CharGetUp", function()
		client:SetAction()
		PLUGIN:MakeConscious(client)
		client:SetHealth(math.random(40,80))
	end)

	client:SetAction("@gettingUp", 60, function()
		if (!IsValid(entity)) then
			return
		end

		hook.Run("OnCharacterGetup", client, entity)
		PLUGIN:MakeConscious(client)
		client:SetHealth(math.random(40,80))
		client:Notify("You were treated at the hospital")
	end)

end

function ENT:StartTouch(ent)

	if(self.Healing) then return end

	if (ent:GetClass() == "prop_ragdoll") then

		if (ent.ixPlayer) then

			local bodyPly = ent.ixPlayer

			if (bodyPly.ixIsDying) then

				self:PlaceRagdollOn(ent)

				if (ent.ixHeldOwner) then
					if (ent.ixHeldOwner:GetActiveWeapon():GetClass() == "ix_hands") then
						ent.ixHeldOwner:GetActiveWeapon():DropObject()
					end
				end

				self.HealPly = bodyPly

			end
		end
	end

end

function ENT:WorkingSound()
    self.pSound = CreateSound(self, Sound("ambient/machines/thumper_amb.wav"))
    self.pSound:SetSoundLevel(70)
	-- self.pSound:PlayEx(1, 100)
end 

function ENT:OnRemove()
    if self.pSound then
        self.pSound:Stop()
    end
end