local PLUGIN = PLUGIN
PLUGIN.name = "ID Card"
PLUGIN.author = "Chancer, ported"
PLUGIN.schema = "Any"

if (SERVER) then
	function PLUGIN:showID(client, item)
		local idInfo = item:GetData("idInfo", {})
		
		netstream.Start(client, "ix_idOpen", idInfo)
	end	
else
	netstream.Hook("ix_idOpen", function(data)
		local IDBackground = Material("driverid.png")

		local character = LocalPlayer():GetCharacter()
	
		local idFrame = vgui.Create("DFrame")
		idFrame:SetSize(500, 300)
		idFrame:Center()
		idFrame:SetTitle("")
		idFrame:MakePopup()
		idFrame:ShowCloseButton(true)
		idFrame.Paint = function(t, w, h)
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(IDBackground)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		local scroll = vgui.Create("DScrollPanel", idFrame)
		scroll:Dock(FILL)

		// if (character:GetHeadmodel() and string.find(character:GetHeadmodel(), "models") and character:GetHeadmodel() != NULL and character:GetHeadmodel() != "" and character:GetHeadmodel() != nil) then
		
		local modelToView = ""
		if (data.headmodel) then
			modelToView = data.headmodel
		elseif (data.model) then
			modelToView = data.model
		end
		
		if (modelToView != "") then
			local model = scroll:Add("SpawnIcon")
			model:SetModel(modelToView)
			model:SetMouseInputEnabled(false)
			-- model:SetWide(288)
			-- model:SetTall(162)
			model:SetSize(140,140)
			model:SetPos(30, 51)
			--model:Dock(LEFT)
			-- model:SetFOV(70)
			-- model:SetAnimated(false)

			-- local sequence = model.Entity:SelectWeightedSequence(ACT_IDLE)
		
			-- if (sequence > 0) then
			-- 	model.Entity:ResetSequence(sequence)
			-- else
			-- 	local found = false

			-- 	for _, v in ipairs(model.Entity:GetSequenceList()) do
			-- 		if ((v:lower():find("idle") or v:lower():find("fly")) and v != "idlenoise") then
			-- 			model.Entity:ResetSequence(v)
			-- 			found = true

			-- 			break
			-- 		end
			-- 	end

			-- 	if (!found) then
			-- 		model.Entity:ResetSequence(4)
			-- 	end
			-- end

			-- function model:LayoutEntity( Entity ) 
			-- end
			
			-- local eyepos = model.Entity:GetBonePosition(model.Entity:LookupBone("ValveBiped.Bip01_Head1"))
			-- model:SetCamPos(eyepos-Vector(-24, 0, 0))
			-- model:SetLookAt(eyepos)
		end
-- 		if (data.model) then
-- 		local picture = vgui.Create( "DModelPanel", self )
-- 	model:SetSize( 210, 220 )
-- 	model:SetPos(0,0)
-- 	model:SetModel( model )
-- 	function model:LayoutEntity( Entity ) return end
-- 	local eyepos = self.picture.Entity:GetBonePosition(self.picture.Entity:LookupBone("ValveBiped.Bip01_Head1"))
-- 	model:SetLookAt(eyepos)
-- 	model:SetCamPos(eyepos-Vector(-20, 0, 0))
-- 	model.Entity:SetEyeTarget(eyepos-Vector(-12, 0, 0))
-- end
		local posX = 160
		local posY = 70
		
		if(data.name) then
			local nameL = vgui.Create("DLabel", scroll)
			nameL:SetText("Name")
			nameL:SetTextColor(Color(0,0,0))
			nameL:SetFont("Trebuchet18")
			nameL:SetPos(posX, posY)
			
			posY = posY + 15
			
			local nameF = vgui.Create("DLabel", scroll)
			nameF:SetText(data.name)
			nameF:SetTextColor(Color(0,0,0))
			--nameF:SetFont("Trebuchet18")
			nameF:SetPos(posX, posY)
			
			posY = posY + 20
		end
			
		if(data.sex) then
			local sexL = vgui.Create("DLabel", scroll)
			sexL:SetText("Sex")
			sexL:SetTextColor(Color(0,0,0))
			sexL:SetFont("Trebuchet18")
			sexL:SetPos(posX, posY)
			
			posY = posY + 15
			
			local sexF = vgui.Create("DLabel", scroll)
			sexF:SetText(data.sex)
			sexF:SetTextColor(Color(0,0,0))
			--sexF:SetFont("Trebuchet18")
			sexF:SetPos(posX, posY)
			
			posY = posY + 20
		end		
		
		--eye color
		if (data.eyeColor) then
			local sexL = vgui.Create("DLabel", scroll)
			sexL:SetText("Eye Color")
			sexL:SetTextColor(Color(0,0,0))
			sexL:SetFont("Trebuchet18")
			sexL:SetPos(posX, posY)
			
			posY = posY + 15
			
			local sexF = vgui.Create("DLabel", scroll)
			sexF:SetText(data.eyeColor)
			sexF:SetTextColor(Color(0,0,0))
			--sexF:SetFont("Trebuchet18")
			sexF:SetPos(posX, posY)
			
			posY = posY + 20
		end	
		
		--hair color
		if (data.hairColor) then
			local sexL = vgui.Create("DLabel", scroll)
			sexL:SetText("Hair Color")
			sexL:SetTextColor(Color(0,0,0))
			sexL:SetFont("Trebuchet18")
			sexL:SetPos(posX, posY)
			
			posY = posY + 15
			
			local sexF = vgui.Create("DLabel", scroll)
			sexF:SetText(data.hairColor)
			sexF:SetTextColor(Color(0,0,0))
			--sexF:SetFont("Trebuchet18")
			sexF:SetPos(posX, posY)
			
			posY = posY + 20
		end		
		
		posX = posX + 100
		posY = 70
		
		--height
		if (data.height) then
			local sexL = vgui.Create("DLabel", scroll)
			sexL:SetText("Height")
			sexL:SetTextColor(Color(0,0,0))
			sexL:SetFont("Trebuchet18")
			sexL:SetPos(posX, posY)
			
			posY = posY + 15
			
			local sexF = vgui.Create("DLabel", scroll)
			sexF:SetText(data.height)
			sexF:SetTextColor(Color(0,0,0))
			--sexF:SetFont("Trebuchet18")
			sexF:SetPos(posX, posY)
			
			posY = posY + 20
		end		
		
		--birth
		if (data.birth) then
			local sexL = vgui.Create("DLabel", scroll)
			sexL:SetText("Birthdate")
			sexL:SetTextColor(Color(0,0,0))
			sexL:SetFont("Trebuchet18")
			sexL:SetPos(posX, posY)
			
			posY = posY + 15
			
			local sexF = vgui.Create("DLabel", scroll)
			sexF:SetText(data.birth)
			sexF:SetTextColor(Color(0,0,0))
			--sexF:SetFont("Trebuchet18")
			sexF:SetPos(posX, posY)
			
			posY = posY + 20
		end
		
		--weight
		if (data.weight) then
			local sexL = vgui.Create("DLabel", scroll)
			sexL:SetText("Weight")
			sexL:SetTextColor(Color(0,0,0))
			sexL:SetFont("Trebuchet18")
			sexL:SetPos(posX, posY)
			
			posY = posY + 15
			
			local sexF = vgui.Create("DLabel", scroll)
			sexF:SetText(data.weight)
			sexF:SetTextColor(Color(0,0,0))
			--sexF:SetFont("Trebuchet18")
			sexF:SetPos(posX, posY)
			
			posY = posY + 20
		end
	end)	
end