local PLUGIN = PLUGIN
PLUGIN.medic_funcs = {
	[1] = {
		Title = "Perform CPR",
		Desc = "Strengthens the patient's pulse",
		Func = function(client)
			if (CLIENT) then return end
			local eyeTrace = client:GetEyeTrace()

			local entity = eyeTrace.Entity

			if (entity:GetClass() != "prop_ragdoll") then return end

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
	        	client:Notify("You're standing too far away to do that")
	        	return false
	        end

			if (entity:GetClass() == "prop_ragdoll") then

				if (entity.ixPlayer) then

					local bodyPly = entity.ixPlayer

					if (bodyPly.ixIsDying) then

						if (bodyPly.PerformsCPR) then
							client:Notify("Someone is already performing CPR on this person")
							return
						end

						if (bodyPly:GetNetVar("ply_pulse") == 3) then
							client:Notify("The person's pulse is too weak to perform CPR")
							return
						end

						PLUGIN:PerformCPR(client, bodyPly)
					else
						client:Notify("This person is conscious and will get up soon")
					end

				end

			end

		end
	},
	[2] = {
		Title = "Stop bleeding",
		Desc = "You dress wounds and stop patient bleeding. \nRequires stitches",
		Func = function(client)
			if (CLIENT) then return end

			local eyeTrace = client:GetEyeTrace()

			local entity = eyeTrace.Entity

			if (entity:GetClass() != "prop_ragdoll") then return end

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
	        	client:Notify("You're standing too far away to do that")
	        	return false
	        end

			if (entity:GetClass() == "prop_ragdoll") then

				if (entity.ixPlayer) then

					local bodyPly = entity.ixPlayer

					if (bodyPly.ixIsDying) then

						if (!bodyPly:GetNetVar("IsBleeding")) then
				        	client:Notify("That person is not bleeding")
				        	return false
				        end

				        local inventory = client:GetCharacter():GetInventory()

				        local char = bodyPly:GetCharacter()

				        local item = inventory:HasItem("stitches")
						
						if (item) then

							client:SetAction("Healing...", 5)

							client:DoStaredAction(entity, function()
			
					        	bodyPly:SetNetVar("IsBleeding", false)
					        	PLUGIN:RemoveShootInLeg(bodyPly)

								client:Notify("You stopped the bleeding")


								if (timer.Exists( "BleedingThink_"..char:GetID() )) then
									timer.Remove( "BleedingThink_"..char:GetID() )
								end

								entity:EmitSound("physics/cardboard/cardboard_box_strain"..math.random(1,3)..".wav", 65)

								item:Remove()

							end, 5, function()
								client:SetAction()
							end)

						else
							client:Notify("You don't have any stitches in your inventory")
						end
					else
						client:Notify("This person is conscious and will get up soon")
					end
				end
			end

		end
	},
	[3] = {
		Title = "Put on a stretcher",
		Desc = "You put the patient on a stretcher. \nRequired for ambulance transport",
		Func = function(client)
			if (CLIENT) then return end

			local eyeTrace = client:GetEyeTrace()

			local entity = eyeTrace.Entity

			if (entity:GetClass() != "prop_ragdoll") then return end

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
	        	client:Notify("You're standing too far away to do that")
	        	return false
	        end

			if (entity:GetClass() == "prop_ragdoll") then

				if (entity.ixPlayer) then

					local bodyPly = entity.ixPlayer

					if (bodyPly.ixIsDying) then

						local foundEnts = ents.FindInSphere(entity:GetPos(), 36)

						local FreeStretcher = nil

						for k, v in ipairs(foundEnts) do

							if (v:GetClass() != "j_setorianmedic_stretcher") then continue end
							if (v.HasVictim) then continue end

							FreeStretcher = v

							break

						end

						if (IsValid(FreeStretcher)) then

							client:SetAction("Putting on a stretcher...", 3)

					        client:DoStaredAction(entity, function()
								
								-- bodyPly:GodEnable()

								FreeStretcher.HasVictim = true

								FreeStretcher:PlaceRagdollOn(entity)

								FreeStretcher:EmitSound("physics/body/body_medium_impact_soft"..math.random(1,4)..".wav")

								client:Notify("You put the patient on a stretcher")

							end, 3, function()
								client:SetAction()
							end)

						else
							client:Notify("No stretcher found or stretcher already has a patient")
						end
					else
						client:Notify("This person is conscious and will get up soon")
					end
				end
			end

		end
	},
	[4] = {
		Title = "Stabilize",
		Desc = "You get extra time before the patient dies. \nRequires bandages",
		Func = function(client)
			if (CLIENT) then return end

			local eyeTrace = client:GetEyeTrace()

			local entity = eyeTrace.Entity

			if (entity:GetClass() != "prop_ragdoll") then return end

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
	        	client:Notify("You're standing too far away to do that")
	        	return false
	        end

			if (entity:GetClass() == "prop_ragdoll") then

				if (entity.ixPlayer) then

					local bodyPly = entity.ixPlayer

					if (bodyPly.ixIsDying) then

						if (bodyPly.IsStabilized) then
							client:Notify("This person's condition is stabilized already")
				        	return false
				        end

				        local inventory = client:GetCharacter():GetInventory()

				        local char = bodyPly:GetCharacter()

				        local item = inventory:HasItem("bandage")
						
						if (item) then

							client:SetAction("You're stabilizing the victim...", 5)

							client:DoStaredAction(entity, function()

								client:Notify("You have successfully stabilized the patient's condition. ")
								bodyPly:Notify("Your condition has been stabilized.")

								PLUGIN:Stabilize(bodyPly)

								entity:EmitSound("physics/cardboard/cardboard_box_strain"..math.random(1,3)..".wav", 65)

								item:Remove()

							end, 5, function()
								client:SetAction()
							end)

						else
							client:Notify("You don't have any bandages in your inventory")
						end
					else
						client:Notify("This person is conscious and will get up soon")
					end
				end
			end

		end
	},
	[5] = {
		Title = "Remove life Alert",
		Desc = "Removes the life alert from your HUD",
		Func = function(client)
			if (CLIENT) then return end

			local eyeTrace = client:GetEyeTrace()

			local entity = eyeTrace.Entity

			if (entity:GetClass() != "prop_ragdoll") then return end

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
	        	client:Notify("You're standing too far away to do that")
	        	return false
	        end

			if (entity:GetClass() == "prop_ragdoll") then

				if (entity.ixPlayer) then

					local bodyPly = entity.ixPlayer

					if (bodyPly.ixIsDying) then

						PLUGIN:RemoveLifeAlert(client, bodyPly)

					end
				end
			end

		end
	},
}
