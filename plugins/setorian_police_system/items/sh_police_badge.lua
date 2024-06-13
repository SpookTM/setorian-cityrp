
ITEM.name = "Police Badge"
ITEM.description = "A police badge in which is written the name and number of the officer to whom it belongs."
ITEM.model = Model("models/kerry/detectiv_pass.mdl")


if (CLIENT) then

	function ITEM:PopulateTooltip(tooltip)
		local badge_number = self:GetData("badge_number", 0)

		local off_name = self:GetData("officer_name", "")

		local panel = tooltip:AddRowAfter("name", "serial number")
		panel:SetBackgroundColor(Color(39, 174, 96))
		panel:SetText("Badge Number: "..badge_number)
		panel:SizeToContents()

		if (off_name != "") then

			local panel = tooltip:AddRowAfter("serial number", "officer name")
			panel:SetBackgroundColor(Color(39, 174, 96))
			panel:SetText("Belongs to: "..off_name)
			panel:SizeToContents()

		end

		
	end

end

function ITEM:OnInstanced(invID, x, y)

	local randNum = math.random(1, 99999)

	local amount = math.max(0, 5 - string.len(randNum))
	local number =  string.rep("0", amount)..tostring(randNum)


	self:SetData("badge_number", number)

end