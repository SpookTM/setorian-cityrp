include("shared.lua")
local lib = include("psychedelics/libs/cl/ents_cl.lua")
local blotter = include("psychedelics/libs/blotter.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Quantity")
	self:NetworkVar("String", 0, "DataP")
end

local tipText = "Click 'e' to crop or 'e' +'shift' to add for selling"
function ENT:DrawTranslucent()
	self:Draw(flags)
	if lib.checkTip(tipText, self) then
		lib.draw3D2DTip(tipText,self)
	end
end

--below is the stuff used to update the submaterial of the blotters
function ENT:Initialize()
	blotter.tryUpdate(self)
end