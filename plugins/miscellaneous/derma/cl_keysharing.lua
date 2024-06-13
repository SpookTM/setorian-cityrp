
local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

AccessorFunc(PANEL, "frameMargin", "FrameMargin", FORCE_NUMBER)


function PANEL:Init()

	self:Dock(FILL)
	local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())
	self:SetFrameMargin(4)
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	local LeftColumn = vgui.Create( "DPanel", self )
	LeftColumn:Dock(LEFT)
	LeftColumn:DockPadding(10,10,10,10)
	LeftColumn:SetWide(parent:GetWide() * 0.45)
	LeftColumn.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)
	end

	self.LeftColumn = LeftColumn

	local LeftColumnTitle = vgui.Create( "DLabel", LeftColumn )
	LeftColumnTitle:Dock(TOP)
	LeftColumnTitle:DockMargin(0,0,0,10)
	LeftColumnTitle:SetFont("ixMenuButtonFont")
	LeftColumnTitle:SetText( string.utf8upper("Shared properties and vehicles") )
	LeftColumnTitle:SetContentAlignment(5)
	LeftColumnTitle:SizeToContents()

	self:RenderLeftColumntContexts()

	local RightColumn = vgui.Create( "DPanel", self )
	RightColumn:Dock(RIGHT)
	RightColumn:DockPadding(10,10,10,10)
	RightColumn:SetWide(parent:GetWide() * 0.45)
	RightColumn.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,150)
	    surface.DrawRect(0,0,w,h)
	end
	self.RightColumn = RightColumn

	local RightColumnTitle = vgui.Create( "DLabel", RightColumn )
	RightColumnTitle:Dock(TOP)
	RightColumnTitle:DockMargin(0,0,0,10)
	RightColumnTitle:SetFont("ixMenuButtonFont")
	RightColumnTitle:SetText( string.utf8upper("Share your properties and vehicles") )
	RightColumnTitle:SetContentAlignment(5)
	RightColumnTitle:SizeToContents()

	self:RenderRightColumntContexts()

end

function PANEL:OnClose()
	ix.gui.KeysSharingUI = nil
end


function PANEL:RenderLeftColumntContexts()
	
	local SharedKeysBG = vgui.Create( "DPanel", self.LeftColumn )
	SharedKeysBG:Dock(LEFT)
	SharedKeysBG:DockMargin(10,0,0,0)
	-- SharedKeysBG:DockPadding(10,10,10,10)
	SharedKeysBG:SetWide(self.LeftColumn:GetWide() * 0.46)
	SharedKeysBG.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,h)
	end

	local SharedKeysBGTitle = vgui.Create( "DLabel", SharedKeysBG )
	SharedKeysBGTitle:Dock(TOP)
	-- SharedKeysBGTitle:DockMargin(0,0,0,10)
	SharedKeysBGTitle:SetFont("ixMenuButtonFontSmall")
	SharedKeysBGTitle:SetText( string.utf8upper("Keys") )
	SharedKeysBGTitle:SetContentAlignment(5)
	SharedKeysBGTitle:SizeToContents()
	SharedKeysBGTitle:SetTall(SharedKeysBGTitle:GetTall()+10)
	SharedKeysBGTitle.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,250)
	    surface.DrawRect(0,0,w,h)
	end

	local SharedKeysScroll = vgui.Create( "DScrollPanel", SharedKeysBG )
	SharedKeysScroll:Dock(FILL)
	SharedKeysScroll:DockMargin(5,5,5,5)
	self.SharedKeysScroll = SharedKeysScroll

	-- self:PopulateSharedKeys()

	local SharedVehsBG = vgui.Create( "DPanel", self.LeftColumn )
	SharedVehsBG:Dock(RIGHT)
	SharedVehsBG:DockMargin(0,0,10,0)
	-- SharedVehsBG:DockPadding(10,10,10,10)
	SharedVehsBG:SetWide(self.LeftColumn:GetWide() * 0.46)
	SharedVehsBG.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,h)
	end

	local SharedVehsBGTitle = vgui.Create( "DLabel", SharedVehsBG )
	SharedVehsBGTitle:Dock(TOP)
	-- SharedVehsBGTitle:DockMargin(0,0,0,10)
	SharedVehsBGTitle:SetFont("ixMenuButtonFontSmall")
	SharedVehsBGTitle:SetText( string.utf8upper("Vehicles") )
	SharedVehsBGTitle:SetContentAlignment(5)
	SharedVehsBGTitle:SizeToContents()
	SharedVehsBGTitle:SetTall(SharedVehsBGTitle:GetTall()+10)
	SharedVehsBGTitle.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,250)
	    surface.DrawRect(0,0,w,h)
	end

	local SharedVehsScroll = vgui.Create( "DScrollPanel", SharedVehsBG )
	SharedVehsScroll:Dock(FILL)
	SharedVehsScroll:DockMargin(5,5,5,5)
	self.SharedVehsScroll = SharedVehsScroll

	-- self:PopulateSharedVehs()

end

