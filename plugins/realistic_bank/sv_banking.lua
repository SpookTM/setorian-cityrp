if (CLIENT) then return end

local PLUGIN = PLUGIN

// 86400 - 24h

timer.Create("InterestAccountsGrowing", 86400, 0, function()
    print("[Realistic Banking] The balance in interest accounts is growing")
    

    local charWhoGetNotify = {}

    PLUGIN:GetAllAccountsData(function(data)
-- PrintTable(data)
        for k,v in ipairs(data) do

-- print(v.account_id, (tobool(v.is_interest)))

            if (!(tobool(v.is_interest))) then continue end

            local newBalance = PLUGIN:GetAccountMoney(tonumber(v.account_id)) * 1.01

            PLUGIN:UpdateBalance(v.account_id, math.Round(newBalance, 2))


            local ownerID = tonumber(v.owner)
            local char = ix.char.loaded[ownerID]
            local ply

            if (char) then
                ply = ix.char.loaded[ownerID]:GetPlayer()
            end

            if (char) and (ply) then

                if (charWhoGetNotify[ply]) then continue end
    
                if (ply:GetCharacter() and ply:GetCharacter():GetID() == ownerID) then
                    ply:Notify("The balance your interest accounts is growing")
                end

                charWhoGetNotify[ply] = true

            end

        end
    end)
end)

timer.Create("SafeBox_Checker", 86400, 0, function()
    print("[Realistic Banking] Safe deposit boxes - check")
    

    PLUGIN:GetAllAccountsData(function(data)

        for k,v in ipairs(data) do

            if (tonumber(v.deposit_id) == 0) then continue end

            local boxCost = (v.deposit_type == 2 and 350) or 150
            
            local ownerID = tonumber(v.owner)
            local char = ix.char.loaded[ownerID]
            local ply

            if (char) then
                ply = ix.char.loaded[ownerID]:GetPlayer()
            end

            if (char) and (ply) then

                if (tonumber(v.money) < boxCost) then
                    ply:Notify("You don't have enough money in your account to pay for the deposit box. It will be closed until it is paid for")
                    return
                end

    
                if (ply:GetCharacter() and ply:GetCharacter():GetID() == ownerID) then
                    ply:Notify("You have been charged for your safe deposit box")
                    PLUGIN:UpdateBalance(v.account_id, math.max(0, tonumber(v.money) - boxCost))
                end


            end

        end
    end)
end)


timer.Create("LoanInBank_Checker", 86400, 0, function()
    print("[Realistic Banking] Loan Bank Checker - check")
    

    PLUGIN:GetAllAccountsData(function(data)

        for k,v in ipairs(data) do

            if (tonumber(v.loan) == 0) then continue end
            if (tonumber(v.loantime) == 0) then continue end

            local bankid = tonumber(v.account_id)

            local newLoanTime = PLUGIN:GetLoanTime(bankid) - 1

            PLUGIN:UpdateLoanTime(bankid, newLoanTime)

        end
    end)
end)


function PLUGIN:GenerateNumbers(loop)

	if (loop <= 1) then return end

	local output = ""

	for i=1, loop do
		output = output .. tostring(math.random(0, 9))
	end

	return output

end


function PLUGIN:CreateNewAccount(bankID, charID, charName)

	local owners = {
		[1] = {
            charID = charID,
            charName = charName
        }
	}


	local sData = util.TableToJSON(owners)

    local select = mysql:Select("ix_bankaccounts")
    select:Where("account_id", bankID)
    select:Callback(function(results)
        if not results or #results == 0 then
            local insert = mysql:Insert("ix_bankaccounts")
                insert:Insert("account_id", bankID)
                insert:Insert("owner", charID)
                insert:Insert("owner_name", charName)
                insert:Insert("money", 0)
                insert:Insert("owners", sData)
            insert:Execute()
        	print("[Realistic Banking] Account created [id]["..bankID.."] for char ["..charID.." - "..charName.."]")
        end
    end)
    select:Execute()
end

