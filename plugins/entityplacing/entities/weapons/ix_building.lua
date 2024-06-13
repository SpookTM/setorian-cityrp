
AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Construction"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Category = "Helix"
SWEP.Author = "pedro.santos53"
SWEP.Instructions = "Primary Fire: Spin object clockwise.\nSecondary Fire: Spin object counter-clockwise.\nReload: Place object.\nPress USE on placed object to replace."
SWEP.Purpose = "Placing selected furniture from your inventory into the world."
SWEP.Drop = false

SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewTranslation = 4

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 0.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Delay = 0.5

SWEP.ViewModel = Model("models/weapons/c_arms_citizen.mdl")
SWEP.WorldModel = ""

SWEP.UseHands = false
SWEP.LowerAngles = Angle(0, 5, -14)
SWEP.LowerAngles2 = Angle(0, 5, -19)

SWEP.FireWhenLowered = true
SWEP.HoldType = "fist"

SWEP.furnitureyaw = 0

-- luacheck: globals ACT_VM_FISTS_DRAW ACT_VM_FISTS_HOLSTER
ACT_VM_FISTS_DRAW = 3
ACT_VM_FISTS_HOLSTER = 2

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	self.lastHand = 0
end

if (CLIENT) then
	function SWEP:PreDrawViewModel(viewModel, weapon, client)
		local hands = player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(client:GetModel()))

		if (hands and hands.model) then
			viewModel:SetModel(hands.model)
			viewModel:SetSkin(hands.skin)
			viewModel:SetBodyGroups(hands.body)
		end
	end

	function SWEP:DoDrawCrosshair(x, y)
		surface.SetDrawColor(255, 255, 255, 66)
		surface.DrawRect(x - 2, y - 2, 4, 4)
	end
end

function SWEP:Deploy()
	if (!IsValid(self:GetOwner())) then
		return
	end

	self:ReleaseGhostEntity()
	return true
end

function SWEP:MakeGhostFurniture( model, pos, angle )

	util.PrecacheModel( model )

	if ( SERVER && !game.SinglePlayer() ) then return end
	if ( CLIENT && game.SinglePlayer() ) then return end

	if ( !IsFirstTimePredicted() ) then return end

	self:ReleaseGhostEntity()

	if ( !util.IsValidProp( model ) ) then return end

	if ( CLIENT ) then
		self.GhostEntity = ents.CreateClientProp( model )
	else
		self.GhostEntity = ents.Create( "prop_physics" )
	end

	if ( !IsValid( self.GhostEntity ) ) then
		self.GhostEntity = nil
		return
	end

	self.GhostEntity:SetModel( model )
	self.GhostEntity:SetPos( pos )
	self.GhostEntity:SetAngles( angle )
	self.GhostEntity:Spawn()

	self.GhostEntity:SetSolid( SOLID_VPHYSICS )
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true )
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.GhostEntity:SetMaterial("models/wireframe")
	self.GhostEntity:SetColor( Color( 255, 255, 255, 150 ) )

end

function SWEP:ReleaseGhostEntity()

	if ( self.GhostEntity ) then
		if ( !IsValid( self.GhostEntity ) ) then self.GhostEntity = nil return end
		self.GhostEntity:Remove()
		self.GhostEntity = nil
	end

	if ( self.GhostEntities ) then

		for k,v in pairs( self.GhostEntities ) do
			if ( IsValid( v ) ) then v:Remove() end
			self.GhostEntities[ k ] = nil
		end

		self.GhostEntities = nil
	end

	if ( self.GhostOffset ) then

		for k,v in pairs( self.GhostOffset ) do
			self.GhostOffset[ k ] = nil
		end

	end

end

function SWEP:UpdateGhostEntity( ent, client )
	if ( !ent or !ent:IsValid() ) then return end

	local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + (client:GetAimVector() * 200)
		data.filter = client
	local trace = util.TraceLine(data)

	if (!trace.Hit or trace.Entity:IsPlayer() ) then
		ent:SetNoDraw( true )
		return
	end

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles(Angle(360, self.furnitureyaw or 0, 0))

	ent:SetNoDraw( false )
end

function SWEP:Think()

	if self:GetOwner() and self:GetOwner():GetActiveWeapon() and (self:GetOwner():GetActiveWeapon():GetClass() == "ix_building") then
		if (!self.GhostEntity or !self.GhostEntity:IsValid() or (self.GhostEntity and IsValid(self.GhostEntity) and (self.GhostEntity:GetModel() != self:GetOwner():GetLocalVar("furniture", nil)))) then
			
			local model = self:GetOwner():GetLocalVar("furniture", nil)
		
			if model != nil then
				self:MakeGhostFurniture( model["model"], Vector(0,0,0), Angle(0,0,0) )
			end
		end

		self:UpdateGhostEntity( self.GhostEntity, self:GetOwner() )
	else
		self:ReleaseGhostEntity()
		self:Remove()
	end
end

function SWEP:Holster()
	if (!IsFirstTimePredicted() or CLIENT) then
		return
	end
	
	self:ReleaseGhostEntity()
	return true
end

function SWEP:OnRemove()
	self:ReleaseGhostEntity()
end

function SWEP:PrimaryAttack()
	if (!IsFirstTimePredicted()) then
		return
	end

	if (self:GetOwner():GetLocalVar("furniture", false)) then
		self.furnitureyaw = self.furnitureyaw + 1
	end
end

function SWEP:SecondaryAttack()
	if (!IsFirstTimePredicted()) then
		return
	end

	if (self:GetOwner():GetLocalVar("furniture", false)) then
		self.furnitureyaw = self.furnitureyaw - 1
	end
end

function SWEP:Reload()
	if (!IsFirstTimePredicted()) then
		return
	end

	if ((self.placeTime or 0) < CurTime()) and (self:GetOwner():GetLocalVar("furniture", false)) and IsValid(self.GhostEntity) then
		
		if CLIENT then
			net.Start("CreateFurniture")
				net.WriteString( self.GhostEntity:GetModel() )
				net.WriteVector( self.GhostEntity:GetPos() )
				net.WriteAngle( self.GhostEntity:GetAngles() )
				net.WriteBool( self.GhostEntity:GetNoDraw() )
			net.SendToServer()
		end

		self:ReleaseGhostEntity()

		self.placeTime = CurTime() + 2
	end
end