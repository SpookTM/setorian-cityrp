
ITEM.name = "Meth Pipe"
ITEM.model = Model("models/legendofrobbo/cigar/pipew.mdl")
ITEM.description = "A meth pipe is often made of glass and is used to smoke methamphetamine, a potent and highly addictive stimulant."
ITEM.category = "Meth"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true

ITEM.functions.Use = {
    name = "Use",
    tip = "useTip",
    icon = "icon16/accept.png",
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

    end,

    OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        local inventory = char:GetInventory()

        client:Give("dmod_methpipe")
        client:SelectWeapon("dmod_methpipe")

        if (!inventory:Add("meth_pipe_empty")) then
            ix.item.Spawn("meth_pipe_empty", client)
        end

        return true

    end
}