function PLUGIN:CreateNewGroupAccount(bankID, acc_name, charID, charName)

    local owners = {
        [1] = {
            charID = charID,
            charName = charName
        }
    }


    local sData = util.TableToJSON(owners)

    local select = mysql:Select("ix_bankaccounts")
    select:Where("account_id", bankID)
    select:Callback(function(results)
        if not results or #results == 0 then
            local insert = mysql:Insert("ix_bankaccounts")
                insert:Insert("account_id", bankID)
                insert:Insert("owner", charID)
                insert:Insert("owner_name", charName)
                insert:Insert("group_acc_name", acc_name)
                insert:Insert("money", 0)
                insert:Insert("is_groupaccount", 1)
                insert:Insert("owners", sData)
            insert:Execute()
            print("[Realistic Banking] Group Account created [id]["..bankID.."] for char ["..charID.." - "..charName.."]")
        end
    end)
    select:Execute()
end

function PLUGIN:GetPermissions(bankid)

    local permissions = {}

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do
            if (tonumber(v.account_id) == bankid) then
                permissions = util.JSONToTable(v.permissions) or {}
                break
            end
        end

    end)

    return permissions
    
end

function PLUGIN:GetOwner(bankid)

    local owner = nil

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do
            if (tonumber(v.account_id) == bankid) then
                owner = tonumber(v.owner)
                break
            end
        end

    end)

    return owner
    
end

function PLUGIN:GetOwners(bankid)

    local owners = {}

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do
            if (tonumber(v.account_id) == bankid) then
                owners = util.JSONToTable(v.owners) or {}
                break
            end
        end

    end)

    return owners
    
end

/*
[charid] = {
    canwithdraw = true,
    candeposit = true,
    etc.
}

permisions[char:getid].canwithdraw

*/

function PLUGIN:GroupAccont_AddUser(ply, bankID, charToAdd_ID, charToAdd_Name, permissions)

    local acc_owners = self:GetOwners(bankID)
    if (table.IsEmpty(acc_owners)) then 
        print("[Realistic Banking] Can't add user to group accont. Table 'owners' doesn't exists")
        return false
    end

    local Tablpermissions = self:GetPermissions(bankID)
    -- if (table.IsEmpty(Tablpermissions)) then 
    --     print("[Realistic Banking] Can't add user to group accont. Table 'permissions' doesn't exists")
    --     return false
    -- end

    acc_owners[#acc_owners + 1] = {
        charID = charToAdd_ID,
        charName = charToAdd_Name
    }

    if (Tablpermissions[charToAdd_ID]) then
        ply:Notify("Character '"..charToAdd_Name.."' is already added")
        return false
    end 

    Tablpermissions[charToAdd_ID] = permissions

    local newOwners = util.TableToJSON(acc_owners)
    local newPerms = util.TableToJSON(Tablpermissions)

    local select = mysql:Select("ix_bankaccounts")
        select:Select("id")
        select:Where("account_id", bankID)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
                local id = data[1].id
                local insert = mysql:Update("ix_bankaccounts")
                    insert:Where("id", id)
                    insert:Update("owners", newOwners)
                    insert:Update("permissions", newPerms)
                insert:Execute()
                print("Realistic Banking] Updated permissions for ["..bankID.."]")
            end
        end)
    select:Execute()

    ply:Notify("Character '"..charToAdd_Name.."' has been added successfully")

end

function PLUGIN:GroupAccont_RemoveUser(ply, bankID, charKey, charID)

    local acc_owners = self:GetOwners(bankID)
    if (table.IsEmpty(acc_owners)) then 
        print("[Realistic Banking] Can't remove user from group accont. Table 'owners' doesn't exists")
        return false
    end

    local Tablpermissions = self:GetPermissions(bankID)
    if (table.IsEmpty(Tablpermissions)) then 
        print("[Realistic Banking] Can't remove user from group accont. Table 'permissions' doesn't exists")
        return false
    end

    table.remove(acc_owners, charKey)

    Tablpermissions[charID] = nil

    local newOwners = util.TableToJSON(acc_owners)
    local newPerms = util.TableToJSON(Tablpermissions)

    local select = mysql:Select("ix_bankaccounts")
        select:Select("id")
        select:Where("account_id", bankID)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
                local id = data[1].id
                local insert = mysql:Update("ix_bankaccounts")
                    insert:Where("id", id)
                    insert:Update("owners", newOwners)
                    insert:Update("permissions", newPerms)
                insert:Execute()
                print("Realistic Banking] Updated permissions for ["..bankID.."]")
            end
        end)
    select:Execute()

    ply:Notify("Character ["..charID.."] has been removed successfully")

