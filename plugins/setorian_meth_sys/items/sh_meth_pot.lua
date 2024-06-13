
ITEM.name = "Meth Pot"
ITEM.model = Model("models/props_c17/metalPot001a.mdl")
ITEM.description = "Pot used for cooking meth."
ITEM.category = "Meth"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true
if (CLIENT) then

    function ITEM:PopulateTooltip(tooltip)

        local cook_level = self:GetData("cook_level", 0)

        local panel = tooltip:AddRowAfter("description", "cook_level")
        panel:SetBackgroundColor(Color(230, 126, 34))
        panel:SetText("Cook Level: "..cook_level)
        panel:SizeToContents()

        local panel = tooltip:AddRowAfter("cook_level", "ingre_title")
        panel:SetBackgroundColor(Color(39, 174, 96))
        panel:SetText("Ingredients: ")
        panel:SizeToContents()

        local acetoneValue = self:GetData("acetone", 0)
        local bismuthValue = self:GetData("bismuth", 0)
        local hydrogenValue = self:GetData("hydrogen", 0)
        local phosphoricValue = self:GetData("phosphoric", 0)

        local panel = tooltip:AddRowAfter("ingre_title", "AcetoneText")
        -- panel:SetBackgroundColor(Color(230, 126, 34))
        panel:SetText("- Acetone "..acetoneValue.."%")
        panel:SizeToContents()

        local panel = tooltip:AddRowAfter("AcetoneText", "BismuthText")
        panel:SetText("- Bismuth "..bismuthValue.."%")
        panel:SizeToContents()
        
        local panel = tooltip:AddRowAfter("BismuthText", "hydrogenText")
        panel:SetText("- Hydrogen Peroxide "..hydrogenValue.."%")
        panel:SizeToContents()
        
        local panel = tooltip:AddRowAfter("hydrogenText", "phosphoricText")
        panel:SetText("- Phosphoric Acid "..phosphoricValue.."%")
        panel:SizeToContents()
         
        local methl = self:GetData("meth_level", 0)

        if (methl > 0) then

            local panel = tooltip:AddRowAfter("phosphoricText", "meth_level")
            panel:SetBackgroundColor(Color(230, 34, 34))
            panel:SetText("Meth Level: "..methl)
            panel:SizeToContents()

        end

    end

end

ITEM.functions.combine = {
    OnCanRun = function(item, data)
        if not data then return false end
        local targetItem = ix.item.instances[data[1]]

        if (targetItem.MethIngredient) then
            return true
        end

        return false

    end,
    OnRun = function(item, data)
        local targetItem = ix.item.instances[data[1]]

        local ply = item.player
        local char = ply:GetCharacter()
        local inv = char:GetInventory()

        if (targetItem.MethIngredient) then

            local targetID = targetItem.uniqueID

            if (targetID == "acetone") then

                if (item:GetData("acetone", 0) >= 100) then
                    ply:Notify("You can't add more "..targetItem:GetName().." to the pot")
                    return false
                end

                item:SetData("acetone", item:GetData("acetone", 0) + 1)
                targetItem:SetData("capacity", targetItem:GetData("capacity", 9) - 1)
            elseif (targetID == "bismuth") then

                if (item:GetData("bismuth", 0) >= 100) then
                    ply:Notify("You can't add more "..targetItem:GetName().." to the pot")
                    return false
                end

                item:SetData("bismuth", item:GetData("bismuth", 0) + 1)
                targetItem:SetData("capacity", targetItem:GetData("capacity", 20) - 1)
            elseif (targetID == "hydrogen") then

                if (item:GetData("hydrogen", 0) >= 100) then
                    ply:Notify("You can't add more "..targetItem:GetName().." to the pot")
                    return false
                end

                item:SetData("hydrogen", item:GetData("hydrogen", 0) + 1)
                targetItem:SetData("capacity", targetItem:GetData("capacity", 30) - 1)
            elseif (targetID == "phosphoric") then

                if (item:GetData("phosphoric", 0) >= 100) then
                    ply:Notify("You can't add more "..targetItem:GetName().." to the pot")
                    return false
                end

                item:SetData("phosphoric", item:GetData("phosphoric", 0) + 1)
                targetItem:SetData("capacity", targetItem:GetData("capacity", 20) - 1)
            end

            if (targetItem:GetData("capacity", 0) <= 0) then
                targetItem:Remove()
            end

            ply:Notify("You've added "..targetItem:GetName().." to the pot")
            ply:EmitSound("ambient/water/water_spray1.wav")

        end

        return false

    end
}

