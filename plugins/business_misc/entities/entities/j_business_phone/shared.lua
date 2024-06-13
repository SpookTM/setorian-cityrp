ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Business Phone"
ENT.Category = "Setorian Business"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "PhoneNumber" )
	self:NetworkVar( "Entity", 0, "Caller" )

end

function ENT:aphone_GetNumber()
	return self:GetPhoneNumber()
end