end

function PLUGIN:CreateInterestAccount(bankID, charID, charName)

    local owners = {
        [1] = {
            charID = charID,
            charName = charName
        }
    }


    local sData = util.TableToJSON(owners)

    local select = mysql:Select("ix_bankaccounts")
    select:Where("account_id", bankID)
    select:Callback(function(results)
        if not results or #results == 0 then
            local insert = mysql:Insert("ix_bankaccounts")
                insert:Insert("account_id", bankID)
                insert:Insert("owner", charID)
                insert:Insert("owner_name", charName)
                insert:Insert("money", 0)
                insert:Insert("is_interest", 1)
                insert:Insert("owners", sData)
            insert:Execute()
            print("[Realistic Banking] Interest Account created [id]["..bankID.."] for char ["..charID.." - "..charName.."]")
        end
    end)
    select:Execute()
end

function PLUGIN:DeleteAccount(bankID)
    local select = mysql:Select("ix_bankaccounts")
        select:Select("id")
        select:Where("account_id", bankID)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
                local id = data[1].id
                local delete = mysql:Delete("ix_bankaccounts")
                    delete:Where("id", id)
                    delete:Where("account_id", bankID)
                delete:Execute()
                print("[Realistic Banking] Account deleted [id]["..bankID.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:UpdateBalance(bankID, money)
    local select = mysql:Select("ix_bankaccounts")
        select:Select("id")
        select:Where("account_id", bankID)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
                local id = data[1].id
                local insert = mysql:Update("ix_bankaccounts")
                    insert:Where("id", id)
                    insert:Update("money", tonumber(money))
                insert:Execute()
                print("Realistic Banking] Updated balance ["..money.."] for ["..bankID.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:UpdateLoan(bankID, money)
    local select = mysql:Select("ix_bankaccounts")
        select:Select("id")
        select:Where("account_id", bankID)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
                local id = data[1].id
                local insert = mysql:Update("ix_bankaccounts")
                    insert:Where("id", id)
                    insert:Update("loan", tonumber(money))
                insert:Execute()
                print("Realistic Banking] Loan ["..money.."] for ["..bankID.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:GetLoanTime(bankid)

    local loantime = 0

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do
            if (tonumber(v.account_id) == bankid) then
                loantime = v.loantime
                break
            end
        end

    end)

    return loantime
    

end

function PLUGIN:UpdateLoanTime(bankID, days)
    local select = mysql:Select("ix_bankaccounts")
        select:Select("id")
        select:Where("account_id", bankID)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
                local id = data[1].id
                local insert = mysql:Update("ix_bankaccounts")
                    insert:Where("id", id)
                    insert:Update("loantime", tonumber(days))
                insert:Execute()
                print("Realistic Banking] Loan Time ["..days.."] for ["..bankID.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:AssignSafetyBox(bankID, boxType, char)

    local boxW = (boxType == 2 and 4) or 3
    local boxh = (boxType == 2 and 4) or 3

    local boxInvType = (boxType == 2 and "SafetyBox4x4") or "SafetyBox3x3"

    char:SetData("SDepositBoxW", boxW)
    char:SetData("SDepositBoxH", boxh)


    local BoxID = char:GetData("SDepositBoxID", 0)
    local BoxInv


    -- if (BoxID != 0) then

    --     BoxInv = ix.item.inventories[BoxID]

    --     if (BoxInv) then
    --         ix.inventory.Restore(BoxID, boxW, boxh, function(inventory)
    --             inventory:SetOwner(char:GetID())
    --             PLUGIN:UpdateSafetyBox(bankID, inventory:GetID(),  boxType)
    --         end)
    --     end

    -- else

        ix.inventory.New(char:GetID() or 0, boxInvType, function(inv)
            local client = inv:GetOwner()

            inv.vars.isBag = true
            inv.vars.isContainer = true

            if (IsValid(client)) then
                inv:AddReceiver(client)

                if (client:GetCharacter()) then

                    local char = client:GetCharacter()

                    char:SetData("SDepositBoxID", inv:GetID())

                    PLUGIN:UpdateSafetyBox(bankID, inv:GetID(),  boxType)
                end

                

            end

        end)
    -- end
   
end

function PLUGIN:UpdateSafetyBox(bankID, boxid,  boxType)
    local select = mysql:Select("ix_bankaccounts")
        select:Select("id")
        select:Where("account_id", bankID)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
                local id = data[1].id
                local insert = mysql:Update("ix_bankaccounts")
                    insert:Where("id", id)
                    insert:Update("deposit_id", tonumber(boxid))
                    insert:Update("deposit_type", tonumber(boxType))
                insert:Execute()
                print("Realistic Banking] New Safety Box assigned ["..boxid.." - "..((boxType == 2 and "4x4") or "3x3").."] for ["..bankID.."]")
            end
        end)
    select:Execute()
end

netstream.Hook("JBanking_OpenSafeBox", function(ply)

    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end

    local char = ply:GetCharacter()

    local BoxID = char:GetData("SDepositBoxID")
    local BoxInv

    local BoxW = char:GetData("SDepositBoxW")
    local BoxH = char:GetData("SDepositBoxH")

    local IsLocked = false

    if BoxID then

        PLUGIN:GetAllAccountsData(function(data)

            for k,v in ipairs(data) do

                if (tonumber(v.deposit_id) != tonumber(BoxID)) then continue end

                    local boxCost = (v.deposit_type == 2 and 350) or 150

                    if (tonumber(v.money) < boxCost) then
                            IsLocked = true
                        break
                    end
                
            end

        end)   

        BoxInv = ix.item.inventories[BoxID]

        if (!BoxInv) then
            ix.inventory.Restore(BoxID, BoxW, BoxH, function(inventory)
                inventory:SetOwner(char:GetID())
                BoxInv = inventory
            end)
        end
    else
        
        ply:Notify("Deposit doesn't exists")
        return

    end

    if (IsLocked) then
            ply:Notify("Deposit box is locked")
            -- netstream.Start(ply, "ixViewBankierUI")
        return false
    end

    
    -- print(BoxInv)
    -- print(BoxW)
    -- PrintTable(ix.item.inventoryTypes)

    ix.storage.Open(ply, BoxInv, {
        entity = ply,
        name = "Safety Deposit Box",
        -- data = {money = 0},
        -- searchText = "Accessing safety deposit box...",
        -- searchTime = 0.5
    })

end)

netstream.Hook("JBanking_CreateAccount", function(ply, pin)
    
	if (!ply) then return end
	if (!ply:Alive()) then return end
	if (!ply:GetCharacter()) then return end

	local char = ply:GetCharacter()
	local inv = char:GetInventory()

    if (!PLUGIN:AccountsCount(char:GetID(),ply)) then
        ply:Notify("You can't create any more accounts")
        return
    end

	local bankID = PLUGIN:GenerateNumbers(6)
	local cardID = PLUGIN:GenerateNumbers(16)

    if (!bankID) then return end
    if (!cardID) then return end

	local bSuccess, error = inv:Add("debit_card", 1, {
        ["CardNumber"] = cardID,
        ["CardBankID"] = tonumber(bankID),
        ["CardPIN"] = pin,
    })

    if (bSuccess) then
    	PLUGIN:CreateNewAccount(bankID, char:GetID(), char:GetName())

    	ply:Notify("Account ["..bankID.."] has been created successfully")

    end

end)

function PLUGIN:AccountsCount(ownerID, ply)

    local acc_count = 0

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do

            if (tonumber(v.owner) != ownerID) then
                continue
            end

            if (!tobool(v.is_groupaccount)) and (!tobool(v.is_interest)) then
                acc_count = acc_count + 1
            end

        end
    end)

    if (acc_count >= (ix.config.Get("MaxAccountPerChar", 5) + (PLUGIN.ExtraPersonalAccounts[ply:GetUserGroup()] or 0)) ) then
        return false
    else
        return true
    end

end

function PLUGIN:GroupAccountsCount(ownerID, ply)

    local acc_count = 0

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do

            if (tonumber(v.owner) != ownerID) then
                continue
            end

            if (tobool(v.is_groupaccount)) then
                acc_count = acc_count + 1
            end

        end
    end)

    if (acc_count >= (ix.config.Get("MaxGroupAccountPerChar", 5) + (PLUGIN.ExtraGroupAccounts[ply:GetUserGroup()]) or 0) ) then
        return false
    else
        return true
    end

