ITEM.name = "Useable Items"
ITEM.description = "Ok this is kinda in by default, but why not make it a meta method so it doesn't have to be added INDIVIDUALLY"
ITEM.category = "Useable"
ITEM.model = "models/player/skeleton.mdl"

ITEM.functions.UseOnEnt = {
	name = "Use on target",
	OnCanRun = function(itemTable)
		return true
	end,
	OnRun = function(itemTable)
		local client = itemTable.player

		local tTrace = util.TraceLine({
			start = client:GetShootPos(),
			endpos = client:GetShootPos() + client:GetAimVector() * 100,
			filter = client
		})

		local eEnt = tTrace.Entity
		if (eEnt == nil) then
			return false
		end
		
		if (eEnt.OnItemUse) then
			eEnt:OnItemUse(itemTable, itemTable.uniqueID)
		end

		return true
	end
}