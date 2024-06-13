local playerMeta = FindMetaTable("Player")

function playerMeta:RemoveDrunkEffect()
    local character = self:GetCharacter()

    character:SetDrunkEffect(0)
    character:SetDrunkEffectTime(0)
end

function playerMeta:AddDrunkEffect(amount, duration)
    local character = self:GetCharacter()

    character:SetDrunkEffect(character:GetDrunkEffect() + amount)
    character:SetDrunkEffectTime(CurTime() + (character:GetDrunkEffectTime() + duration))

    if ix.config.Get("enableAlcoholFallover") and character:GetDrunkEffect() >= ix.config.Get("alcoholFallover") then
        self:SetRagdolled(true, 30)
        self:RemoveDrunkEffect()
    end
end
