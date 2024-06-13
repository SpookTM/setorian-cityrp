local PLUGIN = PLUGIN

for variantI = 1, 12 do

	local pacdata = {	
		[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Skin"] = variantI-1,
					["UniqueID"] = "8qgfs8g4s64gf6sfsa8dfa6f4daf4af7a4fadfs"..variantI,
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
					["Bone"] = "head",
					["Angles"] = Angle(-5.3518069762504e-06, -78.927764892578, -90),
					["AngleOffset"] = Angle(0, 0, 0),
					["BoneMerge"] = false,
					["Color"] = Vector(1, 1, 1),
					["Position"] = Vector(4.5344886779785, -0.1436767578125, 0.18048095703125),
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
					["Model"] = "models/modified/hat08.mdl",
				},
			},
		},
		["self"] = {
			["DrawOrder"] = 0,
			["UniqueID"] = "sdafgfg8fg48ds4gfdsf12gsd31564d8s"..variantI,
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

	PLUGIN:AddClothingPac("hat7_"..variantI, pacdata)

end