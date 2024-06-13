PLUGIN.name = "Setorian Custom UI"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = ""

ix.util.Include("cl_bonemerge.lua")
ix.util.Include("sv_bonemerge.lua")

PLUGIN.EyesColors = {
    "Green", "Brown", "Blue", "Hazel", "Gray", "Amber", "Black", "Honey", "Light Blue", "Dark Brown",
    "Light Green", "Dark Blue", "Light Gray", "Violet"
}

PLUGIN.HairColors = {
    "Black", "Brown", "White", "Blond", "Red", "Chestnut", "Gray", "Silver", "Auburn", "Honey Blonde",
    "Dark Brown", "Light Brown", "Dirty Blonde", "Sandy Blonde"
}


PLUGIN.Nationality = {
    "German", "English", "French", "Spanish", "Italian", "Dutch", "Swedish", "Russian", "Chinese", "Japanese",
    "Korean", "Brazilian", "Mexican", "Canadian", "Australian", "Indian", "Greek", "Turkish", "Egyptian", "Norwegian",
    "Danish", "Finnish", "Irish", "Scottish", "Welsh", "Austrian", "Swiss", "Portuguese", "Polish", "Czech",
    "Hungarian", "Romanian", "Belgian", "South African", "New Zealand", "Argentinian", "Chilean", "Peruvian", "Colombian",
    "Venezuelan", "Costa Rican", "Panamanian", "Singaporean", "Malaysian", "Indonesian", "Thai", "Vietnamese", "Filipino",
    "Israeli", "Saudi Arabian", "Qatari", "Emirati", "Kuwaiti", "Iraqi", "Jordanian", "Lebanese", "Syrian", "American",
    "Bahraini", "Yemeni", "Sri Lankan", "Bangladeshi", "Nepali", "Pakistani", "Afghan", "Iranian", "Turkmen", "Kazakh",
    "Uzbek", "Tajik", "Kyrgyz", "Mongolian", "Ukrainian", "Belarusian", "Lithuanian", "Latvian", "Estonian", "Croatian"
}


for i=1, 9 do
	util.PrecacheModel("models/heads/techcom/brot/male_0"..i..".mdl")
end

for i=10, 99 do
	util.PrecacheModel("models/heads/techcom/brot/male_"..i..".mdl")
end

for i=1, 9 do
	util.PrecacheModel("models/heads/techcom/brot/female_0"..i..".mdl")
end

for i=10, 74 do
	util.PrecacheModel("models/heads/techcom/brot/female_"..i..".mdl")
end

	 

ix.char.RegisterVar("gender", {
	field = "gender",
	fieldType = ix.type.text,
})

ix.char.RegisterVar("headmodel", {
	field = "headmodel",
	fieldType = ix.type.string,
	default = "",
})

ix.char.RegisterVar("height", {
	field = "height",
	fieldType = ix.type.number,
	OnValidate = function(self, value, payload, client)

		if (!payload.height) then
			return false, "Select a height for a character"
		end

	end,
})

ix.char.RegisterVar("weight", {
	field = "weight",
	fieldType = ix.type.number,
	OnValidate = function(self, value, payload, client)

		if (!payload.weight) then
			return false, "Select a weight for a character"
		end

	end,
})

ix.char.RegisterVar("age", {
	field = "age",
	fieldType = ix.type.number,
	OnValidate = function(self, value, payload, client)

		if (!payload.age) then
			return false, "Choose how old your character is"
		end

	end,
})

ix.char.RegisterVar("blood_type", {
	field = "blood_type",
	fieldType = ix.type.text,
	OnValidate = function(self, value, payload, client)

		if (!payload.blood_type) then
			return false, "Choose a blood type for your character"
		end

	end,
})

ix.char.RegisterVar("eye_color", {
	field = "eye_color",
	fieldType = ix.type.text,
	OnValidate = function(self, value, payload, client)

		if (!payload.eye_color) then
			return false, "Enter the eye color for your character"
		end

		-- value = tostring(value):gsub("\r\n", ""):gsub("\n", "")
		-- value = string.Trim(value)

		-- if (value:utf8len() < 3) then
		-- 	return false, "The eye color must be at least %d characters!", 3
		-- end

	end,
})

ix.char.RegisterVar("hair_color", {
	field = "hair_color",
	fieldType = ix.type.text,
	OnValidate = function(self, value, payload, client)

		if (!payload.hair_color) then
			return false, "Enter the hair color for your character"
		end

		-- value = tostring(value):gsub("\r\n", ""):gsub("\n", "")
		-- value = string.Trim(value)

		-- if (value:utf8len() < 3) then
		-- 	return false, "The hair color must be at least %d characters!", 3
		-- end

	end,
})

ix.char.RegisterVar("nationality", {
	field = "nationality",
	fieldType = ix.type.text,
	OnValidate = function(self, value, payload, client)

		if (!payload.nationality) then
			return false, "Enter the nationality for your character"
		end

		-- value = string.Trim((tostring(value):gsub("\r\n", ""):gsub("\n", "")))

		-- if (value:utf8len() < 3) then
		-- 	return false, "The nationality must be at least %d characters!", 3
		-- end

	end,
})

