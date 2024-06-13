ITEM.name = "Smartphone"
ITEM.description = "A smartphone is a wireless handheld device that allows users to make and receive calls.."
ITEM.model = "models/akulla/aphone/w_aphone.mdl"
ITEM.class = "aphone"
ITEM.weaponCategory = "phone"

ITEM.width = 1
ITEM.height = 1
ITEM.category = "Tools"
ITEM.bDropOnDeath = false

ITEM.functions.CopyNumber = {
    name = "Copy Number",
    icon = "icon16/phone.png",
    OnRun = function(item)
        local player = item.player

        if SERVER then
            net.Start("OpenPhoneNumberCopyPanel")
            net.WriteString(player:aphone_GetNumber() or "")
            net.Send(player)
        end

        return false
    end,
    OnCanRun = function(item)
        local player = item.player
        return IsValid(player) and player:aphone_GetNumber() ~= nil
    end
}

