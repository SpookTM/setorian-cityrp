AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/props_c17/cashregister01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self:SetOwnerCharID(0)
	self:SetBankID(0)

	self:SetFunds(0)  // Max 5000
	self:SetIsLock(true)

	self.IsStealing = false
	self.StealSound = CurTime()
	self.StealCoolDown = CurTime()

	self.Permissions = {
		-- [1] = {
		-- 	OwnerName = "John DOe",
		-- 	CanSetPrice = true,
		-- 	CanTakeFunds = true,
		-- 	CanAddItems = false,
		-- 	CanAddStock = true,
		-- 	CanRemoveItem= false,
		-- },
	}

	--[[ [CoOwnerID] = {
		OwnerName = 
		CanSetPrice = 01
		CanTakeFunds
		CanAddItems
		CanAddStock
		CanRemoveItem
	}--]] 

	self.ItemsInside = {}
		-- ["pistol"] = {
		-- 	IName = "Test Name",
		-- 	IDesc = "Test Desc",
		-- 	IModel = "models/props_c17/FurnitureCouch001a.mdl",
		-- 	IPrice = 250,
		-- 	IStock = 1,
		-- }
	-- }

	self.StealSounds = {
		"weapons/357/357_reload1.wav", "weapons/357/357_reload3.wav", "weapons/357/357_reload4.wav"
	}
	PLUGIN:SaveJRCash()
end

function ENT:Think()

	if (self.IsStealing) and (self.StealSound < CurTime()) then

		self:EmitSound(self.StealSounds[ math.random( #self.StealSounds ) ])
		self.StealSound = CurTime() + math.random(0.6, 1.2)

	end

end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRCash()
	end
end

function ENT:OnOptionSelected(client, option, data)

	if (option == "Open UI") then

		if (self:GetOwnerCharID() == 0) then
			self:SetOwnerCharID(client:GetCharacter():GetID())
		end

		net.Start("ixBCashR_OpenUI")
			net.WriteEntity(self)
			PLUGIN:SentNetTable(self.ItemsInside)
			PLUGIN:SentNetTable(self.Permissions)
			-- net.WriteString(self:GetPermissions())
			-- net.ReadBool(self:GetIsLock())
			-- net.WriteUInt(self:GetFunds(), 13)
		net.Send(client)

	elseif (option == "Steal") then

		local char = client:GetCharacter()

		if (char:GetID() == self:GetOwnerCharID()) or (self.Permissions[char:GetID()]) then
			client:Notify("You can't rob the cash register that you're managing.")
			return
		end

		if (self.StealCoolDown > CurTime()) then
			client:Notify("The cash register was already robbed some time ago. Try again later")
			return
		end

		self.IsStealing = true

		ix.chat.Send(client, "me", "starts robbing the cash register")

		client:SetAction("Stealing...", 5)

        client:DoStaredAction(self, function()
				
			local randomFunds = math.random(math.max(self:GetFunds()-100,0),self:GetFunds())

			client:Notify("You robbed the cash register")

			client:GetCharacter():SetMoney(client:GetCharacter():GetMoney() + randomFunds)
			self:SetFunds(self:GetFunds() - randomFunds)

			self:EmitSound("physics/metal/metal_box_break1.wav", 65)

			self.StealCoolDown = CurTime() + 300

			
			self.IsStealing = false
		end, 5, function()
			client:SetAction()
			self.IsStealing = false
		end)

	end
end

-- function ENT:Use( act, call)

	-- if (call:IsPlayer()) then

	-- 	net.Start("ixBCashR_OpenUI")
	-- 		net.WriteEntity(self)
	-- 		PLUGIN:SentNetTable(self.ItemsInside)
	-- 		PLUGIN:SentNetTable(self.Permissions)
	-- 		-- net.WriteString(self:GetPermissions())
	-- 		-- net.ReadBool(self:GetIsLock())
	-- 		-- net.WriteUInt(self:GetFunds(), 13)
	-- 	net.Send(call)

	-- end

-- end