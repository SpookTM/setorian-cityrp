local PLUGIN = PLUGIN
PLUGIN.name = "APhone 911 Emergency"
PLUGIN.desc = "Adds to aphone's ability to make calls for emergency service"
PLUGIN.author = "JohnyReaper"

ALWAYS_RAISED["aphone"] = true

ix.util.Include("cl_func.lua")

function PLUGIN:InitializedPlugins()

	PLUGIN.Services = {
		["New York Police Department"] = {
			[FACTION_POLICE] = true,
		},
		["Emergency Medical Service"] = {
			[FACTION_EMS] = true,
		},
	}

end

if (SERVER) then

	util.AddNetworkString("ixAPhone_EmergencyUI")
	util.AddNetworkString("ixAPhone_SendCall")

	-- util.AddNetworkString("ixAPhone_SendCallLocation")

	net.Receive( "ixAPhone_SendCall", function( len, client )

		local selectedService = net.ReadString()
		local reason = net.ReadString()

		if (!PLUGIN.Services[selectedService]) then
			client:Notify("Service doesn't exists")
			return
		end

		local Receivers = {}

		for Otherclient, character in ix.util.GetCharacters() do

			if (!PLUGIN.Services[selectedService][character:GetFaction()]) then continue end

			if (Otherclient != client) then
				Otherclient:Notify("You have received an emergency call")
			end

			Receivers[#Receivers+1] = Otherclient

		end

		client:Notify("You sent a message to the emergency services")

		net.Start("ixAPhone_SendCall")
			net.WriteEntity(client)
			net.WriteString(reason)
	    net.Send(Receivers)

	end)

	function PLUGIN:CheckForEmergencyUI(client)
		
		net.Start("ixAPhone_EmergencyUI")
	    net.Send(client)

		-- for k, v in pairs(self.Services) do

		-- 	if (v[character:GetFaction()]) then
		-- 		-- vgui.Create("ixEmergencyService_Notify")
		-- 		return
		-- 	end
			
		-- end

		-- if (IsValid(ix.gui.emergencyui)) then
		-- 	ix.gui.emergencyui:Remove()
		-- end

	end

else

	net.Receive( "ixAPhone_EmergencyUI", function( len )

		local character = LocalPlayer():GetCharacter()

		if (!character) then return end

		for k, v in pairs(PLUGIN.Services) do

			if (v[character:GetFaction()]) then
				vgui.Create("ixEmergencyService_Notify")
				return
			end
			
		end

		if (IsValid(ix.gui.emergencyui)) then
			ix.gui.emergencyui:Remove()
		end

	end)

	net.Receive( "ixAPhone_SendCall", function( len )

		local ply = net.ReadEntity()
		local RespondeText = net.ReadString()

		if (IsValid(ix.gui.emergencyui)) then
			ix.gui.emergencyui:AddNewNotify(ply, RespondeText)
		else
			vgui.Create("ixEmergencyService_Notify")
			ix.gui.emergencyui:AddNewNotify(ply, RespondeText)
		end

	end)

	function PLUGIN:CharacterLoaded(character)


		for k, v in pairs(self.Services) do

			if (v[character:GetFaction()]) then
				vgui.Create("ixEmergencyService_Notify")
				return
			end
			
		end

		if (IsValid(ix.gui.emergencyui)) then
			ix.gui.emergencyui:Remove()
		end

	end

	function PLUGIN:PlayerButtonDown(client, key)
		if (key == KEY_F3) then
			gui.EnableScreenClicker(true)
		end
	end

	function PLUGIN:PlayerButtonUp(client, key)
		if (key == KEY_F3) then
			gui.EnableScreenClicker(false)
		end
	end

-- 	net.Receive( "ixPoliceSys_OpenLaptopUI", function( len )

-- 		vgui.Create("ixPoliceSys_PhoneApp")

-- 	end)

end