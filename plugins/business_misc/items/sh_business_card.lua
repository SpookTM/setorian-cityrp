ITEM.name = "Business card"
ITEM.description = "A business card typically includes the giver's name, business affiliation and contact information such as street addresses, telephone number and etc."
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Assign = {
    name = "Assign to Yourself",
    tip = "useTip",
    icon = "icon16/wrench.png",
    OnRun = function(item)

        local ply = item.player

        item:SetData("owner", ply:GetCharacter():GetID())
        ply:Notify("The business card has been assigned to you")

        return false
    end,

    OnCanRun = function(item)
        if IsValid(item.entity) then return false end
        local owner = item:GetData("owner", 0)

        return owner == 0
    end
}

ITEM.functions.EditCard = {
    name = "Edit Text",
    tip = "useTip",
    icon = "icon16/wrench.png",
    isMulti = true,
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

        local owner = item:GetData("owner", 0)

        return owner == item.player:GetCharacter():GetID()


    end,
    multiOptions = function(item, client)
        local targets = {}

        local options = {
        	[1] = "Business Name",
        	[2] = "Business Location",
        	[3] = "Business Number",
        	[4] = "Business Description",
        }

        for i=1, #options do
        	table.insert(targets, {
                name = options[i],
                data = {i},
            })
        end
            
        return targets
    end,
    OnRun = function(item, data)
        if not data[1] then return false end
        local target = data[1]

        local ply = item.player
        local char = ply:GetCharacter()

        ply.editingBusinessCard = item

        net.Start("ixBCard_EditText")
            net.WriteUInt(target, 3)
        net.Send(ply)


        return false

    end
}

ITEM.functions.EditColors = {
    name = "Edit Color",
    tip = "useTip",
    icon = "icon16/color_wheel.png",
    isMulti = true,
    OnCanRun = function(item)

        if IsValid(item.entity) then return false end

        local owner = item:GetData("owner", 0)

        return owner == item.player:GetCharacter():GetID()

    end,
    multiOptions = function(item, client)
        local targets = {}

        local options = {
            [1] = "Background Color",
            [2] = "Text Color",
        }

        for i=1, #options do
            table.insert(targets, {
                name = options[i],
                data = {i},
            })
        end
            
        return targets
    end,
    OnRun = function(item, data)
        if not data[1] then return false end
        local target = data[1]

        local ply = item.player
        local char = ply:GetCharacter()

        ply.editingBusinessCard = item

        net.Start("ixBCard_EditColor")
            net.WriteUInt(target, 2)
        net.Send(ply)


        return false

    end
}

if (CLIENT) then

	local cardTexture = ix.util.GetMaterial("blank_business_card2.png")

	function ITEM:PopulateTooltip(tooltip)

		local panelNumber = tooltip:AddRow("card_number")
		-- panelNumber:SetBackgroundColor(Color(39, 174, 96))
		panelNumber:SetText("")
        panelNumber:SetSize(200,200)
		panelNumber:SizeToContents()

        local WrappedDesc = ix.util.WrapText(self:GetData("BCard_Desc","Business Description"), 140, "Trebuchet18")

        local bgColor = string.ToColor(self:GetData("BCard_BGColor","255 255 255") .. " 255")
        local textColor = string.ToColor(self:GetData("BCard_BGText","0 0 0") .. " 255")

        local tbl = string.Explode( " ", self:GetData("BCard_BGColor","255 255 255") )
        local newtbl = {}

        for k, v in ipairs(tbl) do
            newtbl[k] = math.abs(255-v)
        end

        local lineColor = string.ToColor(table.concat( newtbl, " " ) .. " 255")

		local cardBg = panelNumber:Add("DPanel")
		cardBg:Dock(FILL)
		cardBg.Paint = function(s,w,h)

			surface.SetMaterial( cardTexture )
			surface.SetDrawColor( bgColor )
			surface.DrawTexturedRect( 10,10,w-20,h-20 )

            draw.SimpleText(self:GetData("BCard_Name","Business Name"), "ixChatFont", 20,30, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            for k,v in ipairs(WrappedDesc) do
                draw.SimpleText(v, "Trebuchet18", 21,55 + ((k-1)*12), textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            draw.SimpleText("-", "ixIconsSmall", w*0.5 + 5,55, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(self:GetData("BCard_Number","Business Number"), "Trebuchet18", w*0.5+30,56, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            draw.SimpleText("9", "ixIconsSmall", w*0.5 + 5,85, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(self:GetData("BCard_Location","Business Location"), "Trebuchet18", w*0.5+30,86, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(lineColor)
            surface.DrawRect(w/2-4,42,1,h-65)

		end

		panelNumber:SetTall(180)

		

	end

end