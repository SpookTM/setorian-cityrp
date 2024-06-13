local PLAYER = FindMetaTable("Player")

function PLAYER:EquipHead(headModel)

	local char = self:GetCharacter()

	if (!char) then return end

	local hedModel

	if (headModel) then
		hedModel = headModel
	else

		if (!char:GetHeadmodel() or !string.find(char:GetHeadmodel(), "models")) then return end

		hedModel = char:GetHeadmodel()

	end

	local b = ents.Create("prop_ragdoll")--ClientsideModel(hedModel, RENDERGROUP_OPAQUE)
	if !b then return end
	b:SetModel(hedModel)
	-- b:InvalidateBoneCache()
	b:SetParent(self)
	b:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	b:Activate()
	b:Spawn()
	-- b:SetupBones()
	self.headModel = b

end

-- local ENTITY = FindMetaTable("Entity")

-- function ENTITY:EquipHead(HeadModel)

-- 	local b = ClientsideModel(HeadModel, RENDERGROUP_OPAQUE)
-- 	-- print(b)
-- 	if !b then return end
-- 	b:InvalidateBoneCache()
-- 	b:SetParent(self)
-- 	b:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
-- 	b:SetupBones()
-- 	self.headModel = b

-- end