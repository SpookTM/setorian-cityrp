local PLUGIN = PLUGIN or ix.plugin.list.lockpicking -- Please don't rename plugin folder else PLUGIN variable will be nil in NS beta
if (!PLUGIN) then
	ErrorNoHalt( 'Lockpicking plugin directory may have been changed and thus it causes lua errors. Please name it "lockpicking"\n' )
end

local ITEM = ITEM

ITEM.name = "Bobby pin box"
ITEM.desc = "A box that contains bobbypins used to lockpick."
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 90
ITEM.isStackable = true
ITEM.bDropOnDeath = true
--
ITEM.isBobbypinBox = true
ITEM.pinAmount = 4
ITEM.solidity = 1
ITEM.pinHealth = 100
ITEM.flag = "y"


function ITEM:GetQuantity()
	return self:GetData("quantity", ITEM.pinAmount)
end

function ITEM:SetQuantity(n)
	self:SetData("quantity", n)
end


function ITEM:BreakPin()
	local oldQuantity = self:GetQuantity()

	if ( oldQuantity == 1 ) then
		self:Remove()
		return false
	else
		self:SetData("health", ITEM.pinHealth)
		self:SetQuantity(oldQuantity - 1)
		return true
	end
end


local conditions = {
	[85] = {"lpExcellent", Color(0, 179, 0)},
	[55] = {"lpWell", Color(255, 255, 0)},
	[35] = {"lpWeak", Color(255, 140, 26)},
	[25] = {"lpBad", Color(255, 51, 0)},
	[0] = {"lpVBad", Color(102, 0, 0)}
}

function ITEM:GetCondition()
	local condition = conditions[0]
	local health = self:GetData("health", ITEM.pinHealth)

	for k, v in SortedPairs(conditions) do
		if ( health >= k ) then
			condition = v
		else
			break
		end
	end

	return condition[1], condition[2]
end


function ITEM:IsInBusinnessMenu()
	return (self:GetID() == 0)
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		local quantity = item:GetQuantity()
		draw.SimpleText(quantity, "DermaDefault", 5, h-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
	end

	function ITEM:PopulateTooltip(tooltip)

		local state, color = self:GetCondition()
		local localizedText = L("lpCondition", L(state))

		local panel = tooltip:AddRowAfter("name", "condition_status")
		panel:SetBackgroundColor(color or Color(39, 174, 96))
		panel:SetText(localizedText)
		panel:SizeToContents()

		
	end
end

function ITEM:GetDescription()
	local desc = self.desc

	return desc
end

local function IsDoorLocked(ent)
	return ent:isLocked()--ent:GetSaveTable().m_bLocked or ent.locked or false
end

local function getDoorLockpicker(door)
	local s = door.LockpickSession

	if (s) then
		return s.Player
	end
end

ITEM.functions.use = {
	name = "lpPick",
	tip = "useTip",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		local client = item.player
		local ent = PLUGIN:GetEntityLookedAt(client, PLUGIN.CONFIG.MaxLookDistance)

		if ( not IsDoorLocked(ent) ) then
			client:NotifyLocalized("lpNotLocked")
			return false
		elseif ( getDoorLockpicker(ent) ) then
			client:NotifyLocalized("lpAlrLpcked")
			return false
		end

		local s = PLUGIN:StartSession(ent, client, item)

		if (type(s) == "string") then
			client:notify(s)
		end
		
		return false
	end,
	OnCanRun = function(item)
		local ply; if (SERVER) then ply = item.player else ply = LocalPlayer() end
		local ent = PLUGIN:GetEntityLookedAt(ply, PLUGIN.CONFIG.MaxLookDistance)

		print(ent)

		if ( not IsValid(ent) or (not ent:IsDoor() and not ent:IsVehicle()) ) then
			return false
		end

		-- if ( SERVER ) then
		-- 	if ( not IsDoorLocked(ent) ) then
		-- 		ply:NotifyLocalized("lpNotLocked")
		-- 		return false
		-- 	elseif ( ent.ixLock ) then
		-- 		ply:NotifyLocalized("lpCombineLck")
		-- 		return false	
		-- 	elseif ( getDoorLockpicker(ent) ) then
		-- 		ply:NotifyLocalized("lpAlrLpcked")
		-- 		return false
		-- 	end
		-- end

		return true
	end
}


function ITEM:onRemoved()
    local s = self.LockpickSession

	if ( s ) then
		s:Stop()
	end
end