PLUGIN.name = "DarkRP compatibility"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = "Adds DarkRP compatibility"

DarkRP = DarkRP or {}
RPExtraTeams = RPExtraTeams or {}

for k, v in ipairs(ix.faction.indices) do
	RPExtraTeams[k] = v
	RPExtraTeams[k].team = k
end

local plyMeta = FindMetaTable("Player")
local entMeta = FindMetaTable("Entity")

if (SERVER) then

	function DarkRP.isEmpty(vector, ignore)
	    ignore = ignore or {}

	    local point = util.PointContents(vector)
	    local a = point ~= CONTENTS_SOLID
	        and point ~= CONTENTS_MOVEABLE
	        and point ~= CONTENTS_LADDER
	        and point ~= CONTENTS_PLAYERCLIP
	        and point ~= CONTENTS_MONSTERCLIP
	    if not a then return false end

	    local b = true

	    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
	        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not table.HasValue(ignore, v) then
	            b = false
	            break
	        end
	    end

	    return a and b
	end

	function DarkRP.findEmptyPos(pos, ignore, distance, step, area)
	    if DarkRP.isEmpty(pos, ignore) and DarkRP.isEmpty(pos + area, ignore) then
	        return pos
	    end

	    for j = step, distance, step do
	        for i = -1, 1, 2 do -- alternate in direction
	            local k = j * i

	            -- Look North/South
	            if DarkRP.isEmpty(pos + Vector(k, 0, 0), ignore) and DarkRP.isEmpty(pos + Vector(k, 0, 0) + area, ignore) then
	                return pos + Vector(k, 0, 0)
	            end

	            -- Look East/West
	            if DarkRP.isEmpty(pos + Vector(0, k, 0), ignore) and DarkRP.isEmpty(pos + Vector(0, k, 0) + area, ignore) then
	                return pos + Vector(0, k, 0)
	            end

	            -- Look Up/Down
	            if DarkRP.isEmpty(pos + Vector(0, 0, k), ignore) and DarkRP.isEmpty(pos + Vector(0, 0, k) + area, ignore) then
	                return pos + Vector(0, 0, k)
	            end
	        end
	    end

	    return pos
	end

	function DarkRP.notify(pPlayer, msgtype, time, msg)
		pPlayer:Notify(msg)
	end

	function plyMeta:addMoney(amount)

		local char = self:GetCharacter()

		if (char) then
			char:SetMoney(char:GetMoney() + amount)
		end

	end

	function PLUGIN:PlayerUse(client, ent)

		if (ent:IsVehicle()) then
			if (ent:isLocked()) then

				if ((ent.NextLockSound or 0) < CurTime()) then
					ent:EmitSound("doors/latchlocked2.wav")
					ent.NextLockSound = CurTime() + 1
				end

			end
		end

	end

	-- function PLUGIN:PlayerSpawnedVehicle(client, entity)
	-- 	-- entity:SetNetVar("ownerName", client:GetCharacter():GetName())
	-- 	entity:keysOwn(client)

	-- 	if (simfphys) and (simfphys.IsCar(entity)) then
	-- 		entity:SetNetVar("simf_veh_class",entity.VehicleName)
	-- 	end

	-- end

end

if CLIENT then

	local function charWrap(text, remainingWidth, maxWidth)
	    local totalWidth = 0

	    text = text:gsub(".", function(char)
	        totalWidth = totalWidth + surface.GetTextSize(char)

	        -- Wrap around when the max width is reached
	        if totalWidth >= remainingWidth then
	            -- totalWidth needs to include the character width because it's inserted in a new line
	            totalWidth = surface.GetTextSize(char)
	            remainingWidth = maxWidth
	            return "\n" .. char
	        end

	        return char
	    end)

	    return text, totalWidth
	end

	function DarkRP.textWrap(text, font, maxWidth)
	    local totalWidth = 0

	    surface.SetFont(font)

	    local spaceWidth = surface.GetTextSize(' ')
	    text = text:gsub("(%s?[%S]+)", function(word)
	            local char = string.sub(word, 1, 1)
	            if char == "\n" or char == "\t" then
	                totalWidth = 0
	            end

	            local wordlen = surface.GetTextSize(word)
	            totalWidth = totalWidth + wordlen

	            -- Wrap around when the max width is reached
	            if wordlen >= maxWidth then -- Split the word if the word is too big
	                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
	                totalWidth = splitPoint
	                return splitWord
	            elseif totalWidth < maxWidth then
	                return word
	            end

	            -- Split before the word
	            if char == ' ' then
	                totalWidth = wordlen - spaceWidth
	                return '\n' .. string.sub(word, 2)
	            end

	            totalWidth = wordlen
	            return '\n' .. word
	        end)

	    return text
	end

end

function plyMeta:canAfford(amount)

	local char = self:GetCharacter()

	if (char) then
		return char:GetMoney() >= amount
	else
		return false
	end

end

function entMeta:keysOwn(ply)
	if (self:IsVehicle()) then
		self:CPPISetOwner(ply)
	    self:SetNetVar("owner", ply:GetCharacter():GetID())
	    self.ownerID = ply:GetCharacter():GetID()
	    self:SetNetVar("ownerName", ply:GetCharacter():GetName())
	end
end

function entMeta:keysLock()
	if (self:IsVehicle()) then
		self:Fire("lock")
	end
end

function entMeta:keysUnLock()
	if (self:IsVehicle()) then
		self:Fire("unlock")
	end
end

function entMeta:isLocked()
    local save = self:GetSaveTable()
    return save and ((self:IsDoor() and save.m_bLocked) or (self:IsVehicle() and save.VehicleLocked)) or false
end

function entMeta:getDoorOwner()

	if (self:IsDoor()) then
		// to do

	elseif (self:IsVehicle()) then
		if (self.CPPIGetOwner) then

			local plyOwner = self:CPPIGetOwner()

			return plyOwner
		else
			return nil
		end
	end

	return nil

end

function DarkRP.formatMoney(amount)
	return ix.currency.Get(amount)
end