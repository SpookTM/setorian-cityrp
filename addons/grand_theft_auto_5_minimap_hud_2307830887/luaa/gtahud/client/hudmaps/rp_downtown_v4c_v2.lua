local HUDMAP = {}
HUDMAP.Map = "rp_downtown_v4c_v2"
HUDMAP.Material = "paris/maps/rp_downtown_v4c_v2"
HUDMAP.ScaleX = 2.2705
HUDMAP.ScaleY = 1.8925
HUDMAP.Translate = Vector(3608,-2089,0)
HUDMAP.Zoom = 0.5

paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap

MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")