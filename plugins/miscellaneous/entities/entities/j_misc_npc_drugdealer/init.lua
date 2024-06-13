AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize() --This function is run when the entity is created so it's a good place to setup our entity.
 
	
	self:SetModel( "models/Humans/Group03/male_03.mdl" ) -- Sets the model of the NPC.
	self:SetHullType( HULL_HUMAN ) -- Sets the hull type, used for movement calculations amongst other things.
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX ) -- This entity uses a solid bounding box for collisions.
	self:CapabilitiesAdd( CAP_ANIMATEDFACE ) -- Adds what the NPC is allowed to do ( It cannot move in this case ).
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE ) -- Makes the ENT.Use hook only get called once at every use.
	self:DropToFloor()
	
	self:SetMaxYawSpeed( 90 ) --Sets the angle by which an NPC can rotate at once.

	self:ResetSequence( ACT_IDLE )
	-- PLUGIN:SaveJREqNPC()


	self:SetDealerName("John Doe")
	self:SetDealerPrice(100)
	self:SetDespawnTime(CurTime() + (ix.config.Get("DealerDespawn", 10)*60))
	-- self.LookingItem = "cocaine_brick"
	self:SetDealerType("")
	self:SetDealerTypeName("Nothing")
	-- self.LookingForPly = Entity(1)
	self:SetLookingForPly(NULL)

	self.Despawn = false
	self.CoolDown = CurTime()

end

function ENT:Think()

	if (self:GetDespawnTime() > 0) and (!self.Despawn) then
		if (CurTime() > self:GetDespawnTime()) then
			self.Despawn = true
			self:Remove()
		end
	end

end

function ENT:OnRemove()

	if (self:GetLookingForPly()) and (self:GetLookingForPly() != NULL) then
		self:GetLookingForPly().DealerCalled = false
	end

	if (self.dealerID) and (PLUGIN.Dealers[self.dealerID].CoolDown) then
		PLUGIN.Dealers[self.dealerID].CoolDown = nil
	end

	if (self.SpawnID) and (PLUGIN.DealersSpawns[self.SpawnID].CoolDown) then
		PLUGIN.DealersSpawns[self.SpawnID].CoolDown = nil
	end

	if (PLUGIN.SpawnedDealers) and (PLUGIN.SpawnedDealers[self]) then
		PLUGIN.SpawnedDealers[self] = nil
	end

end

function ENT:AcceptInput( Name, Activator, Caller )	

	if Name == "Use" and Caller:IsPlayer() then

		if (Caller:isPolice()) then
			if (self.CoolDown > CurTime()) then return end
			self:NoSound()
			PLUGIN:DealerSays(self, "Alright, I'm on my way and I'm not going to hang around here, officer.")
			self.CoolDown = CurTime() + 5

			timer.Simple(2, function()
				if (!self) or (!IsValid(self)) then return end
				self:Remove()
			end)

			return
		end

		if (Caller != self:GetLookingForPly()) then
			if (self.CoolDown > CurTime()) then return end
			self:NoSound()
			PLUGIN:DealerSays(self, "What are you looking for here? Go away, I'm waiting for someone")
			self.CoolDown = CurTime() + 2
			return
		end

		local char = Caller:GetCharacter()
		local inv = char:GetInventory()
		local client = Caller
		
		if (self:GetDealerType() != "") then

			client:SetAction("Selling...", 1)
			client:DoStaredAction(self, function()
				
				local item = inv:HasItem(self:GetDealerType())

				if (item) then

					local howManySold = 0
					local EarnedMoney = 0

					// item:GetData("BrickCount", 10)  item:GetData("quantity", 5) self:GetData("leavesCount", 1)

					for k, v in ipairs(inv:GetItemsByUniqueID(self:GetDealerType())) do
						howManySold = howManySold + 1

						local MoneyAdd = self:GetDealerPrice()

						if (v:GetData("BrickCount", 0) != 0) then
							MoneyAdd = MoneyAdd * (v:GetData("BrickCount", 1))
						end

						if (v:GetData("leavesCount", 0) != 0) then
							MoneyAdd = MoneyAdd * (v:GetData("leavesCount", 1))
						end

						if (v:GetData("quantity", 0) != 0) then
							MoneyAdd = MoneyAdd * (v:GetData("quantity", 1))
						end

						EarnedMoney = EarnedMoney + MoneyAdd
						v:Remove()
					end

					self:SellSound()

					PLUGIN:DealerSays(self, "Excellent. Here's your cash for goods. It's good doing business with you.")

					char:SetMoney(char:GetMoney() + EarnedMoney)
					client:Notify("You have earned "..ix.currency.Get(EarnedMoney))

				else

					PLUGIN:DealerSays(self, "You don't have the goods I'm looking for. Bring it before while I'm still here and don't waste my time.")
					self:NoSound()

				end

				self.CoolDown = CurTime() + 1
			end, 1, function()
				client:SetAction()
				self.CoolDown = CurTime() + 1
			end)

		else

			self:NoSound()
		end


	end
end


function ENT:SellSound()

	local itemsound = {
	"vo/npc/male01/yeah02.wav",
	"vo/npc/male01/finally.wav",
	"vo/npc/male01/nice.wav",
	"vo/npc/male01/fantastic01.wav",
	"vo/npc/male01/fantastic02.wav",
	"vo/npc/male01/question10.wav",
	"vo/npc/male01/yougotit02.wav",
	"vo/npc/male01/question31.wav",
	}

	self:EmitSound(itemsound[ math.random( #itemsound ) ])
end

function ENT:NoSound()
	local badly = {
	"vo/npc/male01/excuseme02.wav",
	"vo/npc/male01/ohno.wav",
	"vo/npc/male01/answer05.wav",
	"vo/npc/male01/answer09.wav",
	"vo/npc/male01/answer10.wav",
	"vo/npc/male01/answer19.wav",
	"vo/npc/male01/waitingsomebody.wav",
	}

	self:EmitSound(badly[ math.random( #badly ) ])

end