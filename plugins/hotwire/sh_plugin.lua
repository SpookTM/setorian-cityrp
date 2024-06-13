
PLUGIN.name = "HotWire"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = "Adds the ability to use a hot wire to start up the engine."

if SERVER then

	// (entity:IsVehicle() and entity.CPPIGetOwner and (entity:CPPIGetOwner() == self.Owner or entity.ExtraSharedAccess[self.Owner:GetCharacter():GetID()]))
	
	util.AddNetworkString("HotWire_OpenUI")
	util.AddNetworkString("HotWire_StartEngine")

	net.Receive("HotWire_StartEngine", function(len, ply)
		
		if (!ply:InVehicle()) then return end
		if (!IsValid(ply:GetVehicle())) then return end

		local veh = ply:GetVehicle()

		veh:Fire( "turnon", "", 0 )
		veh:StartEngine( false )
		veh:EnableEngine( false )

		ply:EmitSound("ambient/energy/zap"..math.random(1,9)..".wav")

	end)

	-- function PLUGIN:KeyPress(ply, key)
	-- 	if (ply:InVehicle()) then
	-- 		if (!ply:GetVehicle():IsEngineStarted()) and (key == IN_FORWARD) then
				
	-- 			ply:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")
	-- 			net.Start("HotWire_OpenUI")
	-- 			net.Send(ply)

	-- 		end
	-- 	end
	-- end

	function PLUGIN:PlayerEnteredVehicle(ply, veh, role)

		if ((veh.CPPIGetOwner and veh:CPPIGetOwner() == ply) or (veh.ExtraSharedAccess and veh.ExtraSharedAccess[ply:GetCharacter():GetID()])) then
			veh:Fire( "turnon", "", 0 )
		else
			veh:Fire( "turnoff", "", 0 )
		end
			-- veh:StartEngine( false )
			-- veh:EnableEngine( false )
		-- end

	end
else

	net.Receive("HotWire_OpenUI", function(len, ply)
		vgui.Create("ixHotWireUI")
	end)

end