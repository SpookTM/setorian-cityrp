
-- local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DPanel")
local PANEL = {}

local scrw = ScrW()
local scrh = ScrH()

function PANEL:Init()


	self:SetSize(450,100)
	self:SetPos(scrw/2 - self:GetWide()/2,scrh)

	self:DockPadding(10,20,10,20)

	self.Timer = CurTime() + 1
	self.TimeToAccept = 30

	self.IsClosing = false

	self.Paint = function(s,w,h)

		//Background
	    surface.SetDrawColor(44, 62, 80, 200)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(52, 73, 94, 200)
	    surface.DrawRect(4,4,w-8,h-8)

	end

	local TextDesc = self:Add( "ixLabel")
	TextDesc:Dock(TOP)
	TextDesc:SetFont("Setorian_Interaction_Font")
	TextDesc:SetText( "Waiting for player NULL to accept the frisk" )
	TextDesc:SetScaleWidth(true)
	TextDesc:SetContentAlignment(5)
	TextDesc:SetPadding(5)

	self.TextDesc = TextDesc

	local TextTimer = self:Add( "ixLabel")
	TextTimer:Dock(TOP)
	TextTimer:DockMargin(0,5,0,0)
	TextTimer:SetFont("Trebuchet24")
	TextTimer:SetText( string.ToMinutesSeconds(self.TimeToAccept) )
	TextTimer:SetScaleWidth(true)
	TextTimer:SetContentAlignment(5)
	TextTimer:SetPadding(5)

	self.TextTimer = TextTimer

end

ix_Frisk_WaitPanel = nil

function PANEL:ShowPanel(CharName)

	if (IsValid(ix_Frisk_WaitPanel)) then
		ix_Frisk_WaitPanel:Remove()
	end

	self.TextDesc:SetText( "Waiting for "..CharName.." to accept the frisk." )

	self:MoveTo(scrw/2 - self:GetWide()/2, scrh-self:GetTall(), 0.5)

	surface.PlaySound("garrysmod/content_downloaded.wav")

	ix_Frisk_WaitPanel = self

end

function PANEL:HidePanel(IsSuccess)

	if (IsValid(ix_Frisk_WaitPanel)) then

		self.IsClosing = true

		if (IsSuccess) then
			surface.PlaySound("helix/ui/press.wav")
		else
			surface.PlaySound("common/wpn_denyselect.wav")
		end

		self:MoveTo(scrw/2 - self:GetWide()/2, scrh, 0.5, 0, -1, function()
			self:Remove()
			ix_Frisk_WaitPanel = nil
		end)

	end
end

function PANEL:Think()

	if (self.TimeToAccept <= 0) then return end

	if (self.Timer < CurTime()) then
		self.TimeToAccept = self.TimeToAccept - 1
		self.TextTimer:SetText( string.ToMinutesSeconds(self.TimeToAccept) )
		self.Timer = CurTime() + 1

		if (self.TimeToAccept <= 0) and (!self.IsClosing) then
			self:HidePanel()
		end

	end


end

vgui.Register("ixFrisk_WaitPanel", PANEL, "DPanel")
-- vgui.Create("ixFrisk_WaitPanel"):ShowPanel()