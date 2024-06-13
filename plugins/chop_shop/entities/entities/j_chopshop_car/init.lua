AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/props_vehicles/car004a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end
	
	self:SetMainProgress(100)
	self:SetCurrentProgress(0)

	self:SetDestroyFade(false)
	
	self.PrevSide = nil

	self.SlideMult = 0
	self.SlideMax = 0
	self.SlideLetter = nil

	self.MainProgressDelay = CurTime()

	self.StuckerWait = 15
	self.PointStucker = CurTime() + self.StuckerWait

	-- timer.Simple(0, function()
		-- if (!self) or (!IsValid(self)) then return end
	self:SetupCar(Entity(1),"models/tdmcars/emergency/for_crownvic_fh3.mdl")
-- end)

end

function ENT:Think()

	if (self.PointStucker < CurTime()) then

		self:RandomPoint()

		self.PointStucker = CurTime() + self.StuckerWait
	end

end

function ENT:SetupCar(ply, carModel)

	self:SetDismantler(ply)
	ply:SetLocalVar("DismantleCar", self:EntIndex())

	self:SetModel(carModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self:RandomPoint()

end

function ENT:OnTakeDamage(dmginfo)

	if (dmginfo:GetInflictor()) and (dmginfo:GetInflictor():IsPlayer()) and (dmginfo:GetInflictor() == self:GetDismantler()) and (dmginfo:GetInflictor():GetActiveWeapon():GetClass() == "arccw_blowtorch") then
	if (self:IsNearDismantlePoint(dmginfo:GetDamagePosition())) then
			self:SetCurrentProgress(self:GetCurrentProgress() + math.random(2,5))

			self.PointStucker = CurTime() + self.StuckerWait

			dmginfo:GetInflictor():EmitSound("ambient/energy/weld"..math.random(1,2)..".wav", 55, 100, 0.25)

			if (math.random() > 0.75) then
				dmginfo:GetInflictor():EmitSound("ambient/energy/newspark0"..math.random(1,9)..".wav")
			end
			
			if (self.SlideMult != 0) then

				local modelboundsMin, modelboundsMax = self:GetModelBounds()

				local modelOBBmin = self:OBBMins()
				local modelOBBmax = self:OBBMaxs()

				local correctX = (modelOBBmax.x - modelOBBmin.x)/3

				if ((self:GetCurProgresPos().x > (modelboundsMin.x+correctX)) and (self:GetCurProgresPos().x < (modelboundsMax.x-correctX)) and (self.SlideLetter == "x"))
				or ((self:GetCurProgresPos().y > (modelboundsMin.y+20)) and (self:GetCurProgresPos().y < (modelboundsMax.y-20)) and (self.SlideLetter == "y")) then

					local newSlide = math.random(1,3) * self.SlideMult
					local newVector = self:GetCurProgresPos() + Vector((self.SlideLetter == "x" and newSlide) or 0, (self.SlideLetter == "y" and newSlide) or 0,0)
					-- print( self:GetCurProgresPos())
					self:SetCurProgresPos(newVector)

				end

			end	

			if (self:GetCurrentProgress() >= 100) then
				self:MainProgressIncrease()
			end
		end
	end

end

function ENT:DestroyCar()

	local items = {}
	items["cardoor"] = 2
	items["carengine"] = 1
	items["cartire"] = 4
	items["carexhaust"] = 1

	local char = self:GetDismantler():GetCharacter()

	local entity = ents.Create("ix_shipment")
	entity:Spawn()
	entity:SetPos(self:GetPos() + self:GetUp() * 20 )
	entity:SetItems(items)
	entity:SetNetVar("owner", char:GetID())

	constraint.NoCollide(self, entity)

	local shipments = char:GetVar("charEnts") or {}
	table.insert(shipments, entity)
	char:SetVar("charEnts", shipments, true)

	

end

function ENT:MainProgressIncrease()

	if (self.MainProgressDelay < CurTime()) then

		self:SetMainProgress(self:GetMainProgress() - math.random(25,55))

		if (self:GetMainProgress() <= 0) and (!self:GetDestroyFade()) then

			self:SetDestroyFade(true)

			self:GetDismantler():Notify("You have successfully dismantled the vehicle")

			timer.Simple(1, function()
				if (!self) or (!IsValid(self)) then return end
				self:DestroyCar()
				self:Remove()
			end)
			

		else
			self:SetCurrentProgress(0)
			self:RandomPoint()

		end

		self:EmitSound("ambient/machines/pneumatic_drill_"..math.random(1,4)..".wav")

		self.MainProgressDelay = CurTime() + 0.2
	end

end

function ENT:IsNearDismantlePoint(checkPos)

	local dismantlePoint = self:LocalToWorld(self:GetCurProgresPos())

	if (math.abs(dismantlePoint.x - checkPos.x) < 20) and (math.abs(dismantlePoint.y - checkPos.y) < 20) and (math.abs(dismantlePoint.z - checkPos.z) < 20) then
		return true
	else
		return false
	end

	return false
end

function ENT:RandomPoint()

	local modelboundsMin, modelboundsMax = self:GetModelBounds()
	local modelOBBmin = self:OBBMins()
	local modelOBBmax = self:OBBMaxs()
	local modelOBBCenter = self:OBBCenter()

	local extraConfig

	local corXMult = 2
	local corYMult = 2.1

	if (self.CarClass) then
		if (PLUGIN.SpecialConfig[self.CarClass]) then
			if (PLUGIN.SpecialConfig[self.CarClass].FABSidesOffset) then
				corXMult = PLUGIN.SpecialConfig[self.CarClass].FABSidesOffset or 2
			end
			if (PLUGIN.SpecialConfig[self.CarClass].LARSidesOffset) then
				corYMult = PLUGIN.SpecialConfig[self.CarClass].LARSidesOffset or 2.1
			end
		end
	end

	local correctX = (modelboundsMax.x - modelboundsMin.x)/corXMult
	local correctY = (modelboundsMax.y - modelboundsMin.y)/corYMult


	local randNum = math.random(1,4)

	local IsFront = (randNum == 1)-- and (self.PrevSide and self.PrevSide != "fs")
	local IsLeft = (randNum == 2) --and (self.PrevSide and self.PrevSide != "bs")
	local IsBack = (randNum == 3) --and (self.PrevSide and self.PrevSide != "rs")
	local IsRight = (randNum == 4) --and (self.PrevSide and self.PrevSide != "ls")

	local x, y = 0

	if ((IsFront) and (self.PrevSide == "fs")) then
		IsFront = false
		IsLeft = true
	elseif ((IsLeft) and (self.PrevSide == "ls")) then
		IsLeft = false
		IsBack = true
	elseif ((IsBack) and (self.PrevSide == "bs")) then
		IsBack = false
		IsRight = true
	elseif (IsRight) and (self.PrevSide == "rs") then
		IsRight = false
		IsFront = true
	end

	if (IsFront) or (IsBack) then
		y = (IsBack and  modelboundsMin.y+10) or modelboundsMax.y-10
		x = math.random(modelboundsMin.x+correctX , modelboundsMax.x-correctX )
		self.PrevSide = (IsBack and "bs") or "fs"
		self.SlideLetter = "x"
	elseif (IsLeft) or (IsRight) then
		x = (IsRight and modelboundsMin.x+correctY) or modelboundsMax.x-correctY
		y = math.random(modelboundsMin.y + 10, modelboundsMax.y - 10)
		self.PrevSide = (IsRight and "rs") or "ls"
		self.SlideLetter = "y"
	end

	local zCenter = modelboundsMax.z-modelboundsMin.z--self:OBBCenter().z

	local newVector = Vector(x,y,modelOBBCenter.z)--modelboundsMax.z-modelboundsMin.z)

	self.SlideMult = math.random(-1,1)

	self.LerpedPoint = newVector
	self:SetCurProgresPos(newVector)

end