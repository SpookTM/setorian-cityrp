include("shared.lua")


function ENT:Initialize()
end

local matBallGlow = Material("models/props_combine/tpballglow")

function ENT:AnimatedFadeOut(Color)

	local plyDist = LocalPlayer():GetPos():DistToSqr(self:GetPos())

	local DistanceAlpha = math.Clamp( math.Remap(plyDist , 260*260, 200*200, 0, Color.a ), 0, Color.a)

	return ColorAlpha( Color, DistanceAlpha )
end

net.Receive("NodeOre_Spawn", function()
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end

    ent.height = 0
    ent.StartTime = CurTime()
end)

function ENT:Draw()

	self.height = self.height or 100
    self.colr = self.colr or 1
    self.colg = self.colg or 0
    self.StartTime = self.StartTime or CurTime()

	if (ix.config.Get("nodeRespawn", 60) > 0) and self.height < self:OBBMaxs().z then
        self:drawSpawning()
    else
        self:DrawModel()
    end

	-- local Ang = self:GetAngles()

	-- Ang:RotateAroundAxis(self:GetAngles():Right(), -90)
	-- Ang:RotateAroundAxis(self:GetAngles():Forward(), 90)

	-- if (LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 300*300)then	
	-- 	cam.Start3D2D( self:GetPos() + Ang:Right() * -10 + Ang:Up() * 8.45, Ang, 0.1 )
		
	-- 	surface.SetDrawColor(self:AnimatedFadeOut(Color(47, 53, 66)))
	--     surface.DrawRect(-240,-10,480,70)

	--     surface.SetDrawColor(self:AnimatedFadeOut(Color(44, 62, 80, 230)))
	--     surface.DrawRect(-240,-5,480,60)

	-- 	draw.DrawText("POLICE LOCKER", "ix3D2DMediumFont", 0,0, self:AnimatedFadeOut(Color(255,255,255)), TEXT_ALIGN_CENTER )
	-- 	cam.End3D2D()
	-- end

end

function ENT:drawSpawning()

	local spawnTime = ix.config.Get("nodeRespawn", 60)

    render.MaterialOverride(matBallGlow)

    render.SetColorModulation(self.colr, self.colg, 0)

    self:DrawModel()

    render.MaterialOverride()
    self.colr = 1 - ((CurTime() - self.StartTime) / spawnTime)
    self.colg = (CurTime() - self.StartTime) / spawnTime

    render.SetColorModulation(1, 1, 1)

    render.MaterialOverride()

    local normal = - self:GetAngles():Up()
    local pos = self:LocalToWorld(Vector(0, 0, self:OBBMins().z + self.height + 5))
    local distance = normal:Dot(pos)
    self.height = self:OBBMaxs().z * ((CurTime() - self.StartTime) / spawnTime)
    render.EnableClipping(true)
    render.PushCustomClipPlane(normal, distance)

    self:DrawModel()

    render.PopCustomClipPlane()
end


ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)

	local nodeName = self:GetNodeName()
	
	local panel = tooltip:AddRow("name")
	panel:SetText(nodeName.." node")
	panel:SetImportant()
 	panel:SizeToContents()

 	local desc = tooltip:AddRowAfter("name", "desc")
	desc:SetText("Use the pickaxe to get ore.")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end