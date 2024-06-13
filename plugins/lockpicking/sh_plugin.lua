PLUGIN.name = "Lockpicking"
PLUGIN.author = "github.com/John1344 | Ported by JohnyReaper"
PLUGIN.desc = "Allows to pick locks with bobby pins"


PLUGIN.CONFIG = {
    UnlockSize = 4,
    WeakSize = 40,
    UnlockMaxAngle = -90,
    HardMaxAngle = -30,
    TurningSpeed = 90,
    ReleasingSpeed = 200,
    SpamTime = 0.1,
	MaxLookDistance = 100,
	FadeTime = 4
}


-- Lockpick stop messages
PLUGIN.STOP_AFK = 1
PLUGIN.STOP_FAR = 2

PLUGIN.Messages = {
	"lpAfk",
	"lpTooFar"
}

function PLUGIN:GetEntityLookedAt(player, maxDistance)
    local data = {}
    data.filter = player
    data.start = player:GetShootPos()
    data.endpos = data.start + player:GetAimVector()*maxDistance

    return util.TraceLine(data).Entity
end

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

ix.util.Include("ui/cl_interface.lua")
ix.util.Include("ui/cl_lp_interface.lua")
ix.util.Include("ui/basic/cl_button.lua")
ix.util.Include("ui/basic/cl_label.lua")