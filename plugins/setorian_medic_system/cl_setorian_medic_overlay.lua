
local scrw = ScrW()
local scrh = ScrH()


local dmg_overlay = Material( "screendamage.png")

function Setorian_Damage_Overlay()

	if (!IsValid(LocalPlayer()) and (!LocalPlayer())) then return end

	if (!LocalPlayer():GetCharacter()) then return end

	local hp = LocalPlayer():Health()
	local maxHp = LocalPlayer():GetMaxHealth()

	if (hp == maxHp) then return end

	local hpLeft = maxHp - hp

	local effectOverlay = (hpLeft * 255) / maxHp

	surface.SetDrawColor( 255,255,255, effectOverlay )
	surface.SetMaterial(dmg_overlay)
	surface.DrawTexturedRect(0,0,scrw,scrh)
	
end


hook.Add("HUDPaintBackground", "Setorian_dmg_overlay", Setorian_Damage_Overlay)