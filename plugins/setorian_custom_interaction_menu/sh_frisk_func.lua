if (SERVER) then

	netstream.Hook("SetorianExtras_Frisk_RequestReacted", function(ply, IsAccepted)
        
        if (!IsValid(ply)) then return end

        if ( timer.Exists( "FriskChecker_"..ply:GetCharacter():GetID() ) ) then
        	timer.Remove( "FriskChecker_"..ply:GetCharacter():GetID() )
        end

        netstream.Start(ply, "SetorianExtras_Frisk_CloseAcceptUI", IsAccepted)

        if (!ply:Alive()) then ply.WhoWantFrisk = nil return end

        if (IsAccepted) then
        	ply:Notify("You have accepted a request to search your inventory.")
        else
        	ply:Notify("You refused a request to search your inventory.")
        end

        local PlyCall = ply.WhoWantFrisk

        if (!IsValid(PlyCall)) then return end

        netstream.Start(PlyCall, "SetorianExtras_Frisk_CloseWaitUI", IsAccepted)

        if (!PlyCall:Alive()) then PlyCall.WantsFrisk = nil return end

        
        if (IsAccepted) then
        	PlyCall:Notify("Request for inventory search accepted.")
        else
        	PlyCall:Notify("Request for inventory search refused.")
        end

        if (ply:GetPos():DistToSqr(PlyCall:GetPos()) > 8000) then
        	ply:Notify("You're standing too far away to do that.")
        	PlyCall:Notify("You're standing too far away to do that.")
        	return
        end

        if (IsAccepted) then

	        local char = ply:GetCharacter()

	        if (!char) then return end

	        local inv = char:GetInventory()
			local invItems = inv:GetItems()

			if (!inv) then return end

			local NetItems = {}

			for k, v in pairs(invItems) do
				
				local data = {
					Name = v.name,
					Desc = v.description,
					Model = v.model
				}
				table.insert(NetItems, data)
			end
			
			netstream.Start(PlyCall, "SetorianExtras_Frisk_OpenInv", NetItems, char:GetName())

		end

		PlyCall.WantsFrisk = nil
		ply.WhoWantFrisk = nil

    end)

    function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)

    	if (client.WhoWantFrisk) then
    		local PlyCall = client.WhoWantFrisk
    		netstream.Start(client, "SetorianExtras_Frisk_CloseAcceptUI", false)
    		netstream.Start(PlyCall, "SetorianExtras_Frisk_CloseWaitUI", false)
    	end

    	if (client.WantsFrisk) then
    		local PlyCall = client.WantsFrisk
    		netstream.Start(client, "SetorianExtras_Frisk_CloseAcceptUI", false)
    		netstream.Start(PlyCall, "SetorianExtras_Frisk_CloseWaitUI", false)
    	end

    end

    function PLUGIN:PlayerDisconnected( ply )

    	if (ply.WhoWantFrisk) then
    		local PlyCall = ply.WhoWantFrisk
    		netstream.Start(ply, "SetorianExtras_Frisk_CloseAcceptUI", IsAccepted)
    		netstream.Start(PlyCall, "SetorianExtras_Frisk_CloseWaitUI", IsAccepted)
    	end

    	if (ply.WantsFrisk) then
    		local PlyCall = ply.WantsFrisk
    		netstream.Start(ply, "SetorianExtras_Frisk_CloseAcceptUI", IsAccepted)
    		netstream.Start(PlyCall, "SetorianExtras_Frisk_CloseWaitUI", IsAccepted)
    	end

    end

end	


if (CLIENT) then

	function PLUGIN:PlayerButtonDown(ply, button)

		if (!IsValid(ix_Frisk_AcceptPanel)) then return end

		if (IsValid(ix_Frisk_AcceptPanel)) then
			if (ix_Frisk_AcceptPanel.IsClosing) then return end
		end

		if (input.GetKeyName( button ) == "F1" ) then
			
			netstream.Start("SetorianExtras_Frisk_RequestReacted", true)

		elseif (input.GetKeyName( button ) == "F2" ) then
			
			netstream.Start("SetorianExtras_Frisk_RequestReacted", false)

		end

	end

	netstream.Hook("SetorianExtras_Frisk_OpenInv", function(inv, CharName)

        vgui.Create("ixFrisk_InventoryPanel"):ShowInvItems(inv,CharName)

    end)

    netstream.Hook("SetorianExtras_Frisk_OpenAcceptUI", function(CharName)

    	if (IsValid(ix_Frisk_AcceptPanel)) then
    		ix_Frisk_AcceptPanel:Remove()
    		ix_Frisk_AcceptPanel = nil
    	end

        vgui.Create("ixFrisk_AcceptPanel"):ShowPanel(CharName)

    end)

    netstream.Hook("SetorianExtras_Frisk_CloseAcceptUI", function(IsAccepted)

    	if (IsValid(ix_Frisk_AcceptPanel)) then
    		ix_Frisk_AcceptPanel:HidePanel(IsAccepted)
    	end

    end)

    netstream.Hook("SetorianExtras_Frisk_OpenWaitUI", function(CharName)

    	if (IsValid(ix_Frisk_WaitPanel)) then
			ix_Frisk_WaitPanel:Remove()
			ix_Frisk_WaitPanel = nil
		end

        vgui.Create("ixFrisk_WaitPanel"):ShowPanel(CharName)

    end)

    netstream.Hook("SetorianExtras_Frisk_CloseWaitUI", function(IsAccepted)

    	if (IsValid(ix_Frisk_WaitPanel)) then
			ix_Frisk_WaitPanel:HidePanel(IsAccepted)
		end

    end)

end	