SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Chop Shop" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Blowtorch"
SWEP.TrueName = "Blowtorch"

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_nmrih/v_tool_welder.mdl"
SWEP.WorldModel = "models/weapons/tfa_nmrih/w_tool_welder.mdl"

SWEP.HoldtypeActive = "pistol"
SWEP.ViewModelFOV = 70

SWEP.Damage = 0
SWEP.Range = 1 -- in METRES
SWEP.Penetration = 0
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.
SWEP.InfiniteAmmo = true
SWEP.BottomlessClip = true

SWEP.Recoil = 0
SWEP.RecoilSide = 0
SWEP.RecoilRise = 0

SWEP.NeverPhysBullet = true

SWEP.Sway = 0

SWEP.Delay = 140 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 200

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 0 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 0

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses
SWEP.MagID = "gasoline" -- the magazine pool this gun draws from

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.GMMuzzleEffect = true

SWEP.ShootSound = nil
SWEP.ShootSoundLooping = "weapons/tools/welder/welder_loop.wav"
-- SWEP.MuzzleFlashColor = Color(209, 120, 120)
SWEP.MuzzleEffect = "cball_bounce"

SWEP.ImpactEffect = "ManhackSparks"
//SWEP.ImpactDecal = "ManhackCut"

-- SWEP.ShellModel = "models/shells/shell_762nato.mdl"
-- SWEP.ShellScale = 1.5
-- SWEP.ShellMaterial = "models/weapons/arcticcw/shell_556_steel"

SWEP.MuzzleEffectAttachment = 3 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0
SWEP.SightedSpeedMult = 0
SWEP.SightTime = 0.4
SWEP.VisualRecoilMult = 0
SWEP.RecoilRise = 0
SWEP.RecoilPunch = 0
SWEP.RecoilVMShake = 0
SWEP.RecoilDirection = Angle(0, 0, 0)
SWEP.RecoilDirectionSide = Angle(0, 0, 0)

-- SWEP.TracerNum = 0.01


SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-1, -5, 1.15),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}
SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "pistol"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(1, -3, 2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(5, -5, -2)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.CustomizePos = Vector(9.824, -6, 0)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27


SWEP.AttachmentElements = {

}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {

}

SWEP.Animations = {
    ["idle"] = {
    	Source = "idle",
    },
    ["draw"] = {
        Source = "draw",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["holster"] = {
        Source = "holster",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["fire"] = {
        Source = "weld",
        Time = 1,
    },
    ["bash"] = {
        Source = "attack_quick",
        Time = 2,
    },
}



SWEP.NotForNPCs = true

-- SWEP.PrimaryBash = true
SWEP.CanBash = false
SWEP.MeleeDamage = 20
SWEP.MeleeRange = 32
SWEP.MeleeDamageType = DMG_SLASH

SWEP.MeleeTime = 1

SWEP.Melee2 = false

-- SWEP.MeleeSwingSound  = "weapons/yurie_rustalpha/hatchet/swing.ogg"
SWEP.MeleeHitSound    = "weapons/yurie_rustalpha/hatchet/impact_generic.ogg"
SWEP.MeleeHitNPCSound = "weapons/yurie_rustalpha/hatchet/melee_body_hit-2.wav"

local PLUGIN = PLUGIN

function SWEP:Hook_ShouldNotFire()

    local tr = self.Owner:GetEyeTrace()

    if (tr.Hit) and (tr.Entity) and IsValid(tr.Entity) then
        if (tr.Entity:GetClass() == "j_chopshop_car") and (tr.Entity:LocalToWorld(tr.Entity:GetCurProgresPos()):DistToSqr(self.Owner:GetPos()) < 5000) then
            return false
        elseif (tr.Entity:IsVehicle()) then
            if (SERVER) then

                if (PLUGIN.BlackList[tr.Entity.VehicleName]) then return true end
                if (tr.Entity:getDoorOwner() == self.Owner) then return true end

                if ((self.Owner.NextPrepareCar or 0) < CurTime()) then
                    PLUGIN:PrepareCar(self.Owner, tr.Entity)
                    self.Owner.NextPrepareCar = CurTime() + 0.2
                end
            end
            return true
        end
    else
        return true
    end
end