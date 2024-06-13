EmergencyAlertsTbl = {}
local function JEmergencyAlertHud_Waypoints()
	
    if (EmergencyAlertsTbl) and istable(EmergencyAlertsTbl) then
        for k, v in pairs(EmergencyAlertsTbl) do

        if (!v) then continue end

        local PlayerPos = LocalPlayer():GetPos()
        local EmergencyAlertPos = v

        local drawPos = (EmergencyAlertPos + Vector( 0,0,20 )):ToScreen()

        local dist = PlayerPos:Distance(EmergencyAlertPos)

        if (dist <= 100) then
        	EmergencyAlertsTbl[k] = false
        end

        local convertUnit = math.floor( dist * ( 1 / 16 ) * 10 ) / 10
        
        draw.SimpleText( "EMERGENCY CALL", "ixMediumFont", drawPos.x + 5, drawPos.y - 25, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText( convertUnit.."'", "ixMediumLightFont", drawPos.x + 5, drawPos.y - 5, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText( k:Name() or "Unknown", "ixMediumLightFont", drawPos.x + 5, drawPos.y + 15, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        end
    end

    
end

local PLUGIN = PLUGIN

function JEmergency_RenderHUDs()
        localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
        if (!IsValid(localplayer)) then return end

		if (!localplayer:GetCharacter()) then return end

		if (IsValid(ix.gui.emergencyui)) then
	        JEmergencyAlertHud_Waypoints()
	    end

end

hook.Add("HUDPaintBackground", "DrawEmergencyAlertsHUD", JEmergency_RenderHUDs)