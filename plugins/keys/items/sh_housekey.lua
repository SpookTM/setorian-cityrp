ITEM.name = "House Key"
ITEM.description = "A key used to open a door."
ITEM.model = "models/spartex117/key.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.base = nil -- https://github.com/NebulousCloud/helix/blob/master/gamemode/core/libs/sh_item.lua#L181-L198

-- function ITEM:OnInstanced(invID, x, y, item)
-- 	item:SetData("HouseName", "Unknown House")
-- 	item:SetData("PropertyID", -1)
-- end

function ITEM:GetName()
    return "Key for ".. self:GetData("HouseName", "unknown door")
end

ITEM.functions.drop = {
    tip = "dropTip",
    icon = "icon16/world.png",
    OnRun = function(item)
        local bSuccess, error = item:Transfer(nil, nil, nil, item.player)

        if (!bSuccess and isstring(error)) then
            item.player:NotifyLocalized(error)
        else
            item.player:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
        end

        return false
    end,
    OnCanRun = function(item)
        return !IsValid(item.entity) and !item.noDrop and (!item:GetData("NoDrop", false))
    end
}