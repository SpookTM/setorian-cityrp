local HUDMAP = {}
HUDMAP.Map = "rp_downtown_tits_v2"
HUDMAP.Material = "paris/maps/rp_downtown_tits_v2/rp_downtown_tits_v2"
HUDMAP.Translate = Vector(358,-210,0) // Never do Z
HUDMAP.Zoom = 1
HUDMAP.ScaleX = 0.8423
HUDMAP.ScaleY = 1.0809
HUDMAP.Translate = Vector(3615,-2099,0)

HUDMAP.UseZones = true
HUDMAP.Zones = {}
HUDMAP.Zones["MAIN"] = {
    Material = "paris/maps/rp_downtown_tits_v2/rp_downtown_tits_v2",
    ScaleX = 0.8423,
    ScaleY = 1.0809,
    Translate = Vector(3615,-2099,0),
    Zoom = 0.7
}

HUDMAP.Zones["UNDERGROUND"] = {
    Material = "paris/maps/rp_downtown_tits_v2/rp_downtown_tits_v2_underground",
    ScaleX = 0.8423,
    ScaleY = 1.0809,
    Translate = Vector(3615,-2099,0),
    InsideZones = {
        {Vector(-5002, -2736, -300),
        Vector(4518, 7378, -1500)},
        {Vector(560,-8001,-200),
        Vector(1073,-5280,-380)},
        {Vector(1024,-7379,-210),
        Vector(3818,-7308,-315)},
    },
    Zoom = 0.3
}

paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap

MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")