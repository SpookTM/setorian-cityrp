local PLUGIN = PLUGIN
PLUGIN.Interface = PLUGIN.Interface
PLUGIN.Scales = PLUGIN.Scales or {}



-----------------------------------------
--[[ RELATIVE TO SCR PANEL SCALES ]]-----
-----------------------------------------
function PLUGIN:LoadFonts()
    local sc = self.Scales

    sc.sW = ScrW()
    sc.sH = ScrH()
    sc.scale = (sc.sH/1080) * 0.75 
    sc.pickW = 858 * sc.scale * 1.11
    sc.pickH = 38 * sc.scale * 1.11
    sc.lockInnerW = 1037 * sc.scale
    sc.lockInnerH = 1037 * sc.scale
    sc.backgroundW = 730 * sc.scale
    sc.backgroundH = 730 * sc.scale
    sc.lockOuterW = 1037 * sc.scale
    sc.lockOuterH = 1037 * sc.scale
end



-----------------------------------
--[[ CREATE / REMOVE INTERFACE ]]--
-----------------------------------
function PLUGIN:CreateInterface()
    local i = setmetatable({}, self.InterfaceClass)
    self.Interface = i
    return i
end

function PLUGIN:RemoveInterface()
	local i = PLUGIN.Interface
	i = nil
	PLUGIN.Interface = nil
end


-------------------------
--[[ INTERFACE CLASS ]]--
-------------------------
local Class = PLUGIN.InterfaceClass or {}
Class.__index = Class
Class.Sounds = {}
Class.LockAngle = 0
Class.OldPinRotation = 0
Class.NextPickSound = 1.5


-- Open interface panel and enable lock movements
function Class:Start()
	self.Panel = vgui.Create("forpLockpick")
	self.Panel:OnInit()
end

-- Close interface panel and disable lock movements
function Class:Stop(share, msg)
    local panel = self.Panel
    if ( IsValid(panel) ) then
        panel:Remove()
	end

    self:StopSound("tension")

	-- Stop hooks
	if ( msg )  then
		--LocalPlayer():foNotify(L(PLUGIN.Messages[msg]))
		ix.util.Notify(L(PLUGIN.Messages[msg]))
	end

    if ( share ) then
        netstream.Start("lpStop")
	end
	
    PLUGIN:RemoveInterface()
end


-- Stared action that will start the lockpicking
function Class:StartingAction(state, enterMoment)
    if (state) then
		if (enterMoment) then
			timer.Create("lpEnterSound", enterMoment - 1, 1, function()
				self:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
			end)
		end

		if (IsValid(ix.gui.menu)) then
			ix.gui.menu:Remove()
		end
	end
end

-- Stared action that will load another bobbypin
function Class:ChangePinAction(time)
	self.RotatingLock = false
	self.ChangingPin = true
	timer.Simple(time, function()
		self.ChangingPin = false
	end)

	self:PlaySound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)

	timer.Create("lpEnterSound" ,time - 1, 1, function()
		self:PlaySound("lockpicking/enter.wav", 50, 1, "enter")
	end)
end


-- Play a lockpicking sound that can be stopped whenever we want
function Class:PlaySound(soundName, soundLevel, volume, id)
    local sound = CreateSound(LocalPlayer(), soundName)
	sound:ChangeVolume(volume)
	sound:SetSoundLevel(soundLevel)
	sound:Play()
        
    local sounds = self.Sounds
	if (id) then
		sounds[id] = sound
    end
end

-- Stop a lockpicking sound
function Class:StopSound(id)
	local sounds = self.Sounds
	if (sounds[id]) then
		sounds[id]:Stop()
		sounds[id] = nil
	end
end


