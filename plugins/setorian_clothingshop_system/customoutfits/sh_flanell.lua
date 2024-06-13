local PLUGIN = PLUGIN


for variantI = 1, 13 do

	local pacdata = {	
	[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["ModelIndex"] = 1,
				["DrawOrder"] = 0,
				["UniqueID"] = "ccaa43agfa4gsa86fg6h874fd3543dfd7111ec07ff7edf"..variantI,
				["Hide"] = false,
				["TargetEntityUID"] = "",
				["EditorExpand"] = false,
				["IsDisturbing"] = false,
				["ClassName"] = "bodygroup",
				["Name"] = "",
				["BodyGroupName"] = "body",
			},
		},
		[2] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["ModelIndex"] = variantI,
						["DrawOrder"] = 0,
						["UniqueID"] = "421gdsfg4d867h6j87s68aw7687l86786jg7j6fd45g3de96460efe5"..variantI,
						["Hide"] = false,
						["TargetEntityUID"] = "",
						["EditorExpand"] = false,
						["IsDisturbing"] = false,
						["ClassName"] = "bodygroup",
						["Name"] = "",
						["BodyGroupName"] = "top",
					},
				},
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "e4e770sd86w8q46g4648i6g7it6y87jhvn54cv34s874dfs683fsde3fd29e14bd36"..variantI,
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
				["EditorExpand"] = true,
				["Size"] = 1,
				["ModelModifiers"] = "",
				["Translucent"] = false,
				["BlendMode"] = "",
				["EyeTargetUID"] = "",
				["Model"] = "models/smalls_civilians/pack2/male/flannel/tops.mdl",
			},
		},
		[3] = {
			["children"] = {
			},
			["self"] = {
				["ModelIndex"] = 0,
				["DrawOrder"] = 0,
				["UniqueID"] = "1f3d13f632e3525a54d17a7924287083a5bacee76f7d682f81ce8bd67d3c84c0"..variantI,
				["Hide"] = false,
				["TargetEntityUID"] = "",
				["EditorExpand"] = false,
				["IsDisturbing"] = false,
				["ClassName"] = "bodygroup",
				["Name"] = "",
				["BodyGroupName"] = "hands",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "a375asdfsaf86sa7fs68a7h867g54d3s5a4f354c1abc53f65"..variantI,
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

	PLUGIN:AddClothingPac("flannel_"..variantI, pacdata)

end
