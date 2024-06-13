SWEP.Author			= "Ross Cattero"
SWEP.Purpose		= "For making TV stories"
SWEP.Instructions	= "When in hands - you'll start streaming on your channel"
SWEP.Category		= "TV"

SWEP.HoldType		= "rpg"
SWEP.AnimPrefix	 = "rpg"
SWEP.ViewTranslation = 4
SWEP.IsAlwaysRaised = true;

SWEP.ViewModel		= ""
SWEP.WorldModel		= "models/weapons/w_camera.mdl"

SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo	= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo	= "none"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	ZoomLevel = 0
end

function SWEP:Precache()
	util.PrecacheModel( SWEP.WorldModel )
end

function SWEP:Reload()
	ZoomLevel = 0
	return true
end

function SWEP:PrimaryAttack()
   return false;
end

function SWEP:SecondaryAttack()
	return false;
end

function SWEP:HUDShouldDraw( name )
	if (name == "CHudHealth") then return false end
	if (name == "CHudSuitPower") then return false end
	if (name == "CHudBattery") then return false end
	if (name == "CHudCrosshair") then return false end
	if (name == "CHudAmmo") then return false end
	if (name == "CHudSecondaryAmmo") then return false end
	if (name == "CHudChat") then return false end
	if (name == "CHudDeathNotice") then return false end
	if (name == "CHudTrain") then return false end
	if (name == "CHudMessage") then return false end
	if (name == "CHudVoiceStatus") then return false end
	if (name == "CHudVoiceSelfStatus") then return false end
	if (name == "CHudDamageIndicator") then return false end
	if (name == "CAchievementNotificationPanel") then return false end
	if (name == "CHudSquadStatus") then return false end
	if (name == "CTargetID") then return false end
	return true
end

function SWEP:Holster()
	if self.Owner:IsPlayer() then
		self.Owner:SetCanZoom( true )
		ZoomLevel = 0
	end
	return true
end

function SWEP:OnRemove()
	if self.Owner:IsPlayer() then
		self.Owner:SetCanZoom( true )
		ZoomLevel = 0
	end
	return true
end