
surface.CreateFont("ixLaptopIcons", {
	font = "fontello",
	extended = true,
	size = 120,
	weight = 500
})

local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_police_system") or false
-- local PLUGIN = PLUGIN
local monitorTexture = Material("setorian_police/monitor.png", "noclamp smooth" )
local lapdlogo = Material("setorian_police/pd.png", "noclamp smooth" )

local gradient = Material("vgui/gradient-d")

local PANEL = {}
DEFINE_BASECLASS("Panel")

function PANEL:Init()


	local Card_Title = vgui.Create( "DLabel", self )
	Card_Title:Dock(TOP)
	Card_Title:SetFont("ixSmallFont")
	Card_Title:SetText( "" )
	Card_Title:SetAutoStretchVertical(true)
	Card_Title:SetContentAlignment(5)

	self.Card_Title = Card_Title

	local Card_TitleBG = vgui.Create( "DPanel", self )
	Card_TitleBG:Dock(FILL)
	Card_TitleBG.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)
	end

	local Card_TitleBG_Text = vgui.Create( "DLabel", Card_TitleBG )
	Card_TitleBG_Text:Dock(FILL)
	Card_TitleBG_Text:SetFont("ixSmallFont")
	Card_TitleBG_Text:SetText( "" )
	Card_TitleBG_Text:SetContentAlignment(5)

	self.CardText = Card_TitleBG_Text

end

function PANEL:SetTitle(title)
	self.Card_Title:SetText( title )
end

function PANEL:SetText(text)
	self.CardText:SetText( text )
end

vgui.Register("ixPolice_CardPanel", PANEL, "Panel")

local animationTime = 1
DEFINE_BASECLASS("DFrame")
PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(1000,600)
	self:Center()
	self:MakePopup()
	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self.AFKReset = 60
	self.AFKTimer = CurTime() + self.AFKReset

	self.CaseID = nil
	self.CaseOpen = false

	self.Paint = function(s,w,h) 
		surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(60,20,w-120,h-90)

	    surface.SetDrawColor(52, 73, 94, 255)
	    surface.DrawRect(75,60,w-150,h-150)

     --    surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(45,45,w-90,20)

	    draw.SimpleText(os.date( "%H:%M"), "ix3D2DSmallFont", 72,35, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
	    draw.SimpleText("LHPD OS", "ix3D2DSmallFont", w-77,35, Color( 240,240,240 ), TEXT_ALIGN_RIGHT,TEXT_ALIGN_RIGHT)


	end
	self.PaintOver = function(s,w,h)

		surface.SetDrawColor( 255,255,255 )
	    surface.SetMaterial( monitorTexture )
		surface.DrawTexturedRect(0,0,w,h)


	end


	local InsideMonitor = vgui.Create( "Panel", self )
	InsideMonitor:Dock(FILL)
	InsideMonitor:DockMargin(38,5,38,70)
	InsideMonitor:DockPadding(20,10,20,5)

	self.MainPanel = InsideMonitor

	surface.PlaySound("buttons/lightswitch2.wav")
	self:LoginAnimation()
	-- self:RenderMenu()

	ix.gui.PolicePDA = self

end

function PANEL:OnClose()
	ix.gui.PolicePDA = nil
end

function PANEL:Think()

	if (!self.CaseOpen) then return end
	if (self.BClosing) then return end

	if (self.AFKTimer < CurTime()) then

		LocalPlayer():Notify("Case has been closed due to player inactivity")

		self.BClosing = true

		self.AFKTimer = CurTime() + self.AFKReset

		if (self.CaseID) then
			net.Start("ixPoliceSys_ClaimCase")
			net.WriteBool(false)
			net.WriteUInt(self.CaseID, 17)
			net.SendToServer()
		end

		self.CaseID = nil
		self.CaseOpen = false

		self:TransitionAnim(4)

	end

end

function PANEL:LoginAnimation()

	local WelcomeMsg = vgui.Create( "DLabel", self.MainPanel )
	WelcomeMsg:Dock(TOP)
	WelcomeMsg:DockMargin(0,130,0,0)
	WelcomeMsg:SetFont("ix3D2DMediumFont")
	WelcomeMsg:SetContentAlignment(5)
	WelcomeMsg:SetText( "Loading")
	WelcomeMsg:SetAlpha(0)
	WelcomeMsg:SetAutoStretchVertical(true)

	WelcomeMsg:AlphaTo(255, 1)

	local speed = 0.5
	local barStatus = 0
	
	local LoadingPanel = vgui.Create( "DPanel", self.MainPanel )
	LoadingPanel:Dock(TOP)
	LoadingPanel:DockMargin(200,30,200,0)
	LoadingPanel:SetAlpha(0)
	LoadingPanel.Loading = false
	LoadingPanel.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20)
	    surface.DrawRect(0,0,w,h)

	    if (s.Loading) then
		    barStatus = math.Clamp(barStatus + speed * FrameTime(), 0, 1)
		end

	    surface.SetDrawColor(20,200,20)
	    surface.DrawRect(2,2,(w-4) * barStatus,h-4)

	    if (barStatus == 1) and (s.Loading) then
			self:RenderMenu()
			s.Loading = false
		end

	end

	LoadingPanel:AlphaTo(255, 1,0.5, function() 
		LoadingPanel.Loading = true
	end)

	self.LoadingPanel = LoadingPanel


	local CloseButton = vgui.Create( "ixMenuButton", self.MainPanel )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(15,10,15,15)
	CloseButton:SetFont("ix3D2DMediumFont")
	CloseButton:SetContentAlignment(5)
	CloseButton:SetTall(70)
	CloseButton:SetText( "Cancel" )
	CloseButton.DoClick = function()

		self:AlphaTo(0, 0.3, 0, function() self:Close() end)
	end

end

function PANEL:RenderMenu()

	self.MainPanel:Clear()

	-- self.MainPanel:AlphaTo(0, 0.2,0, function() 
	-- 	self.MainPanel:Clear()

	-- 	self.MainPanel:AlphaTo(255, 0.2)
	-- end)

	surface.PlaySound("buttons/lightswitch2.wav")

	local ContextPanel = vgui.Create( "Panel", self.MainPanel )
	ContextPanel:Dock(FILL)
	ContextPanel:DockMargin(20,25,20,15)
	ContextPanel:SetAlpha(0)
	-- ContextPanel.Paint = function(s,w,h)
	-- 	surface.SetDrawColor(220,20,20)
	--     surface.DrawRect(0,0,w,h)

	-- end

	ContextPanel:AlphaTo(255, 1)


	local ButtonList = vgui.Create( "Panel", ContextPanel )
	ButtonList:Dock(LEFT)
	ButtonList:SetWide(150)

	local TabContentPanel = vgui.Create( "Panel", ContextPanel )
	TabContentPanel:Dock(FILL)
	TabContentPanel:DockMargin(10,0,0,0)
	-- TabContentPanel.Paint = function(s,w,h)
	-- 	surface.SetDrawColor(220,20,20)
	--     surface.DrawRect(0,0,w,h)

	-- end

	self.TabPanel = TabContentPanel

	local buttonsFunc = {
		[1] = {
			BName = "Dashboard",
			BIcon = "9",
			BMenu = function()
				self:TransitionAnim()
			end
		},
		[2] = {
			BName = "People",
			BIcon = "/",
			BMenu = function()
				self:TransitionAnim(1)
			end
		},
		[3] = {
			BName = "Plates",
			BIcon = "]",
			BMenu = function()
				self:TransitionAnim(2)
			end
		},
		[4] = {
			BName = "Guns",
			BIcon = "S",
			BMenu = function()
				self:TransitionAnim(3)
			end
		},
		[5] = {
			BName = "Cases",
			BIcon = ";",
			BMenu = function()
				self:TransitionAnim(4)
			end
		},
	}

	local SelectedMenu = 1

	for k, v in ipairs(buttonsFunc) do
		
		local ButtonPanel = vgui.Create( "DButton", ButtonList )
		ButtonPanel:Dock(TOP)
		ButtonPanel:DockMargin(0,0,0,10)
		ButtonPanel:SetText("")
		ButtonPanel:SetTall(50)
		ButtonPanel:SetIsToggle(true)
		ButtonPanel:SetToggle(k==1)
		ButtonPanel.barAnim = 0
		ButtonPanel.Paint = function(s,w,h)

			if (s:IsHovered()) or (s:GetToggle()) then
				s.barAnim = math.Clamp(s.barAnim + 5 * FrameTime(), 0, 1)
			else
				s.barAnim = math.Clamp(s.barAnim - 5 * FrameTime(), 0, 1)
		    end

		    surface.SetDrawColor(20,20,20,50)
		    surface.DrawRect(0,0,w,h)

		    surface.SetDrawColor(20,20,20,100)
		    surface.DrawRect(0,0,w * s.barAnim,h)


		end
		ButtonPanel.OnCursorEntered = function(s)
			LocalPlayer():EmitSound("Helix.Rollover")
		end
		ButtonPanel.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")
			
			if (SelectedMenu == k) then return end

			v.BMenu()

			for k,v in pairs(ButtonList:GetChildren()) do
				v:SetToggle(false)
			end

			s:SetToggle(true)
			SelectedMenu = k
		end

		local ButtonIcon = vgui.Create( "DLabel", ButtonPanel )
		ButtonIcon:Dock(LEFT)
		-- ButtonIcon:DockMargin(0,50,0,0)
		ButtonIcon:SetWide(40)
		ButtonIcon:SetFont("ixIconsMedium")
		ButtonIcon:SetContentAlignment(5)
		ButtonIcon:SetText( v.BIcon )
		ButtonIcon:SetAutoStretchVertical(true)

		local ButtonLabel = vgui.Create( "DLabel", ButtonPanel )
		ButtonLabel:Dock(FILL)
		ButtonLabel:DockMargin(0,15,0,0)
		ButtonLabel:SetFont("ixMediumFont")
		ButtonLabel:SetContentAlignment(4)
		ButtonLabel:SetText( v.BName )
		ButtonLabel:SetAutoStretchVertical(true)

	end
	
	local CloseButton = vgui.Create( "ixMenuButton", ContextPanel )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(10,5,0,0)
	CloseButton:SetFont("ixMediumFont")
	CloseButton:SetContentAlignment(5)
	CloseButton:SetTall(40)
	CloseButton:SetText( "Log out" )
	CloseButton.DoClick = function()

		self:AlphaTo(0, 0.3, 0, function() self:Close() end)
	end

	-- self:RenderPersonData()
	self:RenderDashboard()

