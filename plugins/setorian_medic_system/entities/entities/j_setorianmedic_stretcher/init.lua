AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos + Vector(0, 0, 40) )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:Initialize()

	self:SetModel("models/medicmod/stretcher.mdl") // "models/medicmod/stretcher/stretcher.mdl"
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )

	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:SetMass(200)
		phys:Wake()
		

	end

	self.NextReset = CurTime()

	-- local prop_bottom = ents.Create("prop_dynamic")
	-- prop_bottom:SetModel("models/medicmod/stretcher.mdl")
	-- prop_bottom:SetPos(self:GetPos())
	-- prop_bottom:SetAngles(self:GetAngles())
	-- prop_bottom:SetParent(self)
	-- prop_bottom:Spawn()

	-- local prop_bottom = ents.Create("prop_physics")
	-- prop_bottom:SetModel("models/hunter/plates/plate075x2.mdl")
	-- prop_bottom:SetPos(self:GetPos()+self:GetAngles():Up() * 3+self:GetAngles():Forward()*7)
	-- prop_bottom:SetAngles(self:GetAngles())
	-- -- prop_bottom:SetParent(self)
	-- self:DeleteOnRemove(prop_bottom)
	-- prop_bottom:Spawn()

	-- constraint.Weld( self, prop_bottom, 0, 0, 0, false, true )
	-- constraint.NoCollide( self, prop_bottom, 0, 0 )

	

end

local boneAngles = {
	[1] = {
		bone = "ValveBiped.Bip01_R_Foot",
		ang = Angle(0,0,0),
		pos = Vector( 12.75, 29.87, 13.28 ),
	},
	-- [2] = {
	-- 	bone = "ValveBiped.Bip01_L_Foot",
	-- 	ang = Angle(-0,0,0)
	-- },
	-- [3] = {
	-- 	bone = "ValveBiped.Bip01_R_ForeArm",
	-- 	ang = Angle(-20,0,0)
	-- },
	-- [4] = {
	-- 	bone = "ValveBiped.Bip01_L_ForeArm",
	-- 	ang = Angle(20,0,0)
	-- },
	-- [5] = {
	-- 	bone = "ValveBiped.Bip01_L_UpperArm",
	-- 	ang = Angle(20,-0,0)
	-- },
	-- [6] = {
	-- 	bone = "ValveBiped.Bip01_R_UpperArm",
	-- 	ang = Angle(-20,-0,0)
	-- },
	-- [7] = {
	-- 	bone = "ValveBiped.Bip01_Head1",
	-- 	ang = Angle(20,0,45)
	-- },
}

