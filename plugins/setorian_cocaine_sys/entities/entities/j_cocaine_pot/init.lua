AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/dannio/fbikid/cocaine/planter.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	-- PLUGIN:SaveGunCraftTables()

	self.NextTick = CurTime()

	self:SetWaterLevel(4)
	self:SetGrowStatus(1)

	self.OldGrowStatus = nil

	self:SetLeaves(10)

	self.NextReset = CurTime()

	self.WaterLvl = 50

	self.DieCount = 0

	local VisualPlant = ents.Create("prop_dynamic");
	VisualPlant:SetModel("models/dannio/fbikid/cocaine/cocaineplant.mdl")
	VisualPlant:SetPos(self:GetPos() + self:GetAngles():Up()*6 )
	VisualPlant:SetAngles(self:GetAngles())
	VisualPlant:SetParent(self)
	VisualPlant:SetModelScale(0)
	VisualPlant:DrawShadow(false)
	VisualPlant:Spawn();

	self.VisualPlant = VisualPlant

	local GrowthTime = ix.config.Get("PlantGrowthTime", 20)
	local GrowthTimeOffset = ix.config.Get("PlantGrowthTimeOffset", 2)

	// 60s * 20min = 1200
	self.GrowProgress = ( math.max(GrowthTime + math.random(-GrowthTimeOffset,GrowthTimeOffset),1) ) * 60
	-- print("self.GrowProgress", self.GrowProgress)

	self.CurrentGrowProgress = 0

end

function ENT:Think()

	if (self.NextTick < CurTime()) then

		-- self:PrintDebugInfo()

		if (self:FindLightSource()) and (self.WaterLvl > 0) then

			if (self.OldGrowStatus) then
				self:SetGrowStatus(self.OldGrowStatus)
			end

			self.CurrentGrowProgress = math.min(self.CurrentGrowProgress + 1, self.GrowProgress)

			self:CheckGrowthLevel()

			if (self.DieCount > 0) then
				self.DieCount = self.DieCount - 1
			end

			if (math.random() > 0.75) then
				self.WaterLvl = math.max(self.WaterLvl - math.random(1,10), 0)
				self:CheckWaterLevel()
			end

			if (self:GetGrowStatus() == 7) then
				self:SetGrowStatus(1)
			end

			self.NextTick = CurTime() + 1
		else

			if (math.random() > 0.75) and self:GetLeaves() > 5 then
				self:SetLeaves(math.max(self:GetLeaves() - 1, 5))
			end

			if (self:GetGrowStatus() != 7) then
				self.OldGrowStatus = self:GetGrowStatus()
			end

			self:SetGrowStatus(7)

			if (self.DieCount < 10) then
				self.DieCount = self.DieCount + 1
			end

			if (self.DieCount >= 10) then
				ix.item.Spawn("plant_pot", self:GetPos(), nil, self:GetAngles())
    			self:Remove()
			end

			self.NextTick = CurTime() + 5
		end

		
	end

end

function ENT:PrintDebugInfo()

	print("========= START ========")
	print("WaterLvl", self.WaterLvl)
	print("WaterLevel:",self:GetWaterLevel())
	print("GrowStatus",self:GetGrowStatus())
	print("Leaves",self:GetLeaves())
	print("self.CurrentGrowProgress", self.CurrentGrowProgress)
	print("self.OldGrowStatus", self.OldGrowStatus)
	print("========== END =========")

end

function ENT:FindLightSource()

	local lamps = ents.FindInSphere(self:GetPos(), 100)

	if (istable(lamps)) then
		for k, v in ipairs(lamps) do
			
			if (v:GetClass() == "j_cocaine_lamp") then

				if (v:GetIsWorking()) then
					if (v:LetsFindPot(self)) then
						return true
					end
				end
			else
				continue
			end

		end
	end

	local ignoredEnts = {self}

	table.Add(ignoredEnts, player.GetAll())

	local tr = util.QuickTrace( self:GetPos(), self:GetUp() * 100000,  ignoredEnts )

	if (tr.HitSky) or (tr.SurfaceProps == 28) then
		return true
	end

	return false

end

function ENT:CheckGrowthLevel()

	if (self:GetGrowStatus() == 6) then return end

	if (self.CurrentGrowProgress == self.GrowProgress) then
		self:SetGrowStatus(6)
	end

	local calc_new_level = math.ceil((self.CurrentGrowProgress * 5) / self.GrowProgress)

	if (calc_new_level > self:GetGrowStatus()) then
		self:SetGrowStatus(calc_new_level)

		self.VisualPlant:SetModelScale(self.VisualPlant:GetModelScale() + 0.25,5)
		
		if (math.random() > 0.40) and self:GetLeaves() < 20 then
			self:SetLeaves(math.min(self:GetLeaves() + math.random(1,5), 20))
		end

	end

