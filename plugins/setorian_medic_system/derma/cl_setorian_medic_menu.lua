
local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

local scrw = ScrW()
local scrh = ScrH()


function PANEL:Init()


	-- self:SetSize(770,570)
	self:SetSize(400,400)
	
	self:Center()
	self:MakePopup()

	self:SetAlpha(0)

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self:DockPadding(10,35,10,10)


	self.Paint = function(s,w,h)

		//Background
	    surface.SetDrawColor(52, 73, 94, 250)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(44, 62, 80, 230)
	    surface.DrawOutlinedRect(0,0,w,h,5)

	    surface.SetDrawColor(44, 62, 80, 230)
	    surface.DrawRect(0,5,w,20)


	end

	self:AlphaTo(255,0.3)

	local Title = vgui.Create( "DLabel", self )
	Title:SetPos(15,0)
	Title:SetFont("ixMediumFont")
	Title:SetText( "Paramedic Menu" )
	Title:SizeToContents()


	local ExitButton = vgui.Create( "DButton", self )
	ExitButton:Dock(BOTTOM)
	ExitButton:DockMargin(0,5,0,0)
	ExitButton:SetTall(40)
	ExitButton:SetZPos(1)
	ExitButton:SetText("EXIT")
	ExitButton:SetFont("ixMediumFont")
	ExitButton.Paint = function(s,w,h)

		if (s:IsHovered()) then
			surface.SetDrawColor(20,20,20,200)
		else
	    surface.SetDrawColor(20,20,20,100)
	    end
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(44, 62, 80)
		surface.DrawOutlinedRect(0,0, w, h, 2)

	end
	ExitButton.DoClick = function(s)

		surface.PlaySound("ui/buttonclick.wav")

		self:AlphaTo(0, 0.3,0, function() 
			
			self:Close()

		end)

	end

	local ScrollPanel = vgui.Create( "DScrollPanel", self )
	ScrollPanel:Dock( FILL )

	local sbar = ScrollPanel:GetVBar()
	sbar:SetSize(3,0)

	self.ScrollPanel = ScrollPanel

	self:DisplayFunctions()

end

function PANEL:DisplayFunctions()

	for k, v in ipairs(PLUGIN.medic_funcs or {}) do
		
		local FuncButton = vgui.Create( "DButton", self.ScrollPanel )
		FuncButton:Dock(TOP)
		FuncButton:DockMargin(0,0,0,5)
		FuncButton:DockPadding(5,15,5,5)
		FuncButton:SetTall(100)
		FuncButton:SetText("")
		FuncButton.Paint = function(s,w,h)

			if (s:IsHovered()) then
				surface.SetDrawColor(20,20,20,200)
			else
		    surface.SetDrawColor(20,20,20,100)
		    end
		    surface.DrawRect(0,0,w,h)

		    surface.SetDrawColor(44, 62, 80)
			surface.DrawOutlinedRect(0,0, w, h, 2)

		end
		FuncButton.DoClick = function(s)

			surface.PlaySound("ui/buttonclick.wav")

			net.Start( "ixMedicMenu_DoAction" )
			net.WriteUInt(k,3)
			net.SendToServer()

			self:AlphaTo(0, 0.3,0, function() 
			
				self:Close()

			end)

		end

		local Title = vgui.Create( "DLabel", FuncButton )
		Title:Dock(TOP)
		Title:SetFont("ixMediumFont")
		Title:SetText( string.upper(v.Title) )
		Title:SetContentAlignment(5)
		Title:SizeToContents()

		local Desc = vgui.Create( "DLabel", FuncButton )
		Desc:Dock(FILL)
		Desc:SetFont("ixSmallFont")
		Desc:SetText( v.Desc )
		-- Desc:SetWrap(true)
		Desc:SetContentAlignment(8)

		-- Desc:SizeToContents()

	end

end


vgui.Register("ixSetorianMedic_Menu", PANEL, "DFrame")
-- vgui.Create("ixSetorianMedic_Menu")