function ENT:TestRagdoll(client)

	local entity = self:PlaceRagdollOn(client)

	entity.ixGrace = CurTime()

	entity:CallOnRemove("fixer", function()
		if (IsValid(client)) then
			client:SetLocalVar("blur", nil)
			client:SetLocalVar("ragdoll", nil)

			if (!entity.ixNoReset) then
				client:SetPos(entity:GetPos())
			end

			client:SetNoDraw(false)
			client:SetNotSolid(false)
			client:SetMoveType(MOVETYPE_WALK)
			client:SetLocalVelocity(IsValid(entity) and entity.ixLastVelocity or vector_origin)
		end

		if (IsValid(client) and !entity.ixIgnoreDelete) then
			if (entity.ixWeapons) then
				for _, v in ipairs(entity.ixWeapons) do
					if (v.class) then
						local weapon = client:Give(v.class, true)

						if (v.item) then
							weapon.ixItem = v.item
						end

						client:SetAmmo(v.ammo, weapon:GetPrimaryAmmoType())
						weapon:SetClip1(v.clip)
					elseif (v.item and v.invID == v.item.invID) then
						v.item:Equip(client, true, true)
						client:SetAmmo(v.ammo, client.carryWeapons[v.item.weaponCategory]:GetPrimaryAmmoType())
					end
				end
			end

			if (entity.ixActiveWeapon) then
				if (client:HasWeapon(entity.ixActiveWeapon)) then
					client:SetActiveWeapon(client:GetWeapon(entity.ixActiveWeapon))
				else
					local weapons = client:GetWeapons()
					if (#weapons > 0) then
						client:SetActiveWeapon(weapons[1])
					end
				end
			end

			if (client:IsStuck()) then
				entity:DropToFloor()
				client:SetPos(entity:GetPos() + Vector(0, 0, 16))

				local positions = ix.util.FindEmptySpace(client, {entity, client})

				for _, v in ipairs(positions) do
					client:SetPos(v)

					if (!client:IsStuck()) then
						return
					end
				end
			end
		end
	end)

	client:SetLocalVar("blur", 25)
	client.ixRagdoll = entity

	entity.ixWeapons = {}
	entity.ixPlayer = client

	if (IsValid(client:GetActiveWeapon())) then
		entity.ixActiveWeapon = client:GetActiveWeapon():GetClass()
	end

	for _, v in ipairs(client:GetWeapons()) do
		if (v.ixItem and v.ixItem.Equip and v.ixItem.Unequip) then
			entity.ixWeapons[#entity.ixWeapons + 1] = {
				item = v.ixItem,
				invID = v.ixItem.invID,
				ammo = client:GetAmmoCount(v:GetPrimaryAmmoType())
			}
			v.ixItem:Unequip(client, false)
		else
			local clip = v:Clip1()
			local reserve = client:GetAmmoCount(v:GetPrimaryAmmoType())
			entity.ixWeapons[#entity.ixWeapons + 1] = {
				class = v:GetClass(),
				item = v.ixItem,
				clip = clip,
				ammo = reserve
			}
		end
	end

end

function ENT:PlaceRagdollOn(ragdoll)

	-- local ragdoll = ents.Create("prop_ragdoll")

	-- local ragdoll = client:CreateServerRagdoll()

	-- ragdoll:SetModel("models/Humans/Group01/male_02.mdl")
	-- ragdoll:SetPos(self:GetPos()+self:GetAngles():Up() * 12+self:GetAngles():Right()*35)
	-- ragdoll:SetAngles(Angle(-90,self:GetAngles().Yaw,-90))
	-- ragdoll:Activate()
	-- ragdoll:SetParent(self)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
	
	ragdoll.OnStretcher = self

	ragdoll:CallOnRemove("ixMedicSystem_Fixer", function(ragdoll)

		if (IsValid(ragdoll.OnStretcher)) then

			ragdoll.OnStretcher.HasVictim = false

			ragdoll.OnStretcher.PatientEnt = nil

		end

	end)

	-- self:DeleteOnRemove(ragdoll)

	-- local	phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(0) )
	-- -- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 15+self:GetAngles():Right()*5, true)
	-- -- phys:SetAngles(self:GetAngles())

	-- phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(4) )
	-- -- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 15+self:GetAngles():Forward()*-10, true)
	-- -- phys:SetAngles(Angle(0,self:GetAngles().Yaw,0))

	-- -- phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(16) )
	-- -- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 15+self:GetAngles():Forward()*10, true)
	-- -- -- phys:SetAngles(self:GetAngles())

	-- local phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(11) )
	-- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 10+self:GetAngles():Right()*5+self:GetAngles():Forward()*-10, true)
	

	-- local phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(16) )
	-- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 10+self:GetAngles():Right()*5+self:GetAngles():Forward()*10, true)

	-- -- phys:SetAngles(self:GetAngles())

	-- -- phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(20) )
	-- -- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 15+self:GetAngles():Right()*25+self:GetAngles():Forward()*10, true)
	-- -- phys:SetAngles(self:GetAngles())


	local NewPos = self:GetPos()+self:GetAngles():Up() * 12+self:GetAngles():Right()*-3

	-- local NewAng = self:GetAngles() + Angle(0,90,0)
	-- local NewAng = Angle(0,self:GetAngles().Yaw,0) + Angle(0,30,0)
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

		-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(i), 0, true, true )

		-- phys:Sleep()
		-- phys:EnableMotion(false)

	end

	-- for i = 0, ragdoll:GetBoneCount() do
	-- 	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(i), 0, true, true )
	-- end

	-- for i = 18, 25 do
	-- 	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(i), 0, false, true )
	-- end

	-- for i = 1,7 do
	-- 	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(i), 0, false, true )
	-- end

	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(0), 0, false, false )

	self.PatientEnt = ragdoll

	timer.Simple(1,function()

		if (IsValid(self)) then
			phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(true)
			end
		end

	end)

	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(6), 0, false, true )
	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(4), 0, false, true )
	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(11), 0, false, true )
	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(16), 0, false, true )
	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(24), 0, false, true )
	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(20), 0, false, true )

	-- constraint.NoCollide( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(0) )


	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(6), 0, true, true )

	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(11), 0, true, true )
	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(16), 0, true, true )

	-- return ragdoll

	-- phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(20) )
	-- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 5+self:GetAngles():Right()*30+self:GetAngles():Forward()*-5)

	-- phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(24) )
	-- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 5+self:GetAngles():Right()*30+self:GetAngles():Forward()*5)

	-- phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(6) )
	-- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 12+self:GetAngles():Right()*-5)

	-- for i = 1, ragdoll:GetPhysicsObjectCount() - 1 do
	-- 	local phys = ragdoll:GetPhysicsObjectNum( i )

	-- 	-- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 30, true)
	-- 	-- phys:SetAngles(Angle(0,self:GetAngles().Yaw,0))

	-- 	local tbone = ragdoll:TranslatePhysBoneToBone(i)

	-- 	for _, inf in pairs( boneAngles ) do
	-- 		local bonename = ragdoll:LookupBone(inf.bone)

	-- 		if (bonename == tbone) then
	-- 			-- phys:SetAngles(inf.ang)
	-- 			phys:SetPos( phys:LocalToWorld(inf.pos) ) 
	-- 			print(phys:LocalToWorld(inf.pos), inf.pos)
	-- 			print("dziala", inf.bone)
	-- 		end

	-- 	end

	-- 	-- phys:SetAngles(Angle(0,0,0))
		
	-- end

	-- local phys = ragdoll:GetPhysicsObjectNum( ragdoll:TranslateBoneToPhysBone(0) )
	-- phys:SetPos(self:GetPos()+self:GetAngles():Up() * 12+self:GetAngles():Right()*5)



	-- for _, inf in pairs( boneAngles ) do
	-- 	local bone = ragdoll:LookupBone(inf.bone)
	-- 	if bone then
	-- 		ragdoll:ManipulateBoneAngles(bone, inf.ang)
	-- 	end
	-- end

	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(0), 0, true, true )


	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(6), 0, true, true )

	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(24), 0, true, true )
	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(20), 0, true, true )

