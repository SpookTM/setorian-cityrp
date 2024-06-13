-- local screenw = ScrW()
-- local screenh = ScrH()
-- local Widescreen = (screenw / screenh) > (4 / 3)
-- local sizex = screenw * (Widescreen and 1 or 1.32)
-- local sizey = screenh
-- local xpos = sizex * 0.02
-- local ypos = sizey * 0.8
-- local x = xpos * (Widescreen and 43.5 or 32)
-- local y = ypos * 1.015
-- local radius = 0.085 * sizex
local startang = 105

local lights_on = Material( "simfphys/hud/low_beam_on" )
local lights_on2 = Material( "simfphys/hud/high_beam_on" )
local lights_off = Material( "simfphys/hud/low_beam_off" )
local fog_on = Material( "simfphys/hud/fog_light_on" )
local fog_off = Material( "simfphys/hud/fog_light_off" )
local cruise_on = Material( "simfphys/hud/cc_on" )
local cruise_off = Material( "simfphys/hud/cc_off" )
local hbrake_on = Material( "simfphys/hud/handbrake_on" )
local hbrake_off = Material( "simfphys/hud/handbrake_off" )
local HUD_1 = Material( "simfphys/hud/hud" )
local HUD_2 = Material( "simfphys/hud/hud_center" )
local HUD_3 = Material( "simfphys/hud/hud_center_red" )
local HUD_5 = file.Exists( "materials/simfphys/hud/hud_5.vmt", "GAME") and Material( "simfphys/hud/hud_5" ) or false
local ForceSimpleHud = not file.Exists( "materials/simfphys/hud/hud.vmt", "GAME" ) -- lets check if the background material exists, if not we will force the old hud to prevent fps drop
local smHider = 0

// Setorian
local speedometer = Material( "setorian_speedometer1.png", "noclamp smooth" )
local fuelmeter = Material( "fuel.png", "noclamp smooth" )
local needle = Material( "needle.png", "noclamp smooth" )

local seatbeltIcon = Material( "seatbelt.png" )
local engineIcon = Material( "engine.png" )
//

local ShowHud = false
local ShowHud_ms = false
local AltHud = false
local AltHudarcs = false
local Hudmph = false
local Hudmpg = false
local Hudreal = false
local isMouseSteer = false
local hasCounterSteerEnabled = false
local slushbox = false
local hudoffset_x = 0
local hudoffset_y = 0

local turnmenu = KEY_COMMA

local ms_sensitivity = 1
local ms_fade = 1
local ms_deadzone = 1.5
local ms_exponent = 2
local ms_key_freelook = KEY_Y

local ms_pos_x = 0
local sm_throttle = 0

local function DrawCircle( X, Y, radius )
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360 - segmentdist, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

