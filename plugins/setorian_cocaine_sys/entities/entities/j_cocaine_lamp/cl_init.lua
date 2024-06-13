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
			self.dlight.pos = self:GetPos()  + self:GetForward()*80
			self.dlight.r = 255
			self.dlight.g = 0
			self.dlight.b = 0
			self.dlight.brightness = 10
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
	text:SetText("Big Lamp")
	text:SizeToContents()

	local status = tooltip:AddRowAfter("name", "status")
	status:SetBackgroundColor( (self:GetIsWorking() and Color(250,250,0)) or Color(250,0,0))
	status:SetText( (self:GetIsWorking() and "WORKING") or "NOT WORKING")
 	status:SizeToContents()

 	local MaxbatteryPower = ix.config.Get("BatteryLifeTime", 300)

 	local batteryPower = self:GetLifeTime()

 	local precPower = math.Round((batteryPower * 100) / MaxbatteryPower)

 	local battery = tooltip:AddRowAfter("status", "lifeTime")
 	battery:SetBackgroundColor(Color(41, 128, 185))
	battery:SetText( "Battery: "..precPower.."%")
 	battery:SizeToContents()

 	local desc = tooltip:AddRowAfter("lifeTime", "desc")
	desc:SetText( "Use this lamp to provide a source of light for your plants")
 	desc:SizeToContents()

 	tooltip:SizeToContents()

end