-- Move lock cylinder and simulate physics
function Class:Think()
	local cfg = PLUGIN.CONFIG

	self.MaxLockAngle = self.MaxLockAngle or cfg.HardMaxAngle

	self.exceedMax = false
	if (not self.Success) then
		if (self.RotatingLock and not self.ChangingPin) then
			self.LockAngle = self.LockAngle - (cfg.TurningSpeed * FrameTime())

			if (self.LockAngle < self.MaxLockAngle) then
				self.exceedMax = true
				self.LockAngle = self.MaxLockAngle
			end

			if (not self.CylinderTurned) then
				self:PlaySound("lockpicking/cylinderturn_"..math.random(8)..".wav", 50, 1, "cylinder")
				self:PlaySound("lockpicking/a/cylindersqueak_"..math.random(7)..".wav", 50, 1, "squeak")

				self.CylinderTurned = true
			end
		else
			self.LockAngle = self.LockAngle + (cfg.ReleasingSpeed * FrameTime())
			self.LockAngle = math.min(self.LockAngle, 0)
			self.CylinderTurned = nil

			self:StopSound("cylinder")
			self:StopSound("squeak")
		end
	end

	if (self.exceedMax) then
		if (self.LockAngle <= cfg.UnlockMaxAngle) then
			self.Success = true
			netstream.Start("lpSuccess")
			self:PlaySound("lockpicking/unlock.wav", 50, 1)
		else
			if (not self.CylinderStopped) then
				self.CylinderStopped = true

				self:PlaySound("lockpicking/picktension.wav", 50, 1, "tension")
				self:PlaySound("lockpicking/cylinderstop_"..math.random(4)..".wav", 50, 1)
			end
		end
		
	else
		self.CylinderStopped = false
		self:StopSound("tension")
	end
	
	-- Draw the bobbypin
	if (not self.RotatingLock and not self.Success and not self.ChangingPin) then
		local mX, mY = gui.MouseX(), gui.MouseY()
		self.PinAngle = math.deg(math.atan2(mY - sH() / 2, mX - sW() / 2))
			
		if (self.OldPinRotation ~= self.PinAngle) then
			self.MaxLockAngle = nil
			self.LastPickMove = CurTime()

			if (CurTime() > self.NextPickSound) then
				self.NextPickSound = CurTime() + math.Rand(0.5, 1)
				self:PlaySound("lockpicking/pickmovement_"..math.random(13)..".wav", 50, 1)
			end
				
			self.OldPinRotation = self.PinAngle
		end
	end
end


PLUGIN.InterfaceClass = Class



----------------
--[[ HOOKS ]]---
----------------
-- Start lock rotation / Close the interface
function PLUGIN:PlayerButtonDown(ply, btn)
	local cfg = self.CONFIG
    local i = self.Interface

	if ( not i ) then return end

    local panel = i.Panel

	if (btn == KEY_D) then
		if (i.LockAngle ~= 0) then return end
		if (i.Success) then return end
		if (i.ChangingPin) then return end
		if (i.LastRotating and CurTime() - i.LastRotating < cfg.SpamTime + 0.08) then return end

		netstream.Start("lpRotat", true, i.PinAngle)

		i.LastRotating = CurTime()
		i.RotatingLock = true
	elseif (btn == KEY_E) then
		i:Stop(true)
	end
end

-- Stop lock rotation
function PLUGIN:PlayerButtonUp(ply, btn)
	local i = self.Interface
    if ( not i ) then return end
    
	if (btn == KEY_D) then
		if (not i.RotatingLock) then return end
		if (i.Success) then return end
		if (i.ChangingPin) then return end

		netstream.Start("lpRotat", false)

		i.RotatingLock = false
	end
end


local allowCommand
function PLUGIN:StartCommand(ply, cmd)
	if ( not allowCommand and self.Interface and ply == LocalPlayer() ) then
        cmd:SetButtons(0)
    end

    allowCommand = false
end

function PLUGIN:Move(ply, mvd)
    if ( self.Interface and ply == LocalPlayer() ) then
        return true
    end
end

