
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Debit Card"
	SWEP.Slot = 1
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
end


SWEP.PrintName				= "Debit Card"
SWEP.Author					= "JohnyReaper"
SWEP.Instructions			= "LPM at ATM: Put card into ATM"
SWEP.Category				= "IX: Banking"

SWEP.Drop = false

SWEP.Slot				= 1
SWEP.SlotPos				= 0

SWEP.Spawnable				= true

SWEP.ViewModel				= Model("models/weapons/c_arms_animations.mdl")
SWEP.WorldModel				= ""
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"
SWEP.UseHands				= true
SWEP.ShowWorldModel = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= ""
SWEP.Primary.Damage = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= ""

SWEP.DrawAmmo			= false

-- SWEP.IsAlwaysLowered = true
SWEP.FireWhenLowered = true

function SWEP:SetupDataTables()
	self:NetworkVar( "String", 0, "CardNumber" )
end

function SWEP:Initialize()

	self:SetHoldType( "passive" )

	
end

function SWEP:PrimaryAttack()


	if (!IsFirstTimePredicted()) then
		return
	end
print("dziala")
	-- local data = {}
	-- 	data.start = self:GetOwner():GetShootPos()
	-- 	data.endpos = data.start + self:GetOwner():GetAimVector() * 84
	-- 	data.filter = {self, self:GetOwner()}
	-- local trace = util.TraceLine(data)
	local trace = self.Owner:GetEyeTraceNoCursor()
	local entity = trace.Entity


	if (SERVER and IsValid(entity)) then
		if entity:GetClass() == "j_banking_atm" then

	   	 	self:SetNextPrimaryFire( CurTime() + 1 )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )

		
			entity:OpenUI(self.Owner, self:GetCardNumber())
		end
	end

	-- local eye = self.Owner:GetEyeTrace()

	-- print("Bron dziala", eye.Entity)
		
	-- if eye.Entity:GetClass() == "j_banking_atm" then

	--     self:SetNextPrimaryFire( CurTime() + 1 )
	-- 	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	-- 	if (SERVER) then
	-- 		eye.Entity:OpenUI(self.Owner, self:GetCardNumber())
	-- 	end

	-- end

end

function SWEP:SecondaryAttack()
	return
end

-- function SWEP:OnDrop()

-- end

if (CLIENT) then

	function SWEP:DoDrawCrosshair(x, y)
		surface.SetDrawColor(255, 255, 255, 66)
		surface.DrawRect(x - 2, y - 2, 4, 4)
	end

	local cardTexture = ix.util.GetMaterial("setorian_banking/setorian_debit_card_2.png")

	function SWEP:FormatDigit(val)

		local formated = ""
		local words = string.Explode( "", val )
		local newWords = {}

		for k, v in pairs(words) do
			
			newWords[#newWords + 1] = v

			if (k%4 == 0) then
				newWords[#newWords + 1] = " "
			end

		end

		return table.concat(newWords)

	end

	function SWEP:DrawHUD()
		
		surface.SetMaterial( cardTexture )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawTexturedRect( ScrW()-350, ScrH()-178, 350, 178 )

		draw.SimpleText(self:FormatDigit(self:GetCardNumber()), "BudgetLabel", ScrW()*0.825, ScrH()*0.92, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	end
end

-- function SWEP:Deploy()

-- 	return true
-- end

-- function SWEP:Holster()

-- 	return true   
-- end

-- function SWEP:OnRemove()
	
-- 	self:Holster()
-- end