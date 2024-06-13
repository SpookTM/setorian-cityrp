local HUDMAP = {}
HUDMAP.Map = "gm_flatgrass"
HUDMAP.Material = "paris/maps/gm_flatgrass/gm_flatgrass"
HUDMAP.ScaleX = 0.9643
HUDMAP.ScaleY = 0.9600
HUDMAP.Translate = Vector(0,-26,0) // Never do Z


HUDMAP.UseZones = true
HUDMAP.Zones = {}
HUDMAP.Zones["MAIN"] = {
    Material = "paris/maps/gm_flatgrass/gm_flatgrass",
    ScaleX = 0.9643,
    ScaleY = 0.9600,
    Translate = Vector(0,-26,0), // Never do Z
}
HUDMAP.Zones["UNDERPASS"] = {
    Material = "paris/maps/gm_flatgrass/gm_flatgrass_underpass",
    ScaleX = 0.9643,
    ScaleY = 0.9600,
    Translate = Vector(0,-26,0), // Never do Z
    InsideZones = {
        {Vector(-418,-992,-12420),
        Vector(421,1026,-12850)},
    },
    Zoom = 0.5
}

HUDMAP.Zones["SECRET"] = {
    Material = "paris/maps/gm_flatgrass/gm_flatgrass_secret",
    ScaleX = 0.9643,
    ScaleY = 0.9600,
    Translate = Vector(0,-26,0), // Never do Z
    InsideZones = {
        {Vector(-417,-448,-12560),
        Vector(-992,448,-12800)},
    },
    Zoom = 0.2
}


paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap


MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")