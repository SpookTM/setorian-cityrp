
local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)

	local LegendScale = math.Clamp(self:GetParent():GetWide()*0.25, 200, 600)

	self.LegendPnl = vgui.Create("DScrollPanel", self)
    self.LegendPnl:Dock(RIGHT)
    self.LegendPnl:DockPadding(2,2,2,2)
    self.LegendPnl:SetWide(LegendScale)
    self.LegendPnl.Paint = function(s,w,h)
		surface.SetDrawColor(60,60,60, 200)
		surface.DrawRect(0, 0, w, h)
	end
	self.LegendPnl.Icons = {}

	for k, v in pairs(paris.MapBlips or {}) do

		if (v.Zone == paris.Zone) or (v.Zone=="*") then

			if (!PLUGIN.MapLegend[v.Icon]) then continue end			

			if (self.LegendPnl.Icons[v.Icon]) then
				continue
			else
				self.LegendPnl.Icons[v.Icon] = true
			end

			local LegendIconPnl = vgui.Create("DPanel", self.LegendPnl)
    		LegendIconPnl:Dock(TOP)
    		LegendIconPnl:DockMargin(2,2,2,3)
    		LegendIconPnl:SetTall(34)
    		LegendIconPnl.Paint = function(s,w,h)
				surface.SetDrawColor(0,0,0, 150)
				surface.DrawRect(0, 0, w, h)
			end

			local IconImage = vgui.Create( "DImage", LegendIconPnl )
			IconImage:Dock(LEFT)
			IconImage:DockMargin(2,2,2,2)
			IconImage:SetWide(30)
			IconImage:SetImage(v.Icon)

			local IconExplain = vgui.Create( "DLabel", LegendIconPnl )
			IconExplain:Dock(FILL)
			IconExplain:DockMargin(5,0,0,0)
			-- IconExplain:DockMargin(30,0,5,0)
			-- IconExplain:SetContentAlignment( 7 )
			IconExplain:SetFont("ixSmallFont")
			IconExplain:SetText(PLUGIN.MapLegend[v.Icon])

		end

	end

end

