include("shared.lua")
local lib = include("psychedelics/libs/cl/ents_cl.lua")
function ENT:Draw()
	self:DrawModel()
end
local tipText = "Press 'e' to use or 'e'+'shift' to add for selling"
function ENT:DrawTranslucent()
	self:Draw(flags)
    if lib.checkTip(tipText, self) then
        lib.draw3D2DTip(tipText, self)
    end
end