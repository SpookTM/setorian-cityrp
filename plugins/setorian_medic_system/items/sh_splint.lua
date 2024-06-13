ITEM.name = "Splint"
ITEM.description = "Used to treat fractures"
ITEM.category = "Medical"
ITEM.model = "models/carlsmei/escapefromtarkov/medical/alusplint.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bDropOnDeath = true

ITEM.functions.healu = {
    name = "Heal yourself",
	tip = "Heal yourself",
	icon = "icon16/heart.png",
	OnRun = function(item)
        local client = item.player

        local char = client:GetCharacter()

        if (!client:Alive()) then return false end
        if (!client:GetNetVar("IsLegBroken")) then
        	client:Notify("Your leg isn't broken")
        	return false
        end

        client.IsHealYourself = true

        client:SetAction("Healing...", 5, function()
			
			client:SetNetVar("IsLegBroken", false)

			client:Notify("You've fixed your leg")

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
       
        if (!traceEnt:GetNetVar("IsLegBroken")) then
        	client:Notify("That person does not have a broken leg")
        	return false
        end

        if (client:GetPos():DistToSqr(traceEnt:GetPos()) > 65 * 65) then
        	client:Notify("You're standing too far away to do that")
        	return false
        end

        traceEnt:Notify(client:GetCharacter():GetName() .." is healing you")

        client:SetAction("Healing...", 5)

        client:DoStaredAction(traceEnt, function()
			
        	traceEnt:SetNetVar("IsLegBroken", false)

        	PLUGIN:RemoveShootInLeg(traceEnt)

			client:Notify("You fixed that person's leg")
			traceEnt:Notify("Your leg has been fixed")

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