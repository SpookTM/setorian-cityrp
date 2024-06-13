ITEM.name = "Sleeping Bag"
ITEM.model = Model("models/props_junk/garbage_carboard002a.mdl")
ITEM.description = "A portable sleeping bag."
ITEM.category = "Deployables"
ITEM.price = 0
ITEM.entityclass = "ix_sleepingbag"

function ITEM:OnDeploy(client, entity)
	entity:SetNetVar("bedowner", client:GetCharacter():GetID())
end