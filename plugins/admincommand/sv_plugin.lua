local PLUGIN = PLUGIN

ix.command.Add("testlol", {
description = "Afficher un message pour les administrateurs",
adminOnly = true,
arguments = ix.type.text,
OnRun = function(self, client, message)
hook.Add("HUDPaint", "ShowAdmin", function()
surface.SetDrawColor(20,00,20, 200)
surface.DrawRect(ScrW()/2-(290/2),5,290,60)


        ix.util.DrawText("Z", "ixIconsMedium", ScrW()/2 - 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)))
        ix.util.DrawText("Z", "ixIconsMedium", ScrW()/2 + 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)))
        draw.SimpleText(message, "ixMenuMiniFont", ScrW()/2, 21, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)
end
})


ix.command.Add("Test", {
    description = "Test command",
    adminOnly = true,
    OnRun = function(self, client)
surface.SetDrawColor(20,00,20, 200)
surface.DrawRect(ScrW()/2-(290/2),5,290,60)


        ix.util.DrawText("Z", "ixIconsMedium", ScrW()/2 - 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)))
        ix.util.DrawText("Z", "ixIconsMedium", ScrW()/2 + 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)))
        draw.SimpleText(message, "ixMenuMiniFont", ScrW()/2, 21, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        timer.Simple(5, function()
            hook.Remove("HUDPaint", "Test")
        end)
    end
})