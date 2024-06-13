local PLUGIN = PLUGIN
local pacdata = {	
	[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "0b904cc77b273de4edc9cad3553b638fcb7abe0bf965b99a0ba4e674e8df9999",
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
				["Angles"] = Angle(1.1138533864141e-06, -81.848220825195, -90),
				["AngleOffset"] = Angle(0, 0, 0),
				["BoneMerge"] = false,
				["Color"] = Vector(1, 1, 1),
				["Position"] = Vector(-0.67193603515625, -0.47613525390625, 0.000701904296875),
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
				["Model"] = "models/modified/bandana.mdl",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "1f21b2cc1c00ff0f8232190dcf846faf437b8778a05bbe76117caabb3a21631b",
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

PLUGIN:AddClothingPac("bandana", pacdata)

function ITEM:OnEquipped()
	self.player:SetNetVar("isMasked",true)
end
 
function ITEM:OnUnequipped()
	self.player:SetNetVar("isMasked",false)
end