AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 50
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 270
	local ent = ents.Create( ClassName )
	ent:SetPos(SpawnPos)
	ent:SetAngles(SpawnAng)
	ent:Spawn()
	return ent
end


function ENT:Initialize()

	self:SetModel("models/sterling/fbikid_atm.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then

		phys:Wake()

	end

	PLUGIN:SaveJRBankingATM()
	

end

function ENT:OnRemove()

	if (!ix.shuttingDown and !self.ixIsSafe) then
		PLUGIN:SaveJRBankingATM()
	end
end

function ENT:OpenUI(ply, cardnumber)

	if (!ply) then return end
	if (!ply:Alive()) then return end
	if (!ply:GetCharacter()) then return end

	local char = ply:GetCharacter()
	local inv = char:GetInventory()

	local data = {
        ["CardNumber"] = cardnumber,
    }

    local item = inv:HasItem("debit_card", data)

    if (item) then

    	local bankID = item:GetData("CardBankID")

    	local accountExists = false
    	local hasloan = false

    	PLUGIN:GetAllAccountsData(function(data)

    		for k, v in pairs(data) do
				if (tonumber(v.account_id) == bankID) then
					accountExists = true

					if (tonumber(v.loan) > 0) then
						if (tonumber(v.loantime) == 0) then
							hasloan = true
						end
					end

					break
				end
			end
		end)

    	netstream.Start(ply, "Jbanking_OpenATM_UI", accountExists, hasloan, cardnumber, item:GetData("CardBankID"), item:GetData("CardPIN"))
    end
 
end


