PLUGIN.name = "Workshop Downloader"
PLUGIN.author = "JohnyReaper"
local PLUGIN = PLUGIN

if (CLIENT) then

    IsDownloadingWorkshop = false
    PLUGIN.DownloadedAddons = {}
    PLUGIN.AddonsToDownload = {}
    PLUGIN.AddonsCount = 0

    function PLUGIN:checkWorkshop()
        http.Fetch("https://steamcommunity.com/sharedfiles/filedetails/?id=2955100960", function(sBody)
            local sPattern = "sharedfile_(%d+)"

            for sID in string.gmatch(sBody, sPattern) do
                self.DownloadedAddons[sID] = steamworks.IsSubscribed(sID)
                if (steamworks.IsSubscribed(sID)) then continue end

                self.AddonsToDownload[sID] = true

                -- steamworks.DownloadUGC(sID, function(sPath)
                --     if (sPath == nil) then return end
                --     game.MountGMA(sPath)
                -- end)
            end

            self.AddonsCount = table.Count(self.AddonsToDownload)

            if (self.AddonsCount > 0) then
                IsDownloadingWorkshop = true
                self:DownloadMissing()
            end

        end)
    end

    local function SWS()

        surface.SetDrawColor(20,00,20, 200)
        surface.DrawRect(ScrW()-260,5,255,60)

        ix.util.DrawText("T", ScrW()-125, 20, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, "ixIconsMedium")
        ix.util.DrawText("Some addons are still downloading", ScrW()-10, 45, Color(250,250,250), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, "ixMenuMiniFont")


    end

    local function DrawHUD()
        localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
        if not IsValid(localplayer) then return end

        if (IsDownloadingWorkshop) then
            SWS()
        end
    end

    function PLUGIN:CheckDownloadStatus()

        if (self.AddonsCount <= 0) then
            IsDownloadingWorkshop = false
            hook.Remove("PostDrawHUD", "Setorian_WorkshopStatus")
        end

    end

    function PLUGIN:DownloadMissing()

        hook.Add("PostDrawHUD", "Setorian_WorkshopStatus", DrawHUD)

        for sID, _ in pairs(self.AddonsToDownload) do

            steamworks.DownloadUGC(sID, function(sPath)

                self.AddonsCount = self.AddonsCount - 1
                self:CheckDownloadStatus()

                if (sPath == nil) then return end
                game.MountGMA(sPath)
            end)
            
        end

    end

    net.Receive( "WorkshopDownloader_Start", function( len, client )

        if (!IsDownloadingWorkshop) then
            PLUGIN:checkWorkshop()
        end

    end)

end

if (SERVER) then

    util.AddNetworkString("WorkshopDownloader_Start")

    function PLUGIN:PlayerInitialSpawn(ply)
        timer.Simple(10, function()
            if (!IsValid(ply)) then return end
            net.Start("WorkshopDownloader_Start")
            net.Send(ply)
        end)
    end

end