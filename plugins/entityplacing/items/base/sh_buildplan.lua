ITEM.name = "Construction Plan"
ITEM.description = "A basic construction plan."
ITEM.category = "Deployables"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Deploy = {
	OnCanRun = function(itemTable)
		local client = itemTable.player
		return !client:GetLocalVar("furniture", false) or false
	end,
	OnRun = function(itemTable)
		local client = itemTable.player

		if itemTable.entityclass then
			client:SetLocalVar("furniture", {
				item_entity = itemTable.entity or nil,
				item = itemTable.uniqueID,
				model = itemTable.model,
				class = itemTable.entityclass
			})
		else
			client:SetLocalVar("furniture", {
				item = itemTable.uniqueID,
				model = itemTable.model
			})
		end

		client:Give("ix_building")
		client:SelectWeapon("ix_building")

		return false
	end
}

function ITEM:OnDeploy(client, entity) -- Function to do stuff when you've successfully placed the object using the Construction SWEP
end