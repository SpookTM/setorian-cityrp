
ITEM.name = "Mushroom"
ITEM.model = Model("models/psychedelics/mushroom/mushroom_3.mdl")
ITEM.description = "They are psychedelic drugs, which means they can affect all the senses, altering a person's thinking, sense of time and emotions."
ITEM.category = "Psychedelics"
ITEM.width = 1 
ITEM.height = 1
ITEM.illegal = true
ITEM.bDropOnDeath = true

ITEM.functions.Use = {
    name = "Use",
    tip = "useTip",
    icon = "icon16/tick.png",
    OnCanRun = function(item)
        return true
    end,

    OnRun = function(item)
        local client = item.player

        net.Start("psychedelicsStartShroom")
		net.WriteInt(100,20)
		net.Send(client)

        return true

    end
}

function ITEM:PopulateTooltip(tooltip)
    local tip = tooltip:AddRow("clothingwarning")
    tip:SetBackgroundColor(derma.GetColor("Error", tooltip))
    tip:SetText("Possession of this item is against the law. If you are caught with it, you may face arrest and charges.")
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end