function PANEL:LoadMap()

	if (IsValid(self.GTABigMapMain)) then self.GTABigMapMain:Remove() end

	self.GTABigMapMain = vgui.Create("Panel", self)
	self.GTABigMapMain:Dock(FILL)
    self.GTABigMapMain:DockMargin(0,0,5,0)
    self.GTABigMapMain.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20, 150)
		surface.DrawRect(0, 0, w, h)
	end

	local OriginalWide = self:GetParent():GetWide()-200


	self.GTABigMapPnl = vgui.Create("DButton",  self.GTABigMapMain)
    self.GTABigMapPnl:Dock(FILL)
    self.GTABigMapPnl:DockMargin(5,5,5,5)
    self.GTABigMapPnl.OffsetX = 0
    self.GTABigMapPnl.OffsetY = 0
    self.GTABigMapPnl.MarginX = 0
    self.GTABigMapPnl.MarginY = 0
    self.GTABigMapPnl:SetText("")
    self.GTABigMapPnl:SetCursor("sizeall")
    self.GTABigMapPnl.Paint = function(s,w,h)
    	surface.SetDrawColor(39,39,39)
		surface.DrawRect(0, 0, w, h)
	end
	self.GTABigMapPnl.DragMousePress = function(s)
		s.PressX, s.PressY = gui.MousePos()
		s.Pressed = true
	end

	self.GTABigMapPnl.DragMouseRelease = function(s)
		s.Pressed = false
	end
	self.GTABigMapPnl.CheckMapSize = function(s)

		local LegendScale = math.Clamp(self:GetParent():GetWide()*0.25, 200, 600)

		if (self.GTABigMapMat:GetX() > 0) then
			self.GTABigMapMat:SetX(0)
		elseif (self.GTABigMapMat:GetX() + self.GTABigMapMat:GetWide() < (self:GetParent():GetWide()-LegendScale)) and (self.GTABigMapMat:GetWide() > (self:GetParent():GetWide()-LegendScale)) then
			self.GTABigMapMat:SetX((self:GetParent():GetWide()-LegendScale) - self.GTABigMapMat:GetWide())
		elseif (self.GTABigMapMat:GetWide() < (self:GetParent():GetWide()-LegendScale)) and (self.GTABigMapMat:GetX() < 0) then
			self.GTABigMapMat:SetX(0)
		end

		if (self.GTABigMapMat:GetY() > 0) then
			self.GTABigMapMat:SetY(0)
		elseif (self.GTABigMapMat:GetY() + self.GTABigMapMat:GetTall() < self:GetParent():GetTall()) then
			self.GTABigMapMat:SetY(self:GetParent():GetTall() - self.GTABigMapMat:GetTall())
		end


	end
	self.GTABigMapPnl.Think = function(s)

		if (s.Pressed) then
			local mx, my = gui.MousePos()

			self.GTABigMapMat:SetX(self.GTABigMapMat:GetX() - ((s.PressX or mx) - mx) )
			self.GTABigMapMat:SetY(self.GTABigMapMat:GetY() - ((s.PressY or my) - my) )

			s:CheckMapSize()

			s.PressX, s.PressY = gui.MousePos()


		end
		
	end
	self.GTABigMapPnl.OnMouseWheeled = function(s, delta)

		local actualX, actualY = s:LocalCursorPos()


		self.GTABigMapMat:SetSize(self.GTABigMapMat:GetWide() + (100*delta), self.GTABigMapMat:GetTall() + (100*delta))
		

		if (self.GTABigMapMat:GetWide() > self:GetParent():GetTall()) then

			self.GTABigMapMat:SetX(self.GTABigMapMat:GetX() - ((actualX/5)*delta) )

			self.GTABigMapMat:SetY(self.GTABigMapMat:GetY() - ((actualY/5)*delta) )

		else
			self.GTABigMapMat:SetSize(self:GetParent():GetTall(),self:GetParent():GetTall())
		end

		s:CheckMapSize()

	end
		

	self.GTABigMapMat = vgui.Create("DPanel", self.GTABigMapPnl)
	self.GTABigMapMat:SetMouseInputEnabled(false)
    self.GTABigMapMat:SetPos(0,0)
    self.GTABigMapMat:SetSize(self:GetParent():GetTall(),self:GetParent():GetTall())
    self.GTABigMapMat.OffsetX = 0
    self.GTABigMapMat.OffsetY = 0
    self.GTABigMapMat.Zoom = 240
    self.GTABigMapMat.Zoominf = 240
    self.GTABigMapMat.AnimOffset = 0
    self.GTABigMapMat.ratio = 1

	self.GTABigMapMat.top = self.GTABigMapMat:GetY() + self.GTABigMapMat:GetTall() * 0.5 - self.GTABigMapMat:GetWide() * self.GTABigMapMat.ratio * 0.5
	self.GTABigMapMat.bottom = self.GTABigMapMat:GetY() + self.GTABigMapMat:GetTall() * 0.5 + self.GTABigMapMat:GetWide() * self.GTABigMapMat.ratio * 0.5

    self.GTABigMapMat.CachedMats = {}

    local mapmin,mapmax = game.GetWorld():GetModelBounds()

    local mapx = mapmax.x-mapmin.x
    local mapy = mapmax.y-mapmin.y

    local mapTranslate = Vector(0,0,0)

    local matPnlW, matPnlH = self:GetSize()

    if (paris) then

    	mapTranslate = paris.Translate
    	
	    mapx = mapx * paris.ScaleX
	    mapy = mapy * paris.ScaleY
    	
    end

    local BipDefault = ix.util.GetMaterial(paris.HUDSettings["blipdefault_local"].mat)

    self.GTABigMapMat.Paint = function(s,w,h)

    	if (paris) then

    		-- s.Zoom = Lerp( 4 * FrameTime() , s.Zoom , s.Zoominf)
    		-- s.OffsetX = Lerp( 4 * FrameTime() , s.OffsetX , s.AnimOffset)
    		-- s.OffsetY = Lerp( 4 * FrameTime() , s.OffsetY , s.AnimOffset)

			surface.SetDrawColor( Color(255,255,255, 200) )
		    surface.SetMaterial( paris.Mat )
			surface.DrawTexturedRect(0,0,w,h)

			local plyAng = LocalPlayer():GetAngles()
			local iconAng = Angle(0,plyAng.y,0) --Angle(number pitch = 0, number yaw = 0, number roll = 0)

			local plyPos = LocalPlayer():GetPos()

			local mapCenterVectorX, mapCenterVectorY = (w*mapTranslate.x)/mapx, (h*mapTranslate.y)/mapy

			mapCenterVectorX = (mapCenterVectorX)
			mapCenterVectorY = (mapCenterVectorY)
			

			local centerX, centerY = w/2, h/2

			local mapCenterX, mapCenterY = w/(mapx/2), h/(mapy/2)

			-- local test = WorldToLocal(plyPos, Angle(), Vector(centerX, centerY,0), Angle(0,0,0))

			-- local LocalPlyPosX, LocalPlyPosY = plyPos.x/centerX, plyPos.y/centerY

			local LocalPlyPosX, LocalPlyPosY = (w*plyPos.x)/mapx, (h*plyPos.y)/mapy

			-- print(plyPos.x,centerX, mapCenterX,LocalPlyPosX)
			-- print(centerX, centerY)

			local RatX = (LocalPlyPosX)
			local RatY = (LocalPlyPosY)

			
			-- local RatX = LocalPlyPosX/matPnlW
            -- local RatY = v.y/ScrH()
            -- local x = (RatX*w)


			local wid = w*0.025
            local hei = h*0.025

            local iconScale = math.min(w*0.025, 32)


			for k, v in pairs(paris.MapBlips or {}) do

				if (v.Zone == paris.Zone) or (v.Zone=="*") then

					if (!self.GTABigMapMat.CachedMats[k]) then
						self.GTABigMapMat.CachedMats[k] = Material(v.Icon, "noclamp smooth")
					end

					local BlipPosX, BlipPosY = (w*v.Pos.x)/mapx, (h*v.Pos.y)/mapy

					BlipPosX = (BlipPosX)
					BlipPosY = (BlipPosY)

					surface.SetDrawColor( v.Color )
				    surface.SetMaterial( self.GTABigMapMat.CachedMats[k] )
					surface.DrawTexturedRect( centerX - mapCenterVectorX + BlipPosX - (iconScale/2), centerY + mapCenterVectorY - BlipPosY - (iconScale/2),iconScale,iconScale)

				end

			end
			
			if (BipDefault) then
				surface.SetDrawColor( paris.HUDSettings["blipdefault_local"].col )
			    surface.SetMaterial( BipDefault )
				surface.DrawTexturedRectRotated( centerX - mapCenterVectorX + RatX, centerY + mapCenterVectorY - RatY,iconScale,iconScale, plyAng.y - 90)
			end


		end

	end

end

function PANEL:RemoveMap()

	if (IsValid(self.GTABigMapMain)) then self.GTABigMapMain:Remove() end

end

function PANEL:Paint(w,h)
	-- surface.SetDrawColor(220,220,220, 250)
	-- 	surface.DrawRect(0, 0, w, h)
end


vgui.Register("ixGtaBigMap", PANEL, "EditablePanel")

hook.Add("CreateMenuButtons", "ixGtaBigMap", function(tabs)

	if (paris) then
		tabs["map"] = {

			Create = function(info, container)
				container.gtamap = container:Add("ixGtaBigMap")
			end,
			OnSelected = function(info, container)
				container.gtamap:LoadMap()
			end,
			OnDeselected = function(info, container)
				container.gtamap:RemoveMap()
			end
			
		}
	end
	

end)
