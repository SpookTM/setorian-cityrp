include("shared.lua")


function ENT:Initialize()

	self.dlight = DynamicLight( self:EntIndex() )

end

function ENT:Draw()

	self:DrawModel()

end

function ENT:Think()

	if (self:GetIsWorking()) then
		
		if ( self.dlight ) then
			self.dlight.pos = self:GetPos()  + self:GetForward()*10 + self:GetUp()*35
			self.dlight.r = 9
			self.dlight.g = 132
			self.dlight.b = 220
			self.dlight.brightness = 8
			self.dlight.Decay = 100
			self.dlight.Size = 70
			self.dlight.style = 6
			self.dlight.DieTime = CurTime() + 1
		end

	end

end

ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)

	local text = tooltip:AddRow("name")
	text:SetImportant()
	text:SetText("Freezer")
	text:SizeToContents()

	local status = tooltip:AddRowAfter("desc", "status")
	status:SetBackgroundColor( (self:GetIsWorking() and Color(250,250,0)) or Color(250,0,0))
	status:SetText( (self:GetIsWorking() and "WORKING") or "NOT WORKING")
 	status:SizeToContents()

 	local MaxbatteryPower = ix.config.Get("BatteryLifeTime", 600)

 	local batteryPower = self:GetLifeTime()

 	local precPower = math.Round((batteryPower * 100) / MaxbatteryPower)

 	local battery = tooltip:AddRowAfter("status", "lifeTime")
 	battery:SetBackgroundColor(Color(41, 128, 185))
	battery:SetText( "Battery: "..precPower.."%")
 	battery:SizeToContents()

 	local trays = tooltip:AddRowAfter("lifeTime", "traysNumber")
 	trays:SetBackgroundColor(Color(41, 128, 185))
	trays:SetText( "Trays inside with cooked meth: "..self:GetTrays())
 	trays:SizeToContents()

 	local trays = tooltip:AddRowAfter("traysNumber", "RtraysNumber")
 	trays:SetBackgroundColor(Color(41, 128, 185))
	trays:SetText( "Trays inside with frozen meth: "..self:GetReadyTrays())
 	trays:SizeToContents()

 	local desc = tooltip:AddRowAfter("name", "desc")
	desc:SetText( "Use the freezer to freeze the cooked meth")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end