function PLUGIN:PlayerSwitchWeapon(ply, oldWep, newWep)
    local allowCommand = ( newWep:GetClass() == "ix_hands" )

	if ( not allowCommand and self.Interface and ply == LocalPlayer() ) then
        return true
    end
end



--------------------
--[[ NETWORKING ]]--
--------------------
netstream.Hook("lpStarting", function(state, enterMoment)
    local i = PLUGIN:CreateInterface()
    i:StartingAction(state, enterMoment)
end)


netstream.Hook("lpChange", function(time)
    local i = PLUGIN.Interface
    if ( not i ) then return end

    i:ChangePinAction(time)
end)


netstream.Hook("lpStart", function(itemId)
    local i = PLUGIN.Interface
	if ( not i ) then return end
	local item = ix.item.instances[itemId]
	if ( not item ) then return end

	i.Item = item
    i:Start()
end)

netstream.Hook("lpStop", function(reason)
	local i = PLUGIN.Interface
    if ( not i ) then return end

    i:Stop(false, reason)
end)


netstream.Hook("lpMax", function(pickAng, ang)
	local i = PLUGIN.Interface
    if ( not i ) then return end

	if (tostring(pickAng) == tostring(i.PinAngle)) then
		i.MaxLockAngle = ang
	end
end)


netstream.Hook("lpFail", function()
	local i = PLUGIN.Interface
	if ( not i ) then return end
	
	i:PlaySound("lockpicking/pickbreak_"..math.random(3)..".wav", 50, 1)
	i:Stop()
end)



------------------------------------------------------
--[[ FO UI library imported from FalloutRP schema ]]--
------------------------------------------------------
fo = fo or {}
fo.ui = fo.ui or {}


-- Get a number multiplied by screen wide
function sW(num)
	local scrW = ScrW()
	if ( num ) then
		scrW = scrW * num
	end
	
	return scrW
end

-- Get a number multiplied by screen height
function sH(num)
	local scrH = ScrH()
	if ( num ) then
		scrH = scrH * num
	end

	return scrH
end

-- Original Fallout colors
forp_amber = Color(255, 182, 66, 255)
forp_white = Color(192, 255, 255 ,255)
forp_green = Color(26, 255, 128, 255)
forp_blue = Color(46, 207, 255, 255)
forp_red = Color(249, 65, 41)

forp_amber_grey = Color(78, 57, 25, 255)
forp_white_grey = Color(92, 114, 107, 255)
forp_green_grey = Color(23, 117, 60, 255)
forp_blue_grey = Color(31, 96, 112, 255)

-- Available ATH colors
local hudColors = {
	amber = forp_amber,
	white = forp_white,
	green = forp_green,
	blue = forp_blue
}

local hudGreyColors = {
	amber = forp_amber_grey,
	white = forp_white_grey,
	green = forp_green_grey,
	blue = forp_blue_grey
}

-- ATH color ConVar
FORP_CVAR_COLOUR = CreateClientConVar("forp_colour", "amber", true, false, "Changes the hud colour, can be amber, white, green or blue.")

-- Get ATH greyed color from ConVar
function fo.ui.GetHUDColor()
	return hudColors[FORP_CVAR_COLOUR:GetString()] or forp_amber
end

-- Get ATH greyed color from ConVar
function fo.ui.GetHUDGreyColor()
	return hudGreyColors[FORP_CVAR_COLOUR:GetString()] or forp_amber_grey
end


-- Show cursor and disable gui.EnableScreenClicker function
fo.ui.oldEnableScreenClicker = fo.ui.oldEnableScreenClicker or gui.EnableScreenClicker
function fo.ui.LockCursor()
	gui.EnableScreenClicker(true)
	gui.EnableScreenClicker = function() end
end


-- Hide cursor and enable gui.EnableScreenClicker
function fo.ui.UnlockCursor()
	gui.EnableScreenClicker = fo.ui.oldEnableScreenClicker
	gui.EnableScreenClicker(false)
end


