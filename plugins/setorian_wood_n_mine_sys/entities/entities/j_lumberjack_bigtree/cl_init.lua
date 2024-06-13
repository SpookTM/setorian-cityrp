include("shared.lua")


function ENT:Initialize()
end

local matBallGlow = Material("models/props_combine/tpballglow")

function ENT:AnimatedFadeOut(Color)

	local plyDist = LocalPlayer():GetPos():DistToSqr(self:GetPos())

	local DistanceAlpha = math.Clamp( math.Remap(plyDist , 260*260, 200*200, 0, Color.a ), 0, Color.a)

	return ColorAlpha( Color, DistanceAlpha )
end

net.Receive("WoodBigTree_Spawn", function()
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end

    ent.height = 0
    ent.StartTime = CurTime()
end)

function ENT:Draw()

	self.height = self.height or self:OBBMaxs().z
    self.colr = self.colr or 1
    self.colg = self.colg or 0
    self.StartTime = self.StartTime or CurTime()

	if (ix.config.Get("BigtreeRespawn", 60) > 0) and self.height < self:OBBMaxs().z then
        self:drawSpawning()
    else
        self:DrawModel()
    end

end

function ENT:drawSpawning()

	local spawnTime = ix.config.Get("BigtreeRespawn", 60)

    render.MaterialOverride(matBallGlow)

    render.SetColorModulation(self.colr, self.colg, 0)

    self:DrawModel()

    render.MaterialOverride()
    self.colr = 1 - ((CurTime() - self.StartTime) / spawnTime)
    self.colg = (CurTime() - self.StartTime) / spawnTime

    render.SetColorModulation(1, 1, 1)

    render.MaterialOverride()

    local normal = - self:GetAngles():Up()
    local pos = self:LocalToWorld(Vector(0, 0, self:OBBMins().z + self.height))
    local distance = normal:Dot(pos)
    self.height = self:OBBMaxs().z * ((CurTime() - self.StartTime) / spawnTime)
    render.EnableClipping(true)
    render.PushCustomClipPlane(normal, distance)

    self:DrawModel()

    render.PopCustomClipPlane()
end


ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)
	
	local panel = tooltip:AddRow("name")
	panel:SetText("Tree")
	panel:SetImportant()
 	panel:SizeToContents()

 	local desc = tooltip:AddRowAfter("name", "desc")
	desc:SetText("Use the hatchet to get wooden logs.")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end