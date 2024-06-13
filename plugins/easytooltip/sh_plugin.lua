local PLUGIN = PLUGIN
PLUGIN.name = ""
PLUGIN.author = "ezaeazea"
PLUGIN.desc = "azeazeaeaea"

local AutomaticMeConfig = {
    enabled = true, 
    items = {
        ["pickaxe"] = "ezaeazeaeaa.",
        ["arccw_go_ak47"] = "ezaezaa.",
        ["clothingstore_beige_open_suit"] = "Automat",
    },
    entities = {
        ["npc_combine_s"] = "ezaezaea",
    },
    vehicles = {
        ["prop_vehicle_jeep"] = {
            enter = "enters a vehicle.",
            leave = "leaves the vehicle."
        },
    }
}


local function HandleAutomaticMe(ply, itemClass)
    if not AutomaticMeConfig.enabled then return end

    local message = AutomaticMeConfig.items[itemClass]

    if message then
        -- Send the /me
        ix.chat.Send(ply, "me", message)
    end
end



hook.Add("PlayerSay", "AutomaticMe_PlayerSay", function(ply, text)
    local trace = ply:GetEyeTrace()

    if IsValid(trace.Entity) then
        HandleAutomaticMe(ply, trace.Entity:GetClass())
    end
end)


hook.Add("PlayerEnteredVehicle", "AutomaticMe_PlayerEnteredVehicle", function(ply, vehicle)
    local vehicleClass = vehicle:GetClass()
    local enterMessage = AutomaticMeConfig.vehicles[vehicleClass] and AutomaticMeConfig.vehicles[vehicleClass].enter

    if enterMessage then

        ix.chat.Send(ply, "me", enterMessage)
    end
end)

hook.Add("PlayerLeaveVehicle", "AutomaticMe_PlayerLeaveVehicle", function(ply, vehicle)
    local vehicleClass = vehicle:GetClass()
    local leaveMessage = AutomaticMeConfig.vehicles[vehicleClass] and AutomaticMeConfig.vehicles[vehicleClass].leave

    if leaveMessage then

        ix.chat.Send(ply, "me", leaveMessage)
    end
end)