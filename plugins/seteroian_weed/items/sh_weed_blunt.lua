
ITEM.name = "Weed Blunt"
ITEM.model = Model("models/base/bluntmodel.mdl")
ITEM.description = "Blunt with weed ready to smoke."
ITEM.category = "Weed"
ITEM.width = 1 
ITEM.height = 1

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

        local lighter = inventory:HasItem("lighter")

        if (!lighter) then
            client:Notify("You don't have a lighter in your inventory")
            return false
        end

        local randomSwep = {
            "dmod_bluntbubba", "dmod_bluntluke", "dmod_bluntmaui", "dmod_bluntog", "dmod_bluntpineapple"
        }

        local drawnSwep = randomSwep[ math.random( #randomSwep ) ]

        client:Give(drawnSwep)
        client:SelectWeapon(drawnSwep)

        return true

    end
}