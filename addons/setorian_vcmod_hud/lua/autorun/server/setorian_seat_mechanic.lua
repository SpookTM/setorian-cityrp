
hook.Add( "KeyPress", "seatBelt_Toggle", function( ply, key )
	if (!ply:InVehicle()) then return end
	if ((ply.SeatBeltDelay or 0) < CurTime()) then
		if ( key == IN_WALK ) and (ply:KeyDown(IN_SPEED)) then
			ply:PrintMessage( HUD_PRINTCENTER, "Seatbeat toggled" )
			ply:EmitSound("setorian_custom_carhud/seatbelt_puton.wav", 55)
			ply:SetNWBool( "SeatBeltOn", !ply:GetNWBool( "SeatBeltOn", false ) )


			if (ply:GetVehicle().SeatAlarm) then
				if ply:GetVehicle().pSound then
			        ply:GetVehicle().pSound:Stop()
			    end
			    ply:GetVehicle().SeatAlarm = false
			    ply:GetVehicle().AlarmCheck = CurTime() + 1
			end
		end
		ply.SeatBeltDelay = CurTime() + 0.5
	end
end )

hook.Add( "CanExitVehicle", "seatBelt_Checker_Exit", function( veh, ply )
    
	if (ply:GetNWBool( "SeatBeltOn", false )) then
		if ((ply.ExitVehDelayWarn or 0) < CurTime()) then
			ply:PrintMessage( HUD_PRINTTALK, "You cannot exit the vehicle because you are wearing a seat belt." )
			ply.ExitVehDelayWarn = CurTime() + 0.5
		end
		return false
	end

end )


hook.Add("VC_canSwitchSeat", "seatBelt_Checker_Seat", function(ply, ent_from, ent_to)
	if (ply:GetNWBool( "SeatBeltOn", false )) then
		if ((ply.ExitVehDelayWarn or 0) < CurTime()) then
			ply:PrintMessage( HUD_PRINTTALK, "You cannot change the seat because you are wearing a seat belt." )
			ply.ExitVehDelayWarn = CurTime() + 0.5
		end
		return false
	end
end)

hook.Add( "PlayerEnteredVehicle", "seatBelt_Reminder", function( ply, veh )
	if (!IsValid(ply)) then return end
	if ( !IsValid( veh ) or !veh:IsVehicle() ) then return end
	
	if ((ply.SeatReminder or 0) < CurTime()) then
		ply:PrintMessage( HUD_PRINTTALK, "Press SHIFT + ALT to fasten your seat belt." )
		ply.SeatReminder = CurTime() + 3
	end
	
end )

hook.Add( "EntityTakeDamage", "seatBelt_DMGMultipler", function( target, dmginfo )
    -- print(target)
    if (target:IsVehicle()) then
	-- if (target:GetClass() == "gmod_sent_vehicle_fphysics_base") then

		local vehicle = target
		-- if (target:IsPlayer()) then
		-- 	vehicle = target:GetSimfphys()
		-- end

		local Hudmph = GetConVar( "cl_simfphys_hudmph" ):GetBool()
		local Hudreal = GetConVar( "cl_simfphys_hudrealspeed" ):GetBool()

		local speed = vehicle:GetVelocity():Length()
		local mph = math.Round(speed * 0.0568182,0)
		local kmh = math.Round(speed * 0.09144,0)
		local wiremph = math.Round(speed * 0.0568182 * 0.75,0)
		local wirekmh = math.Round(speed * 0.09144 * 0.75,0)

		local printspeed = Hudmph and (Hudreal and mph or wiremph) or (Hudreal and kmh or wirekmh)

		local driver = vehicle:GetDriver()

		if (!driver) then return end

		local crashthreshort = (driver:GetNWBool( "SeatBeltOn", false ) and 350) or 150
		local crashdivine = (driver:GetNWBool( "SeatBeltOn", false ) and 7) or 4
		// 150 ~= 20mph
		// 270 ~= 40 mph

		if (speed >= crashthreshort) then
			if (!driver:Alive()) then return end
			-- print("CRASH")
			driver:TakeDamage( math.Round(speed/crashdivine), vehicle, self )
		end

	end

end )

hook.Add( "PlayerDeath", "Seatbelt_Disabler", function( victim, inflictor, attacker )
    if (victim:GetNWBool( "SeatBeltOn", false )) then
    	victim:SetNWBool( "SeatBeltOn", false )
    end
end)

hook.Add( "PlayerLeaveVehicle", "Seatbelt_Disabler_Car", function( ply, veh )
	if (ply:GetVehicle()) then
	    if (ply:GetNWBool( "SeatBeltOn", false )) then
	    	ply:SetNWBool( "SeatBeltOn", false )
	    end
	    ply.SeatBeltDelay = CurTime()
	    if (ply:GetVehicle().SeatAlarm) then
			if ply:GetVehicle().pSound then
		        ply:GetVehicle().pSound:Stop()
		    end
		   	ply:GetVehicle().SeatAlarm = false
		    ply:GetVehicle().AlarmCheck = CurTime() + 1
		end
	end
end)

hook.Add( "VehicleMove", "Seatbelt_Alarm_Checker", function( ply, vehicle, mv )

	if (vehicle:GetDriver() == NULL) then return end

	if (vehicle:GetClass() == "prop_vehicle_prisoner_pod") then return end

	if ((vehicle.AlarmCheck or 0) < CurTime()) then

		local speed = vehicle:GetVelocity():Length()
		local driver = vehicle:GetDriver()

		if (speed > 150) then
			if (!driver:GetNWBool( "SeatBeltOn", false )) then

				vehicle.SeatAlarm = true
				-- ply:EmitSound("setorian_custom_carhud/seatbelt_alarm.wav", 55)

				if vehicle.pSound then
			        vehicle.pSound:Stop()
			    end

				vehicle.pSound = CreateSound(vehicle, Sound("setorian_custom_carhud/seatbelt_alarm.wav"))
			    vehicle.pSound:SetSoundLevel(75)
				vehicle.pSound:PlayEx(1, 100)

				vehicle.AlarmCheck = CurTime() + 7.6
				return
			end
		end


		vehicle.AlarmCheck = CurTime() + 1
	end



end)
