ITEM.name = "Bandage"
ITEM.description = "Used for wound care"
ITEM.category = "Medical"
ITEM.model = "models/carlsmei/escapefromtarkov/medical/bandage.mdl"
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

        if (client:Health() == client:GetMaxHealth()) then
        	client:Notify("You are fully healthy")
        	return false
        end

        client.IsHealYourself = true

        client:SetAction("Healing...", 3, function()

        	local healedHP = math.min(client:Health() + math.random(15,25), client:GetMaxHealth())

			client:SetHealth( healedHP )

			client:Notify("You bandaged yourself")

			ix.log.Add(client, "PlyHealedSelf", healedHP)

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
       
        if (traceEnt:Health() == traceEnt:GetMaxHealth()) then
        	client:Notify("That person is fully healthy")
        	return false
        end

        if (client:GetPos():DistToSqr(traceEnt:GetPos()) > 65 * 65) then
        	client:Notify("You're standing too far away to do that")
        	return false
        end

        traceEnt:Notify(client:GetCharacter():GetName() .." is healing you")

        client:SetAction("Healing...", 3)

        client:DoStaredAction(traceEnt, function()
				
			local healedHP = math.min(traceEnt:Health() + math.random(15,25), traceEnt:GetMaxHealth())

        	traceEnt:SetHealth( healedHP )

			client:Notify("You bandaged this person")
			traceEnt:Notify("Your wounds have been bandaged")

			ix.log.Add(client, "PlyHealed",traceEnt,healedHP)

			traceEnt.NextUnCon = 0

			PLUGIN:RemoveShootInLeg(traceEnt)

			traceEnt:EmitSound("physics/cardboard/cardboard_box_strain"..math.random(1,3)..".wav", 65)

			item:Remove()

		end, 3, function()
			client:SetAction()
		end)


        return false
    end,
    OnCanRun = function(item)
		return (!IsValid(item.entity))
	end
}