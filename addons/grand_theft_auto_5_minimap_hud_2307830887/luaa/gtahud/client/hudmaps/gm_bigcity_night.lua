local HUDMAP = {}
HUDMAP.Map = "gm_bigcity_night"
HUDMAP.Material = "paris/maps/gm_bigcity_night"
HUDMAP.ScaleX = 0.9942
HUDMAP.ScaleY = 0.9959
HUDMAP.Translate = Vector(0,0,0) // Never do Z
HUDMAP.Zoom = 0.9

paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap


print("Loading HudMap .." .. HUDMAP.Map)