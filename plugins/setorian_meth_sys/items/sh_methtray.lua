
ITEM.name = "Tray with Meth"
ITEM.model = Model("models/winningrook/gtav/meth/meth_tray/meth_tray_full.mdl")
ITEM.description = "An open receptacle with a flat bottom and a low rim for holding, carrying, or exhibiting articles. Contains meth."
ITEM.category = "Meth"
ITEM.width = 1 
ITEM.height = 1
ITEM.illegal = true
ITEM.bDropOnDeath = true

if (CLIENT) then


    function ITEM:PopulateTooltip(tooltip)

        local itemStatus = self:GetData("status", false)

        local panel = tooltip:AddRowAfter("name", "status")
        panel:SetBackgroundColor( (itemStatus and Color(41, 128, 185)) or Color(185, 128, 41) )
        panel:SetText("Status: "..((itemStatus and "Frozen") or "Cooked"))
        panel:SizeToContents()



    end

end

ITEM.functions.Smash = {
    name = "Smash",
    tip = "useTip",
    icon = "icon16/link_break.png",
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

        if (!item:GetData("status", false)) then return false end

    end,

    OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        local inventory = char:GetInventory()

        client.IsSmashingMeth = true

        client:SetAction("Crashing...", 3, function()

            local canAdd, invError = inventory:Add("methtray_smash")

            if (canAdd) then

                client:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav")

                client:Notify("You've smashed meth")

                item:Remove()

            else
                client:NotifyLocalized(invError)
            end

        end)


        return false

    end
}

function ITEM:PopulateTooltip(tooltip)
    local tip = tooltip:AddRow("clothingwarning")
    tip:SetBackgroundColor(derma.GetColor("Error", tooltip))
    tip:SetText("Possession of this item is against the law. If you are caught with it, you may face arrest and charges.")
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end