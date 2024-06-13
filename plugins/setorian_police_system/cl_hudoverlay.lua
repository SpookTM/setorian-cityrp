
local function JPolice_ArrestInfo()
	
    draw.SimpleTextOutlined(Realistic_Police.Lang[77][Realistic_Police.Langage],"rpt_font_9", ScrW()/2, ScrH()/15, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,2, Realistic_Police.Colors["black"])
    draw.SimpleTextOutlined("[ "..math.Round(LocalPlayer():GetNWInt("rpt_arrest_time") - CurTime()).." ] - "..Realistic_Police.Lang[87][Realistic_Police.Langage],"rpt_font_9", ScrW()/2, ScrH()/11, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,2, Realistic_Police.Colors["black"])

end

local PLUGIN = PLUGIN

function JPolice_RenderHUDs()
        localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
        if (!IsValid(localplayer)) then return end

		if (!localplayer:GetCharacter()) then return end

		if math.Round(LocalPlayer():GetNWInt("rpt_arrest_time") - CurTime()) > 0 then 
	        JPolice_ArrestInfo()
	    end

end

hook.Add("HUDPaintBackground", "DrawPolice_ExtraHud", JPolice_RenderHUDs)