function PANEL:PopulateSharedKeys()

	self.SharedKeysScroll:Clear()

	-- local keysTest = {
	-- 	{
	-- 		HouseName = "Warehouse",
	-- 		PropertyID = "12",
	-- 	},
	-- 	{
	-- 		HouseName = "Old House",
	-- 		PropertyID = "12",
	-- 	},
	-- }

	-- for k, v in ipairs(keysTest) do
	for k, v in pairs(PLUGIN.KeysShared.Properties or {}) do
		
		local KeysPnl = vgui.Create( "DPanel", self.SharedKeysScroll )
		KeysPnl:Dock(TOP)
		KeysPnl:DockMargin(0,0,0,2)
		KeysPnl:SetTall(90)
		KeysPnl.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,200)
		    surface.DrawRect(0,0,w,h)
		end

		local KeysPnlText = vgui.Create( "DLabel", KeysPnl )
		KeysPnlText:Dock(FILL)
		KeysPnlText:DockMargin(0,5,0,2)
		KeysPnlText:SetFont("ixItemBoldFont")
		KeysPnlText:SetText( v.HouseName )
		KeysPnlText:SetContentAlignment(5)
		KeysPnlText:SizeToContents()
		-- KeysPnlText.Paint = function(s,w,h)
		-- 	surface.SetDrawColor(20,202,20,200)
		--     surface.DrawRect(0,0,w,h)
		-- end

		local KeysPnlRemove= vgui.Create( "ixMenuButton", KeysPnl )
		KeysPnlRemove:Dock(BOTTOM)
		-- KeysPnlRemove:DockMargin(0,0,0,2)
		KeysPnlRemove:SetFont("ixItemDescFont")
		KeysPnlRemove:SetTextColor(Color(220,220,220))
		KeysPnlRemove:SetText( "Manage share" )
		KeysPnlRemove:SetContentAlignment(5)
		KeysPnlRemove:SizeToContents()
		KeysPnlRemove.DoClick = function()
			self:ManageShared(k, true)
		end

	end

end

function PANEL:PopulateSharedVehs()

	self.SharedVehsScroll:Clear()

	-- local keysTest = {
	-- 	{
	-- 		VehClass = "Jeep",
	-- 	},
	-- 	{
	-- 		VehClass = "gmcvantdm",
	-- 	},
	-- }

	-- for k, v in ipairs(keysTest) do
	for k, v in pairs(PLUGIN.KeysShared.Vehicles or {}) do

		local carTable = list.Get( "Vehicles" )[ k ]

		if (!carTable) or (table.IsEmpty(carTable)) then continue end
		
		local VehsPnl = vgui.Create( "DPanel", self.SharedVehsScroll )
		VehsPnl:Dock(TOP)
		VehsPnl:DockMargin(0,0,0,2)
		VehsPnl:SetTall(90)
		VehsPnl.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,200)
		    surface.DrawRect(0,0,w,h)
		end

		local VehsPnlText = vgui.Create( "DLabel", VehsPnl )
		VehsPnlText:Dock(FILL)
		VehsPnlText:DockMargin(0,5,0,2)
		VehsPnlText:SetFont("ixItemBoldFont")
		VehsPnlText:SetText( carTable.Name )
		VehsPnlText:SetContentAlignment(5)
		VehsPnlText:SizeToContents()
		-- KeysPnlText.Paint = function(s,w,h)
		-- 	surface.SetDrawColor(20,202,20,200)
		--     surface.DrawRect(0,0,w,h)
		-- end

		local VehsPnlRemove= vgui.Create( "ixMenuButton", VehsPnl )
		VehsPnlRemove:Dock(BOTTOM)
		-- KeysPnlRemove:DockMargin(0,0,0,2)
		VehsPnlRemove:SetFont("ixItemDescFont")
		VehsPnlRemove:SetTextColor(Color(220,220,220))
		VehsPnlRemove:SetText( "Manage share" )
		VehsPnlRemove:SetContentAlignment(5)
		VehsPnlRemove:SizeToContents()
		VehsPnlRemove.DoClick = function()
			self:ManageShared(k, false)
		end

	end

end

