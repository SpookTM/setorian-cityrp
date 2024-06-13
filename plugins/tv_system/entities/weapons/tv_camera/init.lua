include('shared.lua')
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

resource.AddFile( "models/weapons/w_camera.mdl" )
resource.AddFile( "models/weapons/w_camera.dx90.vtx" )
resource.AddFile( "models/weapons/w_camera.dx80.vtx" )
resource.AddFile( "models/weapons/w_camera.sw.vtx" )
resource.AddFile( "models/weapons/w_camera.vvd" )

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
	self.Owner:SetCanZoom( false )
end

function SWEP:DoRotateThink()
	return true
end