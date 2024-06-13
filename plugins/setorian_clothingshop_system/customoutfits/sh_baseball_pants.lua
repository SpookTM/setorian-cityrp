local PLUGIN = PLUGIN


for variantI = 1, 11 do

	local pacdata = {	
	[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "35230206baf9d6a7c1973e1d52ac927507373a300ecba3ae9f1d83c09bd3cebc"..variantI,
				["NoLighting"] = false,
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Materials"] = "",
				["Name"] = "",
				["LevelOfDetail"] = 0,
				["NoTextureFiltering"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TargetEntityUID"] = "",
				["Alpha"] = 1,
				["Material"] = "",
				["Invert"] = false,
				["ForceObjUrl"] = false,
				["Bone"] = "chest",
				["Angles"] = Angle(0, 0, 0),
				["AngleOffset"] = Angle(0, 0, 0),
				["BoneMerge"] = true,
				["Color"] = Vector(1, 1, 1),
				["Position"] = Vector(0, 0, 0),
				["ClassName"] = "model2",
				["Brightness"] = 1,
				["Hide"] = false,
				["NoCulling"] = false,
				["Scale"] = Vector(1, 1, 1),
				["LegacyTransform"] = false,
				["EditorExpand"] = false,
				["Size"] = 1,
				["ModelModifiers"] = "pants_01="..variantI..";",
				["Translucent"] = false,
				["BlendMode"] = "",
				["EyeTargetUID"] = "",
				["Model"] = "models/smalls_civilians/pack2/male/baseballtee/pants.mdl",
			},
		},
		[2] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "522dde2054cbb4e53d0d304b3dbd3f47f807f5d4293f2dda80511f6e9f82b24d"..variantI,
				["NoLighting"] = false,
				["BlendMode"] = "",
				["AimPartUID"] = "",
				["Materials"] = "",
				["Name"] = "",
				["LevelOfDetail"] = 0,
				["NoTextureFiltering"] = false,
				["InverseKinematics"] = true,
				["PositionOffset"] = Vector(0, 0, 0),
				["NoCulling"] = false,
				["Brightness"] = 1,
				["DrawOrder"] = 0,
				["TargetEntityUID"] = "",
				["DrawShadow"] = true,
				["Alpha"] = 1,
				["Material"] = "",
				["CrouchingHullHeight"] = 36,
				["Model"] = "",
				["ModelModifiers"] = "leg=1;",
				["NoDraw"] = false,
				["IgnoreZ"] = false,
				["HullWidth"] = 32,
				["Translucent"] = false,
				["Position"] = Vector(0, 0, 0),
				["LegacyTransform"] = false,
				["ClassName"] = "entity2",
				["Hide"] = false,
				["IsDisturbing"] = false,
				["Scale"] = Vector(1, 1, 1),
				["Color"] = Vector(1, 1, 1),
				["EditorExpand"] = false,
				["Size"] = 1,
				["Invert"] = false,
				["Angles"] = Angle(0, 0, 0),
				["AngleOffset"] = Angle(0, 0, 0),
				["EyeTargetUID"] = "",
				["StandingHullHeight"] = 72,
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "f49cf1956f553b6530cc79038d1b256bfb3a4b91de67d2e99cc5e67818a8a7be"..variantI,
		["Hide"] = false,
		["TargetEntityUID"] = "",
		["EditorExpand"] = true,
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "my outfit",
		["Duplicate"] = false,
		["ClassName"] = "group",
	},
},

}

	PLUGIN:AddClothingPac("baseballtee_pants_"..variantI, pacdata)

end
