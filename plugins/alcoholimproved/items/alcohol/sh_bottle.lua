ITEM.name = "Brandy"
ITEM.description = "A bottle with liquid that can be poured into cups."
ITEM.category = "Alcohol"
ITEM.model = "models/mark2580/gtav/barstuff/bottle_brandy.mdl" -- Change to your bottle model
ITEM.effectAmount = 0.5
ITEM.effectTime = 180
ITEM.pourCount = 5 -- Number of pours available

function ITEM:GetDescription()
    local pours = self:GetData("pours", self.pourCount)
    print("GetDescription called for: " .. self.name .. " | Pours remaining: " .. pours)  -- Debugging line
    return self.description .. "\nPours remaining: " .. pours
end


ITEM.functions.Pour = {
    name = "Pour into Cup",
    icon = "icon16/cup.png",
    OnRun = function(item)
        local player = item.player
        local inventory = player:GetCharacter():GetInventory()
        local pours = item:GetData("pours", item.pourCount)

        if pours > 0 then
            local cupItem = ix.item.list["cup_whiskey"]
            if cupItem then
                local canAdd = inventory:FindEmptySlot(cupItem.width, cupItem.height)
                if canAdd then
                    inventory:Add("cup_whiskey", 1)
                    pours = pours - 1
                    item:SetData("pours", pours)
                    player:Notify("You poured a cup.")

                    if pours <= 0 then
                        player:Notify("The bottle is now empty.")
                        return true -- This will remove the bottle from the inventory
                    end

                    return false
                else
                    player:Notify("You need more space for a cup.")
                end
            else
                player:Notify("Error: Cup item not found.")
            end
        else
            player:Notify("The bottle is empty.")
            return true -- This will remove the bottle from the inventory
        end

        return false
    end,
    OnCanRun = function(item)
        return (!IsValid(item.entity))
    end
}