end

function PLUGIN:InterestAccountsCount(ownerID, ply)

    local acc_count = 0

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do

            if (tonumber(v.owner) != ownerID) then
                continue
            end

            if (tobool(v.is_interest)) then
                acc_count = acc_count + 1
            end

        end
    end)

    if (acc_count >= (ix.config.Get("MaxInterestAccountPerChar", 5) + (PLUGIN.ExtraInterestAccounts[ply:GetUserGroup()]) or 0) ) then
        return false
    else
        return true
    end

end

netstream.Hook("JBanking_CreateGroupAccount", function(ply, name)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end

    local char = ply:GetCharacter()

    local bankID = PLUGIN:GenerateNumbers(6)

    if (!bankID) then return end

    if (!PLUGIN:GroupAccountsCount(char:GetID(),ply)) then
        ply:Notify("You can't create any more group accounts")
        return
    end

    PLUGIN:CreateNewGroupAccount(bankID, name, char:GetID(), char:GetName())

    ply:Notify("Group Account ["..bankID.."] has been created successfully")


end)

netstream.Hook("JBanking_GroupAccount_AddUser", function(ply, bankID, charToAdd_Data, permissions)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end

    PLUGIN:GroupAccont_AddUser(ply, tonumber(bankID), charToAdd_Data[1], charToAdd_Data[2], permissions)

end)

