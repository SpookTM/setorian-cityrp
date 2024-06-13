
netstream.Hook("ixViewPaper", function(itemID, text, bEditable, textcolor)
	bEditable = tobool(bEditable)

	local panel = vgui.Create("ixPaper")
	if textcolor ~= nil then
		panel:SetText(text, textcolor)
	else
		panel:SetText(text, Color(0, 0, 0))
	end
	panel:SetEditable(true)
	panel:SetItemID(itemID)
end)

