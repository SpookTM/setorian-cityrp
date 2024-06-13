local PLUGIN = PLUGIN
PLUGIN.KeysShared = PLUGIN.KeysShared or {}
PLUGIN.SharedVehicles = PLUGIN.SharedVehicles or {}
PLUGIN.SharedForFactions = PLUGIN.SharedForFactions or {}
PLUGIN.AllowedSharedFactions = {
    [FACTION_CITIZEN] = true
}

if (SERVER) then

    util.AddNetworkString("KeySharing_CreateNewShare")
    util.AddNetworkString("KeySharing_RemoveShare")
    util.AddNetworkString("KeySharing_SyncSharing")
    util.AddNetworkString("KeySharing_SyncSharing_Req")
    util.AddNetworkString("KeySharing_PlyManage")  // Add or Remove

    PLUGIN.KeysShared.Properties = PLUGIN.KeysShared.Properties or {}
    PLUGIN.KeysShared.Vehicles = PLUGIN.KeysShared.Vehicles or {}

    function PLUGIN:LoadData()
        self:LoadSharedKeysFromDb()
    end

    function PLUGIN:SaveData()
        self:SaveSharedKeysToDb()
    end

    function PLUGIN:SaveSharedKeysToDb()

        local data = PLUGIN.KeysShared or {}

        ix.data.Set("jr_shared_keys_db", data)

    end

    function PLUGIN:LoadSharedKeysFromDb()

        local data = ix.data.Get("jr_shared_keys_db") or {}

        PLUGIN.KeysShared = data

    end

    function PLUGIN:OnReloaded()

        self:LoadSharedKeysFromDb()
        print("Shared Keys restored after reload")


    end

    function PLUGIN:PlayerLoadedCharacter(client, char, currentChar)

        local inv = char:GetInventory()

        local keysDeleted = false

        for k, v in ipairs(inv:GetItemsByUniqueID("housekey")) do

            if (v:GetData("IsSharedKey", false)) then

                if (PLUGIN.KeysShared.Properties[tonumber(v:GetData("PropertyID"))]) and (!table.IsEmpty(PLUGIN.KeysShared.Properties[tonumber(v:GetData("PropertyID"))])) then

                    if (!PLUGIN.KeysShared.Properties[tonumber(v:GetData("PropertyID"))].SharePly[char:GetID()]) then
                        keysDeleted = true
                        v:Remove()
                    end

                else
                    keysDeleted = true
                    v:Remove()
                end

            end
            
        end

        if (keysDeleted) then
            client:Notify("Someone has taken away your access to one of the shared properties")
        end

    end

    -- function PLUGIN:OnEntityCreated( ent )
    function PLUGIN:PlayerSpawnedVehicle(client, ent)

        timer.Simple(0.5, function()
            if (!ent) or (!IsValid(ent)) then return end

            if (ent:GetNetVar("owner")) then

                local ownerID = ent:GetNetVar("owner")

                self.KeysShared.Vehicles = self.KeysShared.Vehicles or {}

                if (self.KeysShared.Vehicles[ownerID]) and (self.KeysShared.Vehicles[ownerID][ent:GetVehicleClass()]) then
                    ent.ExtraSharedAccess = self.KeysShared.Vehicles[ownerID][ent:GetVehicleClass()].SharePly
                    self.SharedVehicles = self.SharedVehicles or {}
                    self.SharedVehicles[ownerID] = self.SharedVehicles[ownerID] or {}
                    self.SharedVehicles[ownerID][ent:GetVehicleClass()] = ent
                end

            end

        end)

    end

    function PLUGIN:EntityRemoved( ent )
        if (ent:IsVehicle()) then
            if (ent:GetNetVar("owner")) then

                local ownerID = ent:GetNetVar("owner")

                if (self.SharedVehicles) and (self.SharedVehicles[ownerID]) and (self.SharedVehicles[ownerID][ent:GetVehicleClass()]) then           
                    self.SharedVehicles[ownerID][ent:GetVehicleClass()] = nil
                end
            end
        end
    end

    function PLUGIN:SyncSharing(ply)

        local char = ply:GetCharacter()
        local inv  = char:GetInventory()

        local netTable = {}
        netTable.Properties = {}
        netTable.Vehicles = {}

        PLUGIN.KeysShared = PLUGIN.KeysShared or {}
        PLUGIN.KeysShared.Properties = PLUGIN.KeysShared.Properties or {}
        PLUGIN.KeysShared.Vehicles = PLUGIN.KeysShared.Vehicles or {}

        -- PrintTable(PLUGIN.KeysShared)
        // lua_run ix.plugin.Get("miscellaneous").KeysShared

        for k,v in ipairs(inv:GetItemsByUniqueID("housekey")) do

            if (tonumber(v:GetData("PropertyID")) > 0) and (!v:GetData("IsSharedKey", false)) then
                if (PLUGIN.KeysShared.Properties[tonumber(v:GetData("PropertyID"))]) and (!table.IsEmpty(PLUGIN.KeysShared.Properties[tonumber(v:GetData("PropertyID"))])) then
                    netTable.Properties[v:GetData("PropertyID")] = netTable.Properties[v:GetData("PropertyID")] or {}
                    netTable.Properties[v:GetData("PropertyID")].HouseName = v:GetData("HouseName")
                    netTable.Properties[v:GetData("PropertyID")].SharePly = PLUGIN.KeysShared.Properties[tonumber(v:GetData("PropertyID"))].SharePly or {}
                end
            end

        end

        netTable.Vehicles = PLUGIN.KeysShared.Vehicles[char:GetID()]


        net.Start("KeySharing_SyncSharing")
            local json = util.TableToJSON(netTable)
            local compressedTable = util.Compress( json )
            local bytes = #compressedTable

            net.WriteUInt( bytes, 16 )
            net.WriteData( compressedTable, bytes )
        net.Send(ply)

    end

    net.Receive("KeySharing_SyncSharing_Req", function(len, ply)

        PLUGIN:SyncSharing(ply)

    end)

    net.Receive("KeySharing_CreateNewShare", function(len, ply)
        
        local operationType = net.ReadUInt(2)

        local char = ply:GetCharacter()

        if (operationType == 1) then

            local keyID = net.ReadUInt(8)

            local targetClient = net.ReadEntity()
            if (!targetClient:IsPlayer()) then return end

            if (targetClient == ply) then
                if (!PLUGIN.AllowedSharedFactions or !PLUGIN.AllowedSharedFactions[char:GetFaction()]) then
                    ply:Notify("You can't make it available to faction members")
                    return
                end
            end

            local inv  = char:GetInventory()

            -- local keyItem = inv:GetItemByID(keyID)

            local keyItem = inv:HasItem("house_key",{
                    ["PropertyID"] = keyID,
                })

            if (keyItem) then

                if (tonumber(keyItem:GetData("PropertyID")) > 0) and (!keyItem:GetData("IsSharedKey", false)) then

                    if (targetClient == ply) then

                        local numberID = tonumber(keyItem:GetData("PropertyID"))

                        local targetChar = targetClient:GetCharacter()

                        PLUGIN.KeysShared.Properties[numberID] = PLUGIN.KeysShared.Properties[numberID] or {}
                        PLUGIN.KeysShared.Properties[numberID].SharePly = PLUGIN.KeysShared.Properties[numberID].SharePly or {}
                        PLUGIN.KeysShared.Properties[numberID].SharePly[targetChar:GetID()] = targetChar:GetName()
                        PLUGIN.KeysShared.Properties[numberID].Owner = char:GetID()

                        PLUGIN.KeysShared.Properties[numberID].Faction = char:GetFaction()

                        -- PLUGIN.SharedForFactions = PLUGIN.SharedForFactions or {}
                        -- PLUGIN.SharedForFactions[char:GetFaction()] = PLUGIN.SharedForFactions[char:GetFaction()] or {}
                        -- PLUGIN.SharedForFactions[char:GetFaction()].Properties = PLUGIN.SharedForFactions[char:GetFaction()].Properties or {}
                        -- PLUGIN.SharedForFactions[char:GetFaction()].Properties[numberID] = true

                        for client, character in ix.util.GetCharacters() do
                            if (client == ply) then continue end
                            if (character:GetFaction() != PLUGIN.KeysShared.Properties[numberID].Faction) then continue end
                            local targetInv = character:GetInventory()
        

                            local bSuccess, error = targetInv:Add("housekey", 1, {
                                ["PropertyID"] = keyItem:GetData("PropertyID"),
                                ["HouseName"] = keyItem:GetData("HouseName"),
                                ["IsTemp"] = true,
                                ["IsSharedKey"] = true,
                                ["NoDrop"] = true
                            })

                            if (bSuccess) then
                                client:Notify("Someone has made their property ["..keyItem:GetData("HouseName").."] available to you")
                            else
                                client:Notify("Someone tried to give you a faction key")
                                client:Notify(error)
                            end
                        end

                        ply:Notify("You have successfully created a new share")
                        PLUGIN:SaveSharedKeysToDb()
                        PLUGIN:SyncSharing(ply)

                    else

                        local targetChar = targetClient:GetCharacter()
                        local targetInv = targetChar:GetInventory()

                        local bSuccess, error = targetInv:Add("housekey", 1, {
                            ["PropertyID"] = keyItem:GetData("PropertyID"),
                            ["HouseName"] = keyItem:GetData("HouseName"),
                            ["IsTemp"] = true,
                            ["IsSharedKey"] = true,
                            ["NoDrop"] = true
                        })

                        if (bSuccess) then

                            local numberID = tonumber(keyItem:GetData("PropertyID"))

                            PLUGIN.KeysShared.Properties[numberID] = PLUGIN.KeysShared.Properties[numberID] or {}
                            PLUGIN.KeysShared.Properties[numberID].SharePly = PLUGIN.KeysShared.Properties[numberID].SharePly or {}
                            PLUGIN.KeysShared.Properties[numberID].SharePly[targetChar:GetID()] = targetChar:GetName()
                            PLUGIN.KeysShared.Properties[numberID].Owner = char:GetID()

                            ply:Notify("You have successfully created a new share")
                            targetClient:Notify("Someone has made their property ["..keyItem:GetData("HouseName").."] available to you")
                            PLUGIN:SaveSharedKeysToDb()
                            PLUGIN:SyncSharing(ply)
                        else
                            ply:Notify(error)
                            targetClient:Notify(error)
                        end

                    end

                else
                    ply:Notify("You do not have a key for this property or do not own it")
                end

            else
                ply:Notify("You don't have a key for this property")
            end

        elseif (operationType == 2) then

            local targetCar = net.ReadEntity()
            local targetClient = net.ReadEntity()

            if (!targetCar:IsVehicle()) then return end
            if (!targetClient:IsPlayer()) then return end

            local targetChar = targetClient:GetCharacter()

            if (targetCar:GetNetVar("owner") == char:GetID()) then

                local carClass = targetCar.VehicleName
                -- print(carClass)
                PLUGIN.KeysShared.Vehicles[char:GetID()] = PLUGIN.KeysShared.Vehicles[char:GetID()] or {}
                PLUGIN.KeysShared.Vehicles[char:GetID()][carClass] = PLUGIN.KeysShared.Vehicles[char:GetID()][carClass] or {}
                PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly = PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly or {}
                PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[targetChar:GetID()] = targetChar:GetName()

                if (targetClient == ply) then
                    PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].Faction = char:GetFaction()
                end

                ply:Notify("You have successfully created a new share")
                

                PLUGIN.SharedVehicles = PLUGIN.SharedVehicles or {}
                PLUGIN.SharedVehicles[char:GetID()] = PLUGIN.SharedVehicles[char:GetID()] or {}

                if (!PLUGIN.SharedVehicles[char:GetID()][carClass]) then

                    for k, v in ipairs(ents.GetAll()) do
                        if (v:IsVehicle()) then
                            if (v:GetNetVar("owner") == char:GetID()) then
                                PLUGIN.SharedVehicles[char:GetID()][carClass] = v
                                break
                            end
                        end
                    end
                end

                if (targetClient == ply) and (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].Faction) then
                    
                    for client, character in ix.util.GetCharacters() do
                        if (client == ply) then continue end
                        if (character:GetFaction() == PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].Faction) then continue end
                        if (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[character:GetID()]) then continue end

                        client:Notify("Someone has made their vehicle ["..list.Get( "Vehicles" )[ carClass ].Name.."] available to you")

                        targetCar.ExtraSharedAccess[character:GetID()] = character:GetName()

                    end

                else
                    targetClient:Notify("Someone has made their vehicle ["..list.Get( "Vehicles" )[ carClass ].Name.."] available to you")
                    targetCar.ExtraSharedAccess = PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly
                end

                PLUGIN:SaveSharedKeysToDb()
                PLUGIN:SyncSharing(ply)

            else
                ply:Notify("You don't own this vehicle")
            end

        end

    end)

    net.Receive("KeySharing_RemoveShare", function(len, ply)
        
        local operationType = net.ReadUInt(2)

        local char = ply:GetCharacter()

        if (operationType == 1) then

            local keyID = net.ReadUInt(8)

            if ( PLUGIN.KeysShared.Properties[keyID]) then

                if ( PLUGIN.KeysShared.Properties[keyID].Owner == char:GetID()) then

                    if (PLUGIN.KeysShared.Properties[keyID].SharePly) and (!table.IsEmpty(PLUGIN.KeysShared.Properties[keyID].SharePly)) then

                        for k, v in pairs(PLUGIN.KeysShared.Properties[keyID].SharePly) do

                            local targetChar = ix.char.loaded[k]
                            if (targetChar == char) then continue end
                            if (!targetChar) or (!targetChar:GetPlayer()) then continue end
                            local targetInv = targetChar:GetInventory()

                            local houseKey = targetInv:HasItem("housekey",{
                                ["PropertyID"] = tostring(keyID),
                                ["IsSharedKey"] = true,
                            })

                            if (houseKey) then
                                houseKey:Remove()
                                targetChar:GetPlayer():Notify("Someone has taken away your access to a property named: "..houseKey:GetData("HouseName"))
                            else
                                targetChar:GetPlayer():Notify("Someone has taken away your access to one of the shared properties")
                            end

                        end

                    end

                    -- PLUGIN.SharedForFactions = PLUGIN.SharedForFactions or {}
                    -- PLUGIN.SharedForFactions[char:GetFaction()] = PLUGIN.SharedForFactions[char:GetFaction()] or {}
                    -- PLUGIN.SharedForFactions[char:GetFaction()].Properties = PLUGIN.SharedForFactions[char:GetFaction()].Properties or {}

                    -- if (PLUGIN.SharedForFactions[char:GetFaction()].Properties[keyID]) then
                    if (PLUGIN.KeysShared.Properties[keyID].Faction) then

                        for client, character in ix.util.GetCharacters() do
                            if (client == ply) then continue end
                            if (character:GetFaction() == PLUGIN.KeysShared.Properties[keyID].Faction) then
                                local targetInv = character:GetInventory()

                                local houseKey = targetInv:HasItem("housekey",{
                                    ["PropertyID"] = tostring(keyID),
                                    ["IsSharedKey"] = true,
                                })

                                if (houseKey) then
                                    houseKey:Remove()
                                    character:GetPlayer():Notify("Someone has taken away your access to a property named: "..houseKey:GetData("HouseName"))
                                else
                                    character:GetPlayer():Notify("Someone has taken away your access to one of the shared properties")
                                end
                            end
                        end

                        -- PLUGIN.SharedForFactions[char:GetFaction()].Properties[keyID] = nil
                    end

                    PLUGIN.KeysShared.Properties[keyID] = nil

                    ply:Notify("You have successfully removed the sharing")

                    PLUGIN:SaveSharedKeysToDb()
                    PLUGIN:SyncSharing(ply)

                else
                    ply:Notify("You are not the owner")
                end

            end

        elseif (operationType == 2) then

            local carClass = net.ReadString()

            PLUGIN.KeysShared.Vehicles[char:GetID()] = PLUGIN.KeysShared.Vehicles[char:GetID()] or {}

            if (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass]) then

                PLUGIN.KeysShared.Vehicles[char:GetID()][carClass] = nil

                ply:Notify("You have successfully removed the sharing")

                PLUGIN.SharedVehicles = PLUGIN.SharedVehicles or {}

                if (PLUGIN.SharedVehicles[char:GetID()]) and (PLUGIN.SharedVehicles[char:GetID()][carClass]) and (IsValid(PLUGIN.SharedVehicles[char:GetID()][carClass])) then     
                    PLUGIN.SharedVehicles[char:GetID()][carClass].ExtraSharedAccess = nil
                    PLUGIN.SharedVehicles[char:GetID()][carClass] = nil
                end


                PLUGIN:SaveSharedKeysToDb()
                PLUGIN:SyncSharing(ply)

            else
                ply:Notify("You are not the owner")
            end

        end

    end)


    net.Receive("KeySharing_PlyManage", function(len, ply)
        
        local operationType = net.ReadUInt(2)

        local char = ply:GetCharacter()

        PLUGIN.SharedForFactions = PLUGIN.SharedForFactions or {}
        PLUGIN.SharedForFactions[char:GetFaction()] = PLUGIN.SharedForFactions[char:GetFaction()] or {}

        if (operationType == 1) then

            local keyID = net.ReadUInt(8)

            if (PLUGIN.KeysShared.Properties[keyID]) then

                if ( PLUGIN.KeysShared.Properties[keyID].Owner == char:GetID()) then

                    -- local targetCharID = net.ReadUInt(10)
                    local targetClient = net.ReadEntity()
                    if (!targetClient:IsPlayer()) then return end
                    local targetChar = targetClient:GetCharacter()
                    local targetCharID = targetChar:GetID()

                    local isDelete = net.ReadBool()

                    PLUGIN.SharedForFactions[char:GetFaction()].Properties = PLUGIN.SharedForFactions[char:GetFaction()].Properties or {}

                    if (isDelete) then

                        if (targetChar == char) then

                            if (!PLUGIN.AllowedSharedFactions or !PLUGIN.AllowedSharedFactions[char:GetFaction()]) then
                                ply:Notify("You can't modify it to faction members")
                                return
                            end

                            -- if (PLUGIN.AllowedSharedFactions and PLUGIN.AllowedSharedFactions[char:GetFaction()]) then

                            if (PLUGIN.KeysShared.Properties[keyID].SharePly[char:GetID()]) and (PLUGIN.KeysShared.Properties[keyID].Faction) then

                                for client, character in ix.util.GetCharacters() do
                                    if (client == ply) then continue end
                                    if (character:GetFaction() == PLUGIN.KeysShared.Properties[keyID].Faction) then
                                        local targetInv = character:GetInventory()

                                        local houseKey = targetInv:HasItem("housekey",{
                                            ["PropertyID"] = tostring(keyID),
                                            ["IsSharedKey"] = true,
                                        })

                                        if (houseKey) then
                                            houseKey:Remove()
                                            character:GetPlayer():Notify("Someone has taken away your access to a property named: "..houseKey:GetData("HouseName"))
                                        else
                                            character:GetPlayer():Notify("Someone has taken away your access to one of the shared properties")
                                        end
                                    end
                                end

                                PLUGIN.KeysShared.Properties[keyID].Faction = nil
                                PLUGIN.KeysShared.Properties[keyID].SharePly[targetCharID] = nil
                                ply:Notify("You remove the access for all faction members.")
                                PLUGIN:SaveSharedKeysToDb()
                                PLUGIN:SyncSharing(ply)

                            else
                                ply:Notify("It was not made available to faction members")
                            end

                            -- else
                            --     ply:Notify("You are not in the faction for which the sharing was created")
                            -- end

                        else

                            if (PLUGIN.KeysShared.Properties[keyID].SharePly[targetCharID]) then

                                -- local targetChar = ix.char.loaded[targetCharID]

                                if (targetChar) and (targetChar:GetPlayer()) then
                                    local targetInv = targetChar:GetInventory()

                                    local houseKey = targetInv:HasItem("housekey",{
                                        ["PropertyID"] = tostring(keyID),
                                        ["IsSharedKey"] = true,
                                    })

                                    if (houseKey) then
                                        houseKey:Remove()
                                        targetChar:GetPlayer():Notify("Someone has taken away your access to a property named: "..houseKey:GetData("HouseName"))
                                    else
                                        targetChar:GetPlayer():Notify("Someone has taken away your access to one of the shared properties")
                                    end

                                end

                                PLUGIN.KeysShared.Properties[keyID].SharePly[targetCharID] = nil
                                ply:Notify("You remove the access for this person.")

                                PLUGIN:SaveSharedKeysToDb()
                                PLUGIN:SyncSharing(ply)

                            else
                                ply:Notify("It was not made available to this person")
                            end
                        end
                    else


                        if (targetChar == char) then

                            if (!PLUGIN.AllowedSharedFactions or !PLUGIN.AllowedSharedFactions[char:GetFaction()]) then
                                ply:Notify("You can't modify it to faction members")
                                return
                            end

                            if (PLUGIN.KeysShared.Properties[keyID].SharePly[char:GetID()]) and (PLUGIN.KeysShared.Properties[keyID].Faction) then
                                ply:Notify("This has already been made available to faction members")
                            else

                                local numberID = keyID

                                local targetChar = targetClient:GetCharacter()

                                PLUGIN.KeysShared.Properties[numberID] = PLUGIN.KeysShared.Properties[numberID] or {}
                                PLUGIN.KeysShared.Properties[numberID].SharePly = PLUGIN.KeysShared.Properties[numberID].SharePly or {}
                                PLUGIN.KeysShared.Properties[numberID].SharePly[targetChar:GetID()] = targetChar:GetName()
                                PLUGIN.KeysShared.Properties[numberID].Owner = char:GetID()

                                PLUGIN.KeysShared.Properties[numberID].Faction = char:GetFaction()

                                for client, character in ix.util.GetCharacters() do
                                    if (client == ply) then continue end
                                    if (character:GetFaction() == PLUGIN.KeysShared.Properties[numberID].Faction) then
                                        local targetInv = character:GetInventory()
                    

                                        local bSuccess, error = targetInv:Add("housekey", 1, {
                                            ["PropertyID"] = keyItem:GetData("PropertyID"),
                                            ["HouseName"] = keyItem:GetData("HouseName"),
                                            ["IsTemp"] = true,
                                            ["IsSharedKey"] = true,
                                            ["NoDrop"] = true
                                        })

                                        if (bSuccess) then
                                            client:Notify("Someone has made their property ["..keyItem:GetData("HouseName").."] available to you")
                                        else
                                            client:Notify("Someone tried to give you a faction key")
                                            client:Notify(error)
                                        end
                                    end
                                end

                                ply:Notify("You have successfully made the property available to faction members")
                                PLUGIN:SaveSharedKeysToDb()
                                PLUGIN:SyncSharing(ply)

                            end


                        else

                            if (PLUGIN.KeysShared.Properties[keyID].SharePly[targetCharID]) then
                                ply:Notify("This has already been made available to this person")
                            else

                                local inv = char:GetInventory()

                                local keyItem = inv:HasItem("housekey",{
                                                ["PropertyID"] = tostring(keyID)
                                            })--:GetItemByID(keyID)

                                if (keyItem) then

                                    if (tonumber(keyItem:GetData("PropertyID")) > 0) and (!keyItem:GetData("IsSharedKey", false)) then

                                        -- local targetChar = ix.char.loaded[targetCharID]
                                        -- print(targetCharID)
                                        -- if (!targetChar) or (!targetChar:GetPlayer()) then
                                        --     ply:Notify("This character doesn't exist or the player is offline")
                                        --     return
                                        -- end

                                        local targetInv = targetChar:GetInventory()

                                        local bSuccess, error = targetInv:Add("housekey", 1, {
                                            ["PropertyID"] = keyItem:GetData("PropertyID"),
                                            ["HouseName"] = keyItem:GetData("HouseName"),
                                            ["IsTemp"] = true,
                                            ["IsSharedKey"] = true,
                                            ["NoDrop"] = true
                                        })

                                        if (bSuccess) then

                                            local numberID = tonumber(keyItem:GetData("PropertyID"))

                                            PLUGIN.KeysShared.Properties[numberID] = PLUGIN.KeysShared.Properties[numberID] or {}
                                            PLUGIN.KeysShared.Properties[numberID].SharePly = PLUGIN.KeysShared.Properties[numberID].SharePly or {}
                                            PLUGIN.KeysShared.Properties[numberID].SharePly[targetChar:GetID()] = targetChar:GetName()

                                            ply:Notify("You have successfully made the property available to this person")
                                            targetClient:Notify("Someone has made their property ["..keyItem:GetData("HouseName").."] available to you")
                                            PLUGIN:SaveSharedKeysToDb()
                                            PLUGIN:SyncSharing(ply)
                                        else
                                            ply:Notify(error)
                                            targetClient:Notify(error)
                                        end

                                    else
                                        ply:Notify("You do not have a key for this property or do not own it")
                                    end

                                else
                                    ply:Notify("You don't have a key for this property")
                                end

                            end

                        end

                    end

                else
                    ply:Notify("You are not the owner")
                end

            end

        elseif (operationType == 2) then

            local carClass = net.ReadString()

            PLUGIN.KeysShared.Vehicles[char:GetID()] = PLUGIN.KeysShared.Vehicles[char:GetID()] or {}

            if (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass]) then

                local targetClient = net.ReadEntity()
                if (!targetClient:IsPlayer()) then return end
                local targetChar = targetClient:GetCharacter()
                local targetCharID = targetChar:GetID()

                local isDelete = net.ReadBool()

                if (isDelete) then

                    if (targetChar == char) then

                        if (!PLUGIN.AllowedSharedFactions or !PLUGIN.AllowedSharedFactions[char:GetFaction()]) then
                            ply:Notify("You can't modify it to faction members")
                            return
                        end

                        if (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[char:GetID()]) then

                            PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].Faction = nil
                            PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[char:GetID()] = nil
                            ply:Notify("You remove the access for all faction members.")
                            PLUGIN:SaveSharedKeysToDb()
                            PLUGIN:SyncSharing(ply)

                        else
                            ply:Notify("It was not made available to faction members")
                        end

                    else

                        if (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[targetCharID]) then

                            if (targetChar) and (targetChar:GetPlayer()) then

                                local carTable = list.Get( "Vehicles" )[ carClass ]

                                if (carTable) then

                                    targetChar:GetPlayer():Notify("Someone has taken away your access to a vehicle named: "..carTable.Name)
                                else
                                    targetChar:GetPlayer():Notify("Someone has taken away your access to one of the shared vehicles")
                                end

                            end

                            PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[targetCharID] = nil
                            ply:Notify("You remove the access for this person.")
                            PLUGIN:SaveSharedKeysToDb()
                            PLUGIN:SyncSharing(ply)
                        else
                            ply:Notify("It was not made available to this person")
                        end
                    end

                else

                    if (targetChar == char) then

                        if (!PLUGIN.AllowedSharedFactions or !PLUGIN.AllowedSharedFactions[char:GetFaction()]) then
                            ply:Notify("You can't modify it to faction members")
                            return
                        end

                        if (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[char:GetID()]) then
                            ply:Notify("This has already been made available to faction members")
                        else

                            PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].Faction = char:GetFaction()
                            PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[targetChar:GetID()] = targetChar:GetName()
                            ply:Notify("You have successfully made the vehicle available to faction members")
                            -- targetClient:Notify("Someone has made their vehicle ["..list.Get( "Vehicles" )[ carClass ].Name.."] available to you")
                            PLUGIN:SaveSharedKeysToDb()
                            PLUGIN:SyncSharing(ply)
                        end
                    else

                        if (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[targetCharID]) then
                            ply:Notify("This has already been made available to this person")
                        else

                            PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[targetChar:GetID()] = targetChar:GetName()

                            ply:Notify("You have successfully made the vehicle available to this person")
                            targetClient:Notify("Someone has made their vehicle ["..list.Get( "Vehicles" )[ carClass ].Name.."] available to you")
                            PLUGIN:SaveSharedKeysToDb()
                            PLUGIN:SyncSharing(ply)

                        end

                    end

                end
                
                PLUGIN.SharedVehicles = PLUGIN.SharedVehicles or {}
                PLUGIN.SharedVehicles[char:GetID()] = PLUGIN.SharedVehicles[char:GetID()] or {}

                if (!PLUGIN.SharedVehicles[char:GetID()][carClass]) then

                    for k, v in ipairs(ents.GetAll()) do
                        if (v:IsVehicle()) then
                            if (v:GetNetVar("owner") == char:GetID()) then
                                PLUGIN.SharedVehicles[char:GetID()][carClass] = v
                                break
                            end
                        end
                    end
                end

                if (PLUGIN.SharedVehicles[char:GetID()][carClass]) and (IsValid(PLUGIN.SharedVehicles[char:GetID()][carClass])) then
                    (PLUGIN.SharedVehicles[char:GetID()][carClass]).ExtraSharedAccess = PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly
                end

                if (targetClient == ply) and (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].Faction) then
                    
                    for client, character in ix.util.GetCharacters() do
                        if (client == ply) then continue end
                        if (character:GetFaction() != PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].Faction) then continue end
                        if (PLUGIN.KeysShared.Vehicles[char:GetID()][carClass].SharePly[character:GetID()]) then continue end

                        -- client:Notify("Someone has made their vehicle ["..list.Get( "Vehicles" )[ carClass ].Name.."] available to you")

                        PLUGIN.SharedVehicles[char:GetID()][carClass].ExtraSharedAccess[character:GetID()] = character:GetName()

                    end
                end

            end

        end

    end)

else

    net.Receive("KeySharing_SyncSharing", function(len, ply)

        local tableNet = false

        local bytes = net.ReadUInt( 16 )
        local compressedJson = net.ReadData( bytes )
        local DecompressJson = util.Decompress( compressedJson )

        tableNet = util.JSONToTable(DecompressJson)

        if (tableNet) then
            PLUGIN.KeysShared = tableNet
            -- PrintTable(PLUGIN.KeysShared)

            if (ix.gui.KeysSharingUI) and (IsValid(ix.gui.KeysSharingUI)) then
                ix.gui.KeysSharingUI:PopulateSharedKeys()
                ix.gui.KeysSharingUI:UpdateProperties()
                ix.gui.KeysSharingUI:PopulateSharedVehs()
                ix.gui.KeysSharingUI:UpdateCars()

                if (ix.gui.KeysSharingUI.ShareID != "") then
                    ix.gui.KeysSharingUI:ManageShared(ix.gui.KeysSharingUI.ShareID, ix.gui.KeysSharingUI.isProperty)
                end

            end

        end
        -- PrintTable(PLUGIN.KeysShared)
    end)


end