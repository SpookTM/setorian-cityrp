AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/yan/gasstove.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self:Set1BurnerOn(false)
	self:Set2BurnerOn(false)
	self:Set3BurnerOn(false)
	self:Set4BurnerOn(false)

	self:Set1BurnEnt(NULL)
	self:Set2BurnEnt(NULL)
	self:Set3BurnEnt(NULL)
	self:Set4BurnEnt(NULL)

	self:SetIsWorking(false)

	self.NextCheckBurners = CurTime()
	self.NextSound = CurTime()
	self.NextTouchCheck = CurTime()

end

function ENT:Think()

	if ((self:Get1BurnEnt()) and (self:Get1BurnEnt() != NULL) or (self:Get2BurnEnt()) and (self:Get2BurnEnt() != NULL) or (self:Get3BurnEnt()) and (self:Get3BurnEnt() != NULL) or (self:Get4BurnEnt()) and (self:Get4BurnEnt() != NULL))  then
		if (self.NextCheckBurners < CurTime()) then

			-- if (self:Get1BurnerOn()) then
			-- 	self:Set1BurnEnt(self:CheckBurner1() or NULL)
			-- else
			if (self:Get1BurnEnt()) and (self:Get1BurnEnt() != NULL) then
				self:Get1BurnEnt():Process()
			end
			if (self:Get2BurnEnt()) and (self:Get2BurnEnt() != NULL) then
				self:Get2BurnEnt():Process()
			end
			if (self:Get3BurnEnt()) and (self:Get3BurnEnt() != NULL) then
				self:Get3BurnEnt():Process()
			end
			if (self:Get4BurnEnt()) and (self:Get4BurnEnt() != NULL) then
				self:Get4BurnEnt():Process()
			end
			-- end

			-- if (self:Get2BurnerOn()) then
			-- 	self:Set2BurnEnt(self:CheckBurner2() or NULL)
			-- else
			-- 	if (self:Get2BurnEnt()) and (self:Get2BurnEnt() != NULL) then
			-- 		self:Set2BurnEnt(NULL)
			-- 	end
			-- end

			-- if (self:Get3BurnerOn()) then
			-- 	self:Set3BurnEnt(self:CheckBurner3() or NULL)
			-- else
			-- 	if (self:Get3BurnEnt()) and (self:Get3BurnEnt() != NULL) then
			-- 		self:Set3BurnEnt(NULL)
			-- 	end
			-- end

			-- if (self:Get4BurnerOn()) then
			-- 	self:Set4BurnEnt(self:CheckBurner3() or NULL)
			-- else
			-- 	if (self:Get4BurnEnt()) and (self:Get4BurnEnt() != NULL) then
			-- 		self:Set4BurnEnt(NULL)
			-- 	end
			-- end

			-- self:Set1BurnEnt(self:CheckBurner1() or NULL)
			-- self:Set2BurnEnt(self:CheckBurner2() or NULL)
			-- self:Set3BurnEnt(self:CheckBurner3() or NULL)
			-- self:Set4BurnEnt(self:CheckBurner4() or NULL)
			self:SetIsWorking((self:Get1BurnEnt() and self:Get1BurnEnt() != NULL and self:Get1BurnerOn()) or (self:Get2BurnEnt() and self:Get2BurnEnt() != NULL and self:Get2BurnerOn()) or (self:Get3BurnEnt() and self:Get3BurnEnt() != NULL and self:Get3BurnerOn()) or (self:Get4BurnEnt() and self:Get4BurnEnt() != NULL and self:Get4BurnerOn()))

			-- if (self:Get1BurnerOn()) or (self:Get2BurnerOn()) or (self:Get3BurnerOn()) or (self:Get4BurnerOn()) then
			-- 	self:SetIsWorking(self:CheckBurner1() or self:CheckBurner2())
			-- else
			-- 	self:SetIsWorking(false)
			-- end

			if (self:GetIsWorking()) then
				self:CheckForNearbyPlayers()
			end

			self.NextCheckBurners = CurTime() + 1
		end
	else
		if (self:GetIsWorking()) then
			self:SetIsWorking(false)
		end
	end
	-- self:PrintDebugInfo()
	-- if (self.NextSound < CurTime()) and (self:GetIsWorking()) then

	-- 	self:EmitSound("ambient/levels/canals/toxic_slime_gurgle"..math.random(2,8)..".wav")
	-- 	self.NextSound = CurTime() + math.random(0.85,2)

	-- end

