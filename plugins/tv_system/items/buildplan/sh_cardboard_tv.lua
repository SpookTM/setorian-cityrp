
ITEM.name = "Box with TV"
ITEM.model = Model("models/physrbox/taped_big.mdl")
ITEM.description = "Box which contains a TV."
ITEM.category = technology
ITEM.width = 4
ITEM.height = 4
ITEM.noBusiness = true
ITEM.entityclass = "ent_tv"

function ITEM:OnDeploy(client, entity)
    local obb = entity:OBBMaxs()
    entity:SetPos(entity:GetPos() + Vector(0, 0, obb.z - 0.97))
    entity:SetOwnerID( client:GetCharacter():GetID() )
    
    -- Just a small notification for player.
    net.Start("ix.tv.OnDeploy")
    net.Send( client )

    local remote = ix.item.Get("remote")
    local inventory = client:GetCharacter():GetInventory();
    local data = {TVID = entity.tvID};
    
    if inventory:FindEmptySlot(remote.width, remote.height) then
        inventory:Add("remote", 1, data);
    else
        ix.item.Spawn("remote", client:GetPos(), nil, Angle(0, 0, 0), data);
        client:Notify("You can't fit the TV remote in your pocket so you lay it down on the floor.")
    end
end