function PANEL:RenderRightColumntContexts()
	
	local ShareNewOne = vgui.Create( "DPanel", self.RightColumn )
	ShareNewOne:Dock(TOP)
	ShareNewOne:DockMargin(0,0,0,10)
	ShareNewOne:SetTall(self:GetParent():GetTall() * 0.42)
	ShareNewOne.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(20,20,20,250)
	    surface.DrawRect(0,h/2+12,w,4)

	end

	local ShareNewOneTitle = vgui.Create( "DLabel", ShareNewOne )
	ShareNewOneTitle:Dock(TOP)
	ShareNewOneTitle:SetFont("ixMenuButtonFontSmall")
	ShareNewOneTitle:SetText( string.utf8upper("create a new sharing") )
	ShareNewOneTitle:SetContentAlignment(5)
	ShareNewOneTitle:SizeToContents()
	ShareNewOneTitle:SetTall(ShareNewOneTitle:GetTall()+10)
	ShareNewOneTitle.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,250)
	    surface.DrawRect(0,0,w,h)
	end

	local ShareNewOneTitle_Properties = vgui.Create( "DPanel", ShareNewOne )
	ShareNewOneTitle_Properties:Dock(TOP)
	ShareNewOneTitle_Properties:DockPadding(5,5,5,5)
	ShareNewOneTitle_Properties:SetTall(ShareNewOne:GetTall()*0.45)
	ShareNewOneTitle_Properties.Paint = function(s,w,h)

		draw.SimpleText("9", "ixIconsBig", w-10,h-10, Color(50,50,50,200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	end

	local ShareNewOneTitle_PropertiesTitle = vgui.Create( "DLabel", ShareNewOneTitle_Properties )
	ShareNewOneTitle_PropertiesTitle:Dock(TOP)
	ShareNewOneTitle_PropertiesTitle:DockMargin(5,0,0,10)
	ShareNewOneTitle_PropertiesTitle:SetFont("ixItemBoldFont")
	ShareNewOneTitle_PropertiesTitle:SetText( string.utf8upper("Properties") )
	ShareNewOneTitle_PropertiesTitle:SetContentAlignment(4)
	ShareNewOneTitle_PropertiesTitle:SizeToContents()

	local ShareNewOne_Properties = vgui.Create( "Panel", ShareNewOneTitle_Properties )
	ShareNewOne_Properties:Dock(TOP)
	ShareNewOne_Properties:DockPadding(10,5,10,5)
	ShareNewOne_Properties:SetTall(ShareNewOneTitle_Properties:GetTall()*0.4)
	-- ShareNewOne_Properties.Paint = function(s,w,h)
	-- 	surface.SetDrawColor(40,40,40,150)
	--     surface.DrawRect(0,0,w,h)
	-- end

	local ShareNewOne_PropertiesLeftColumn = vgui.Create( "DPanel", ShareNewOne_Properties )
	ShareNewOne_PropertiesLeftColumn:Dock(LEFT)
	ShareNewOne_PropertiesLeftColumn:SetWide(self:GetParent():GetWide()*0.205)
	-- ShareNewOne_PropertiesLeftColumn:DockPadding(10,5,10,5)
	ShareNewOne_PropertiesLeftColumn.Paint = function(s,w,h)
	end

	local ShareNewOne_PropertiesRightColumn = vgui.Create( "DPanel", ShareNewOne_Properties )
	ShareNewOne_PropertiesRightColumn:Dock(RIGHT)
	ShareNewOne_PropertiesRightColumn:SetWide(self:GetParent():GetWide()*0.205)
	-- ShareNewOne_PropertiesLeftColumn:DockPadding(10,5,10,5)
	ShareNewOne_PropertiesRightColumn.Paint = function(s,w,h)
	end


	local ShareNewOneTitle_PropertyTip = vgui.Create( "DLabel", ShareNewOne_PropertiesLeftColumn )
	ShareNewOneTitle_PropertyTip:Dock(TOP)
	ShareNewOneTitle_PropertyTip:DockMargin(3,0,0,5)
	ShareNewOneTitle_PropertyTip:SetFont("ixItemDescFont")
	ShareNewOneTitle_PropertyTip:SetText( "Select a property" )
	ShareNewOneTitle_PropertyTip:SetContentAlignment(4)
	ShareNewOneTitle_PropertyTip:SizeToContents()

	local ShareNewOneTitle_PropertyChooser = vgui.Create( "DComboBox", ShareNewOne_PropertiesLeftColumn )
	ShareNewOneTitle_PropertyChooser:Dock(TOP)
	ShareNewOneTitle_PropertyChooser:DockMargin(0,0,0,5)
	ShareNewOneTitle_PropertyChooser:SetFont("ixItemDescFont")
	ShareNewOneTitle_PropertyChooser:SetValue( "" )
	ShareNewOneTitle_PropertyChooser.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)
	end
	self.ShareNewOneTitle_PropertyChooser = ShareNewOneTitle_PropertyChooser

	local ShareNewOneTitle_PlayesTip = vgui.Create( "DLabel", ShareNewOne_PropertiesRightColumn )
	ShareNewOneTitle_PlayesTip:Dock(TOP)
	ShareNewOneTitle_PlayesTip:DockMargin(3,0,0,5)
	ShareNewOneTitle_PlayesTip:SetFont("ixItemDescFont")
	ShareNewOneTitle_PlayesTip:SetText( "Select a known character nearby" )
	ShareNewOneTitle_PlayesTip:SetContentAlignment(4)
	ShareNewOneTitle_PlayesTip:SizeToContents()

	local ShareNewOneTitle_PlayersChooser = vgui.Create( "DComboBox", ShareNewOne_PropertiesRightColumn )
	ShareNewOneTitle_PlayersChooser:Dock(TOP)
	ShareNewOneTitle_PlayersChooser:DockMargin(0,0,0,5)
	ShareNewOneTitle_PlayersChooser:SetFont("ixItemDescFont")
	ShareNewOneTitle_PlayersChooser:SetValue( "" )
	ShareNewOneTitle_PlayersChooser.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)
	end
	self.ShareNewOneTitle_PlayersChooser = ShareNewOneTitle_PlayersChooser
	
	local CreateShareButton = vgui.Create( "ixMenuButton", ShareNewOneTitle_Properties )
	CreateShareButton:Dock(BOTTOM)
	CreateShareButton:DockMargin(2,0,2,5)
	CreateShareButton:SetFont("ixItemDescFont")
	CreateShareButton:SetText( "Create a new sharing" )
	CreateShareButton:SetContentAlignment(5)
	CreateShareButton:SizeToContents()
	CreateShareButton.DoClick = function(s)

		if (ShareNewOneTitle_PropertyChooser:GetValue() == "") then
			LocalPlayer():Notify("Please select a property")
			return
		end

		if (ShareNewOneTitle_PlayersChooser:GetValue() == "") then
			LocalPlayer():Notify("Please select a character")
			return
		end

		local _, PropertyID = ShareNewOneTitle_PropertyChooser:GetSelected()
		local _, clientEnt = ShareNewOneTitle_PlayersChooser:GetSelected()

		net.Start("KeySharing_CreateNewShare")
			net.WriteUInt(1, 2)
			net.WriteUInt(PropertyID,8)
			net.WriteEntity(clientEnt)
		net.SendToServer()

	end

	// ---------------------------------------------
	local ShareNewOneTitle_Vehicles = vgui.Create( "Panel", ShareNewOne )
	ShareNewOneTitle_Vehicles:Dock(TOP)
	ShareNewOneTitle_Vehicles:DockPadding(5,5,5,5)
	ShareNewOneTitle_Vehicles:SetTall(ShareNewOne:GetTall()*0.45)
	ShareNewOneTitle_Vehicles.Paint = function(s,w,h)

		draw.SimpleText("'", "ixIconsBig", w-10,h-10, Color(50,50,50,200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	end

	local ShareNewOneTitle_VehiclesTitle = vgui.Create( "DLabel", ShareNewOneTitle_Vehicles )
	ShareNewOneTitle_VehiclesTitle:Dock(TOP)
	ShareNewOneTitle_VehiclesTitle:DockMargin(5,0,0,5)
	ShareNewOneTitle_VehiclesTitle:SetFont("ixItemBoldFont")
	ShareNewOneTitle_VehiclesTitle:SetText( string.utf8upper("Vehicles") )
	ShareNewOneTitle_VehiclesTitle:SetContentAlignment(4)
	ShareNewOneTitle_VehiclesTitle:SizeToContents()

	local ShareNewOne_Vehicles = vgui.Create( "Panel", ShareNewOneTitle_Vehicles )
	ShareNewOne_Vehicles:Dock(TOP)
	ShareNewOne_Vehicles:DockPadding(10,5,10,5)
	ShareNewOne_Vehicles:SetTall(ShareNewOneTitle_Vehicles:GetTall()*0.4)
	-- ShareNewOne_Properties.Paint = function(s,w,h)
	-- 	surface.SetDrawColor(40,40,40,150)
	--     surface.DrawRect(0,0,w,h)
	-- end

	local ShareNewOne_VehiclesLeftColumn = vgui.Create( "DPanel", ShareNewOne_Vehicles )
	ShareNewOne_VehiclesLeftColumn:Dock(LEFT)
	ShareNewOne_VehiclesLeftColumn:SetWide(self:GetParent():GetWide()*0.205)
	-- ShareNewOne_PropertiesLeftColumn:DockPadding(10,5,10,5)
	ShareNewOne_VehiclesLeftColumn.Paint = function(s,w,h)
	end

	local ShareNewOne_VehiclesRightColumn = vgui.Create( "DPanel", ShareNewOne_Vehicles )
	ShareNewOne_VehiclesRightColumn:Dock(RIGHT)
	ShareNewOne_VehiclesRightColumn:SetWide(self:GetParent():GetWide()*0.205)
	-- ShareNewOne_PropertiesLeftColumn:DockPadding(10,5,10,5)
	ShareNewOne_VehiclesRightColumn.Paint = function(s,w,h)
	end


	local ShareNewOneTitle_VehsTip = vgui.Create( "DLabel", ShareNewOne_VehiclesLeftColumn )
	ShareNewOneTitle_VehsTip:Dock(TOP)
	ShareNewOneTitle_VehsTip:DockMargin(3,0,0,5)
	ShareNewOneTitle_VehsTip:SetFont("ixItemDescFont")
	ShareNewOneTitle_VehsTip:SetText( "Select a vehicle" )
	ShareNewOneTitle_VehsTip:SetContentAlignment(4)
	ShareNewOneTitle_VehsTip:SizeToContents()

	local ShareNewOneTitle_VehChooser = vgui.Create( "DComboBox", ShareNewOne_VehiclesLeftColumn )
	ShareNewOneTitle_VehChooser:Dock(TOP)
	ShareNewOneTitle_VehChooser:DockMargin(0,0,0,5)
	ShareNewOneTitle_VehChooser:SetFont("ixItemDescFont")
	ShareNewOneTitle_VehChooser:SetValue( "" )
	ShareNewOneTitle_VehChooser.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)
	end
	self.ShareNewOneTitle_VehChooser = ShareNewOneTitle_VehChooser

	local ShareNewOneTitle_PlayesVehTip = vgui.Create( "DLabel", ShareNewOne_VehiclesRightColumn )
	ShareNewOneTitle_PlayesVehTip:Dock(TOP)
	ShareNewOneTitle_PlayesVehTip:DockMargin(3,0,0,5)
	ShareNewOneTitle_PlayesVehTip:SetFont("ixItemDescFont")
	ShareNewOneTitle_PlayesVehTip:SetText( "Select a known character nearby" )
	ShareNewOneTitle_PlayesVehTip:SetContentAlignment(4)
	ShareNewOneTitle_PlayesVehTip:SizeToContents()

	local ShareNewOneTitle_PlayersVehChooser = vgui.Create( "DComboBox", ShareNewOne_VehiclesRightColumn )
	ShareNewOneTitle_PlayersVehChooser:Dock(TOP)
	ShareNewOneTitle_PlayersVehChooser:DockMargin(0,0,0,5)
	ShareNewOneTitle_PlayersVehChooser:SetFont("ixItemDescFont")
	ShareNewOneTitle_PlayersVehChooser:SetValue( "" )
	ShareNewOneTitle_PlayersVehChooser.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)
	end
	self.ShareNewOneTitle_PlayersVehChooser = ShareNewOneTitle_PlayersVehChooser
	
	local CreateShareButtonVeh = vgui.Create( "ixMenuButton", ShareNewOneTitle_Vehicles )
	CreateShareButtonVeh:Dock(BOTTOM)
	CreateShareButtonVeh:DockMargin(2,0,2,5)
	CreateShareButtonVeh:SetFont("ixItemDescFont")
	CreateShareButtonVeh:SetText( "Create a new sharing" )
	CreateShareButtonVeh:SetContentAlignment(5)
	CreateShareButtonVeh:SizeToContents()
	CreateShareButtonVeh.DoClick = function(s)

		if (ShareNewOneTitle_VehChooser:GetValue() == "") then
			LocalPlayer():Notify("Please select a vehicle")
			return
		end

		if (ShareNewOneTitle_PlayersVehChooser:GetValue() == "") then
			LocalPlayer():Notify("Please select a character")
			return
		end

		local _, carEnt = ShareNewOneTitle_VehChooser:GetSelected()
		local _, clientEnt = ShareNewOneTitle_PlayersVehChooser:GetSelected()

		net.Start("KeySharing_CreateNewShare")
			net.WriteUInt(2, 2)
			net.WriteEntity(carEnt)
			net.WriteEntity(clientEnt)
		net.SendToServer()

	end

	////////////////////////////////////////

	local ShareManage = vgui.Create( "DPanel", self.RightColumn )
	ShareManage:Dock(TOP)
	ShareManage:DockMargin(0,0,0,10)
	-- ShareManage:DockPadding(10,5,10,5)
	ShareManage:SetTall(self:GetParent():GetTall() * 0.42)
	-- ShareManage:SetMouseInputEnabled(false)
	ShareManage.Paint = function(s,w,h)
		surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,h)

	    draw.SimpleText("`", "ixIconsBig", w-10,h-10, Color(50,50,50,200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

	end
	-- ShareManage.PaintOver = function(s,w,h)

	-- 	if (self.ShareID == "") then
	--     	surface.SetDrawColor(40,40,40,250)
	--     	surface.DrawRect(0,0,w,h)
	--     	draw.SimpleText("Select a sharing to manage", "ixMenuButtonFontSmall", w/2,h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--     else
	--     	return true
	--     end

	-- end
	self.ShareManage = ShareManage

	local ShareManageTitle = vgui.Create( "DLabel", ShareManage )
	ShareManageTitle:Dock(TOP)
	ShareManageTitle:SetFont("ixMenuButtonFontSmall")
	ShareManageTitle:SetText( string.utf8upper("manage existing sharing") )
	ShareManageTitle:SetContentAlignment(5)
	ShareManageTitle:SizeToContents()
	ShareManageTitle:SetTall(ShareManageTitle:GetTall()+10)
	ShareManageTitle.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,250)
	    surface.DrawRect(0,0,w,h)
	end

	local ShareManageBlur = vgui.Create( "Panel", ShareManage )
	ShareManageBlur:SetPos(0,ShareManageTitle:GetTall())
	ShareManageBlur:SetSize(self:GetParent():GetWide() * 0.44, self:GetParent():GetTall() * 0.42)
	ShareManageBlur:SetZPos(99)
	ShareManageBlur.Paint = function(s,w,h)

		surface.SetDrawColor(40,40,40,250)
    	surface.DrawRect(0,0,w,h)
    	draw.SimpleText("Select a sharing to manage", "ixMenuButtonFontSmall", w/2,h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end
	self.ShareManageBlur = ShareManageBlur

	local ShareManageContent = vgui.Create( "Panel", ShareManage )
	ShareManageContent:Dock(FILL)
	ShareManageContent:DockMargin(10,5,10,5)

	local ShareManageTitle_Title = vgui.Create( "DLabel", ShareManageContent )
	ShareManageTitle_Title:Dock(TOP)
	ShareManageTitle_Title:DockMargin(0,5,0,15)
	ShareManageTitle_Title:SetFont("ixItemBoldFont")
	ShareManageTitle_Title:SetText( string.utf8upper("You are editing:") )
	ShareManageTitle_Title:SetContentAlignment(4)
	ShareManageTitle_Title:SizeToContents()
	self.ShareManageTitle_Title = ShareManageTitle_Title

	local ShareManage_PlayesManageTip = vgui.Create( "DLabel", ShareManageContent )
	ShareManage_PlayesManageTip:Dock(TOP)
	ShareManage_PlayesManageTip:DockMargin(3,0,0,5)
	ShareManage_PlayesManageTip:SetFont("ixItemDescFont")
	ShareManage_PlayesManageTip:SetText( "Select a new known character nearby" )
	ShareManage_PlayesManageTip:SetContentAlignment(4)
	ShareManage_PlayesManageTip:SizeToContents()

	local ShareManage_PlayesManageChooser = vgui.Create( "DComboBox", ShareManageContent )
	ShareManage_PlayesManageChooser:Dock(TOP)
	ShareManage_PlayesManageChooser:DockMargin(0,0,0,5)
	ShareManage_PlayesManageChooser:SetFont("ixItemDescFont")
	ShareManage_PlayesManageChooser:SetValue( "" )
	ShareManage_PlayesManageChooser.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)
	end
	self.ShareManage_PlayesManageChooser = ShareManage_PlayesManageChooser

	local AddNewPlyButton = vgui.Create( "ixMenuButton", ShareManageContent )
	AddNewPlyButton:Dock(TOP)
	AddNewPlyButton:DockMargin(0,0,0,5)
	AddNewPlyButton:SetFont("ixItemDescFont")
	AddNewPlyButton:SetText( "Add a new character" )
	AddNewPlyButton:SetContentAlignment(5)
	-- AddNewPlyButton:SizeToContents()
	AddNewPlyButton.DoClick = function()

		if (self.ShareID != "") then

			if (ShareManage_PlayesManageChooser:GetValue() == "") then
				LocalPlayer():Notify("Please select a character")
				return
			end

			local _, clientEnt = ShareManage_PlayesManageChooser:GetSelected()

			
			net.Start("KeySharing_PlyManage")
	    		if (self.isProperty) then
	    			net.WriteUInt(1, 2)
					net.WriteUInt(self.ShareID,8)
				else
					net.WriteUInt(2, 2)
					net.WriteString(self.ShareID)
				end
				net.WriteEntity(clientEnt)
				net.WriteBool(false)
	    	net.SendToServer()


		end

	end
	self.AddNewPlyButton = AddNewPlyButton

	local ShareManage_AllPlayes = vgui.Create( "DLabel", ShareManageContent )
	ShareManage_AllPlayes:Dock(TOP)
	ShareManage_AllPlayes:DockMargin(3,5,0,5)
	ShareManage_AllPlayes:SetFont("ixItemDescFont")
	ShareManage_AllPlayes:SetText( "Shared for:" )
	ShareManage_AllPlayes:SetContentAlignment(4)
	ShareManage_AllPlayes:SizeToContents()

	local ShareManageScrollBG = vgui.Create( "Panel", ShareManageContent )
	ShareManageScrollBG:Dock(FILL)
	ShareManageScrollBG:DockMargin(3,5,3,5)
	ShareManageScrollBG.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)
	end

	local ShareManageScroll = vgui.Create( "DScrollPanel", ShareManageScrollBG )
	ShareManageScroll:Dock( FILL )
	ShareManageScroll:DockMargin(2,2,0,2)
	ShareManageScroll:SetMouseInputEnabled(true)
	self.ShareManageScroll = ShareManageScroll

	-- for i=0, 10 do
	-- 	local ShareManagePlyBG = ShareManageScroll:Add( "DPanel" )
	-- 	ShareManagePlyBG:Dock( TOP )
	-- 	ShareManagePlyBG:DockMargin( 0, 0, 0, 5 )
	-- 	ShareManagePlyBG:DockPadding(15,0,5,0)
	-- 	ShareManagePlyBG:SetTall(50)
	-- 	ShareManagePlyBG.Paint = function(s,w,h)
	-- 		surface.SetDrawColor(20,20,20,200)
	-- 	    surface.DrawRect(0,0,w,h)
	-- 	end

	-- 	local ShareManagePlyBG_PlyName = vgui.Create( "DLabel", ShareManagePlyBG )
	-- 	ShareManagePlyBG_PlyName:Dock(LEFT)
	-- 	-- ShareManagePlyBG_PlyName:DockMargin(3,5,0,5)
	-- 	ShareManagePlyBG_PlyName:SetFont("ixItemDescFont")
	-- 	ShareManagePlyBG_PlyName:SetText( "JohnyReaper" )
	-- 	ShareManagePlyBG_PlyName:SetContentAlignment(5)
	-- 	ShareManagePlyBG_PlyName:SizeToContents()

	-- 	local RemovePlyButton = vgui.Create( "ixMenuButton", ShareManagePlyBG )
	-- 	RemovePlyButton:Dock(RIGHT)
	-- 	-- AddNewPlyButton:DockMargin(0,0,0,5)
	-- 	RemovePlyButton:SetFont("ixItemDescFont")
	-- 	RemovePlyButton:SetText( "Remove character" )
	-- 	RemovePlyButton:SetTextColor(Color(250,120,120))
	-- 	RemovePlyButton:SetContentAlignment(5)
	-- 	RemovePlyButton:SizeToContents()

	-- end

	local RemoveShareButton = vgui.Create( "ixMenuButton", ShareManage )
	RemoveShareButton:Dock(BOTTOM)
	RemoveShareButton:DockMargin(5,0,5,10)
	RemoveShareButton:SetFont("ixItemDescFont")
	RemoveShareButton:SetTextColor(Color(250,120,120))
	RemoveShareButton:SetText( "Delete sharing" )
	RemoveShareButton:SetContentAlignment(5)
	RemoveShareButton:SizeToContents()
	RemoveShareButton.DoClick = function()

		if (self.ShareID != "") then
			Derma_Query(
			    "Are you sure you want to remove this sharing? This will remove access to any person added to the share. This action cannot be undone.",
			    "Confirmation:",
			    "Yes",
			    function() 

			    	net.Start("KeySharing_RemoveShare")
						if (self.isProperty) then			    	
			    			net.WriteUInt(1, 2)
							net.WriteUInt(self.ShareID,8)
						else
							net.WriteUInt(2, 2)
							net.WriteString(self.ShareID)
						end
			    	net.SendToServer()

			    	self.ShareID = ""

			    end,
				"No"
			)
		end

	end

end

function PANEL:ManageShared(shareID, isProperty)

	self.ShareManage:SetMouseInputEnabled(true)
	for k, v in ipairs(self.ShareManage:GetChildren()) do
		v:SetMouseInputEnabled(true)
	end

	if (self.ShareManageBlur) and IsValid(self.ShareManageBlur) then
		self.ShareManageBlur:Remove()
	end

	self.ShareID = shareID
	self.isProperty = isProperty
	local shareData

	if (isProperty) then
		shareData = PLUGIN.KeysShared.Properties[shareID]
	else
		shareData = PLUGIN.KeysShared.Vehicles[shareID]
	end

	-- if (self.ShareManage_PlayesManageChooser) and (IsValid(self.ShareManage_PlayesManageChooser)) then
	-- 	self.ShareManage_PlayesManageChooser:SetValue( "" )
	
	-- 	for client, character in ix.util.GetCharacters() do
	-- 		if (client == LocalPlayer()) then continue end

	-- 		if (LocalPlayer():GetPos():DistToSqr(client:GetPos()) < (90*90)) and (LocalPlayer():GetCharacter():DoesRecognize(character:GetID())) and (!shareData.Players[character:GetID()]) then

	-- 			if (self.ShareManage_PlayesManageChooser) and (IsValid(self.ShareManage_PlayesManageChooser)) then
	-- 				self.ShareManage_PlayesManageChooser:AddChoice(client:Name(),client)
	-- 			end

	-- 		end
	-- 	end

	-- end

	if (isProperty) then
		self.ShareManageTitle_Title:SetText( string.utf8upper("You are editing: "..shareData.HouseName) )
	else
		self.ShareManageTitle_Title:SetText( string.utf8upper("You are editing: "..list.Get( "Vehicles" )[ shareID ].Name) )
	end

	self.ShareManageScroll:Clear()

	for k, v in pairs(shareData.SharePly or {}) do
		local ShareManagePlyBG = self.ShareManageScroll:Add( "DPanel" )
		ShareManagePlyBG:Dock( TOP )
		ShareManagePlyBG:DockMargin( 0, 0, 0, 5 )
		ShareManagePlyBG:DockPadding(15,0,5,0)
		ShareManagePlyBG:SetTall(50)
		ShareManagePlyBG:SetMouseInputEnabled(true)
		ShareManagePlyBG.Paint = function(s,w,h)
			surface.SetDrawColor(20,20,20,200)
		    surface.DrawRect(0,0,w,h)
		end

		local ShareManagePlyBG_PlyName = vgui.Create( "DLabel", ShareManagePlyBG )
		ShareManagePlyBG_PlyName:Dock(LEFT)
		-- ShareManagePlyBG_PlyName:DockMargin(3,5,0,5)
		ShareManagePlyBG_PlyName:SetFont("ixItemDescFont")
		ShareManagePlyBG_PlyName:SetText( (k == LocalPlayer():GetCharacter():GetID() and "Faction Members") or (ix.char.loaded[k] and ix.char.loaded[k]:GetName()) or "[OFFLINE] " .. v )
		ShareManagePlyBG_PlyName:SetContentAlignment(5)
		ShareManagePlyBG_PlyName:SizeToContents()

		local RemovePlyButton = vgui.Create( "ixMenuButton", ShareManagePlyBG )
		RemovePlyButton:Dock(RIGHT)
		-- AddNewPlyButton:DockMargin(0,0,0,5)
		RemovePlyButton:SetFont("ixItemDescFont")
		RemovePlyButton:SetText( "Remove" )
		RemovePlyButton:SetTextColor(Color(250,120,120))
		RemovePlyButton:SetMouseInputEnabled(true)
		RemovePlyButton:SetContentAlignment(5)
		RemovePlyButton:SizeToContents()
		RemovePlyButton.DoClick = function()


			net.Start("KeySharing_PlyManage")
	    		if (isProperty) then
	    			net.WriteUInt(1, 2)
					net.WriteUInt(self.ShareID,8)
				else
					net.WriteUInt(2, 2)
					net.WriteString(self.ShareID)
				end
				-- net.WriteUInt(k, 10)
				net.WriteEntity(ix.char.loaded[k]:GetPlayer())
				net.WriteBool(true)
	    	net.SendToServer()


		end

	end

	self.ShareManage_PlayesManageChooser:SetValue( "" )
	self.ShareManage_PlayesManageChooser:Clear()

	if (PLUGIN.AllowedSharedFactions and PLUGIN.AllowedSharedFactions[LocalPlayer():GetCharacter():GetFaction()]) then
		if (!shareData.SharePly[LocalPlayer():GetCharacter():GetID()]) then
			if (self.ShareManage_PlayesManageChooser) and (IsValid(self.ShareManage_PlayesManageChooser)) then
				self.ShareManage_PlayesManageChooser:AddChoice("All Faction Members",LocalPlayer())
			end
		end
	end

	for client, character in ix.util.GetCharacters() do
		if (client == LocalPlayer()) then continue end
		if (shareData.SharePly[character:GetID()]) then continue end

		if (LocalPlayer():GetPos():DistToSqr(client:GetPos()) < (90*90)) and (LocalPlayer():GetCharacter():DoesRecognize(character:GetID())) then
			self.ShareManage_PlayesManageChooser:AddChoice(client:Name(),client)
		end
	end

end

function PANEL:UpdateProperties()

	if (!self.ShareNewOneTitle_PropertyChooser) or (!IsValid(self.ShareNewOneTitle_PropertyChooser)) then return end

	self.ShareNewOneTitle_PropertyChooser:SetValue( "" )

	local char = LocalPlayer():GetCharacter()
	local inv  = char:GetInventory()

	self.ShareNewOneTitle_PropertyChooser:Clear()

	-- if (PLUGIN.KeysShared.Properties) and (!table.IsEmpty(PLUGIN.KeysShared.Properties)) then

		for k, v in ipairs(inv:GetItemsByUniqueID("housekey")) do

			if (tonumber(v:GetData("PropertyID")) > 0) and (!v:GetData("IsSharedKey", false)) then

				if (PLUGIN.KeysShared.Properties) and (PLUGIN.KeysShared.Properties[tonumber(v:GetData("PropertyID"))] and (!table.IsEmpty(PLUGIN.KeysShared.Properties[tonumber(v:GetData("PropertyID"))]))) then continue end

				self.ShareNewOneTitle_PropertyChooser:AddChoice(v:GetData("HouseName"),tonumber(v:GetData("PropertyID")))

			end
			
		end

	-- end

end

function PANEL:UpdateCars()

	if (!self.ShareNewOneTitle_VehChooser) or (!IsValid(self.ShareNewOneTitle_VehChooser)) then return end

	self.ShareNewOneTitle_VehChooser:SetValue( "" )

	self.ShareNewOneTitle_VehChooser:Clear()


	-- if (PLUGIN.KeysShared.Vehicles) and (!table.IsEmpty(PLUGIN.KeysShared.Vehicles)) then

		for k, v in ipairs(ents.GetAll()) do
			if (v:IsVehicle()) then
				if (v:GetNetVar("owner") == LocalPlayer():GetCharacter():GetID()) and (list.Get( "Vehicles" )[ v:GetVehicleClass() ]) then

					if (PLUGIN.KeysShared.Vehicles) and (PLUGIN.KeysShared.Vehicles[v:GetVehicleClass()]) then continue end

					self.ShareNewOneTitle_VehChooser:AddChoice(list.Get( "Vehicles" )[ v:GetVehicleClass() ].Name,v)
				end
			end
		end

	-- end

end

function PANEL:UpdatePlayers()

	if (self.ShareNewOneTitle_PlayersChooser) and (IsValid(self.ShareNewOneTitle_PlayersChooser)) then
		self.ShareNewOneTitle_PlayersChooser:SetValue( "" )
	end

	if (self.ShareNewOneTitle_PlayersVehChooser) and (IsValid(self.ShareNewOneTitle_PlayersVehChooser)) then
		self.ShareNewOneTitle_PlayersVehChooser:SetValue( "" )
	end

	if (PLUGIN.AllowedSharedFactions and PLUGIN.AllowedSharedFactions[LocalPlayer():GetCharacter():GetFaction()]) then
		if (self.ShareNewOneTitle_PlayersChooser) and (IsValid(self.ShareNewOneTitle_PlayersChooser)) then
			self.ShareNewOneTitle_PlayersChooser:AddChoice("All Faction Members",LocalPlayer())
		end
		if (self.ShareNewOneTitle_PlayersVehChooser) and (IsValid(self.ShareNewOneTitle_PlayersVehChooser)) then
			self.ShareNewOneTitle_PlayersVehChooser:AddChoice("All Faction Members",LocalPlayer())
		end
	end

	for client, character in ix.util.GetCharacters() do
		if (client == LocalPlayer()) then continue end

		if (LocalPlayer():GetPos():DistToSqr(client:GetPos()) < (90*90)) and (LocalPlayer():GetCharacter():DoesRecognize(character:GetID())) then

			if (self.ShareNewOneTitle_PlayersChooser) and (IsValid(self.ShareNewOneTitle_PlayersChooser)) then
				self.ShareNewOneTitle_PlayersChooser:AddChoice(client:Name(),client)
			end

			if (self.ShareNewOneTitle_PlayersVehChooser) and (IsValid(self.ShareNewOneTitle_PlayersVehChooser)) then
				self.ShareNewOneTitle_PlayersVehChooser:AddChoice(client:Name(),client)
			end

		end

	end

end

function PANEL:Update(ply)

	-- self:PopulateSharedKeys()
	-- self:PopulateSharedVehs()

	print("request sent")
	net.Start("KeySharing_SyncSharing_Req")
	net.SendToServer()

	-- self:UpdateCars()
	-- self:UpdateProperties()
	self:UpdatePlayers()

	self.ShareID = ""

end

function PANEL:Paint(width, height)
-- 	derma.SkinFunc("PaintCharacterCreateBackground", self, width, height)
-- 	BaseClass.Paint(self, width, height)
-- surface.SetDrawColor(39,39,39)
-- 		surface.DrawRect(0, 0, width, height)
end

vgui.Register("ixKeysShareUI", PANEL, "DFrame")

hook.Add("CreateMenuButtons", "ixGloveBoxHandler", function(tabs)
	-- if (hook.Run("ShowKeysSharing") != false) then
		tabs["Keys Sharing"] = {
			Create = function(info, container)

			-- 	-- local canvas = container:Add("DTileLayout")
			-- 	-- local canvasLayout = canvas.PerformLayout
			-- 	-- canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
			-- 	-- canvas:SetBorder(0)
			-- 	-- canvas:SetSpaceX(2)
			-- 	-- canvas:SetSpaceY(2)
			-- 	-- canvas:Dock(FILL)

				container.KeysSharingUI = container:Add("ixKeysShareUI")
				ix.gui.KeysSharingUI = container.KeysSharingUI

			-- 	local localInventory = LocalPlayer():GetCharacter():GetInventory()

			-- 	if (localInventory) then
			-- 		container.GloveBoxUI:SetLocalInventory(localInventory)
			-- 	end

			-- 	ix.gui.gloveboxUI:Update(LocalPlayer():GetVehicle())

			-- 	-- canvas.PerformLayout = canvasLayout
			-- 	-- canvas:Layout()

			end,
			OnSelected = function(info, container)
				container.KeysSharingUI:Update(LocalPlayer())
			end,
		}
	-- end
end)