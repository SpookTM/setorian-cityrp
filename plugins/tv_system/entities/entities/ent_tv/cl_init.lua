include("shared.lua");

local glowMaterial = Material("sprites/glow04_noz")

function ENT:Think()
	if (not self.texture or not self.material) then
		self:CreateTexMat()
	end

	ix.tv.instances[self] = LocalPlayer():IsLineOfSightClear(self)
end

function ENT:Draw()
	self:DrawModel()

	local position = self:GetPos()

	render.SetMaterial(glowMaterial)

	if self.buttons then
		for k, v in ipairs(self.buttons) do
			if not v.CanWork or v.CanWork() then
				local closest = self:FindButton(LocalPlayer(), k);
				local pos = position + v.forward * self:GetForward() + v.right * self:GetRight() + v.up * self:GetUp()
				local color = v.color
				render.DrawSprite(pos, 4, 4, color)

				if (closest ~= k) then
					color.a = color == Color(255, 0, 0) and 100 or 75
				else
					color.a = 230 + (math.sin(RealTime() * 7.5) * 25)
				end
			end;
		end;
	end;
end

function ENT:OnRemove()
	if ix.tv.instances[self] then
		ix.tv.instances[self] = nil;
	end;
end;

function ENT:CreateTexMat()
	ix.tv.matrixes = ix.tv.matrixes + 1

	self.texture = GetRenderTarget("tv_rt" .. ix.tv.matrixes, 512, 256)
	self.material = CreateMaterial("tv_un_rt" .. ix.tv.matrixes, "UnlitGeneric", {
		["$basetexture"] = self.texture,
	})
end