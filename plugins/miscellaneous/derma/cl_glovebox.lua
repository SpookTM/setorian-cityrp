
local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

AccessorFunc(PANEL, "frameMargin", "FrameMargin", FORCE_NUMBER)


function PANEL:Init()

	self:Dock(FILL)
	local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())
	self:SetFrameMargin(4)
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	local canvas = self:Add("DTileLayout")
	local canvasLayout = canvas.PerformLayout
	canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
	canvas:SetBorder(0)
	canvas:SetSpaceX(2)
	canvas:SetSpaceY(2)
	canvas:Dock(FILL)

	self.storageInventory = canvas:Add("ixInventory")
	self.storageInventory.bNoBackgroundBlur = true
	self.storageInventory:SetTitle(nil)
	self.storageInventory:SetDraggable(false)
	self.storageInventory:SetSizable(false)
	self.storageInventory.childPanels = {}

	self.localInventory = canvas:Add("ixInventory")
	self.localInventory.bNoBackgroundBlur = true
	self.localInventory:SetDraggable(false)
	self.localInventory:SetSizable(false)
	self.localInventory:SetTitle(nil)
	self.localInventory.bNoBackgroundBlur = true
	self.localInventory.childPanels = {}

	canvas.PerformLayout = canvasLayout
	canvas:Layout()

	-- local panel = vgui.Create("ixStorageView", self)

	-- local localInventory = LocalPlayer():GetCharacter():GetInventory()

	-- if (localInventory) then
	-- 	panel:SetLocalInventory(localInventory)
	-- end

	-- panel:SetStorageID(id)
	-- panel:SetStorageTitle("Glovebox")
	-- panel:SetStorageInventory(inventory)

	-- self.StorageUI = panel

end

function PANEL:SetLocalInventory(inventory)
	if (IsValid(self.localInventory)) then
		local parent = self:GetParent()
		self.localInventory:SetInventory(inventory)
		-- self.localInventory:SetPos(parent:GetWide() / 2 + self:GetFrameMargin() / 2, parent:GetTall() / 2 - self.localInventory:GetTall() / 2)
	end
end


function PANEL:SetStorageInventory(inventory)
	local parent = self:GetParent()
	self.storageInventory:SetInventory(inventory)
	-- self.storageInventory:SetPos(
	-- 	parent:GetWide() / 2 - self.storageInventory:GetWide() - 2,
	-- 	parent:GetTall() / 2 - self.storageInventory:GetTall() / 2
	-- )

	ix.gui["inv" .. inventory:GetID()] = self.storageInventory
end

function PANEL:Update(vehicle)
	if (!vehicle) then
		return
	end

	local gloveInv = vehicle:GetGloveBox()

	if (gloveInv) then
		self:SetStorageInventory(gloveInv)
	end

	-- self.StorageUI:SetStorageID(gloveInv:GetID())
	

end


function PANEL:Paint(width, height)
-- 	derma.SkinFunc("PaintCharacterCreateBackground", self, width, height)
-- 	BaseClass.Paint(self, width, height)
-- surface.SetDrawColor(39,39,39)
-- 		surface.DrawRect(0, 0, width, height)
end

vgui.Register("ixGloveboxUI", PANEL, "DFrame")

-- hook.Add("CreateMenuButtons", "ixGloveBoxHandler", function(tabs)
-- 	if (hook.Run("ShowGloveBoxUI") != false) then
-- 		tabs["Glove Box"] = {
-- 			Create = function(info, container)

-- 				-- local canvas = container:Add("DTileLayout")
-- 				-- local canvasLayout = canvas.PerformLayout
-- 				-- canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
-- 				-- canvas:SetBorder(0)
-- 				-- canvas:SetSpaceX(2)
-- 				-- canvas:SetSpaceY(2)
-- 				-- canvas:Dock(FILL)

-- 				container.GloveBoxUI = container:Add("ixGloveboxUI")
-- 				ix.gui.gloveboxUI = container.GloveBoxUI

-- 				local localInventory = LocalPlayer():GetCharacter():GetInventory()

-- 				if (localInventory) then
-- 					container.GloveBoxUI:SetLocalInventory(localInventory)
-- 				end

-- 				ix.gui.gloveboxUI:Update(LocalPlayer():GetVehicle())

-- 				-- canvas.PerformLayout = canvasLayout
-- 				-- canvas:Layout()

-- 			end,
-- 			OnSelected = function(info, container)
-- 				container.GloveBoxUI:Update(LocalPlayer():GetVehicle())
-- 			end,
-- 		}
-- 	end
-- end)