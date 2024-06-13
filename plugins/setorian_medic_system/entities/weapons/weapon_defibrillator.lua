AddCSLuaFile()

local PLUGIN = PLUGIN

SWEP.PrintName				= "Defibrillator"
SWEP.Author					= "JohnyReaper"
SWEP.Purpose				= ""
SWEP.Category				= "JR Helix"
SWEP.Base					= "weapon_setorian_def_base"

SWEP.Slot					= 0
SWEP.SlotPos				= 1

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/custom/v_defib.mdl"
SWEP.WorldModel = "models/weapons/custom/w_defib.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}

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


SWEP.VElements = {}

SWEP.WElements = {
	["def2"] = { type = "Model", model = "models/weapons/custom/w_defib.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.521, 0.778, 0.261), angle = Angle(180, 91.864, -4.533), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	-- ["def1"] = { type = "Model", model = "models/weapons/custom/defib2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.454, 0.809, -1.438), angle = Angle(180, 86.938, 5.826), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.LowerAngles = Angle(0, 0, -5)
-- SWEP.LowerAngles2 = Angle(0, 0, 0)


function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Charged" )

end


function SWEP:Deploy()

	local vm = self.Owner:GetViewModel()

	local EnumToSeq = vm:SelectWeightedSequence( ACT_VM_DRAW )

	vm:SendViewModelMatchingSequence( EnumToSeq )

	self:SetCharged(false)

	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )

end


function SWEP:PrimaryAttack()

	if (SERVER) then
	
		self:SetNextPrimaryFire( CurTime() + 1 )
		self:SetNextSecondaryFire( CurTime() + 1 )

		if (!self:GetCharged()) then
			self.Owner:Notify("The defibrillator is not charged")
			return
		end


		local vm = self.Owner:GetViewModel()

		local EnumToSeq = vm:SelectWeightedSequence( ACT_VM_PRIMARYATTACK )

		vm:SendViewModelMatchingSequence( EnumToSeq )
		
		self.Owner:EmitSound("buttons/button19.wav", 65)

		self:SetCharged(false)


		local client = self.Owner

		local eyeTrace = client:GetEyeTrace()

		local entity = eyeTrace.Entity

		if (entity:GetClass() == "prop_ragdoll") then

			if (client:GetPos():DistToSqr(entity:GetPos()) > 65 * 65) then
				return
			end

			if (entity.ixPlayer) then

				local bodyPly = entity.ixPlayer

				if (bodyPly.ixIsDying) then

					if (bodyPly:GetNetVar("ply_pulse") != 1) then
						client:Notify("The person's pulse is too weak to use a defibrillator")
						return
					end

					if (bodyPly.DefTry == 5) then
						client:Notify("Too many attempts fail. You can no longer use the defibrillator on this person")
						return
					end

					if (math.random() > 0.5) then
						PLUGIN:MakeConscious(bodyPly)
						client:Notify("You successfully brought the person back to life")
						ix.log.Add(client, "BackToLife",bodyPly)
					else
						client:Notify("The attempt to bring the person back to life has failed. Please try again")
						bodyPly.DefTry = bodyPly.DefTry + 1 or 1
					end

				end
			end
		end

		

	end

end

function SWEP:SecondaryAttack()

	if (SERVER) then

		self:SetNextPrimaryFire( CurTime() + 1 )
		self:SetNextSecondaryFire( CurTime() + 1 )

		if (self:GetCharged()) then
			self.Owner:Notify("The defibrillator is already charged")
			return
		end

		local vm = self.Owner:GetViewModel()
		
		local EnumToSeq = vm:SelectWeightedSequence( ACT_VM_SECONDARYATTACK )

		vm:SendViewModelMatchingSequence( EnumToSeq )

		self.Owner:EmitSound("buttons/blip1.wav", 65)

		self:SetCharged(true)

	end

end

