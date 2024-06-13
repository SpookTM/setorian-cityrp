local PLUGIN = PLUGIN or {}

function PLUGIN:RenderScreenspaceEffects()

	if (LocalPlayer():GetLocalVar("CocaineDrugged", false) and LocalPlayer():GetCharacter()) then
	
		DrawMotionBlur( 0.4, 0.8, 0.02 )
		DrawSharpen( 2, (math.cos(RealTime() * 2) * 2) )
		DrawSobel( 1 )
		DrawMaterialOverlay( "effects/water_warp01", 0.02 )

	end

end