ix.char.RegisterVar("dob", {
	field = "dob",
	fieldType = ix.type.text,
	OnValidate = function(self, value, payload, client)

		if (!payload.dob) then
			return false, "Enter the Date of birth"
		end

		-- value = string.Trim((tostring(value):gsub("\r\n", ""):gsub("\n", "")))

		-- if (!string.match( value, "^%d%d%/%d%d%/%d%d%d%d$" )) then
		-- 	return false, "Invalid Date of birth. Try MM/DD/YYYY"
		-- end

		-- if (!string.match( value, "^[0-1][0-2]/[0-3][1-9]/[1-2][0-9][0-9][0-9]$" )) then
		-- 	return false, "Invalid Date of birth. MM:01-12 / DD: 01-31 / YYYY: Any"
		-- end

	end,
})

if CLIENT then

	function PLUGIN:LoadFonts(font, genericFont)

		surface.CreateFont("Setorian_Creator_Font1", {
			font = "Tahoma",
			size = ScreenScale(15),
			antialias = true,
			weight = 400,
		})

	end

	net.Receive( "ixSetorian_CustomMenu_HeadEquiper", function( len )

		local entity = net.ReadEntity()


		if (!IsValid(entity)) then return end

		if (entity:IsRagdoll()) then

			local headStringMdl = net.ReadString()

			-- if (entity.ixPlayer) then
			-- 	if (entity.ixPlayer.headModel) then
			-- 		entity.ixPlayer.headModel:Remove()
			-- 	end

				entity:EquipHead(headStringMdl)

			-- end



		elseif (entity:IsPlayer()) then

			if (entity.ixRagdoll) then
				if (entity.ixRagdoll.headModel) then
					entity.ixRagdoll.headModel:Remove()
				end

				-- if (LookForRagdoll) then
				-- 	entity.ixRagdoll:EquipHead(headStringMdl)
				-- end

			end

			if (entity.headModel) then
				entity.headModel:Remove()
			end


			-- if (!LookForRagdoll) then
				entity:EquipHead()
			-- end

		end

	end)

	net.Receive( "ixSetorian_CustomMenu_EquipPlyHeads", function( len )

		for client, char in ix.util.GetCharacters() do
			
			if (char and char:GetHeadmodel() and string.find(char:GetHeadmodel(), "models")) then
				client:EquipHead()
			end
		end

	end)

	-- net.Receive( "ixSetorian_CustomMenu_HeadEquiper", function( len )

	-- 	local entity = net.ReadEntity()

	-- 	if (!IsValid(entity)) then return end

	-- 	local headModel = net.ReadString()

	-- 	if (!string.find(headModel, "models")) then return end

	-- 	entity:EquipHead(headModel)

	-- end)

	net.Receive( "ixSetorian_CustomMenu_HeadRemover", function( len )

		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end

		if (entity.headModel) then
			entity.headModel:Remove()
		end

	end)

	function PLUGIN:Think()

		if ((self.HeadsChecker or 0) < CurTime()) then


			for client, char in ix.util.GetCharacters() do

				if (client.headModel) and (IsValid(client.headModel)) then
					client.headModel:Remove()
				end

				if (client:Alive()) then

					if (client:GetNetVar("HeadEquiped", false)) then

						if (char:GetHeadmodel() and string.find(char:GetHeadmodel(), "models")) then

							-- if (!IsValid(client.headModel)) or (client.headModel and (client.headModel:GetParent() == NULL)) then
								client:EquipHead()
							-- end
						end

					end

					-- else

					-- 	if (client.headModel) and (IsValid(client.headModel)) then
					-- 		client.headModel:Remove()
					-- 	end

					-- end

				-- else

				-- 	if (client.headModel) and (IsValid(client.headModel)) then
				-- 		client.headModel:Remove()
				-- 	end

				end

			end


			self.HeadsChecker = CurTime() + 5

		end

	end

end

