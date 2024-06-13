ITEM.name = "Alcohol Base"
ITEM.description = ""
ITEM.category = "Alcohol"
ITEM.model = "models/props_junk/GlassBottle01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.effectAmount = 0.2
ITEM.effectTime = 1
ITEM.returnItems = {}

ITEM.functions.Use = {
	name = "Drink",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()

		if istable(item.returnItems) then
			for _, v in ipairs(item.returnItems) do
				character:GetInventory():Add(v)
			end
		else
			character:GetInventory():Add(item.returnItems)
		end

		client:AddDrunkEffect(item.effectAmount, item.effectTime)
	end,
}