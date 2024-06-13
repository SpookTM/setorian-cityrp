
AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "debit card"
	SWEP.Slot = 0
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Author = "Chessnut"
SWEP.Instructions = "Primary Fire: Lock\nSecondary Fire: Unlock"
SWEP.Purpose = "Hitting things and knocking on doors."
SWEP.Drop = false

SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.ViewTranslation = 4

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 5
SWEP.Primary.Delay = 0.75

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""


SWEP.Spawnable				= true

SWEP.ViewModel = Model("models/weapons/c_arms_animations.mdl")
SWEP.WorldModel = ""

SWEP.UseHands = false
SWEP.LowerAngles = Angle(0, 5, -14)
SWEP.LowerAngles2 = Angle(0, 5, -22)

SWEP.IsAlwaysLowered = true
SWEP.FireWhenLowered = true
SWEP.HoldType = "passive"

-- luacheck: globals ACT_VM_FISTS_DRAW ACT_VM_FISTS_HOLSTER
ACT_VM_FISTS_DRAW = 2
ACT_VM_FISTS_HOLSTER = 1

function SWEP:Holster()
	if (!IsValid(self.Owner)) then
		return
	end

	local viewModel = self.Owner:GetViewModel()

	if (IsValid(viewModel)) then
		viewModel:SetPlaybackRate(1)
		viewModel:ResetSequence(ACT_VM_FISTS_HOLSTER)
	end

	return true
end

function SWEP:Precache()
end

-- function SWEP:SetupDataTables()
-- 	self:NetworkVar( "String", 0, "CardNumber" )
-- end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire(CurTime() + 1)

	if (!IsFirstTimePredicted()) then
		return
	end

	if (CLIENT) then
		return
	end

	local data = {}
		data.start = self.Owner:GetShootPos()
		data.endpos = data.start + self.Owner:GetAimVector()*96
		data.filter = self.Owner
	local entity = util.TraceLine(data).Entity

	if (IsValid(entity) and (entity:GetClass() == "j_banking_atm")) then
        
        print("Dziala checker")

		return
	end
end


function SWEP:SecondaryAttack()

    return
end

-- if (CLIENT) then

-- 	function SWEP:DoDrawCrosshair(x, y)
-- 		surface.SetDrawColor(255, 255, 255, 66)
-- 		surface.DrawRect(x - 2, y - 2, 4, 4)
-- 	end

-- 	local cardTexture = ix.util.GetMaterial("setorian_banking/setorian_debit_card_2.png")

-- 	function SWEP:FormatDigit(val)

-- 		local formated = ""
-- 		local words = string.Explode( "", val )
-- 		local newWords = {}

-- 		for k, v in pairs(words) do
			
-- 			newWords[#newWords + 1] = v

-- 			if (k%4 == 0) then
-- 				newWords[#newWords + 1] = " "
-- 			end

-- 		end

-- 		return table.concat(newWords)

-- 	end

-- 	function SWEP:DrawHUD()
		
-- 		surface.SetMaterial( cardTexture )
-- 		surface.SetDrawColor( 255, 255, 255 )
-- 		surface.DrawTexturedRect( ScrW()-350, ScrH()-178, 350, 178 )

-- 		draw.SimpleText(self:FormatDigit(self:GetCardNumber()), "BudgetLabel", ScrW()*0.825, ScrH()*0.92, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

-- 	end
-- end