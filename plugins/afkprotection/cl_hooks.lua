
function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
	if (!client:GetNetVar("isAFK")) then return end

	local panel = tooltip:AddRowAfter("name", "afkTip")
	panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
	panel:SetText("They have been AFK for " .. string.NiceTime(CurTime() - client:GetNetVar("afkTime", 0)) .. ".")
	panel:SizeToContents()
end

function PLUGIN:HUDPaintBackground()
	if (!LocalPlayer():GetNetVar("isAFK")) then return end
	
	ix.util.DrawText("You have been AFK for " .. string.NiceTime(CurTime() - LocalPlayer():GetNetVar("afkTime", 0)) .. ".", ScrW() * 0.5, ScrH() * 0.33, nil, 1, 1, "ixBigFont")
end
