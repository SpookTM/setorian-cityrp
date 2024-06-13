local PLUGIN = PLUGIN
PLUGIN.name = "Chop Shop"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = "Dismantle cars and sell auto parts"
///////////////
// CONFIG

PLUGIN.SpecialConfig = {
	["merc_sprinter_lwb_lw"] = {
		LARSidesOffset = 3, // LAR - Left And Right
		FABSidesOffset = 2  // FAB - Front And Back
	}
}

PLUGIN.BlackList = {
	["merc_sprinter_lwb_lw"] = true,
}

//
/////////////////

PLUGIN.DismantledCars = {}

if (SERVER) then

	function PLUGIN:PlayerSpawnedVehicle(ply, ent)

		if (ent.MCD_Owner) then

			local ownerID =  ent.MCD_Owner

			if (self.DismantledCars[ownerID]) then
				if (self.DismantledCars[ownerID][ent:GetVehicleClass()]) then
					ply:Notify("Someone dismantled this vehicle some time ago. Try again later")
					ent:Remove()
				end
			end

		end

	end

	-- function PLUGIN:KeyPress(ply, key)
	-- hook.Add( "KeyPress", "PrepareCarFunc", function( ply, key )
	-- function PLUGIN:CanPlayerEnterVehicle( ply, veh, role )
	function PLUGIN:PrepareCar(ply, veh)
		-- print(key)
		
		if (ply:GetActiveWeapon()) and (IsValid(ply:GetActiveWeapon())) and (ply:GetActiveWeapon():GetClass() == "arccw_blowtorch") then
			local tr = ply:GetEyeTrace()
			-- print(tr.Entity)
			-- if (tr.Hit) and (tr.Entity) and IsValid(tr.Entity) and (tr.Entity:IsVehicle()) and (tr.Entity:GetPos():DistToSqr(ply:GetPos()) < 15000) then
			if (veh) and IsValid(veh) and (veh:GetPos():DistToSqr(ply:GetPos()) < 15000) then
				-- if (veh.ownerID == ply:GetCharacter():GetID()) then
				-- 	ply:Notify("You can't dismantle your own car")
				-- 	return false
				-- end

				ply:EmitSound("doors/door_metal_thin_close2.wav")

				ply:SetAction("Preparing...", 5)
				ply:DoStaredAction(veh, function()
					ply:EmitSound("doors/vent_open1.wav", 60)

					ply:Notify("The car is ready for dismantling")

					local chopCar = ents.Create("j_chopshop_car")
					chopCar:SetPos(veh:GetPos() + veh:GetUp() * 2 )
					chopCar:SetAngles(veh:GetAngles())
					chopCar:Spawn()
					chopCar:SetupCar(ply, veh:GetModel())
					chopCar.CarClass = veh:GetVehicleClass()

					constraint.NoCollide(chopCar, veh)
					
					local ownerID =  veh:GetNetVar("owner")
					local vehClass = veh:GetVehicleClass()

					PLUGIN.DismantledCars = PLUGIN.DismantledCars or {}
					PLUGIN.DismantledCars[ownerID] = PLUGIN.DismantledCars[ownerID] or {}
				 	PLUGIN.DismantledCars[ownerID][vehClass] = true

				 	timer.Simple(7200, function()
				 		PLUGIN.DismantledCars[ownerID][vehClass] = nil
				 	end)
				 	
					veh:Remove()
				end, 5, function()
					ply:SetAction()
				end)
				return false
			end
			
		end
		
	end

end