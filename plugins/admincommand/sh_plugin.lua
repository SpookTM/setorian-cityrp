local PLUGIN = PLUGIN

PLUGIN.name = "placeholder name"
PLUGIN.author = "KINGXIII"
PLUGIN.description = "ezaezaea"

ix.util.Include("sv_plugin.lua")


-- Client-side
local showAdmin = false
local message = ""

net.Receive("ShowAdmin", function()
showAdmin = true
message = net.ReadString()
endTime = CurTime() + 6 -- Afficher le HUDPaint pendant 6 secondes
end)

hook.Add("HUDPaint", "ShowAdmin", function()
            local color = Color(250, math.abs(math.cos(RealTime() * 2) * 120), math.abs(math.cos(RealTime() * 2) * 120))
    if (showAdmin and CurTime() < endTime) then
        surface.SetDrawColor(20, 0, 20, 200)
        surface.DrawRect(ScrW() / 2 - 145, 5, 290, 60)


        ix.util.DrawText("Z", "ixMenuMiniFont", ScrW() / 2 - 80, 44, color)
        ix.util.DrawText("Z", "ixMenuMiniFont", ScrW() / 2 + 80, 44, color)
        ix.util.DrawText(message, "ixMediumFont", ScrW() / 2, 21, Color(250, 250, 250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        ix.util.DrawText("Z", ScrW() / 2 + 135, 44, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, nil, nil, nil, nil, "ixIconsMedium")
    else
        showAdmin = false
    end
end)



if (SERVER) then
    util.AddNetworkString("ShowAdmin")

    ix.command.Add("testlol", {
        description = "blablabla",
        adminOnly = true,
        arguments = ix.type.text,
        OnRun = function(self, client, message)
            net.Start("ShowAdmin")
            net.WriteString(message)
            net.Send(client)
            -- Ajoutez votre logique de commande ici si nécessaire
        end
    })
end


-- ix.command.Add("testlol", {
-- description = "Afficher un message pour les administrateurs",
-- adminOnly = true,
-- arguments = ix.type.text,
-- OnRun = function(self, client, message)
-- hook.Add("HUDPaint", "ShowAdmin", function()
-- surface.SetDrawColor(20,00,20, 200)
-- surface.DrawRect(ScrW()/2-(290/2),5,290,60)


--         ix.util.DrawText("Z", "ixIconsMedium", ScrW()/2 - 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)))
--         ix.util.DrawText("Z", "ixIconsMedium", ScrW()/2 + 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)))
--         draw.SimpleText(message, "ixMenuMiniFont", ScrW()/2, 21, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
--     end)
-- end
-- })


-- ix.command.Add("Test", {
--     description = "Test command",
--     adminOnly = true,
--     OnRun = function(self, client)
-- surface.SetDrawColor(255,255,255)
-- surface.DrawRect(ScrW()/2-(290/2),5,290,60)


--         ix.util.DrawText("Z", "ixIconsMedium", ScrW()/2 - 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)))
--         ix.util.DrawText("Z", "ixIconsMedium", ScrW()/2 + 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)))
--         draw.SimpleText(message, "ixMenuMiniFont", ScrW()/2, 21, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
--         timer.Simple(5, function()
--             hook.Remove("HUDPaint", "Test")
--         end)
--     end
-- })