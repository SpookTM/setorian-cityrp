local PLUGIN = PLUGIN
PLUGIN.name = "APhone extra functions"
PLUGIN.desc = "Adds extra functions"
PLUGIN.author = "spook"

if SERVER then
    util.AddNetworkString("OpenPhoneNumberCopyPanel")
end

if CLIENT then
    net.Receive("OpenPhoneNumberCopyPanel", function()
        local phoneNumber = net.ReadString()

        if phoneNumber and phoneNumber ~= "" then
            local frame = vgui.Create("DFrame")
            frame:SetTitle("Phone Number")
            frame:SetSize(300, 100)
            frame:Center()
            frame:MakePopup()

            local textEntry = vgui.Create("DTextEntry", frame)
            textEntry:SetSize(280, 30)
            textEntry:SetPos(10, 35)
            textEntry:SetText(phoneNumber)
            textEntry:SelectAllOnFocus()
        end
    end)
end
