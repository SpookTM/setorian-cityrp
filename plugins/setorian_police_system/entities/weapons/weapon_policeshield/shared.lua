AddCSLuaFile()


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Downloading content from workshop
---------------------------------------------------------------------------------------------------------------------------------------------
*/	

if SERVER then resource.AddWorkshop("2441211404"); end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Config
---------------------------------------------------------------------------------------------------------------------------------------------
*/

SWEP.shieldDamage = 10;
SWEP.bashReloadTime = 2;
SWEP.stunTime = 1;

SWEP.canBeDestroyedByDamage = false;
SWEP.onlyExplosionDamage = true;
SWEP.defaultHealth = 1000;

local deleteShieldsAfterDeath = true;

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Default SWEP config
---------------------------------------------------------------------------------------------------------------------------------------------
*/

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Author = "Drover | Edit by Mickerd"
SWEP.Contact = "Discord: Mickerd#1593"
SWEP.Purpose = ""
SWEP.IconLetter = ""
SWEP.PrintName = "Police Shield"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "physgun"
SWEP.HoldType ="physgun"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Police Shield"

SWEP.ViewModel = Model("models/drover/shield.mdl");
SWEP.WorldModel = Model("models/drover/w_shield.mdl");



SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Initialize
---------------------------------------------------------------------------------------------------------------------------------------------
*/

function SWEP:Initialize()
    self:SetHoldType("physgun");
end



function SWEP:SetupShield()
	if CLIENT then return end;
	self.shieldProp = ents.Create("prop_physics");
	self.shieldProp:SetModel("models/drover/2w_shield.mdl");
	self.shieldProp:Spawn(); 
	self.shieldProp:SetModelScale(0,0);
	local phys = self.shieldProp:GetPhysicsObject();
	if not IsValid(phys) then
		self.Owner:ChatPrint("not valid physics object!");
		return;
	end
	phys:SetMass(5000);
	
	local nothand = false;
	local attach = self.Owner:LookupAttachment("anim_attachment_RH");
	if attach == nil or attach == 0 then
		--self.Owner:ChatPrint("Attachment 'anim_attachment_RH' not found for this player model!");
		attach = self.Owner:LookupAttachment("forward");
		nothand = true;
		if attach == nil or attach == 0 then
			self.Owner:ChatPrint("Attachment 'anim_attachment_RH' and 'forward' not found for this player model!");
			return;
		end
	end
	
	local up = 3;
	local forward = 11;
	local right = 0;
	
	local aforward = 20;
	local aup = 70;
	
	if nothand then
	    up = -20;
		forward = 17;
		aforward = 0;
		aup = 90;
	end
	local attachTable = self.Owner:GetAttachment(attach);
	self.shieldProp:SetPos(attachTable.Pos + attachTable.Ang:Up()*up + attachTable.Ang:Forward()*forward + attachTable.Ang:Right()*right);
	
	attachTable.Ang:RotateAroundAxis(attachTable.Ang:Forward(),aforward);
	attachTable.Ang:RotateAroundAxis(attachTable.Ang:Up(),aup);
	self.shieldProp:SetAngles(attachTable.Ang);
	self.shieldProp:SetCollisionGroup( COLLISION_GROUP_WORLD );
	self.shieldProp:SetParent(self.Owner,attach);
	timer.Simple(0.2,function()
		if IsValid(self) and IsValid(self.shieldProp) then
			self.shieldProp:SetModelScale(1,0);
			net.Start("disable_shielddraw") net.WriteEntity(self) net.WriteEntity(self.shieldProp) net.Send(self.Owner);
		end
	end)
end


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				CheckPlace
---------------------------------------------------------------------------------------------------------------------------------------------
*/
function SWEP:CheckPlace(pos)

	local mins = Vector( -10, -20, -3);
	local maxs = Vector( 20, 20, 40);
	local tr = {
		start = pos, 
		endpos = pos + Vector(0,0,5), 
		mins = mins, 
		maxs = maxs,
		filter = {self.Owner,self.shieldProp}
	}
	local hullTrace = util.TraceHull( tr );
	if ( hullTrace.Hit ) then
		return false;
	end	
	return true;	
end



/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Shield bash
---------------------------------------------------------------------------------------------------------------------------------------------
*/


function SWEP:FreezeEnemy(ply)
	ply:Freeze(true);
	timer.Create('unfreezemeswep'..tostring(ply:EntIndex()),self.stunTime,1,function()
		if IsValid(ply) then ply:Freeze(false); end
	end)
end

function SWEP:FindEnemy()
	local mins = Vector( -10, -10, -3);
	local maxs = Vector( 10, 10, 40);
	local pos = self.Owner:GetPos() + self.Owner:GetForward()*35 + Vector(0,0,40);
	local tr = {
		start = pos, 
		endpos = pos + Vector(0,0,5), 
		mins = mins, 
		maxs = maxs,
		filter = {self.Owner,self.shieldProp,Entity(0)}
	}
	local hullTrace = util.TraceHull( tr );
	if ( hullTrace.Hit ) then
		if hullTrace.Entity:IsPlayer() then
			return hullTrace.Entity;
		end
		return false;
	end
	return false;