end

function PANEL:TransitionAnim(menuType)

	local menus = {
		[1] = function()
			self:RenderPersonData()
		end,
		[2] = function()
			self:RenderPlatesData()
		end,
		[3] = function()
			self:RenderGunsData()
		end,
		[4] = function()
			self:RendersCases()
		end,
	}

	self.TabPanel:AlphaTo(0, 0.2,0, function() 
		self.TabPanel:Clear()

		if (menuType) then
			menus[menuType]()
		else
			self:RenderDashboard()
		end

		

		self.TabPanel:AlphaTo(255, 0.2)
	end)

end

function PANEL:RenderDashboard()

	local logo = vgui.Create("DImage", self.TabPanel)
	logo:Dock(TOP)
	logo:DockMargin(260,0,260,0)
	logo:SetTall(180)
	logo:SetMaterial(lapdlogo)

	local WelcomeMsg = vgui.Create( "DLabel", self.TabPanel )
	WelcomeMsg:Dock(TOP)
	WelcomeMsg:DockMargin(0,10,0,30)
	WelcomeMsg:SetFont("ixMediumFont")
	WelcomeMsg:SetContentAlignment(5)
	WelcomeMsg:SetText( "Welcome "..LocalPlayer():GetCharacter():GetName())
	WelcomeMsg:SetAutoStretchVertical(true)

	local PoliceOnline = 0
	local PoliceOnDuty = 0
	local casesCount = (CasesDataBase and table.Count(CasesDataBase)) or "N/A"

	//"kerry/player/police_usa"

	for client, character in ix.util.GetCharacters() do

		if (client:GetNetVar("PoliceOfficer_Net")) then

			PoliceOnline = PoliceOnline + 1

			-- if (character:GetFaction() == FACTION_POLICE) then
			if (client:isPolice()) then
				PoliceOnDuty = PoliceOnDuty + 1
			end

		end

	end

	local stats = {
		[1] = {
			SName = "Police officers on duty",
			SValue = PoliceOnDuty,
		},
		[2] = {
			SName = "Police officers online",
			SValue = PoliceOnline,
		},
		[3] = {
			SName = "Opened cases",
			SValue = casesCount,
		},
	}

	for k,v in ipairs(stats) do
		
		local statsPanel = vgui.Create( "DLabel", self.TabPanel )
		statsPanel:Dock(TOP)
		statsPanel:DockMargin(0,0,0,5)
		statsPanel:SetFont("ixMediumFont")
		statsPanel:SetContentAlignment(5)
		statsPanel:SetText( v.SName .. ": " ..v.SValue)
		statsPanel:SetAutoStretchVertical(true)

	end

end

function PANEL:RenderProfile(ply)
	
	net.Start("ixPoliceSys_RenderPersonProfile")
	net.WriteEntity(ply)
	net.SendToServer()

end

function PANEL:RenderPersonData()
	
	local searchBar = vgui.Create("ixIconTextEntry", self.TabPanel)
	searchBar:Dock(TOP)
	searchBar.OnEnter = function(s)
	   	self:FillPersonData(s:GetValue())
	end

	local DataScroll = vgui.Create( "DScrollPanel", self.TabPanel )
	DataScroll:Dock( FILL )
	DataScroll:DockMargin(0,5,0,0)
	DataScroll.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.DataScroll = DataScroll

	local sbar = DataScroll:GetVBar()
	sbar:SetWide(5)

	local function sign( num )
		return num > 0
	end
	
	local function getBiggerPos( signOld, signNew, old, new )
		if signOld != signNew then return new end
		if signNew then
			return math.max(old, new)
		else
			return math.min(old, new)
		end
	end

	local tScroll = 0
	local newerT = 0

	function sbar:AddScroll( dlta )
	
		self.Old_Pos = nil
		self.Old_Sign = nil

		local OldScroll = self:GetScroll()

		dlta = dlta * 30
		
		local anim = self:NewAnimation( 0.5, 0, 0.25 )
		anim.StartPos = OldScroll
		anim.TargetPos = OldScroll + dlta + tScroll
		tScroll = tScroll + dlta

		local ctime = RealTime() -- does not work correctly with CurTime, when in single player game and in game menu (then CurTime get stuck). I think RealTime is better.
		local doing_scroll = true
		newerT = ctime
		
		anim.Think = function( anim, pnl, fraction )
			local nowpos = Lerp( fraction, anim.StartPos, anim.TargetPos )
			if ctime == newerT then
				self:SetScroll( getBiggerPos( self.Old_Sign, sign(dlta), self.Old_Pos, nowpos ) )
				tScroll = tScroll - (tScroll * fraction)
			end
			if doing_scroll then -- it must be here. if not, sometimes scroll get bounce.
				self.Old_Sign = sign(dlta)
				self.Old_Pos = nowpos
			end
			if ctime != newerT then doing_scroll = false end
		end

		return math.Clamp( self:GetScroll() + tScroll, 0, self.CanvasSize ) != self:GetScroll()

	end

	self:FillPersonData()
	

end

function PANEL:FillPersonData(sWord)

	self.DataScroll:Clear()

	for client, character in ix.util.GetCharacters() do

		if (sWord) then
			if (!string.find(string.lower(client:Name()), string.lower(sWord))) then continue end
		end
		
		local ProfilePanel = vgui.Create( "Panel", self.DataScroll )
		ProfilePanel:Dock(TOP)
		ProfilePanel:DockMargin(0,0,0,10)
		ProfilePanel:SetTall(120)
		ProfilePanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local BGPanel = vgui.Create("DPanel", ProfilePanel)
		BGPanel:Dock(LEFT)
		BGPanel:DockMargin(10,10,10,10)
		BGPanel:SetWide(100)		
			
		local mdl = vgui.Create("DModelPanel", BGPanel)
		mdl:Dock(FILL)
		mdl:DockMargin(2,2,2,2)
		mdl:SetModel(client:GetModel() or "models/error.mdl")

		function mdl:LayoutEntity( Entity )
			return 
		end

		mdl.PaintOver = function(s,w,h)
			if (!client:isWanted()) then return end
			draw.SimpleTextOutlined("WANTED", "ixSmallBoldFont", w/2,h, Color( 240,math.abs(math.cos(RealTime() * 3) * 120),math.abs(math.cos(RealTime() * 3) * 120) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(20,20,20))
		end

		local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		mdl:SetLookAt(headpos-Vector(0, 0, 0))

		mdl:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

		mdl.Entity:SetEyeTarget(headpos-Vector(-30, 0, 0))

		local PlyInfoList = vgui.Create( "DIconLayout", ProfilePanel )
		PlyInfoList:Dock( FILL )
		PlyInfoList:DockMargin(0,10,0,10)
		PlyInfoList:SetSpaceY( 10 )
		PlyInfoList:SetSpaceX( 10 )

		local NamePanel = PlyInfoList:Add( "Panel" )
		NamePanel:SetSize(210,45)

		local NamePanel_Title = vgui.Create( "DLabel", NamePanel )
		NamePanel_Title:Dock(TOP)
		NamePanel_Title:DockMargin(10,0,0,0)
		NamePanel_Title:SetFont("ixSmallFont")
		NamePanel_Title:SetText( "Name" )
		NamePanel_Title:SetAutoStretchVertical(true)

		local NamePanel_TextBG = vgui.Create( "DPanel", NamePanel )
		NamePanel_TextBG:Dock(FILL)
		NamePanel_TextBG.Paint = function(s,w,h)
			//Background
		    surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)
		end

		local NamePanel_TextBG_Text = vgui.Create( "DLabel", NamePanel_TextBG )
		NamePanel_TextBG_Text:Dock(FILL)
		NamePanel_TextBG_Text:DockMargin(10,0,0,0)
		NamePanel_TextBG_Text:SetFont("ixSmallFont")
		NamePanel_TextBG_Text:SetText( character:GetName() or "Unknown" )

		local AgePanel = PlyInfoList:Add( "ixPolice_CardPanel" )
		AgePanel:SetSize(100,45)
		AgePanel:SetTitle("Age")
		AgePanel:SetText( (character:GetAge() and character:GetAge() .. " yrs.") or "N/A" )

		local HeightPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
		HeightPanel:SetSize(100,45)
		HeightPanel:SetTitle("Height")
		HeightPanel:SetText( (character:GetHeight() and character:GetHeight() .." ft") or "N/A" )

		local GenderPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
		GenderPanel:SetSize(100,45)
		GenderPanel:SetTitle("Gender")
		GenderPanel:SetText( character:GetGender() or "N/A" )

		local DobPabel = PlyInfoList:Add( "ixPolice_CardPanel" )
		DobPabel:SetSize(100,45)
		DobPabel:SetTitle("Date of Birth")
		DobPabel:SetText( character:GetDob() or "N/A" )

		local EyeColorPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
		EyeColorPanel:SetSize(100,45)
		EyeColorPanel:SetTitle("Eye Color")
		EyeColorPanel:SetText( character:GetEye_color() or "Unknown" )

		local HairColorPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
		HairColorPanel:SetSize(100,45)
		HairColorPanel:SetTitle("Hair Color")
		HairColorPanel:SetText(  character:GetHair_color() or "Unknown" )

		local volitionsPanel = PlyInfoList:Add( "Panel" )
		volitionsPanel:SetSize(210,45)

		local volitionsPanel_Title = vgui.Create( "DLabel", volitionsPanel )
		volitionsPanel_Title:Dock(TOP)
		volitionsPanel_Title:SetFont("ixSmallFont")
		volitionsPanel_Title:SetText( "" )
		volitionsPanel_Title:SetAutoStretchVertical(true)
		volitionsPanel_Title:SetContentAlignment(5)

		local volitionsPanel_Button = volitionsPanel:Add( "DButton" )
		volitionsPanel_Button:Dock(FILL)
		volitionsPanel_Button:SetText("More Info")
		volitionsPanel_Button:SetFont("ixSmallFont")
		volitionsPanel_Button.Paint = function(s,w,h)
			//Background
		    surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)
		end
		volitionsPanel_Button.DoClick = function(s)
			self:RenderProfile(client)
		end


	end

end

