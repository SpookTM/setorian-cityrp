AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/winningrook/gtav/meth/meth_chiller/meth_chiller.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end


	self:SetIsWorking(false)
	self:SetIsOpened(false)
	self:SetLifeTime(0)
	self:SetTrays(0)
	self:SetReadyTrays(0)

	self.FreezeTable = {}

	self.NextTick = CurTime()

end

function ENT:Think()

	if (self:GetIsWorking()) then
		if (self.NextTick < CurTime()) then

			self:SetLifeTime( math.max(self:GetLifeTime() - 1, 0) )

			if (self:GetLifeTime() <= 0) then
				self:DisableMachine()
			end

			if (!table.IsEmpty(self.FreezeTable)) then
				for k, v in ipairs(self.FreezeTable) do
					if (v > 0) then
						self.FreezeTable[k] = self.FreezeTable[k] - 1
					end

				end

				local tblCopy = table.Copy(self.FreezeTable)

				self.FreezeTable = {}

				for k, v in ipairs(tblCopy) do
					if (v > 0) then
						self.FreezeTable[#self.FreezeTable + 1] = v
					else

						self:SetTrays( math.max(self:GetTrays() - 1, 0))
						self:SetReadyTrays( math.max(self:GetReadyTrays() + 1, 0))

					end
				end
			end

			self.NextTick = CurTime() + 1

		end
	end

end

function ENT:ReplaceBattery(client)

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local batteryPower = ix.config.Get("FreezerLifeTime", 600)

	if (self:GetLifeTime() >= batteryPower) then
		client:Notify("Cannot be replaced if new battery is still installed")
		return
	end

	local item = inv:HasItem("freezer_battery")

	if (item) then

		self:SetLifeTime(batteryPower)
		self:EmitSound("physics/metal/metal_grenade_impact_soft"..math.random(1,3)..".wav")
		client:Notify("The battery has been replaced")

		item:Remove()

	else
		client:Notify("You don't have battery in your inventory")
	end

end


function ENT:MachineSwitch(client)

	local CurState = self:GetIsWorking()

	if (CurState) then

		self:StopWorkSound()

	else

		if (self:GetLifeTime() <= 0) then
			client:Notify("Cannot start because there is no power supply. Install a new battery")
			return
		end

		if (self:GetIsOpened()) then
			client:Notify("First close the freezer doors")
			return false
		end

		self:StartWorkSound()

	end

	self:EmitSound("buttons/lightswitch2.wav")

	self:SetIsWorking(!CurState)

end

function ENT:DisableMachine()

	self:StopWorkSound()
	self:SetIsWorking(false)

end

function ENT:ChangeDoorState(client)

	self:SetIsOpened(!self:GetIsOpened())

	local curState = self:GetIsOpened()

	if (curState) then

		self:EmitSound("items/ammocrate_open.wav")

		self:SetBodygroup(1, 1)
		self:SetBodygroup(2, 1)

		self:DisableMachine()

		client:Notify("You opened the freezer doors. The freezer is automatically turned off.")

	else

		client:Notify("You closed the freezer doors.")

		self:EmitSound("items/ammocrate_close.wav")

		self:SetBodygroup(1, 0)
		self:SetBodygroup(2, 0)

	end

end

function ENT:PutTray(client)

	if (!self:GetIsOpened()) then
		client:Notify("First open the freezer doors")
		return false
	end

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	if (self:GetTrays() >= 5) or (self:GetReadyTrays() >= 5) then
		client:Notify("You can't put more trays")
		return false
	end

	local dataToCheck = {
		status = false
	}

	local hasTray = inv:HasItem("methtray")

	if (hasTray) then

		local foundItem = nil

		for k, v in ipairs(inv:GetItemsByUniqueID("methtray")) do

			if (v:GetData("status", false)) then continue end
			foundItem = v
			break
		end

		if (foundItem) then
			self:SetTrays(self:GetTrays() + 1)

			self.FreezeTable[#self.FreezeTable+1] = (ix.config.Get("MethFreezeTime", 20)*60)

			client:Notify("You put the tray in the freezer")
			foundItem:Remove()
		else
			client:Notify("You don't have any tray of cooked meth")
		end
	else
		client:Notify("You don't have any tray of cooked meth")
	end

end

function ENT:CollectTray(client)

	if (self:GetReadyTrays() <= 0) then
		client:Notify("There is no frozen tray inside")
		return
	end

	if (!self:GetIsOpened()) then
		client:Notify("First open the freezer doors")
		return false
	end


	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local extraData = {
		status = true
	}

	local canAdd, invError = inv:Add("methtray",1,extraData)

    if (canAdd) then

        self:EmitSound("physics/cardboard/cardboard_box_break3.wav")

        client:Notify("You pulled out a tray")

        self:SetReadyTrays(math.max(self:GetReadyTrays()-1,0))

    else
        client:Notify(L(invError))
    end

end

function ENT:OnOptionSelected(client, option, data)

	if (option == "Turn On/Off") then
		self:MachineSwitch(client)
	elseif (option == "Open/Close Doors") then
		self:ChangeDoorState(client)
	elseif (option == "Replace Battery") then
		self:ReplaceBattery(client)
	elseif (option == "Put the tray") then
		self:PutTray(client)
	elseif (option == "Collect frozen tray") then
		self:CollectTray(client)
	end
	

end


function ENT:OnRemove()

	self:StopWorkSound()

end

function ENT:StartWorkSound()

	if (self.Worksound) then
		self.Worksound:PlayEx(1, 100)
	else
	    self.Worksound = CreateSound(self, Sound("ambient/machines/refrigerator.wav"))
	    self.Worksound:SetSoundLevel(60)
		self.Worksound:PlayEx(1, 100)
	end
end

function ENT:StopWorkSound()
	if self.Worksound then
        self.Worksound:Stop()
    end
end