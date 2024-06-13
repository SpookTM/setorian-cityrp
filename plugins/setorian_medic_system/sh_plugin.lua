local PLUGIN = PLUGIN
PLUGIN.name = "Medic System"
PLUGIN.desc = "Imersive injury and paramedic system"
PLUGIN.author = "JohnyReaper"

ix.util.Include("cl_setorian_medic_overlay.lua")
ix.util.Include("cl_func.lua")

ix.util.Include("sh_paramedic.lua")

ix.util.Include("sv_func.lua")

ix.config.Add("DyingTime", 120, "This is the time when the player is unconscious and still has a chance to receive medical attention" , nil, {
	data = {min = 30, max = 600},
})

ix.config.Add("StabilizzedTime", 120, "This is the time that replaces the current dying time. It should be such that the medic has enough time to transport the patient" , nil, {
	data = {min = 30, max = 600},
})

ix.config.Add("LifeAlertTime", 60, "How long should the life alert be shown in EMS's HUD?" , nil, {
	data = {min = 30, max = 600},
})

PLUGIN.EMSFaction = FACTION_EMS

/*
1 - Strong Pulse
2 - Good Pulse
3 - Weak Pulse
4 or dead - No Pulse
*/

PLUGIN.PulseName = {
	[1] = "strong",
	[2] = "good",
	[3] = "weak",
}

