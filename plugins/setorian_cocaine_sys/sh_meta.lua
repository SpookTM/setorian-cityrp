
local plyMeta = FindMetaTable("Player")

function plyMeta:IsCocaineDrugged()
	
	-- local effectID = "ixCocaineDrugged" .. self:UniqueID()
	-- return timer.Exists(effectID)
	return self:GetLocalVar("CocaineDrugged", false)

end

function plyMeta:SetCocaineDrugged(bValue)

	self:SetLocalVar("CocaineDrugged", bValue)

	local effectID = "ixCocaineDrugged" .. self:UniqueID()

	local char = self:GetCharacter()

	if (bValue) then

		local DurationTime = ix.config.Get("CocaDuration", 7) * 60

		if (timer.Exists(effectID)) then
			timer.Adjust(effectID, DurationTime)
		else
			timer.Create(effectID, DurationTime, 1, function()

				if (!IsValid(self)) then return end
				if (!self:GetLocalVar("CocaineDrugged", false)) then return end

				self:SetCocaineDrugged(false)

			end)

			
			char:AddBoost(effectID, "stm", math.random(25,40))
			char:AddBoost(effectID, "end", math.random(25,40))
		end

		self:ScreenFade( SCREENFADE.IN, Color( 220,220,220 ), 1, 0 )

	else

		if (timer.Exists(effectID)) then
			timer.Destroy(effectID)
		end

		char:RemoveBoost(effectID, "stm")
		char:RemoveBoost(effectID, "end")

		self:ScreenFade( SCREENFADE.IN, Color( 20,20,20, 200 ), 1, 0 )

	end

end