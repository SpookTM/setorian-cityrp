local PLUGIN = PLUGIN
ITEM.name = "Cards Base"
ITEM.model = "models/lostsignalproject/items/quest/keycard.mdl"
ITEM.material = "models/debug/debugwhite"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.description = ""
ITEM.longdesc = ""
ITEM.category = "Cards"
ITEM.isCard = true
ITEM.isFlipped = false

function ITEM:GetDescription()
    local quant = self:GetData("quantity", self.ammoAmount or self.quantity or 0)
    local quantdesc = ""
    local invdesc = ""

    -- if self.longdesc then
    --     invdesc = "\n\n" .. (self.longdesc)
    -- end

    -- if self.quantdesc then
    --     quantdesc = "\n\n" .. Format(self.quantdesc, quant)
    -- end

    if (self.entity) then
        return (self.description)
    else
        return (self.description .. quantdesc .. invdesc)
    end
end

function ITEM:GetName()

    if (IsValid(self.entity)) then

        local entPos = self.entity:GetPos()

        local trace = util.QuickTrace(entPos, self.entity:GetAngles():Up() * 10, self.entity)

        local ValidEnt = ((trace.Entity) and (trace.Entity != NULL))

        if (ValidEnt) then

            return "An unknown playing card"

        else

            return self.name

        end

    else

        return self.name

    end

end

if CLIENT then
    function ITEM:PaintOver(item, w, h)

        if (item.img) then

            surface.SetDrawColor(255,255,255)
            surface.SetMaterial( item.img )
            surface.DrawTexturedRect(0,0,w,h)

        end

    end

end


ITEM.functions.Flip = {
    name = "Flip the card",
    icon = "icon16/arrow_refresh.png",
    OnRun = function(itemTable)
        local client = itemTable.player
        local vStart = client:GetShootPos()
        local vForward = client:GetAimVector()
        local trace = {}
        trace.start = vStart
        trace.endpos = vStart + (vForward * 60)
        trace.filter = client
        local tr = util.TraceLine(trace)
        local ang = client:EyeAngles()
        local ActualAng = itemTable.entity:GetAngles()
        ang.yaw = ang.yaw + 180
        ang.roll = ActualAng.roll + 180
        ang.pitch = 0
        ix.chat.Send(itemTable.player, "me", "begins to flip his card, placing it down in front of him.", false)
        client:Notify("You have flipped the " .. itemTable.name .. " card.")
        --    ix.log.Add(client, "cardLog", "flipped their "..ITEM.name..".")  -- disabled for the time being

        local RandomSnds = {
            "physics/cardboard/cardboard_box_impact_soft2.wav",
            "physics/cardboard/cardboard_box_impact_soft4.wav",
            "physics/cardboard/cardboard_box_impact_soft7.wav"
        }

        local actualPos = itemTable.entity:GetPos()

        itemTable.entity:SetPos(Vector(actualPos.x, actualPos.y, actualPos.z + 2))
        itemTable.entity:SetAngles(ang)

        local phys = itemTable.entity:GetPhysicsObject()

        if phys:IsValid() then

            phys:Wake()

        end

        client:EmitSound(RandomSnds[ math.random( #RandomSnds ) ])

        -- ix.item.Instance(0, "cards_deck_cards", nil, 0, 0, function(item)
        --     item:Spawn(tr.HitPos, ang)

        --     item:SetData("cards", {
        --         [1] = itemTable.uniqueID
        --     })
        -- end)

        return false

    end,
    OnCanRun = function(itemTable)

        return IsValid(itemTable.entity) 

    end
}

ITEM.functions.combine = {
    OnCanRun = function(item, data)
        if not data then return false end
        local targetItem = ix.item.instances[data[1]]

        if targetItem.uniqueID == "cards_deck_cards" and PLUGIN:FindCards(item.player) then
            if #targetItem:GetData("cards", PLUGIN:FillDeckCards()) ~= 54 then
                return true
            else
                return false
            end
        end
    end,
    OnRun = function(item, data)
        local targetItem = ix.item.instances[data[1]]

        if not targetItem:GetData("cards") then
            targetItem:SetData("cards", PLUGIN:FillDeckCards())
        end

        local duplicateFound = false
        local cards = targetItem:GetData("cards")

        for k, v in pairs(cards) do
            if v == item.uniqueID then
                duplicateFound = true
                break
            end
        end

        if duplicateFound then
            item.player:Notify("You can not put the card in the deck as the same type already is in there!")

            return false
        end

        cards[#cards + 1] = item.uniqueID
        targetItem:SetData("cards", cards)
        item.player:EmitSound("stalkersound/inv_properties.mp3", 110)
    end,
}