netstream.Hook("JBanking_GroupAccount_RemoveUser", function(ply, bankID, charKey, charID)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end

    PLUGIN:GroupAccont_RemoveUser(ply, tonumber(bankID), charKey, charID)

end)

netstream.Hook("JBanking_CreateInterestAccount", function(ply, pin, ownerID, ownerName)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end

    if (ply:GetCharacter():GetFaction() != PLUGIN.BankierFaction) then
        ply:Notify("You are not a bankier")
        return
    end

    local Targetchar = ix.char.loaded[ownerID]

    if (!Targetchar) then
        return
    end

    local Targetply = Targetchar:GetPlayer()

    if (!PLUGIN:GroupAccountsCount(tonumber(ownerID),Targetply)) then
        Targetply:Notify("You can't create any more interest accounts")
        ply:Notify("This player can't create any more interest accounts")
        return
    end

    local char = ply:GetCharacter()
    local inv = char:GetInventory()

    local bankID = PLUGIN:GenerateNumbers(6)
    local cardID = PLUGIN:GenerateNumbers(16)

    if (!bankID) then return end
    if (!bankcardIDID) then return end

    local bSuccess, error = inv:Add("debit_card", 1, {
        ["CardNumber"] = cardID,
        ["CardBankID"] = tonumber(bankID),
        ["CardPIN"] = pin,
    })

    if (bSuccess) then
        PLUGIN:CreateInterestAccount(bankID, ownerID, ownerName)

        ply:Notify("Interest account ["..bankID.."] has been created successfully")

    end

end)

netstream.Hook("JBanking_DeleteAccount", function(ply, bankID)
    
	if (!ply) then return end
	if (!ply:Alive()) then return end
	if (!ply:GetCharacter()) then return end
	if (!bankID) or (bankID == 0) then return end

    if (tonumber(PLUGIN:GetAccountLoan(bankID)) > 0) then
        ply:Notify("You must repay the loan before your account can be deleted")
        return
    end

	PLUGIN:DeleteAccount(bankID)

    ply:Notify("Account ["..bankID.."] has been successfully deleted")

end)

