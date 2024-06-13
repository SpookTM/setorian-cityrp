local HUDMAP = {}
HUDMAP.Map = "rp_rockford_v2b"
HUDMAP.Material = "paris/maps/rp_rockford_v2b"
HUDMAP.ScaleX = 1.0172
HUDMAP.ScaleY = 1.0120
HUDMAP.Translate = Vector(30.0854,-30.4968,0)
HUDMAP.Zoom = 0.5

paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap


MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")