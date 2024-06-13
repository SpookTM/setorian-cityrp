
local PLUGIN = PLUGIN

function PLUGIN:HUDPaint()
	local client = LocalPlayer()
	local character = client:GetCharacter()

	if IsValid(client) and character and client:Alive() then
		if IsValid(client:GetActiveWeapon()) and (client:GetActiveWeapon():GetClass() == "ix_building") then

			ix.util.DrawText("Use LMB and RMB to rotate the object.", ScrW() / 2, 64, color_white, 1, 4, "ixMenuButtonHugeFont")
			ix.util.DrawText("Press RELOAD to place the object.", ScrW() / 2, 128, color_white, 1, 4, "ixMenuButtonHugeFont")
		end
	end
end