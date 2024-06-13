ITEM.name = "Debit card"
ITEM.description = "You can use it at an ATM or when making a payment at a terminal."
ITEM.model = "models/gibs/metal_gib4.mdl"
-- ITEM.class = "ix_j_banking_debitcard"
-- ITEM.weaponCategory = "debitcard"
ITEM.width = 1
ITEM.height = 1
-- ITEM.OnEquipWeapon = true
-- ITEM.isGrenade = true

-- function ITEM:OnEquipWeapon(client, weapon)

-- 	weapon:SetCardNumber(self:GetData("CardNumber",0))
-- 	-- self:SetData("ammo", 255)
-- end

-- function ITEM:Equip(client, bNoSelect, bNoSound)
-- 	local items = client:GetCharacter():GetInventory():GetItems()

-- 	client.carryWeapons = client.carryWeapons or {}

-- 	for _, v in pairs(items) do
-- 		if (v.id != self.id) then
-- 			local itemTable = ix.item.instances[v.id]

-- 			if (!itemTable) then
-- 				client:NotifyLocalized("tellAdmin", "wid!xt")

-- 				return false
-- 			else
-- 				if (itemTable.isWeapon and client.carryWeapons[self.weaponCategory] and itemTable:GetData("equip")) then
-- 					client:NotifyLocalized("weaponSlotFilled", self.weaponCategory)

-- 					return false
-- 				end
-- 			end
-- 		end
-- 	end

-- 	if (client:HasWeapon(self.class)) then
-- 		client:StripWeapon(self.class)
-- 	end

-- 	local weapon = client:Give(self.class)

-- 	if (IsValid(weapon)) then
-- 		-- local ammoType = weapon:GetPrimaryAmmoType()

-- 		client.carryWeapons[self.weaponCategory] = weapon

-- 		if (!bNoSelect) then
-- 			client:SelectWeapon(weapon:GetClass())
-- 		end

-- 		if (!bNoSound) then
-- 			client:EmitSound(self.useSound, 80)
-- 		end

-- 		self:SetData("equip", true)

-- 		-- weapon.ixItem = self

-- 		if (self.OnEquipWeapon) then
-- 			self:OnEquipWeapon(client, weapon)
-- 		end
-- 	else
-- 		print(Format("[Helix] Cannot equip weapon - %s does not exist!", self.class))
-- 	end
-- end

ITEM.functions.Use = {
	OnRun = function(item)
        local client = item.player

        if (!client:Alive()) then return false end

        local tr = client:GetEyeTrace()
        local trEnt = tr.Entity


        if (trEnt:GetClass() == "j_banking_atm") then

        	if (client:GetPos():DistToSqr(trEnt:GetPos()) < 5000) then

        		trEnt:OpenUI(client, item:GetData("CardNumber",0))

        	else
        		client:Notify("You're too far away to do that")
        	end

        else
        	client:Notify("Invalid entity")
        end


        return false
    end,
    OnCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

if (CLIENT) then

	function ITEM:FormatDigit(val)

		local formated = ""
		local words = string.Explode( "", val )
		local newWords = {}

		for k, v in pairs(words) do
			
			newWords[#newWords + 1] = v

			if (k%4 == 0) then
				newWords[#newWords + 1] = " "
			end

		end

		return table.concat(newWords)

	end

	local cardTexture = ix.util.GetMaterial("HavenTrust Debit Card.png")

	function ITEM:PopulateTooltip(tooltip)

		local panel = tooltip:AddRow("card_bankid")
		panel:SetBackgroundColor(Color(255,51,51))
		panel:SetText("Bank ID: "..self:GetData("CardBankID",0))
		panel:SizeToContents()

		local panelNumber = tooltip:AddRow("card_number")
		-- panelNumber:SetBackgroundColor(Color(39, 174, 96))
		panelNumber:SetText("")
		-- panelNumber:SetText("CardNumber: "..self:FormatDigit(self:GetData("CardNumber",0)) )
		panelNumber:SizeToContents()

		local cardBg = panelNumber:Add("DPanel")
		cardBg:Dock(FILL)
		-- cardBg:SetMaterial(cardTexture)
		cardBg.Paint = function(s,w,h)

			surface.SetMaterial( cardTexture )
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawTexturedRect( 0,0,w,h )

			draw.SimpleText(self:FormatDigit(self:GetData("CardNumber",0)), "BudgetLabel", 40, h*0.55, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		
		end

		panelNumber:SetTall(180)

		

	end

end