ITEM.name = "Deed"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.description = "A deed issued to owner of property."
ITEM.width = 1
ITEM.height = 1
ITEM.IsDeed = true

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local ownerName = self:GetData("OwnerName", "")
		local propertyName = self:GetData("PropertyName", "")

		if (ownerName == "") then return end

		local panel = tooltip:AddRowAfter("name", "owner_name")
		panel:SetBackgroundColor(Color(39, 174, 96))
		panel:SetText("Belongs to: "..ownerName)
		panel:SizeToContents()

		if (propertyName == "") then return end
		
		local panel = tooltip:AddRowAfter("owner_name", "property_name")
		panel:SetBackgroundColor(Color(52, 152, 219))
		panel:SetText("deed issued for: "..propertyName)
		panel:SizeToContents()

		
	end
end

ITEM.functions.View = {
	OnRun = function(item)
		netstream.Start(item.player, "ixViewDeed", item:GetData("PropertyType", ""), item:GetData("OwnerName", ""), item:GetData("purchaseDate", ""))
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("OwnerName", "")
		-- return true
		return owner != ""
	end
}