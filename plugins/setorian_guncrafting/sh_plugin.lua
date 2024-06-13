local PLUGIN = PLUGIN
PLUGIN.name = "Gun Crafting"
PLUGIN.description = "Adds gun crafting system"
PLUGIN.author = "JohnyReaper"

PLUGIN.Recipes = {
	[1] = {
		RName = "Primary",
		Weapons = {
			["M16A2"] = {
				req = {
					["bolt"] = 15,
					["lower_receiver"] = 4,
					["upper_recevier"] = 6,
					["slide"] = 4,
					["handle_grip"] = 7,
					["firing_pin"] = 5,
					["long_barrel"] = 2,
					["trigger"] = 2,
					["stock"] = 2,

				},
				level = 10,
				result = "arccw_ud_m16"
			},
			["Remington 870"] = {
				req = {
					["bolt"] = 15,
					["lower_receiver"] = 2,
					["upper_recevier"] = 5,
					["slide"] = 4,
					["handle_grip"] = 5,
					["firing_pin"] = 3,
					["long_barrel"] = 2,
					["trigger"] = 2,
					["stock"] = 2,

				},
				level = 15,
				result = "arccw_ud_870"
			},
			["HK G36C"] = {
				req = {
					["bolt"] = 12,
					["lower_receiver"] = 4,
					["upper_recevier"] = 4,
					["slide"] = 4,
					["handle_grip"] = 2,
					["firing_pin"] = 3,
					["short_barrel"] = 2,
					["trigger"] = 4,
					["stock"] = 1,
				},
				level = 8,
				result = "arccw_cod4e_g36c"
			},
			["AUG A3"] = {
				req = {
					["bolt"] = 20,
					["lower_receiver"] = 3,
					["upper_recevier"] = 5,
					["slide"] = 4,
					["handle_grip"] = 4,
					["firing_pin"] = 8,
					["long_barrel"] = 2,
					["trigger"] = 2,
					["stock"] = 3,
				},
				level = 15,
				result = "arccw_go_aug"


			}
		},																	
	}, 
	[2] = {
		RName = "Secondary",
		Weapons = {
			["Glock 17"] = {
				req = {
					["bolt"] = 10,
					["lower_receiver"] = 2,
					["upper_recevier"] = 2,
					["slide"] = 1,
					["handle_grip"] = 2,
					["firing_pin"] = 2,
					["short_barrel"] = 1,
					["trigger"] = 2,
				},
				level = 5,
				result = "arccw_ud_glock"
			},
			["Walther P99"] = {
				req = {
					["bolt"] = 13,
					["lower_receiver"] = 2,
					["upper_recevier"] = 4,
					["slide"] = 2,
					["handle_grip"] = 2,
					["firing_pin"] = 4,
					["short_barrel"] = 1,
					["trigger"] = 2,
				},
				level = 7,
				result = "arccw_mw3e_p99"
			},
			["Makarov"] = {
				req = {
					["bolt"] = 5,
					["lower_receiver"] = 1,
					["upper_recevier"] = 2,
					["slide"] = 1,
					["handle_grip"] = 2,
					["firing_pin"] = 1,
					["short_barrel"] = 1,
					["trigger"] = 2,
				},
				level = 0,
				result = "arccw_makarov"
			},
			["Colt Anaconda"] = {
				req = {
					["bolt"] = 12,
					["lower_receiver"] = 4,
					["upper_recevier"] = 3,
					["handle_grip"] = 5,
					["firing_pin"] = 2,
					["short_barrel"] = 1,
					["trigger"] = 4,
				},
				level = 10,
				result = "arccw_mw3e_anaconda"
			}
		},
	}
}

if (SERVER) then

	util.AddNetworkString("ixGunCrafting_CraftWep")
	util.AddNetworkString("ixGunCrafting_OpenUI")

	net.Receive( "ixGunCrafting_CraftWep", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local WepToCraft = net.ReadString()
		local recipeID = net.ReadUInt(8)

		if (!PLUGIN.Recipes[recipeID]) or (!PLUGIN.Recipes[recipeID].Weapons[WepToCraft]) then
			client:Notify("Recipe Table doesn't exists")
			return
		end

		local requirements = PLUGIN.Recipes[recipeID].Weapons[WepToCraft].req

		local level = PLUGIN.Recipes[recipeID].Weapons[WepToCraft].level or 0

		if (level and level != 0) then
			if (char:GetAttribute("guncraft", 0) < level) then
				client:Notify("You do not have enough skills to craft this item")
				return
			end
		end

		local inv = char:GetInventory()

		for k, v in pairs(requirements) do

			local item = inv:HasItem(k)

			if (!item) or (inv:GetItemCount(k) < v) then
				client:Notify("You don't have enough ingredients to craft this item")
				return
			end


		end

		for k, v in pairs(requirements) do
			
			for i=1, v do

				local item = inv:HasItem(k)

				if (item) then
					item:Remove()
				end

			end

		end

		local resultItem = PLUGIN.Recipes[recipeID].Weapons[WepToCraft].result

		if (!inv:Add(resultItem)) then
            ix.item.Spawn(resultItem, client)
        end

        client:Notify("You have successfully crafted this item")
		

	end)

	function PLUGIN:LoadData()
		self:LoadGunCraftTables()
	end

	function PLUGIN:SaveData()
		self:SaveGunCraftTables()
	end

	function PLUGIN:SaveGunCraftTables()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_guncrafttable")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_craftgun_tables", data)

	end

	function PLUGIN:LoadGunCraftTables()
		for _, v in ipairs(ix.data.Get("jr_craftgun_tables") or {}) do
			local npc = ents.Create("j_guncrafttable")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

end

if (CLIENT) then


	net.Receive( "ixGunCrafting_OpenUI", function( len, client )

		-- local bytes_amount = net.ReadUInt( 16 ) 
		-- local compressed_message = net.ReadData( bytes_amount )
		-- local pacsData = util.JSONToTable(util.Decompress( compressed_message ))

		local tableEnt = net.ReadEntity()

		local CraftUI = vgui.Create("ixSetorianGunCraftUI")
		-- CraftUI:WeaponModel(tableEnt)
		CraftUI.TableEnt = tableEnt
		-- StoreUI.PlyPacsData = pacsData
		-- StoreUI:FakePlyModel()
		CraftUI:RenderCategories()

	end)

	function PLUGIN:CalcView(client, origin, angles, fov)
		-- local view = self.BaseClass:CalcView(client, origin, angles, fov) or {}

		local guncraftMenu = ix.gui.SetorianGunCraftingUI
	
		if (IsValid(guncraftMenu) and guncraftMenu:IsVisible()) then
			local view = {}

			local newOrigin, newAngles, newFOV, bDrawPlayer = guncraftMenu:GetOverviewInfo(origin, angles, fov)

			view.drawviewer = bDrawPlayer
			view.fov = newFOV
			view.origin = newOrigin
			view.angles = newAngles

			return view

		end

		
	end

	function PLUGIN:LoadFonts(font, genericFont)

		surface.CreateFont("GunCraftUI_Font1", {
			font = "BIZ UDGothic",
			size = 26,
			antialias = true,
			weight = 600,
		})


	end

end
