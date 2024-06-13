AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

	self:SetModel("models/dannio/fbikid/cocaine/dryingrack.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	-- PLUGIN:SaveGunCraftTables()


	self:SetWetLeaves(0)
	self:SetDryLeaves(0)

	self.TimerProcess = CurTime()

	self:SetIsWorking(false)

	self.DryTable = {}

	local LampEffect1 = ents.Create("prop_dynamic");
	LampEffect1:SetModel("models/effects/vol_light128x128.mdl")
	LampEffect1:SetPos(self:GetPos() + self:GetAngles():Up()*70 + self:GetAngles():Forward() * -19 + self:GetAngles():Right() * -0.4 )
	LampEffect1:SetAngles(self:GetAngles())
	LampEffect1:SetParent(self)
	LampEffect1:SetModelScale(0.18)
	LampEffect1:DrawShadow(false)
	LampEffect1:SetRenderMode(RENDERMODE_NONE)
	LampEffect1:SetColor(Color(250,250,250, 1))
	LampEffect1:Spawn();

	self.LampEffect1 = LampEffect1


	local LampEffect2 = ents.Create("prop_dynamic");
	LampEffect2:SetModel("models/effects/vol_light128x128.mdl")
	LampEffect2:SetPos(self:GetPos() + self:GetAngles():Up()*70 + self:GetAngles():Forward() * -13 + self:GetAngles():Right() * -0.4 )
	LampEffect2:SetAngles(self:GetAngles())
	LampEffect2:SetParent(self)
	LampEffect2:SetModelScale(0.18)
	LampEffect2:DrawShadow(false)
	LampEffect2:SetRenderMode(RENDERMODE_NONE)
	LampEffect2:SetColor(Color(250,250,250, 1))
	LampEffect2:Spawn();

	self.LampEffect2 = LampEffect2

	local LampEffect3 = ents.Create("prop_dynamic");
	LampEffect3:SetModel("models/effects/vol_light128x128.mdl")
	LampEffect3:SetPos(self:GetPos() + self:GetAngles():Up()*70 + self:GetAngles():Forward() * 14 + self:GetAngles():Right() * -0.4 )
	LampEffect3:SetAngles(self:GetAngles())
	LampEffect3:SetParent(self)
	LampEffect3:SetModelScale(0.18)
	LampEffect3:DrawShadow(false)
	LampEffect3:SetRenderMode(RENDERMODE_NONE)
	LampEffect3:SetColor(Color(250,250,250, 1))
	LampEffect3:Spawn();

	self.LampEffect3 = LampEffect3

	local LampEffect4 = ents.Create("prop_dynamic");
	LampEffect4:SetModel("models/effects/vol_light128x128.mdl")
	LampEffect4:SetPos(self:GetPos() + self:GetAngles():Up()*70 + self:GetAngles():Forward() * 19 + self:GetAngles():Right() * -0.4 )
	LampEffect4:SetAngles(self:GetAngles())
	LampEffect4:SetParent(self)
	LampEffect4:SetModelScale(0.18)
	LampEffect4:DrawShadow(false)
	LampEffect4:SetRenderMode(RENDERMODE_NONE)
	LampEffect4:SetColor(Color(250,250,250, 1))
	LampEffect4:Spawn();

	self.LampEffect4 = LampEffect4


	-- for i=1, 5 do

		-- local VisualLeaf = ents.Create("prop_dynamic");
		-- VisualLeaf:SetModel("models/customhq/tobaccofarm/leaf.mdl")
		-- VisualLeaf:SetPos(self:GetPos() + self:GetAngles():Up()*37 + self:GetAngles():Forward() * (-19 + ((i-1)*10)) + self:GetAngles():Right() * -2 )
		-- VisualLeaf:SetAngles(self:GetAngles() + Angle(0,math.random(-180,180),0))
		-- VisualLeaf:SetModelScale(0.6)
		-- VisualLeaf:SetParent(self)
		-- VisualLeaf:Spawn()

	-- end

	self.VisualLeavesSlots = {
		[1] = {
			SVector = Vector( -24.94, -7.19, 37.25 ),
			IsBusy = false,
			SlotEnt = nil,
		},
		[2] = {
			SVector = Vector( -24.25, 7.59, 37.25 ),
			IsBusy = false,
			SlotEnt = nil,
		},
		[3] = {
			SVector = Vector( -8.6, -4.63, 37.25 ),
			IsBusy = false,
			SlotEnt = nil,
		},
		[4] = {
			SVector = Vector( -12.1, 8.06, 37.25 ),
			IsBusy = false,
			SlotEnt = nil,
		},
		[5] = {
			SVector = Vector( 8.93, -5.66, 37.25 ),
			IsBusy = false,
			SlotEnt = nil,
		},
		[6] = {
			SVector = Vector( 9.4, 7.87, 37.25 ),
			IsBusy = false,
			SlotEnt = nil,
		},
		[7] = {
			SVector = Vector( 20.78, -5.19, 37.25 ),
			IsBusy = false,
			SlotEnt = nil,
		},
		[8] = {
			SVector = Vector( 20.15, 7.46, 37.25 ),
			IsBusy = false,
			SlotEnt = nil,
		},
	}

end

function ENT:EnableLampEffect(curState)

	if (curState) then

		self.LampEffect1:SetRenderMode(RENDERMODE_TRANSCOLOR)
		self.LampEffect2:SetRenderMode(RENDERMODE_TRANSCOLOR)
		self.LampEffect3:SetRenderMode(RENDERMODE_TRANSCOLOR)
		self.LampEffect4:SetRenderMode(RENDERMODE_TRANSCOLOR)

	else

		self.LampEffect1:SetRenderMode(RENDERMODE_NONE)
		self.LampEffect2:SetRenderMode(RENDERMODE_NONE)
		self.LampEffect3:SetRenderMode(RENDERMODE_NONE)
		self.LampEffect4:SetRenderMode(RENDERMODE_NONE)

	end
end

function ENT:Think()

	if (!self:GetIsWorking()) then return end
 	if (!table.IsEmpty(self.DryTable)) then
		if (self.TimerProcess < CurTime()) then

			for k, v in ipairs(self.DryTable) do
				if (v > 0) then
					self.DryTable[k] = self.DryTable[k] - 1
				end

			end

			local tblCopy = table.Copy(self.DryTable)

			self.DryTable = {}

			for k, v in ipairs(tblCopy) do
				if (v > 0) then
					self.DryTable[#self.DryTable + 1] = v
				else

					self:SetWetLeaves( math.max(self:GetWetLeaves() - 1, 0))
					self:SetDryLeaves( math.max(self:GetDryLeaves() + 1, 0))

				end
			end


			self.TimerProcess = CurTime() + 1

		end
	end

end

function ENT:CreateVisualLeaf(howMany)

	local LoopCount = howMany or 1

	for i=1, LoopCount do

		for k, v in RandomPairs(self.VisualLeavesSlots or {}) do
			if (v.IsBusy) then continue end

			local VisualLeaf = ents.Create("prop_dynamic");
			VisualLeaf:SetModel("models/customhq/tobaccofarm/leaf.mdl")
			VisualLeaf:SetPos( self:LocalToWorld(v.SVector) )
			VisualLeaf:SetAngles(self:GetAngles() + Angle(0,math.random(-40,40),0))
			VisualLeaf:SetModelScale(0.6)
			VisualLeaf:SetParent(self)
			VisualLeaf:Spawn()

			v.SlotEnt = VisualLeaf

			v.IsBusy = true

			break

		end
		
	end

end

function ENT:RemoveVisualLeaf(howMany)

	local LoopCount = howMany or 1

	for i=1, LoopCount do

		for k, v in RandomPairs(self.VisualLeavesSlots or {}) do

			if (v.IsBusy) then

				if (v.SlotEnt) then
					if (IsValid(v.SlotEnt)) then
						v.SlotEnt:Remove()
					end
					v.SlotEnt = nil
				end

				v.IsBusy = false

				break

			end

		end
	end

end

function ENT:VisualLeafUsed()

	local SlotCount = 0

	for k, v in ipairs(self.VisualLeavesSlots or {}) do
		if (v.IsBusy) then
			SlotCount = SlotCount + 1
		end
	end

	return SlotCount

end

function ENT:PutWetLeaves(client)

	local char = client:GetCharacter()
	local inv = char:GetInventory()

	local dataCheck = {
		dry_status = false
	}

	local hasLeaves = inv:HasItem("coca_leaves")

	if (hasLeaves) then

		local howMany = 0

		for k, v in ipairs(inv:GetItemsByUniqueID("coca_leaves")) do

			if (v:GetData("dry_status", false)) then continue end

			local leavesCount = v:GetData("leavesCount", 1)
			
			for i=1, leavesCount do
				self.DryTable[#self.DryTable+1] = (ix.config.Get("DryingTime", 20) * 60)
				howMany = howMany + 1
			end

			v:Remove()

		end

		self:CreateVisualLeaf(howMany)

		self:SetWetLeaves(self:GetWetLeaves() + howMany)

		local properName = (howMany == 1 and "one wet leaf") or howMany.." wet leaves"

		client:Notify("You have placed "..properName)

	else
		client:Notify("You don't have any wet leaves in your inventory")
	end

end

function ENT:CollectDryLeaves(client)

	if (self:GetDryLeaves() > 0) then

		local char = client:GetCharacter()
		local inv = char:GetInventory()

		local TakeFive = 0

		local SomeTaken = false

		for i=1, 5 do

			TakeFive = TakeFive + 1
			self:SetDryLeaves( math.max(self:GetDryLeaves() - 1, 0))

			if (self:GetDryLeaves() <= 0) then break end

		end

		local TakeLeft = TakeFive

		for k, v in ipairs(inv:GetItemsByUniqueID("coca_leaves")) do
			
			if (v:GetData("leavesCount", 1) < 5) and (v:GetData("dry_status")) then
					
				local CountAdd = TakeLeft

				if (v:GetData("leavesCount", 1) + CountAdd > 5) then
					CountAdd = 5 - v:GetData("leavesCount", 1)
				end

				v:SetData("leavesCount", v:GetData("leavesCount", 1) + CountAdd )

				TakeLeft = TakeLeft - CountAdd

				if (!SomeTaken) then
					SomeTaken = true
				end

			end

		end


		local itemData = {
			leavesCount = TakeLeft,
			dry_status = true
		}

		local IsAdded, ErrorInv = inv:Add("coca_leaves",1,itemData)

		if (!IsAdded) then
	        client:Notify(L(ErrorInv, client))
	        self:SetDryLeaves( math.max(self:GetDryLeaves() + TakeLeft, 0))

	        if (SomeTaken) then
	        	client:Notify("It was not possible to collect all the leaves. There are "..self:GetDryLeaves().." left to collect")
	        end

	        -- return false
	    end

	    if (self:GetWetLeaves() > 0) then
		    if (self:GetWetLeaves() < self:VisualLeafUsed()) then
		    	self:RemoveVisualLeaf(self:VisualLeafUsed() - self:GetWetLeaves())
		    end
		end

		if (self:GetDryLeaves() > 0) then
		    if (self:GetDryLeaves() < self:VisualLeafUsed()) then
		    	self:RemoveVisualLeaf(self:VisualLeafUsed() - self:GetDryLeaves())
		    end
		end

	    if (!SomeTaken) then

		    local properName = (TakeFive == 1 and "one dried leaf") or TakeFive.." dried leaves"

		    client:Notify("You have collected "..properName)

		end


	else

		client:Notify("There are no dry leaves to collect")
		

	end

end

function ENT:MachineSwitch(client)

	local CurState = self:GetIsWorking()

	if (CurState) then

		self:EmitSound("buttons/button19.wav")
		self:StopWorkSound()

	else

		self:EmitSound("buttons/button1.wav")

		self:StartWorkSound()

	end

	self:SetIsWorking(!CurState)

	self:EnableLampEffect(!CurState)

end

function ENT:OnOptionSelected(client, option, data)

	if (option == "Turn On/Off") then
		self:MachineSwitch(client)
	elseif (option == "Put the wet leaves") then
		self:PutWetLeaves(client)
	elseif (option == "Collect the dry leaves") then
		self:CollectDryLeaves(client)
	end

end

function ENT:OnRemove()

	self:StopWorkSound()

end

function ENT:StartWorkSound()

	if (self.Worksound) then
		self.Worksound:PlayEx(1, 100)
	else
	    self.Worksound = CreateSound(self, Sound("ambient/machines/power_transformer_loop_2.wav"))
	    self.Worksound:SetSoundLevel(60)
		self.Worksound:PlayEx(1, 100)
	end
end

function ENT:StopWorkSound()
	if self.Worksound then
        self.Worksound:Stop()
    end
end