netstream.Hook("JBanking_GetNewCard", function(ply, pin, bankID)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end
    if (!bankID) or (bankID == 0) then return end

    local char = ply:GetCharacter()

    if (PLUGIN:GetOwner(bankID) != char:GetID()) and (!PLUGIN:GetPermissions(bankID)[char:GetID()].can_getcard) then

        ply:Notify("You don't own this account or don't have permissions to do that.")

        return
    end

    local inv = char:GetInventory()

    local data = {
        ["CardBankID"] = tonumber(bankID),
    }

    local item = inv:HasItem("debit_card", data)

    if (item) then
        ply:Notify("You already have a card for this account")
        return
    end

    local cardID = PLUGIN:GenerateNumbers(16)

    local bSuccess, error = inv:Add("debit_card", 1, {
        ["CardNumber"] = cardID,
        ["CardBankID"] = tonumber(bankID),
        ["CardPIN"] = pin,
    })

    if (bSuccess) then
        ply:Notify("A card created successfully.")

    end

end)

netstream.Hook("JBanking_ChangeCardPIN", function(ply, pin, card)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end

    local char = ply:GetCharacter()
    local inv = char:GetInventory()

    local data = {
        ["CardNumber"] = card,
    }

    local item = inv:HasItem("debit_card", data)

    if (item) then

        item:SetData("CardPIN", pin)

        ply:Notify("PIN changed succesfully.")

    end

end)

function PLUGIN:GetAccountMoney(bankid)

    local output = 0

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do
            if (tonumber(v.account_id) == bankid) then
                output = v.money
                break
            end
        end

    end)
    print(tonumber(output))
    return tonumber(output)

end

function PLUGIN:GetAccountLoan(bankid)

    local output = 0

    self:GetAllAccountsData(function(data)

        for k, v in pairs(data) do
            if (tonumber(v.account_id) == bankid) then
                output = v.loan
                break
            end
        end

    end)

    return output

end

netstream.Hook("ixJRBanking_Withdraw", function(ply, bankID, money)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end
    if (!bankID) or (bankID == 0) then print("ixJRBanking_Withdraw - bankID is 0") return end
    if (!money) or (money == 0) then print("ixJRBanking_Withdraw - money is 0") return end

    local char = ply:GetCharacter()

    if (PLUGIN:GetOwner(bankID) != char:GetID()) and (!PLUGIN:GetPermissions(bankID)[char:GetID()].can_withdraw) then

        ply:Notify("You don't own this account or don't have permissions to do that.")

        return
    end


    if (tonumber(PLUGIN:GetAccountLoan(bankID)) > 0) then
        if (tonumber(PLUGIN:GetLoanTime(bankid)) == 0) then
            ply:Notify("This account has an outstanding loan and has been blocked")
            return
        end
    end

    if (tonumber(PLUGIN:GetAccountMoney(bankID)) < money) then
        ply:Notify("You don't have enough money in your account.")
        return
    end

    char:SetMoney(math.max( 0, char:GetMoney() + money))
    PLUGIN:UpdateBalance(bankID, PLUGIN:GetAccountMoney(bankID) - money)

    ply:Notify("You withdrawed " .. ix.currency.Get(money) .. ".")

end)

netstream.Hook("ixJRBanking_Deposit", function(ply, bankID, money)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end
    if (!bankID) or (bankID == 0) then print("ixJRBanking_Deposit - bankID is 0") return end
    if (!money) or (money == 0) then print("ixJRBanking_Deposit - money is 0") return end

    local char = ply:GetCharacter()

    if (PLUGIN:GetOwner(bankID) != char:GetID()) and (!PLUGIN:GetPermissions(bankID)[char:GetID()].can_deposit) then
        ply:Notify("You don't own this account or don't have permissions to do that.")
        return
    end

    if (tonumber(PLUGIN:GetAccountLoan(bankID)) > 0) then
        if (tonumber(PLUGIN:GetLoanTime(bankid)) == 0) then
            ply:Notify("This account has an outstanding loan and has been blocked")
            return
        end
    end

    if (char:GetMoney() < money) then
        ply:Notify("You don't have enough money.")
        return
    end

    char:SetMoney(math.max( 0, char:GetMoney() - money))
    PLUGIN:UpdateBalance(bankID, PLUGIN:GetAccountMoney(bankID) + money)

    ply:Notify("You deposited " .. ix.currency.Get(money) .. ".")

end)

