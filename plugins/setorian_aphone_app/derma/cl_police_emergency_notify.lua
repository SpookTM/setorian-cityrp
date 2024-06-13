DEFINE_BASECLASS("Panel")
local PANEL = {}


function PANEL:Init()
	

	self:SetPos(15, 25)
	self:SetSize(250, ScrH())

	-- self:SetLife(35)

	ix.gui.emergencyui = self

	local NotifyTIP = vgui.Create( "DLabel", self )
	NotifyTIP:Dock(TOP)
	NotifyTIP:DockMargin(10,7,0,0)
	NotifyTIP:SetFont("ixSmallFont")
	NotifyTIP:SetText( "Hold F3 to show cursor" )
	NotifyTIP:SizeToContents()

	local NotifyPnl = vgui.Create( "DNotify", self )
	NotifyPnl:Dock(FILL)
	NotifyPnl:SetLife(30)

	self.Notify = NotifyPnl

	-- self:AddNewNotify(Entity(1), "Lorem ipsum test test")

end

function PANEL:AddNewNotify(Ply, Text)

	local bg = vgui.Create("DPanel", self.Notify)
	-- bg:Dock(TOP)
	-- bg:DockMargin(0,0,0,10)
	bg:SetSize(self:GetWide(),20)
	bg.LifeTimeAnim = 1
	bg.Paint = function(s,w,h)

		
		surface.SetDrawColor( 52, 73, 94 )
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor( 44, 62, 80 )
	    surface.DrawRect(0,0,w,30)

	    surface.SetDrawColor( 44, 62, 80 )
	    surface.DrawOutlinedRect(0,0,w,h, 2)

	    -- surface.SetDrawColor( 230,230,230 )
	    -- surface.DrawRect(4,h-6,(w-8) * s.LifeTimeAnim,2)

	    -- print(s.LifeTimeAnim)

	end

	-- bg:NewAnimation( 14, 0, 1, function( anim, pnl )
	-- 	pnl.LifeTimeAnim = 0
	-- end)
	-- bg:CreateAnimation(15, {
	-- 	index = 1,
	-- 	easing = "linear",
	-- 	OnComplete = function(animation, panel)
	-- 		panel:Remove()
	-- 	end

	-- })
	-- bg:CreateAnimation(14, {
	-- 	index = 2,
	-- 	target = {LifeTimeAnim = 0},
	-- 	easing = "linear",

	-- })

	local PlyNamePnl = vgui.Create( "DLabel", bg )
	PlyNamePnl:Dock(TOP)
	PlyNamePnl:DockMargin(10,7,0,0)
	PlyNamePnl:SetFont("ixSmallFont")
	PlyNamePnl:SetText( "From: "..Ply:Name() )
	PlyNamePnl:SizeToContents()
	-- PlyNamePnl:SetAutoStretchVertical(true)

	local WrappedDesc = ix.util.WrapText(Text, 230, "DermaDefaultBold")

	local WrappedDescString = string.Trim(table.concat( WrappedDesc, "\n"))

	local ReasonPnl = vgui.Create( "DLabel", bg )
	ReasonPnl:Dock(FILL)
	ReasonPnl:DockMargin(10,10,5,5)
	ReasonPnl:SetFont("DermaDefaultBold")
	ReasonPnl:SetText( WrappedDescString )
	-- ReasonPnl:SetWrap(true)
	ReasonPnl:SetContentAlignment(7)
	ReasonPnl:SizeToContents()

	bg:SetTall(20 + 40 + (20 + (11 * #WrappedDesc)))
	-- bg:SetTall(20 + (20 * (#WrappedDesc)))

	local progressBar = vgui.Create("DPanel", bg)
	progressBar:SetPos(4,bg:GetTall()-6)
	progressBar:SetSize(240,2)
	progressBar:SizeTo( 0, 2, self.Notify:GetLife()-0.5)
	progressBar.Paint = function(s,w,h)
		surface.SetDrawColor( 230,230,230 )
		surface.DrawRect(0,0,w,h)
	end

	local CloseButtonAlpha = 0
	local CloseButton = vgui.Create( "DButton", bg )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(5,0,5,10)
	CloseButton:SetTall(20)
	CloseButton:SetText( "Respond" )
	CloseButton:SetTextColor( Color( 255, 255, 255) )
	CloseButton:SetFont("DermaDefaultBold")
	CloseButton:SetZPos(1)
	CloseButton.Paint = function(s,w,h)
		surface.SetDrawColor( 24, 42, 60,240 )
	    surface.DrawRect(0,0,w,h)
	    surface.SetDrawColor(120,120,120,CloseButtonAlpha)
	    surface.DrawOutlinedRect(0,0,w,h)
	end
	CloseButton.OnCursorEntered = function()
	CloseButtonAlpha = 240
	surface.PlaySound( "ui/buttonrollover.wav")
	end
	CloseButton.OnCursorExited = function()
	CloseButtonAlpha = 0
	end
	CloseButton.DoClick = function()
		surface.PlaySound( "ui/buttonclick.wav")
		EmergencyAlertsTbl[Ply] = Ply:GetPos()
		bg:Remove()
	end

	-- bg:InvalidateLayout( true )
	-- bg:SizeToChildren( true, true )

	self.Notify:AddItem(bg)

end

vgui.Register("ixEmergencyService_Notify", PANEL, "Panel")
-- vgui.Create("ixEmergencyService_Notify")

if (IsValid(ix.gui.emergencyui)) then
	ix.gui.emergencyui:Remove()
end