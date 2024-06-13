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

	-- self:ResetSequence( "idle" )
	PLUGIN:SaveJRGarageNPC()
end


function ENT:AcceptInput( Name, Activator, Caller )	

	if Name == "Use" and Caller:IsPlayer() and Caller:isPolice() then
		

		if (!Caller.PrepareCarData) then
			Caller:Notify("Preparing car data. Please wait")
			Caller.PrepareCarData = true
		end

		local CarsTable = PLUGIN:PrepareCarVendorData()


		-- local TblToJson = util.TableToJSON(CarsTable)
		-- net.WriteString(TblToJson)

		if (CarsTable) then
			timer.Simple(0.1, function()

				net.Start("ixPoliceSys_OpenGarageUI")

				net.WriteUInt(#CarsTable, 6)

				for k, v in ipairs(CarsTable) do
					
					net.WriteString(v.CarModel)
					net.WriteString(v.CarName)
					net.WriteBool(v.CarTaken)

				end

				net.Send(Caller)

			end)
		end
 		
		self:Talker()


	
	end
end


function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRGarageNPC()
	end
end

function ENT:Talker()
	self:EmitSound("vo/npc/male01/hi0"..math.random(1,2)..".wav")
end
