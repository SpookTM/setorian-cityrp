ITEM.name = "Drill"
ITEM.description = "Special set with large drill bit for opening safes."
ITEM.model = Model("models/props_junk/cardboard_box003a.mdl")
ITEM.price = 1000

local PLUGIN = PLUGIN

ITEM.functions.Use = {
	OnRun = function(item)
        local client = item.player

        if (!client:Alive()) then return false end

        if (client:GetCharacter():GetFaction() == PLUGIN.PoliceFaction) then
			client:Notify("You can't rob as a police officer")
			return false
		end

        local tr = client:GetEyeTrace()
        local trEnt = tr.Entity

        if (!PLUGIN:EnoughPolice()) then
			client:Notify("Not enough police officers")
			return false
		end

		if (trEnt:GetCooldown() > 0) then
			client:Notify("You have to wait before you can rob it again")
			return false
		end

        if (trEnt:GetClass() == "j_banking_safe") then

        	if (client:GetPos():DistToSqr(trEnt:GetPos()) < 5000) then

        		client:SetAction("Mounting...", 1) -- for displaying the progress bar
				client:DoStaredAction(trEnt, function()
					trEnt:EmitSound("ambient/machines/pneumatic_drill_"..math.random(1,4)..".wav", 60)

					trEnt:StartDrilling()
						
					item:Remove()

				end, 1, function()
					client:SetAction()
				end)

        	else
        		client:Notify("You're too far away to do that")
        	end

        else
        	client:Notify("Invalid entity")
        end


        return false
    end,
    OnCanRun = function(item)
		return (!IsValid(item.entity))
	end
}
