local PLUGIN = PLUGIN
function PLUGIN:PerformCPR(client,target)

	if (!client:Alive()) then return end

	if (client:GetCharacter():GetFaction() != PLUGIN.EMSFaction) then
		client:Notify("You are not EMS")
		return false
	end

 	local char = client:GetCharacter()

 	client:Notify("You start performing CPR")
 	target:Notify("Someone performs CPR on you")

 	client.PerformingCPR = true
 	target.PerformsCPR = true

	timer.Create( "PerformingCPR"..char:GetID(), 1, 0, function() 
		
		if (IsValid(client) and (client:Alive()) and (target:Alive()) and (target.ixIsDying) and (IsValid(target.ixRagdoll)) and (target.ixRagdoll) ) then
			client:ViewPunch( Angle( 5, 0, 0 ) )
			client:EmitSound("physics/body/body_medium_impact_soft"..math.random(1,4)..".wav", 65)

			if (!client:KeyDown(IN_DUCK)) then
	        	client:Notify("You have to crouch down to do it")
	        	client:SetAction()
	        	timer.Remove("PerformingCPR"..char:GetID())
				client.PerformingCPR = false
	 			target.PerformsCPR = false
	 		end

		else
			timer.Remove("PerformingCPR"..char:GetID())
			client.PerformingCPR = false
 			target.PerformsCPR = false
		end

	end )


	client:SetAction("You are performing CPR...", 10)

    client:DoStaredAction(target.ixRagdoll, function()

    	target:SetNetVar("ply_pulse", 1)
		client.PerformingCPR = false
		target.PerformsCPR = false
		timer.Remove("PerformingCPR"..char:GetID())

		client:Notify("You have finished performing CPR")

    end, 10, function()
		client:SetAction()
		timer.Remove("PerformingCPR"..char:GetID())
		client.PerformingCPR = false
		target.PerformsCPR = false
	end)

end

function PLUGIN:KeyPress( ply, key )
	local pEye = ply:GetEyeTrace()
	local pEnt = pEye.Entity
	
	if (!IsValid( pEnt )) then return end
	if (!pEnt:IsVehicle()) then return end
	if (ply:GetPos():DistToSqr(pEnt:GetPos()) > 250*250) then return end
	if (ply:InVehicle()) then return end

	if (ply:GetCharacter():GetFaction() != PLUGIN.EMSFaction) then
		return false
	end
	
	if (key == IN_ATTACK2) and (ply:KeyDown(IN_SPEED)) then
		local FirstX, SecX = -43, 43
		local FirstY, SecY = -180, 20
		local FirstZ, SecZ = 30, 120



		local pos = pEnt:WorldToLocal(pEye.HitPos)
		if pEnt.VehicleName == "sim_fphys_ford_f350_amb" then
			if pos.x > FirstX and pos.x < SecX and pos.y > FirstY and pos.y < SecY and pos.z > FirstZ and pos.z < SecZ then
			
				local spawnPos = pEnt:GetPos() + pEnt:GetAngles():Right()*230 + pEnt:GetAngles():Up() * 60

				if (!pEnt.Stretcher) then
					ply:Notify("This vehicle has no stretcher")
					return false
				end

				if (self:CanSpawnStretcher(spawnPos, pEnt:GetAngles())) then
					
					pEnt:EmitSound("items/ammocrate_open.wav", 70)

					ply:SetAction("Pulling out a stretcher...", 1)

	        		ply:DoStaredAction(pEnt, function()

	        			if (self:CanSpawnStretcher(spawnPos, pEnt:GetAngles())) then
		        			self:SpawnStretcher(pEnt, spawnPos)
		        			pEnt:EmitSound("items/ammocrate_close.wav", 70)
		        		else
		        			ply:Notify("There is not enough space")
		        		end

	        		end, 1, function()
						ply:SetAction()
					end)

				else
					ply:Notify("There is not enough space")
				end

				
			end
		end
	end
end

function PLUGIN:CanSpawnStretcher(pos, ang)

	local tr = util.QuickTrace(pos, ang:Right()*60)

	if IsValid(tr.Entity) then
		return false
	end

	local foundEnts = ents.FindInSphere(pos, 20)

	for k, v in ipairs(foundEnts) do
		if (v:IsWeapon()) then continue end
		if (v:GetClass() == "physgun_beam") then continue end
		if (v:GetClass() == "info_player_start") then continue end
		if (IsValid(v)) then
			return false
		end
	end

	return true

end

function PLUGIN:FixCorpse(stretcher)

	if (IsValid( stretcher.PatientEnt)) then

		local ragdoll = stretcher.PatientEnt

		local NewPos = stretcher:GetPos()+stretcher:GetAngles():Up() * 12+stretcher:GetAngles():Right()*-3

		local NewAng = Angle(0,stretcher:GetAngles().Yaw,0)

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

		constraint.Weld( stretcher, ragdoll, 0, ragdoll:TranslateBoneToPhysBone(0), 0, false, false )
	end

end

function PLUGIN:SpawnStretcher(pEnt, pos)

	constraint.RemoveConstraints( pEnt.Stretcher, "Weld" )

	pEnt.Stretcher:SetPos(pEnt:GetPos() + pEnt:GetAngles():Right()*230 + pEnt:GetAngles():Up() * 60 )
	pEnt.Stretcher:SetAngles(pEnt:GetAngles())

	self:FixCorpse(pEnt.Stretcher)
	
	pEnt.Stretcher = nil

end

function PLUGIN:OnEntityCreated(ent)

	if (!IsValid(ent)) then return end

	if (!ent:IsVehicle()) then return end

	timer.Simple(0.5, function()
		if (!IsValid(ent)) then return end

		if ent.VehicleName == "sim_fphys_ford_f350_amb" then

		

			local stretcher = ents.Create("j_setorianmedic_stretcher")
			stretcher:SetPos(ent:GetPos() + ent:GetAngles():Forward() * 15 + ent:GetAngles():Right()*100 + ent:GetAngles():Up() * 70 )
			stretcher:SetAngles(ent:GetAngles())
			-- stretcher:SetParent(ent)
			stretcher:Spawn()

			constraint.Weld( ent, stretcher, 0, 0, 0, true, true )

			ent:DeleteOnRemove(stretcher)


			ent.Stretcher = stretcher

		end

	end)

end