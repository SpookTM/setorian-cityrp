local HUDMAP = {}
HUDMAP.Map = "rp_nycity"
HUDMAP.Material = "paris/maps/rp_nycity"
HUDMAP.ScaleX = 0.9568
HUDMAP.ScaleY = 1
HUDMAP.Translate = Vector(-273.8667,81.1907,3.9021)
HUDMAP.Zoom = 0.4

paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap


MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")