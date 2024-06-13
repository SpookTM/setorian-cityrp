PLUGIN.name = "Realistic Bank"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = ""

// CONFIG

PLUGIN.PoliceFaction = FACTION_MPF
PLUGIN.BankierFaction = FACTION_CITIZEN

// Extra accounts depends of player's rank
PLUGIN.ExtraPersonalAccounts = {
	["prime"] = 1,
	["superadmin"] = 2,
	["founder"] = 2,
}

PLUGIN.ExtraInterestAccounts = {
	["prime"] = 1,
	["superadmin"] = 1,
	["founder"] = 1,
}

PLUGIN.ExtraGroupAccounts = {
	["prime"] = 1,
	["superadmin"] = 1,
	["founder"] = 1,
}

//

ix.util.Include("sv_banking.lua", "server")


// In-game config
ix.config.Add("MaxAccountPerChar", 3, "Number of accounts that a character can create." , nil, {
	data = {min = 1, max = 5},
	category = "Realistic Bank"
})

ix.config.Add("MaxInterestAccountPerChar", 2, "Number of interest accounts that a character can create." , nil, {
	data = {min = 1, max = 5},
	category = "Realistic Bank"
})

ix.config.Add("MaxGroupAccountPerChar", 1, "Number of group accounts that a character can create." , nil, {
	data = {min = 1, max = 5},
	category = "Realistic Bank"
})
//


-- ALWAYS_RAISED["weapon_j_banking_debitcard"] = true

-- function PLUGIN:CharacterPreSave(character)

-- 	local inv = character:GetInventory()

-- 	local data = {
-- 		["equip"] = true,
-- 	}

-- 	local item = inv:HasItem("debit_card",data)

-- 	if (item) then
-- 		item:SetData("equip", false)
-- 	end

-- end

function PLUGIN:InitializedPlugins()
	ix.inventory.Register("SafetyBox10x5", 10,5)
	ix.inventory.Register("SafetyBox10x10", 10,10)

	self.RobbedDepositBoxes = {}

end

function PLUGIN:EnoughPolice()

	local count = 0

	for client, character in ix.util.GetCharacters() do
		if character:GetFaction() == self.PoliceFaction then
			count = count + 1
		end
	end

	return count >= 1

end

