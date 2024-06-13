
ITEM.name = "LSD 5 Sheets"
ITEM.model = Model("models/psychedelics/lsd/blotter/5sheet.mdl")
ITEM.description = "A potent psychedelic drug. Effects typically include intensified thoughts, emotions, and sensory perception."
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

        net.Start("psychedelicsStartLSD")
		net.WriteInt(5,20)
		net.Send(client)

        return true

    end
}

ITEM.functions.Crop = {
    name = "Crop",
    tip = "useTip",
    icon = "icon16/cut.png",
    OnCanRun = function(item)
        return true
    end,

    OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()
        local inventory = char:GetInventory()

        client:EmitSound("physics/cardboard/cardboard_box_strain1.wav")
        
        for i=1, 5 do
            if (!inventory:Add("psychedelics_blotter_1sheet")) then
                ix.item.Spawn("psychedelics_blotter_1sheet", client)
            end
        end

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