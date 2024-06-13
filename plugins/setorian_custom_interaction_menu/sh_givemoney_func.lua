if (SERVER) then

	netstream.Hook("SetorianExtras_Post_GiveMoney", function(client, text)

		if (!client:GetCharacter():HasMoney(text)) then
			return "@insufficientMoney"
		end

		local eyeTrace = client:GetEyeTrace()

		local eyeEnt = eyeTrace.Entity

		if (eyeEnt:IsPlayer()) then
			
			if (client:GetPos():DistToSqr(eyeEnt:GetPos()) < 5000) then

				local TransferMoney = text

				client:GetCharacter():TakeMoney(TransferMoney)
				eyeEnt:GetCharacter():GiveMoney(TransferMoney)

				client:Notify("You gave "..ix.currency.Get(TransferMoney).." to "..eyeEnt:GetCharacter():GetName())
				eyeEnt:Notify("You received "..ix.currency.Get(TransferMoney).." from "..client:GetCharacter():GetName())

			else
				client:Notify("You or the person you want to give money to is standing too far away to do that.")
			end

		end

	end)

end	


if (CLIENT) then

	netstream.Hook("SetorianExtras_GiveMoney", function()

        Derma_StringRequest("Money", "What amount of money do you want to give?", "1", function(text)

        	local amount = tonumber(text)

        	if (amount > 0) then
	            netstream.Start("SetorianExtras_Post_GiveMoney", amount)
	        end
        end)
    end)

end	