AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()


	self:SetModel("models/sligwolf/garbagetruck/sw_dumpster.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:SetMass(500)
		phys:Wake()

	end

	self:SetFullTrash(true)

	self:SetSpawnTimer(0)

	self.TrashEnts = {}

	timer.Simple(0.3, function()
		
		if (!IsValid(self)) then return end

		local phys = self:GetPhysicsObject()
		
		if phys:IsValid() then
			phys:EnableMotion(false)
		end

		

	end)

	self.NextCheck = CurTime() + 5
	
	self:SpawnTrash()

	PLUGIN:SaveJRDumpsters()

end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRDumpsters()
	end
end

function ENT:SpawnTrash()

	local randomTrashs = math.random(2,3)

	for i = 1, randomTrashs do

		timer.Simple(i - 1 + 0.1, function()

			if (!IsValid(self)) then return end

			local TrashEnt = ents.Create("prop_physics");
			TrashEnt:SetModel("models/sligwolf/garbagetruck/sw_trashbag_"..math.random(1,3)..".mdl")
			TrashEnt:SetPos(self:GetPos() + self:GetAngles():Up()*20 + self:GetAngles():Forward() * (-60 + (i * 30) ) + self:GetAngles():Right() * math.random(-1,1) )
			TrashEnt:SetAngles(self:GetAngles())
			-- TrashEnt:SetParent(self)
			TrashEnt:Spawn()
			TrashEnt.Dumpster = self
			TrashEnt:CallOnRemove("RemoveTrashFromTable",function(ent) 
				if (ent.Dumpster) and (IsValid(ent.Dumpster)) then
					if (ent.Dumpster.TrashEnts[ent]) then
						ent.Dumpster.TrashEnts[ent] = nil
					end
				end
			end)

			self.TrashEnts[TrashEnt] = true,

			self:DeleteOnRemove(TrashEnt)

			-- timer.Simple(1, function()
			
			-- 	if (!IsValid(self)) then return end
			-- 	if (!IsValid(TrashEnt)) then return end

			-- 	TrashEnt:SetParent(self)

			-- 	-- local phys = TrashEnt:GetPhysicsObject()
				
			-- 	-- if phys:IsValid() then
			-- 	-- 	phys:EnableMotion(false)
			-- 	-- end

			-- end)

		end)

	end

end

function ENT:ToggleTrash(bStatus)

	for k, v in pairs(self.TrashEnts or {}) do
		
		if (IsValid(k)) then
			if (bStatus) then
				k:SetParent(self)
			else
				k:SetParent(NULL)

				local phys = k:GetPhysicsObject()
	
				if phys:IsValid() then

					phys:Wake()

				end

			end
		end

	end

end

function ENT:FindCollector()

	self:SetFullTrash(false)

	local tr = util.QuickTrace(self:GetPos(), Vector(0,0,-100), {self, "prop_physics"})

	local trEnt = tr.Entity

	if (trEnt:IsVehicle()) then
		if (trEnt.VehicleName == "sligwolf_garbagetruck") then

			if (!trEnt.__SW_GrabDumpster) then
				local ply = trEnt:GetDriver()

				local driverChar = ply:GetCharacter()

        		driverChar:SetData("Paycheck_money_garbagecollector", driverChar:GetData("Paycheck_money_garbagecollector",0) + 75)

				ply:Notify("You have emptied the dumpster")
			end

		end
	end

	local spawnTime = ix.config.Get("DumpsterSpawn", 5) * 60

	self:SetSpawnTimer(spawnTime)

	-- local EntsSphere = ents.FindInSphere(self:GetPos(), 100)

	-- if (istable(EntsSphere)) then
	-- 	for k, v in ipairs(EntsSphere) do
			
	-- 		if (v:IsVehicle()) then
	-- 			if (v.VehicleName == "sw_garbagetruck") then

	-- 				if (!v.__SW_GrabDumpster) then
	-- 					local ply = v:GetDriver()
	-- 					ply:Notify("wywaliles smieci, brawo")
	-- 				end

	-- 			end
	-- 		end
	-- 	end
	-- end


end

function ENT:Think()

	if (self.NextCheck < CurTime()) then

		if (self:GetSpawnTimer() > 0) then

			self:SetSpawnTimer(self:GetSpawnTimer() - 1)

			if (self:GetSpawnTimer() <= 0) then
				self:SetFullTrash(true)
				self:SpawnTrash()
			end

			self.NextCheck = CurTime() + 1

		else

			if (self.__SW_OnFork) then

				if (self:GetFullTrash()) then
					if (self:GetAngles().z >= 85) then
						self:FindCollector()
					end
				end

				-- if (self.TrashEnts) and (!table.IsEmpty(self.TrashEnts)) then

				-- 	if (self:GetAngles().z > 10) then
				-- 		self:ToggleTrash(false)
				-- 	elseif (self:GetAngles().z <= 10) then
				-- 		self:ToggleTrash(true)
				-- 	end

				-- end

				self.NextCheck = CurTime() + 0.5

			else

				local phys = self:GetPhysicsObject()
			
				if phys:IsValid() then
					phys:EnableMotion(false)
				end

				self.NextCheck = CurTime() + 5

			end
		end

		
	end

	self:NextThink( CurTime() ) -- Set the next think for the serverside hook to be the next frame/tick
	return true
end