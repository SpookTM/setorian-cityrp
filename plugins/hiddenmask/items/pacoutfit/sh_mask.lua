ITEM.name = "Mask"
ITEM.description = "A mask hiding your face."
ITEM.category = "Clothing"
ITEM.outfitCategory = "face"
ITEM.illegal = true
ITEM.model = "models/sal/halloween/ninja.mdl"
ITEM.width = 1
ITEM.weight = 0.1
ITEM.height = 1
ITEM.pacData = {
	[1] = {
	["children"] = {
		[1] = {
			["children"] = {
			},
			["self"] = {
				["Skin"] = 0,
				["Invert"] = false,
				["LightBlend"] = 1,
				["CellShade"] = 0,
				["OwnerName"] = "self",
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Passes"] = 1,
				["Name"] = "",
				["NoTextureFiltering"] = false,
				["DoubleFace"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["Fullbright"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TintColor"] = Vector(0, 0, 0),
				["UniqueID"] = "2653000414",
				["Translucent"] = false,
				["LodOverride"] = -1,
				["BlurSpacing"] = 0,
				["Alpha"] = 1,
				["Material"] = "",
				["UseWeaponColor"] = false,
				["UsePlayerColor"] = false,
				["UseLegacyScale"] = false,
				["Bone"] = "mouth",
				["Color"] = Vector(255, 255, 255),
				["Brightness"] = 1,
				["BoneMerge"] = false,
				["BlurLength"] = 0,
				["Position"] = Vector(-5.9287109375, 0.14892578125, 0.78759765625),
				["AngleOffset"] = Angle(0, 0, 0),
				["AlternativeScaling"] = false,
				["Hide"] = false,
				["OwnerEntity"] = false,
				["Scale"] = Vector(1, 1, 1),
				["ClassName"] = "model",
				["EditorExpand"] = false,
				["Size"] = 1,
				["ModelFallback"] = "",
				["Angles"] = Angle(0, 0, 0),
				["TextureFilter"] = 3,
				["Model"] = "models/sal/halloween/ninja.mdl",
				["BlendMode"] = "",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "172602216",
		["AimPartUID"] = "",
		["Hide"] = false,
		["Duplicate"] = false,
		["ClassName"] = "group",
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "my outfit",
		["EditorExpand"] = true,
	},
},
}
ITEM.iconCam = {
	pos = Vector(151.25764465332, 126.45708465576, 93.097259521484),
	ang = Angle(25, 220, 0),
	fov = 4.5802596401417
}

function ITEM:OnEquipped()
	self.player:SetNetVar("isMasked",true)
end
 
function ITEM:OnUnequipped()
	self.player:SetNetVar("isMasked",false)
end

function ITEM:PopulateTooltip(tooltip)
    local tip = tooltip:AddRow("clothingwarning")
    tip:SetBackgroundColor(derma.GetColor("Error", tooltip))
    tip:SetText("Possession of this item is against the law. If you are caught with it, you may face arrest and charges.")
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end

function ITEM:CanEquipOutfit()
    if self.player:Team() == FACTION_CITIZEN or self.player:Team() == FACTION_CWU then
   return true
else
   return false
   end
end