ITEM.name = "Paycheck"
ITEM.description = "Make this check payable in bank to receive cash."
ITEM.model = "models/gibs/metal_gib4.mdl"

ITEM.width = 1
ITEM.height = 1

if (CLIENT) then

	local cardTexture = ix.util.GetMaterial("setorian_paycheck.png")

	function ITEM:PopulateTooltip(tooltip)

		local panelNumber = tooltip:AddRow("card_texture")
		panelNumber:SetText("")
		panelNumber:SetWide(400)

		local check_money = self:GetData("Check_Money",0)
		local check_date  = self:GetData("Check_Date","02/12/1995")
		local check_name  = self:GetData("Check_Name","John Doe")
		local check_memo  = self:GetData("Check_Memo","City Work")


		local cardBg = panelNumber:Add("DPanel")
		cardBg:Dock(FILL)
		cardBg.Paint = function(s,w,h)

			surface.SetMaterial( cardTexture )
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawTexturedRect( 0,0,w,h )

			draw.SimpleText(check_name, "ixSmallFont", 85, h*0.4, Color( 10,10,10 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText(check_memo, "ixSmallFont", 85, h*0.68, Color( 10,10,10 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			draw.SimpleText(check_money, "ixSmallFont", w-90, h*0.338, Color( 10,10,10 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			draw.SimpleText(check_date, "ixSmallFont", w-120, 23.5, Color( 10,10,10 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		end

		panelNumber:SetTall(180)

		

	end

end