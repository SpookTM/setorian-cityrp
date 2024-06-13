
ITEM.name = "Empty Meth Pipe"
ITEM.model = Model("models/legendofrobbo/cigar/pipew.mdl")
ITEM.description = "A meth pipe is often made of glass and is used to smoke methamphetamine, a potent and highly addictive stimulant."
ITEM.category = "Meth"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true
ITEM.functions.Refill = {
    name = "Refill",
    tip = "useTip",
    icon = "icon16/add.png",
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

    end,

    OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        local inventory = char:GetInventory()

        local bag = inventory:HasItem("meth_bag")

        if (!bag) then
            client:Notify("You don't have a bag of meth in your inventory")
            return false
        end

        local canAdd, invError = inventory:Add("meth_pipe")

        if (canAdd) then

            client:EmitSound("physics/cardboard/cardboard_box_shake"..math.random(1,3)..".wav")

            client:Notify("You filled the pipe with meth")

            if (!inventory:Add("meth_bag_empty")) then
                ix.item.Spawn("meth_bag_empty", client)
            end

            bag:Remove()

            return true

        else
            client:Notify(L(invError))
        end


        return false

    end
}