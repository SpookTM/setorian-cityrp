AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/props_phx2/garbage_metalcan001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:StartMotionController()
	-- self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:SetMass(200)
		phys:SetDamping(0,100)
		phys:Wake()
		

	end

	self.Fish = false
	self.WaterChecker = 0
	

end

function ENT:Think()

	if (self.WaterChecker >= 100) then
		self:Remove()
	end

	if (!self:GetOwner()) or (!IsValid(self:GetOwner())) then
		self:Remove()
	end

	if (self:GetOwner()) and (IsValid(self:GetOwner())) and (self:GetOwner():GetActiveWeapon():GetClass() != "weapon_fishingrod") then
		self:Remove()
	end

	if (math.random() > 0.99) then
		self.Fish = !self.Fish
		if (self:GetOwner()) and (IsValid(self:GetOwner())) and (self:GetOwner():GetActiveWeapon():GetClass() == "weapon_fishingrod") then
			if (self.Fish) then
				self:GetOwner():GetActiveWeapon():SetRStr(math.random(5,15) * 10)
			else
				self:GetOwner():GetActiveWeapon():SetRStr(50)
			end
		end
	end

end

function ENT:Catch()

	if (!self:GetOwner()) or (!IsValid(self:GetOwner())) or (self:GetOwner():GetActiveWeapon():GetClass() != "weapon_fishingrod") then
		return false
	end

	local CatchChance = math.random()
	local PossibleFishes = {}

	for k,v in ipairs(PLUGIN.fishes) do

		if (v.FChance <= CatchChance) then
			PossibleFishes[#PossibleFishes+1] = string.lower(string.Replace(string.Replace(v.FName,"'", "")," ","_")) .. "_fish"
		end

	end
	
	if (table.IsEmpty(PossibleFishes)) then
		self:GetOwner():Notify("You didn't catch anything")
	else
		local randomFish = PossibleFishes[ math.random( #PossibleFishes ) ]
		self:GetOwner():Notify("You have caught a fish")

		local char = self:GetOwner():GetCharacter()
		local inv = char:GetInventory()

		if (!inv:Add(randomFish)) then
	        ix.item.Spawn(randomFish, self:GetOwner())
	    end

	end

end

function ENT:Yank( force )
	force = force or math.random( 50, 100 )
	self:GetPhysicsObject():AddVelocity( Vector( 0, 0, -force ) )
	self:EmitSound( "ambient/water/water_splash"..math.random(1,3)..".wav", 100, 255 )
	local data = EffectData()
	data:SetOrigin(self:GetPos())
	data:SetScale(force*0.01)
	util.Effect("WaterSplash", data)
end

function ENT:PhysicsSimulate(phys)
	local data = {}
	
	data.start = self:GetPos()
	data.endpos = self:GetPos()+Vector(0,0,((self.Fish and 0) or 5))
	data.filter = self
	data.mask = CONTENTS_WATER
	
	local trace = util.TraceLine(data)
	
	local invert_fraction = (trace.Fraction * -1 + 1)
	
	phys:SetDamping(invert_fraction*20, 100)
	phys:AddVelocity(Vector(0,0,20) * invert_fraction)
	-- self:AlignAngles(self:GetAngles(),Angle(0,0,0))
	if (trace.Hit) then
		if (math.abs(self:GetAngles().p) > 5) or (math.abs(self:GetAngles().r) > 5) then
			self:SetAngles(Angle(0,0,0))
		end
		self.WaterChecker = 0
	else
		self.WaterChecker = self.WaterChecker + 1
	end
	
	if (trace.Hit) and (math.random() > 0.99) then
		
		self:SetAngles(Angle(0,0,0))
		local data = EffectData()
		data:SetOrigin(trace.HitPos)
		data:SetScale(2)
		util.Effect("WaterRipple", data)
	

	end
end