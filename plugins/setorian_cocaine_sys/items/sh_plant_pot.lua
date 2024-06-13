
ITEM.name = "Plant Pot"
ITEM.model = Model("models/dannio/fbikid/cocaine/planter.mdl")
ITEM.description = "A pot into which you can plant a coco. The seedling can be placed if the pot is lying on the ground."
ITEM.category = "Cocaine"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true
ITEM.functions.Seed = {
    name = "Place the seedling",
    OnRun = function(itemTable)
        local client = itemTable.player
        
        local char = client:GetCharacter()

        local inv = char:GetInventory()

        local item = inv:HasItem("coca_seed")

        if (item) then

            local PotEnt = ents.Create("j_cocaine_pot");
            PotEnt:SetPos( itemTable.entity:GetPos() )
            PotEnt:SetAngles(Angle(0,0,0))
            PotEnt:Spawn()

            item:Remove()
            -- itemTable:Remove()
            return true
            -- return false

        else
            client:Notify("You don't have a coca seed")
        end

        return false

    end,
    OnCanRun = function(itemTable)

        return IsValid(itemTable.entity) 

    end
}