end

function ENT:CheckForNearbyPlayers()

	local FoundEnts = ents.FindInSphere(self:GetPos(), 75)

	if (istable(FoundEnts)) then
		for k, v in ipairs(FoundEnts) do

			if (v:IsNPC()) then
				v:TakeDamage( 15, self, self )
			end

			if (v:IsPlayer()) then

				local char = v:GetCharacter()
				local inv = char:GetInventory()

				local item = inv:HasItem("gasmask")

				if (!item) or (!item:GetData("equip")) then
					local d = DamageInfo()
					d:SetDamage( 15 )
					d:SetAttacker( self )
					d:SetDamageType( DMG_ACID ) 

					v:TakeDamageInfo( d )
				end
			end

		end
	end

end

function ENT:PrintDebugInfo()

	print("========START=========")
	print("self:GetIsWorking()", self:GetIsWorking())
	print("1BurnEnt()", self:Get1BurnEnt())
	print("2BurnEnt()", self:Get2BurnEnt())
	print("3BurnEnt()", self:Get3BurnEnt())
	print("4BurnEnt()", self:Get4BurnEnt())
	print("========END=========")

end

function ENT:StartTouch(ent)

	if (self.NextTouchCheck < CurTime()) then
		if (ent:GetClass() == "ix_item") then
			local itemTable = ent:GetItemTable()

			if (itemTable.uniqueID == "meth_pot") then
				
				if (self:WorldToLocal(ent:GetPos()).z >= 38) then

					if (!self:Get1BurnEnt()) or (self:Get1BurnEnt() == NULL) then

						local PotEnt = ents.Create("j_setorianmeth_pot");
						PotEnt:SetPos(self:GetPos()+(self:GetRight()*-8)+(self:GetUp()*46.1)+(self:GetForward()*-8) )
						PotEnt:SetAngles(self:GetAngles())
						PotEnt:SetParent(self)
						PotEnt:Spawn();

						-- ent:SetPos(self:GetPos()+(self:GetRight()*-8)+(self:GetUp()*48)+(self:GetForward()*-8))
						-- ent:SetAngles(Angle(0,0,0))

						if (ent.ixHeldOwner) then
							ent.ixHeldOwner:GetActiveWeapon():DropObject()
						end

						PotEnt:Setup(ent:GetData("cook_level", 0),ent:GetData("acetone", 0),ent:GetData("bismuth", 0),ent:GetData("hydrogen", 0),ent:GetData("phosphoric", 0))
						PotEnt.BurnerIndex = 1
						self:Set1BurnEnt(PotEnt)
						ent:Remove()


						self.NextTouchCheck = CurTime() + 0.1
					elseif (!self:Get2BurnEnt()) or (self:Get2BurnEnt() == NULL) then

						local PotEnt = ents.Create("j_setorianmeth_pot");
						PotEnt:SetPos(self:GetPos()+(self:GetRight()*-8)+(self:GetUp()*46.1)+(self:GetForward()*8) )
						PotEnt:SetAngles(self:GetAngles())
						PotEnt:SetParent(self)
						PotEnt:Spawn();

						-- ent:SetPos(self:GetPos()+(self:GetRight()*-8)+(self:GetUp()*48)+(self:GetForward()*-8))
						-- ent:SetAngles(Angle(0,0,0))

						if (ent.ixHeldOwner) then
							ent.ixHeldOwner:GetActiveWeapon():DropObject()
						end

						PotEnt:Setup(ent:GetData("cook_level", 0),ent:GetData("acetone", 0),ent:GetData("bismuth", 0),ent:GetData("hydrogen", 0),ent:GetData("phosphoric", 0))
						PotEnt.BurnerIndex = 2
						self:Set2BurnEnt(PotEnt)
						ent:Remove()


						self.NextTouchCheck = CurTime() + 0.1
					elseif (!self:Get3BurnEnt()) or (self:Get3BurnEnt() == NULL) then

						local PotEnt = ents.Create("j_setorianmeth_pot");
						PotEnt:SetPos(self:GetPos()+(self:GetRight()*7)+(self:GetUp()*46.1)+(self:GetForward()*-8) )
						PotEnt:SetAngles(self:GetAngles())
						PotEnt:SetParent(self)
						PotEnt:Spawn();

						-- ent:SetPos(self:GetPos()+(self:GetRight()*-8)+(self:GetUp()*48)+(self:GetForward()*-8))
						-- ent:SetAngles(Angle(0,0,0))

						if (ent.ixHeldOwner) then
							ent.ixHeldOwner:GetActiveWeapon():DropObject()
						end

						PotEnt:Setup(ent:GetData("cook_level", 0),ent:GetData("acetone", 0),ent:GetData("bismuth", 0),ent:GetData("hydrogen", 0),ent:GetData("phosphoric", 0))
						PotEnt.BurnerIndex = 3
						self:Set3BurnEnt(PotEnt)
						ent:Remove()


						self.NextTouchCheck = CurTime() + 0.1
					elseif (!self:Get4BurnEnt()) or (self:Get4BurnEnt() == NULL) then

						local PotEnt = ents.Create("j_setorianmeth_pot");
						PotEnt:SetPos(self:GetPos()+(self:GetRight()*7)+(self:GetUp()*46.1)+(self:GetForward()*8) )
						PotEnt:SetAngles(self:GetAngles())
						PotEnt:SetParent(self)
						PotEnt:Spawn();

						-- ent:SetPos(self:GetPos()+(self:GetRight()*-8)+(self:GetUp()*48)+(self:GetForward()*-8))
						-- ent:SetAngles(Angle(0,0,0))

						if (ent.ixHeldOwner) then
							ent.ixHeldOwner:GetActiveWeapon():DropObject()
						end

						PotEnt:Setup(ent:GetData("cook_level", 0),ent:GetData("acetone", 0),ent:GetData("bismuth", 0),ent:GetData("hydrogen", 0),ent:GetData("phosphoric", 0))
						PotEnt.BurnerIndex = 4
						self:Set4BurnEnt(PotEnt)
						ent:Remove()


						self.NextTouchCheck = CurTime() + 0.1
					end
					-- elseif (!self:Get2BurnEnt()) or (self:Get2BurnEnt() == NULL) then
					-- 	ent:SetPos(self:GetPos()+(self:GetRight()*-8)+(self:GetUp()*48)+(self:GetForward()*8))
					-- 	ent:SetAngles(Angle(0,0,0))

					-- 	if (ent.ixHeldOwner) then
					-- 		ent.ixHeldOwner:GetActiveWeapon():DropObject()
					-- 	end

					-- 	self:Set2BurnEnt(ent)

					-- 	self.NextTouchCheck = CurTime() + 0.1
					-- elseif (!self:Get3BurnEnt()) or (self:Get3BurnEnt() == NULL) then
					-- 	ent:SetPos(self:GetPos()+(self:GetRight()*7)+(self:GetUp()*48)+(self:GetForward()*-8))
					-- 	ent:SetAngles(Angle(0,0,0))

					-- 	if (ent.ixHeldOwner) then
					-- 		ent.ixHeldOwner:GetActiveWeapon():DropObject()
					-- 	end

					-- 	self:Set3BurnEnt(ent)

					-- 	self.NextTouchCheck = CurTime() + 0.1
					-- elseif (!self:Get4BurnEnt()) or (self:Get4BurnEnt() == NULL) then
					-- 	ent:SetPos(self:GetPos()+(self:GetRight()*7)+(self:GetUp()*48)+(self:GetForward()*8))
					-- 	ent:SetAngles(Angle(0,0,0))

					-- 	if (ent.ixHeldOwner) then
					-- 		ent.ixHeldOwner:GetActiveWeapon():DropObject()
					-- 	end

					-- 	self:Set4BurnEnt(ent)

					-- 	self.NextTouchCheck = CurTime() + 0.1
					-- end
				end
			end
		end
	end

