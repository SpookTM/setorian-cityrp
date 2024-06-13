if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

if (CLIENT) then
	SWEP.Slot = 5;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "";
	SWEP.DrawCrosshair = false;
end

SWEP.Author					= "JohnyReaper"
SWEP.Instructions 			= "";
SWEP.Purpose 				= "";
SWEP.Contact 				= ""

SWEP.Category				= "" 
SWEP.Slot					= 5
SWEP.SlotPos				= 5
SWEP.Weight					= 5
SWEP.Spawnable     			= false
SWEP.AdminSpawnable			= false;
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ViewModel 				= "models/gmod4phun/c_contagion_gasmask.mdl"
SWEP.WorldModel 			= "models/gmod4phun/w_contagion_gasmask.mdl"
SWEP.HoldType 				= "normal"
SWEP.UseHands = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


function SWEP:Deploy()
	
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "take_off" ) )
	self.Owner:ViewPunch( Angle( 10,0,0 ) )


end

function SWEP:Holster()
	return true
end


function SWEP:OnRemove()
	return true
end


function SWEP:PrimaryAttack()
	return false
end;


function SWEP:SecondaryAttack()
	return false
end