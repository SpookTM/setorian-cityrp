SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Rust" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Pickaxe"
SWEP.TrueName = "Pickaxe"

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/yurie_rustalpha/c-vm-pickaxe.mdl"
SWEP.WorldModel = "models/weapons/yurie_rustalpha/wm-pickaxe.mdl"
SWEP.ViewModelFOV = 60

SWEP.HoldtypeActive = "melee2"

SWEP.NotForNPCs = true

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamage = 20
SWEP.MeleeRange = 32
SWEP.MeleeDamageType = DMG_CLUB

SWEP.MeleeTime = 1

SWEP.NoHideLeftHandInCustomization = true

-- SWEP.MeleeSwingSound  = "weapons/yurie_rustalpha/hatchet/swing.ogg"
SWEP.MeleeHitSound    = "weapons/yurie_rustalpha/hatchet/impact_generic.ogg"
SWEP.MeleeHitNPCSound = "weapons/yurie_rustalpha/hatchet/melee_body_hit-2.wav"

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "deploy",
        Time = 1,
        SoundTable = {{s = "weapons/yurie_rustalpha/shared/draw_generic_rustle.ogg", t = 0}},
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["ready"] = {
        Source = "deploy",
        Time = 0.5,
    },
    ["bash"] = {
        Source = "fire_1",
        SoundTable = {{s = "weapons/yurie_rustalpha/hatchet/swing.ogg", t = 0}},
        Time = 1,
        LHIK = false,
    },

}

function SWEP:Hook_PostBash(data)

    if (SERVER) then

        local tr = data.tr

        if (IsValid(tr.Entity)) then

            if (tr.Entity:GetClass() == "j_mining_node") then

                tr.Entity:MineOre(self.Owner, data.dmg)

            end

        end

    end

end