if SERVER then

	util.AddNetworkString("ixSetorian_CustomMenu_Ply_HeadEquiper")
	util.AddNetworkString("ixSetorian_CustomMenu_HeadEquiper")
	util.AddNetworkString("ixSetorian_CustomMenu_EquipPlyHeads")
	util.AddNetworkString("ixSetorian_CustomMenu_HeadRemover")

	if (ix.plugin.Get("iditem")) then

		function PLUGIN:OnCharacterCreated(client, character)

			local inventory = character:GetInventory()

			local CharData = {
				name = character:GetName(),
				sex = character.vars.gender or "Unknown",
				eyeColor = character.vars.eye_color or "Undefinied",
				hairColor = character.vars.hair_color or "Undefinied",
				height = character.vars.height or "Unknown",
				birth = character.vars.dob or "Unknown",
				weight = character.vars.weight or "Unknown",
				model = character:GetModel(),
				headmodel = character:GetHeadmodel(),
			}

			inventory:Add("id", 1, {
				idInfo = CharData,
			})
		end

	end

	function PLUGIN:PlayerSpawn(client) 

		local char = client:GetCharacter()

		-- if (!client.FirstTimeLoadedHeads) then

		-- 	timer.Simple(1, function()

		-- 		net.Start("ixSetorian_CustomMenu_EquipPlyHeads")    	
		-- 		net.Send(client)

		-- 		client.FirstTimeLoadedHeads = true

		-- 	end)

		-- end

		if (char) then

			if (char:GetHeadmodel() and string.find(char:GetHeadmodel(), "models")) then
				net.Start("ixSetorian_CustomMenu_HeadEquiper")
		        	net.WriteEntity(client)
		        	-- net.WriteBool(false)
				net.Broadcast()

				client:SetNetVar("HeadEquiped", true)

			end

		end

	end

	function PLUGIN:OnCharacterFallover(client, entity, bFallenOver)

		timer.Simple(0.1, function()

		if (IsValid(entity)) then

			if (bFallenOver) then

				local char = client:GetCharacter()

				if (char and char:GetHeadmodel() and string.find(char:GetHeadmodel(), "models")) then

					client:SetNetVar("HeadEquiped", false)

					net.Start("ixSetorian_CustomMenu_HeadEquiper")
			        	net.WriteEntity(entity)
			        	-- net.WriteUInt(entity:EntIndex(),16)
			        	-- net.WriteBool(true)
			        	net.WriteString(char:GetHeadmodel())
			        	
					net.Broadcast()

					net.Start("ixSetorian_CustomMenu_HeadRemover")
			        	net.WriteEntity(client)
			        net.Broadcast()

					entity:CallOnRemove("removeHead", function()
						if (IsValid(client)) then

							net.Start("ixSetorian_CustomMenu_HeadEquiper")
					        	net.WriteEntity(client)
					        	-- net.WriteBool(false)
					        	-- net.WriteString(char:GetHeadmodel())
			        			
					        	-- net.WriteUInt(client:EntIndex(),16)
					        	-- net.WriteString("models/heads/techcom/brot/male_69.mdl")
							net.Broadcast()

							client:SetNetVar("HeadEquiped", true)

							net.Start("ixSetorian_CustomMenu_HeadRemover")
					        	net.WriteEntity(entity)
					        net.Broadcast()

					        -- net.Start("ixSetorian_CustomMenu_Ply_HeadEquiper")
					        -- 	net.WriteEntity(client)
					        -- net.Broadcast()

						end
					end)

				end
			else

				-- net.Start("ixSetorian_CustomMenu_HeadEquiper")
		        -- 	net.WriteEntity(client)
		        -- 	-- net.WriteString("models/heads/techcom/brot/male_69.mdl")
				-- net.Broadcast()

				-- net.Start("ixSetorian_CustomMenu_HeadRemover")
		        -- 	net.WriteEntity(client.ixRagdoll)
		        -- net.Broadcast()

		        -- net.Start("ixSetorian_CustomMenu_Ply_HeadEquiper")
		        -- 	net.WriteEntity(client)
		        -- net.Broadcast()

			end

		end

		end)

	end

	function PLUGIN:PlayerDisconnected(client)

		net.Start("ixSetorian_CustomMenu_HeadRemover")
        	net.WriteEntity(client)
        net.Broadcast()

	end

	function PLUGIN:PlayerDeath(client, inflictor, attacker)

		client:SetNetVar("HeadEquiped", false)

		net.Start("ixSetorian_CustomMenu_HeadRemover")
        	net.WriteEntity(client)
        net.Broadcast()

		local char = client:GetCharacter()

		if (char and char:GetHeadmodel() or string.find(char:GetHeadmodel(), "models")) then
			
			if (IsValid(client:GetRagdollEntity())) then

				net.Start("ixSetorian_CustomMenu_HeadEquiper")
		        	net.WriteEntity(client:GetRagdollEntity())
		        	net.WriteString(char:GetHeadmodel())
				net.Broadcast()

				client:GetRagdollEntity():CallOnRemove("removeHead", function()
					net.Start("ixSetorian_CustomMenu_HeadRemover")
			        	net.WriteEntity(client:GetRagdollEntity())
			        net.Broadcast()
				end)

			end

		end

	end

	function PLUGIN:OnPlayerCorpseCreated(client, entity)

		timer.Simple(0.1, function()

			local char = client:GetCharacter()

			if (char and char:GetHeadmodel() or string.find(char:GetHeadmodel(), "models")) then

				if (IsValid(entity)) then

					net.Start("ixSetorian_CustomMenu_HeadEquiper")
			        	net.WriteEntity(entity)
			        	net.WriteString(char:GetHeadmodel())
					net.Broadcast()

					entity:CallOnRemove("removeHead", function()
						net.Start("ixSetorian_CustomMenu_HeadRemover")
				        	net.WriteEntity(entity)
				        net.Broadcast()
					end)


				end

			end

		end)

	end

end