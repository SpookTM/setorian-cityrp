ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Furnace"
ENT.Category = "Setorian Mining System"

ENT.Spawnable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "WorkTime" )
	self:NetworkVar( "Int", 1, "MeltTime" )
	self:NetworkVar( "Bool", 0, "IsWorking" )

	self:NetworkVar( "Int", 2, "FuelCount" )
	self:NetworkVar( "Int", 3, "InputCount" )
	self:NetworkVar( "Int", 4, "OutputCount" )
	
end

function ENT:GetEntityMenu(client)
	local options = {}
	
	options["Open Menu"] = true
	options["Ignite/Extinguish"] = true

	return options
end