ITEM.name = "Cash Register"
ITEM.description = "A machine used in shops that has a drawer for money and totals, displays, and records the amount of each sale."
ITEM.model = "models/props_c17/cashregister01a.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Place = {
    name = "Place",
    tip = "useTip",
    icon = "icon16/wrench.png",
    OnRun = function(item)

        local client = item.player

        local entity = ents.Create("j_business_cashregister")

        local position = client:GetItemDropPos(entity)
        entity:SetPos(position)
        entity:SetAngles(client:GetAngles())
        entity:Spawn()
        entity:SetOwnerCharID(client:GetCharacter():GetID())

        return true
    end,

    OnCanRun = function(item)
        if IsValid(item.entity) then return false end
    end
}
