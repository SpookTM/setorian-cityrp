
local PANEL = {}

function PANEL:Init()
	self:SetTitle("Add a user to group account")
	self:SetSize(460, 220)
	self:Center()
	self:MakePopup()

	self.SelectedCharData = ""

	local AccountSelector = vgui.Create( "DComboBox", self )
	AccountSelector:Dock(TOP)
	-- AccountSelector:DockMargin(0,0,0,10)
	AccountSelector:SetTall(50)
	AccountSelector:SetValue( "Choose a character" )

	for client, character in ix.util.GetCharacters() do

		if (client == LocalPlayer()) then continue end

		AccountSelector:AddChoice( character:GetName(), {character:GetID(), character:GetName()} )

	end
	AccountSelector.OnSelect = function( s, index, value, data )
		self.SelectedCharData = data
	end

	self.AccountSelector = AccountSelector

	local options = {
		["can_withdraw"] = "Can a user withdraw money from a group account?",
		["can_deposit"] = "Can a user deposit money to a group account?",
		["can_transfer"] = "Can a user transfer money between accounts?",
		["can_getcard"] = "Can a person get their own debit card from an npc that belongs to a group account?",
	}

	self.optionsBool = {
		["can_withdraw"] = 0,
		["can_deposit"] = 0,
		["can_transfer"] = 0,
		["can_getcard"] = 0,
	}

	for k, v in pairs(options) do

		local CheckBoxOptions = self:Add( "DCheckBoxLabel" )
		CheckBoxOptions:Dock(TOP)
		CheckBoxOptions:DockMargin(10,0,0,10)
		CheckBoxOptions:SetText(v)
		CheckBoxOptions.option = k
		CheckBoxOptions:SizeToContents()
		CheckBoxOptions.OnChange = function( s, state )
			self.optionsBool[s.option] = state
		end

	end

	self.Accept = self:Add( "DButton" )
	self.Accept:SetText( "Add character" )
	self.Accept:Dock(BOTTOM)
	self.Accept:DockMargin(5, 10, 5, 10)
	self.Accept.DoClick = function(s)
		if (self.bankID != 0) then

			if (self.SelectedCharData == "") then
				LocalPlayer():Notify("Please character to add")
				return
			end

			netstream.Start("JBanking_GroupAccount_AddUser",self.bankID, self.SelectedCharData, self.optionsBool)

			self:GetParent():FillList_ManageAccounts_Delay()

			self:Close()
		end
	end

end

function PANEL:Think()
	if (!self.AccountSelector:IsMenuOpen()) then
		self:MoveToFront()
	end
end


vgui.Register("ixBankManageAccounts_List", PANEL, "DFrame")
-- vgui.Create("ixBankManageAccounts_List")