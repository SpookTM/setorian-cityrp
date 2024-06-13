local meta = FindMetaTable("Player")

function meta:isPolice()

    if (!self:GetCharacter()) then return false end

    local policeJobs = {
        [FACTION_POLICE] = true,
        [FACTION_FBI] = true,
        [FACTION_SWAT] = true,
    }

    return policeJobs[self:GetCharacter():GetFaction()]

end

function meta:isWanted()
	if (!self:GetCharacter()) then return end
    return self:GetCharacter():GetWanted() != "none"
end

function meta:getWantedReason()
	if (!self:GetCharacter()) then return end
    return self:GetCharacter():GetWanted()
end

function meta:wanted(wReason)
	if (!self:GetCharacter()) then return end
	self:GetCharacter():SetWanted(wReason or "none")
end

function meta:canAfford(price)
	if (!self:GetCharacter()) then return false end
    return self:GetCharacter():GetMoney() >= tonumber(price)
end


if (SERVER) then

	function meta:addMoney(amount)
		if (!self:GetCharacter()) then return false end
		self:GetCharacter():SetMoney(math.max(self:GetCharacter():GetMoney() + amount, 0))
	end

end

function meta:getEyeSightHitEntity(searchDistance, hitDistance, filter)
    searchDistance = searchDistance or 100
    hitDistance = (hitDistance or 15) * (hitDistance or 15)

    filter = filter or function(p) return p:IsPlayer() and p ~= self end

    self:LagCompensation(true)

    local shootPos = self:GetShootPos()
    local entities = ents.FindInSphere(shootPos, searchDistance)
    local aimvec = self:GetAimVector()

    local smallestDistance = math.huge
    local foundEnt

    for _, ent in pairs(entities) do
        if not IsValid(ent) or filter(ent) == false then continue end

        local center = ent:GetPos()

        -- project the center vector on the aim vector
        local projected = shootPos + (center - shootPos):Dot(aimvec) * aimvec

        if aimvec:Dot((projected - shootPos):GetNormalized()) < 0 then continue end

        -- the point on the model that has the smallest distance to your line of sight
        local nearestPoint = ent:NearestPoint(projected)
        local distance = nearestPoint:DistToSqr(projected)

        if distance < smallestDistance then
            local trace = {
                start = self:GetShootPos(),
                endpos = nearestPoint,
                filter = {self, ent}
            }
            local traceLine = util.TraceLine(trace)
            if traceLine.Hit then continue end

            smallestDistance = distance
            foundEnt = ent
        end
    end

    self:LagCompensation(false)

    if smallestDistance < hitDistance then
        return foundEnt, math.sqrt(smallestDistance)
    end

    return nil
end