ITEM.functions.AddIngredients = {
    name = "Add ingredients",
    tip = "useTip",
    icon = "icon16/add.png",
    isMulti = true,
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end
        -- if (!item:GetData("Attachments")) then return false end
        -- if table.Count(item:GetData("Attachments", {})) <= 0 then return false end
        -- if IsValid(item.entity) then return false end
        return true

    end,
    multiOptions = function(item, client)
        local targets = {}
        local char = client:GetCharacter()

        if (char) then
        	local inventory = char:GetInventory()
            -- local atts = item:GetData("Attachments", {})

            local HasAcetone = inventory:HasItem("acetone")

            if (HasAcetone) and (item:GetData("acetone", 0) < 100) then
            	table.insert(targets, {
                    name = HasAcetone:GetName(),
                    data = {HasAcetone.uniqueID},
                })
            end

            local HasBismuth = inventory:HasItem("bismuth")

            if (HasBismuth) and (item:GetData("bismuth", 0) < 100) then
            	table.insert(targets, {
                    name = HasBismuth:GetName(),
                    data = {HasBismuth.uniqueID},
                })
            end

            local Hashydrogen = inventory:HasItem("hydrogen")

            if (Hashydrogen) and (item:GetData("hydrogen", 0) < 100) then
            	table.insert(targets, {
                    name = Hashydrogen:GetName(),
                    data = {Hashydrogen.uniqueID},
                })
            end

            local Hasphosphoric = inventory:HasItem("phosphoric")

            if (Hasphosphoric)  and (item:GetData("phosphoric", 0) < 100) then
            	table.insert(targets, {
                    name = Hasphosphoric:GetName(),
                    data = {Hasphosphoric.uniqueID},
                })
            end
            
        end

        return targets
    end,
    OnRun = function(item, data)
        if not data[1] then return false end
        local target = data[1]

        local ply = item.player
        local char = ply:GetCharacter()

        local inventory = char:GetInventory()
        local targetID = target
        local targetName = ix.item.list[targetID].name
        local hasTarget = inventory:HasItem(targetID)

        if (hasTarget) then

            if (targetID == "acetone") then

                if (item:GetData("acetone", 0) >= 100) then
                    ply:Notify("You can't add more "..targetName.." to the pot")
                    return false
                end

                item:SetData("acetone", item:GetData("acetone", 0) + 1)
                hasTarget:SetData("capacity", hasTarget:GetData("capacity", 9) - 1)
            elseif (targetID == "bismuth") then

                if (item:GetData("bismuth", 0) >= 100) then
                    ply:Notify("You can't add more "..targetName.." to the pot")
                    return false
                end

                item:SetData("bismuth", item:GetData("bismuth", 0) + 1)
                hasTarget:SetData("capacity", hasTarget:GetData("capacity", 20) - 1)
            elseif (targetID == "hydrogen") then

                if (item:GetData("hydrogen", 0) >= 100) then
                    ply:Notify("You can't add more "..targetName.." to the pot")
                    return false
                end

                item:SetData("hydrogen", item:GetData("hydrogen", 0) + 1)
                hasTarget:SetData("capacity", hasTarget:GetData("capacity", 30) - 1)
            elseif (targetID == "phosphoric") then

                if (item:GetData("phosphoric", 0) >= 100) then
                    ply:Notify("You can't add more "..targetName.." to the pot")
                    return false
                end

                item:SetData("phosphoric", item:GetData("phosphoric", 0) + 1)
                hasTarget:SetData("capacity", hasTarget:GetData("capacity", 20) - 1)
            end

            if (hasTarget:GetData("capacity", 0) <= 0) then
                hasTarget:Remove()
            end

            ply:Notify("You've added "..targetName.." to the pot")
            ply:EmitSound("ambient/water/water_spray1.wav")
        end

        return false

    end
}

ITEM.functions.RemoveIngredients = {
    name = "Remove ingredients",
    tip = "useTip",
    icon = "icon16/delete.png",
    isMulti = true,
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

        if (item:GetData("acetone", 0) > 0) or (item:GetData("bismuth", 0) > 0) or (item:GetData("hydrogen", 0) > 0) or (item:GetData("phosphoric", 0) > 0) then
            return true
        else
            return false
        end

    end,
    multiOptions = function(item, client)
        local targets = {}
        
        local acetoneValue = item:GetData("acetone", 0)
        local bismuthValue = item:GetData("bismuth", 0)
        local hydrogenValue = item:GetData("hydrogen", 0)
        local phosphoricValue = item:GetData("phosphoric", 0)

        if (acetoneValue > 0) then
            table.insert(targets, {
                name = "Acetone",
                data = {"acetone"},
            })
        end
        if (bismuthValue > 0) then
            table.insert(targets, {
                name = "Bismuth",
                data = {"bismuth"},
            })
        end
        if (hydrogenValue > 0) then
            table.insert(targets, {
                name = "Hydrogen Peroxide",
                data = {"hydrogen"},
            })
        end
        if (phosphoricValue > 0) then
            table.insert(targets, {
                name = "Phosphoric Acid",
                data = {"phosphoric"},
            })
        end

        return targets
    end,
    OnRun = function(item, data)
        if not data[1] then return false end
        local target = data[1]

        local ply = item.player
        local char = ply:GetCharacter()

        if (item:GetData(target, 0) > 0) then

            item:SetData(target, item:GetData(target, 0) - 1)

            ply:Notify("You removed an ingredient from the pot")
            ply:EmitSound("ambient/water/water_spray1.wav")

        end
        
        return false

    end
}

ITEM.functions.Tray = {
    name = "Pour into a tray",
    tip = "useTip",
    icon = "icon16/basket_put.png",
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

        local client = item.player

        local char = client:GetCharacter()

        local inventory = char:GetInventory()

        local HasTray = inventory:HasItem("methtray_empty")

        if (HasTray) and (item:GetData("cook_level", 0) >= 100) then
            return true
        else
            return false
        end

    end,

    OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        local inventory = char:GetInventory()

        local HasTray = inventory:HasItem("methtray_empty")

        if (HasTray) and (item:GetData("cook_level", 0) >= 100) then

            local canAdd, invError = inventory:Add("methtray")

            if (canAdd) then

                client:EmitSound("ambient/water/water_spray1.wav")
                client:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav")

                client:Notify("You poured the contents into a tray")

                item:SetData("meth_level", math.max(item:GetData("meth_level", 0) - 20,0))

                HasTray:Remove()

                if (item:GetData("meth_level", 0) <= 0) then
                    item:SetData("cook_level", 0)
                    item:SetData("acetone", 0)
                    item:SetData("bismuth", 0)
                    item:SetData("hydrogen", 0)
                    item:SetData("phosphoric", 0)
                end

            else
                client:NotifyLocalized(invError)
            end

        end

        return false

    end
}