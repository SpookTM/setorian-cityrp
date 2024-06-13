ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Cash Register"
ENT.Category = "Setorian Business"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "OwnerCharID" )
	self:NetworkVar( "Entity", 0, "CurUser" )

	self:NetworkVar( "Int", 1, "Funds" )
	self:NetworkVar( "Bool", 0, "IsLock" )
	self:NetworkVar( "String", 0, "Permissions" )

	self:NetworkVar( "Int", 2, "BankID" )

end

function ENT:GetEntityMenu(client)
	local options = {}

	options["Open UI"] = true
	options["Steal"] = true


	return options
end