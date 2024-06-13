local HUDMAP = {}
HUDMAP.Map = "gm_construct"
HUDMAP.Material = "paris/maps/gm_construct/gm_construct_main"
HUDMAP.ScaleX = 0.3523
HUDMAP.ScaleY = 0.3584
HUDMAP.Translate = Vector(-1699.3,1535,0)

HUDMAP.UseZones = true
HUDMAP.Zones = {}
HUDMAP.Zones["MAIN"] = {
    Material = "paris/maps/gm_construct/gm_construct_main",
    ScaleX = 0.3523,
    ScaleY = 0.3584,
    Translate = Vector(-1699.3,1535,0),
    Zoom = 0.7,
}
HUDMAP.Zones["LOWER"] = {
    Material = "paris/maps/gm_construct/gm_construct_below",
    ScaleX = 0.3523,
    ScaleY = 0.3584,
    Translate = Vector(-1699.3,1535,0),
    Zoom = 0.7,
    InsideZones = {
        {Vector(-5640,-3045,178),
        Vector(-3248,-1056,-180)},
        {Vector(-1200,96,-516),
        Vector(-3288,-4568,-196)},
        {Vector(-3248,-1866,-144),
        Vector(-3120,-1121,-32)},
        {Vector(-3120,-1520,-32),
        Vector(-2879,-1424,-144)},
        {Vector(-808,-4568,152),
        Vector(-1256,-2632,-260)},
    },
}



paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap

MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")