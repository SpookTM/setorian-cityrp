AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
local quant = 100
function ENT:Initialize()
	self:SetModel("models/psychedelics/mushroom/mushroom_3.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:Activate()
end

function ENT:Use(activator, caller)
	if not ( IsValid(caller) and caller:IsPlayer() ) then return end
    if activator.usedShroom then --avoids +use spam
		return
	end
	activator.usedShroom = true
	timer.Simple(0.2, function()
	activator.usedShroom = false
	end)

	local char = caller:GetCharacter()
	local inventory = char:GetInventory()

	local canAdd, errorNotf = inventory:Add("psychedelics_mushroom")

	if (canAdd) then
        self:Remove()
	else
		caller:NotifyLocalized(errorNotf)
    end

	-- local price = GetConVar("psychedelics_mushroom_price"):GetInt()
	-- local money = activator.moneyP
	-- if money == nil then money = 0 end
	-- if activator:KeyDown(IN_SPEED) then -- adds the lsd sheet for selling
	-- 	activator.moneyP = money + price
	-- 	self:Remove()
	-- 	return
	-- end
	-- net.Start("psychedelicsStartShroom")
	-- net.WriteInt(quant, 20)
	-- net.Send(caller)
	-- self:Remove()
end

function ENT:Touch(entity) end

function ENT:Think() end
