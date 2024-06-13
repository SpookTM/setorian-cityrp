
ITEM.name = "Tray with Smashed Meth"
ITEM.model = Model("models/winningrook/gtav/meth/meth_tray/meth_tray_smashed.mdl")
ITEM.description = "An open receptacle with a flat bottom and a low rim for holding, carrying, or exhibiting articles. Contains meth."
ITEM.category = "Meth"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true
if (CLIENT) then

    function ITEM:PaintOver(item, w, h)

        local quant = item:GetData("quantity", 5)

        if (quant > 1 ) then
            draw.SimpleTextOutlined(quant, "DermaDefault", w - 3, h - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
        end

    end
end

ITEM.functions.PutInBack = {
    name = "Put in the bag",
    tip = "useTip",
    icon = "icon16/add.png",
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

        if (item:GetData("status", false)) then return false end

    end,

    OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        local inventory = char:GetInventory()

        local empty_bag = inventory:HasItem("meth_bag_empty")

        if (!empty_bag) then
            client:Notify("You don't have an empty bag in your inventory")
            return false
        end

        local canAdd, invError = inventory:Add("meth_bag")

        if (canAdd) then

            local itemStatus = item:GetData("quantity", 5)

            client:EmitSound("physics/cardboard/cardboard_box_shake"..math.random(1,3)..".wav")

            client:Notify("You put the meth in the bag")

            item:SetData("quantity", item:GetData("quantity", 5) - 1)

            empty_bag:Remove()

            if (item:GetData("quantity", 5) <= 0) then

                if (!inventory:Add("methtray_empty")) then
                    ix.item.Spawn("methtray_empty", client)
                end



                return true
            end
            
        else
            client:Notify(L(invError))
        end


        return false

    end
}