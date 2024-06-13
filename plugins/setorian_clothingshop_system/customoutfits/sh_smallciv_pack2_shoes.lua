local PLUGIN = PLUGIN


for variantI = 1, 2 do

	local pacdata = {	
	[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "5099d36e2a431ad473bef838c7935cc08b421981eb0dde8d156f7dc77fdffee4"..variantI,
				["NoLighting"] = false,
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Materials"] = "",
				["Name"] = "",
				["LevelOfDetail"] = 0,
				["NoTextureFiltering"] = false,
				["PositionOffset"] = Vector(-0.20000000298023, 0, 0),
				["IsDisturbing"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TargetEntityUID"] = "",
				["Alpha"] = 1,
				["Material"] = "",
				["Invert"] = false,
				["ForceObjUrl"] = false,
				["Bone"] = "skirt",
				["Angles"] = Angle(2.1799855232239, -94.259262084961, 83.894226074219),
				["AngleOffset"] = Angle(0, 0, 0),
				["BoneMerge"] = true,
				["Color"] = Vector(1, 1, 1),
				["Position"] = Vector(38.855850219727, 3.6216735839844, -0.835693359375),
				["ClassName"] = "model2",
				["Brightness"] = 1,
				["Hide"] = false,
				["NoCulling"] = false,
				["Scale"] = Vector(1, 1, 1),
				["LegacyTransform"] = false,
				["EditorExpand"] = false,
				["Size"] = 1.1,
				["ModelModifiers"] = "shoes="..variantI..";",
				["Translucent"] = false,
				["BlendMode"] = "",
				["EyeTargetUID"] = "",
				["Model"] = "models/smalls_civilians/pack2/male/hoodie_sweatpants/shoes.mdl",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "3bf142c999f34fb5fe370a00f9f4b4c0c88359f200385b4ea96dde5688758f7e"..variantI,
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

	PLUGIN:AddClothingPac("shoes_pack2_"..variantI, pacdata)

end
