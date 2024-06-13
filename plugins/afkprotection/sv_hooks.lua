
function PLUGIN:KeyPress(client, key)
	client:SetNetVar("isAFK", false)
	client:SetNetVar("afkTime", CurTime() + 180)
end

function PLUGIN:InitializedPlugins()
	timer.Create("ixAFKtimer", 1, 0, function()
		for _, client in ipairs(player.GetAll()) do
			if (CurTime() < client:GetNetVar("afkTime", 0) or client:GetNetVar("isAFK")) then continue end
			
			client:SetNetVar("isAFK", true)
		end
	end)
end
