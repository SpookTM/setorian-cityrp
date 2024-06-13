local PLUGIN = PLUGIN


for variantI = 1, 2 do

	local pacdata = {	
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Skin"] = variantI-1,
					["UniqueID"] = "0basdfsafasfasf123131f9999"..variantI,
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
					["Angles"] = Angle(1.1138533864141e-06, 0, 0),
					["AngleOffset"] = Angle(0, 0, 0),
					["BoneMerge"] = false,
					["Color"] = Vector(1, 1, 1),
					["Position"] = Vector(-0.77569580078125, 0.028900146484375, -3.6521964073181),
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
					["Model"] = "models/modified/backpack_3.mdl",
				},
			},
		},
		["self"] = {
			["DrawOrder"] = 0,
			["UniqueID"] = "1fasdfsfasfasf14141132asfasf1231313131aabb3a21631b"..variantI,
			["Hide"] = false,
			["TargetEntityUID"] = "",
			["EditorExpand"] = true,
			["OwnerName"] = "self",
			["IsDisturbing"] = false,
			["Name"] = "",
			["Duplicate"] = false,
			["ClassName"] = "group",
		},
	},

	}

	PLUGIN:AddClothingPac("backpack_1_"..variantI, pacdata)

end