end

function ENT:CheckBurner1()

	local traceF1 = {}
	traceF1.start = self:GetPos()+(self:GetRight()*-6.5)+(self:GetUp()*39.5)+(self:GetForward()*-6.5)
	traceF1.endpos = self:GetPos()+(self:GetRight()*-6.5)+(self:GetUp()*41)+(self:GetForward()*-6.5)
	traceF1.filter = self

	local traceFire1 = util.TraceLine(traceF1)

	if (traceFire1.Hit) and (traceFire1.Entity) and (IsValid(traceFire1.Entity)) then

		if (traceFire1.Entity:GetClass() == "ix_item") then
			local itemTable = traceFire1.Entity:GetItemTable()

			if (itemTable.uniqueID == "meth_pot") then
				return traceFire1.Entity
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end 

end

function ENT:CheckBurner2()

	local traceF1 = {}
	traceF1.start = self:GetPos()+(self:GetRight()*-6.5)+(self:GetUp()*39.5)+(self:GetForward()*7)
	traceF1.endpos = self:GetPos()+(self:GetRight()*-6.5)+(self:GetUp()*41)+(self:GetForward()*7)
	traceF1.filter = self

	local traceFire1 = util.TraceLine(traceF1)

	if (traceFire1.Hit) and (traceFire1.Entity) and (IsValid(traceFire1.Entity)) then

		if (traceFire1.Entity:GetClass() == "ix_item") then
			local itemTable = traceFire1.Entity:GetItemTable()

			if (itemTable.uniqueID == "meth_pot") then
				return traceFire1.Entity
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end 

