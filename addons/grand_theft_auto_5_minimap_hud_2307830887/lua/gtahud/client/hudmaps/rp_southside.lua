local HUDMAP = {}
HUDMAP.Map = "rp_southside"
HUDMAP.Material = "paris/maps/rp_southside"
HUDMAP.ScaleX = 1.0325
HUDMAP.ScaleY = 1.0431
HUDMAP.Translate = Vector(-30.8064,-83.0662,0)
HUDMAP.Zoom = 0.9

paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap


MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")