-- Draw all text lines of a string table
function fo.ui.DrawWrappedText(lines, font, color, x, y, gap)
	local fontHeight = draw.GetFontHeight( font )
	surface.SetFont(font)
	surface.SetTextColor(color)

	for _, line in pairs(lines) do
		surface.SetTextPos(x, y)
		surface.DrawText(line)
		y = y + fontHeight + (gap or 0)
	end
end


-- Draw a rotated texture from his center
function fo.ui.DrawTexturedRectRotatedPoint(x, y, w, h, rot, x0, y0)
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s

	surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end


-- Draw original Fallout blur
function fo.ui.DrawFalloutBlur(x, y, w, h, thickness)
	local col = Color(0,0,0)
	local thickness = thickness or 16

	for i = 0, thickness do
		local xChange, yChange, wChange, hChange = x + (i * 2), y + (i * 2), w - (i * 4), h - (i * 4)
		draw.RoundedBox(8, xChange, yChange, wChange, hChange, Color(col.r, col.g, col.b, 2 + (i * 4)))

		if i == thickness then
			return xChange, yChange, wChange, hChange -- We return the size of the inner frame so we can use it in panels to make the UI, this might not be the best way.
		end
	end
end

function fo.ui.DrawFalloutBlurText(x, y, text, xAlign, yAlign)
	local col = fo.ui.GetHUDColor()
	local bgCol = col
	bgCol.a = 180

	draw.SimpleText(text, "Monofonto24_blur", x, y, col, xAlign or nil, yAlign or nil)
    draw.SimpleText(text, "Monofonto24", x, y, bgCol, xAlign or nil, yAlign or nil)
end

PLUGIN.BlurPanel = PLUGIN.BlurPanel or vgui.Create("DPanel")
PLUGIN.BlurPanel:SetSize(sW(), sH())
PLUGIN.BlurPanel:Hide()
local blurPanel = PLUGIN.BlurPanel

PLUGIN.BlurPanels = PLUGIN.BlurPanels or {}

function fo.ui.BlurBackground(self, state)
    if ( state ) then
        PLUGIN.BlurPanels[self] = true
    else
        PLUGIN.BlurPanels[self] = nil
    end
end

hook.Add("HUDPaintBackground", "forp_blur_panels", function()
    for p, _ in pairs (PLUGIN.BlurPanels) do
        if ( IsValid(p) ) then
            Derma_DrawBackgroundBlur(blurPanel)
        else
            PLUGIN.BlurPanels[p] = nil
        end
    end
end)


PLUGIN.HideHUDPanels = PLUGIN.HideHUDPanels or {}

function fo.ui.HideHUD(self, state)
    if ( state ) then
        PLUGIN.HideHUDPanels[self] = true
    else
        PLUGIN.HideHUDPanels[self] = nil
    end
end

hook.Add("FalloutHUDShouldDraw", "forp_Interface", function()
    for p, _ in pairs (PLUGIN.HideHUDPanels) do
        if ( IsValid(p) ) then
            return false
        else
            PLUGIN.HideHUDPanels[p] = nil
        end
    end
end)

hook.Add("OnSpawnMenuOpen", "lpRestrictSpawnMenu", function()
    for p, _ in pairs (PLUGIN.HideHUDPanels) do
        if ( IsValid(p) ) then
            return false
        else
            PLUGIN.HideHUDPanels[p] = nil
        end
    end
end)

hook.Add("CanDrawDoorInfo", "lpHideDoorInfo", function()
    for p, _ in pairs (PLUGIN.HideHUDPanels) do
        if ( IsValid(p) ) then
            return false
        else
            PLUGIN.HideHUDPanels[p] = nil
        end
    end
end)

hook.Add("CanDrawEntInt", "lpHideDoorInfo", function()
    for p, _ in pairs (PLUGIN.HideHUDPanels) do
        if ( IsValid(p) ) then
            return false
        else
            PLUGIN.HideHUDPanels[p] = nil
        end
    end
end)