function PANEL:RenderPlatesData()

	local searchBar = vgui.Create("ixIconTextEntry", self.TabPanel)
	searchBar:Dock(TOP)
	searchBar.OnEnter = function(s)
	   	self:FindPlate(s:GetValue())
	end

	local DataScroll = vgui.Create( "DScrollPanel", self.TabPanel )
	DataScroll:Dock( FILL )
	DataScroll:DockMargin(0,5,0,0)
	DataScroll.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.DataScroll = DataScroll

	local sbar = DataScroll:GetVBar()
	sbar:SetWide(5)

	local LoadingText = vgui.Create( "DLabel", DataScroll )
	LoadingText:Dock(TOP)
	LoadingText:SetFont("ixMediumFont")
	LoadingText:SetText( "Enter the plate number to view profile" )
	LoadingText:SetContentAlignment(5)
	LoadingText:SizeToContents()

end

function Realistic_Police.GetVehicleLicense_Extend(String)
    local TableVehicle = {}
    for k,v in pairs(ents.GetAll()) do 
        if string.StartWith(string.Replace(string.upper(v:GetNWString("rpt_plate")), " ", ""), string.Replace(string.upper(String), " ", "")) or string.Replace(v:GetNWString("rpt_plate"), " ", "") == string.Replace(string.upper(String), " ", "") then 
            local t = list.Get( "Vehicles" )[ v:GetVehicleClass() ]
            if istable(RPTInformationVehicle[v:GetModel()]) then 
                TableVehicle[#TableVehicle + 1] = {
                    ModelVehc = v:GetModel(),
                    NameVehc = t.Name,
                    Plate = v:GetNWString("rpt_plate"),
                    VOwner = v:GetNetVar("ownerName", "Unknown"),
                    VOwner_CharID = v:GetNetVar("owner")
                }
            end 
        end 
    end 
    return TableVehicle
end 

function PANEL:FindPlate(sPlate)

	self.DataScroll:Clear()

	local carTable = Realistic_Police.GetVehicleLicense_Extend(sPlate)

	if (!carTable) or (table.IsEmpty(carTable)) then 

		local LoadingText = vgui.Create( "DLabel", self.DataScroll )
		LoadingText:Dock(TOP)
		LoadingText:SetFont("ixMediumFont")
		LoadingText:SetText( "The plate was not found" )
		LoadingText:SetContentAlignment(5)
		LoadingText:SizeToContents()

	return end

	for k, v in ipairs(carTable) do

		local ProfilePanel = vgui.Create( "Panel", self.DataScroll )
		ProfilePanel:Dock(TOP)
		ProfilePanel:DockMargin(0,5,0,0)
		ProfilePanel:SetTall(80)
		ProfilePanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local BGPanel = vgui.Create("DPanel", ProfilePanel)
		BGPanel:Dock(LEFT)
		BGPanel:DockMargin(10,10,10,10)
		BGPanel:DockPadding(5,5,5,5)
		BGPanel:SetWide(100)

		local RPTCarModel = vgui.Create( "DModelPanel", BGPanel )
        RPTCarModel:Dock(FILL)
        RPTCarModel:SetFOV(70)
        RPTCarModel:SetCamPos(Vector(200, 0, 20))
        RPTCarModel:SetModel( v.ModelVehc )
        function RPTCarModel:LayoutEntity( ent ) end 

		local InfoPanel = vgui.Create( "Panel", ProfilePanel )
		InfoPanel:Dock(TOP)
		InfoPanel:DockMargin(10,10,10,0)
		InfoPanel:SetTall(25)

		local NamePanel_Title = vgui.Create( "DLabel", InfoPanel )
		NamePanel_Title:Dock(LEFT)
		NamePanel_Title:SetFont("ixSmallFont")
		NamePanel_Title:SetText( "Name:" )
		NamePanel_Title:SetContentAlignment(4)
		NamePanel_Title:SizeToContents()

		local NamePanel = vgui.Create("DPanel", InfoPanel)
		NamePanel:Dock(LEFT)
		NamePanel:DockMargin(10,0,20,0)
		NamePanel:DockPadding(10,0,0,0)
		NamePanel:SetWide(200)
		NamePanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local NamePanel_Text = vgui.Create( "DLabel", NamePanel )
		NamePanel_Text:Dock(FILL)
		NamePanel_Text:SetFont("ixSmallFont")
		NamePanel_Text:SetText( v.NameVehc or "Unknown" )
		NamePanel_Text:SetContentAlignment(4)
		NamePanel_Text:SizeToContents()

		local NumberPanel_Title = vgui.Create( "DLabel", InfoPanel )
		NumberPanel_Title:Dock(RIGHT)
		NumberPanel_Title:SetFont("ixSmallFont")
		NumberPanel_Title:SetText( "Plate:" )
		NumberPanel_Title:SetContentAlignment(4)
		NumberPanel_Title:SizeToContents()
		NumberPanel_Title:SetZPos(2)

		local NumberPanel = vgui.Create("DPanel", InfoPanel)
		NumberPanel:Dock(RIGHT)
		NumberPanel:DockMargin(10,0,0,0)
		NumberPanel:DockPadding(10,0,0,0)
		NumberPanel:SetWide(150)
		NumberPanel:SetZPos(1)
		NumberPanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local NumberPanel_Text = vgui.Create( "DLabel", NumberPanel )
		NumberPanel_Text:Dock(FILL)
		NumberPanel_Text:SetFont("ixSmallFont")
		NumberPanel_Text:SetText( v.Plate or "Error" )
		NumberPanel_Text:SetContentAlignment(4)
		NumberPanel_Text:SizeToContents()

		local InfoPanel2 = vgui.Create( "Panel", ProfilePanel )
		InfoPanel2:Dock(TOP)
		InfoPanel2:DockMargin(10,5,10,10)
		InfoPanel2:SetTall(25)

		local OwnerPanel_Title = vgui.Create( "DLabel", InfoPanel2 )
		OwnerPanel_Title:Dock(LEFT)
		OwnerPanel_Title:SetFont("ixSmallFont")
		OwnerPanel_Title:SetText( "Registered on:" )
		OwnerPanel_Title:SetContentAlignment(4)
		OwnerPanel_Title:SizeToContents()

		local OwnerPanel = vgui.Create("DPanel", InfoPanel2)
		OwnerPanel:Dock(FILL)
		OwnerPanel:DockMargin(10,0,0,0)
		OwnerPanel:DockPadding(10,0,0,0)
		OwnerPanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local OwnerPanel_Text = vgui.Create( "DLabel", OwnerPanel )
		OwnerPanel_Text:Dock(FILL)
		OwnerPanel_Text:SetFont("ixSmallFont")
		OwnerPanel_Text:SetText( v.VOwner or "Unknown" )
		OwnerPanel_Text:SetContentAlignment(4)
		OwnerPanel_Text:SizeToContents()

		local character = ix.char.loaded[v.VOwner_CharID]

		if (!character) then
			local ProfileNotFound = vgui.Create( "DLabel", self.DataScroll )
			ProfileNotFound:Dock(TOP)
			ProfileNotFound:SetFont("ixMediumFont")
			ProfileNotFound:SetText( "Profile for '"..v.NameVehc or "Unknown".."' not found. Please try later" )
			ProfileNotFound:SetContentAlignment(4)
			ProfileNotFound:SizeToContents()
		else

			local ProfilePanel = vgui.Create( "Panel", self.DataScroll )
			ProfilePanel:Dock(TOP)
			ProfilePanel:DockMargin(0,0,0,10)
			ProfilePanel:SetTall(120)
			ProfilePanel.Paint = function(s,w,h)
				surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)

			end

			local BGPanel = vgui.Create("DPanel", ProfilePanel)
			BGPanel:Dock(LEFT)
			BGPanel:DockMargin(10,10,10,10)
			BGPanel:SetWide(100)		
				
			local mdl = vgui.Create("DModelPanel", BGPanel)
			mdl:Dock(FILL)
			mdl:DockMargin(2,2,2,2)
			mdl:SetModel(character:GetModel() or "models/error.mdl")

			function mdl:LayoutEntity( Entity )
				return 
			end

			mdl.PaintOver = function(s,w,h)
				if (!character:GetPlayer():isWanted()) then return end
				draw.SimpleTextOutlined("WANTED", "ixSmallBoldFont", w/2,h, Color( 240,math.abs(math.cos(RealTime() * 3) * 120),math.abs(math.cos(RealTime() * 3) * 120) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(20,20,20))
			end

			local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
			mdl:SetLookAt(headpos-Vector(0, 0, 0))

			mdl:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

			mdl.Entity:SetEyeTarget(headpos-Vector(-30, 0, 0))

			local PlyInfoList = vgui.Create( "DIconLayout", ProfilePanel )
			PlyInfoList:Dock( FILL )
			PlyInfoList:DockMargin(0,10,0,10)
			PlyInfoList:SetSpaceY( 10 )
			PlyInfoList:SetSpaceX( 10 )

			local NamePanel = PlyInfoList:Add( "Panel" )
			NamePanel:SetSize(210,45)

			local NamePanel_Title = vgui.Create( "DLabel", NamePanel )
			NamePanel_Title:Dock(TOP)
			NamePanel_Title:DockMargin(10,0,0,0)
			NamePanel_Title:SetFont("ixSmallFont")
			NamePanel_Title:SetText( "Name" )
			NamePanel_Title:SetAutoStretchVertical(true)

			local NamePanel_TextBG = vgui.Create( "DPanel", NamePanel )
			NamePanel_TextBG:Dock(FILL)
			NamePanel_TextBG.Paint = function(s,w,h)
				//Background
			    surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)
			end

			local NamePanel_TextBG_Text = vgui.Create( "DLabel", NamePanel_TextBG )
			NamePanel_TextBG_Text:Dock(FILL)
			NamePanel_TextBG_Text:DockMargin(10,0,0,0)
			NamePanel_TextBG_Text:SetFont("ixSmallFont")
			NamePanel_TextBG_Text:SetText( character:GetName() or "Unknown" )

			local AgePanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			AgePanel:SetSize(100,45)
			AgePanel:SetTitle("Age")
			AgePanel:SetText(  character:GetAge() .. " yrs." )

			local HeightPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			HeightPanel:SetSize(100,45)
			HeightPanel:SetTitle("Height")
			HeightPanel:SetText( character:GetHeight() .." ft" )

			local GenderPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			GenderPanel:SetSize(100,45)
			GenderPanel:SetTitle("Gender")
			GenderPanel:SetText( character:GetGender() )

			local DobPabel = PlyInfoList:Add( "ixPolice_CardPanel" )
			DobPabel:SetSize(100,45)
			DobPabel:SetTitle("Date of Birth")
			DobPabel:SetText( character:GetDob() )

			local EyeColorPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			EyeColorPanel:SetSize(100,45)
			EyeColorPanel:SetTitle("Eye Color")
			EyeColorPanel:SetText( character:GetEye_color() or "Unknown" )

			local HairColorPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			HairColorPanel:SetSize(100,45)
			HairColorPanel:SetTitle("Hair Color")
			HairColorPanel:SetText(  character:GetHair_color() or "Unknown" )

			local volitionsPanel = PlyInfoList:Add( "Panel" )
			volitionsPanel:SetSize(210,45)

			local volitionsPanel_Title = vgui.Create( "DLabel", volitionsPanel )
			volitionsPanel_Title:Dock(TOP)
			volitionsPanel_Title:SetFont("ixSmallFont")
			volitionsPanel_Title:SetText( "" )
			volitionsPanel_Title:SetAutoStretchVertical(true)
			volitionsPanel_Title:SetContentAlignment(5)

			local volitionsPanel_Button = volitionsPanel:Add( "DButton" )
			volitionsPanel_Button:Dock(FILL)
			volitionsPanel_Button:SetText("More Info")
			volitionsPanel_Button:SetFont("ixSmallFont")
			volitionsPanel_Button.Paint = function(s,w,h)
				//Background
			    surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)
			end
			volitionsPanel_Button.DoClick = function(s)
				self:RenderProfile(character:GetPlayer())
			end

		end

	end

