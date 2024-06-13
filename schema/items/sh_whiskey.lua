ITEM.name = "Whiskey Bottle"
ITEM.description = "Old aged whiskey"
ITEM.category = "Alcohol"
ITEM.model = "models/props/cryts_food/drink_whiskey.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.effectAmount = 0.5
ITEM.effectTime = 30
ITEM.shots = 4

-- Define the item's initial shot count, if needed to identify the number of shots the item has
-- **Function Definition**:
ITEM.functions.Pour = {
    name = "Pour",
    icon = "icon16/drink.png",
    OnRun = function(item)
        local client = item.player
        local remainingShots = item:GetData("shots", 0)  -- Retrieve the remaining shots
        if (IsValid(client)) then
            ix.chat.Send(client, "me", "poured a shot from the bottle.")  -- Send a /me notice
            if remainingShots > 0 then
                -- Decrease the shot count
                item:SetData("shots", remainingShots - 1)

                -- Create a cup item and give it to the player
                local cupItem = client:GetCharacter():GetInventory():Add("cup_whiskey")  -- Replace "cup_whiskey" with the correct unique ID

                if cupItem then
                    client:ChatPrint("You poured a shot into a cup.")
                else
                    client:ChatPrint("Your inventory is full. You can't pour any more shots.")
                end

                -- Check if the bottle is empty
                if remainingShots - 1 == 0 then
                    -- Remove the bottle item from the player's inventory
                    client:GetCharacter():GetInventory():Remove(item:GetID())
                end
            else
                client:ChatPrint("The bottle is empty.")
            end
        end
        return false
    end,
    OnCanRun = function(item)
        return item:GetData("shots", 0) > 0
    end
}