include("shared.lua")
local lib = include("psychedelics/libs/cl/ents_cl.lua")
local blotter = include("psychedelics/libs/blotter.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent(flags)
	self:Draw(flags)
	local tipText=self:GetNWString("psychedelicsTipText","Add lysergic acid")
	if lib.checkTip(tipText, self) then
		lib.draw3D2DTip(tipText,self)
	end
end