end

function PANEL:RenderGunsData()

	self.gunsLoading = true
	
	local searchBar = vgui.Create("ixIconTextEntry", self.TabPanel)
	searchBar:Dock(TOP)
	searchBar.OnEnter = function(s)
		if (self.gunsLoading) then return end
	   	self:FindWeapon(s:GetValue())
	end

	local DataScroll = vgui.Create( "DScrollPanel", self.TabPanel )
	DataScroll:Dock( FILL )
	DataScroll:DockMargin(0,5,0,0)
	DataScroll.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.DataScroll = DataScroll

	local sbar = DataScroll:GetVBar()
	sbar:SetWide(5)

	self:GunsLoading()

	net.Start("ixPoliceSys_RequestData")
	net.WriteString("guns")
	net.SendToServer()

end

function PANEL:GunsLoading()

	local LoadingText = vgui.Create( "DLabel", self.DataScroll )
	LoadingText:Dock(TOP)
	LoadingText:SetFont("ixMediumFont")
	LoadingText:SetText( "Loading, Please Wait" )
	LoadingText:SetContentAlignment(5)
	LoadingText:SizeToContents()

end

function PANEL:GunsLoaded()

	self.DataScroll:Clear()

	self.gunsLoading = false

	local LoadingText = vgui.Create( "DLabel", self.DataScroll )
	LoadingText:Dock(TOP)
	LoadingText:SetFont("ixMediumFont")
	LoadingText:SetText( "Data downloaded successfully" )
	LoadingText:SetContentAlignment(5)
	LoadingText:SizeToContents()

end

function PANEL:FindWeapon(Snumber)

	self.DataScroll:Clear()

	local GunFound = {}

	for k, v in pairs(WeaponsDataBase) do

		if (string.find(tostring(k), tostring(Snumber))) then
		-- if (tostring(k) == tostring(Snumber)) then
			GunFound[k] = v
			-- GunFound.SerialNumber = k
			-- break
		end

	end

	if (table.IsEmpty(GunFound)) then

		local LoadingText = vgui.Create( "DLabel", self.DataScroll )
		LoadingText:Dock(TOP)
		LoadingText:SetFont("ixMediumFont")
		LoadingText:SetText( "The weapon was not found" )
		LoadingText:SetContentAlignment(5)
		LoadingText:SizeToContents()

	else

		for SerialNumber, GunData in pairs(GunFound) do

			local character = ix.char.loaded[GunData.Owner]
				
			local ProfilePanel = vgui.Create( "Panel", self.DataScroll )
			ProfilePanel:Dock(TOP)
			ProfilePanel:DockMargin(0,5,0,0)
			ProfilePanel:SetTall(80)
			ProfilePanel.Paint = function(s,w,h)
				surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)

			end

			local BGPanel = vgui.Create("DPanel", ProfilePanel)
			BGPanel:Dock(LEFT)
			BGPanel:DockMargin(10,10,10,10)
			BGPanel:DockPadding(10,10,10,10)
			BGPanel:SetWide(100)

			local SpawnI = vgui.Create( "SpawnIcon" , BGPanel )
			SpawnI:Dock(FILL)
			SpawnI:SetModel( GunData.ItemModel or  "models/error.mdl" )
			SpawnI:SetTooltip(false)
			SpawnI.PaintOver = function(s)
			end
			SpawnI.Paint = function(s)
			end
			SpawnI.DoClick = function(s)
			end

			local InfoPanel = vgui.Create( "Panel", ProfilePanel )
			InfoPanel:Dock(TOP)
			InfoPanel:DockMargin(10,10,10,0)
			InfoPanel:SetTall(25)

			local NamePanel_Title = vgui.Create( "DLabel", InfoPanel )
			NamePanel_Title:Dock(LEFT)
			NamePanel_Title:SetFont("ixSmallFont")
			NamePanel_Title:SetText( "Name:" )
			NamePanel_Title:SetContentAlignment(4)
			NamePanel_Title:SizeToContents()

			local NamePanel = vgui.Create("DPanel", InfoPanel)
			NamePanel:Dock(LEFT)
			NamePanel:DockMargin(10,0,20,0)
			NamePanel:DockPadding(10,0,0,0)
			NamePanel:SetWide(200)
			NamePanel.Paint = function(s,w,h)
				surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)

			end

			local NamePanel_Text = vgui.Create( "DLabel", NamePanel )
			NamePanel_Text:Dock(FILL)
			NamePanel_Text:SetFont("ixSmallFont")
			NamePanel_Text:SetText( GunData.ItemName or "Unknown" )
			NamePanel_Text:SetContentAlignment(4)
			NamePanel_Text:SizeToContents()

			local NumberPanel_Title = vgui.Create( "DLabel", InfoPanel )
			NumberPanel_Title:Dock(RIGHT)
			NumberPanel_Title:SetFont("ixSmallFont")
			NumberPanel_Title:SetText( "Serial Number:" )
			NumberPanel_Title:SetContentAlignment(4)
			NumberPanel_Title:SizeToContents()
			NumberPanel_Title:SetZPos(2)

			local NumberPanel = vgui.Create("DPanel", InfoPanel)
			NumberPanel:Dock(RIGHT)
			NumberPanel:DockMargin(10,0,0,0)
			NumberPanel:DockPadding(10,0,0,0)
			NumberPanel:SetWide(150)
			NumberPanel:SetZPos(1)
			NumberPanel.Paint = function(s,w,h)
				surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)

			end

			local NumberPanel_Text = vgui.Create( "DLabel", NumberPanel )
			NumberPanel_Text:Dock(FILL)
			NumberPanel_Text:SetFont("ixSmallFont")
			NumberPanel_Text:SetText( SerialNumber or "Error" )
			NumberPanel_Text:SetContentAlignment(4)
			NumberPanel_Text:SizeToContents()

			local InfoPanel2 = vgui.Create( "Panel", ProfilePanel )
			InfoPanel2:Dock(TOP)
			InfoPanel2:DockMargin(10,5,10,10)
			InfoPanel2:SetTall(25)

			local OwnerPanel_Title = vgui.Create( "DLabel", InfoPanel2 )
			OwnerPanel_Title:Dock(LEFT)
			OwnerPanel_Title:SetFont("ixSmallFont")
			OwnerPanel_Title:SetText( "Registered on:" )
			OwnerPanel_Title:SetContentAlignment(4)
			OwnerPanel_Title:SizeToContents()

			local OwnerPanel = vgui.Create("DPanel", InfoPanel2)
			OwnerPanel:Dock(FILL)
			OwnerPanel:DockMargin(10,0,0,0)
			OwnerPanel:DockPadding(10,0,0,0)
			OwnerPanel.Paint = function(s,w,h)
				surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)

			end

			local OwnerPanel_Text = vgui.Create( "DLabel", OwnerPanel )
			OwnerPanel_Text:Dock(FILL)
			OwnerPanel_Text:SetFont("ixSmallFont")
			OwnerPanel_Text:SetText( GunData.OwnerName or "Unknown" )
			OwnerPanel_Text:SetContentAlignment(4)
			OwnerPanel_Text:SizeToContents()

			local ProfilePanel = vgui.Create( "Panel", self.DataScroll )
			ProfilePanel:Dock(TOP)
			ProfilePanel:DockMargin(0,0,0,10)
			ProfilePanel:SetTall(120)
			ProfilePanel.Paint = function(s,w,h)
				surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)

			end

			local BGPanel = vgui.Create("DPanel", ProfilePanel)
			BGPanel:Dock(LEFT)
			BGPanel:DockMargin(10,10,10,10)
			BGPanel:SetWide(100)		
				
			local mdl = vgui.Create("DModelPanel", BGPanel)
			mdl:Dock(FILL)
			mdl:DockMargin(2,2,2,2)
			mdl:SetModel(character:GetModel() or "models/error.mdl")

			function mdl:LayoutEntity( Entity )
				return 
			end

			mdl.PaintOver = function(s,w,h)
				if (!character:GetPlayer():isWanted()) then return end
				draw.SimpleTextOutlined("WANTED", "ixSmallBoldFont", w/2,h, Color( 240,math.abs(math.cos(RealTime() * 3) * 120),math.abs(math.cos(RealTime() * 3) * 120) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(20,20,20))
			end

			local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
			mdl:SetLookAt(headpos-Vector(0, 0, 0))

			mdl:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

			mdl.Entity:SetEyeTarget(headpos-Vector(-30, 0, 0))

			local PlyInfoList = vgui.Create( "DIconLayout", ProfilePanel )
			PlyInfoList:Dock( FILL )
			PlyInfoList:DockMargin(0,10,0,10)
			PlyInfoList:SetSpaceY( 10 )
			PlyInfoList:SetSpaceX( 10 )

			local NamePanel = PlyInfoList:Add( "Panel" )
			NamePanel:SetSize(210,45)

			local NamePanel_Title = vgui.Create( "DLabel", NamePanel )
			NamePanel_Title:Dock(TOP)
			NamePanel_Title:DockMargin(10,0,0,0)
			NamePanel_Title:SetFont("ixSmallFont")
			NamePanel_Title:SetText( "Name" )
			NamePanel_Title:SetAutoStretchVertical(true)

			local NamePanel_TextBG = vgui.Create( "DPanel", NamePanel )
			NamePanel_TextBG:Dock(FILL)
			NamePanel_TextBG.Paint = function(s,w,h)
				//Background
			    surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)
			end

			local NamePanel_TextBG_Text = vgui.Create( "DLabel", NamePanel_TextBG )
			NamePanel_TextBG_Text:Dock(FILL)
			NamePanel_TextBG_Text:DockMargin(10,0,0,0)
			NamePanel_TextBG_Text:SetFont("ixSmallFont")
			NamePanel_TextBG_Text:SetText( character:GetName() or "Unknown" )

			local AgePanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			AgePanel:SetSize(100,45)
			AgePanel:SetTitle("Age")
			AgePanel:SetText(  character:GetAge() .. " yrs." )

			local HeightPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			HeightPanel:SetSize(100,45)
			HeightPanel:SetTitle("Height")
			HeightPanel:SetText( character:GetHeight() .." ft" )

			local GenderPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			GenderPanel:SetSize(100,45)
			GenderPanel:SetTitle("Gender")
			GenderPanel:SetText( character:GetGender() )

			local DobPabel = PlyInfoList:Add( "ixPolice_CardPanel" )
			DobPabel:SetSize(100,45)
			DobPabel:SetTitle("Date of Birth")
			DobPabel:SetText( character:GetDob() )

			local EyeColorPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			EyeColorPanel:SetSize(100,45)
			EyeColorPanel:SetTitle("Eye Color")
			EyeColorPanel:SetText( character:GetEye_color() or "Unknown" )

			local HairColorPanel = PlyInfoList:Add( "ixPolice_CardPanel" )
			HairColorPanel:SetSize(100,45)
			HairColorPanel:SetTitle("Hair Color")
			HairColorPanel:SetText(  character:GetHair_color() or "Unknown" )

			local volitionsPanel = PlyInfoList:Add( "Panel" )
			volitionsPanel:SetSize(210,45)

			local volitionsPanel_Title = vgui.Create( "DLabel", volitionsPanel )
			volitionsPanel_Title:Dock(TOP)
			volitionsPanel_Title:SetFont("ixSmallFont")
			volitionsPanel_Title:SetText( "" )
			volitionsPanel_Title:SetAutoStretchVertical(true)
			volitionsPanel_Title:SetContentAlignment(5)

			local volitionsPanel_Button = volitionsPanel:Add( "DButton" )
			volitionsPanel_Button:Dock(FILL)
			volitionsPanel_Button:SetText("More Info")
			volitionsPanel_Button:SetFont("ixSmallFont")
			volitionsPanel_Button.Paint = function(s,w,h)
				//Background
			    surface.SetDrawColor(20,20,20,150)
			    surface.DrawRect(0,0,w,h)
			end
			volitionsPanel_Button.DoClick = function(s)
				self:RenderProfile(character:GetPlayer())
			end

		end

	end

