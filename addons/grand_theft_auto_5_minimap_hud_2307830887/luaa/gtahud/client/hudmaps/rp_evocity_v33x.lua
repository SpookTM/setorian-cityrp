local HUDMAP = {}
HUDMAP.Map = "rp_evocity_v33x"
HUDMAP.Material = "paris/maps/rp_evocity_v33x/rp_evocity_v33x"
HUDMAP.Translate = Vector(-463.164,328.5042,0) // Never do Z
HUDMAP.ScaleX = 1.1303
HUDMAP.ScaleY = 1.0170
HUDMAP.Zoom = 0.3

HUDMAP.UseZones = true
HUDMAP.Zones = {}
HUDMAP.Zones["MAIN"] = {
    Material = "paris/maps/rp_evocity_v33x/rp_evocity_v33x",
    Translate = Vector(-463.164,328.5042,0),
    ScaleX = 1.1303,
    ScaleY = 1.0170,
    Zoom = 0.9,
}

HUDMAP.Zones["POLICE"] = {
    Material = "paris/maps/rp_evocity_v33x/rp_evocity_v33x_police",
    Translate = Vector(-463.164,328.5042,0),
    ScaleX = 1.1303,
    ScaleY = 1.0170,
    InsideZones = {
        {Vector(-8112,-10649,-32),
        Vector(-6214,-8600,-459)},
    },
    Zoom = 0.3
}

paris = paris or {}                     // Register Prep
if !paris.HUDMaps then
    paris.HUDMaps = {}
end
paris.HUDMaps[HUDMAP.Map] = HUDMAP      // Registers the hudmap


MsgC( Color(200,110,255), "Loading HUD Map ", Color(255,255,255), "> " .. HUDMAP.Map .. " \n")