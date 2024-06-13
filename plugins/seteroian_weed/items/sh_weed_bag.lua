
ITEM.name = "Weed Bag"
ITEM.model = Model("models/winningrook/gtav/weed/weed_bag/weed_bag.mdl")
ITEM.description = "A small bag containing weed."
ITEM.category = "Weed"
ITEM.width = 1 
ITEM.height = 1

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

            if (!inventory:Add("weed1_bag_empty")) then
                ix.item.Spawn("weed1_bag_empty", client)
            end

            return true

            
        else
            client:Notify(L(invError))
        end


        return false

    end
}