if (SERVER) then

	local bInit = false
	function PLUGIN:DatabaseConnected()
	    if bInit then return end
	    local query = mysql:Create("ix_bankaccounts")
	        query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
	        query:Create("account_id", "INT(11) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("owner", "INT(10) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("owner_name", "VARCHAR(50) UNSIGNED NOT NULL DEFAULT ''")
	        query:Create("group_acc_name", "VARCHAR(50) UNSIGNED NOT NULL DEFAULT ''")
	        query:Create("money", "FLOAT(15) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("is_groupaccount", "INT(2) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("is_interest", "INT(2) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("has_loan", "INT(2) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("loan", "FLOAT(15) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("loantime", "INT(100) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("deposit_id", "INT(10) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("deposit_type", "INT(10) UNSIGNED NOT NULL DEFAULT '0'")
	        query:Create("owners", "VARCHAR(255)")
	        query:Create("permissions", "VARCHAR(255)")
	        query:PrimaryKey("id")
	    query:Execute()
	    bInit = true
	end

	PLUGIN.CachedAccounts = {}
	function PLUGIN:GetAllAccountsData(fCallback, pPlayer)
	    local select = mysql:Select("ix_bankaccounts")
	        select:Select("id")
	        select:Select("account_id")
	        select:Select("owner")
	        select:Select("owner_name")
	        select:Select("group_acc_name")
	        select:Select("money")
	        select:Select("is_groupaccount")
	        select:Select("is_interest")
	        select:Select("has_loan")
	        select:Select("loan")
	        select:Select("loantime")
	        select:Select("deposit_id")
	        select:Select("deposit_type")
	        select:Select("owners")
	        select:Select("permissions")

			-- Temp fix to broadcasting every account in server
			-- Need to also check if character is in "permissions"
			if (pPlayer) then
				local character = pPlayer:GetCharacter()

				if (character) then
					select:Where("owner", character:GetID())
				end 
			end

	        select:Callback(function(results)
	            -- PLUGIN.CachedAccounts = results
	            fCallback(results or {})
	        end)
	    select:Execute()
	end

	function PLUGIN:InitPostEntity()
	    if (!bInit) then
	        self:DatabaseConnected()
	    end
	end

	function PLUGIN:LoadData()
		self:LoadJRBankierNPC()
		self:LoadJRCorruptNPC()
		self:LoadJRBankingATM()
		self:LoadJRBankingMonitors()
		self:LoadJRBankingSafes()
		self:LoadJRBankingBoxes()
	end

	function PLUGIN:SaveData()
		self:SaveJRBankierNPC()
		self:SaveJRCorruptNPC()
		self:SaveJRBankingATM()
		self:SaveJRBankingMonitors()
		self:SaveJRBankingSafe()
		self:SaveJRBankingDepositBox()
	end

	function PLUGIN:SaveJRBankierNPC()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_bankier_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_bankiers_npc", data)

	end

	function PLUGIN:SaveJRCorruptNPC()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_corrupt_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("j_corrupt_npcs", data)

	end

	function PLUGIN:SaveJRBankingATM()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_banking_atm")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_banking_atms", data)

	end

	function PLUGIN:SaveJRBankingSafe()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_banking_safe")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_banking_safes", data)

	end

	function PLUGIN:SaveJRBankingDepositBox()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_banking_depositboxes")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_banking_boxes", data)

	end

	function PLUGIN:SaveJRBankingMonitors()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_banking_monitor")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_banking_monitors", data)

	end

	function PLUGIN:LoadJRBankierNPC()
		for _, v in ipairs(ix.data.Get("jr_bankiers_npc") or {}) do
			local npc = ents.Create("j_bankier_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

	function PLUGIN:LoadJRCorruptNPC()
		for _, v in ipairs(ix.data.Get("j_corrupt_npcs") or {}) do
			local npc = ents.Create("j_corrupt_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

	function PLUGIN:LoadJRBankingATM()
		for _, v in ipairs(ix.data.Get("jr_banking_atms") or {}) do
			local atm = ents.Create("j_banking_atm")

			atm:SetPos(v[1])
			atm:SetAngles(v[2])
			atm:Spawn()

			local phys = atm:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
		end
	end

	function PLUGIN:LoadJRBankingSafes()
		for _, v in ipairs(ix.data.Get("jr_banking_safes") or {}) do
			local atm = ents.Create("j_banking_safe")

			atm:SetPos(v[1])
			atm:SetAngles(v[2])
			atm:Spawn()

			local phys = atm:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
		end
	end

	function PLUGIN:LoadJRBankingBoxes()
		for _, v in ipairs(ix.data.Get("jr_banking_boxes") or {}) do
			local atm = ents.Create("j_banking_depositboxes")

			atm:SetPos(v[1])
			atm:SetAngles(v[2])
			atm:Spawn()

			local phys = atm:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
		end
	end

	function PLUGIN:LoadJRBankingMonitors()
		for _, v in ipairs(ix.data.Get("jr_banking_monitors") or {}) do
			local pc = ents.Create("j_banking_monitor")

			pc:SetPos(v[1])
			pc:SetAngles(v[2])
			pc:Spawn()

			local phys = pc:GetPhysicsObject()
	
			if phys:IsValid() then

				phys:EnableMotion(false)

			end
			
		end
	end

	util.AddNetworkString("ixBankingDataRequest")

	local PLUGIN = PLUGIN

	net.Receive("ixBankingDataRequest", function(_, pPlayer)
	    PLUGIN:GetAllAccountsData(function(data)			
			netstream.Start(pPlayer, "Jbanking_DataForClient", data)
		end, pPlayer)
	end)

	-- netstream.Hook("JBanking_RequestDataForClient", function(ply, plugin)

	-- 	plugin:GetAllAccountsData(function(data)
			
	-- 		netstream.Start(ply, "Jbanking_DataForClient", data)

	-- 	end)


	-- end)

end

if (CLIENT) then

	function PLUGIN:PostDrawHelixModelView(panel, ent)
		if (ent.headmodel and IsValid(ent.headmodel)) then
			ent.headmodel:DrawModel()
		end

		if (!pac) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			pac.RenderOverride(ent, "opaque")
			pac.RenderOverride(ent, "translucent", true)
		end

		if (!panel.pac_setup) then
            pac_setup = true
            panel.pac_setup = true
            pac.SetupENT(ent)
        end

	end

	// From Pixel UI by Tom O'Sullivan (Tom.bat)
	// https://github.com/TomDotBat/pixel-ui/blob/master/lua/pixelui/core/sh_formatting.lua
	local floor, format = math.floor, string.format
	function PLUGIN:NiceFormatTime(time)
	    if not time then return end

	    local s = time % 60
	    time = floor(time / 60)

	    local m = time % 60
	    time = floor(time / 60)

	    local h = time % 24
	    time = floor(time / 24)

	    local d = time % 7
	    local w = floor(time / 7)

	    if w ~= 0 then
	        return format("%iw %id %ih %im %is", w, d, h, m, s)
	    elseif d ~= 0 then
	        return format("%id %ih %im %is", d, h, m, s)
	    elseif h ~= 0 then
	        return format("%ih %im %is", h, m, s)
	    end

	    return format("%im %is", m, s)
	end

	JBanking_Data = {}

	local fCallback = function()end

	netstream.Hook("Jbanking_DataForClient", function(data)
		-- JBanking_Data = data
		fCallback(data)
	end)

	netstream.Hook("Jbanking_OpenATM_UI", function(exists, hasloan, cardnumber, banknumber, cardpin)

		local panel = vgui.Create("ixBanking_ATMMenu")
		panel.LogInPanel.CorrectPin = cardpin
		panel.LogInPanel.exists = exists
		panel.LogInPanel.HasLoan = hasloan
		panel.BankNumber = banknumber
		panel.CardNumber = cardnumber

		if (IsValid(ix.gui.menu)) then
			ix.gui.menu:Remove()
		end

	end)

	netstream.Hook("Jbanking_OpenMonitor_UI", function()
		vgui.Create("ixBanking_MonitorMenu")
	end)

	netstream.Hook("ixViewCorruptNPCUI", function()
		vgui.Create("ixBanking_CorruptedNPCMenu")
	end)

	netstream.Hook("ixViewBankierUI", function()
		vgui.Create("ixBanking_NPCMenu")
	end)

	function PLUGIN:GetAllAccountsData(fCallback_)
		-- netstream.Start("JBanking_RequestDataForClient", self)

		-- fCallback = fCallback_ or function() end

		net.Start("ixBankingDataRequest")
	    fCallback = fCallback_ or function() end
	    net.SendToServer()

		-- return JBanking_Data

	end

	function PLUGIN:PopulateEntityInfo(ent, tooltip)
		if (ent:GetClass() == "j_bankier_npc") then

			local panel = tooltip:AddRow("name")
			panel:SetText("Bankier")
			panel:SetImportant()
	  		-- panel:SetBackgroundColor(Color(250,250,0))
	  	 	panel:SizeToContents()
	  	 	

	  	 	local desc = tooltip:AddRowAfter("name", "desc")
			desc:SetText("You can create and manage your bank accounts here.")
	  		-- desc:SetBackgroundColor(Color(250,250,0))
	  	 	desc:SizeToContents()

	  	 	tooltip:SizeToContents()

	  	end

	  	if (ent:GetClass() == "j_corrupt_npc") then

			local panel = tooltip:AddRow("name")
			panel:SetText("Corrupt Bankier")
			panel:SetImportant()
	  	 	panel:SizeToContents()
	  	 	

	  	 	local desc = tooltip:AddRowAfter("name", "desc")
			desc:SetText("You can clean up stolen money here.")
	  	 	desc:SizeToContents()

	  	 	tooltip:SizeToContents()

	  	end

	  	if (ent:GetClass() == "j_banking_atm") then

			local panel = tooltip:AddRow("name")
			panel:SetText("ATM")
			panel:SetImportant()
	  	 	panel:SizeToContents()
	  	 	

	  	 	local desc = tooltip:AddRowAfter("name", "desc")
			desc:SetText("You can deposit and withdraw cash here.")
	  	 	desc:SizeToContents()

	  	 	tooltip:SizeToContents()
	  	 	
	  	end

	  	if (ent:GetClass() == "j_banking_monitor") then

			local panel = tooltip:AddRow("name")
			panel:SetText("Banker's computer")
			panel:SetImportant()
	  	 	panel:SizeToContents()
	  	 	

	  	 	local desc = tooltip:AddRowAfter("name", "desc")
			desc:SetText("Allows the banker, for example, to make loans or create interest accounts.")
	  	 	desc:SizeToContents()

	  	 	tooltip:SizeToContents()
	  	 	
	  	end

	end

end