-- 	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(4), 0, true, true )
	-- timer.Simple(0.1, function()
	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(0), 0, true, true )
-- 	-- constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(4), 0, true, true )
-- 	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(11), 0, true, true )
-- 	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(16), 0, true, true )
-- 	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(24), 0, true, true )
-- 	constraint.Weld( self, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(20), 0, true, true )
-- end)

end

function ENT:TakeOff()

	if (!IsValid(self.PatientEnt)) then return end

	local ragdoll = self.PatientEnt

	constraint.RemoveAll( ragdoll )

	local NewPos = self:GetPos()+self:GetAngles():Up() * 22+self:GetAngles():Right()*-3

	-- local NewAng = self:GetAngles() + Angle(0,90,0)
	-- local NewAng = Angle(0,self:GetAngles().Yaw,0) + Angle(0,30,0)
	local NewAng = Angle(0,self:GetAngles().Yaw,0)

	local OldPos = ragdoll:GetPos()
	local OldAng = ragdoll:GetAngles()
	local physcount = ragdoll:GetPhysicsObjectCount()

	for i = 0, physcount - 1 do

		local phys = ragdoll:GetPhysicsObjectNum( i ) 
		local relpos = phys:GetPos()-OldPos

		local relang = phys:GetAngles()-OldAng

		phys:SetPos(NewPos+relpos)

		phys:SetVelocity(Vector(0,0,0))


	end

	

	ragdoll.OnStretcher = nil

	self.HasVictim = false

	self.PatientEnt = nil

	-- local bodyPly = ragdoll.ixPlayer

	-- timer.Simple(0.1,function()

	-- 	bodyPly:GodDisable()

	-- end)

