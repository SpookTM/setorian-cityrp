
ITEM.name = "Cocaine Brick"
ITEM.model = Model("models/dannio/fbikid/cocaine/cocainebrick.mdl")
ITEM.description = "A brick weighing a few pounds containing cocaine."
ITEM.category = "Cocaine"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true

if (CLIENT) then

    function ITEM:PaintOver(item, w, h)

        local usesLeft = item:GetData("BrickCount", 10)

        if (usesLeft > 1) then
            draw.SimpleTextOutlined(usesLeft.."/10", "DermaDefault", w - 3, h - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
        end

    end

end

ITEM.functions.Snort = {
    name = "Snort it",
    icon = "icon16/wand.png",
    OnRun = function(itemTable)
        local client = itemTable.player
            
        local char = client:GetCharacter()

        client:EmitSound("physics/rubber/rubber_tire_strain"..math.random(1,3)..".wav")

        itemTable:SetData("BrickCount", itemTable:GetData("BrickCount", 10) - 1)

        -- client.OverDoseCocaine = client.OverDoseCocaine + 1

        char:SetData("OverDoseCocaine", char:GetData("OverDoseCocaine", 0) + 1)

        client:SetCocaineDrugged(true)

        if (char:GetData("OverDoseCocaine", 0) >= 3) then
            client:Notify("You've overdosed on cocaine")
            client:Kill()
        end

        if (itemTable:GetData("BrickCount", 10) <= 0) then
            return true
        else
            return false
        end


        return false

    end,
    OnCanRun = function(itemTable)
        return (!IsValid(itemTable.entity)) 
    end
}

ITEM.functions.Cut = {
    name = "Cut it up",
    icon = "icon16/cut.png",
    OnRun = function(itemTable)
        local client = itemTable.player
            
        local char = client:GetCharacter()
        local inv = char:GetInventory()

        local razor_item = inv:HasItem("razorblade")
        local empty_bag = inv:HasItem("cocaine_bag_empty")

        if (!razor_item) then
            client:Notify("You don't have a razor blade to cut it up")
            return false
        end

        if (!empty_bag) then
            client:Notify("You don't have an empty bag in your inventory")
            return false
        end

        client.IsCuttingBrick = true

        client:EmitSound("physics/cardboard/cardboard_box_strain1.wav")

        client:SetAction("Cutting...", 3, function()

            itemTable:SetData("BrickCount", itemTable:GetData("BrickCount", 10) - 1)

            client:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav")

            if (itemTable:GetData("BrickCount", 10) <= 0) then
                itemTable:Remove()
            end

            empty_bag:Remove()

            if (!inv:Add("cocaine_bag")) then
                ix.item.Spawn("cocaine_bag", client)
            end

        end)

        return false

    end,
    OnCanRun = function(itemTable)
        return (!IsValid(itemTable.entity)) 
    end
}