end


function SWEP:ShieldBash()
	local enemy = self:FindEnemy();
	if enemy == false then return end;
	enemy:TakeDamage(self.shieldDamage,self.Owner,self);
	self:FreezeEnemy(enemy);
	self.Owner:EmitSound(Sound("Flesh.ImpactHard"));
end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Primary attack
---------------------------------------------------------------------------------------------------------------------------------------------
*/

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.bashReloadTime);
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	if CLIENT then return end;
	net.Start("shieldbash") net.WriteEntity(self.Owner) net.Broadcast();
	self:ShieldBash();
	
end


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Secondary attack / Deploy static shield
---------------------------------------------------------------------------------------------------------------------------------------------
*/
function SWEP:SecondaryAttack()
	if CLIENT then return end;
	local ang = self.Owner:GetAngles()
	ang.p = 0;
	ang.r = 0;
	local pos = self.Owner:GetPos() + ang:Forward()*45 + Vector(0,0,10);
	local checkingPlace = self:CheckPlace(pos);
	if not checkingPlace then return end;
	local shieldEnt = ents.Create("police_shield");
	shieldEnt:SetPos(pos);
	local tempAngle = self.Owner:GetAngles();
	shieldEnt:SetAngles(Angle(0,tempAngle.y,0));
	
	shieldEnt.canBeDestroyedByDamage = self.canBeDestroyedByDamage;
	shieldEnt.onlyExplosionDamage = self.onlyExplosionDamage;
	shieldEnt.currentHealth = self.defaultHealth;
	
	shieldEnt:Spawn();
	shieldEnt.Owner = self.Owner;
	self.Owner:Freeze(true);
	local ply = self.Owner;
	timer.Simple(0.2,function()
		if IsValid(ply) then
			ply:Freeze(false);			
		end
	end)
	self:Remove();
end



/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Network initialize && Client Receive
---------------------------------------------------------------------------------------------------------------------------------------------
*/

if SERVER then
	util.AddNetworkString("disable_shielddraw");
	util.AddNetworkString("shieldbash");
end

if CLIENT then
	net.Receive("disable_shielddraw",function()
		local weaponEntity = net.ReadEntity();
		local shieldProp = net.ReadEntity();
		if IsValid(shieldProp) then
			shieldProp:SetNoDraw(true);
		if IsValid(weaponEntity) then
			weaponEntity.shieldProp = shieldProp;
		end	
		end
	end)
	
	
net.Receive('shieldbash',function()
	local ply = net.ReadEntity();
	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end;
	ply:AnimRestartGesture( GESTURE_SLOT_GRENADE,ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND, true );
end)
	
	
end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Weapon dropped / replace world model
---------------------------------------------------------------------------------------------------------------------------------------------
*/
/*
 hook.Add("onDarkRPWeaponDropped","Police Shield",function(d2, ent, weapon)
	if weapon:GetClass() == "weapon_policeshield" then
		ent:SetModel("models/drover/w_shield.mdl");
	end
 end)
*/

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Player Death / delete our shields
---------------------------------------------------------------------------------------------------------------------------------------------
*/

hook.Add("PlayerDeath","PlayerDeathDeleteShields",function(ply)
	if deleteShieldsAfterDeath then
		for k,v in pairs(ents.FindByClass("police_shield")) do
			if v.Owner != nil and IsValid(v.Owner) and v.Owner == ply then
				v:Remove();
			end
		end
	end	
end)

hook.Add("OnPlayerChangedTeam","PlayerChangeTeamDeleteShields",function(ply)
    if deleteShieldsAfterDeath then
        for k,v in pairs(ents.FindByClass("police_shield")) do
            if v.Owner != nil and IsValid(v.Owner) and v.Owner == ply then
                v:Remove();
            end
        end
    end
end)

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Reload && Deploy && Holster && Drop && Remove
---------------------------------------------------------------------------------------------------------------------------------------------
*/


function SWEP:ViewModelDrawn(viewmodel)
	if IsValid(self.shieldProp) and !self.shieldProp:GetNoDraw() then
		self.shieldProp:SetNoDraw(true);
	end
end

function SWEP:DrawWorldModel()
	if IsValid(self.shieldProp) and self.shieldProp:GetNoDraw() then
		self.shieldProp:SetNoDraw(false);
	end
end

function SWEP:Reload()

end

function SWEP:Deploy()
	self:SetHoldType("physgun"); 
	self:SetupShield();
	return true
end

function SWEP:Holster()
	if CLIENT then return end;
	if not IsValid(self.shieldProp) then return true end;
	self.shieldProp:Remove();
	return true;
end


function SWEP:OnDrop()
	if CLIENT then return end;
	if not IsValid(self.shieldProp) then return true end;
	self.shieldProp:Remove();
	return true;
end

function SWEP:OnRemove()
	if CLIENT then return end;
	if not IsValid(self.shieldProp) then return true end;
	self.shieldProp:Remove();
	return true;
end

