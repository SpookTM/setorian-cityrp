
ITEM.name = "Cigar"
ITEM.model = Model("models/jellik/cigar.mdl")
ITEM.description = "Cigar with filter and filled tobacco."


ITEM.functions.light = {
    name = "Light up",
    icon = "icon16/asterisk_yellow.png",
    OnRun = function(itemTable)
        local client = itemTable.player
        local char = client:GetCharacter()
    	local inv = char:GetInventory()

    	if (inv:HasItem("lighter")) then

    		if (client:HasWeapon( "weapon_cigar" )) then
    			client:Notify("You already have a lit cigar")
    			return false
    		end

    		client:Give("weapon_cigar")
    		client:SelectWeapon("weapon_cigar")
            -- client:ConCommand("say /me lights up a cigarette with a lighter.")
            ix.chat.Send(client, "me", "lights up a cigar with a lighter.")
    		client:EmitSound("ambient/fire/mtov_flame2.wav",50)

            char.HasCig = true

            timer.Create("ligcig_"..char:GetID(), 60, 0, function() 
                if (!client:Alive()) then return end
                if (client:GetCharacter():GetID() != char:GetID()) then return end

                if (client:HasWeapon( "weapon_cigar" )) then
                    client:StripWeapon( "weapon_cigar" )
                    ix.chat.Send(client, "me", "has stomped out the cigar.")
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