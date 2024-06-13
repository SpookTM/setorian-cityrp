local HUDMAP = {}
HUDMAP.Map = "rp_truenorth_v1a"
HUDMAP.Material = "paris/maps/rp_truenorth_v1a/rp_truenorth_v1a"
HUDMAP.Translate = Vector(20,19.16,0) // Never do Z
HUDMAP.ScaleX = 0.9842
HUDMAP.ScaleY = 0.9831

HUDMAP.UseZones = true
HUDMAP.Zones = {}
HUDMAP.Zones["MAIN"] = {
    Material = "paris/maps/rp_truenorth_v1a/rp_truenorth_v1a",
    Translate = Vector(20,19.16,0), // Never do Z
    ScaleX = 0.9842,
    ScaleY = 0.9831,
    Zoom = 1,
}

HUDMAP.Zones["UPPER"] = {
    Material = "paris/maps/rp_truenorth_v1a/rp_truenorth_v1a_upper",
    Translate = Vector(20,19.16,0), // Never do Z
    ScaleX = 0.9842,
    ScaleY = 0.9831,
    InsideZones = {
        {Vector(15830,-15836,2300),
        Vector(-15851,15810,14970)},
    },
    Zoom = 1,
}

paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap


MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")