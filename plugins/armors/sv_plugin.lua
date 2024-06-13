local PLUGIN = PLUGIN

function PLUGIN:ScalePlayerDamage(target, hitgroup, dmg)
    local char = target:GetCharacter()

    if char then
        local item = char:GetInventory():HasItemOfBase("base_karmors", {["equip"] = true})

        if item then
            local kevlar = item:GetData("kevlar", 100)
            local durability = item:GetData("durability", 100)

            if kevlar > 1 and durability > 1 then
                if (dmg:IsDamageType(2) or dmg:IsDamageType(536870912) or dmg:IsDamageType(33554432)) and hitgroup == item.hitgroups then
                    dmg:ScaleDamage(item.protect)
                    
                    if math.random(1, 16) < 3 and durability > 0 then
                        item:SetData("durability", durability - 1)
                    end

                    if math.random(1, 16) < 5 and kevlar > 0 then
                        item:SetData("kevlar", kevlar - 1)
                    end
                end
            end
        end
    end
end