end

function PANEL:RendersCases()
	
	self.casesLoading = true

	self.BClosing = false

	local searchBar = vgui.Create("ixIconTextEntry", self.TabPanel)
	searchBar:Dock(TOP)
	searchBar.OnEnter = function(s)
		if (self.casesLoading) then return end
	   	self:SearchCase(s:GetValue())
	end

	local PanelBg = vgui.Create( "Panel", self.TabPanel )
	PanelBg:Dock( FILL )
	PanelBg:DockMargin(0,5,0,0)
	PanelBg:DockPadding(5,5,0,5)
	PanelBg.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	local DataScroll = vgui.Create( "DScrollPanel", PanelBg )
	DataScroll:Dock( FILL )
	-- DataScroll.Paint = function(s,w,h)

	-- 	surface.SetDrawColor(20,20,20,50)
	--     surface.DrawRect(0,0,w,h)

	-- end

	self.DataScroll = DataScroll

	self:CasesLoading()

	net.Start("ixPoliceSys_RequestData")
	net.WriteString("cases")
	net.SendToServer()


	local NewCaseB = vgui.Create( "ixMenuButton", self.TabPanel )
	NewCaseB:Dock(BOTTOM)
	NewCaseB:DockMargin(0,5,0,0)
	NewCaseB:SetFont("ixMediumFont")
	NewCaseB:SetContentAlignment(5)
	NewCaseB:SetTall(35)
	NewCaseB:SetText( "NEW CASE" )
	-- NewCaseB.Anim = 0
	-- NewCaseB.Paint = function(s,w,h)


	-- 	if (s:IsHovered()) then
	-- 		s.Anim = math.Clamp(s.Anim + 6 * FrameTime(), 0, 1)
	-- 	else
	-- 		s.Anim = math.Clamp(s.Anim - 6 * FrameTime(), 0, 1)
	-- 	end

	-- 	surface.SetDrawColor(Color(20,20,20,50 + (s.Anim * 100)))
	-- 	surface.DrawRect(0, 0, w, h)

	-- end
	NewCaseB.DoClick = function()

		net.Start("ixPoliceSys_CreateNewCase")
		net.SendToServer()

		-- self:AlphaTo(0, 0.3, 0, function() self:Close() end)
	end

	-- self:SearchCase()

end

function PANEL:CasesLoading()

	local LoadingText = vgui.Create( "DLabel", self.DataScroll )
	LoadingText:Dock(TOP)
	LoadingText:SetFont("ixMediumFont")
	LoadingText:SetText( "Loading, Please Wait" )
	LoadingText:SetContentAlignment(5)
	LoadingText:SizeToContents()

end

function PANEL:CasesLoaded()

	self.DataScroll:Clear()

	self.casesLoading = false

	self:SearchCase()
end

function PANEL:SearchCase(sWord)


	local sbar = self.DataScroll:GetVBar()
	sbar:SetWide(5)

	self.DataScroll:Clear()

	local function sign( num )
		return num > 0
	end
	
	local function getBiggerPos( signOld, signNew, old, new )
		if signOld != signNew then return new end
		if signNew then
			return math.max(old, new)
		else
			return math.min(old, new)
		end
	end

	local tScroll = 0
	local newerT = 0

	function sbar:AddScroll( dlta )
	
		self.Old_Pos = nil
		self.Old_Sign = nil

		local OldScroll = self:GetScroll()

		dlta = dlta * 30
		
		local anim = self:NewAnimation( 0.5, 0, 0.25 )
		anim.StartPos = OldScroll
		anim.TargetPos = OldScroll + dlta + tScroll
		tScroll = tScroll + dlta

		local ctime = RealTime() -- does not work correctly with CurTime, when in single player game and in game menu (then CurTime get stuck). I think RealTime is better.
		local doing_scroll = true
		newerT = ctime
		
		anim.Think = function( anim, pnl, fraction )
			local nowpos = Lerp( fraction, anim.StartPos, anim.TargetPos )
			if ctime == newerT then
				self:SetScroll( getBiggerPos( self.Old_Sign, sign(dlta), self.Old_Pos, nowpos ) )
				tScroll = tScroll - (tScroll * fraction)
			end
			if doing_scroll then -- it must be here. if not, sometimes scroll get bounce.
				self.Old_Sign = sign(dlta)
				self.Old_Pos = nowpos
			end
			if ctime != newerT then doing_scroll = false end
		end

		return math.Clamp( self:GetScroll() + tScroll, 0, self.CanvasSize ) != self:GetScroll()

	end

	-- for i=0, 5 do
	-- for client, character in ix.util.GetCharacters() do
	for k, v in SortedPairsByMemberValue(CasesDataBase, "CCreateTime", true) do

		if (sWord) then
			if (!string.find(k,sWord)) and (!string.find(string.lower(v.CTitle),string.lower(sWord))) then continue end
		end

		local ProfilePanel = vgui.Create( "Panel", self.DataScroll )
		ProfilePanel:Dock(TOP)
		ProfilePanel:DockMargin(0,0,0,10)
		ProfilePanel:DockPadding(10,10,5,10)
		ProfilePanel:SetTall(160)
		ProfilePanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local CaseName = ProfilePanel:Add( "ixPolice_CardPanel" )
		CaseName:Dock(TOP)
		CaseName:DockMargin(0,0,0,10)
		CaseName:SetTall(45)
		CaseName:SetTitle("CASE TITLE")
		CaseName:SetText("ID: "..k.." | "..v.CTitle)

		local CurrentTime = os.date( "%j" , os.time() )
		local CreatedTime = os.date( "%j" , v.CCreateTime )

		local DaysAgo = CurrentTime - CreatedTime
		local DaysAgoText = (DaysAgo <= 0 and "Today") or DaysAgo .. " days ago"

		local SubmittedPanel = ProfilePanel:Add( "ixPolice_CardPanel" )
		SubmittedPanel:Dock(TOP)
		SubmittedPanel:DockMargin(0,0,0,10)
		SubmittedPanel:SetTall(45)
		SubmittedPanel:SetTitle("Submitted")
		SubmittedPanel:SetText(DaysAgoText.." by "..v.CSubBy)

		local MoreInfoButton = ProfilePanel:Add( "DButton" )
		MoreInfoButton:Dock(TOP)
		MoreInfoButton:SetTall(30)
		MoreInfoButton:SetText( (CasesInUse[k] and "Someone else is editing") or "See Details")
		MoreInfoButton:SetFont("ixSmallFont")
		MoreInfoButton.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)
		end
		MoreInfoButton.NextCheck = CurTime() + 1
		MoreInfoButton.Think = function(s)

			if (s.NextCheck < CurTime()) then
				s:SetText( (CasesInUse[k] and "Someone else is editing") or "See Details")
				s.NextCheck = CurTime() + 1
			end

		end
		MoreInfoButton.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")

			if (CasesInUse[k]) then
				LocalPlayer():Notify("Someone is editing this case at the moment. Try again later.")
				return
			end

			self:RenderCase(k,v)



			net.Start("ixPoliceSys_ClaimCase")
			net.WriteBool(true)
			net.WriteUInt(k, 17)
			net.SendToServer()

		end


	end

end

