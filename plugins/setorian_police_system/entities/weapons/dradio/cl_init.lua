
include("shared.lua")
surface.CreateFont( "radio_45", { font = "digital-7", size = 45, weight = 400, antialias = true,})
surface.CreateFont( "radio_60", { font = "DermaDefault", size = 60, weight = 400, antialias = true,})
surface.CreateFont( "radio_36", { font = "DermaDefault", size = 36, weight = 400, antialias = true,})
surface.CreateFont( "radio_16", { font = "DermaDefault", size = 16, weight = 400, antialias = true,})
local radio = {}
radio.w = 140
radio.h = 60
local frequency = 0
local frequencyIncrement = .001
local inputText = "Input Frequency"
 
function SWEP:PostDrawViewModel( vm, weapon, ply )

	if weapon:GetClass() == "dradio" and IsValid(self) then 
		local BoneIndx = vm:LookupBone("ValveBiped.Bip01_R_Hand")
		local BonePos, BoneAng = vm:GetBonePosition( BoneIndx )
		TextPos = BonePos + BoneAng:Forward() * 4.9 + BoneAng:Right() * 2.66 + BoneAng:Up() * -2.89
		TextAngle = BoneAng
		TextAngle:RotateAroundAxis(TextAngle:Right(), 191)
		TextAngle:RotateAroundAxis(TextAngle:Up(), -3.1)
		TextAngle:RotateAroundAxis(TextAngle:Forward( ), 90)
		cam.Start3D2D( TextPos, TextAngle, .01 )
			if self:GetNWBool("power") then 
				surface.SetDrawColor(175,199,139,255)
				surface.DrawRect(0, 0, radio.w, radio.h)
				draw.SimpleText(frequency, "radio_45", radio.w / 2, radio.h / 2, Color(50,50,50,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				surface.SetFont("radio_60")
			end
			if self:GetNWBool("editting") then 
				surface.SetDrawColor(0,0,0,100)
				surface.DrawRect(200, -260, 525, 240)
				draw.SimpleText("Frequency Increment: " .. frequencyIncrement, "radio_36", 200, -240, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("[R] - Tune Radio Frequency Forward", "radio_36", 200, -200, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("[E] - Tune Radio Frequency Back", "radio_36", 200, -160, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("[LEFT MOUSE] - Increase Increment", "radio_36", 200, -120, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("[RIGHT MOUSE] - Decrease Increment", "radio_36", 200, -80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("[MIDDLE MOUSE] - " .. inputText, "radio_36", 200, -40, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				
			else
				surface.SetDrawColor(0,0,0,100)
				surface.DrawRect(-125 - 600, -100, 600 + 30, 70)
				if self:GetNWBool("power") then 
					draw.SimpleText("[LEFT MOUSE] - Toggle Off", "radio_60", -100, -70, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					surface.DrawRect(-125 - 525, -30, 555, 70)
					draw.SimpleText("[C] - Change Frequency", "radio_60", -100, 0, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					local ypos = 70
					local numChannels = 0
					local foundChannel 
					for k,v in pairs(RADIO.RADIOCHANNELS) do
						if table.HasValue(v.teams, LocalPlayer():GetCharacter():GetFaction()) then
							local tw, th = surface.GetTextSize("SECURE CHANNEL ON: " .. v.frequency)
							surface.DrawRect(-125 - tw, ypos - 30, tw + 30, 70)
							draw.SimpleText("SECURE CHANNEL AT: " .. v.frequency, "radio_60", -100, ypos, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
							numChannels = numChannels + 1
							ypos = ypos + 70
						end
						
						if frequency == v.frequency then
							foundChannel = v.name 
						end

					end 
					if foundChannel then
						local tw, wh = surface.GetTextSize(foundChannel .. " CHANNEL")
						surface.DrawRect(-125 - tw, 70 * (numChannels + 1) - 30, tw + 30, 70)
						draw.SimpleText(foundChannel .. " CHANNEL", "radio_60", -100, 70 * (numChannels + 1), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					end 
				else
					draw.SimpleText("[LEFT MOUSE] - Toggle On", "radio_60", -100, -70, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end
			end 
		cam.End3D2D()
	end 
end

local lastChange = CurTime()

local function ChangeFrequency(newVal, increase)
	increase = increase or false
	net.Start("dradio_adjustfrequency")
	net.WriteFloat(newVal)
	net.WriteBool(increase)
	net.SendToServer()

end 
  
local function fMenu()

	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if not wep:GetNWBool("editting") then return end
	if radio.menu then return end 
	radio.menu = vgui.Create("DFrame")
	local rmenu = radio.menu
	rmenu:SetSize(150, 30)
	rmenu:Center()
	rmenu:MakePopup()
	rmenu:SetTitle("")
	rmenu:ShowCloseButton(false)
	rmenu.Paint = function(me,w,h)
		surface.SetDrawColor(0,0,0,100)
		surface.DrawRect(0,0,w,h)
	end 
	rmenu.OnClose = function()
		radio.menu = nil
		rmenu:Remove()
	end 
	radio.menu.finput = vgui.Create("DTextEntry", rmenu)
	local finput = radio.menu.finput
	finput:SetPos(0,0)
	finput:SetSize(rmenu:GetWide(), rmenu:GetTall())
	finput:SetFont("radio_16")
	finput:SetNumeric(true)
	function finput:OnEnter()
		if string.len(self:GetValue()) <= 0 then return end 
		rmenu:Remove()
		radio.menu = nil
		ChangeFrequency(math.Round(tonumber(self:GetValue()), 3))
	end 
	local tcolor = Color(175,199,139,140)
	finput.Paint = function(me,w,h) 
		surface.SetDrawColor(60,60,60,255)
		surface.DrawRect(0,0,w,h)
		me:DrawTextEntryText(color_white, tcolor, tcolor)
		if string.len(me:GetText()) <= 0 then
			draw.SimpleText("Input Frequency", "radio_16", w / 2, h / 2, Color(140, 140, 140, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end  
	end
	function finput:OnChange()
		if not self:GetValue() then return end 
	
		if not tonumber(self:GetValue()) then self:SetText("") return end 	
		if tonumber(self:GetValue()) >= 1000 then
			self:SetText(999.999)
		elseif tonumber(self:GetValue()) < .001 then
			self:SetText(.001)
		end 
	end

end  
function SWEP:Think()


	if lastChange + .15 < CurTime() and not radio.menu then

		if input.IsKeyDown(KEY_R) then
			ChangeFrequency(frequency + frequencyIncrement, true)
			lastChange = CurTime()
		elseif input.IsKeyDown(KEY_E) then
			ChangeFrequency(frequency - frequencyIncrement, false)
			lastChange = CurTime()
		end 
		if input.IsMouseDown(MOUSE_LEFT) then
			frequencyIncrement = frequencyIncrement * 10
			if frequencyIncrement > 100 then
				frequencyIncrement = 100
			end 
			lastChange = CurTime()
		elseif input.IsMouseDown(MOUSE_RIGHT) then
			frequencyIncrement = frequencyIncrement * .1
			if frequencyIncrement < .001 then
				frequencyIncrement = .001
			end 
			lastChange = CurTime()
		elseif input.IsMouseDown(MOUSE_MIDDLE) then
			fMenu()
			lastChange = CurTime()
		end 

	end 
 
end 


 
hook.Add("ContextMenuOpen", "Manage Radio", function()

	local ply = LocalPlayer()
	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and weapon:GetClass() == "dradio"  then
		if weapon:GetNWBool("power") then 
			net.Start("dradio_edit")
			net.SendToServer()
		end 
		return false
	end 

end)
local PLUGIN = PLUGIN
staticSound = staticSound or nil
hook.Add("InitPostEntity", "RadioSounds", function()
	staticSound = CreateSound(LocalPlayer(), "dradio/radio_static.wav" ) 
end)


hook.Add("PlayerStartVoice", "RadioVoiceChatStart", function(ply)

	local LP = LocalPlayer()
	
	if frequency == 0 or not frequency then return end
	if ply == LocalPlayer() then 
		if RADIO and RADIO.WhileHolding and IsValid(LP:GetActiveWeapon()) and LP:GetActiveWeapon():GetClass() == "dradio" then 
			surface.PlaySound("dradio/radio_on.wav")
		elseif RADIO and not RADIO.WhileHolding and ply:HasWeapon("dradio") then
			surface.PlaySound("dradio/radio_on.wav")
		end
	end
	if ply != LocalPlayer() and ply.frequency == frequency then

		if RADIO and RADIO.WhileHolding and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "dradio" then
			staticSound:Play() 
			staticSound:ChangeVolume(1, .1)
		elseif RADIO and not RADIO.WhileHolding then
			staticSound:Play() 
			staticSound:ChangeVolume(1, .1)
		end 
	
	end
	

end ) 

net.Receive("dradio_clearfrequency", function()

	frequency = nil

end)

net.Receive("dradio_networkfrequency", function()
	local freq = net.ReadDouble()
	local speaker = net.ReadEntity()
	speaker.frequency = freq
end)

hook.Add("PlayerEndVoice", "RadioVoiceChatEnd", function(ply)
	staticSound:Stop()
	local LP = LocalPlayer()
	if frequency and frequency != 0 and ply.frequency != 0 and ply.frequency == frequency then 


		if RADIO and RADIO.WhileHolding and IsValid(LP:GetActiveWeapon()) and LP:GetActiveWeapon():GetClass() == "dradio" and 
		ply:GetActiveWeapon() and ply:GetActiveWeapon():GetClass() == "dradio" then
			surface.PlaySound("dradio/radio_off.wav")
		elseif RADIO and not RADIO.WhileHolding then
			surface.PlaySound("dradio/radio_off.wav")
		end 
		
	end

end)

net.Receive("dradio_updatefrequency", function()

	local freq = net.ReadDouble()
	frequency =	freq

end)

net.Receive("dradio_sendMessage", function()

	local ply = LocalPlayer()
	local message = net.ReadString()
	local freq = net.ReadDouble()
	local speaker = net.ReadEntity()
	message = string.sub(message, 3)
	speaker.frequency = freq
	if frequency == 0 and speaker == ply then
		chat.AddText(RADIO.FailMessage)
	end 
	if frequency and frequency != 0 and speaker.frequency != 0 and speaker.frequency == frequency then 
		chat.AddText(Color(175,199,139,255), "[" .. frequency .. "] ", team.GetColor(speaker:Team()), speaker:Name() .. ": ", Color(255,255,255), message)
	end

end)