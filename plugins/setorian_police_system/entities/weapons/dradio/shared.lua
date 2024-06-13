
SWEP.PrintName = "Radio"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Author = "Dan"
SWEP.Purpose = "Voice Communication"
SWEP.Instructions = ""
SWEP.Category = "Dan's Addons"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/danradio/c_radio.mdl"
SWEP.WorldModel = "models/danradio/w_radio.mdl"
 
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IsAlwaysLowered = true
SWEP.FireWhenLowered = true

SWEP.LowerAngles = Angle(0, 0, 0)
SWEP.LowerAngles2 = Angle(0, 0, 0)


function SWEP:Deploy()

	self:SetHoldType("slam")

end


--CONFIGURATION - ANY CHANGES REQUIRE RESTART

local function CreateConfig()
	RADIO = {}
	RADIO.RADIOCHANNELS = {

		{name = "POLICE", frequency = 133.33, teams = {
			FACTION_POLICE,
		}},
		{name = "EMS", frequency = 122.22, teams = {
			FACTION_EMS,
		}},
		/*
		{name = YOUR TITLE, frequency = SECURE FREQUENCY VALUE, TEAMS = {YOUR_TEAM, YOUR_TEAMA, YOUR_TEAMB,}}, <--- Needs comma after every entry.
		{name = YOUR TITLE, frequency = SECURE FREQUENCY VALUE, TEAMS = {YOUR_TEAM, YOUR_TEAMA, YOUR_TEAMB,}}, <-- Do not make a ticket about this.
		FOR CUSTOM GAMEMODES REPLACE TEAM_WHATEVER with either a team NUMBER or a team ENUMERATOR.
		*/

	}
	
	RADIO.WhileHolding = false -- True: Radio must be in hand to speak False: Radio just has to be on the person. FIXED NOW
	RADIO.FailMessage = "Message delivery failed. Your radio is off or is using an invalid frequency."
	RADIO.ChatCommand = "/r"
	RADIO.SpawnActive = false
	RADIO.AllowWeaponsInVehicles = true -- Enabling this will allow users to use SWEPS while in vehicles. This does not limit weapon usage to just the radio.
end

CreateConfig()

if DCONFIG then 
	hook.Add("DConfigDataLoaded", "CreateRadioChannels", function() //ANY CHANGES REQUIRE  A RESTART
		CreateConfig()
	end) 
else 
	hook.Add("Initialize", "CreateRadioChannels", function()
		CreateConfig()
	end)
end 


--IF RECEIVE THIS ERROR: [ERROR] addons/dradio/lua/weapons/dradio/cl_init.lua:X: attempt to index upvalue 'staticSound' (a nil value)
--IT'S BECAUSE YOU MADE A CHANGE AND DID NOT RESTART YOUR SERVER.
--Thank u