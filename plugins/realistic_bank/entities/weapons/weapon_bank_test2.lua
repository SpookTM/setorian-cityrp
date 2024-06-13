AddCSLuaFile()

local PLUGIN = PLUGIN

SWEP.PrintName				= "bank test2"
SWEP.Author					= "JohnyReaper"
SWEP.Purpose				= ""
SWEP.Category				= "IX: Banking"

SWEP.Slot					= 0
SWEP.SlotPos				= 1

SWEP.ViewModel				= Model( "" )
SWEP.WorldModel				= Model( "" )
SWEP.ViewModelFOV			= 70
SWEP.UseHands				= false
SWEP.HoldType				= "normal"


SWEP.EMPEnt					= "j_hl2_cd_hl2door_base"
SWEP.PreviewModel 			= "models/props_combine/combine_door01.mdl"

SWEP.Spawnable = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.DrawAmmo				= false

SWEP.IsAlwaysLowered = true
SWEP.FireWhenLowered = true


local SwingSound = Sound( "WeaponFrag.Throw" )

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()
	if ( game.SinglePlayer() ) then self:CallOnClient( "PrimaryAttack" ) end

	if (SERVER) then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end	


		
				if (SERVER) then
					
					local entity = tr.Entity

					if (IsValid(entity)) then
						if entity:GetClass() == "j_banking_atm" then
							print("!! DZAIALA !!")
						end
					end
				end

				-- self:Remove()
		
	-- end

end

function SWEP:SecondaryAttack()

end
