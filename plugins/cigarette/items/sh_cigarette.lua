
ITEM.name = "Cigarette"
ITEM.model = Model("models/unconid/props_pack/cigarette.mdl")
ITEM.description = "Cigarette with filter and filled tobacco."


ITEM.functions.light = {
    name = "Light up",
    icon = "icon16/asterisk_yellow.png",
    OnRun = function(itemTable)
        local client = itemTable.player
        local char = client:GetCharacter()
    	local inv = char:GetInventory()

    	if (inv:HasItem("lighter")) then

    		if (client:HasWeapon( "weapon_ciga" )) then
    			client:Notify("You already have a lit cigarette")
    			return false
    		end

    		client:Give("weapon_ciga")
    		client:SelectWeapon("weapon_ciga")
            -- client:ConCommand("say /me lights up a cigarette with a lighter.")
            ix.chat.Send(client, "me", "Lights up a cigarette with a lighter.")
    		client:EmitSound("ambient/fire/mtov_flame2.wav",50)

            char.HasCig = true

            timer.Create("ligcig_"..char:GetID(), 60, 0, function() 
                if (!client:Alive()) then return end
                if (client:GetCharacter():GetID() != char:GetID()) then return end

                if (client:HasWeapon( "weapon_ciga" )) then
                    client:StripWeapon( "weapon_ciga" )
                    ix.chat.Send(client, "me", "has stomped out the cigarette.")
                end

            end)

    		return true

    	end

    end,
    OnCanRun = function(itemTable)
    	local client = itemTable.player
    	local char = client:GetCharacter()
    	local inv = char:GetInventory()
    	return inv:HasItem("lighter")
    end
}