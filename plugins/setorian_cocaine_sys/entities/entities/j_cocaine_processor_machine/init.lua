AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/dannio/fbikid/cocaine/cocaineproc.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self:SetProcesLeaves(0)
	self:SetWorkTime(0)
	self:SetIsWorking(false)

	self:SetBrickReady(false)

	self.IsProducing = false

	self.NextTick = CurTime()


end

function ENT:Think()

	if (self:GetIsWorking()) then

		if (self.NextTick < CurTime()) then

			self:SetWorkTime(math.max(self:GetWorkTime() - 1, 0))

			if (self:GetWorkTime() <= 0) then-- and (!self.IsProducing) then

				self:SetProcesLeaves( math.max(self:GetProcesLeaves() - 5, 0) )

				-- if (self:GetProcesLeaves() >= 5) then
				-- 	self:SetWorkTime(10)
				-- else
				self:SetBrickReady(true)
				self:DisableMachine()
				-- end

				-- self:ProduceBrick()

			end

			self.NextTick = CurTime() + 1
		end

	end

end

function ENT:ProduceBrick(client)

	if (!self:GetBrickReady()) then
		client:Notify("There are no ground leaves inside")
		return
	end

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local IsAdded, ErrorInv = inv:Add("cocaine_brick",1)

	if (!IsAdded) then
        client:Notify(L(ErrorInv, client))
        return

    end

    self:EmitSound("buttons/button4.wav")

	self:SetBrickReady(false)

	client:Notify("You took a brick of cocaine out of the machine")

end

function ENT:MachineSwitch(client)

	local CurState = self:GetIsWorking()

	if (CurState) then

		self:EmitSound("buttons/lever4.wav")
		self:StopWorkSound()

	else

		self:EmitSound("buttons/lever6.wav")

		if (self:GetBrickReady()) then
			client:Notify("The machine is full. First, pull out the finished brick of cocaine")
			return
		end

		if (self:GetProcesLeaves() < 5) then
			client:Notify("You need at least five leaves to run the machine")
			return
		end

		local workTime = ix.config.Get("CocaineProcessTime", 10) * 60

		if (self:GetWorkTime() <= 0) then
			self:SetWorkTime(workTime)
		end

		self:StartWorkSound()

	end

	self:SetIsWorking(!CurState)


end

function ENT:DisableMachine()

	self:StopWorkSound()
	self:SetIsWorking(false)

	self:EmitSound("ambient/machines/spindown.wav")

end


function ENT:PutLeaves(client)

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local dataCheck = {
		dry_status = true
	}

	local hasLeaves = inv:HasItem("coca_leaves", dataCheck)

	if (hasLeaves) then

		local howMany = 0

		for k, v in ipairs(inv:GetItemsByUniqueID("coca_leaves")) do

			if (!v:GetData("dry_status", false)) then continue end

			local leavesCount = v:GetData("leavesCount", 1)
			
			howMany = howMany + leavesCount

			v:Remove()

		end

		self:SetProcesLeaves(self:GetProcesLeaves() + howMany)

		local properName = (howMany == 1 and "one dried leaf") or howMany.." dried leaves"

		client:Notify("You have placed "..properName)

	else
		client:Notify("You don't have any dried leaves in your inventory")
	end

end

function ENT:OnOptionSelected(client, option, data)

	if (option == "Turn On/Off") then
		self:MachineSwitch(client)
	elseif (option == "Put the dried leaves") then
		self:PutLeaves(client)
	elseif (option == "Take a cocaine brick") then
		self:ProduceBrick(client)
	end

end

function ENT:OnRemove()

	self:StopWorkSound()

end

function ENT:StartWorkSound()

	if (self.Worksound) then
		self.Worksound:PlayEx(1, 100)
	else
	    self.Worksound = CreateSound(self, Sound("ambient/machines/machine3.wav"))
	    self.Worksound:SetSoundLevel(75)
		self.Worksound:PlayEx(1, 100)
	end
end

function ENT:StopWorkSound()
	if self.Worksound then
        self.Worksound:Stop()
    end
end