if SERVER then

	util.AddNetworkString("ixPlayerUnconscious")
	util.AddNetworkString("ixPlayerConscious")
	util.AddNetworkString("ixPlayerStable")
	util.AddNetworkString("ixPlayerHeal")

	util.AddNetworkString("ixMedicMenu_DoAction")

	util.AddNetworkString("ixMedic_UpdateLifeAlert")

	ix.log.AddType("BackToLife", function(client, target)
		return string.format("%s used a defibrillator on %s.",client:Name(), target:Name())
	end)

	ix.log.AddType("DoUnconscious", function(client)
		return string.format("%s is now unconscious.",client:Name())
	end)

	ix.log.AddType("PlyHealed", function(client, target, hp)
		return string.format("%s healed %d hp to %s.", client:Name(), hp, target:Name())
	end)

	ix.log.AddType("PlyHealedSelf", function(client, hp)
		return string.format("%s healed himself by %d hp.", client:Name(), hp)
	end)

	net.Receive( "ixMedicMenu_DoAction", function( len, ply )
		
		if (!IsValid(ply)) then return end
		if (!ply:Alive()) then return end
		if (!ply:GetCharacter()) then return end
		-- if (!ply:GetCharacter() == FACTION_EMS) then return end

		if (ply:GetCharacter():GetFaction() != PLUGIN.EMSFaction) then
			ply:Notify("You are not EMS")
			return false
		end

		local num_choosen = net.ReadUInt(3)

		if (!num_choosen) then return end

		if (num_choosen > #PLUGIN.medic_funcs) then return end

		if (PLUGIN.medic_funcs[num_choosen]) then
			PLUGIN.medic_funcs[num_choosen].Func(ply)
		else
			client:Notify("Action doesn't exist")
		end

	end )

	function PLUGIN:CharacterPreSave(char)
		local ply = char:GetPlayer()

		if (IsValid(ply)) then
			char:SetData("IsLegBroken", ply:GetNetVar("IsLegBroken", false))
			char:SetData("IsBleeding", ply:GetNetVar("IsBleeding", false))
		end
	end

	function PLUGIN:PlayerLoadedCharacter(ply, char, prevChar)

		if (prevChar) then
			if (timer.Exists( "BleedingThink_"..prevChar:GetID() )) then
				timer.Remove( "BleedingThink_"..prevChar:GetID() )
			end
		end

		timer.Simple(0.25, function()
			ply:SetNetVar("IsLegBroken", char:GetData("IsLegBroken", false))
			ply:SetNetVar("IsBleeding", char:GetData("IsBleeding", false))

			// Reset

			ply.NextUnCon = 0
			ply:SetNetVar("ply_pulse", 1)

			ply.DefTry = 0

			ply.ixIsDying = false
			ply.IsStabilized = false

			ply.ShootInLeg = false

			ply.PerformingCPR = false
	 		ply.PerformsCPR = false

			local uniqueID = "ixConscious" .. ply:SteamID()

			if (timer.Exists( uniqueID .. "_pulse_stage1" )) then
				timer.Remove( uniqueID .. "_pulse_stage1" )
			end

			if (timer.Exists( uniqueID .. "_pulse_stage2" )) then
				timer.Remove( uniqueID .. "_pulse_stage2" )
			end

			self:RemoveShootInLeg(ply)

			// Restore 

			if (ply:GetNetVar("IsBleeding")) then

				timer.Create( "BleedingThink_"..char:GetID(), 3, 0, function() BleedingFunc(ply) end )

				if (ply:Health() <= 10) then
					self:MakeUnconscious(ply)
				end
			end

		end)
	end



	local function PlaceBloodDecal(ply)

		local plyPos = ply:GetPos()
		local PosLen = plyPos:GetNormalized()

		local Pos1 = plyPos + PosLen
		local Pos2 = plyPos - PosLen

		util.Decal( "Blood", Pos1, Pos2 )

	end

	local painSounds = {
		Sound("vo/npc/male01/pain01.wav"),
		Sound("vo/npc/male01/pain02.wav"),
		Sound("vo/npc/male01/pain03.wav"),
		Sound("vo/npc/male01/pain04.wav"),
		Sound("vo/npc/male01/pain05.wav"),
		Sound("vo/npc/male01/pain06.wav")
	}

	function BleedingFunc(ply)

		if (!IsValid(ply)) then return end

		local CharRagdoll = ply.ixRagdoll

		if IsValid(CharRagdoll) then return end

		if (ply.ixIsDying) then return end

		local hp = ply:Health()
		local pos = ply:GetPos()

		-- ply:SetHealth( math.max(hp - math.random(1,5), 10) )
		if (ply:Health() > 10) then
			ply:SetHealth( math.max(hp - math.random(1,5), 1) )
		-- 	ply:TakeDamage( math.random(1,5), ply, ply )
		end

		if (math.random() > 0.35) then

			local painSound = hook.Run("GetPlayerPainSound", ply) or painSounds[math.random(1, #painSounds)]

			if (ply:IsFemale() and !painSound:find("female")) then
				painSound = painSound:gsub("male", "female")
			end

			ply:EmitSound(painSound, 75, 100, 0.5)

			PlaceBloodDecal(ply)
		end

		if (ply:Health() <= 10) then
			
			if ((ply.NextUnCon or 0) > 0) then
				ply.NextUnCon = math.max(ply.NextUnCon - 1,0)
			else
				PLUGIN:MakeUnconscious(ply)
				ply.NextUnCon = 4
			end
		end

	end

	function PLUGIN:Stabilize(client)

		if (!client:Alive()) then return end
		if (!client:GetCharacter()) then return end

		if (!IsValid(client.ixRagdoll)) then return end

		client.IsStabilized = true

		net.Start("ixPlayerStable")
		net.Send(client)

		local DyingTime = ix.config.Get("StabilizzedTime", 120)

		client:SetAction("Dying...", DyingTime, function()
			
			if (client.ixIsDying) then
				client:Kill()
			end

		end)

	end

	function PLUGIN:SendLifeAlert(ply, BRemove)

		local emsOnline = {}

		for client, character in ix.util.GetCharacters() do

			if (character:GetFaction() != PLUGIN.EMSFaction) then continue end
			if (client == ply) then continue end

			emsOnline[#emsOnline+1] = client

			if (!BRemove) then
				client:EmitSound("buttons/blip2.wav", 65, 100, 0.3)
				client:Notify("You receive life alert!")
			end

		end

		if (!table.IsEmpty(emsOnline)) then
			net.Start("ixMedic_UpdateLifeAlert")
			net.WriteEntity(ply)
			net.WriteBool(BRemove)
			net.Send(emsOnline)



			if (!BRemove) then

				local LifeAlertTime = ix.config.Get("LifeAlertTime", 60)

				local uniqueID = "ixLifeAlertRemove" .. ply:SteamID()

				local entity = ply.ixRagdoll

				timer.Create(uniqueID, LifeAlertTime, 1, function()
					if (IsValid(entity) and IsValid(ply) and (ply.ixIsDying) and ply.ixRagdoll == entity) then
						self:SendLifeAlert(ply, true)
					else
						timer.Remove(uniqueID)
						self:SendLifeAlert(ply, true)
					end
				end)

			end

		end

	end


	function PLUGIN:RemoveLifeAlert(client, target)

		if (!client) then return end
		if (!target) then return end

		net.Start("ixMedic_UpdateLifeAlert")
		net.WriteEntity(target)
		net.WriteBool(true)
		net.Send(client)

		client:Notify("Life Alert removed")

	end

	function PLUGIN:MakeUnconscious(client)

		if (!client:Alive()) then return end
		if (!client:GetCharacter()) then return end


		client:SetRagdolled(true)

		client.ixRagdoll.ixGrace = nil

		client.ixIsDying = true

		client:ExitVehicle()

		client:SetHealth(15)

		ix.log.Add(client, "DoUnconscious")

		net.Start("ixPlayerUnconscious")
		net.Send(client)

		local item = client:GetCharacter():GetInventory():HasItem("lifealert")

		if (item) then
			self:SendLifeAlert(client, false)
		end

		local DyingTime = ix.config.Get("DyingTime", 120)

		client:SetAction("Dying...", DyingTime, function()
			
			if (client.ixIsDying) then
				client:Kill()
			end

		end)

		local uniqueID = "ixConscious" .. client:SteamID()

		local entity = client.ixRagdoll

		timer.Create(uniqueID .. "_pulse_stage1", DyingTime*0.3, 1, function()
			if (IsValid(entity) and IsValid(client) and (client.ixIsDying) and client.ixRagdoll == entity) then
				client:SetNetVar("ply_pulse", 2)
			else
				timer.Remove(uniqueID .. "_pulse_stage1")
			end
		end)

		timer.Create(uniqueID .. "_pulse_stage2", DyingTime*0.6, 1, function()
			if (IsValid(entity) and IsValid(client) and (client.ixIsDying) and client.ixRagdoll == entity) then
				client:SetNetVar("ply_pulse", 3)
			else
				timer.Remove(uniqueID .. "_pulse_stage2")
			end
		end)

	end

	function PLUGIN:MakeConscious(client)

		if (!client:Alive()) then return end
		if (!client:GetCharacter()) then return end

		client:SetRagdolled(false)

		client.ixIsDying = false

		client.IsStabilized = false

		client.DefTry = 0

		client:SetAction()

		net.Start("ixPlayerConscious")
		net.Send(client)

		local uniqueID = "ixConscious" .. client:SteamID()

		if (timer.Exists( uniqueID .. "_pulse_stage1" )) then
			timer.Remove( uniqueID .. "_pulse_stage1" )
		end

		if (timer.Exists( uniqueID .. "_pulse_stage2" )) then
			timer.Remove( uniqueID .. "_pulse_stage2" )
		end

		uniqueID = "ixLifeAlertRemove" .. client:SteamID()

		if (timer.Exists( uniqueID )) then
			timer.Remove( uniqueID )
			self:SendLifeAlert(client, true)
		end


		client:SetNetVar("ply_pulse", 1)

	end

	function PLUGIN:ShootInLeg(client)

		if (!client:Alive()) then return end
		if (!client:GetCharacter()) then return end

		client.ShootInLeg = true

		local uniqueID = "ixShootInLeg" .. client:SteamID()

		local entity = client.ixRagdoll

		timer.Create(uniqueID, 25, 1, function()
			if (!IsValid(entity)) and IsValid(client) and (client.ShootInLeg) then
				client.ShootInLeg = false
			else
				timer.Remove(uniqueID)
			end
		end)

	end

	function PLUGIN:RemoveShootInLeg(client)

		if (!client:Alive()) then return end
		if (!client:GetCharacter()) then return end

		client.ShootInLeg = false

		local uniqueID = "ixShootInLeg" .. client:SteamID()

		if (timer.Exists( uniqueID )) then
			timer.Remove( uniqueID )
		end

	end

	function PLUGIN:EntityTakeDamage( ply, dmginfo )

		if (ply:GetClass() == "prop_ragdoll") then
			if (IsValid(ply.OnStretcher)) or (IsValid(ply.HealMachine)) then
				if (dmginfo:GetDamageType() == 1) then
					dmginfo:ScaleDamage(0)
				end
			end
		end

		if (!ply) then return end
		if (!IsValid(ply)) then return end
		if (!ply:IsPlayer()) then return end
		if (!ply:Alive()) then return end
		-- if (!IsValid(ply:GetCharacter())) then return end
		if (!ply:GetCharacter()) then return end

		local char = ply:GetCharacter()

		local hitgroup = ply:LastHitGroup()

		if (hitgroup == HITGROUP_LEFTARM) or (hitgroup == HITGROUP_RIGHTARM) then

			local painSound = "vo/npc/male01/myarm0"..math.random(1,2)..".wav"

			if (ply:IsFemale() and !painSound:find("female")) then
				painSound = painSound:gsub("male", "female")
			end

			ply:EmitSound(painSound, 75)

		elseif (hitgroup == HITGROUP_LEFTLEG) or (hitgroup == HITGROUP_RIGHTLEG) then

			local painSound = "vo/npc/male01/myleg0"..math.random(1,2)..".wav"

			if (ply:IsFemale() and !painSound:find("female")) then
				painSound = painSound:gsub("male", "female")
			end

			ply:EmitSound(painSound, 75)


			if (!ply.ShootInLeg) then
				self:ShootInLeg(ply)
			end


		end
		

		if (dmginfo:IsFallDamage() and (!ply:GetNetVar("IsLegBroken")) ) then
			ply:SetNetVar("IsLegBroken", true)
			ply:EmitSound("physics/body/body_medium_break4.wav", 65)
			ply.legEffect = CurTime()

			local painSound = "vo/npc/male01/myleg0"..math.random(1,2)..".wav"

			if (ply:IsFemale() and !painSound:find("female")) then
				painSound = painSound:gsub("male", "female")
			end

			ply:EmitSound(painSound, 75, 100, 0.5)

			ply:Notify("You broke your leg")

		elseif (!dmginfo:IsFallDamage() and (!ply:GetNetVar("IsBleeding")) ) then

			local dmgs = {
				[DMG_BULLET] = true,
				[DMG_SLASH] = true,
				[DMG_CLUB] = true,
			}

			if (dmgs[dmginfo:GetDamageType()]) or (dmginfo:IsBulletDamage()) then

				ply:SetNetVar("IsBleeding", true)
				ply:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", 65, 100, 0.5)
				
				ply:Notify("You start bleeding")

				timer.Create( "BleedingThink_"..char:GetID(), 3, 0, function() BleedingFunc(ply) end )

			end

		end

	end

	function PLUGIN:PlayerDeath( ply, inflictor, attacker )
		self:ResetPlayerConditions(ply)
	end

	function PLUGIN:GetPlayerDeathSound(client)
		if (client.ixIsDying) then
			return false
		end
	end

	function PLUGIN:PlayerSpawn(ply)

		-- self:ResetPlayerConditions(ply)

		-- ply:SetNetVar("ply_pulse", 1)
	end

	function PLUGIN:ResetPlayerConditions(ply)

		if (!ply:GetCharacter()) then return end

		local char = ply:GetCharacter()

		ply:ExitVehicle()

		ply:SetNetVar("IsLegBroken", false)
		ply:SetNetVar("IsBleeding", false)

		ply:SetNetVar("ply_pulse", 1)

		ply.NextUnCon = 0

		ply.DefTry = 0

		ply.ixIsDying = false
		ply.IsStabilized = false

		ply.ShootInLeg = false

		ply.IsHealYourself = false

		ply.PerformingCPR = false
 		ply.PerformsCPR = false

 		self:SendLifeAlert(ply, true)

		if (timer.Exists( "BleedingThink_"..char:GetID() )) then
			timer.Remove( "BleedingThink_"..char:GetID() )
		end

		local uniqueID = "ixConscious" .. ply:SteamID()

		if (timer.Exists( uniqueID .. "_pulse_stage1" )) then
			timer.Remove( uniqueID .. "_pulse_stage1" )
		end

		if (timer.Exists( uniqueID .. "_pulse_stage2" )) then
			timer.Remove( uniqueID .. "_pulse_stage2" )
		end

		uniqueID = "ixShootInLeg" .. ply:SteamID()

		if (timer.Exists( uniqueID )) then
			timer.Remove( uniqueID )
		end

		uniqueID = "ixLifeAlertRemove" .. ply:SteamID()

		if (timer.Exists( uniqueID )) then
			timer.Remove( uniqueID )
		end

	end

end

function PLUGIN:Move(ply, mv)

	if (ply:GetVelocity():Length() > 10) then
		if (ply.IsHealYourself) then
			ply:SetAction(false)
			ply.IsHealYourself = false
		end
	end

	if (ply:GetMoveType() == MOVETYPE_NOCLIP) then return false end

	if ((ply:GetNetVar("IsLegBroken")) or (ply.ShootInLeg)) and (ply:IsOnGround()) then

		local speed = ix.config.Get("walkSpeed")

		mv:SetMaxSpeed( speed * 0.75 )
		mv:SetMaxClientSpeed( speed * 0.75 )

		mv:SetButtons( bit.band( mv:GetButtons(), bit.bnot( IN_JUMP ) ) )

		if (ply:GetVelocity():Length() > 60) and (ply:GetNetVar("IsLegBroken")) then

			if ((ply.legEffect or 0) < CurTime()) then

				ply:ViewPunch( Angle( 2, 1, 1 ) )

				local delay = 0.7

				if (ply:KeyDown( IN_WALK )) then
					delay = 1
				end

				ply.legEffect = CurTime() + delay

			end

		end

	end

end