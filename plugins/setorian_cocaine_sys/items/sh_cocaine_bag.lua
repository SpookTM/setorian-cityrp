
ITEM.name = "Cocaine Bag"
ITEM.model = Model("models/jellik/cocaine.mdl")
ITEM.description = "A small bag containing cocaine."
ITEM.category = "Cocaine"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true

ITEM.functions.Snort = {
    name = "Snort it",
    icon = "icon16/wand.png",
    OnRun = function(itemTable)
        local client = itemTable.player
            
        local char = client:GetCharacter()
        local inv = char:GetInventory()

        client:EmitSound("physics/rubber/rubber_tire_strain"..math.random(1,3)..".wav")

        char:SetData("OverDoseCocaine", char:GetData("OverDoseCocaine", 0) + 1)
        client:SetCocaineDrugged(true)

        if (char:GetData("OverDoseCocaine", 0) >= 3) then
        	client:Notify("You've overdosed on cocaine")
        	client:Kill()
        end

        if (!inv:Add("cocaine_bag_empty")) then
            ix.item.Spawn("cocaine_bag_empty", client)
        end

        return true

    end,
    OnCanRun = function(itemTable)
        return (!IsValid(itemTable.entity))
    end
}