function PANEL:RenderCase(CaseID,CaseData)

	self.TabPanel:Clear()

	self.AFKTimer = CurTime() + self.AFKReset

	self.CaseID = CaseID

	self.CaseOpen = true

	self.IsModified = false

	local PanelBg = vgui.Create( "Panel", self.TabPanel )
	PanelBg:Dock( FILL )
	PanelBg:DockMargin(0,5,0,0)
	PanelBg:DockPadding(5,5,5,5)
	PanelBg.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	local ButtonsPanel = PanelBg:Add( "Panel" )
	ButtonsPanel:Dock(TOP)
	ButtonsPanel:SetTall(30)

	local ReturnButton = ButtonsPanel:Add( "DButton" )
	ReturnButton:Dock(LEFT)
	ReturnButton:SetWide(220)
	ReturnButton:SetText("RETURN")
	ReturnButton:SetFont("ixSmallFont")
	ReturnButton.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)
	end
	ReturnButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		if (self.IsModified) then

			Derma_Query(
			    "Are you sure you want to return? You have unsaved changes!",
			    "Return confirmation",
			    "Yes",
			    function()

			    	self:TransitionAnim(4)

					self.CaseID = nil
					self.CaseOpen = false

					net.Start("ixPoliceSys_ClaimCase")
					net.WriteBool(false)
					net.WriteUInt(CaseID, 17)
					net.SendToServer()

			    end,
				"No",
				function() end
			)

		else

			self:TransitionAnim(4)

			self.CaseID = nil
			self.CaseOpen = false

			net.Start("ixPoliceSys_ClaimCase")
			net.WriteBool(false)
			net.WriteUInt(CaseID, 17)
			net.SendToServer()

		end

	end

	local SaveButton = ButtonsPanel:Add( "DButton" )
	SaveButton:Dock(LEFT)
	SaveButton:DockMargin(10,0,10,0)
	SaveButton:SetWide(220)
	SaveButton:SetText("SAVE")
	SaveButton:SetFont("ixSmallFont")
	SaveButton.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)
	end
	SaveButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		CasesDataBase[CaseID] = CaseData

		self.AFKTimer = CurTime() + self.AFKReset

		for k, v in pairs(CasesDataBase[CaseID].Details) do

			if (self.PersonCaseData[k]) then
				CasesDataBase[CaseID].Details[k] = self.PersonCaseData[k].People
			end
			
		end

		local JSONData = util.TableToJSON(CasesDataBase[CaseID])

		net.Start("ixPoliceSys_UpdateCase")
			net.WriteUInt(CaseID, 17)
			net.WriteString(JSONData)
		net.SendToServer()

		self.IsModified = false

	end

	local CloseButton = ButtonsPanel:Add( "DButton" )
	CloseButton:Dock(LEFT)
	CloseButton:SetWide(220)
	CloseButton:SetText("CLOSE CASE")
	CloseButton:SetFont("ixSmallFont")
	CloseButton.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)
	end
	CloseButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		self.AFKTimer = CurTime() + self.AFKReset

		Derma_Query(
		    "Are you sure about that?",
		    "Close confirmation",
		    "Yes",
		    function()

		    	net.Start("ixPoliceSys_CloseCase")
					net.WriteUInt(CaseID, 17)
				net.SendToServer()

				self:TransitionAnim(4)

		    end,
			"No",
			function() end
		)

	end

	local sheet = vgui.Create( "DPropertySheet", PanelBg )
	sheet:Dock( FILL )
	sheet:DockMargin(0,5,0,0)
	sheet:SetPadding(4)
	sheet.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

	end

	local OverviewPanel = PanelBg:Add( "Panel",sheet )
	OverviewPanel.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

	end

	local TabData = sheet:AddSheet( "Overview", OverviewPanel, "icon16/book.png" )

	TabData.Tab.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w-5,h)

	end

	local CaseName = OverviewPanel:Add( "ixPolice_CardPanel" )
	CaseName:Dock(TOP)
	CaseName:DockMargin(0,5,0,10)
	CaseName:SetTall(45)
	CaseName:SetTitle("Case Title")
	CaseName:SetText(CaseData.CTitle)
	CaseName.Title = CaseData.CTitle

	local CaseEdit = CaseName:Add( "DImageButton" )
	CaseEdit:SetPos(380,0)
	CaseEdit:SetImage( "icon16/pencil.png" )
	CaseEdit:SizeToContents()
	CaseEdit.DoClick = function()

		self.AFKTimer = CurTime() + self.AFKReset

		self.IsModified = true

		Derma_StringRequest(
			"Case Title", 
			"Enter the title for this case",
			CaseName.Title,
			function(text) 
				CaseName:SetText(text)
				CaseName.Title = text
				LocalPlayer():Notify("Changed the title for this case")
				CaseData.CTitle = text
			end,
			function(text) self.IsModified = false end
		)

	end

	local CaseIDPanel = OverviewPanel:Add( "ixPolice_CardPanel" )
	CaseIDPanel:Dock(TOP)
	CaseIDPanel:DockMargin(0,0,0,10)
	CaseIDPanel:SetTall(45)
	CaseIDPanel:SetTitle("Case ID")
	CaseIDPanel:SetText(CaseID)

	local CurrentTime = os.date( "%j" , os.time() )
	local CreatedTime = os.date( "%j" , CaseData.CCreateTime )

	local DaysAgo = CurrentTime - CreatedTime
	local DaysAgoText = (DaysAgo <= 0 and "Today") or DaysAgo .. " days ago"

	local SubmittedPanel = OverviewPanel:Add( "ixPolice_CardPanel" )
	SubmittedPanel:Dock(TOP)
	SubmittedPanel:DockMargin(0,0,0,10)
	SubmittedPanel:SetTall(45)
	SubmittedPanel:SetTitle("Submitted")
	SubmittedPanel:SetText(DaysAgoText)

	local SubmittedByPanel = OverviewPanel:Add( "ixPolice_CardPanel" )
	SubmittedByPanel:Dock(TOP)
	SubmittedByPanel:DockMargin(0,0,0,10)
	SubmittedByPanel:SetTall(45)
	SubmittedByPanel:SetTitle("Submitted by")
	SubmittedByPanel:SetText(CaseData.CSubBy)

	local BriefTE = vgui.Create( "DTextEntry", sheet )
	BriefTE:SetMultiline(true)
	BriefTE:SetValue(CaseData.Brief)
	BriefTE.Paint = function(s,w,h)
	    surface.SetDrawColor(200,200,200,150)
	    surface.DrawRect(0, 0, w,h)
	    s:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end
	BriefTE.OnGetFocus = function(s)
		self.AFKTimer = CurTime() + self.AFKReset
	end
	BriefTE.OnEnter = function(s)
		self.AFKTimer = CurTime() + self.AFKReset
		if (s:GetValue() != CaseData.Brief) then
			CaseData.Brief = s:GetValue()
			LocalPlayer():Notify("Brief has been updated")
			self.IsModified = true
		end
	end
	BriefTE.OnLoseFocus = function( s )
		self.AFKTimer = CurTime() + self.AFKReset
		if (s:GetValue() != CaseData.Brief) then
			CaseData.Brief = s:GetValue()
			LocalPlayer():Notify("Brief has been updated")
			self.IsModified = true
		end
	end

	TabData = sheet:AddSheet( "Brief", BriefTE, "icon16/script_edit.png" )

	TabData.Tab.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w-5,h)

	end

	local CaseDetailsScroll = vgui.Create( "DScrollPanel", sheet )
	CaseDetailsScroll.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)

	end
	local sbar = CaseDetailsScroll:GetVBar()
	sbar:SetWide(5)

	local function sign( num )
		return num > 0
	end
	
	local function getBiggerPos( signOld, signNew, old, new )
		if signOld != signNew then return new end
		if signNew then
			return math.max(old, new)
		else
			return math.min(old, new)
		end
	end

	local tScroll = 0
	local newerT = 0

	function sbar:AddScroll( dlta )
	
		self.Old_Pos = nil
		self.Old_Sign = nil

		local OldScroll = self:GetScroll()

		dlta = dlta * 30
		
		local anim = self:NewAnimation( 0.5, 0, 0.25 )
		anim.StartPos = OldScroll
		anim.TargetPos = OldScroll + dlta + tScroll
		tScroll = tScroll + dlta

		local ctime = RealTime() -- does not work correctly with CurTime, when in single player game and in game menu (then CurTime get stuck). I think RealTime is better.
		local doing_scroll = true
		newerT = ctime
		
		anim.Think = function( anim, pnl, fraction )
			local nowpos = Lerp( fraction, anim.StartPos, anim.TargetPos )
			if ctime == newerT then
				self:SetScroll( getBiggerPos( self.Old_Sign, sign(dlta), self.Old_Pos, nowpos ) )
				tScroll = tScroll - (tScroll * fraction)
			end
			if doing_scroll then -- it must be here. if not, sometimes scroll get bounce.
				self.Old_Sign = sign(dlta)
				self.Old_Pos = nowpos
			end
			if ctime != newerT then doing_scroll = false end
		end

		return math.Clamp( self:GetScroll() + tScroll, 0, self.CanvasSize ) != self:GetScroll()

	end

	self.PersonCaseData = {
		["Evidences"] = {
			AddFunc = function(ListPanel, person, personID)
				self:AddItemCard(ListPanel, person,personID)
			end,
			PanelAddFunc = function()

				local char = LocalPlayer():GetCharacter()
				local inv = char:GetInventory()
				local items = inv:GetItems()

				local ItemsSearch = vgui.Create("ixPoliceStuff_EvidenceSelector")
				ItemsSearch:ShowInvItems(items)
				ItemsSearch.TableToAdd = "Evidences"
				ItemsSearch:SetParent(self)
				self.IsModified = true
			end,
			People = CaseData.Details["Evidences"]
		},
		["Officers"] = {
			AddFunc = function(ListPanel, person,personID)
				self:AddOfficerCard(ListPanel, person,personID)
			end,
			PanelAddFunc = function()
				local PersonSearch = vgui.Create("ixPoliceSys_SearchPerson")
				PersonSearch.TableToAdd = "Officers"
				PersonSearch:SetParent(self)
				self.IsModified = true
			end,
			People = CaseData.Details["Officers"]
		},
		["Suspects"] = {
			AddFunc = function(ListPanel, person,personID)
				self:AddSuspectCard(ListPanel, person,personID)
			end,
			PanelAddFunc = function()
				local PersonSearch = vgui.Create("ixPoliceSys_SearchPerson")
				PersonSearch.TableToAdd = "Suspects"
				PersonSearch:SetParent(self)
				self.IsModified = true
			end,
			People = CaseData.Details["Suspects"]
		},
		["Victims"] = {
			AddFunc = function(ListPanel, person,personID)
				self:AddVictimCard(ListPanel, person,personID)
			end,
			PanelAddFunc = function()
				local PersonSearch = vgui.Create("ixPoliceSys_SearchPerson")
				PersonSearch.TableToAdd = "Victims"
				PersonSearch:SetParent(self)
				self.IsModified = true
			end,
			People = CaseData.Details["Victims"]
		},
	}

	for k, v in SortedPairs(self.PersonCaseData) do
		
		local PersonsPanel = vgui.Create( "Panel", CaseDetailsScroll )
		PersonsPanel:Dock(TOP)
		PersonsPanel:DockMargin(5,5,0,5)
		PersonsPanel:DockPadding(5,5,5,5)
		PersonsPanel:SetTall(30)
		PersonsPanel.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,150)
		    surface.DrawRect(0,0,w,h)

		end

		local PersonsPanelTop = PersonsPanel:Add( "Panel")
		PersonsPanelTop:Dock(TOP)
		PersonsPanelTop:SetTall(20)
		PersonsPanelTop.Paint = function(s,w,h)
			surface.SetDrawColor(200,200,200)
		    surface.DrawRect(0,h-1,w,1)

		end

		local PersonsPanel_Title = vgui.Create( "DLabel", PersonsPanelTop )
		PersonsPanel_Title:Dock(LEFT)
		PersonsPanel_Title:SetFont("ixSmallFont")
		PersonsPanel_Title:SetText( k )
		PersonsPanel_Title:SetAutoStretchVertical(true)
		PersonsPanel_Title:SetContentAlignment(4)

		local PersonsAdd = PersonsPanelTop:Add( "DImageButton" )
		PersonsAdd:Dock(RIGHT)
		PersonsAdd:DockMargin(0,2,0,2)
		PersonsAdd:SetImage( "icon16/add.png" )
		PersonsAdd:SetSize(16,16)
		PersonsAdd.DoClick = function(s)
			self.AFKTimer = CurTime() + self.AFKReset
			v.PanelAddFunc()
		end

		self.PersonCaseData[k].PersonsPanel = PersonsPanel

		self:RenderCaseDetails(v.People,k)

	end

	TabData = sheet:AddSheet( "Case Details", CaseDetailsScroll, "icon16/briefcase.png" )

	TabData.Tab.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w-5,h)

	end

