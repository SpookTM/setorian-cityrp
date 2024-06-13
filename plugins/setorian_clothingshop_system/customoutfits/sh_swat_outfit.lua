local PLUGIN = PLUGIN

local pacdata = {	
	[1] = {
	["children"] = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["FollowAnglesOnly"] = false,
						["DrawOrder"] = 0,
						["InvertHideMesh"] = false,
						["TargetEntityUID"] = "",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "head",
						["ScaleChildren"] = false,
						["UniqueID"] = "cb8aeed013e1629a6d53fa10b6a44773cf72f14c2e5be6e5e512b5aeff0f5ae7",
						["MoveChildrenToOrigin"] = false,
						["Position"] = Vector(0, 0, 0),
						["AimPartUID"] = "",
						["Angles"] = Angle(0, 0, 0),
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1, 1),
						["EditorExpand"] = true,
						["ClassName"] = "bone3",
						["Size"] = 2.4,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["EyeAngles"] = false,
						["HideMesh"] = false,
					},
				},
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "3cf3cda3487a183553550e7a952f059e128eaa7fce7a8335bf56f9a64df1a198",
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
				["Position"] = Vector(-9.1552734375e-05, 3.0517578125e-05, -52.5693359375),
				["ClassName"] = "model2",
				["Brightness"] = 1,
				["Hide"] = false,
				["NoCulling"] = false,
				["Scale"] = Vector(1, 1, 1),
				["LegacyTransform"] = false,
				["EditorExpand"] = true,
				["Size"] = 1,
				["ModelModifiers"] = "",
				["Translucent"] = false,
				["BlendMode"] = "",
				["EyeTargetUID"] = "",
				["Model"] = "models/player/kerry/swat_ls.mdl",
			},
		},
		[2] = {
			["children"] = {
			},
			["self"] = {
				["FollowAnglesOnly"] = false,
				["DrawOrder"] = 0,
				["InvertHideMesh"] = false,
				["TargetEntityUID"] = "",
				["AimPartName"] = "",
				["FollowPartUID"] = "",
				["Bone"] = "head",
				["ScaleChildren"] = false,
				["UniqueID"] = "0ae499e093def218aeea93734e64055941411c0b96297fcf89da331085dbbfdd",
				["MoveChildrenToOrigin"] = false,
				["Position"] = Vector(0, 0, 0),
				["AimPartUID"] = "",
				["Angles"] = Angle(0, 0, 0),
				["Hide"] = false,
				["Name"] = "",
				["Scale"] = Vector(1, 1, 1),
				["EditorExpand"] = false,
				["ClassName"] = "bone3",
				["Size"] = 0.4,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["AngleOffset"] = Angle(0, 0, 0),
				["EyeAngles"] = false,
				["HideMesh"] = false,
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "410ee2ef7fdf460f8ee17c25db794f64639ab0951f14c9a850a02fd58de22788",
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



PLUGIN:AddClothingPac("swat_outfit", pacdata)

