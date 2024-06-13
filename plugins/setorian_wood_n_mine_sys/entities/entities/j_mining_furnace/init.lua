AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/fbkid/work/furnace3.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()
	
	self.WorkTimer = CurTime()
	
	if phys:IsValid() then

		phys:Wake()

	end
	
	self:SetWorkTime(0)
	self:SetMeltTime(0)

	self:SetIsWorking(false)

	self:SetFuelCount(0)
	self:SetInputCount(0)
	self:SetOutputCount(0)

	self.FuelItem = nil
	self.InputItem = nil
	-- self.OutputItem = nil

	-- self.FuelData = {}
	-- self.InputData = {}
	self.OutputData = {}

	self.IsReady = false


end

-- function ENT:SpawnFunction( ply, tr, ClassName )
-- 	if ( !tr.Hit ) then return end

-- 	local SpawnPos = tr.HitPos + tr.HitNormal * 50
-- 	local SpawnAng = ply:EyeAngles()
-- 	SpawnAng.p = 0
-- 	SpawnAng.y = SpawnAng.y + 180
-- 	local ent = ents.Create( ClassName )
-- 	ent:SetPos(SpawnPos)
-- 	ent:SetAngles(SpawnAng)
-- 	ent:Spawn()
-- 	return ent
-- end



function ENT:Think()

	if (self:GetIsWorking()) then

		if (self.WorkTimer < CurTime()) then

			if (self.FuelItem) then
				if (self:GetWorkTime() % PLUGIN.fuel[self.FuelItem] == 0) then

					if (self:GetFuelCount() > 0) then
						self:SetFuelCount(self:GetFuelCount() - 1)

						if (self:GetFuelCount() <= 0) then
							self.FuelItem = nil
						end

					else
						self:TurnOff()
					end

				end
			end
			
			self:SetWorkTime( math.max( self:GetWorkTime() - 1, 0 ) )
			
			if (self:GetMeltTime() > 0) and (self.InputItem) and (!table.IsEmpty(self.OutputData)) and (self:GetInputCount() >= self.OutputData.NeededAmount) then
				self:SetMeltTime( math.max( self:GetMeltTime() - 1, 0 ) )
			end

			self.WorkTimer = CurTime() + 1

			if (self:GetWorkTime() <= 0) then

				self:TurnOff()
			end

			if (self:GetMeltTime() <= 0) and (self.InputItem) and (!table.IsEmpty(self.OutputData)) and (self:GetInputCount() >= self.OutputData.NeededAmount) then

				-- self.OutputData.MeltedAmount = self.OutputData.MeltedAmount + 1 or 1
				self:SetOutputCount(self:GetOutputCount() + 1)

				self:SetInputCount(self:GetInputCount() - self.OutputData.NeededAmount)

				if (self:GetInputCount() >= self.OutputData.NeededAmount) then
					self:SetMeltTime(self.OutputData.MeltTime)
				end

				if (self:GetInputCount() <= 0) then
					self.InputItem = nil
				end

			end


				-- if (table.IsEmpty(self.FuelData)) then
				-- 	self:TurnOff()
				-- else	
				-- 	if (self.FuelData.Count > 0) then
				-- 		self:SetWorkTime(PLUGIN.fuel[self.FuelData.ItemID])
				-- 		self.FuelData.Count = self.FuelData.Count - 1
				-- 	else
				-- 		self:TurnOff()
				-- 	end
				-- end

			-- end

		end


	end

	-- 	self:VisualEffect()
		
	-- 	if self:GetFuel() > 0 and self:GetWorkTime() > 0 then
	-- 		if CurTime() > self.timer + 1 then
		
	-- 		self.timer = CurTime()
		
	-- 		self:SetWorkTime( math.Clamp( self:GetWorkTime() - 10, 0, ix.config.Get("MeltTime", 2) * 60 ) )
		
	-- 		end
		
	-- 		if CurTime() > self.fuel + 2 then
		
	-- 		self.fuel = CurTime()
		
	-- 		self:Setfuel( math.Clamp( self:GetFuel() - 1, 0, 60 ) )
		
	-- 		end
	-- 	end
		
	-- end

	-- if (self:GetFuel() == 0) then
	-- 	self:SetIsWorking(false)
	-- 	if self.sound then
	--         self.sound:Stop()
	--     end
	-- end	

	-- if self:GetWorkTime() == 0 then
	-- 	if self.sound then
	--         self.sound:Stop()
	--     end
		
	-- 	-- ix.item.Spawn("ore_ironingot" ,self:GetPos() + (self:GetUp()*-20) + (self:GetRight()*-0.5) + (self:GetForward()*17), nil, self:GetAngles())
		
	-- 	self.IsReady = true
	-- 	self:SetIsWorking(false)
	-- end

