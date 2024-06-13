net.Receive("ixPlayerUnconscious", function()
	if (IsValid(ix.gui.unconsScreen)) then
		ix.gui.unconsScreen:Remove()
	end

	ix.gui.unconsScreen = vgui.Create("ixUnconsciousScreen")
end)

net.Receive("ixPlayerConscious", function()
	if (IsValid(ix.gui.unconsScreen)) then
		ix.gui.unconsScreen:Close()
	end
end)

net.Receive("ixPlayerStable", function()
	if (IsValid(ix.gui.unconsScreen)) then
		ix.gui.unconsScreen:Close()
	end

	ix.gui.unconsScreen = vgui.Create("ixStabilizedScreen")
end)

net.Receive("ixPlayerHeal", function()
	if (IsValid(ix.gui.unconsScreen)) then
		ix.gui.unconsScreen:Close()
	end

	ix.gui.unconsScreen = vgui.Create("ixMedicHealScreen")
end)

LifeAlertsTbl = {}

net.Receive("ixMedic_UpdateLifeAlert", function()

	local ent = net.ReadEntity()
	local BRemove = net.ReadBool()

	if (!ent:IsPlayer()) then return end

	LifeAlertsTbl[ent] = !BRemove

end)

netstream.Hook("SetorianExtras_OpenMedicUI", function()

	vgui.Create("ixSetorianMedic_Menu")

end)

local function JMedicHUD_Ambulance()
   	
   	localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
    if not IsValid(localplayer) then return end

    local pEye = LocalPlayer():GetEyeTrace()
    local pEnt = pEye.Entity
    
	if (!IsValid( pEnt )) then return end
	if (!pEnt:IsVehicle()) then return end
    if (LocalPlayer():GetPos():DistToSqr(pEnt:GetPos()) > 250*250) then return end
    if (LocalPlayer():InVehicle()) then return end

    // Vector( -40.13, -171.63, 45.65 )
    // Vector( 40.65, -171.63, 115.09 )

    local FirstX, SecX = -43, 43
	local FirstY, SecY = -180, 20
	local FirstZ, SecZ = 30, 120

    local pos = pEnt:WorldToLocal(pEye.HitPos)
    if pEnt:GetModel() == "models/lonewolfie/ford_f350_ambu.mdl" then
        if pos.x > FirstX and pos.x < SecX and pos.y > FirstY and pos.y < SecY and pos.z > FirstZ and pos.z < SecZ then
			draw.SimpleTextOutlined( "Press SHIFT+RMB to pull out the stretcher", "ixMenuButtonFontThick", ScrW() / 2, ScrH()-250, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100) )
		end
      
    end

end


local heart_icon = Material("setorian_medic/heart-attack.png", "noclamp smooth")

local function JMedicHud_Waypoints()
	
    if (LifeAlertsTbl) and istable(LifeAlertsTbl) then
        for k, v in pairs(LifeAlertsTbl) do

        if (!v) then continue end

        local PlayerPos = LocalPlayer():GetPos()
        local LifeAlertPos = k:GetPos()

        local drawPos = (LifeAlertPos + Vector( 0,0,20 )):ToScreen()

        local dist = PlayerPos:Distance(LifeAlertPos)
        local convertUnit = math.floor( dist * ( 1 / 16 ) * 10 ) / 10

        local anim = math.abs(math.cos(RealTime() * 3) * 120)
        
        surface.SetDrawColor(255,anim,anim)
        surface.SetMaterial( heart_icon )
        surface.DrawTexturedRect(drawPos.x - 12, drawPos.y - 75, 32,32)
        draw.SimpleText( "LIFE ALERT", "ixMediumFont", drawPos.x + 5, drawPos.y - 25, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText( convertUnit.."'", "ixMediumLightFont", drawPos.x + 5, drawPos.y - 5, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        end
    end

    
end

local PLUGIN = PLUGIN

function JMedic_RendersHUDs()
        localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
        if (!IsValid(localplayer)) then return end

		if (!localplayer:GetCharacter()) then return end

		if (localplayer:GetCharacter():GetFaction() == PLUGIN.EMSFaction) then	
			JMedicHUD_Ambulance()
	        JMedicHud_Waypoints()
		end
end

hook.Add("HUDPaintBackground", "DrawMedicSysHUDs", JMedic_RendersHUDs)