end

function PANEL:RenderCaseDetails(TablePeople,TableCategory)

	if (IsValid(self.PersonCaseData[TableCategory].BackgroundPanel)) then
		self.PersonCaseData[TableCategory].BackgroundPanel:Remove()
	end

	local PersonPanel = self.PersonCaseData[TableCategory].PersonsPanel

	local PeopleList = vgui.Create( "DIconLayout", PersonPanel )
	PeopleList:Dock( FILL )
	PeopleList:DockMargin(10,5,0,0)
	PeopleList:SetSpaceY( 10 )
	PeopleList:SetSpaceX( 15 )


	self.PersonCaseData[TableCategory].BackgroundPanel = PeopleList

	if (!table.IsEmpty(TablePeople)) then

		for IndexC, client in ipairs(TablePeople) do
			
			self.PersonCaseData[TableCategory].AddFunc(PeopleList,client,IndexC)
			PeopleList:InvalidateLayout()
			
		end

	end

	self:CalculateListTall(PeopleList)
	
end

function PANEL:CalculateListTall(ListPanel)

	local PersonPanel = ListPanel:GetParent()

	if (!IsValid(PersonPanel)) then return end

	local extraTall = 0

	for k, v in pairs(ListPanel:GetChildren()) do
		if ((k+1) % 2 == 0) then
			extraTall = extraTall + 110
		end
	end

	if (extraTall == 0) then
		PersonPanel:SetTall(60)
		self:RenderNothingToShow(ListPanel)
	else
		PersonPanel:SetTall(30 + extraTall)
	end

end

function PANEL:RenderNothingToShow(ListPanel)

	local NoTableText = vgui.Create( "DLabel", ListPanel )
	NoTableText:SetSize(300,100)
	NoTableText:SetFont("ixSmallFont")
	NoTableText:SetText( "Nothing to show" )
	NoTableText:SetAutoStretchVertical(true)
	NoTableText:SetContentAlignment(4)
end

function PANEL:AddOfficerCard(ListPanel, person,personID)

	if (!IsValid(ListPanel)) then return end

	local ProfilePanel = ListPanel:Add( "DPanel" )
	ProfilePanel:SetSize(300,100)
	ProfilePanel:SetText("")
	ProfilePanel.Paint = function(s,w,h)

		surface.SetDrawColor(200,200,200)
	    surface.DrawRect(0,0,w,h)

	end

	local DeleteB = ProfilePanel:Add( "DImageButton" )
	DeleteB:SetSize(16,16)
	DeleteB:SetPos(ProfilePanel:GetWide() - DeleteB:GetWide(),0)
	DeleteB:SetImage( "icon16/cancel.png" )
	DeleteB.DoClick = function(s)

		self.AFKTimer = CurTime() + self.AFKReset

		Derma_Query(
		    "Are you sure about that?",
		    "Delete confirmation",
		    "Yes",
		    function()

		    	local tempList = ProfilePanel:GetParent()

		    	ProfilePanel:Remove()
		    	ProfilePanel:GetParent():InvalidateLayout()

		    	table.remove(self.PersonCaseData["Officers"].People, personID)

		    	timer.Simple(0,function()
			    	self:CalculateListTall(tempList)



			    end)
		    end,
			"No",
			function() end
		)

	end

	local BGPanel = vgui.Create("DPanel", ProfilePanel)
	BGPanel:Dock(LEFT)
	BGPanel:SetWide(100)
	BGPanel:SetMouseInputEnabled(false)
	BGPanel.Paint = function(s,w,h)
		surface.SetDrawColor(34, 52, 70)
	    surface.DrawRect(0,0,w,h)

	    

	end

	local mdl = vgui.Create("DModelPanel", BGPanel)
	mdl:Dock(FILL)
	mdl:DockMargin(2,2,2,2)
	mdl:SetModel(person.PModel or "models/error.mdl")

	function mdl:LayoutEntity( Entity )
		return 
	end

	local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
	mdl:SetLookAt(headpos-Vector(0, 0, 0))

	mdl:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

	mdl.Entity:SetEyeTarget(headpos-Vector(-30, 0, 0))

	local NamePanel = vgui.Create( "DLabel", ProfilePanel )
	NamePanel:Dock(TOP)
	NamePanel:DockMargin(10,10,0,0)
	NamePanel:SetFont("ixSmallFont")
	NamePanel:SetTextColor(Color(20,20,20))
	NamePanel:SetText( "Name:" )
	NamePanel:SetAutoStretchVertical(true)

	local NamePanel_Title = vgui.Create( "DLabel", ProfilePanel )
	NamePanel_Title:Dock(TOP)
	NamePanel_Title:DockMargin(10,0,0,0)
	NamePanel_Title:SetFont("ixSmallFont")
	NamePanel_Title:SetTextColor(Color(20,20,20))
	NamePanel_Title:SetText( person.PName )
	NamePanel_Title:SetAutoStretchVertical(true)

	local RankTitle = vgui.Create( "DLabel", ProfilePanel )
	RankTitle:Dock(TOP)
	RankTitle:DockMargin(10,10,0,0)
	RankTitle:SetFont("ixSmallFont")
	RankTitle:SetTextColor(Color(20,20,20))
	RankTitle:SetText( "Rank:" )
	RankTitle:SetAutoStretchVertical(true)

	local RankName = vgui.Create( "DLabel", ProfilePanel )
	RankName:Dock(TOP)
	RankName:DockMargin(10,0,0,0)
	RankName:SetFont("ixSmallFont")
	RankName:SetTextColor(Color(20,20,20))
	RankName:SetText( person.PRank )
	RankName:SetAutoStretchVertical(true)

end

function PANEL:AddVictimCard(ListPanel, person,personID)

	if (!IsValid(ListPanel)) then return end

	local ProfilePanel = ListPanel:Add( "DPanel" )
	ProfilePanel:SetSize(300,100)
	ProfilePanel:SetText("")
	ProfilePanel.Paint = function(s,w,h)

		surface.SetDrawColor(200,200,200)
	    surface.DrawRect(0,0,w,h)

	end

	local DeleteB = ProfilePanel:Add( "DImageButton" )
	DeleteB:SetSize(16,16)
	DeleteB:SetPos(ProfilePanel:GetWide() - DeleteB:GetWide(),0)
	DeleteB:SetImage( "icon16/cancel.png" )
	DeleteB.DoClick = function(s)

		self.AFKTimer = CurTime() + self.AFKReset

		Derma_Query(
		    "Are you sure about that?",
		    "Delete confirmation",
		    "Yes",
		    function()

		    	local tempList = ProfilePanel:GetParent()

		    	ProfilePanel:Remove()
		    	ProfilePanel:GetParent():InvalidateLayout()

		    	table.remove(self.PersonCaseData["Victims"].People, personID)

		    	timer.Simple(0,function()
			    	self:CalculateListTall(tempList)
			    end)

		    end,
			"No",
			function() end
		)

	end

	local BGPanel = vgui.Create("DPanel", ProfilePanel)
	BGPanel:Dock(LEFT)
	BGPanel:SetWide(100)
	BGPanel:SetMouseInputEnabled(false)
	BGPanel.Paint = function(s,w,h)
		surface.SetDrawColor(34, 52, 70)
	    surface.DrawRect(0,0,w,h)

	    

	end

	local mdl = vgui.Create("DModelPanel", BGPanel)
	mdl:Dock(FILL)
	mdl:DockMargin(2,2,2,2)
	mdl:SetModel(person.PModel or "models/error.mdl")

	function mdl:LayoutEntity( Entity )
		return 
	end

	local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
	mdl:SetLookAt(headpos-Vector(0, 0, 0))

	mdl:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

	mdl.Entity:SetEyeTarget(headpos-Vector(-30, 0, 0))

	local NamePanel = vgui.Create( "DLabel", ProfilePanel )
	NamePanel:Dock(TOP)
	NamePanel:DockMargin(10,10,0,0)
	NamePanel:SetFont("ixSmallFont")
	NamePanel:SetTextColor(Color(20,20,20))
	NamePanel:SetText( "Name:" )
	NamePanel:SetAutoStretchVertical(true)

	local NamePanel_Title = vgui.Create( "DLabel", ProfilePanel )
	NamePanel_Title:Dock(TOP)
	NamePanel_Title:DockMargin(10,0,0,0)
	NamePanel_Title:SetFont("ixSmallFont")
	NamePanel_Title:SetTextColor(Color(20,20,20))
	NamePanel_Title:SetText( person.PName )
	NamePanel_Title:SetAutoStretchVertical(true)

