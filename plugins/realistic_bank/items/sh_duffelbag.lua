ITEM.name = "Duffel Bag"
ITEM.description = "A long tube-shaped bag used for example carrying clothes."
ITEM.model = Model("models/tobadforyou/duffel_bag.mdl")
ITEM.price = 300


if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local stacks = tonumber(self:getStacks()) or 0

		local panel = tooltip:AddRowAfter("name", "stacks_number")
		panel:SetBackgroundColor(Color(39, 174, 96))
		panel:SetText("Contains: "..ix.currency.Get(5000 * stacks))
		panel:SizeToContents()

		
	end
end

function ITEM:getStacks()
	return self:GetData("stack", 0)
end

function ITEM:AddStack()
	if (self:getStacks() == 2) then return end
	self:SetData("stack",  self:GetData("stack", 0) + 1)
end



-- function ITEM:OnInstanced(invID, x, y)
	-- self:SetData("stack", 0)
-- end