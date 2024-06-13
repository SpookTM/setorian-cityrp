
local PANEL = {}

function PANEL:Init()
	self:SetTitle("Delete a user from group account")
	self:SetSize(330, 240)
	self:Center()
	self:MakePopup()


	self.ScrollPanel = vgui.Create( "DScrollPanel", self )
	self.ScrollPanel:Dock( FILL )


	self.Tip = vgui.Create( "DLabel", self )
	self.Tip:Dock(BOTTOM)
	self.Tip:DockMargin(5, 10, 5, 0)
	self.Tip:SetZPos(2)
	self.Tip:SetContentAlignment(5)
	self.Tip:SetText( "Select the account you want to delete from the group account" )

	self.Accounts = {}

end

function PANEL:Think()
	self:MoveToFront()
end


function PANEL:ScrollRefresh()
	self.ScrollPanel:Clear()
	for k, v in pairs(self.Accounts or {}) do
		if (k==1) then continue end
		self.Account = self.ScrollPanel:Add( "DButton" )
		self.Account:SetText( v.charName .. " - " .. v.charID )
		self.Account:Dock( TOP )
		self.Account:DockMargin( 0, 0, 0, 5 )
		self.Account.DoClick = function(s)
			-- self:RemoveFrequency(k)

			Derma_Query("Are you sure you want to delete this account?", "Delete account", "Yes", function()

				netstream.Start("JBanking_GroupAccount_RemoveUser",self.bankID, k, v.charID)

				self:GetParent():FillList_ManageAccounts_Delay()

				self:Close()
	           
	        end, "No", function()
	        end)
			
			

		end
	end
end


vgui.Register("ixBankManageAccounts_List_Del", PANEL, "DFrame")
-- vgui.Create("ixBankManageAccounts_List_Del")