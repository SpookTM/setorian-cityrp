ITEM.name = "Business Certification"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.description = "A certificate that contains information about the business. It proves that the business is legitimate.."
ITEM.width = 1
ITEM.height = 1
ITEM.IsBCertificate = true

if (CLIENT) then

	local cardTexture = ix.util.GetMaterial("business_certification1.png")

	function ITEM:PopulateTooltip(tooltip)

		local panelNumber = tooltip:AddRow("card_number")
		-- panelNumber:SetBackgroundColor(Color(39, 174, 96))
		panelNumber:SetText("")
        -- panelNumber:SetSize(286,198)
		panelNumber:SizeToContents()

		local cardBg = panelNumber:Add("DPanel")
		cardBg:Dock(FILL)
		cardBg.Paint = function(s,w,h)

			surface.SetMaterial( cardTexture )
			surface.SetDrawColor( color_white )
			surface.DrawTexturedRect( 5,5, w-10, h-10 )

			draw.SimpleText(self:GetData("BCerti_Name","Business Name"), "Setorian_Century1", w/2,h*0.36, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.SimpleText(self:GetData("BCerti_Name","Business Name"), "Setorian_Century2", w*0.325,h*0.4985, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            draw.SimpleText(self:GetData("BCerti_Date","02/12/1995"), "Setorian_Century2", 144,h*0.572, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(self:GetData("BCerti_Name","Business Name"), "Setorian_Century2", 178,h*0.572, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            draw.SimpleText(self:GetData("BCerti_Sign",""), "Setorian_Anthony1", w*0.75,h*0.76, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end

		panelNumber:SetSize(512,408)

		

	end

end