

-- local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_police_system") or false
local PLUGIN = PLUGIN
local monitorTexture = Material("setorian_police/monitor.png", "noclamp smooth" )
local lapdlogo = Material("setorian_police/lapd-logo.png", "noclamp smooth" )

local gradient = Material("vgui/gradient-d")

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(ScrW(),ScrH())
	self:Center()
	self:MakePopup()
	
	self:SetAlpha(0)

	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self:DockPadding(ScreenScale(100),ScreenScale(50),ScreenScale(100),20)

	self.Paint = function(s,w,h) 
		ix.util.DrawBlur(s)

	end

	local TitlePanel = vgui.Create( "DLabel", self )
	TitlePanel:Dock(TOP)
	TitlePanel:SetFont("ixTitleFont")
	TitlePanel:SetText( "Garage: Your Name Police Departament" )
	TitlePanel:SetContentAlignment(5)
	TitlePanel:SizeToContents()

	local DataScroll = vgui.Create( "DScrollPanel", self )
	DataScroll:Dock( FILL )
	DataScroll:DockMargin(0,10,0,10)
	DataScroll.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.DataScroll = DataScroll

	local UpdateButton = vgui.Create( "ixMenuButton", self )
	UpdateButton:Dock(BOTTOM)
	UpdateButton:DockMargin(0,10,0,0)
	UpdateButton:SetFont("ix3D2DMediumFont")
	UpdateButton:SetContentAlignment(5)
	UpdateButton:SetTall(70)
	UpdateButton:SetText( "UPDATE CARS" )
	UpdateButton:SetZPos(3)
	UpdateButton.DoClick = function()

		net.Start("ixPoliceSys_Update_GarageCars")
		net.SendToServer()

	end

	local ReturnCarButton = vgui.Create( "ixMenuButton", self )
	ReturnCarButton:Dock(BOTTOM)
	ReturnCarButton:DockMargin(0,10,0,0)
	ReturnCarButton:SetFont("ix3D2DMediumFont")
	ReturnCarButton:SetContentAlignment(5)
	ReturnCarButton:SetTall(70)
	ReturnCarButton:SetText( "RETURN POLICE CAR" )
	ReturnCarButton:SetZPos(2)
	ReturnCarButton.DoClick = function()

		net.Start("ixPoliceSys_ReturnPoliceCar")
		net.SendToServer()

	end

	local CloseButton = vgui.Create( "ixMenuButton", self )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(0,10,0,0)
	CloseButton:SetFont("ix3D2DMediumFont")
	CloseButton:SetContentAlignment(5)
	CloseButton:SetTall(70)
	CloseButton:SetText( "CLOSE MENU" )
	CloseButton:SetZPos(1)
	CloseButton.DoClick = function()

		self:AlphaTo(0, 0.3, 0, function() self:Close() end)
	end

	-- self:RenderCars()

	ix.gui.PoliceGarageUI = self

end

function PANEL:OnClose()
	ix.gui.PoliceGarageUI = nil
end

function PANEL:RenderCars(CarsTable, NoAnim)
	
	self.DataScroll:Clear()

	if (NoAnim) then
		self:SetAlpha(255)
	else	
		self:AlphaTo(255, 0.5)
	end

	if (!CarsTable) or (table.IsEmpty(CarsTable)) then

		local ErrorText = vgui.Create( "DLabel", self.DataScroll )
		ErrorText:Dock(TOP)
		ErrorText:DockMargin(0,10,0,0)
		ErrorText:SetFont("ixSubTitleFont")
		ErrorText:SetText( "No vehicles available. Check back later" )
		ErrorText:SetContentAlignment(5)
		ErrorText:SizeToContents()

		return
	end

	for k, v in ipairs(CarsTable) do

		-- local carExtraInfo = PLUGIN.PoliceCarVendor[k]

		-- local carTable = list.Get( "Vehicles" )[ k ]

		-- PrintTable(carTable)

		if (v.CarTaken) then continue end

		local ProfilePanel = vgui.Create( "Panel", self.DataScroll )
		ProfilePanel:Dock(TOP)
		ProfilePanel:DockMargin(0,0,0,10)
		ProfilePanel:DockPadding(10,10,10,10)
		ProfilePanel:SetTall(180)
		ProfilePanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local BGPanel = vgui.Create("DPanel", ProfilePanel)
		BGPanel:Dock(LEFT)
		-- BGPanel:DockMargin(0,0,10,0)
		BGPanel:DockPadding(3,3,3,3)
		BGPanel:SetWide(200)
		BGPanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local RPTCarModel = vgui.Create( "DModelPanel", BGPanel )
        RPTCarModel:Dock(FILL)
        RPTCarModel:SetFOV(40)
        RPTCarModel:SetCamPos(Vector(300, 300, 20))
        RPTCarModel:SetModel( v.CarModel or "models/error.mdl" )
        function RPTCarModel:LayoutEntity( ent ) 
        end

        local groups = {}

    	RPTCarModel.Entity:SetSkin(v.Skin or 0)

    	for k, v in pairs(v.BodyGroups or {}) do
    		
    		local bodyID = RPTCarModel.Entity:FindBodygroupByName( k )

    		if (bodyID > -1) then
    			groups[bodyID] = v
    			-- RPTCarModel.Entity:SetBodygroup(bodyID,v)
    		end

    	end

    	for index, value in pairs(groups) do
			RPTCarModel.Entity:SetBodygroup(index, value)
		end



        local CarName = vgui.Create( "DLabel", ProfilePanel )
		CarName:Dock(TOP)
		CarName:DockMargin(10,10,0,0)
		CarName:SetFont("ixSubTitleFont")
		CarName:SetText( "Name: "..v.CarName )
		CarName:SetContentAlignment(4)
		CarName:SizeToContents()

		local FuelValue = vgui.Create( "DLabel", ProfilePanel )
		FuelValue:Dock(TOP)
		FuelValue:DockMargin(10,10,0,0)
		FuelValue:SetFont("ixSubTitleFont")
		FuelValue:SetText( "Fuel: ".. ((v.Fuel and math.Round(v.Fuel)) or "FULL") )
		FuelValue:SetContentAlignment(4)
		FuelValue:SizeToContents()

		local TakeCarB = vgui.Create( "ixMenuButton", ProfilePanel )
		TakeCarB:Dock(BOTTOM)
		TakeCarB:DockMargin(10,10,0,0)
		TakeCarB:SetFont("ixMediumFont")
		TakeCarB:SetContentAlignment(5)
		TakeCarB:SetTall(40)
		TakeCarB:SetText( "TAKE CAR" )
		TakeCarB.DoClick = function()

			net.Start("ixPoliceSys_TakePoliceCar")
				net.WriteUInt(k,6)
			net.SendToServer()

		end
		

	end
	
end

vgui.Register("ixPolice_GarageMenu", PANEL, "DFrame")

-- vgui.Create("ixPolice_GarageMenu")

