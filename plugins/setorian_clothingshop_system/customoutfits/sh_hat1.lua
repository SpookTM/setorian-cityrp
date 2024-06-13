local PLUGIN = PLUGIN

for variantI = 1, 8 do

	local pacdata = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Skin"] = variantI-1,
						["UniqueID"] = "109337848127183asufhsaufufhau9hfa9w8fh9afdhua93hfanc824bvsjdfh2735"..variantI,
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
						["Angles"] = Angle(0, -90, -90),
						["AngleOffset"] = Angle(0, 0, 0),
						["BoneMerge"] = false,
						["Color"] = Vector(1, 1, 1),
						["Position"] = Vector(5.4027481079102, 0.48257446289063, 0.000640869140625),
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
						["Model"] = "models/modified/hat01_fix.mdl",
					},
				},
			},
			["self"] = {
				["DrawOrder"] = 0,
				["UniqueID"] = "4123sadfasfsffhfghsfsf4125745"..variantI,
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

	PLUGIN:AddClothingPac("hat1_"..variantI, pacdata)

end