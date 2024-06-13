ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Processor"
ENT.Category = "Setorian Cocaine"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "ProcesLeaves" )
	self:NetworkVar( "Int", 1, "WorkTime" )
	self:NetworkVar( "Bool", 0, "IsWorking" )
	self:NetworkVar( "Bool", 1, "BrickReady" )

end

function ENT:GetEntityMenu(client)
	local options = {}
	
	options["Put the dried leaves"] = true
	options["Take a cocaine brick"] = true
	options["Turn On/Off"] = true

	return options
end