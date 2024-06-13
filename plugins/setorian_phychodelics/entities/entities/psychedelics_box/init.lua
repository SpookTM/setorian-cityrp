AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
local offset = 8
local positionsX = {offset, -offset, offset, -offset}
local positionsY = {offset, offset, -offset, -offset}
local function grow(box)
	local level = box.level
	if level == nil then level = 0 end

	if level == 5 then
		for i = 1, 4 do
			local mushroom1 = ents.Create("psychedelics_mushroom1")
			local posX, posY = positionsX[i], positionsY[i]
			mushroom1:Spawn()
			mushroom1:GetPhysicsObject():EnableMotion(false)
			local mins, maxs = mushroom1:GetModelBounds()
			mushroom1:SetPos(box:LocalToWorld(Vector(posX, posY, 17.9 - mins.z)))
			mushroom1:SetParent(box)
		end
		box.level = 5


	elseif level == 6 then
		--finds all active mushrooms and replace them
		for k, mushroom1 in pairs(ents.FindByClassAndParent("psychedelics_mushroom1", box)) do
			local mushroom2 = ents.Create("psychedelics_mushroom2")
			mushroom2:Spawn()
			mushroom2:GetPhysicsObject():EnableMotion(false)
			local mins, maxs = mushroom2:GetModelBounds()
			local mushroom1LocalPos = box:WorldToLocal(mushroom1:GetPos())
			local pos = box:LocalToWorld(Vector(mushroom1LocalPos.x, mushroom1LocalPos.y, 17.9 - mins.z))
			mushroom2:SetPos(pos)
			mushroom2:SetAngles(mushroom1:GetAngles())
			mushroom2:SetParent(box)
			mushroom1:Remove()
		end
		box.level = 6


	elseif level == 7 then
		for k, mushroom2 in pairs(ents.FindByClassAndParent("psychedelics_mushroom2", box)) do
			local mushroom3 = ents.Create("psychedelics_mushroom3")
			mushroom3:Spawn()
			mushroom3:GetPhysicsObject():EnableMotion(false)
			local mins, maxs = mushroom3:GetModelBounds()
			local mushroom2LocalPos = box:WorldToLocal(mushroom2:GetPos())
			local pos = box:LocalToWorld(Vector(mushroom2LocalPos.x, mushroom2LocalPos.y, 17.9 - mins.z))
			mushroom3:SetPos(pos)
			mushroom3:SetAngles(mushroom2:GetAngles())
			mushroom3:SetParent(box)
			mushroom2:Remove()
		end
		box:SetNWString("psychedelicsTipText", "Press 'e' to pickup the mushrooms")
		box.level = 7
	end
end


local function destroy(box) --used when water runs out
	box:SetBodygroup(1, 0)

	--remove active mushrooms
	local table = ents.FindByClassAndParent("psychedelics_mushroom1", box)
	if table ~= nil then
		for k, mushroom1 in pairs(table) do mushroom1:Remove() end
	end
	local table = ents.FindByClassAndParent("psychedelics_mushroom2", box)
	if table ~= nil then
		for k, mushroom2 in pairs(table) do mushroom2:Remove() end
	end

	box.level = 0
	box:SetNWInt("psychedelicsProgress", 0)
	box:SetNWString("psychedelicsTipText", "Add mushroom substrate (0/3)")
	

end


