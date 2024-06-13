PLUGIN.name = "HL2RP Custom TAB Menu"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = ""

if CLIENT then
	function PLUGIN:CanPlayerViewInventory()
		return false
	end

	function PLUGIN:PostDrawHelixModelView(panel, ent)
		if (ent.headmodel and IsValid(ent.headmodel)) then
			ent.headmodel:DrawModel()
		end

		if (!pac) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			pac.RenderOverride(ent, "opaque")
			pac.RenderOverride(ent, "translucent", true)
		end

		if (!panel.pac_setup) then
            pac_setup = true
            panel.pac_setup = true
            pac.SetupENT(ent)
        end

	end

	net.Receive( "ixSetorian_TabMenu_ApplyBgs", function( len )

		timer.Simple(0.1, function()
			if (IsValid(ix.gui.menu)) then

				if (IsValid(ix.gui.youtab)) then
					ix.gui.youtab:HandlePAC()-- (LocalPlayer():GetCharacter())
				end

			end
		end)

	end)

	hook.Add("CreateMenuButtons", "ixCharInfo", function(tabs)
		tabs["you"] = nil
	end)

end

if SERVER then

	util.AddNetworkString("ixSetorian_TabMenu_ApplyBgs")

	function PLUGIN:PlayerInteractItem(client, action, item)

		if (action == "Equip") or (action == "EquipUn") or (action == "drop") then

			net.Start("ixSetorian_TabMenu_ApplyBgs")
			net.Send(client)

		end
	end

end