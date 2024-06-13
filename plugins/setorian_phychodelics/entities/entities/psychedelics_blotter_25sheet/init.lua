AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")
local blotter = include("psychedelics/libs/blotter.lua")
local defaultQuantity = 25

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Quantity")
	self:NetworkVar("String", 0, "DataP")
end


function ENT:Initialize()
	self:SetModel("models/psychedelics/lsd/blotter/25sheet.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local data = self:GetDataP()
	local quantity = self:GetQuantity()

	if data == "" then
		data = "psychedelicsSheet--1"
		self:SetDataP(data)
	end
	if quantity == 0 then
		quantity = defaultQuantity
		self:SetQuantity(quantity)
	end

	local tab = string.Split(data, "-")
	local subMaterial = tab[2]
	blotter.saveData(data, quantity, self)
	self:GetPhysicsObject():Wake()
	self:Activate()
	if subMaterial ~= "" then self:SetSubMaterial(0, "!" .. data) end
	self:SetNWBool("psychedelicsInitialized", true)
end


function ENT:Use(activator, caller)
	if not (IsValid(caller) and caller:IsPlayer())  then return end
	if activator.usedBlotter then return end --avoid +use spam
	activator.usedBlotter = true
	timer.Simple(0.2,function() 
		if not activator:IsValid() then return end
		activator.usedBlotter = false 
	end)

	local char = caller:GetCharacter()
	local inventory = char:GetInventory()

	local canAdd, errorNotf = inventory:Add("psychedelics_blotter_25sheet")

	if (canAdd) then
        self:Remove()
	else
		caller:NotifyLocalized(errorNotf)
    end


	-- local price = GetConVar("psychedelics_lsd_price"):GetInt()
	-- local quant = self:GetQuantity()
	-- local money = activator.moneyP
	-- if money == nil then money = 0 end
	-- if activator:KeyDown(IN_SPEED) then --adds the entity for selling
	-- 	activator.moneyP = money + (price * quant) / 4
	-- 	self:Remove()
	-- 	return
	-- end

	-- 	--here we avoid entity spam
	-- local count = 0
	-- for k, v in pairs(ents.FindByClass("psychedelics_blotter_5sheet")) do -- counts spawned sheets owned by player
	-- 	if v:CPPIGetOwner() == activator then count = count + 1 end
	-- end
	-- if count >= GetConVar("psychedelics_limitspawn_5sheet"):GetInt() then -- prevents player from spamming entities
	-- 	net.Start("psychedelicsHintMessage")
	-- 	net.WriteString("You have hit this entity limit")
	-- 	net.WriteInt(1, 32)
	-- 	net.WriteInt(3, 32)
	-- 	net.Send(activator)
	-- 	return
	-- end

	--here its when the player crops the 25sheet
	-- self:EmitSound("physics/cardboard/cardboard_box_strain1.wav") --below is used for crop the sheet
	-- local quantity = self:GetQuantity()
	-- local data = self:GetDataP()
	-- local tab = string.Split(data, "-")
	-- local subMaterial = tab[2]
	-- local angles25 = self:LocalToWorldAngles(Angle(0, -90, 0))
	-- local pos = self:GetPos()
	-- for b = 1, 5 do
	-- 	local sheet5 = ents.Create("psychedelics_blotter_5sheet")
	-- 	sheet5:SetPos(pos - self:GetForward() * (4 * (5 - b)) + (self:GetForward() * 10))
	-- 	sheet5:CPPISetOwner(activator)
	-- 	sheet5:SetAngles(angles25)
	-- 	blotter.saveData(data.."-"..(b), quantity, sheet5)
	-- 	sheet5:Spawn()
	-- 	sheet5:Activate()
	-- end
	-- self:Remove()
end

function ENT:Think() end
