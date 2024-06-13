AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

local digits = #string.Split(aphone.Format, "%s") - 1

local function free_number(id)
    -- We start from a "static" random number, will be consistent IF nobody got this number already in-game ( Very, very, very small chance to happens )
    util.SharedRandom("APhone", 0, 10^digits-1, id)
    local pick = math.random(0, 10^digits-1)

    -- if unavailable_numbers[pick] then
    --     while (unavailable_numbers[pick]) do
    --         pick = pick + 1
    --     end
    -- end

    -- unavailable_numbers[pick] = true
    return pick
end

function ENT:Initialize()

	self:SetModel("models/props/cs_office/phone.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	self:SetPhoneNumber(aphone.FormatNumber(free_number(self:EntIndex())))
	-- self.Caller = nil
	self.AnswerCooldown = CurTime()
	self.UpcomingCall = false
	self.RightoneCooldown = CurTime()

	self.LastCalls = {}
	PLUGIN:SaveJRPhones()
end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRPhones()
	end
end

local function end_call(ply)

	net.Start("aphone_Phone")
		net.WriteUInt(5, 4)
	net.Send(ply)
	
end

function ENT:Think()

	if (self.UpcomingCall) then
		if (self.RightoneCooldown < CurTime()) then
			self.RightoneCooldown = CurTime() + 2
			self:PlayRightone()
		end
		if (self.AnswerCooldown < CurTime()) then
			self.UpcomingCall = false
			end_call(self:GetCaller())
		end
	end

end

function ENT:InitCall(caller)

	-- self.Caller = caller
	self:SetCaller(caller)
	self.RightoneCooldown = CurTime()
	self.UpcomingCall = true
	self.AnswerCooldown = CurTime() + 30

	table.insert(self.LastCalls,1, caller:aphone_GetNumber())

	if (#self.LastCalls > 10) then
		table.remove( self.LastCalls, #self.LastCalls )
	end

end

function ENT:EndCall()
	-- self.Caller = nil
	self:SetCaller(nil)
	self.AnswerCooldown = CurTime()
	self.UpcomingCall = false
	self.RightoneCooldown = CurTime()
end

function ENT:PrepareCall(user)

	if (!IsValid(self:GetCaller())) or (self:GetCaller() == user) then
		self:EndCall()
		return
	end

	self.Caller = self:GetCaller()

	if self.Caller.aphoneCallID then
		local t = aphone.Call.Table[self.Caller.aphoneCallID]

		if !t then
			self.Caller.aphoneCallID = nil
			return
		end

		aphone.Call.Table[self.Caller.aphoneCallID] = nil

		if IsValid(t.ent1) then
			t.ent1.aphone_PVS = nil
			t.ent1.aphoneCallID = nil
		end

		if IsValid(t.ent2) then
			t.ent2.aphone_PVS = nil
			t.ent2.aphoneCallID = nil
		end
	end

	local id_tbl = table.insert(aphone.Call.Table, {
		pending = false,
		ent1 = user,
		ent2 = self.Caller,
	})
	user.aphoneCallID = id_tbl
	self.Caller.aphoneCallID = id_tbl

end

function ENT:PlayRightone()
	self:EmitSound("akulla/phone_ringing.mp3")
end

function ENT:Use( act, call)

	if (call:IsPlayer()) then
		call:SetLocalVar("BPhone_Ent",self)

		if (self.UpcomingCall) then
			self:PrepareCall(call)
		end

		net.Start("ixBPhone_OpenUI")
			net.WriteBool(self.UpcomingCall)
			PLUGIN:SentNetTable(self.LastCalls)
		net.Send(call)

		self.UpcomingCall = false
	end

end