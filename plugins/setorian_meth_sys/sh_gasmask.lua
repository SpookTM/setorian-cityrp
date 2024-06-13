ALWAYS_RAISED["badair_gasmask_deploy"] = true
ALWAYS_RAISED["badair_gasmask_holster"] = true
ALWAYS_RAISED["badair_gasmask_changefilter"] = true
local PLAYER = FindMetaTable("Player")

function PLAYER:getGasMask()
	return self.ixGasMaskItem 
end

if (CLIENT) then
	local gasmaskTexture2 = Material("morganicism/metroredux/gasmask/metromask1")
	local gasmaskTexture = Material("shtr_01")
	local w, h, gw, gh, margin, move, healthFactor, ft
	local nextBreath = CurTime()
	local exhale = false

	-- Local function for condition.
	local function canEffect(client)
		return (
			client:GetCharacter() and
			client:getGasMask() and
			!client:ShouldDrawLocalPlayer() and
			(!ix.gui.char or !ix.gui.char:IsVisible())
		)
	end

	shtrPos = {}

	-- Draw the Gas Mask Overlay. But other essiential stuffs must be visible.
	function PLUGIN:HUDPaintBackground()
		if (canEffect(LocalPlayer())) then
			w, h = ScrW(), ScrH()
			-- gw, gh = h/3*4, h

			-- surface.SetMaterial(gasmaskTexture)
			-- for k, v in ipairs(shtrPos) do
			-- 	surface.SetDrawColor(255, 255, 255)
			-- 	surface.DrawTexturedRectRotated(v[1], v[2], 512*v[3], 512*v[3], v[4])
			-- end

			-- render.UpdateScreenEffectTexture()
			-- surface.SetMaterial(gasmaskTexture2)
			-- surface.SetDrawColor(255, 255, 255)
			-- surface.DrawTexturedRect(0,0,w,h)
			-- surface.DrawTexturedRect(w/2 - gw/2, h/2 - gh/2, gw, gh)
			DrawMaterialOverlay("morganicism/metroredux/gasmask/metromask1.vmt", -0.06)

			-- surface.SetDrawColor(0, 0, 0)
			-- surface.DrawRect(0, 0, w/2 - gw/2, h)
			-- surface.DrawRect(0, 0, w, h/2 - gh/2)
			-- surface.DrawRect(0, h/2 + gh/2, w, h/2 - gh/2)
			-- surface.DrawRect(w/2 + gw/2, 0, w/2 - gw/2, h)
		end
	end

	function PLUGIN:Think()
		local client = LocalPlayer()
		local item = client:getGasMask()

		if (client.GASMASK_FaceModel and IsValid(client.GASMASK_FaceModel)) then
			client.GASMASK_FaceModel:DrawModel()
		end

		if (client:GetCharacter() and client:Alive() and item) then
			healthFactor = math.Clamp(client:Health()/client:GetMaxHealth(), 0, 1)

			if (!client.nextBreath or client.nextBreath < CurTime()) then
				-- client:EmitSound(!exhale and "gmsk_in.wav" or "gmsk_out.wav", 
				-- (LocalPlayer() == client and client:ShouldDrawLocalPlayer()) and 20 or 50, math.random(90, 100) + 15*(1 - healthFactor))
				
				-- local f = healthFactor*.5

				-- client:EmitSound("gmod4phun/gasmask/breathe_mask_loop.wav", (LocalPlayer() == client and client:ShouldDrawLocalPlayer()) and 20 or 50, math.random(90, 100))

				-- client.nextBreath = CurTime() + 12
				-- exhale = !exhale
			end
		end
	end


	netstream.Hook("ixMaskOn", function(id, health)
		local client = LocalPlayer()
		local item = ix.item.instances[id]

		if (item) then

			client:EmitSound("gmod4phun/gasmask/breathe_mask_loop.wav", (LocalPlayer() == client and client:ShouldDrawLocalPlayer()) and 20 or 50, math.random(90, 100))

			client.ixGasMaskItem = item
		end
	end)

	netstream.Hook("ixMaskOff", function()
		local client = LocalPlayer()

		client:StopSound( "gmod4phun/gasmask/breathe_mask_loop.wav" )

		client.ixGasMaskItem = nil
	end)

	-- netstream.Hook("mskAdd", function()
	-- 	LocalPlayer():EmitSound("player/bhit_helmet-1.wav")

	-- 	addCrack()
	-- end)
end