end

function PANEL:AddItemCard(ListPanel, person,personID)

	if (!IsValid(ListPanel)) then return end

	local ProfilePanel = ListPanel:Add( "DPanel" )
	ProfilePanel:SetSize(300,100)
	ProfilePanel:SetText("")
	ProfilePanel.Paint = function(s,w,h)

		surface.SetDrawColor(200,200,200)
	    surface.DrawRect(0,0,w,h)

	end

	local DeleteB = ProfilePanel:Add( "DImageButton" )
	DeleteB:SetSize(16,16)
	DeleteB:SetPos(ProfilePanel:GetWide() - DeleteB:GetWide(),0)
	DeleteB:SetImage( "icon16/cancel.png" )
	DeleteB.DoClick = function(s)

		self.AFKTimer = CurTime() + self.AFKReset

		Derma_Query(
		    "Are you sure about that?",
		    "Delete confirmation",
		    "Yes",
		    function()

		    	local tempList = ProfilePanel:GetParent()

		    	ProfilePanel:Remove()
		    	ProfilePanel:GetParent():InvalidateLayout()

		    	table.remove(self.PersonCaseData["Evidences"].People, personID)

		    	timer.Simple(0,function()
			    	self:CalculateListTall(tempList)
			    end)

		    end,
			"No",
			function() end
		)

	end

	local BGPanel = vgui.Create("DPanel", ProfilePanel)
	BGPanel:Dock(LEFT)
	BGPanel:SetWide(100)
	BGPanel:SetMouseInputEnabled(false)
	BGPanel.Paint = function(s,w,h)
		surface.SetDrawColor(34, 52, 70)
	    surface.DrawRect(0,0,w,h)

	    

	end


	if (person.CustomImage) then

		local CustomImage = Material("nil")

		PLUGIN:GetImgur(person.CustomImage,function(mat)
			CustomImage = mat
		end)

		// test image - FESczTU_d
		local mdl = vgui.Create("DPanel", BGPanel)
		mdl:Dock(FILL)
		mdl:DockMargin(2,2,2,2)		
		mdl.Paint = function(s,w,h)

			surface.SetDrawColor( 255,255,255 )
		    surface.SetMaterial( CustomImage )
			surface.DrawTexturedRect(0,0,w,h)

		end

	else

		local mdl = vgui.Create("DModelPanel", BGPanel)
		mdl:Dock(FILL)
		mdl:DockMargin(2,2,2,2)
		mdl:SetModel(person.IModel or "models/error.mdl")
		mdl:SetFOV(20)

		function mdl:LayoutEntity( Entity )
			return 
		end

		mdl:SetCamPos(mdl:GetCamPos()+Vector(50,0,0))
		local mn, mx = mdl.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

		mdl:SetFOV( 60 )
		mdl:SetCamPos( Vector( size, size, 5 ) )
		mdl:SetLookAt( ( mn + mx ) * 0.5 )

	end


	local NamePanel = vgui.Create( "DLabel", ProfilePanel )
	NamePanel:Dock(TOP)
	NamePanel:DockMargin(10,10,0,0)
	NamePanel:SetFont("ixSmallFont")
	NamePanel:SetTextColor(Color(20,20,20))
	NamePanel:SetText( "Name:" )
	NamePanel:SetAutoStretchVertical(true)

	local NamePanel_Title = vgui.Create( "DLabel", ProfilePanel )
	NamePanel_Title:Dock(TOP)
	NamePanel_Title:DockMargin(10,0,0,0)
	NamePanel_Title:SetFont("ixSmallFont")
	NamePanel_Title:SetTextColor(Color(20,20,20))
	NamePanel_Title:SetText( person.IName )
	NamePanel_Title:SetAutoStretchVertical(true)

end

function PANEL:AddSuspectCard(ListPanel, person,personID)

	if (!IsValid(ListPanel)) then return end

	local ProfilePanel = ListPanel:Add( "DPanel" )
	ProfilePanel:SetSize(300,100)
	ProfilePanel:SetText("")
	ProfilePanel.Paint = function(s,w,h)

		surface.SetDrawColor(200,200,200)
	    surface.DrawRect(0,0,w,h)

	end

	local DeleteB = ProfilePanel:Add( "DImageButton" )
	DeleteB:SetSize(16,16)
	DeleteB:SetPos(ProfilePanel:GetWide() - DeleteB:GetWide(),0)
	DeleteB:SetImage( "icon16/cancel.png" )
	DeleteB.DoClick = function(s)

		self.AFKTimer = CurTime() + self.AFKReset

		Derma_Query(
		    "Are you sure about that?",
		    "Delete confirmation",
		    "Yes",
		    function()

		    	local tempList = ProfilePanel:GetParent()

		    	ProfilePanel:Remove()
		    	ProfilePanel:GetParent():InvalidateLayout()

		    	table.remove(self.PersonCaseData["Suspects"].People, personID)

		    	timer.Simple(0,function()
			    	self:CalculateListTall(tempList)
			    end)

		    end,
			"No",
			function() end
		)

	end

	local ChargesB = ProfilePanel:Add( "DImageButton" )
	ChargesB:SetSize(16,16)
	ChargesB:SetPos(ProfilePanel:GetWide() - DeleteB:GetWide(),16)
	ChargesB:SetImage( "icon16/pencil.png" )
	ChargesB.DoClick = function(s)

		self.AFKTimer = CurTime() + self.AFKReset
		
		local ChargesEditPnl = vgui.Create("ixPoliceStuff_ChargesEditing")
		ChargesEditPnl.Charges = self.PersonCaseData["Suspects"].People[personID].Chargers
		ChargesEditPnl:CheckForCharges()
		ChargesEditPnl.PersonTable = personID
		ChargesEditPnl.ProfilePanel = ProfilePanel
		ChargesEditPnl:SetParent(self)
		self.IsModified = true

	end

	local BGPanel = vgui.Create("DPanel", ProfilePanel)
	BGPanel:Dock(LEFT)
	BGPanel:SetWide(100)
	BGPanel:SetMouseInputEnabled(false)
	BGPanel.Paint = function(s,w,h)
		surface.SetDrawColor(34, 52, 70)
	    surface.DrawRect(0,0,w,h)

	    

	end

	local mdl = vgui.Create("DModelPanel", BGPanel)
	mdl:Dock(FILL)
	mdl:DockMargin(2,2,2,2)
	mdl:SetModel(person.PModel or "models/error.mdl")

	function mdl:LayoutEntity( Entity )
		return 
	end

	local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
	mdl:SetLookAt(headpos-Vector(0, 0, 0))

	mdl:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

	mdl.Entity:SetEyeTarget(headpos-Vector(-30, 0, 0))

	local NamePanel = vgui.Create( "DLabel", ProfilePanel )
	NamePanel:Dock(TOP)
	NamePanel:DockMargin(10,10,0,0)
	NamePanel:SetFont("ixSmallFont")
	NamePanel:SetTextColor(Color(20,20,20))
	NamePanel:SetText( "Name:" )
	NamePanel:SetAutoStretchVertical(true)

	local NamePanel_Title = vgui.Create( "DLabel", ProfilePanel )
	NamePanel_Title:Dock(TOP)
	NamePanel_Title:DockMargin(10,0,0,0)
	NamePanel_Title:SetFont("ixSmallFont")
	NamePanel_Title:SetTextColor(Color(20,20,20))
	NamePanel_Title:SetText( person.PName )
	NamePanel_Title:SetAutoStretchVertical(true)

	self:CalculateFineValue(ProfilePanel, person.Chargers)
	
end

local function GetAmountByName(String)
    local Amount = 0 
    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if v.Name == String then 
            Amount = v.Price
            break
        end 
    end 
    return Amount 
end

function PANEL:CalculateFineValue(ProfilePanel, Charges)

	-- local test = {
	-- 	["assault"] = {
	-- 		Fine = 500,
	-- 		PrisonTime = 2,
	-- 	},
	-- 	["murder"] = {
	-- 		Fine = 1000,
	-- 		PrisonTime = 2,
	-- 	},
	-- }

	local totalfine = 0
	local prisontime = 0

	local chargesCount = 0

	for k, v in pairs(Charges) do
		totalfine = totalfine + GetAmountByName(k) * v
		chargesCount = chargesCount + v
		-- prisontime = test[k].PrisonTime * v
	end

	// In case if you want use is
	-- local PrisonTime = vgui.Create( "DLabel", ProfilePanel )
	-- PrisonTime:Dock(TOP)
	-- PrisonTime:DockMargin(10,10,0,0)
	-- PrisonTime:SetFont("ixSmallFont")
	-- PrisonTime:SetTextColor(Color(20,20,20))
	-- PrisonTime:SetText( "Prison Time: "..prisontime.." minutes" )
	-- PrisonTime:SetAutoStretchVertical(true)

	if (IsValid(ProfilePanel.ChargesCount)) then
		ProfilePanel.ChargesCount:SetText( "Total Charges count: "..chargesCount )

	else

		local ChargesCount = vgui.Create( "DLabel", ProfilePanel )
		ChargesCount:Dock(TOP)
		ChargesCount:DockMargin(10,10,0,0)
		ChargesCount:SetFont("ixSmallFont")
		ChargesCount:SetTextColor(Color(20,20,20))
		ChargesCount:SetText( "Total Charges count: "..chargesCount )
		ChargesCount:SetAutoStretchVertical(true)

		ProfilePanel.ChargesCount = ChargesCount

	end

	if (IsValid(ProfilePanel.FinedValue)) then
		ProfilePanel.FinedValue:SetText( "Total finned: $"..totalfine )

	else

		local FinedValue = vgui.Create( "DLabel", ProfilePanel )
		FinedValue:Dock(TOP)
		FinedValue:DockMargin(10,0,0,0)
		FinedValue:SetFont("ixSmallFont")
		FinedValue:SetTextColor(Color(20,20,20))
		FinedValue:SetText( "Total finned: $"..totalfine )
		FinedValue:SetAutoStretchVertical(true)

		ProfilePanel.FinedValue = FinedValue

	end

end

vgui.Register("ixPolice_LaptopMenu", PANEL, "DFrame")

-- vgui.Create("ixPolice_LaptopMenu")

