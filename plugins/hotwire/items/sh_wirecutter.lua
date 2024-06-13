local PLUGIN = PLUGIN

ITEM.name = "Wire Cutter"
ITEM.description = "Pliers designed for cutting wire with their jaws."
ITEM.model = "models/props_c17/tools_wrench01a.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Cut = {
    name = "Cut",
    tip = "useTip",
    icon = "icon16/cut.png",
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

    end,

    OnRun = function(item)
        local client = item.player

        if (!client:InVehicle()) then
        	client:Notify("You are not in a vehicle")
        	return false
        end

		if (client:GetVehicle():IsEngineStarted()) then
			client:Notify("You are not in a vehicle")
        	return false
		end
		
		client:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")
		net.Start("HotWire_OpenUI")
		net.Send(client)

        return false

    end
}