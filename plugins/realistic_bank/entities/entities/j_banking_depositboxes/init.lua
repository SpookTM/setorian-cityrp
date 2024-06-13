AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 90
	SpawnAng.r = SpawnAng.r + 90
	local ent = ents.Create( ClassName )
	ent:SetPos(SpawnPos)
	ent:SetAngles(SpawnAng)
	ent:Spawn()
	return ent
end

function ENT:Initialize()

	self:SetModel("models/hunter/blocks/cube025x075x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self:SetCooldown(0)

	self:SetLockPicking(false)

	self.NextTick = CurTime()


	for i=1, 5 do
		local Box = ents.Create("prop_dynamic");
		Box:SetModel("models/tobadforyou/deposit_box.mdl")
		Box:SetPos(self:GetPos() + self:GetAngles():Up() * 6 + self:GetAngles():Forward() * -6  + self:GetAngles():Right() * (32 - ((i-1)*8.1)) )
		Box:SetAngles(self:GetAngles() + Angle(0,90,-90))
		Box:SetParent(self);
		Box:Spawn();
	end

	PLUGIN:SaveJRBankingDepositBox()
end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRBankingDepositBox()
	end
end

function ENT:Think()

	if (self:GetCooldown() > 0) then

		if (self.NextTick < CurTime()) then

			self:SetCooldown(math.max(0, self:GetCooldown() - 1))

			self.NextTick = CurTime() + 1
		end
	elseif (self:GetLockPicking()) then

		local randSnds = {1,3,4}

		if (self.NextTick < CurTime()) then

			self:EmitSound("weapons/357/357_reload"..table.Random(randSnds)..".wav")

			self.NextTick = CurTime() + (math.random(6,10)/10)
		end

	end

end

function ENT:SelectRandomDeposit()

	local deposits = {}

	PLUGIN:GetAllAccountsData(function(data)

        for k,v in ipairs(data) do

            if (tonumber(v.deposit_id) == 0) then continue end

            if (PLUGIN.RobbedDepositBoxes[tonumber(v.deposit_id)]) then continue end

            local boxCost = (v.deposit_type == 2 and 350) or 150

            deposits[v.deposit_id] = true
            
        end

    end)

    if (table.Count(deposits) == 0) then
    	return false
    end

	return tonumber(select(2,table.Random(deposits)))


end

function ENT:Use(act, client)

	if (!client) then return end
	if (!client:Alive()) then return end
	if (!client:GetCharacter()) then return end

	if (client:GetCharacter():GetFaction() == PLUGIN.PoliceFaction) then
		client:Notify("You can't rob as a police officer")
		return
	end

	if (!PLUGIN:EnoughPolice()) then
		client:Notify("Not enough police officers")
		return
	end

	if (self:GetCooldown() > 0) then
		client:Notify("You have to wait before you can rob it again")
		return
	end

	self:EmitSound("physics/metal/paintcan_impact_soft"..math.random(1,3)..".wav", 60)
	self:SetLockPicking(true)

	client:SetAction("Lockpicking...", 30) -- for displaying the progress bar
	client:DoStaredAction(self, function()

		local selectedBox = self:SelectRandomDeposit()

		if (!selectedBox) then
			client:Notify("Deposit box is empty")
			return
		end


		PLUGIN.RobbedDepositBoxes[selectedBox] = true

		timer.Simple(18000,function()
			PLUGIN.RobbedDepositBoxes[selectedBox] = nil
			print("[Realistic Banking] "..selectedBox.." deposit box can be rob again.")
		end)


		local inv = ix.item.inventories[selectedBox]

		if (table.Count(inv:GetItems()) == 0) then
			client:Notify("The safety deposit box is empty")
			self:SetCooldown(18000)
			return false
		end

		local Randomitem, Randomitem_invID = table.Random(inv:GetItems())
		local RandomitemID = Randomitem.uniqueID
		local character = client:GetCharacter()

		if (!character:GetInventory():Add(RandomitemID, 1, Randomitem.data)) then
			ix.item.Spawn(RandomitemID, client, nil, Angle(0,0,0),Randomitem.data)
		end

		inv:Remove(Randomitem_invID)

		client:Notify("You stole "..Randomitem:GetName().." from "..selectedBox.." box")


		self:DoorOpen()

		self:EmitSound("doors/door_metal_medium_open1.wav",60)
		self:SetLockPicking(false)

	end, 30, function()
		if (!IsValid(self)) then return end
		client:SetAction()
		self:SetLockPicking(false)
	end)

end


function ENT:DoorOpen()

	self:SetCooldown(18000)

	self:EmitSound("doors/door_latch1.wav")

end

