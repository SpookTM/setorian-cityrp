local PLUGIN = PLUGIN

for variantI = 1, 11 do

	local pacdata = {	
		[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Skin"] = variantI-1,
					["UniqueID"] = "bdcsdasfasfff9s87fd9m79s7c1da3s5wa43ed1ef"..variantI,
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
					["Angles"] = Angle(-5.6156892469517e-07, -73.626747131348, -90),
					["AngleOffset"] = Angle(0, 0, 0),
					["BoneMerge"] = false,
					["Color"] = Vector(1, 1, 1),
					["Position"] = Vector(4.6704483032227, 0.34634399414063, 0.18026733398438),
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
					["Model"] = "models/modified/hat07.mdl",
				},
			},
		},
		["self"] = {
			["DrawOrder"] = 0,
			["UniqueID"] = "a43qqf561231321521sdafsafdfadsbv654vfv68acdfada1ac"..variantI,
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

	PLUGIN:AddClothingPac("hat6_"..variantI, pacdata)

end