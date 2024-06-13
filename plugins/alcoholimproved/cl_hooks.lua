local PLUGIN = PLUGIN or {}

function PLUGIN:RenderScreenspaceEffects()
	if LocalPlayer():GetCharacter() != nil then
		local drunkEffect = LocalPlayer():GetCharacter():GetDrunkEffect()

		if (drunkEffect > 0) then
			DrawMotionBlur(0.075, drunkEffect, 0.025)
		end
	end
end



