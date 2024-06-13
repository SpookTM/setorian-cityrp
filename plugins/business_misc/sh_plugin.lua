PLUGIN.name = "Business Extended"
PLUGIN.author = "JohnyReaper"
local PLUGIN = PLUGIN

ix.config.Add("AdPrice", 150, "The cost of creating an advertisement", nil, {
    data = {min = 0, max = 1000},
    category = "Business Extended"
})

ix.config.Add("CertificationPrice", 10000, "The cost of purchasing a certificate", nil, {
    data = {min = 0, max = 1000000},
    category = "Business Extended"
})

ix.config.Add("AdCooldown", 5, "Advertisement cooldown in minutes", nil, {
    data = {min = 0, max = 60},
    category = "Business Extended"
})

ix.chat.Register("advertisement", {
    format = "[Advertisement] %s",
    GetColor = function(self, speaker, text)
        return Color(254, 202, 87)
        -- -- If you are looking at the speaker, make it greener to easier identify who is talking.
        -- if (LocalPlayer():GetEyeTrace().Entity == speaker) then
        --     return ix.config.Get("chatListenColor")
        -- end

        -- -- Otherwise, use the normal chat color.
        -- return ix.config.Get("chatColor")
    end,
    CanHear = function(self, speaker, listener)
        -- the speaking player will be heard by everyone
        return true
    end,
    CanSay = function(self, speaker,text)
        
        local char = speaker:GetCharacter()

        if (char:GetData("AdCooldown", 0) > CurTime()) then
            speaker:Notify("You created an advertisement a while ago. Please try again later.")
            return false
        elseif (char:GetMoney() < ix.config.Get("AdPrice", 150)) then
            speaker:NotifyLocalized("insufficientMoney")
            return false
        else
            return true
        end

    end,
    OnChatAdd = function(self,speaker, text, anonymous, info)
        local color = self:GetColor(speaker, text, info)
        chat.AddText(color, string.format(self.format, text))
    end,
    prefix = {"/advert", "/ad"},
    description = "Create an advertisement that will appear in the chat",
    indicator = "Adverting",
    deadCanChat = false
})

function PLUGIN:SentNetTable(tableNet)

    local json = util.TableToJSON(tableNet)
    local compressedTable = util.Compress( json )
    local bytes = #compressedTable

    net.WriteUInt( bytes, 16 )
    net.WriteData( compressedTable, bytes )

end

function PLUGIN:ReadNetTable()

    local tableNet = false

    local bytes = net.ReadUInt( 16 )
    local compressedJson = net.ReadData( bytes )
    local DecompressJson = util.Decompress( compressedJson )

    tableNet = util.JSONToTable(DecompressJson)

    return tableNet

end

