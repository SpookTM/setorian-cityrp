
ITEM.name = "Bismuth"
ITEM.model = Model("models/winningrook/gtav/meth/hcacid/hcacid.mdl")
ITEM.description = "A heavy brittle grayish white chiefly trivalent metallic element that is chemically like arsenic and antimony and that is used in alloys and pharmaceuticals."
ITEM.category = "Meth"
ITEM.width = 1 
ITEM.height = 1
ITEM.MethIngredient = true
ITEM.bDropOnDeath = true
if (CLIENT) then

    function ITEM:PopulateTooltip(tooltip)

        local capacity = self:GetData("capacity", 20)

        local panel = tooltip:AddRowAfter("name", "capacity")
        panel:SetBackgroundColor(Color(230, 126, 34))
        panel:SetText("Capacity: "..capacity.."/20")
        panel:SizeToContents()
         
    end

end

ITEM.functions.AddtoPot = {
    name = "Add to the pot",
    tip = "useTip",
    icon = "icon16/add.png",
    isMulti = true,
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

    	local ply = item.player
        local char = ply:GetCharacter()
        local inventory = char:GetInventory()

        local hasPot = inventory:HasItem("meth_pot")

        if (hasPot) then
        	return true
        else
        	return false
        end

    end,
    multiOptions = function(item, client)
        local targets = {}

        local capacity = item:GetData("capacity", 20)

        local optionsNumber = 10

        if (capacity < optionsNumber) then
            optionsNumber = capacity
        end

        for i=1, optionsNumber do
        	table.insert(targets, {
                name = "Add "..i.." percentage",
                data = {i},
            })
        end
            
        return targets
    end,
    OnRun = function(item, data)
        if not data[1] then return false end
        local target = data[1]

        local ply = item.player
        local char = ply:GetCharacter()

        if (char) then

            local inventory = char:GetInventory()

            local hasPot = inventory:HasItem("meth_pot")

            if (hasPot) then 
                
                if (target > item:GetData("capacity", 20)) then
                    return false
                end
                
                hasPot:SetData(item.uniqueID, hasPot:GetData(item.uniqueID, 0) + target)
                item:SetData("capacity", item:GetData("capacity", 20) - target)

                ply:Notify("You've added "..item:GetName().." to the pot")
                ply:EmitSound("ambient/water/water_spray1.wav")

                if (item:GetData("capacity", 0) <= 0) then
                    return true
                end

            end

        end

        return false

    end
}