end

function ENT:CheckBurner3()

	local traceF1 = {}
	traceF1.start = self:GetPos()+(self:GetRight()*6.25)+(self:GetUp()*39.5)+(self:GetForward()*-6.5)
	traceF1.endpos = self:GetPos()+(self:GetRight()*6.25)+(self:GetUp()*41)+(self:GetForward()*-6.5)
	traceF1.filter = self

	local traceFire1 = util.TraceLine(traceF1)

	if (traceFire1.Hit) and (traceFire1.Entity) and (IsValid(traceFire1.Entity)) then

		if (traceFire1.Entity:GetClass() == "ix_item") then
			local itemTable = traceFire1.Entity:GetItemTable()

			if (itemTable.uniqueID == "meth_pot") then
				return traceFire1.Entity
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end 

end

function ENT:CheckBurner4()

	local traceF1 = {}
	traceF1.start = self:GetPos()+(self:GetRight()*6.25)+(self:GetUp()*39.5)+(self:GetForward()*7)
	traceF1.endpos = self:GetPos()+(self:GetRight()*6.25)+(self:GetUp()*41)+(self:GetForward()*7)
	traceF1.filter = self

	local traceFire1 = util.TraceLine(traceF1)

	if (traceFire1.Hit) and (traceFire1.Entity) and (IsValid(traceFire1.Entity)) then

		if (traceFire1.Entity:GetClass() == "ix_item") then
			local itemTable = traceFire1.Entity:GetItemTable()

			if (itemTable.uniqueID == "meth_pot") then
				return traceFire1.Entity
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end 

end

function ENT:BurnerChange(bNumber)
	if (bNumber == "1") then
		self:Set1BurnerOn(!self:Get1BurnerOn())
	elseif (bNumber == "2") then
		self:Set2BurnerOn(!self:Get2BurnerOn())
	elseif (bNumber == "3") then
		self:Set3BurnerOn(!self:Get3BurnerOn())
	elseif (bNumber == "4") then
		self:Set4BurnerOn(!self:Get4BurnerOn())
	end
	self:EmitSound("ambient/fire/mtov_flame2.wav")
end

function ENT:OnOptionSelected(client, option, data)

	if (option == "Burner #1 [On/Off]") then
		self:BurnerChange("1")
	elseif (option == "Burner #2 [On/Off]") then
		self:BurnerChange("2")
	elseif (option == "Burner #3 [On/Off]") then
		self:BurnerChange("3")
	elseif (option == "Burner #4 [On/Off]") then
		self:BurnerChange("4")
	end

end

function ENT:OnRemove()


end
