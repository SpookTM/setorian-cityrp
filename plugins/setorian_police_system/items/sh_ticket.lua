
ITEM.name = "Ticket"
ITEM.description = "A ticket with an assigned number and information."
ITEM.model = Model("models/props_lab/clipboard.mdl")


function ITEM:GetName()

    local IsCarTicket = (self:GetData("CarTicket", false) and "Car Ticket") or "Ticket"

    return IsCarTicket
end

if (CLIENT) then

	function ITEM:PopulateTooltip(tooltip)
		local ticket_price = self:GetData("ticket_price", 0)

		local ticket_data = self:GetData("ticket_data", 0)

		local panel = tooltip:AddRowAfter("name", "ticket_price")
		panel:SetBackgroundColor(Color(39, 174, 96))
		panel:SetText("The price of this ticket: $"..ticket_price)
		panel:SizeToContents()

		if (ticket_data == 0) then return end

		local format_data = os.date( "%H:%M:%S - %m/%d/%Y" , ticket_data )

		local panel2 = tooltip:AddRowAfter("ticket_price", "ticket_data")
		panel2:SetBackgroundColor(Color(39, 174, 96))
		panel2:SetText("Pay before: "..format_data)
		panel2:SizeToContents()

		local panel3 = tooltip:AddRowAfter("ticket_data", "ticket_warn")
		panel3:SetBackgroundColor(Color(255,120,120))
		panel3:SetText("Or you will be wanted")
		panel3:SizeToContents()

	end

end
