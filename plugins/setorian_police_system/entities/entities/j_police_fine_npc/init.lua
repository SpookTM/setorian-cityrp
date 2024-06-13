AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize() --This function is run when the entity is created so it's a good place to setup our entity.
 
	
	self:SetModel( "models/gman_high.mdl" ) -- Sets the model of the NPC.
	self:SetHullType( HULL_HUMAN ) -- Sets the hull type, used for movement calculations amongst other things.
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX ) -- This entity uses a solid bounding box for collisions.
	self:CapabilitiesAdd( CAP_ANIMATEDFACE ) -- Adds what the NPC is allowed to do ( It cannot move in this case ).
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE ) -- Makes the ENT.Use hook only get called once at every use.
	self:DropToFloor()
	
	self:SetMaxYawSpeed( 90 ) --Sets the angle by which an NPC can rotate at once.

	PLUGIN:SaveJRTicketNPC()
end


function ENT:AcceptInput( Name, Activator, Caller )	

	if Name == "Use" and Caller:IsPlayer() then
		
		local char = Caller:GetCharacter()

		if (!char) then return end

		if (char:GetData("FineToPay")) and (!table.IsEmpty(char:GetData("FineToPay"))) then

			local AllFines = table.Count(char:GetData("FineToPay"))
			local FinesPayed = 0

			local HaveAllTickets = true

			local inv = char:GetInventory()

			local NewFineData = {}

			for k, v in ipairs(char:GetData("FineToPay")) do

				local PayData = {
					ticket_data = v,
				}

				local item = inv:HasItem("ticket", PayData)

				if (item) then

					local ticketAmount = item:GetData("ticket_price")

					if (char:GetMoney() >= ticketAmount) then

						-- NewFineData[k] = nil

						char:SetMoney(char:GetMoney() - ticketAmount)

						item:Remove()

						FinesPayed = FinesPayed + 1
					else
						NewFineData[#NewFineData+1] = v
						continue
					end

				else

					if (HaveAllTickets) then
						HaveAllTickets = false
					end

				end

			end

			if (FinesPayed > 0) then
				if (AllFines == FinesPayed) then
					Caller:Notify("You've paid all your tickets")
				else
					Caller:Notify("You paid off the "..FinesPayed.." tickets you could afford. "..(AllFines - FinesPayed).." are still waiting to be paid.")
				end
				char:SetData("FineToPay",NewFineData)
			else
				if (HaveAllTickets) then
					Caller:Notify("You can't afford to pay the fines")
				end
			end

			if (!HaveAllTickets) then
				Caller:Notify("One of your tickets was not found in your inventory")
			end

		else
			Caller:Notify("You don't have any fines to pay off")
		end
 		
		self:Talker()


	
	end
end


function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRTicketNPC()
	end
end

function ENT:Talker()
	self:EmitSound("vo/npc/male01/hi0"..math.random(1,2)..".wav")
end
