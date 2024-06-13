include("shared.lua")
local lib = include("psychedelics/libs/cl/ents_cl.lua")

local tipTextBar = "Water Level"
local function waterBar(ent)
	local water = ent:GetNWInt("psychedelicsWaterLevel", 100)
	local mins, maxs = ent:GetModelBounds()
	local pos = ent:LocalToWorld(Vector(maxs.x, 0, maxs.z / 2))
	local ang = ent:LocalToWorldAngles(Angle(0, 90, 90))
	local barWidth = Lerp(water / 100, 0, 300)
	cam.Start3D2D(pos, ang, 0.1)

	--draw rectangles
	draw.NoTexture() -- fixes material bugs
	surface.SetDrawColor(HSVToColor(184, 0.46, 0.86))
	surface.DrawRect(-154, -14, 308, 28)
	surface.SetDrawColor(HSVToColor(Lerp(water / 100, 0, 120), 0.46, 0.86))
	surface.DrawRect(-150, -10, barWidth, 20)

	--draw text
	surface.SetFont("DermaLarge")
	local w, h = surface.GetTextSize(tipTextBar)
	surface.SetTextColor(230, 230, 230)
	surface.SetTextPos(-w / 2, -h / 0.7) -- center the text
	surface.DrawText(tipTextBar)

	cam.End3D2D()
end

function ENT:Draw() self:DrawModel(flags) end

function ENT:DrawTranslucent(flags)
	self:Draw(flags)

	if lib.checkDist(self) then 
		waterBar(self) 
	end

	local tipText = self:GetNWString("psychedelicsTipText", "Add mushroom substrate (0/3)")
	if lib.checkTip(tipText, self) then 
		lib.draw3D2DTip(tipText, self) 
	end

end
