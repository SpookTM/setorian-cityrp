ITEM.name = "Weed Bud"
ITEM.description = "Combine these to into bags"
ITEM.model = Model("models/gram.mdl")
ITEM.category = "Drugs"
ITEM.price = 0

ITEM.functions.MakeBlunt = {
    name = "Make a Blunt",
    tip = "useTip",
    icon = "icon16/page_go.png",
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

    end,

 	OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        local inventory = char:GetInventory()

        local paper = inventory:HasItem("weed_rolling_paper")

        if (!paper) then
            client:Notify("You don't have a rolling paper in your inventory")
            return false
        end

        local canAdd, invError = inventory:Add("weed_blunt")

        if (canAdd) then

            client:EmitSound("physics/cardboard/cardboard_box_strain"..math.random(1,3)..".wav")

            client:Notify("You've created a blunt")

            paper:Remove()

            return true

            
        else
            client:Notify(L(invError))
        end


        return false

    end
}

ITEM.functions.MakeBrick = {
    name = "Make a Brick",
    tip = "useTip",
    icon = "icon16/brick.png",
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

    end,

 	OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        local inventory = char:GetInventory()

        local budCount = inventory:GetItemCount("weed_bud")

        if (budCount < 5) then
            client:Notify("You don't have enough buds in your inventory. Required minimum of 5")
            return false
        end

        local canAdd, invError = inventory:Add("weed_brick")

        budCount = 4

        if (canAdd) then

            client:EmitSound("physics/cardboard/cardboard_box_strain"..math.random(1,3)..".wav")

            client:Notify("You've created a brick")

            for k, v in ipairs(inventory:GetItemsByUniqueID("weed_bud")) do
            	if (v == item) then continue end
            	v:Remove()
            	budCount = budCount - 1
            	if (budCount <= 0) then break end
            end

            return true

            
        else
            client:Notify(L(invError))
        end


        return false

    end
}