end

function ENT:CheckWaterLevel()

	local calc_new_level = math.ceil((self.WaterLvl * 7) / 100)

	if (calc_new_level != self:GetWaterLevel()) then
		self:SetWaterLevel( math.Clamp(8 - calc_new_level, 1, 7) )
	end

end

function ENT:Waterit(client)

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local item = inv:HasItem("grow_water")

	if (item) then

		self.WaterLvl = math.min(self.WaterLvl + math.random(20,40), 100)
		self:CheckWaterLevel()
		self:EmitSound("ambient/water/water_spray1.wav")
		client:Notify("You have added water to the pot")

		item:Remove()

	else
		client:Notify("You don't have any water bottle in your inventory")
	end

end

function ENT:TakeLeaves(client,count, noNotify)

	if (self.CurrentGrowProgress != self.GrowProgress) then
		client:Notify("The plant isn't yet ready to harvest leaves")
		return false
	end

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local HarvestedCount = count

	if (count > self:GetLeaves()) then
		HarvestedCount = self:GetLeaves()
	end

	local HarvestedLeft = HarvestedCount

	for k, v in ipairs(inv:GetItemsByUniqueID("coca_leaves")) do
		
		if (v:GetData("leavesCount", 1) < 5) then
				
			local CountAdd = HarvestedLeft

			if (v:GetData("leavesCount", 1) + CountAdd > 5) then
				CountAdd = 5 - v:GetData("leavesCount", 1)
			end

			v:SetData("leavesCount", v:GetData("leavesCount", 1) + CountAdd )

			HarvestedLeft = HarvestedLeft - CountAdd

		end

	end


	if (HarvestedLeft > 0) then

		local itemData = {
			leavesCount = HarvestedLeft
		}

		local IsAdded, ErrorInv = inv:Add("coca_leaves",1,itemData)

		if (!IsAdded) then
	        client:Notify(L(ErrorInv, client))
	        return false
	    end

	end

    self:SetLeaves(math.max(self:GetLeaves() - HarvestedCount, 0))
 
    if (self:GetLeaves() <= 0) then

    	if (!noNotify) then
	    	client:Notify("You collected all the leaves")
	    end

    	ix.item.Spawn("plant_pot", self:GetPos(), nil, self:GetAngles())
    	self:Remove()
    else

    	if (!noNotify) then

	    	local properName = (HarvestedCount == 1 and "one leaf") or (HarvestedCount .. " leaves")

	    	client:Notify("You collected "..properName..". There are "..self:GetLeaves().." left to collect")

	    end

    end

    return true, HarvestedCount

end

function ENT:TakeOneLeaf(client)
	self:TakeLeaves(client,1)
end

function ENT:TakeFiveLeaves(client)
	self:TakeLeaves(client,5)
end

function ENT:TakeAllLeaves(client)

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local howManyHarvested = 0

	local AllCollected = true

	while (self:GetLeaves() > 0) do

		local IsSucces, HowMany = self:TakeLeaves(client,5, true)

		if (IsSucces) then
			howManyHarvested = howManyHarvested + HowMany
		else
			AllCollected = false
			break
		end

	end

	if (AllCollected) then
		client:Notify("You collected all the leaves")
	else
		client:Notify("It was not possible to collect all the leaves. There are "..self:GetLeaves().." left to collect")
	end

end

function ENT:OnOptionSelected(client, option, data)

	if (option == "Water it (needed water item)") then
		self:Waterit(client)
	elseif (option == "Collect one leaf") then
		self:TakeOneLeaf(client)
	elseif (option == "Collect five leaves") then
		self:TakeFiveLeaves(client)
	elseif (option == "Collect all the leaves") then
		self:TakeAllLeaves(client)
	elseif (option == "Flip it") then

		if (self.NextReset < CurTime()) then

			self:SetPos( self:GetPos() + Vector(0, 0, 1) )
			self:SetAngles(Angle(0,self:GetAngles().yaw,0))

			local phys = self:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)
				
			end

			timer.Simple(0.2,function()

				if (IsValid(self)) then
					local phys = self:GetPhysicsObject()
					if phys:IsValid() then
						phys:EnableMotion(true)
						phys:Wake()
					end
				end

			end)

			self.NextReset = CurTime() + 2

		else
			client:Notify("You must wait before doing it again")
		end
	end

end

function ENT:OnRemove()


end
