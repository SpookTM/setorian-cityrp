ITEM.name = "Stitches"
ITEM.description = "Used to stitch wounds"
ITEM.category = "Medical"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bDropOnDeath = true

ITEM.functions.healu = {
    name = "Heal yourself",
	tip = "Heal yourself",
	icon = "icon16/heart_add.png",
	OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        if (!client:Alive()) then return false end
        if (!client:GetNetVar("IsBleeding")) then
        	client:Notify("You're not bleeding")
        	return false
        end

        client.IsHealYourself = true

        client:SetAction("Healing...", 5, function()
			
			client:SetNetVar("IsBleeding", false)

			client:Notify("You stopped the bleeding")

			if (timer.Exists( "BleedingThink_"..char:GetID() )) then
				timer.Remove( "BleedingThink_"..char:GetID() )
			end

			client:EmitSound("physics/cardboard/cardboard_box_strain"..math.random(1,3)..".wav", 65)

			item:Remove()

		end)

        return false
    end,
    OnCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

local PLUGIN = PLUGIN

ITEM.functions.heal = {
    name = "Heal",
	tip = "Heal",
	icon = "icon16/heart.png",
	OnRun = function(item)
        local client = item.player

        if (!client:Alive()) then return false end

        local trace = client:GetEyeTrace()

        local traceEnt = trace.Entity

        if (!traceEnt:IsPlayer()) then return false end
        if (!traceEnt:Alive()) then return false end

        local char = traceEnt:GetCharacter()
       
        if (!traceEnt:GetNetVar("IsBleeding")) then
        	client:Notify("That person is not bleeding")
        	return false
        end

        if (client:GetPos():DistToSqr(traceEnt:GetPos()) > 65 * 65) then
        	client:Notify("You're standing too far away to do that")
        	return false
        end

        traceEnt:Notify(client:GetCharacter():GetName() .." is healing you")

        client:SetAction("Healing...", 5)

        client:DoStaredAction(traceEnt, function()
			
        	traceEnt:SetNetVar("IsBleeding", false)

        	PLUGIN:RemoveShootInLeg(traceEnt)

			client:Notify("You stopped the bleeding")
			traceEnt:Notify("Bleeding has been stopped")

			traceEnt.NextUnCon = 0

			if (timer.Exists( "BleedingThink_"..char:GetID() )) then
				timer.Remove( "BleedingThink_"..char:GetID() )
			end

			traceEnt:EmitSound("physics/cardboard/cardboard_box_strain"..math.random(1,3)..".wav", 65)

			item:Remove()

		end, 5, function()
			client:SetAction()
		end)


        return false
    end,
    OnCanRun = function(item)
		return (!IsValid(item.entity))
	end
}