netstream.Hook("ixJRBanking_Transfer", function(ply, bankID, targetBankID, money)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end
    if (!bankID) or (bankID == 0) then print("ixJRBanking_Transfer - bankID is 0") return end
    if (!targetBankID) or (targetBankID == 0) then print("ixJRBanking_Transfer - targetBankID is 0") return end
    if (!money) or (money == 0) then print("ixJRBanking_Transfer - money is 0") return end

    local char = ply:GetCharacter()

    if (PLUGIN:GetOwner(bankID) != char:GetID()) and (!PLUGIN:GetPermissions(bankID)[char:GetID()].can_transfer) then
        ply:Notify("You don't own this account or don't have permissions to do that.")
        return
    end

    if (tonumber(PLUGIN:GetAccountLoan(bankID)) > 0) then
        if (tonumber(PLUGIN:GetLoanTime(bankid)) == 0) then
            ply:Notify("This account has an outstanding loan and has been blocked")
            return
        end
    end

    if (tonumber(PLUGIN:GetAccountMoney(bankID)) < money) then
        ply:Notify("You don't have enough money in your account.")
        return
    end

    PLUGIN:UpdateBalance(bankID, PLUGIN:GetAccountMoney(bankID) - money)
    PLUGIN:UpdateBalance(targetBankID, PLUGIN:GetAccountMoney(targetBankID) + money)

    ply:Notify("You transfered money to '"..targetBankID.."'.")

    PLUGIN:GetAllAccountsData(function(data)

        for k, v in pairs(data) do

            if (tonumber(v.account_id) == targetBankID) then
            
                local OwnersTable = util.JSONToTable(v.owners)

                for k, v in pairs(OwnersTable) do
        
                    local targetChar = ix.char.loaded[tonumber(v.charID)]
                    
                    if (targetChar) then
                        if (targetChar:GetPlayer():GetCharacter() == targetChar) then
                            targetChar:GetPlayer():Notify("You get " .. ix.currency.Get(money) .. " from '".. bankID .. "'.")
                        end
                    end


                end
                break
            end

        end

    end)

end)


netstream.Hook("JBanking_GiveALoan", function(ply, bankID, amount, days)

    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end
    if (!bankID) or (bankID == 0) then print("ixJRBanking_Transfer - bankID is 0") return end
    if (amount > 20000) or (amount < 500) then return end
    if (days < 1) or (days > 30) then return end

    if (ply:GetCharacter():GetFaction() != PLUGIN.BankierFaction) then
        ply:Notify("You are not a bankier")
        return
    end

    PLUGIN:GetAllAccountsData(function(data)

        for k, v in pairs(data) do

            if (tonumber(v.account_id) != bankID) then continue end

            local ownerID = tonumber(v.owner)
            local char = ix.char.loaded[ownerID]
            local Charply

            if (char) then
                Charply = ix.char.loaded[ownerID]:GetPlayer()
            else
                ply:Notify("Invalid character")
                return
            end

            if (char) and (Charply) then

                if (tonumber(PLUGIN:GetAccountLoan(bankID)) > 0) then
                    Charply:Notify("You need to repay your loan before you take out another one")
                    ply:Notify("This person already has a loan on this account")
                    return
                end

                if (Charply:GetCharacter() and Charply:GetCharacter():GetID() == ownerID) then
                    Charply:Notify("You have a loan on account id " .. bankID.. " in the amount of " .. ix.currency.Get(amount))
                    ply:Notify("You give a loan to account " .. bankID.. " in the amount of " .. ix.currency.Get(amount))
                    Charply:Notify("Funds have been added to your account")
                end

                PLUGIN:UpdateLoan(bankID,amount)
                PLUGIN:UpdateLoanTime(bankID, days)
                PLUGIN:UpdateBalance(bankID, PLUGIN:GetAccountMoney(bankID) + amount)

            end
            break
        end
    end)

    

end)

