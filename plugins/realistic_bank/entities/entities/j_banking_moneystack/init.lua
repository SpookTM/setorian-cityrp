AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")


function ENT:Initialize()

	self:SetModel("models/tobadforyou/cash_stack.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end


end


function ENT:Use(act, call)

	if (!call) then return end
	if (!call:Alive()) then return end
	if (!call:GetCharacter()) then return end

	local client = call
	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local foundBag = false

	for k, v in pairs(inv:GetItems()) do
		if (v.uniqueID != "duffelbag") then continue end

		if (v:getStacks() < 2) then
			foundBag = v
			break
		end
	end

	if (foundBag) then	

		self:EmitSound("physics/flesh/flesh_impact_hard4.wav")
		client:SetAction("Taking...", 1) -- for displaying the progress bar
		client:DoStaredAction(self, function()
			self:EmitSound("physics/cardboard/cardboard_box_break3.wav")
				
			foundBag:AddStack()

			client:Notify("You picked up a stack of money")

			self:Remove()
		end, 1, function()
			client:SetAction()
		end)

	else
		call:Notify("You don't have a duffel bag or all your bags are full")
	end

end

