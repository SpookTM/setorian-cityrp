local PLUGIN = PLUGIN
ITEM.name = "Meth Recipe"
ITEM.model = Model("models/props_lab/clipboard.mdl")
ITEM.description = "A special recipe to create the perfect meth."
ITEM.category = "Meth"
ITEM.width = 1 
ITEM.height = 1
ITEM.bDropOnDeath = true
if (CLIENT) then

	local recipepartone = ix.util.GetMaterial("setorian_meth/recipe_paper.png")
	local recipeparttwo = ix.util.GetMaterial("setorian_meth/recipe_paper2.png")

	function ITEM:PopulateTooltip(tooltip)


		local panel = tooltip:AddRowAfter("description", "paperone")
		panel:SetText("")
		panel:SizeToContents()

		local cardBg = panel:Add("DImage")
		cardBg:Dock(FILL)
		cardBg:SetMaterial(recipepartone)


		local cardBg = panel:Add("DImage")
		cardBg:Dock(FILL)
		cardBg:SetMaterial(recipepartone)

		local methTitle = cardBg:Add("DLabel")
		methTitle:SetText("Meth Recipe")
		methTitle:SetFont("ixArchitexFont")
		methTitle:SetTextColor(color_black)
		methTitle:Dock(TOP)
		methTitle:DockMargin(0,35,0,0)
		methTitle:SetContentAlignment(5)
		methTitle:SizeToContents()

		local methingredients = cardBg:Add("DLabel")
		methingredients:SetText("Ingredients:")
		methingredients:SetFont("ixArchitexFont2")
		methingredients:SetTextColor(color_black)
		methingredients:Dock(TOP)
		methingredients:DockMargin(20,5,0,0)
		methingredients:SizeToContents()
		-- methingredients:SetContentAlignment(5)

		local ingredients = PLUGIN.MethRecipe
		local ingName = {
			["Acetone"] = "Acetone",
			["Bismuth"] = "Bismuth",
			["Hydrogen"] = "Hydrogen Peroxide",
			["Phosphoric"] = "Phosphoric Acid",
		}
		-- {
		-- 	["Acetone"] = 3,
		-- 	["Bismuth"] = 20,
		-- 	["Hydrogen Peroxide"] = 15,
		-- 	["Phosphoric Acid"] = 5,
		-- }


		for k, v in pairs(ingredients) do
			
			local methingredient = cardBg:Add("DLabel")
			methingredient:SetText(" - "..v.."% of "..ingName[k])
			methingredient:SetFont("ixArchitexFont3")
			methingredient:SetTextColor(color_black)
			methingredient:Dock(TOP)
			methingredient:DockMargin(20,0,0,0)
			methingredient:SizeToContents()

		end

		local methtip = cardBg:Add("DLabel")
		methtip:SetText("Cook at 212 degrees fahrenheit for about 15 minutes, then set aside in the freezer for 20 minutes. The order in which the ingredients are added does not matter. \nNote: Wrong ingredient ratio can be fatal")
		methtip:SetFont("ixArchitexFont2")
		methtip:SetTextColor(color_black)
		methtip:Dock(FILL)
		methtip:DockMargin(20,0,0,0)
		methtip:SetWrap(true)


		panel:SetSize(370,400) 
		

	end

end