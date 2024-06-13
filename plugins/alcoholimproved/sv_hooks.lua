local PLUGIN = PLUGIN or {}

function PLUGIN:PlayerDeath(client)
    client:RemoveDrunkEffect()
end

function PLUGIN:Think()
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetCharacter() != nil and CurTime() >= ply:GetCharacter():GetDrunkEffectTime() and ply:GetCharacter():GetDrunkEffect() > 0 then
            ply:RemoveDrunkEffect()
        end
    end
end



