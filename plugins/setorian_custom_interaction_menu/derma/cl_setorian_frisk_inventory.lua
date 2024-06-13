
-- local PLUGIN = PLUGIN

local function InventoryToolTip(tooltip, ItemName, ItemDesc)
	local name = tooltip:AddRow("name")
	name:SetImportant()
	name:SetText(ItemName)
	name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
	name:SizeToContents()

	local description = tooltip:AddRow("description")
	description:SetText(ItemDesc or "")
	description:SizeToContents()

end

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

local scrw = ScrW()
local scrh = ScrH()

function PANEL:Init()


	self:SetSize(600,600)
	-- self:SetPos(scrw/2 - self:GetWide()/2,scrh)
	self:Center()
	self:MakePopup()

	self:SetTitle("")


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
	WindowTitle:SetText( "Unknown - Inventory" )
	-- WindowTitle:SetScaleWidth(true)
	WindowTitle:SetContentAlignment(4)
	WindowTitle:SetPadding(5)
	WindowTitle:SetMouseInputEnabled(false)

	self.WindowTitle = WindowTitle

	local ScrollPanel = vgui.Create( "ThreeGrid", self )
	ScrollPanel:Dock( FILL )
	ScrollPanel:DockMargin(5,5,0,5)
	-- ScrollPanel:InvalidateParent(true)
	ScrollPanel:SetWide(570)

	ScrollPanel:SetColumns(3)
	ScrollPanel:SetHorizontalMargin(5)
	ScrollPanel:SetVerticalMargin(5)
	ScrollPanel.Paint = function(s,w,h)
	end

	self.ScrollPanel = ScrollPanel

end

function PANEL:ShowInvItems(items, CharName)

	self.ScrollPanel:Clear()

	self.WindowTitle:SetText( CharName.." - Inventory" )

	if (!items) then return end

	for k, v in pairs(items) do
		
		local ItemPanel = self.ScrollPanel:Add( "DPanel" )
		ItemPanel:Dock( TOP )
		ItemPanel:DockMargin( 0, 0, 0, 15 )
		ItemPanel:SetTall(130)
		ItemPanel:SetHelixTooltip(function(tooltip)
			InventoryToolTip(tooltip, v.Name, v.Desc)
		end)
		ItemPanel.Paint = function(s,w,h)

		//Background
		    surface.SetDrawColor(40,40,40,150)
		    surface.DrawRect(0,0,w,h)

		    if (s:IsHovered()) then
		    	surface.SetDrawColor(39, 174, 96,150)
		    	surface.DrawOutlinedRect(0,0,w,h,3)
		    end

		end

		self.ScrollPanel:AddCell(ItemPanel)

		local SpawnI = vgui.Create( "SpawnIcon" , ItemPanel ) -- SpawnIcon
		SpawnI:SetSize(120,120)
		SpawnI:SetPos(ItemPanel:GetWide()/2 - SpawnI:GetWide()/2,ItemPanel:GetTall()/2 - SpawnI:GetTall()/2)
		SpawnI:SetModel( v.Model or "models/Items/item_item_crate.mdl" )
		SpawnI:SetTooltip(false)
		SpawnI:SetMouseInputEnabled(false)


		local ItemTitle = ItemPanel:Add( "ixLabel")
		ItemTitle:Dock(BOTTOM)
		ItemTitle:DockMargin(0,0,0,10)
		ItemTitle:SetFont("Setorian_Interaction_Font")
		ItemTitle:SetText( v.Name or "Undefined" )
		-- WindowTitle:SetScaleWidth(true)
		ItemTitle:SetContentAlignment(5)
		ItemTitle:SetPadding(5)
		ItemTitle:SetMouseInputEnabled(false)

	end


end

vgui.Register("ixFrisk_InventoryPanel", PANEL, "DFrame")
-- vgui.Create("ixFrisk_InventoryPanel")