local function LoadSpeedFont()

	surface.CreateFont( "speedometer_font", {
		font = "Verdana",
		extended = false,
		size = (ScrH() >= 900 and (ScrH() >= 1080 and 20 or 18) or 12) * 1.3,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = true,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

end


hook.Add( "OnScreenSizeChanged", "speedmeter_loadfonts", function( oldWidth, oldHeight )
	LoadSpeedFont()
end)

LoadSpeedFont()

local function drawSetorianHUD(vehicle)

	-- if not ShowHud then return end
	
	-- if vehicle:GetNWBool( "simfphys_NoHud", false ) then return end

	local screenw = ScrW()
	local screenh = ScrH()
	local Widescreen = (screenw / screenh) > (4 / 3)
	local sizex = screenw * (Widescreen and 1 or 1.32)
	local sizey = screenh
	local xpos = sizex * 0.02
	local ypos = sizey * 0.8
	local x = xpos * (Widescreen and 43.5 or 32)
	local y = ypos * 1.015
	local radius = 0.085 * sizex

	local o_x = hudoffset_x * screenw
	local o_y = hudoffset_y * screenh

	-- o_x = o_x - smHider * 300 - (SeatCount > 0 and 45 or 0)

	-- local speed = vehicle:GetVelocity():Length()
	-- local mph = math.Round(speed * 0.0568182,0)
	-- local kmh = math.Round(speed * 0.09144,0)
	-- local wiremph = math.Round(speed * 0.0568182 * 0.75,0)
	-- local wirekmh = math.Round(speed * 0.09144 * 0.75,0)
	local Hudmph = VC_getSettings().HUD_MPh
	-- print(kmh, vehicle:VC_getSpeedKmH())

	local kmh = math.Round(vehicle:VC_getSpeedKmH(), 0)
	local mph = math.Round(kmh * 0.6213, 0)

	local printspeed = ( Hudmph and mph) or kmh

	local CarStates = vehicle:VC_getStates()


	local LightsOn = CarStates.LowBeamsOn--vehicle:GetLightsEnabled()
	local LampsOn = CarStates.HighBeamsOn--vehicle:GetLampsEnabled()
	local FogLightsOn = CarStates.FogLightsOn--CarStates.HighBeamsOn--vehicle:GetFogLightsEnabled()
	local HandBrakeOn = LocalPlayer():KeyDown( IN_JUMP )--vehicle:GetHandBrakeEnabled()
	local cruisecontrol = vehicle:VC_getCruise()
	local SeatBealtOn = LocalPlayer():GetNWBool( "SeatBeltOn", false )
	local EngineOn = true--(vehicle:GetFlyWheelRPM() != 0)

	surface.SetDrawColor( 255,255,255,255 )
    surface.SetMaterial( speedometer )
	surface.DrawTexturedRect( x - radius*1.28 + o_x, y - radius * 0.92 + o_y, radius * 2.8, radius * 2.8 )

	surface.SetDrawColor( 255,255,255,255 )
    surface.SetMaterial( fuelmeter )
	surface.DrawTexturedRect( x - radius*3.3 + o_x, y - radius * 1.5 + o_y, radius * 2.8, radius * 2.8 )

	local print_text = Hudmph and "MPH" or "KM/H"

	draw.SimpleText( printspeed .. " " ..print_text, "speedometer_font", x + radius * 0.15 + o_x, y + radius * 0.3 + o_y, Color(255,255,255,50), 1, 1 )

	
	// ICONS

	surface.SetDrawColor( 255, 255, 255, 255 )
		
	local mat = LightsOn and (LampsOn and lights_on2 or lights_on) or lights_off
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( x - radius * 0.4 + o_x, y + radius * 1 + o_y, sizex * 0.014, sizex * 0.014 )

	local mat = FogLightsOn and fog_on or fog_off
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( x - radius * 0.2 + o_x, y + radius * 0.96 + o_y, sizex * 0.02, sizex * 0.018 )

	local mat = HandBrakeOn and hbrake_on or hbrake_off
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( x + radius * 0.1 + o_x, y + radius * 0.96 + o_y, sizex * 0.02, sizex * 0.018 )

	local mat = cruisecontrol and cruise_on or cruise_off
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( x + radius * 0.37 + o_x, y + radius * 0.65 + o_y, sizex * 0.02, sizex * 0.02 )
		

	local matColor = SeatBealtOn and Color(0,204,0) or Color(120,120,120)
	surface.SetDrawColor( matColor )
	surface.SetMaterial( seatbeltIcon )
	surface.DrawTexturedRect( x + radius * 0.37 + o_x, y + radius * 0.96 + o_y, sizex * 0.02, sizex * 0.018 )

	local matColor = EngineOn and Color(0,204,0) or Color(120,120,120)
	surface.SetDrawColor( matColor )
	surface.SetMaterial( engineIcon )
	surface.DrawTexturedRect( x - radius * 0.3 + o_x, y + radius * 0.68 + o_y, sizex * 0.02, sizex * 0.018 )


	// Speed Needle
	local ang = math.min(printspeed * 1.23, 223)

	surface.SetDrawColor( 255, 255, 255, 255 )

    surface.SetMaterial( needle )
	surface.DrawTexturedRectRotated( x + radius*0.1 + o_x, y + radius*0.8 + o_y, radius * 1.7, radius * 1.7,-28 - ang )
	-- surface.DrawTexturedRectRotated( x + radius*0.1 + o_x, y + radius*1.15 + o_y, radius * 1.7, radius * 1.7,-50 - printspeed )--- (1.5*printspeed) ) 

	// Fuel Needle
	local fuel = vehicle:VC_fuelGet(true)

	local fuelAng = (80 * fuel) / 100--math.Remap( fuel, 0, 100, 0, 80 )

    surface.SetMaterial( needle )
	surface.DrawTexturedRectRotated( x - radius*1.95 + o_x, y + radius*1.2 + o_y, radius * 1.1, radius * 1.1,-99 - fuelAng )
	

end

hook.Add( "HUDPaint", "setorian_HUD", function()
	local ply = LocalPlayer()
	
	if not IsValid( ply ) or not ply:Alive() then  return end

	local vehicle = ply:GetVehicle()
	
	if (!IsValid(vehicle)) then return end
	if (vehicle:GetClass() == "prop_vehicle_prisoner_pod") then return end
	
	drawSetorianHUD(vehicle)
	

end)

local VCMODHUD = {
	["VCMod_Health"] = true,
	["VCMod_Fuel"] = true,
	["VCMod_Icons"] = true,
}

hook.Add("HUDShouldDraw", "VC_HUD_Disable_Name", function(name)
	if VCMODHUD[name] then return false end
end)

-- draw.arc function by bobbleheadbob
-- https://dl.dropboxusercontent.com/u/104427432/Scripts/drawarc.lua
-- https://facepunch.com/showthread.php?t=1438016&p=46536353&viewfull=1#post46536353

function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise)
	local triarc = {}
	local deg2rad = math.pi / 180
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	if bClockwise and (startang < endang) then
		local temp = startang
		startang = endang
		endang = temp
		temp = nil
	elseif (startang > endang) then 
		local temp = startang
		startang = endang
		endang = temp
		temp = nil
	end
	
	
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	if bClockwise then
		step = math.abs(roughness) * -1
	end
	
	
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = deg2rad * deg
		table.insert(inner, {
			x=cx+(math.cos(rad)*r),
			y=cy+(math.sin(rad)*r)
		})
	end
	
	
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = deg2rad * deg
		table.insert(outer, {
			x=cx+(math.cos(rad)*radius),
			y=cy+(math.sin(rad)*radius)
		})
	end
	
	
	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
	
		table.insert(triarc, {p1,p2,p3})
	end
	
	-- Return a table of triangles to draw.
	return triarc
	
end

function surface.DrawArc(arc)
	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color,bClockwise)
	surface.SetDrawColor(color)
	surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise))
end