end

function ENT:OnOptionSelected(client, option, data)

	-- if (!client:IsCombine()) then
	-- 	client:Notify("You are not the Combine!")

	-- 	return
	-- end

	if (option == "Take off the patient") then

		if (IsValid(self.PatientEnt)) then
			self:TakeOff()
			self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1,4)..".wav")
		else
			client:Notify("There's no patient on a stretcher")
		end

	elseif (option == "Reset positions") then

		if (self.NextReset < CurTime()) then

			self:SetPos( self:GetPos() + Vector(0, 0, 10) )
			self:SetAngles(Angle(0,self:GetAngles().yaw,0))

			local phys = self:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)
				
			end

			timer.Simple(1,function()

				if (IsValid(self)) then
					phys = self:GetPhysicsObject()
					if phys:IsValid() then
						phys:EnableMotion(true)
						phys:Wake()
					end
				end

			end)

			self.NextReset = CurTime() + 2

		else
			client:Notify("You must wait before doing it again")
		end

	elseif (option == "Put in the ambulance") then

		local foundEnts = ents.FindInSphere(self:GetPos(), 64)

		local FreeAmbulance = nil

		for k, v in ipairs(foundEnts) do

			if (!v:IsVehicle()) then continue end
			if v.VehicleName != "sim_fphys_ford_f350_amb" then continue end

			FreeAmbulance = v

			break

		end

		if (IsValid(FreeAmbulance)) then

			FreeAmbulance:EmitSound("items/ammocrate_open.wav", 70)

			client:SetAction("Putting on a stretcher...", 1)

	        client:DoStaredAction(self, function()


	        	self:SetPos(FreeAmbulance:GetPos() + FreeAmbulance:GetAngles():Forward() * 15 + FreeAmbulance:GetAngles():Right()*100 + FreeAmbulance:GetAngles():Up() * 70 )
				self:SetAngles(FreeAmbulance:GetAngles())
				-- self:SetParent(FreeAmbulance)

				if (IsValid(self.PatientEnt)) then
	        		-- constraint.NoCollide( FreeAmbulance, self.PatientEnt, 0, self.PatientEnt:TranslateBoneToPhysBone(0) )
	        		
	        		local ragdoll = self.PatientEnt

	        		local NewPos = self:GetPos()+self:GetAngles():Up() * 12+self:GetAngles():Right()*-3

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

						constraint.NoCollide( self.PatientEnt, FreeAmbulance, 0, ragdoll:TranslateBoneToPhysBone(i) )

					end

	        	end

				FreeAmbulance:DeleteOnRemove(self)

				constraint.Weld( self, FreeAmbulance, 0, 0, 0, true, true )

				FreeAmbulance.Stretcher = self

				FreeAmbulance:EmitSound("items/ammocrate_close.wav", 70)

				client:Notify("You put the stretcher in the ambulance")

			end, 1, function()
				client:SetAction()
			end)

		else
			client:Notify("There is no ambulance nearby or the ambulance already has a stretcher inside")
		end

	end

end

function ENT:Touch(ent)

	if (ent:IsPlayer()) then

		local phys = self:GetPhysicsObject()
	
		if phys:IsValid() then

			phys:ApplyForceCenter(ent:GetAimVector() * 2000)

		end

	end

end
-- 	if(self.HasVictim) then return end

-- 	if (ent:GetClass() == "prop_ragdoll") then

-- 		if (ent.ixPlayer) then

-- 			local bodyPly = ent.ixPlayer

-- 			if (ent.testvar) then return end

-- 			-- if (bodyPly.ixIsDying) then
-- 				-- bodyPly:SetRagdolled(false)

-- 				bodyPly:GodEnable()

-- 				self.HasVictim = true

-- 				self:PlaceRagdollOn(ent)
-- 				-- ent:Remove()

-- 			-- end
-- 		end
-- 	end

-- end