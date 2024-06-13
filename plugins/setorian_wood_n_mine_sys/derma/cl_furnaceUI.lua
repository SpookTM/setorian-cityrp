
local PANEL = {}

local PLUGIN = PLUGIN

DEFINE_BASECLASS("Panel")

AccessorFunc(PANEL, "fadeTime", "FadeTime", FORCE_NUMBER)
AccessorFunc(PANEL, "frameMargin", "FrameMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "storageID", "StorageID", FORCE_NUMBER)

function PANEL:Init()
	if (IsValid(ix.gui.furnaceUI)) then
		ix.gui.furnaceUI:Remove()
	end

	ix.gui.furnaceUI = self

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)
	self:SetFadeTime(0.25)
	self:SetFrameMargin(4)

	self.CoolDown = CurTime()

	-- self.storageInventory = self:Add("ixInventory")
	-- self.storageInventory.bNoBackgroundBlur = true
	-- self.storageInventory:ShowCloseButton(true)
	-- self.storageInventory:SetTitle("Storage")
	-- self.storageInventory.Close = function(this)
	-- 	net.Start("ixStorageClose")
	-- 	net.SendToServer()
	-- 	self:Remove()
	-- end

	local FurnacePnl =  self:Add( "DFrame", self )
	FurnacePnl:SetSize(250,375)
	FurnacePnl:SetPos(
		self:GetWide() / 2,
		self:GetTall() / 2 - FurnacePnl:GetTall() / 2
	)
	FurnacePnl:SetTitle("")
	FurnacePnl:ShowCloseButton(true)
	FurnacePnl.Close = function(this)
		self:Remove()
	end
	FurnacePnl.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,150)
	    surface.DrawOutlinedRect(0,0,w,h,2)

	    surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,25)

		surface.SetDrawColor(20,20,20,200)
	    surface.DrawRect(0,0,w,h)


	    draw.SimpleTextOutlined("v", "ixIconsBig", w*0.62,120, Color( 129, 145, 146 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(20,20,20))
	   	
	   	draw.SimpleTextOutlined("v", "ixIconsBig", w*0.62,240, Color( 129, 145, 146 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(20,20,20))

	   	if (self.FurnaceEnt:GetIsWorking()) then
			draw.SimpleTextOutlined(",", "ixIconsSmall", 73, 85, Color( 243, 156, 18, math.abs(math.cos(RealTime()) * 255) ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(211, 84, 0))
		end

		if (self.FurnaceEnt:GetWorkTime() > 0) then
			
			draw.SimpleTextOutlined(string.ToMinutesSeconds(self.FurnaceEnt:GetWorkTime()) , "ixMediumLightFont", 13, 85, Color( 230,230,230 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(20,20,20))
			-- else
			-- 	draw.SimpleTextOutlined(string.ToMinutesSeconds(self.FurnaceEnt:GetWorkTime()), "ixMediumLightFont", 10, 105, Color( 230,230,230 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(20,20,20))
			-- end
		elseif (self.FuelSpace.item) then
			draw.SimpleTextOutlined(string.ToMinutesSeconds(PLUGIN.fuel[self.FuelSpace.item] * self.FuelSpace.ItemCount), "ixMediumLightFont", 13, 85, Color( 230,230,230 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(20,20,20))
		end

		if (self.FurnaceEnt:GetMeltTime() > 0) then
			draw.SimpleTextOutlined(string.ToMinutesSeconds(self.FurnaceEnt:GetMeltTime()), "ixMediumLightFont", 13, 325, Color( 230,230,230 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(20,20,20))
		end

	end

	local FurnaceTitle = vgui.Create( "DLabel", FurnacePnl )
	FurnaceTitle:SetPos(5,5)
	FurnaceTitle:SetFont("ixSmallFont")
	FurnaceTitle:SetText( "Furnace" )
	FurnaceTitle:SetContentAlignment(4)
	FurnaceTitle:SizeToContents()


	//Fuel

	local FuelInfo = vgui.Create( "DLabel", FurnacePnl )
	FuelInfo:SetPos(10,60)
	FuelInfo:SetFont("ixMediumLightFont")
	FuelInfo:SetText( "Fuel" )
	FuelInfo:SetContentAlignment(4)
	FuelInfo:SizeToContents()

	local FuelSpace = vgui.Create( "DButton", FurnacePnl )
	FuelSpace:SetSize(64,64)
	FuelSpace:SetPos(FurnacePnl:GetWide() * 0.5, 50)
	FuelSpace:SetText("")
	FuelSpace.ItemCount = 1
	FuelSpace.IsFuelSlot = true
	FuelSpace:SetEnabled(false)
	FuelSpace:SetCursor("arrow")
	FuelSpace.Checker = CurTime()
	FuelSpace:Receiver("ixInventoryItem", function(slot,panels, bDropped, menuIndex, x, y)
		self:OutfitDropFunction(slot,panels, bDropped, menuIndex, x, y)
	end)
	FuelSpace.GetItemsCount = function(s)
		return self.FurnaceEnt:GetFuelCount()
	end
	FuelSpace.Think = function(s)

		if (s.icon) and (s.Checker < CurTime() ) then

			if (self.FurnaceEnt:GetFuelCount() <= 0) then
				self:RemoveItem(s)
			end

			s.Checker = CurTime() + 0.5
		end

	end
	FuelSpace.PaintOver = function(s,w,h)

		if (s.icon) then
			draw.SimpleTextOutlined("x"..self.FurnaceEnt:GetFuelCount(), "ixSmallFont", w-5, h-5, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(20,20,20))
		end

	end
	FuelSpace.Paint = function(s,w,h)

		surface.SetDrawColor(160,160,160,200)
	    surface.DrawOutlinedRect(0,0,w,h)

		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	end
	FuelSpace.DoClick = function(s)
		surface.PlaySound( "ui/buttonclickrelease.wav")
		self:RemoveItem(s)

		net.Start("ixFurnace_RemoveFuel")
			net.WriteEntity(self.FurnaceEnt)
		net.SendToServer()

	end

	self.FuelSpace = FuelSpace

	// Input

	local InputInfo = vgui.Create( "DLabel", FurnacePnl )
	InputInfo:SetPos(10,175)
	InputInfo:SetFont("ixMediumLightFont")
	InputInfo:SetText( "Input" )
	InputInfo:SetContentAlignment(4)
	InputInfo:SizeToContents()

	local InputSpace = vgui.Create( "DButton", FurnacePnl )
	InputSpace:SetSize(64,64)
	InputSpace:SetPos(FurnacePnl:GetWide() * 0.5, 170)
	InputSpace:SetText("")
	InputSpace.ItemCount = 1
	InputSpace.IsInputSlot = true
	InputSpace:SetEnabled(false)
	InputSpace:SetCursor("arrow")
	InputSpace.Checker = CurTime()
	InputSpace:Receiver("ixInventoryItem", function(slot,panels, bDropped, menuIndex, x, y)
		self:OutfitDropFunction(slot,panels, bDropped, menuIndex, x, y)
	end)
	InputSpace.GetItemsCount = function(s)
		return self.FurnaceEnt:GetInputCount()
	end
	InputSpace.Think = function(s)

		if (s.icon) and (s.Checker < CurTime() ) then

			if (self.FurnaceEnt:GetInputCount() <= 0) then
				self:RemoveItem(s)
			end

			s.Checker = CurTime() + 0.5
		end

	end
	InputSpace.PaintOver = function(s,w,h)

		if (s.icon) then
			draw.SimpleTextOutlined("x"..self.FurnaceEnt:GetInputCount(), "ixSmallFont", w-5, h-5, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(20,20,20))
		end

	end
	InputSpace.Paint = function(s,w,h)

		surface.SetDrawColor(160,160,160,200)
	    surface.DrawOutlinedRect(0,0,w,h, 1)

		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	end
	InputSpace.DoClick = function(s)
		surface.PlaySound( "ui/buttonclickrelease.wav")
		self:RemoveItem(s)

		net.Start("ixFurnace_RemoveInput")
			net.WriteEntity(self.FurnaceEnt)
		net.SendToServer()

	end

	self.InputSpace = InputSpace

	// Output

	local OutputInfo = vgui.Create( "DLabel", FurnacePnl )
	OutputInfo:SetPos(10,295)
	OutputInfo:SetFont("ixMediumLightFont")
	OutputInfo:SetText( "Output" )
	OutputInfo:SetContentAlignment(4)
	OutputInfo:SizeToContents()

	local OutputSpace = vgui.Create( "DButton", FurnacePnl )
	OutputSpace:SetSize(64,64)
	OutputSpace:SetPos(FurnacePnl:GetWide() * 0.5, 290)
	OutputSpace.MeltedItems = 0
	OutputSpace.IsOutputSlot = true
	OutputSpace:SetText("")
	OutputSpace:SetEnabled(false)
	OutputSpace:SetCursor("arrow")
	OutputSpace.Paint = function(s,w,h)

		surface.SetDrawColor(160,160,160,200)
	    surface.DrawOutlinedRect(0,0,w,h, 1)

		surface.SetDrawColor(40,40,40,150)
	    surface.DrawRect(0,0,w,h)

	end
	OutputSpace.GetItemsCount = function(s)
		return self.FurnaceEnt:GetOutputCount()
	end
	OutputSpace.PaintOver = function(s,w,h)

		if (s.icon) and (self.FurnaceEnt:GetOutputCount() > 0) then
			draw.SimpleTextOutlined("x"..self.FurnaceEnt:GetOutputCount(), "ixSmallFont", w-5, h-5, Color( 240,240,240 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(20,20,20))
		end

	end
	OutputSpace.DoClick = function(s)
		surface.PlaySound( "ui/buttonclickrelease.wav")

		if (self.FurnaceEnt:GetOutputCount() > 0) then

			self:RemoveItem(s)

			net.Start("ixFurnace_TakeOutput")
				net.WriteEntity(self.FurnaceEnt)
			net.SendToServer()

		end

	end

	self.OutputSpace = OutputSpace

	// Local Inv

	ix.gui.inv1 = self:Add("ixInventory")
	ix.gui.inv1.bNoBackgroundBlur = true
	ix.gui.inv1:ShowCloseButton(true)
	ix.gui.inv1.Close = function(this)
		-- net.Start("ixStorageClose")
		-- net.SendToServer()
		self:Remove()
	end

	self:SetAlpha(0)
	self:AlphaTo(255, self:GetFadeTime())


	FurnacePnl:MakePopup()
	ix.gui.inv1:MakePopup()
end

function PANEL:OnChildAdded(panel)
	panel:SetPaintedManually(true)
end

function PANEL:SetLocalInventory(inventory)
	if (IsValid(ix.gui.inv1) and !IsValid(ix.gui.menu)) then
		ix.gui.inv1:SetInventory(inventory)
		ix.gui.inv1:SetPos(self:GetWide() / 2 - ix.gui.inv1:GetWide()-6  + self:GetFrameMargin() / 2, self:GetTall() / 2 - ix.gui.inv1:GetTall() / 2)
	end
end

function PANEL:Think()
	
	-- if (self.FuelSpace.item) then
	-- 	if (self.FurnaceEnt:GetIsWorking()) and (self.FurnaceEnt:GetWorkTime() % PLUGIN.fuel[self.FuelSpace.item] == 0) then

	-- 		if (self.CoolDown < CurTime()) then
	-- 			self:RemoveItem(self.FuelSpace)
	-- 			self.CoolDown = CurTime() + 1
	-- 		end

	-- 	end
	-- end

	-- if (self.FurnaceEnt:GetIsWorking()) then
	-- 	print(self.FurnaceEnt:GetMeltTime() )
	-- 	if (self.FurnaceEnt:GetMeltTime() <= 0) and (!table.IsEmpty(self.furnaceData.InputData)) and (!table.IsEmpty(self.furnaceData.OutputData)) and (self.furnaceData.InputData.Count >= self.furnaceData.OutputData.NeededAmount) then

	-- 		if (self.CoolDown < CurTime()) then

	-- 			self.furnaceData.OutputData.MeltedAmount = self.furnaceData.OutputData.MeltedAmount + 1 or 1

	-- 			self.furnaceData.InputData.Count = self.furnaceData.InputData.Count - self.furnaceData.OutputData.NeededAmount

	-- 			if (self.furnaceData.InputData.Count <= 0) then
	-- 				self.furnaceData.InputData = {}
	-- 			end

	-- 			self.OutputSpace.MeltedItems = self.furnaceData.OutputData.MeltedAmount

	-- 			self.CoolDown = CurTime() + 1
	-- 		end

	-- 	end 
	-- end

end

function PANEL:PopulateData(furnaceData)

	-- self.furnaceData = furnaceData

	if (furnaceData.FuelItem) then

		if (self.FurnaceEnt:GetFuelCount() > 0) then

			local item = ix.item.list[furnaceData.FuelItem]

			if (item) then
				self:AddIcon(item, self.FuelSpace)

			end

		end

	end

	if (furnaceData.InputItem) then

		if (self.FurnaceEnt:GetInputCount() > 0) then

			local item = ix.item.list[furnaceData.InputItem]

			if (item) then
				self:AddIcon(item, self.InputSpace)

				if (furnaceData.OutputData) or (table.IsEmpty(furnaceData.OutputData)) then
					self:FindRecipe(furnaceData.InputItem, self.FurnaceEnt:GetInputCount())
				end

			end

		end

	end

	if (furnaceData.OutputData) and (!table.IsEmpty(furnaceData.OutputData)) then

		local item = ix.item.list[furnaceData.OutputData.OutputID]

		self.OutputData = furnaceData.OutputData

		if (item) then
			
			if (!self.OutputSpace.icon) then
				self:AddIcon(item, self.OutputSpace)
			end

		end
	end

end

function PANEL:FindRecipe(ItemuniqueID, ItemsAmount)

	local data = false

	for k, v in ipairs(PLUGIN.FurnaceRecipes or {}) do

		if (v.InputID != ItemuniqueID) then continue end

		if (ItemsAmount >= v.InputAmmount) then

			data = {
				NeededIngre = v.InputID,
				NeededAmount = v.InputAmmount,
				OutputID = v.Output,
				MeltTime = v.OutputTime,
			}


			break
		end
		
	end

	if (data) then

		if (self.OutputSpace.icon) then
			self:RemoveItem(self.OutputSpace)
		end

		self.OutputData = data

		local item = ix.item.list[data.OutputID]

		if (item) then

			self:AddIcon(item, self.OutputSpace)

		end

	end

end

-- local fuel = {
-- 	["wood"] = true,
-- 	["wood_log"] = true,
-- 	["ore_coal"] = true,
-- }

function PANEL:OutfitDropFunction(slot,panels, bDropped, menuIndex, x, y)

	local panel = panels[1]

	if (bDropped) then


		local itemTable = panel.itemTable
		local inventory = panel.inventoryID

		local item = ix.item.instances[itemTable.id]

		if (item) then

			local char = LocalPlayer():GetCharacter()
			local inv  = char:GetInventory()

			//

			if (slot.IsFuelSlot) and (PLUGIN.fuel[item.uniqueID])
			or (slot.IsInputSlot) and (!PLUGIN.fuel[item.uniqueID]) then

				if (slot.item) then
					if (slot.item != item.uniqueID) then return end
				end

				self:AddIcon(item, slot)

				if (slot.IsFuelSlot) then

					net.Start("ixFurnace_AddFuel")
						net.WriteEntity(self.FurnaceEnt)
						net.WriteUInt(itemTable.id, 12)
					net.SendToServer()

				end

				if (slot.IsInputSlot) then

					net.Start("ixFurnace_AddInput")
						net.WriteEntity(self.FurnaceEnt)
						net.WriteUInt(itemTable.id, 12)
					net.SendToServer()

					-- if (!self.OutputSpace.icon) then

					timer.Simple(0.2, function()
						if (!IsValid(self)) then return end
						self:FindRecipe(item.uniqueID, slot:GetItemsCount())

					end)

					-- end

				end

				surface.PlaySound("physics/wood/wood_crate_impact_soft"..math.random(1,3)..".wav")

			end
			
		end	

	end	

end

function PANEL:AddIcon(item, Slot)

	local item = item or nil
	local Slot = Slot or nil
	-- local itemTable = itemTable or nil
	-- local inventory = inventory or nil

	if (!item) or (!Slot) then return end

	-- if (Slot.icon) then

	-- 	if (Slot.ItemCount) then
	-- 		Slot.ItemCount = Slot.ItemCount + 1
	-- 	end

	if (!Slot.icon) then

		if (Slot.Checker) then
			Slot.Checker = CurTime() + 1	
		end

		self:AddSlotIcon(Slot, item:GetModel() or "models/props_junk/popcan01a.mdl", 0,0, item:GetSkin())


		Slot:SetCursor("hand")

		-- Slot.ItemTable = itemTable
		-- Slot.Inventory = inventory
		Slot.item = item.uniqueID
		-- Slot.ItemID = itemTable.id


		Slot:SetHelixTooltip(function(tooltip)
			ix.hud.PopulateItemTooltip(tooltip, item)
		end)

	end

end

function PANEL:RemoveItem(slot)

	if (slot:GetItemsCount()) and (slot:GetItemsCount() > 1) then
		-- slot.ItemCount = slot.ItemCount - 1

		timer.Simple(0.2, function()
			if (!IsValid(self)) then return end

				if (slot.IsInputSlot) and (self.OutputSpace.item) and (self.FurnaceEnt:GetOutputCount() == 0) then

					self:RemoveItem(self.OutputSpace)

					self:FindRecipe(slot.item, slot:GetItemsCount())

				end

			end)

	-- elseif (slot.MeltedItems) and (slot.MeltedItems > 1) then
	-- 	slot.MeltedItems = slot.MeltedItems - 1
	else

		if (IsValid(slot.icon)) then slot.icon:Remove() end

		if (slot.IsInputSlot) and (self.FurnaceEnt:GetOutputCount() == 0) then

			self:RemoveItem(self.OutputSpace)
		end

		if (slot.IsOutputSlot) and (self.InputSpace.item) then

			timer.Simple(0.2, function()
				if (!IsValid(self)) then return end
				self:FindRecipe(self.InputSpace.item, self.InputSpace:GetItemsCount())
			end)

		end

		slot.icon = nil
		slot.item = nil

		slot:SetEnabled(false)
		slot:SetCursor("arrow")

		slot:SetHelixTooltip(function(tooltip)
		end)

	end


end

function PANEL:AddSlotIcon(slot, model, x, y, skin)

	if (!IsValid(slot)) then return end

	if (IsValid(slot.icon)) then slot.icon:Remove() end

	local skin = skin or 0

	local icon = vgui.Create( "SpawnIcon", slot)
	icon:Dock(FILL)
	icon:DockMargin(2,2,2,2)
	icon:SetModel( model, skin )
	icon:SetMouseInputEnabled(false)

	slot.icon = icon

	slot:SetEnabled(true)
	slot:SetMouseInputEnabled(true)


end	


function PANEL:Paint(width, height)
	ix.util.DrawBlurAt(0, 0, width, height)

	for _, v in ipairs(self:GetChildren()) do
		v:PaintManual()
	end
end

function PANEL:Remove()
	self:SetAlpha(255)
	self:AlphaTo(0, self:GetFadeTime(), 0, function()
		BaseClass.Remove(self)
	end)
end

function PANEL:OnRemove()
	if (!IsValid(ix.gui.menu)) then
		-- self.storageInventory:Remove()
		ix.gui.inv1:Remove()
	end
end

vgui.Register("ixFurnaceView", PANEL, "Panel")