local function growProgress(box)
	if not box:IsValid() then return end
	local level = box.level
	if level==nil then level = 0 end
	if (level >= 4 and level <= 6) == false then return end --only execute when box has enough substrate


	local progress = box:GetNWInt("psychedelicsProgress", 0)
	local water = box:GetNWInt("psychedelicsWaterLevel", 100)
	local minusWater = math.random(1, 10)
	local random = math.random(0, 1)

	--algorithm for growing tick
	if random == 1 then
		progress = progress + 1
		if water - minusWater < 0 then
			box:SetNWInt("psychedelicsWaterLevel", 0)
		else
			water = water - random
			box:SetNWInt("psychedelicsWaterLevel", water)
		end
	end
	if water <= 0 then
		destroy(box)
		return
	end

	if progress >= 100 then
		box:SetNWInt("psychedelicsProgress", 0)
		box.level = level + 1
		grow(box)
	else
		box:SetNWInt("psychedelicsProgress", progress)
	end

	local delay = GetConVar("psychedelics_mushroom_grow_rate"):GetFloat()
	timer.Simple(delay, function() growProgress(box) end) --run the grow func after delay
end


local function try(box)
	if box:IsValid() == false then return end
	if box.level == 4 and box:GetNWInt("psychedelicsProgress",0) == 0 then
		growProgress(box)
	end
	timer.Simple(0.05, function() try(box) end) --keep checking when to execute growProgress
end


function ENT:Initialize()
	self:SetModel("models/psychedelics/mushroom/box.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:Activate()
	try(self)
end

function ENT:Use(activator, caller)
	if activator.usedBox then return end
	activator.usedBox = true
	timer.Simple(0.1, function()
		activator.usedBox = false
	end) -- avoids +use spam

	local level = self.level
	if level == nil then level = 0 end
	-- if level >= 4 and level <= 6 then
	-- 	self:EmitSound("ambient/water/water_splash" ..tostring(math.random(1, 3)) .. ".wav", 75, 100, 1)
	-- 	self:SetNWInt("psychedelicsWaterLevel", 100)
	-- end

	--when the mushrooms have fully growed
	if level == 7 then
		for k, v in pairs(ents.FindByClassAndParent("psychedelics_mushroom3", self)) do
			v:SetParent(nil)
			v:GetPhysicsObject():EnableMotion(true)
		end
		self.level = 0
		self:SetBodygroup(1, 0)
		self:SetNWString("psychedelicsTipText", "Add mushroom substrate (0/3)")
	end
end

function ENT:StartTouch(hitEnt)

	if hitEnt:GetClass() == "ix_item" then
    	local itemTable = hitEnt:GetItemTable()
        
    	if (itemTable.uniqueID == "psychedelics_spores") then

    		local level = self.level
			if level == nil then level = 0 end
			if not (level == 3) then return end

			if self.sporesTouched then	return end
			self.sporesTouched = true
			timer.Simple(0.2, function()
				self.sporesTouched = false
			end) -- delay used to fix bugs related to tick


			level = level + 1
			self.level = level
			self:SetNWInt("psychedelicsWaterLevel", 100)
			self:SetNWString("psychedelicsTipText", "Water it regularly and wait for it to grow")
			hitEnt:Remove()
		elseif (itemTable.uniqueID == "psychedelics_substrate") then

    		local level = self.level
			if level == nil then level = 0 end

			if not (level <= 2) then return end
			if self.substrateTouched then	return end
			self.substrateTouched = true
			timer.Simple(0.2, function()
				self.substrateTouched = false
			end) -- delay used to fix bugs related to tick
			
				
			level = level + 1
			self:SetBodygroup(1, level)
			self.level = level
			if level ~= 3 then
				self:SetNWString("psychedelicsTipText", "Add mushroom substrate (" .. tostring(level) .."/3)")
			else
				self:SetNWString("psychedelicsTipText", "Add mushroom spores")
			end
			hitEnt:Remove()
		elseif (itemTable.uniqueID == "grow_water") then

			local level = self.level
			if level == nil then level = 0 end
			if level >= 4 and level <= 6 then
				self:EmitSound("ambient/water/water_splash" ..tostring(math.random(1, 3)) .. ".wav", 75, 100, 1)
				self:SetNWInt("psychedelicsWaterLevel", 100)
			end
			hitEnt:Remove()
    	end
    end
end

function ENT:Touch(entity) end

function ENT:Think() end
