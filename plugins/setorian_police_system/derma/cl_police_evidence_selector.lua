
-- local PLUGIN = PLUGIN

local function InventoryToolTip(tooltip, item)

	local name = tooltip:AddRow("name")
	name:SetImportant()
	name:SetText(item.GetName and item:GetName() or L(item.name))
	name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
	name:SizeToContents()

	local description = tooltip:AddRow("description")
	description:SetText(item:GetDescription() or "")
	description:SizeToContents()

	if (item.PopulateTooltip) then
		item:PopulateTooltip(tooltip)
	end

end

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

local scrw = ScrW()
local scrh = ScrH()

function PANEL:Init()


	self:SetSize(600,640)
	-- self:SetPos(scrw/2 - self:GetWide()/2,scrh)
	self:Center()
	self:MakePopup()

	self:SetTitle("")

	self.ImgurID = ""

	self:ShowCloseButton(false)

	self.Paint = function(s,w,h)

		//Background
	    surface.SetDrawColor(44, 62, 80)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(52, 73, 94)
	    surface.DrawRect(4,28,w-8,h-32)

	end

	local WindowTitle = self:Add( "ixLabel")
	WindowTitle:SetPos(2,2)
	WindowTitle:SetWide(self:GetWide())
	WindowTitle:SetFont("Setorian_Interaction_Font")
	WindowTitle:SetText( "Evidence Selector" )
	WindowTitle:SetContentAlignment(4)
	WindowTitle:SetPadding(5)
	WindowTitle:SetMouseInputEnabled(false)

	self.WindowTitle = WindowTitle

	local Scroll = vgui.Create( "DScrollPanel", self ) -- Create the Scroll panel
	Scroll:Dock( FILL )
	Scroll:DockMargin(5,5,0,5)

	local List = vgui.Create( "DIconLayout", Scroll )
	List:Dock( FILL )
	-- ScrollPanel:InvalidateParent(true)
	List:SetWide(570)
	List:SetSpaceY( 5 )
	List:SetSpaceX( 5 )

	-- List:SetColumns(3)
	-- List:SetHorizontalMargin(5)
	-- List:SetVerticalMargin(5)
	List.Paint = function(s,w,h)
	end

	self.ScrollPanel = List

	local CustomImage = self:Add( "Panel")
	CustomImage:Dock(BOTTOM)
	CustomImage:DockMargin(5,0,5,0)
	CustomImage:SetTall(40)
	CustomImage:SetZPos(2)
	-- CustomImage.Paint = function(s,w,h)
	-- 	surface.SetDrawColor(40,40,40,150)
	--     surface.DrawRect(0,0,w,h)

	-- end

	local CustomImage_Text = CustomImage:Add( "ixLabel")
	CustomImage_Text:Dock(LEFT)
	CustomImage_Text:SetWide(self:GetWide()/2)
	CustomImage_Text:SetFont("ixSmallBoldFont")
	CustomImage_Text:SetText( "Do you want use a custom image?" )
	CustomImage_Text:SetContentAlignment(4)
	CustomImage_Text:SetPadding(5)
	CustomImage_Text:SetMouseInputEnabled(false)

	local TextEntryPH = vgui.Create( "DTextEntry", CustomImage )
	TextEntryPH:Dock( RIGHT )
	TextEntryPH:DockMargin(0,5,0,5)
	TextEntryPH:SetWide(self:GetWide()/2 - 20)
	TextEntryPH:SetText("IMGUR ID")
	TextEntryPH:SetFont("ixSmallBoldFont")
	TextEntryPH.Paint = function(s,w,h)

	    surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0, 0, w,h)
	    s:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	    
	end
	TextEntryPH.OnGetFocus = function( s )
		if (s:GetValue() == "IMGUR ID") then
			s:SetValue("")
			self.ImgurID = ""
		end
	end
	TextEntryPH.OnLoseFocus = function(s)
		if (s:GetValue() != "IMGUR ID") then
			self.ImgurID = s:GetValue()
		end
	end
	TextEntryPH.OnEnter = function(s)
		if (s:GetValue() != "IMGUR ID") then
			self.ImgurID = s:GetValue()
		end
	end

	self.SelectedItem = {}

	local ConfirmButton = self:Add( "DButton" )
	ConfirmButton:Dock(BOTTOM)
	ConfirmButton:DockMargin(5,0,5,5)
	ConfirmButton:SetTall(40)
	ConfirmButton:SetZPos(2)
	ConfirmButton:SetText("CONFIRM")
	ConfirmButton:SetFont("ixSmallBoldFont")
	ConfirmButton.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	    if (s:IsHovered()) then
	    	surface.SetDrawColor(100,100,100,150)
	    	surface.DrawOutlinedRect(0,0,w,h,2)
	    end
	end
	ConfirmButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")

		if (table.IsEmpty(self.SelectedItem)) then
			LocalPlayer():Notify("Please select a evidence item")
			return
		end

		if (self.TableToAdd) and (self:GetParent()) then

			if (self.ImgurID != "") then
				self.SelectedItem.CustomImage = self.ImgurID
			end

			self:GetParent().PersonCaseData[self.TableToAdd].People[#self:GetParent().PersonCaseData[self.TableToAdd].People+1] = self.SelectedItem

			self:GetParent():RenderCaseDetails(self:GetParent().PersonCaseData[self.TableToAdd].People,self.TableToAdd)


		end

		self:Close()

	end

	local CloseButton = self:Add( "DButton" )
	CloseButton:Dock(BOTTOM)
	CloseButton:DockMargin(5,0,5,5)
	CloseButton:SetTall(40)
	CloseButton:SetZPos(1)
	CloseButton:SetText("CANCEL")
	CloseButton:SetFont("ixSmallBoldFont")
	CloseButton.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	    if (s:IsHovered()) then
	    	surface.SetDrawColor(100,100,100,150)
	    	surface.DrawOutlinedRect(0,0,w,h,2)
	    end
	end
	CloseButton.DoClick = function(s)
		surface.PlaySound("helix/ui/press.wav")
		self:Close()

		if (self:GetParent()) then
			self:GetParent().IsModified = false
		end
 
	end

end

function PANEL:ShowInvItems(items)

	self.ScrollPanel:Clear()

	if (!items) then return end

	for k, v in pairs(items) do
		
		local ItemPanel = self.ScrollPanel:Add( "DButton" )
		-- ItemPanel:Dock( TOP )
		-- ItemPanel:DockMargin( 0, 0, 0, 15 )
		-- ItemPanel:SetTall(130)
		ItemPanel:SetSize(186,130)
		ItemPanel:SetText("")
		ItemPanel:SetIsToggle(true)
		ItemPanel:SetHelixTooltip(function(tooltip)
			InventoryToolTip(tooltip, v)
		end)
		ItemPanel.Paint = function(s,w,h)

		//Background
		    surface.SetDrawColor(40,40,40,150)
		    surface.DrawRect(0,0,w,h)

		    if (s:IsHovered() or s:GetToggle()) then
		    	surface.SetDrawColor(39, 174, 96,150)
		    	surface.DrawOutlinedRect(0,0,w,h,3)
		    end

		    
		end
		ItemPanel.DoClick = function(s)

			surface.PlaySound("helix/ui/press.wav")

			for k, v in pairs(self.ScrollPanel:GetChildren()) do
		    	if (v == ItemPanel) then continue end
		    	v:SetToggle(false)
		    end

		    s:SetToggle(true)

		    self.SelectedItem = {
		    	IName = v:GetName(),
		    	IModel = v:GetModel()
		    }

		end

		-- self.ScrollPanel:AddCell(ItemPanel)

		local SpawnI = vgui.Create( "SpawnIcon" , ItemPanel ) -- SpawnIcon
		SpawnI:SetSize(120,120)
		SpawnI:SetPos(ItemPanel:GetWide()/2 - SpawnI:GetWide()/2,ItemPanel:GetTall()/2 - SpawnI:GetTall()/2)
		SpawnI:SetModel( v:GetModel() or "models/Items/item_item_crate.mdl" )
		SpawnI:SetTooltip(false)
		SpawnI:SetMouseInputEnabled(false)


		local ItemTitle = ItemPanel:Add( "ixLabel")
		ItemTitle:Dock(BOTTOM)
		ItemTitle:DockMargin(0,0,0,10)
		ItemTitle:SetFont("Setorian_Interaction_Font")
		ItemTitle:SetText( v.GetName and v:GetName() or L(v.name) or "Undefined" )
		-- WindowTitle:SetScaleWidth(true)
		ItemTitle:SetContentAlignment(5)
		ItemTitle:SetPadding(5)
		ItemTitle:SetMouseInputEnabled(false)

	end


end

vgui.Register("ixPoliceStuff_EvidenceSelector", PANEL, "DFrame")

-- local char = LocalPlayer():GetCharacter()
-- local inv = char:GetInventory()
-- local items = inv:GetItems()

-- vgui.Create("ixPoliceStuff_EvidenceSelector"):ShowInvItems(items)