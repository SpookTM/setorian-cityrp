
ITEM.name = "Meth Bag"
ITEM.model = Model("models/winningrook/gtav/meth/meth_ziplock/meth_ziplock_small.mdl")
ITEM.description = "A small bag containing cocaine."
ITEM.category = "Meth"
ITEM.width = 1 
ITEM.height = 1
ITEM.illegal = true
ITEM.bDropOnDeath = true

function ITEM:PopulateTooltip(tooltip)
    local tip = tooltip:AddRow("clothingwarning")
    tip:SetBackgroundColor(derma.GetColor("Error", tooltip))
    tip:SetText("Possession of this item is against the law. If you are caught with it, you may face arrest and charges.")
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end