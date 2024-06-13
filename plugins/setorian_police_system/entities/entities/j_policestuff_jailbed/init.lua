AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/props/de_inferno/bed.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self.SearchCoolDown = CurTime()

	self.IsSearching = false

	self.NextTick = CurTime()

	PLUGIN:SaveJRPrisonBeds()

end

function ENT:Think()

	if (self.IsSearching) then

		if (self.NextTick < CurTime()) then

			self:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav")

			self.NextTick = CurTime() + (math.random(2,6)/10)
		end

	end

end

function ENT:Use(client) 

	if (!client:Alive()) then return end

	if (!client:GetCharacter()) then return end

	local char = client:GetCharacter()

	if (self.SearchCoolDown > CurTime()) then 
		client:Notify("You have to wait before you can search again")
	return end

	self.IsSearching = true

	client:SetAction("Searching...", 30)

	client:DoStaredAction(self, function()

		self:EmitSound("physics/cardboard/cardboard_box_break3.wav", 65)
		self.IsSearching = false

		-- if (math.random() > 0.5) then
			self:RandomItems(client,char)
		-- else
		-- 	client:Notify("You didn't find anything")
		-- end


		self.SearchCoolDown = CurTime() + 3600

	end, 30, function()
		client:SetAction()
		self.IsSearching = false
	end)


end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRPrisonBeds()
	end
end

function ENT:RandomItems(client,char)


	local FoundItems = PLUGIN.Contraband

	local chance = math.random(1, 100)

	local RandomItems = {}

	for k, v in pairs(FoundItems) do
		if (v >= chance) then
			RandomItems[k] = true
		end
	end

	if (table.IsEmpty(RandomItems)) then
		client:Notify("You didn't find anything")
		return false
	end

	local DrawItem = table.Random(RandomItems)

	local inv = char:GetInventory()

	if (!inv:Add(DrawItem)) then
        ix.item.Spawn(DrawItem, client)
    end


	client:Notify("You have found contraband")

end