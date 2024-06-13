
local PANEL = {}

local wire = ix.util.GetMaterial("cable/cable")
local background = ix.util.GetMaterial("phoenix_storms/futuristictrackramp_1-2")

function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )
	
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
	
	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
	
end

function PANEL:Init()
	self:SetTitle("")
	self:SetSize(330, 260)
	-- self:DockPadding(0,0,0,0)
	self:Center()
	self:MakePopup()

	self.Paint = function(s,w,h)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(background)
		surface.DrawTexturedRect( 0,0,w,h )

		ix.util.DrawBlur(s)

		surface.SetDrawColor(Color(10,10,10,200))
		surface.DrawRect(0,0,w,h)

	end
	self.PaintOver = function(s,w,h)

		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(0,0,w,h,3)
	end

	self.colors = {
		[1] = Color(255,120,120),
		[2] = Color(0,255,0),
		[3] = Color(120,120,255),
		[4] = Color(241, 196, 15),
	}

	local NumBase = {1,2,3,4}

	self.SelectedWire = nil
	self.ConnectedWires = {}

	local HotWire = vgui.Create( "DPanel", self )
	HotWire:Dock(FILL)
	HotWire.Paint = function(s,w,h)

		for k, v in pairs(self.ConnectedWires) do

			local mX, mY = v.EndPnl:GetPos()

			local YPos = v.StartPnl:GetY() -20
			
			local wid = mX - 10
			local he = (20+YPos)-mY

			local len = math.sqrt(math.pow(wid,2)+math.pow(he,2))

			draw.NoTexture()
			surface.SetDrawColor(self.colors[k])
			surface.DrawTexturedRectRotatedPoint( 10,YPos, len, 10,math.deg(math.atan(he/wid)), -(len/2), 0 )
			
		end

		if (self.SelectedWire) then
			local mX, mY = self:CursorPos()

			local YPos = self.SelectedWire:GetY() -20
			
			local wid = mX - 10
			local he = (20+YPos)-mY

			local len = math.sqrt(math.pow(wid,2)+math.pow(he,2))

			draw.NoTexture()
			surface.SetDrawColor(self.colors[self.SelectedWire.id])
			surface.DrawTexturedRectRotatedPoint( 10,YPos, len, 10,math.deg(math.atan(he/wid)), -(len/2), 0 )

		end

	end
	
	for i=1,4 do
		
		local randomIndex = math.random( #NumBase )
		local randomNum = NumBase[ randomIndex ]

		table.remove(NumBase, randomIndex)

		local StartPoint = vgui.Create( "DButton", self )
		StartPoint:SetPos(0,50 * i)
		StartPoint:SetSize(30,20)
		StartPoint:SetText("")
		StartPoint.id=randomNum
		StartPoint.Paint = function(s,w,h)

			surface.SetDrawColor(self.colors[s.id])
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor(color_white)
			surface.DrawRect(0,0,w,2)
			surface.DrawRect(0,h-2,w,2)

		end
		StartPoint.DoClick = function(s)

			if (self.ConnectedWires[s.id]) then return end

			self.SelectedWire = s
			LocalPlayer():EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")

		end
		

	end
	local NumBase = {1,2,3,4}
	for i=1,4 do
		
		local randomIndex = math.random( #NumBase )
		local randomNum = NumBase[ randomIndex ]

		table.remove(NumBase, randomIndex)
		
		local EndPoint = vgui.Create( "DButton", self )
		EndPoint:SetPos(self:GetWide()-30,50 * i)
		EndPoint:SetSize(30,20)
		EndPoint:SetText("")
		EndPoint.id=randomNum
		EndPoint.Paint = function(s,w,h)
			surface.SetDrawColor(self.colors[s.id])
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor(color_white)
			surface.DrawRect(0,0,w,2)
			surface.DrawRect(0,h-2,w,2)
		end
		EndPoint.DoClick = function(s)
			if (self.SelectedWire) and (self.SelectedWire.id == s.id) then

				self.ConnectedWires[s.id] = {
					StartPnl = self.SelectedWire,
					EndPnl = s
				}
				self.SelectedWire = nil

				LocalPlayer():EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")

			end
		end

	end

	if (ix.gui.HotWireUI and IsValid(ix.gui.HotWireUI)) then
		ix.gui.HotWireUI:Close()
	end

	ix.gui.HotWireUI = self

end

function PANEL:OnClose()
	ix.gui.HotWireUI = nil

	if (table.Count(self.ConnectedWires) >= 4) then
		net.Start("HotWire_StartEngine")
		net.SendToServer()
	end

end

function PANEL:Think()

	if (table.Count(self.ConnectedWires) >= 4) then
		self:Close()
	end

end

vgui.Register("ixHotWireUI", PANEL, "DFrame")

-- vgui.Create("ixHotWireUI")