
local Version = "1.1.0"
--[[
    If you plan on modifying any files, I suggest changing the version to:
    "modified_{version}"
    This will prevent it saying you are loading an outdated version if that annoys you
]]

paris = paris or {}

paris.APILink = "http://parisiscool.com/paris/api"

paris.GTAHudVersion = Version

if SERVER then

    function paris:HUDPrintMessage(string)
        MsgC(Color(99, 211, 255), "[GTA HUD Server] ", Color(233, 233, 233), string .. "\n")
    end

    function paris:HUDPrintPrefix()
        MsgC(Color(99, 211, 255), "[GTA HUD Server] ", Color(233, 233, 233))
    end

    paris:HUDPrintMessage("Loading Version " .. Version .. ".")

    hook.Add("PlayerConnect", "GTAHudLatestNotifier", function()

        if paris.GTAInitialized then return end
        paris.GTAInitialized = true

        http.Fetch( paris.APILink.."/latestversions.json", function( raw )
    
            versions = util.JSONToTable( raw ) or {}
    
            if !versions["gtahud"] then
                paris:HUDPrintMessage("A big oopsies occured trying to find latest version!")
            else
                if Version == versions["gtahud"] then
                    paris:HUDPrintMessage("This is the latest release version!")
                elseif string.StartWith(Version, "dev") then
                    paris:HUDPrintMessage("You are loading a development build!")
                elseif string.StartWith(Version, "testers") then
                    paris:HUDPrintMessage("You are loading a testers build!")
                elseif string.StartWith(Version, "prerelease") then
                    paris:HUDPrintMessage("You are loading a prerelease build!")
                elseif string.StartWith(Version, "modified") then
                    paris:HUDPrintMessage("You are loading a modified version!")
                else
                    paris:HUDPrintMessage("You are loading an outdated version!")
                    paris:HUDPrintMessage("Consider upgrading to the latest version!")
                end
            end
            
        end )
    end )
    
    ------------------------
    --[[    SHARED    ]]
    ------------------------

    include("gtahud/shared/sh_defaultoptions.lua")
    AddCSLuaFile("gtahud/shared/sh_defaultoptions.lua")

    ------------------------
    --[[    SERVERSIDE    ]]
    ------------------------

    include("gtahud/server/sv_load.lua")
    include("gtahud/server/sv_gtahud.lua")

    ------------------------
    --[[    CLIENTSIDE    ]]
    ------------------------

    AddCSLuaFile("gtahud/client/pbool.lua")
    AddCSLuaFile("gtahud/client/pbutton.lua")
    AddCSLuaFile("gtahud/client/pframe.lua")
    AddCSLuaFile("gtahud/client/pscrollpanel.lua")
    AddCSLuaFile("gtahud/client/cl_nicelibs.lua")
    AddCSLuaFile("gtahud/client/cl_options.lua")
    AddCSLuaFile("gtahud/client/cl_blipeditor.lua")
    AddCSLuaFile("gtahud/client/cl_blipremover.lua")
    -- AddCSLuaFile("gtahud/client/cl_chat.lua")
    AddCSLuaFile("gtahud/client/cl_hud.lua")

    AddCSLuaFile("gtahud/client/hudmaps/" .. game.GetMap() .. ".lua")

elseif CLIENT then

    --------------------------------
    --[[    CLIENTSIDE LOADING    ]]
    --------------------------------

    function paris:HUDPrintMessage(string)
        MsgC(Color(174, 99, 255), "[GTA HUD Client] ", Color(233, 233, 233), string .. "\n")
    end

    function paris:HUDPrintPrefix()
        MsgC(Color(174, 99, 255), "[GTA HUD Client] ", Color(233, 233, 233))
    end

    paris:HUDPrintMessage("Loading Version " .. Version .. ".")

    include("gtahud/shared/sh_defaultoptions.lua")

    include("gtahud/client/pbool.lua")
    include("gtahud/client/pbutton.lua")
    include("gtahud/client/pframe.lua")
    include("gtahud/client/pscrollpanel.lua")
    include("gtahud/client/cl_nicelibs.lua")
    include("gtahud/client/cl_options.lua")
    include("gtahud/client/cl_blipeditor.lua")
    include("gtahud/client/cl_blipremover.lua")
    -- include("gtahud/client/cl_chat.lua")
    include("gtahud/client/cl_hud.lua")

end