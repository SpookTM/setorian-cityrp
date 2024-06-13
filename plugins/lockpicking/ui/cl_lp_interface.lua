local PLUGIN = PLUGIN or ix.plugin.list.lockpicking -- Please don't rename plugin folder else PLUGIN variable will be nil in NS beta
if (!PLUGIN) then
	ErrorNoHalt( 'Lockpicking plugin directory may have been changed and thus it causes lua errors. Please name it "lockpicking"\n' )
end

local PANEL = {}
PANEL.borderW = 448
PANEL.borderH = 197


function PANEL:OnInit()
	local interface = PLUGIN.Interface

	self.exitBtn = self:AddButton(L("lpExit").." E)")
    self.exitBtn.DoClick = function(this)
        interface:Stop(true)
	end
	
	self.skillLbl = select( 2, self:AddInfoTab( L"lpSkill", LocalPlayer():GetCharacter():GetAttribute( "lockpick", 0 ) ) )
	self.pinsLbl = select( 2, self:AddInfoTab( L"lpPins", interface.Item:GetQuantity() ) )
end


local matLockinside = Material( "vgui/fallout/lockpicking/inner.png" )
local matLock = Material( "vgui/fallout/lockpicking/outer.png" )
local matLockpick = Material( "vgui/fallout/lockpicking/pick.png" )

local nextVib = 0
local vib = false


function PANEL:DrawMain()
	local scales = PLUGIN.Scales
	local cfg = PLUGIN.Config

	local interface = PLUGIN.Interface
	if ( not interface.Freeze ) then
		interface:Think()
	end

	self.skillLbl:SetText(LocalPlayer():GetCharacter():GetAttribute( "lockpick", 0 ))
	self.pinsLbl:SetText(interface.Item:GetQuantity())

	-- Draw a black background to avoid transparency behing the lock
	surface.SetDrawColor( color_black )
	surface.DrawRect( (scales.sW / 2) - (scales.backgroundW / 2), (scales.sH / 2) - (scales.backgroundH / 2), scales.backgroundW, scales.backgroundH )
	
	-- Draw the outter lock
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( matLock )
	surface.DrawTexturedRect( (scales.sW / 2) - (scales.lockInnerW / 2), (scales.sH / 2) - (scales.lockInnerH / 2), scales.lockOuterW, scales.lockOuterH)


	-- Lock vibration
	local lockRotationToDraw = interface.LockAngle
	if (interface.exceedMax) then
		if (CurTime() > nextVib) then
			nextVib = CurTime() + 0.035
			vib = !vib
		end

		if (vib) then
			lockRotationToDraw = interface.LockAngle + 1
		end
	end

	-- Draw the inner lock
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( matLockinside )
	surface.DrawTexturedRectRotated( scales.sW / 2, scales.sH / 2, scales.lockInnerW, scales.lockInnerH, lockRotationToDraw)
	
	if (not interface.ChangingPin) then
		surface.SetDrawColor( 200, 200, 200, 255 )
		surface.SetMaterial( matLockpick )
		fo.ui.DrawTexturedRectRotatedPoint( scales.sW / 2, scales.sH / 2, scales.pickW, scales.pickH, 180 - interface.PinAngle, scales.pickW / 2, 0 )
	end

	ix.bar.DrawAction()
end


vgui.Register("forpLockpick", PANEL, "forpInterface")