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

	local b = ClientsideModel(hedModel, RENDERGROUP_OPAQUE)
	if !b then return end
	b:InvalidateBoneCache()
	b:SetParent(self)
	b:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	b:SetupBones()
	self.headModel = b
	-- function b:Think()
	-- 	-- local ply = Entity_GetParent(self)

	-- 	local ply = b:GetParent()

	-- 	if IsValid(ply) then

	-- 		if !self.LastParent then
	-- 			if !self.bLastAliveState then
	-- 				self.bLastAliveState = ply:Alive()
	-- 			end
				
	-- 			if !self.nLastCharID then
	-- 				self.nLastCharID = ply:GetCharacter()
	-- 			end

	-- 			if !self.nLastRagdollID then
	-- 				self.nLastRagdollID = ply:GetLocalVar("ragdoll", 0)
	-- 			end
	-- 		else
	-- 			if !self.bLastAliveState then
	-- 				self.bLastAliveState = self.LastParent:Alive()
	-- 			end
				
	-- 			if !self.nLastCharID then
	-- 				self.nLastCharID = self.LastParent:GetCharacter()
	-- 			end

	-- 			if !self.nLastRagdollID then
	-- 				self.nLastRagdollID = self.LastParent:GetLocalVar("ragdoll", 0)
	-- 			end
	-- 		end

	-- 		if ply:GetMoveType() == MOVETYPE_NOCLIP and ply:GetNoDraw() and !self.bLastDrawState then
	-- 			b:SetNoDraw(true)
	-- 		elseif !ply:GetNoDraw() and self.bLastDrawState then
	-- 			b:SetNoDraw(false)
	-- 		end


	-- 		if ply.pac_hide_entity then
	-- 			b:SetNoDraw(true)
	-- 		end

	-- 		if !IsValid(self.LastParent) then
	-- 			if !ply:Alive() and self.bLastAliveState then
	-- 				self.LastParent = ply
	-- 				b:SetParent(ply:GetRagdollEntity())
	-- 				b:AddEffects(EF_BONEMERGE)
	-- 			end

	-- 			if self.nLastRagdollID == 0 and ply:GetLocalVar("ragdoll") then
	-- 				self.LastParent = ply
	-- 				b:SetParent(Entity(ply:GetLocalVar("ragdoll")))
	-- 				b:AddEffects(EF_BONEMERGE)
	-- 			end
				
	-- 			if ply:GetCharacter() != self.nLastCharID then
	-- 				-- bonemergeEntities[self] = nil
	-- 				-- plugin:RemoveBonemergedItemCache(ply)
	-- 				self:Remove()
	-- 			end
	-- 		else
	-- 			if self.LastParent:GetCharacter() != self.nLastCharID then
	-- 				-- bonemergeEntities[self] = nil
	-- 				-- plugin:RemoveBonemergedItemCache(ply)
	-- 				self:Remove()
	-- 			end

	-- 			if self.LastParent:Alive() and !self.bLastAliveState then
	-- 				b:SetParent(self.LastParent)
	-- 				b:AddEffects(EF_BONEMERGE)
	-- 				self.LastParent = nil
	-- 			end

	-- 			if !self.LastParent:GetLocalVar("ragdoll") and self.bLastAliveState then
	-- 				b:SetParent(self.LastParent)
	-- 				b:AddEffects(EF_BONEMERGE)
	-- 				self.LastParent = nil
	-- 			end
	-- 		end

	-- 	else
	-- 		if !IsValid(self.LastParent) then
	-- 			-- plugin:RemoveBonemergedItemCache(ply)
	-- 			self:Remove()
	-- 		else
	-- 			b:SetParent(self, self.LastParent)
	-- 			b:AddEffects(self, EF_BONEMERGE)
	-- 			self.LastParent = nil
	-- 		end
	-- 	end
		
	-- 	self.bLastDrawState = self:GetNoDraw()
	-- 	if !IsValid(self.LastParent) then
	-- 		if IsValid(ply) and ply:IsPlayer() then
	-- 			-- self.bLastPACHideEntity = ply.pac_hide_entity
	-- 			self.bLastAliveState = ply:Alive()
	-- 			self.nLastCharID = ply:GetCharacter()
	-- 			self.nLastRagdollID = ply:GetLocalVar("ragdoll", 0)
	-- 		end
	-- 	else
	-- 		-- self.bLastPACHideEntity = self.pac_hide_entity
	-- 		self.bLastAliveState = self.LastParent:Alive()
	-- 		self.nLastCharID = self.LastParent:GetCharacter()
	-- 		self.nLastRagdollID = self.LastParent:GetLocalVar("ragdoll", 0)
	-- 	end
	-- end
	-- hook.Add("Think", b, b.Think)

end

local ENTITY = FindMetaTable("Entity")

function ENTITY:EquipHead(HeadModel)

	local b = ClientsideModel(HeadModel, RENDERGROUP_OPAQUE)
	if !b then return end
	b:InvalidateBoneCache()
	b:SetParent(self)
	b:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	b:SetupBones()
	self.headModel = b

end