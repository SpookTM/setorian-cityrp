
AddCSLuaFile()

SWEP.PrintName = "Med Kit" -- change the name
SWEP.Author = "Brickwall"
SWEP.Instructions = "Left click to heal others, right click to self heal"

SWEP.Category = "DarkRP SWEP Replacements" -- change the name


SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/sterling/c_enhanced_firstaidkit.mdl" ) -- just change the model 
SWEP.WorldModel = ( "models/sterling/w_enhanced_firstaidkit.mdl" )
SWEP.ViewModelFOV = 85
SWEP.UseHands = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 0.1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 0.3
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"

SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( "pistol" )

	self.stickRange = 90
end

function SWEP:SetupDataTables()
    self:NetworkVar( "Int", 0, "HealTime" )
    self:NetworkVar( "Entity", 0, "Target" )
end

function SWEP:PrimaryAttack()
    if( self:GetHealTime() > 0 or IsValid( self:GetTarget() ) ) then return end

    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self:SetNextPrimaryFire( CurTime() + 0.1 )
    self:SetNextSecondaryFire( CurTime() + 0.1 )

    self:GetOwner():LagCompensation(true)
    local trace = util.QuickTrace(self:GetOwner():EyePos(), self:GetOwner():GetAimVector() * 90, {self:GetOwner()})
    self:GetOwner():LagCompensation(false)

    ent = self:GetOwner():getEyeSightHitEntity(nil, nil, function(p) return p ~= self:GetOwner() and p:IsPlayer() and p:Alive() and p:IsSolid() end)

    local stickRange = self.stickRange * self.stickRange
    if not IsValid(ent) or (self:GetOwner():EyePos():DistToSqr(ent:GetPos()) > stickRange) or not ent:IsPlayer() then
        return
    end

    self:SetHealTime( CurTime()+BES.CONFIG.Medkit.HealTime )
    self:SetTarget( ent )
end

function SWEP:ResetHealing()
    self:SetTarget( nil )
    self:SetHealTime( 0 )
end

function SWEP:FinishHealing()
    if( CLIENT ) then return end

    self:SetHealTime( 0 )

    local victim = self:GetTarget()

    self:SetTarget( nil )

    if( IsValid( victim ) ) then
        if( victim != self.Owner ) then
            victim:SetHealth( math.Clamp( victim:Health() + BES.CONFIG.Medkit.PlyHeal, 0, victim:GetMaxHealth() ) )
        else
            victim:SetHealth( math.Clamp( victim:Health() + BES.CONFIG.Medkit.SelfHeal, 0, victim:GetMaxHealth() ) )

            if( not BES.CONFIG.Medkit.SlowdownSelfHeal ) then return end

            victim:SetWalkSpeed( victim:GetNWInt( "BES_OLDWSPEED", 25 ) )
            victim:SetRunSpeed( victim:GetNWInt( "BES_OLDRSPEED", 100 ) )
        end
    end
end

function SWEP:Think()
    if( self:GetHealTime() != 0 and self:GetTarget() and CurTime() >= self:GetHealTime() ) then
        self:FinishHealing()
    end

    if( self:GetHealTime() != 0 and self:GetTarget() ) then
        if( IsValid( self:GetTarget() ) and self:GetTarget() != self.Owner ) then
            self:GetOwner():LagCompensation(true)
            local trace = util.QuickTrace(self:GetOwner():EyePos(), self:GetOwner():GetAimVector() * 90, {self:GetOwner()})
            self:GetOwner():LagCompensation(false)
        
            local ent = trace.Entity
            if( ent != self:GetTarget() ) then
                self:ResetHealing()
            end
        elseif( not IsValid( self:GetTarget() ) ) then
            self:ResetHealing()
        end
    end
end

function SWEP:SecondaryAttack()
    if( self:GetHealTime() > 0 or IsValid( self:GetTarget() ) ) then return end

    self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
    self:SetNextPrimaryFire( CurTime() + 0.1 )
    self:SetNextSecondaryFire( CurTime() + 0.1 )

    self:SetHealTime( CurTime()+BES.CONFIG.Medkit.SelfHealTime )
    self:SetTarget( self.Owner )

    if( not BES.CONFIG.Medkit.SlowdownSelfHeal ) then return end

    self.Owner:SetNWInt( "BES_OLDWSPEED", self.Owner:GetWalkSpeed() )
    self.Owner:SetNWInt( "BES_OLDRSPEED", self.Owner:GetRunSpeed() )
    self.Owner:SetWalkSpeed( 25 )
    self.Owner:SetRunSpeed( 25 )
end

if( CLIENT ) then
    local status
    hook.Add( "HUDPaint", "BESHooks_HUDPaint_DrawHealing", function()
        if( IsValid( LocalPlayer():GetActiveWeapon() ) and LocalPlayer():GetActiveWeapon():GetClass() == "dsr_medkit" ) then
            local self = LocalPlayer():GetActiveWeapon()
            if( self:GetHealTime() != 0 and self:GetTarget() ) then
                if( self:GetTarget() != LocalPlayer() ) then
                    status = math.Clamp( 1-(self:GetHealTime()-CurTime())/BES.CONFIG.Medkit.HealTime, 0, 1)
                else
                    status = math.Clamp( 1-(self:GetHealTime()-CurTime())/BES.CONFIG.Medkit.SelfHealTime, 0, 1)
                end
                local Spacing = 0
                local Thickness = 7
                local Radius = 65

                draw.Arc( ScrW()/2, ScrH()/2, Radius, Thickness, 0, 360, 3, Color( 35, 38, 45 ) )
                draw.Arc( ScrW()/2, ScrH()/2, Radius-Spacing, Thickness-(2*Spacing), 0, (status*360), 3, HSVToColor( 90*status, 1, 1 ) )
                draw.Arc( ScrW()/2, ScrH()/2, Radius-Spacing, Thickness-(2*Spacing), 0, 360, 3, Color( 50, 50, 50, 100 ) )

                draw.SimpleText( "Healing", "BES_Myriad_24", ScrW()/2, ScrH()/2, Color(255, 255, 255, 255), 1, 1)
            end
        end
    end )
end