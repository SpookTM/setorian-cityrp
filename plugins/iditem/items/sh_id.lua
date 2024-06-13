local PLUGIN = PLUGIN

ITEM.name = "Identification Card"
ITEM.description = "A card that holds information about a person."
ITEM.model = "models/cmz/citizenid.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Identification"

ITEM.functions.Assign = { -- sorry, for name order.
	name = "Assign",
	icon = "icon16/add.png",
	OnRun = function(item)
		local client = item.player
		local char = client:GetCharacter()

		local idInfo = {
			name = client:Name(),
			charID = char:GetID(),
			sex = (client:IsFemale() and "Female") or "Male",
			eyeColor = char:GetEye_color(),
			hairColor = char:GetHair_color(),
			height = char:GetHeight().." ft",
			birth = char:GetDob(),
			weight = char:GetWeight(),
			model = client:GetModel(),
			headmodel = char:GetHeadmodel(),
		}
		
		item:SetData("idInfo", idInfo)
		
		return false
	end,
	OnCanRun = function(item)
		if (item:GetData("idInfo")) then
			return false
		end
		
		return true
	end
}

ITEM.functions.View = { -- sorry, for name order.
	name = "View",
	icon = "icon16/eye.png",
	OnRun = function(item)
		local client = item.player
		local idInfo = item:GetData("idInfo", {})

		if (idInfo.charID != client:GetCharacter():GetID()) then
			client:GetCharacter():Recognize(idInfo.charID)
		end
		
		netstream.Start(client, "ix_idOpen", idInfo)
		
		return false
	end,
	OnCanRun = function(item)
		if (!item:GetData("idInfo")) then
			return false
		end
		
		return true
	end
}

function ITEM:GetName()
	local itemName = self.name
	
	local idInfo = self:GetData("idInfo", {})
	
	local charName = idInfo.name
	if (charName) then
		itemName = charName.. "'s " ..itemName
	end

	return Format(itemName)
end