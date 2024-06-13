
AddCSLuaFile()

SWEP.PrintName = "Fishing Rod" -- change the name
SWEP.Author = "sterlingpierce"

SWEP.Category = "Sterling Pierce" -- change the name

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/sterling/spook_c_fishingrod.mdl" ) -- just change the model 
SWEP.WorldModel = ( "models/sterling/spook_w_fishingrod.mdl" )
SWEP.ViewModelFOV = 85
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"

SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "pistol"
function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
      return true
end

function SWEP:PrimaryAttack()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end 

function SWEP:SecondaryAttack()
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
end

function SWEP:Reload()
	self.Weapon:SendWeaponAnim( ACT_VM_FIDGET )
end