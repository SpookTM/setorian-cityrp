
ITEM.name = "Coca Leaf"
ITEM.model = Model("models/customhq/tobaccofarm/leaf.mdl")
ITEM.description = "from the coca plant."
ITEM.category = "Cocaine"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true

function ITEM:GetModel()

    local leavesCount = self:GetData("leavesCount", 1)

    -- local dryStatus = (self:GetData("dry_status") and "Dry") or "Wet"

    if (leavesCount > 1) then
        return (self:GetData("dry_status", false) and "models/customhq/tobaccofarm/leafstack_dry.mdl") or "models/customhq/tobaccofarm/leafstack.mdl"
    else
        return (self:GetData("dry_status", false) and "models/customhq/tobaccofarm/dryleaf.mdl") or "models/customhq/tobaccofarm/leaf.mdl"
    end

    -- return (leavesCount > 1 and (self:GetData("dry_status", false) and "models/customhq/tobaccofarm/leafstack_dry.mdl") or "models/customhq/tobaccofarm/leafstack.mdl") or ((self:GetData("dry_status") and "models/customhq/tobaccofarm/dryleaf.mdl") or "models/customhq/tobaccofarm/leaf.mdl")

end

function ITEM:GetName()

    local leavesCount = self:GetData("leavesCount", 1)

    local ProperName = (leavesCount > 1 and "leaves") or "leaf"

    return "Coca "..ProperName
end

function ITEM:GetDescription()

    local leavesCount = self:GetData("leavesCount", 1)

    local ProperName = (leavesCount > 1 and "Leaves") or "Leaf"

    return ProperName .. " ".. self.description

end

if (CLIENT) then

    function ITEM:PaintOver(item, w, h)

        local leavesCount = item:GetData("leavesCount", 1)

        if (leavesCount > 1) then
            draw.SimpleTextOutlined(leavesCount, "DermaDefault", w - 3, h - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
        end

    end

    function ITEM:PopulateTooltip(tooltip)

        local dryStatus = (self:GetData("dry_status", false) and "Dry") or "Wet"

        local leavesCount = self:GetData("leavesCount", 1)

        local ProperName = (leavesCount > 1 and "leaves are ") or "leaf is "

        local panel = tooltip:AddRowAfter("name", "dry_status")
        panel:SetBackgroundColor( (self:GetData("dry_status") and Color(189, 195, 199)) or Color(41, 128, 185)  )
        panel:SetText("This "..ProperName..dryStatus)
        panel:SizeToContents()

        local CountPnl = tooltip:AddRowAfter("dry_status", "count")
        CountPnl:SetBackgroundColor(Color(39, 174, 96))
        CountPnl:SetText("Count: "..leavesCount)
        CountPnl:SizeToContents()  


    end

end