end


function ENT:OnOptionSelected(client, option, data)

	if (option == "Ignite/Extinguish") then

		if (self:GetIsWorking()) then
			self:TurnOff()
		else
			self:TurnOn()
		end

	elseif (option == "Open Menu") then

		local furnaceData = {
			FuelItem   = self.FuelItem,
			InputItem  = self.InputItem,
			OutputData = self.OutputData
		}
		-- furnaceData.FuelData   = self.FuelData
		-- furnaceData.InputData  = self.InputData
		-- furnaceData.OutputData = self.OutputData

		net.Start("ixFurnace_OpenUI")
			net.WriteEntity(self)

			local json = util.TableToJSON(furnaceData)
			local compressedTable = util.Compress( json )
			local bytes = #compressedTable

			net.WriteUInt( bytes, 16 )
			net.WriteData( compressedTable, bytes )

		net.Send(client)

	end

end

function ENT:TurnOn()

	if (( self.FuelItem ) and (self:GetFuelCount() > 0) and (PLUGIN.fuel[self.FuelItem])) or (self:GetWorkTime() != 0)  then

		self:SetIsWorking(true)
		-- self:SetWorkTime(PLUGIN.fuel[self.FuelData.ItemID])
		self:PlayFireSound()
		-- self.FuelData.Count = self.FuelData.Count - 1
		self:EmitSound("ambient/fire/mtov_flame2.wav")

	end

end

function ENT:TurnOff()

	self:SetIsWorking(false)
	self:EmitSound("ambient/fire/gascan_ignite1.wav")
	if (self.FireSound) then
        self.FireSound:Stop()
    end

end

-- function ENT:StartTouch( hitEnt ) 
-- 	if (hitEnt:GetClass() == "ix_item") then 
-- 		local itemTable = hitEnt:GetItemTable() 

-- 		if self.OresToPut[itemTable.uniqueID] then

-- 			if itemTable.uniqueID == "ore_coal" then 
-- 				self:Setfuel(math.Clamp( self:Getfuel() + 10, 0, 60 )) 
-- 			elseif self.OresNotCoal[itemTable.uniqueID] then

-- 				if (!self.ActualOre) or (self.ActualOre == nil) then
-- 					self.ActualOre = itemTable.uniqueID
-- 				end
				
-- 				if (self.ActualOre != itemTable.uniqueID) then return end

-- 				if (self.IsReady) then return end 
-- 				local ironStorage = ix.config.Get("FurnaceSize", 5) 

-- 				self:SetIrons(math.Clamp( self:GetIrons() + 1, 0, ironStorage )) 

-- 				self:VisualOres(itemTable.model) 
-- 			end 

-- 		hitEnt:Remove() 

-- 		self:EmitSound("physics/concrete/rock_impact_soft"..math.random(1,3)..".wav") 


-- 		end

-- 	end 


-- end

-- function ENT:Use(act, call)

-- 	if call:IsPlayer() then

-- 		if self:GetIrons() > 0 then
		
-- 			if (!self.IsReady) and self:Getfuel() > 0 then
-- 				self:SetIsWorking(true)
-- 				self:FireSound()
-- 				self:EmitSound("ambient/fire/mtov_flame2.wav")

-- 			elseif (self.IsReady) then
-- 				self:GetIronsIgnot()
-- 			end	
		
-- 		end
	
	
	
-- 	end

-- end

function ENT:PlayFireSound()

	if (self.FireSound) then
		self.FireSound:PlayEx(1, 100)
	else
	    self.FireSound = CreateSound(self, Sound("ambient/fire/fire_med_loop1.wav"))
	    self.FireSound:SetSoundLevel(75)
		self.FireSound:PlayEx(1, 100)
	end

end

function ENT:OnRemove()
    if (self.FireSound) then
        self.FireSound:Stop()
    end
end