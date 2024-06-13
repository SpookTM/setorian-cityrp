
ITEM.name = "Pack of Cigars"
ITEM.model = Model("models/props_junk/cardboardbox03.mdl")
ITEM.description = "A pack that contains cigars."

if (CLIENT) then


    function ITEM:PopulateTooltip(tooltip)

        local cigAmount = self:GetData("cigAmount", 6)

        local CountPnl = tooltip:AddRowAfter("name", "count")
        CountPnl:SetBackgroundColor(Color(39, 174, 96))
        CountPnl:SetText("Quantity: "..cigAmount)
        CountPnl:SizeToContents()  


    end

end

ITEM.functions.takecig = {
    name = "Pull out",
    icon = "icon16/arrow_up.png",
    OnRun = function(itemTable)
        local client = itemTable.player
        local char = client:GetCharacter()
    	local inv = char:GetInventory()

    	local cigAmount = itemTable:GetData("cigAmount", 6)

    	local isSucces, errorMsg = inv:Add("cigar")

    	if (isSucces) then
    		itemTable:SetData("cigAmount", cigAmount - 1)
    		client:Notify("You pulled out a cigar")
            client:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav",50)
    		-- if (self:GetData("cigAmount", 12) <= 0) then
    		-- 	return true
    		-- end
    	else
    		client:Notify(errorMsg)
    	end

    	
    	return false

    end,
    OnCanRun = function(itemTable)
    	return (itemTable:GetData("cigAmount", 6) > 0)
    end
}
