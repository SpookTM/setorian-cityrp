PLUGIN.name = "Properties System"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = ""

ix.util.Include("sv_properties.lua", "server")
ix.util.Include("libraries/cl_imgur.lua", "client")

if (!(ix.plugin.Get("keys") or false)) then
	return MsgN("[Helix] keys plugin is missing!")
end

ix.config.Add("PropertyOwnMax", 3, "Minimum health value that can be healed by vortigaunt" , nil, {
	data = {min = 1, max = 20},
	category = "Properties"
})

if (SERVER) then

	function PLUGIN:LoadData()
		self:LoadJREstateAgents()
	end

	function PLUGIN:SaveData()
		self:SaveJREstateAgents()
	end

	function PLUGIN:SaveJREstateAgents()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_property_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_properties_npc", data)

	end

	function PLUGIN:LoadJREstateAgents()
		for _, v in ipairs(ix.data.Get("jr_properties_npc") or {}) do
			local npc = ents.Create("j_property_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

end

if (CLIENT) then

	-- function PLUGIN:ShouldDisableLegs()
	-- 	return LocalPlayer().LookOnPreview
	-- end

	function PLUGIN:PopulateEntityInfo(ent, tooltip)
		if (ent:GetClass() == "j_property_npc") then

			local panel = tooltip:AddRow("name")
			panel:SetText("Estate agent")
			panel:SetImportant()
	  		-- panel:SetBackgroundColor(Color(250,250,0))
	  	 	panel:SizeToContents()
	  	 	

	  	 	local desc = tooltip:AddRowAfter("name", "desc")
			desc:SetText("You can purchase and manage properties here.")
	  		-- desc:SetBackgroundColor(Color(250,250,0))
	  	 	desc:SizeToContents()

	  	 	tooltip:SizeToContents()

	  	 end

	end

	netstream.Hook("ixViewDeed", function(type, owner, date)
		vgui.Create("ix_deedGUI"):Populate(type,owner,date)
	end)

	netstream.Hook("ixPropeties_OpenMenu", function()
	
		local keysPlugin = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("keys") or false
-- print("Open property menu")
		if (!keysPlugin) then return end

		keysPlugin:RequestData(function(data)
		    local frame = vgui.Create("ixPropertiesMenu")
		    frame.Properties = data
		end)

	end)
end