if (SERVER) then

    function PLUGIN:LoadData()
        self:LoadJRBusinesNPC()
        self:LoadJRPhones()
        self:LoadJRCashRegisters()
    end

    function PLUGIN:SaveData()
        self:SaveJRBusinesNPC()
        self:SaveJRPhones()
        self:SaveJRCash()
    end

    function PLUGIN:SaveJRBusinesNPC()
        local data = {}

        for _, v in ipairs(ents.FindByClass("j_business_npc")) do
            data[#data + 1] = {v:GetPos(), v:GetAngles()}
        end

        ix.data.Set("jr_business_npc", data)

    end

    function PLUGIN:SaveJRPhones()
        local data = {}

        for _, v in ipairs(ents.FindByClass("j_business_phone")) do
            data[#data + 1] = {v:GetPos(), v:GetAngles(), v:aphone_GetNumber()}
        end

        ix.data.Set("jr_business_phones", data)

    end

    function PLUGIN:SaveJRCash()
        local data = {}

        for _, v in ipairs(ents.FindByClass("j_business_cashregister")) do
            data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetOwnerCharID(), v:GetBankID(), v:GetFunds(), v.Permissions, v.ItemsInside}
        end

        ix.data.Set("jr_business_cregister", data)

    end

    function PLUGIN:LoadJRBusinesNPC()
        for _, v in ipairs(ix.data.Get("jr_business_npc") or {}) do
            local npc = ents.Create("j_business_npc")

            npc:SetPos(v[1])
            npc:SetAngles(v[2])
            npc:Spawn()
            
        end
    end


    function PLUGIN:LoadJRPhones()
        for _, v in ipairs(ix.data.Get("jr_business_phones") or {}) do
            local ent = ents.Create("j_business_phone")

            ent:SetPos(v[1])
            ent:SetAngles(v[2])
            ent:Spawn()
            ent:SetPhoneNumber(v[3])

            local phys = ent:GetPhysicsObject()
    
            if phys:IsValid() then

                phys:EnableMotion(false)

            end
            
        end
    end

    function PLUGIN:LoadJRCashRegisters()
        for _, v in ipairs(ix.data.Get("jr_business_cregister") or {}) do
            local ent = ents.Create("j_business_cashregister")

            ent:SetPos(v[1])
            ent:SetAngles(v[2])
            ent:Spawn()
            ent:SetOwnerCharID(v[3])
            ent:SetBankID(v[4])

            ent:SetFunds(v[5]) 

            ent.Permissions = v[6]
            ent.ItemsInside = v[7]

            local phys = ent:GetPhysicsObject()
    
            if phys:IsValid() then

                phys:EnableMotion(false)

            end
            
        end
    end

    gameevent.Listen( "player_activate" )

    -- function PLUGIN:player_activate(data)
    function PLUGIN:PlayerLoadedCharacter(ply,char, prevchar)
        -- local id = data.userid

        -- local ply = Player(id)

        if (!ply.sentPhonesNumbers) then

            local nums = {}

            for k, v in ipairs(ents.FindByClass( "j_business_phone" )) do
                nums[v:aphone_GetNumber()] = v:EntIndex()
            end
            
            net.Start("ixBPhone_SentNumbers")
                self:SentNetTable(nums)
            net.Send(ply)
            ply.sentPhonesNumbers = true
        end

    end

    function PLUGIN:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
        if (chatType == "advertisement") then

            local adPrice = ix.config.Get("AdPrice", 150)
            local adCoolDown = ix.config.Get("AdCooldown", 5) * 60

            local char = speaker:GetCharacter()

            char:SetMoney(char:GetMoney() - adPrice)
            char:SetData("AdCooldown", adCoolDown)

        end
    end

    function PLUGIN:aphone_calls(status, ply1, ply2)

        if (status == 3) then
            if (ply1.GetLocalVar and ply1:GetLocalVar("BPhone_Ent", nil) != nil) and (IsValid(ply1:GetLocalVar("BPhone_Ent", nil))) then
                net.Start("ixBPhone_SentStatus")
                    net.WriteUInt(4, 3)
                net.Send(ply1)
            end
            if (ply2.GetLocalVar and ply2:GetLocalVar("BPhone_Ent", nil) != nil) and (IsValid(ply2:GetLocalVar("BPhone_Ent", nil))) then
                net.Start("ixBPhone_SentStatus")
                    net.WriteUInt(4, 3)
                net.Send(ply2)
            end
            if (ply1:GetClass() == "j_business_phone") then
                ply1:EndCall()
            end
            if (ply2:GetClass() == "j_business_phone") then
                ply2:EndCall()
            end
        end

    end

    function PLUGIN:OnEntityCreated(ent)
        if (ent:GetClass() == "j_business_phone") then
            timer.Simple(0.2, function()
                net.Start("ixBPhone_SentNumber")
                    net.WriteString(ent:aphone_GetNumber())
                    -- net.WriteEntity(ent)
                    net.WriteUInt(ent:EntIndex(), 16)
                net.Broadcast()
            end)
        end
    end

    util.AddNetworkString("ixBCard_EditText")
    util.AddNetworkString("ixBCard_EditColor")

    util.AddNetworkString("ixBCerti_OpenUI")
    util.AddNetworkString("ixBCerti_Buy")

    util.AddNetworkString("ixBPhone_OpenUI")
    util.AddNetworkString("ixBPhone_CloseUI")
    util.AddNetworkString("ixBPhone_EndCall")
    util.AddNetworkString("ixBPhone_SentStatus")
    util.AddNetworkString("ixBPhone_SentNumber")
    util.AddNetworkString("ixBPhone_SentNumbers")

    util.AddNetworkString("ixBCashR_OpenUI")
    util.AddNetworkString("ixBCashR_Buy")
    util.AddNetworkString("ixBCashR_SetBankID")
    util.AddNetworkString("ixBCashR_Withdraw")
    util.AddNetworkString("ixBCashR_SetLock")
    util.AddNetworkString("ixBCashR_PermissionsManage")
    util.AddNetworkString("ixBCashR_ItemManage")
    util.AddNetworkString("ixBCashR_SetPrice")

    net.Receive("ixBPhone_CloseUI", function(len, ply)
        ply:SetLocalVar("BPhone_Ent",nil)
    end)

    net.Receive("ixBPhone_EndCall", function(len, ply)

        if ply.aphoneCallID then
            local t = aphone.Call.Table[ply.aphoneCallID]

            if !t then
                ply.aphoneCallID = nil
                return
            end

            aphone.Call.Table[ply.aphoneCallID] = nil

            if IsValid(t.ent1) then
                t.ent1.aphone_PVS = nil
                t.ent1.aphoneCallID = nil
            end

            if IsValid(t.ent2) then
                t.ent2.aphone_PVS = nil
                t.ent2.aphoneCallID = nil
            end

            net.Start("aphone_Phone")
                net.WriteUInt(5, 4)
            net.Send({t.ent1, t.ent2})
        end

    end)

    -- local PLUGINBank = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

    net.Receive("ixBCashR_Buy", function(len, ply)

        local PLUGINBank = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

        local cashEnt = net.ReadEntity()

        if (!IsValid(cashEnt)) and (cashEnt:GetClass() != "models/props_c17/cashregister01a.mdl") then return end

        if (ply:GetPos():DistToSqr(cashEnt:GetPos()) > 115*115) then return end

        local itemID = net.ReadString()

        local bankID = net.ReadUInt(20)

        if (cashEnt:GetFunds() >= 5000) and (bankID == 0) then
            ply:Notify("The Cash register is full and payment cannot be processed")
            return
        end

        if (bankID != 0) and (cashEnt:GetBankID() == 0) then
            ply:Notify("The cash register does not have bank payments set up")
            return
        end

        if (cashEnt.ItemsInside[itemID]) then

            local char = ply:GetCharacter()
            local inv = char:GetInventory()

            local itemPrice = cashEnt.ItemsInside[itemID].IPrice

            if (bankID != 0) then

                if (tonumber(PLUGINBank:GetAccountMoney(bankID)) < itemPrice) then
                    ply:Notify("You don't have enough money in your account.")
                    return
                end

            else

                if (itemPrice > 5000) then
                    ply:Notify("This payment is larger than "..ix.currency.Get(5000).." must use a card to pay.")
                    return
                end

                if (char:GetMoney() < itemPrice) then
                    ply:NotifyLocalized("canNotAfford")
                    return
                end

            end

            local invAdd, invErr = inv:Add(itemID)

            if (invAdd) then

                if (bankID != 0) then
                    PLUGINBank:UpdateBalance(bankID, PLUGINBank:GetAccountMoney(bankID) - itemPrice)
                else
                    char:SetMoney(char:GetMoney() - itemPrice)
                end

                ply:NotifyLocalized("businessPurchase",cashEnt.ItemsInside[itemID].IName,ix.currency.Get(itemPrice))

                cashEnt.ItemsInside[itemID].IStock = cashEnt.ItemsInside[itemID].IStock - 1

                if (cashEnt.ItemsInside[itemID].IStock <= 0) then
                    cashEnt.ItemsInside[itemID] = nil
                end

                if (bankID != 0) and (cashEnt:GetBankID() != 0) then
                    PLUGINBank:UpdateBalance(cashEnt:GetBankID(), PLUGINBank:GetAccountMoney(cashEnt:GetBankID()) + itemPrice)
                else
                    cashEnt:SetFunds(cashEnt:GetFunds()+itemPrice)
                end

                net.Start("ixBCashR_ItemManage")
                    net.WriteEntity(cashEnt)
                    PLUGIN:SentNetTable(cashEnt.ItemsInside)
                net.Broadcast()


            else
                ply:NotifyLocalized(invErr)
            end

        end

    end)

    net.Receive("ixBCashR_SetPrice", function(len, ply)

        local cashEnt = net.ReadEntity()

        if (!IsValid(cashEnt)) and (cashEnt:GetClass() != "models/props_c17/cashregister01a.mdl") then return end

        if (ply:GetPos():DistToSqr(cashEnt:GetPos()) > 115*115) then return end

        local itemID = net.ReadString()
        local itemPrice = net.ReadUInt(32)

        if (cashEnt.ItemsInside[itemID]) then
            cashEnt.ItemsInside[itemID].IPrice = itemPrice
        
            ply:Notify("The price of "..cashEnt.ItemsInside[itemID].IName.." has been changed")

            net.Start("ixBCashR_ItemManage")
                net.WriteEntity(cashEnt)
                PLUGIN:SentNetTable(cashEnt.ItemsInside)
            net.Broadcast()

        end

    end)

    net.Receive("ixBCashR_ItemManage", function(len, ply)

        local cashEnt = net.ReadEntity()

        if (!IsValid(cashEnt)) and (cashEnt:GetClass() != "models/props_c17/cashregister01a.mdl") then return end

        if (ply:GetPos():DistToSqr(cashEnt:GetPos()) > 115*115) then return end

        local IsAdd = net.ReadBool()

        local char = ply:GetCharacter()
        local inv = char:GetInventory()

        if (IsAdd) then

            if (char:GetID() != cashEnt:GetOwnerCharID()) and (cashEnt.Permissions[char:GetID()] and (!cashEnt.Permissions[char:GetID()].CanAddItems) and (!cashEnt.Permissions[char:GetID()].CanAddStock)) then
                ply:NotifyLocalized("notNow")
                return
            end

            local itemID = net.ReadUInt(14)

            local item = inv:GetItemByID(itemID)

            if (item) then

                if (cashEnt.ItemsInside[item.uniqueID] and cashEnt.ItemsInside[item.uniqueID].IStock > 0) then
                    cashEnt.ItemsInside[item.uniqueID].IStock = cashEnt.ItemsInside[item.uniqueID].IStock + 1
                else

                    if (char:GetID() != cashEnt:GetOwnerCharID() and cashEnt.Permissions[char:GetID()] and (!cashEnt.Permissions[char:GetID()].CanAddItems)) then
                        ply:Notify("You cannot add a new item. You can only replenish the stock.")
                        return
                    end

                    cashEnt.ItemsInside[item.uniqueID] = {
                        IName = item.name,
                        IDesc = item.description,
                        IModel = item.model,
                        IPrice = 100,
                        IStock = 1,
                    }
                end

                item:Remove()

                ply:Notify("The "..item.name.." has been added to the stock")

            end

        else

            if (char:GetID() != cashEnt:GetOwnerCharID()) and (cashEnt.Permissions[char:GetID()] and (!cashEnt.Permissions[char:GetID().CanRemoveItem])) then
                ply:NotifyLocalized("notNow")
                return
            end

            local itemID = net.ReadString()

            if (cashEnt.ItemsInside[itemID]) then

                local invAdd, invErr = inv:Add(itemID)

                if (invAdd) then

                    cashEnt.ItemsInside[itemID].IStock = cashEnt.ItemsInside[itemID].IStock - 1

                    if (cashEnt.ItemsInside[itemID].IStock <= 0) then
                        cashEnt.ItemsInside[itemID] = nil
                    end
                    ply:Notify("You took the item from the stock")
                else
                    ply:NotifyLocalized(invErr)
                end

            end

        end

        net.Start("ixBCashR_ItemManage")
            net.WriteEntity(cashEnt)
            PLUGIN:SentNetTable(cashEnt.ItemsInside)
        net.Broadcast()

    end)

    net.Receive("ixBCashR_SetBankID", function(len, ply)

        local PLUGINBank = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

        local cashEnt = net.ReadEntity()

        if (!IsValid(cashEnt)) and (cashEnt:GetClass() != "models/props_c17/cashregister01a.mdl") then return end

        if (ply:GetPos():DistToSqr(cashEnt:GetPos()) > 115*115) then return end
        local char = ply:GetCharacter()
        if (char:GetID() != cashEnt:GetOwnerCharID()) then return end

        local bankID = tonumber(net.ReadString())

        if ((PLUGINBank:GetOwner(bankID)) or (!table.IsEmpty(PLUGINBank:GetOwners(bankid)))) then

            cashEnt:SetBankID(tonumber(bankID))
            ply:Notify("You have set up a bank account")

        else
            ply:Notify("Bank account does not exist or you do not have permission to use it")
        end


    end)

    net.Receive("ixBCashR_PermissionsManage", function(len, ply)

        local cashEnt = net.ReadEntity()

        if (!IsValid(cashEnt)) and (cashEnt:GetClass() != "models/props_c17/cashregister01a.mdl") then return end

        if (ply:GetPos():DistToSqr(cashEnt:GetPos()) > 115*115) then return end
        local char = ply:GetCharacter()
        if (char:GetID() != cashEnt:GetOwnerCharID()) then return end

        local newOwner = net.ReadBool()
        local newCharID = net.ReadUInt(12)

        if (newOwner) then

            local charOptions = PLUGIN:ReadNetTable()

            cashEnt.Permissions[newCharID] = charOptions

            ply:Notify("The person has been added to co-owners")

        else

            if (cashEnt.Permissions[newCharID]) then
                cashEnt.Permissions[newCharID] = nil
            end

            ply:Notify("The person has been removed from co-owners")

        end

        net.Start("ixBCashR_PermissionsManage")
            net.WriteEntity(cashEnt)
            PLUGIN:SentNetTable(cashEnt.Permissions)
        net.Broadcast()

    end)

    net.Receive("ixBCashR_Withdraw", function(len, ply)

        local cashEnt = net.ReadEntity()

        if (!IsValid(cashEnt)) and (cashEnt:GetClass() != "models/props_c17/cashregister01a.mdl") then return end

        if (ply:GetPos():DistToSqr(cashEnt:GetPos()) > 115*115) then return end

        local char = ply:GetCharacter()

        if (char:GetID() == cashEnt:GetOwnerCharID()) or (cashEnt.Permissions[char:GetID()] and cashEnt.Permissions[char:GetID()].CanTakeFunds) then

            local funds = cashEnt:GetFunds()

            char:SetMoney(char:GetMoney() + funds)
            cashEnt:SetFunds(0)

            ply:Notify("You have withdrawn "..ix.currency.Get(funds).." from the cash register")

        else
            ply:NotifyLocalized("notNow")
        end

    end)

    net.Receive("ixBCashR_SetLock", function(len, ply)

        local cashEnt = net.ReadEntity()

        if (!IsValid(cashEnt)) and (cashEnt:GetClass() != "models/props_c17/cashregister01a.mdl") then return end

        if (ply:GetPos():DistToSqr(cashEnt:GetPos()) > 115*115) then return end

        local char = ply:GetCharacter()

        if (char:GetID() == cashEnt:GetOwnerCharID()) then

            cashEnt:SetIsLock(!cashEnt:GetIsLock())

            ply:Notify("The lock status has changed")

        else
            ply:NotifyLocalized("notNow")
        end

    end)

    net.Receive("ixBCerti_Buy", function(len, ply)

        local bName = net.ReadString()

        if (string.len( bName ) == 0) then
            ply:Notify("The business name must not be empty")
            return
        end

        local certPrice = ix.config.Get("CertificationPrice", 10000)
        local char = ply:GetCharacter()
        local inv = char:GetInventory()

        if (char:GetMoney() < ix.config.Get("CertificationPrice", 10000)) then
            ply:NotifyLocalized("insufficientMoney")
            return
        end

        local formatTime = "%m.%d.%Y"

        local itemData = {
            ["BCerti_Name"] = bName,
            ["BCerti_Sign"] = char:GetName(),
            ["BCerti_Date"] = os.date(formatTime)--ix.date.GetFormatted(formatTime),
        }

        local isSucces, invError = inv:Add("business_certification",1,itemData)

        if (isSucces) then
            ply:NotifyLocalized("businessPurchase", "Business Certification", ix.currency.Get(certPrice))
            char:SetMoney(char:GetMoney() - certPrice)
        else
            ply:NotifyLocalized(invError)
        end


    end)

    net.Receive("ixBCard_EditText", function(len, ply)

        local editType = net.ReadUInt(3)
        local editText = net.ReadString()

        if (string.len( editText ) == 0) then return end

        local char = ply:GetCharacter()
        local inv = char:GetInventory()

        local cardItem = ply.editingBusinessCard --inv:HasItem("business_card")

        if (cardItem) then

            local dataType = {
                [1] = "BCard_Name",
                [2] = "BCard_Location",
                [3] = "BCard_Number",
                [4] = "BCard_Desc",
            }

            cardItem:SetData(dataType[editType], editText)

            ply:Notify("The string on the business card has been changed")

        end

    end)

    net.Receive("ixBCard_EditColor", function(len, ply)

        local editType = net.ReadUInt(2)
        local editText = net.ReadString()

        if (string.len( editText ) == 0) then return end

        local char = ply:GetCharacter()
        local inv = char:GetInventory()

        local cardItem = ply.editingBusinessCard

        if (cardItem) then

            local dataType = {
                [1] = "BCard_BGColor",
                [2] = "BCard_BGText",
            }

            cardItem:SetData(dataType[editType], editText)

            ply:Notify("The color on the business card has been changed")

        end

    end)


else

    function PLUGIN:LoadFonts(font, genericFont)

        surface.CreateFont("Setorian_Century1", {
            font = "Century Schoolbook",
            size = 20,
            antialias = true,
            weight = 4000,
        })

        surface.CreateFont("Setorian_Century2", {
            font = "Century Schoolbook",
            size = 14,
            antialias = true,
            weight = 4000,
        })

        surface.CreateFont("Setorian_Anthony1", {
            font = "Anthony Hunter",
            size = 40,
            antialias = true,
            weight = 100,
        })

    end

    net.Receive("ixBCashR_PermissionsManage", function(len, ply)

        local cashEnt = net.ReadEntity()

        local permissions = PLUGIN:ReadNetTable()

        if (ix.gui.BusinessCashUI) then
            ix.gui.BusinessCashUI.coowners = permissions
        end

    end)

    net.Receive("ixBCashR_ItemManage", function(len, ply)

        local cashEnt = net.ReadEntity()

        local items = PLUGIN:ReadNetTable()

        if (ix.gui.BusinessCashUI) then
            ix.gui.BusinessCashUI.items = items
            if (ix.gui.BusinessCashUI.productsBut.selected) then
                ix.gui.BusinessCashUI:PopulateProducts()
            end
        end

    end)


    net.Receive("ixBCard_EditText", function()

        local editType = net.ReadUInt(3)

        Derma_StringRequest(
            "Business Card", 
            "Input the text you want to put on the card",
            "",
            function(text)

                if (string.len( text ) != 0) then
                    net.Start("ixBCard_EditText")
                        net.WriteUInt(editType,3)
                        net.WriteString(text)
                    net.SendToServer()
                end

            end,
            function(text) end
        )

    end)

    net.Receive("ixBCard_EditColor", function()

        local editType = net.ReadUInt(2)

        local dataType = {
                [1] = "BCard_BGColor",
                [2] = "BCard_BGText",
            }

        Derma_StringRequest(
            "Business Card", 
            "Input the color (in RGB format) that you want to change.",
            "255 255 255",
            function(text)

                if (string.len( text ) != 0) then
                    net.Start("ixBCard_EditColor")
                        net.WriteUInt(editType,2)
                        net.WriteString(text)
                    net.SendToServer()
                end

            end,
            function(text) end
        )

    end)

    LocalPlayer().LocalBPhones = LocalPlayer().LocalBPhones or {}

    net.Receive("ixBPhone_SentNumber", function()

        local num = net.ReadString()
        -- local ent = net.ReadEntity()
        local entIndex = net.ReadUInt(16)

        -- print(num)
        LocalPlayer().LocalBPhones = LocalPlayer().LocalBPhones or {}
        LocalPlayer().LocalBPhones[num] = entIndex
        -- PrintTable(LocalPlayer().LocalBPhones)
    end)

    net.Receive("ixBPhone_SentNumbers", function()

        local nums = PLUGIN:ReadNetTable()
        LocalPlayer().LocalBPhones = nums

    end)

    net.Receive("ixBPhone_SentStatus", function()

        local status = net.ReadUInt(3)

        if (ix.gui.BusinessPhoneUI) then
            ix.gui.BusinessPhoneUI:RenderStatus(status)
        end

    end)

    net.Receive("ixBPhone_OpenUI", function()

        local upcomCall = net.ReadBool()

        local lastCalls = PLUGIN:ReadNetTable()

        local phoneUI = vgui.Create("ixBusinessPhoneUI")
        phoneUI.lastCalls = lastCalls
        phoneUI:RenderLatestCalls()

        if (upcomCall) and (LocalPlayer():GetLocalVar("BPhone_Ent")) then

            local phoneEnt = LocalPlayer():GetLocalVar("BPhone_Ent")

            phoneUI.CalledNumber = phoneEnt:GetCaller():aphone_GetNumber()
            phoneUI:RenderStatus(5)

            net.Start("aphone_Phone")
                net.WriteUInt(2, 4)
            net.SendToServer()

        end
        
    end)

    net.Receive("ixBCashR_OpenUI", function()

        local cashR = net.ReadEntity()
        -- print(cashR,IsValid(cashR), cashR:GetClass())
        if (!IsValid(cashR)) and (cashR:GetClass() != "models/props_c17/cashregister01a.mdl") then return end

        if (LocalPlayer():GetPos():DistToSqr(cashR:GetPos()) > 115*115) then return end

        local items = PLUGIN:ReadNetTable()

        local permissions = PLUGIN:ReadNetTable()

        local cashUI = vgui.Create("ixSetorian_CashRegUI")
        cashUI.cashEnt = cashR
        cashUI.items = items
        cashUI.coowners = permissions
        cashUI:PopulateProducts()

    end)

    net.Receive("ixBCerti_OpenUI", function()

        local ply = LocalPlayer()
        local char = ply:GetCharacter()
            
        Derma_StringRequest(
            "Business Certification", 
            "Enter the name of the business for which you want to buy a certificate. The cost is: "..ix.currency.Get(ix.config.Get("CertificationPrice", 10000)),
            "",
            function(text)

                if (string.len( text ) != 0) then
                    
                    if (char:GetMoney() < ix.config.Get("CertificationPrice", 10000)) then
                        ply:NotifyLocalized("insufficientMoney")
                        return
                    end

                    net.Start("ixBCerti_Buy")
                        net.WriteString(text)
                    net.SendToServer()

                else
                    ply:Notify("The business name must not be empty")
                end

            end,
            function(text) end
        )

    end)


end