netstream.Hook("ixJRBanking_PayLoan", function(ply, bankID, money)
    
    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end
    if (!bankID) or (bankID == 0) then print("ixJRBanking_PayLoan - bankID is 0") return end
    if (!money) or (money == 0) then print("ixJRBanking_PayLoan - money is 0") return end

    local char = ply:GetCharacter()

    if (PLUGIN:GetOwner(bankID) != char:GetID()) then
        ply:Notify("You don't own this account.")
        return
    end

    money = math.min(money, PLUGIN:GetAccountLoan(bankID))

    if (char:GetMoney() < money) then
        ply:Notify("You don't have enough money.")
        return
    end

    char:SetMoney(math.max( 0, char:GetMoney() - money))
    PLUGIN:UpdateLoan(bankID, PLUGIN:GetAccountLoan(bankID) - money, "nochange")

    ply:Notify("You have paid off ".. ix.currency.Get(money) .. " loan.")

    if (tonumber(PLUGIN:GetAccountLoan(bankID)) == 0) then    
        ply:Notify("You paid off the entire loan.")
        PLUGIN:UpdateLoanTime(bankID, 0)
    end

end)

//JBanking_GiveSafeBox

netstream.Hook("JBanking_GiveSafeBox", function(ply, bankID, boxType)

    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end
    if (!bankID) or (bankID == 0) then print("JBanking_GiveSafeBox - bankID is 0") return end
    if (!boxType) or (boxType == 0) then print("JBanking_GiveSafeBox - boxType is 0") return end

    if (ply:GetCharacter():GetFaction() != PLUGIN.BankierFaction) then
        ply:Notify("You are not a bankier")
        return
    end

    local BoxCost = (boxType == 2 and 350) or 150

    local boxW = (boxType == 2 and 4) or 3
    local boxH = (boxType == 2 and 4) or 3

    PLUGIN:GetAllAccountsData(function(data)

        for k, v in pairs(data) do

            if (tonumber(v.account_id) != bankID) then continue end

            local ownerID = tonumber(v.owner)
            local char = ix.char.loaded[ownerID]
            local Charply

            if (char) then
                Charply = char:GetPlayer()
            else
                ply:Notify("Invalid character")
                return
            end

            if (char) and (Charply) then

                if (char:GetData("SDepositBoxW") == boxW) and (char:GetData("SDepositBoxH") == boxH) then
                    if (char:GetData("SDepositBoxID", 0) != 0) then
                        Charply:Notify("You can only have one safe deposit box")
                        ply:Notify("This person already has a safe deposit box")
                        return
                    end
                end

                if (tonumber(PLUGIN:GetAccountMoney(bankID)) < BoxCost) then
                    Charply:Notify("You don't have enough money in this account")
                    ply:Notify("This account does not have enough money")
                    return
                end

                if (Charply:GetCharacter() and Charply:GetCharacter():GetID() == ownerID) then
                    Charply:Notify("You got a safe deposit box for this account")
                    ply:Notify("You gave a safe deposit box for this account")
                end

                PLUGIN:AssignSafetyBox(bankID,boxType,char)
                PLUGIN:UpdateBalance(bankID, PLUGIN:GetAccountMoney(bankID) - BoxCost)

            end
            break
        end
    end)

end)


netstream.Hook("JBanking_CleanMoney", function(ply)

    if (!ply) then return end
    if (!ply:Alive()) then return end
    if (!ply:GetCharacter()) then return end

    local char = ply:GetCharacter()
    local inv = char:GetInventory()

    local moneyCount = 0

    local splitforNPC = 58

    for k, v in pairs(inv:GetItems()) do
        if (v.uniqueID != "duffelbag") then continue end

        moneyCount = moneyCount + (5000 * v:getStacks())

    end

    if (moneyCount == 0) then
        ply:Notify("You don't have any money bags")
        return
    end

    splitforNPC = math.Round(splitforNPC - math.min(25,moneyCount/2500),0)

    local splitForPly = 100 - splitforNPC

    local SplittedMoney = math.Round((splitForPly*moneyCount)/100,0)

    for k, v in pairs(inv:GetItems()) do
        if (v.uniqueID != "duffelbag") then continue end
        v:Remove()
    end

    char:SetMoney(math.max( 0, char:GetMoney() + SplittedMoney))

    ply:Notify("You get "..ix.currency.Get(SplittedMoney).." clean money")

end)