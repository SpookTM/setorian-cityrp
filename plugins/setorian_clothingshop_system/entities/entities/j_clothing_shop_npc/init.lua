AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize() --This function is run when the entity is created so it's a good place to setup our entity.
 
	
	self:SetModel( "models/mossman.mdl" ) -- Sets the model of the NPC.
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
	PLUGIN:SaveJRClothingStoreNPC()
end


function ENT:AcceptInput( Name, Activator, Caller )	

	if Name == "Use" and Caller:IsPlayer() then

		local pacsData = Caller:GetCharacter():GetData("clothingstore_pacs", {})

		local compressed = util.Compress(util.TableToJSON(pacsData))
		local compressLen = #compressed

		net.Start("ixClothingShop_OpenUI")
			net.WriteUInt( compressLen, 16 )
			net.WriteData( compressed, compressLen )
		net.Send(Caller)

 		
		self:Talker()


	
	end
end


function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRClothingStoreNPC()
	end
end

function ENT:Talker()
	self:EmitSound("vo/npc/female01/hi0"..math.random(1,2)..".wav")
end
