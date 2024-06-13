local PLUGIN = PLUGIN

local bInit = false
function PLUGIN:DatabaseConnected()
    if bInit then return end
    local query = mysql:Create("ix_properties")
        query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
        query:Create("name", "VARCHAR(50) NOT NULL")
        query:Create("map", "VARCHAR(50) NOT NULL")
        query:Create("entities", "VARCHAR(255) NOT NULL")
        query:Create("lock_spawn", "INT(2) UNSIGNED NOT NULL DEFAULT '1'")
        query:Create("start_open", "INT(2) UNSIGNED NOT NULL DEFAULT '0'")
        query:Create("is_buyable", "INT(2) UNSIGNED NOT NULL DEFAULT '1'")
        query:Create("is_rentable", "INT(2) UNSIGNED NOT NULL DEFAULT '1'")
        query:Create("rent_status", "INT(2) UNSIGNED NOT NULL DEFAULT '0'")
        query:Create("rent_collect", "INT(15) UNSIGNED NOT NULL DEFAULT '0'")
        query:Create("category", "VARCHAR(50) NOT NULL DEFAULT ''")
        query:Create("preview", "VARCHAR(50) NOT NULL DEFAULT ''")
        query:Create("owner", "INT(10) UNSIGNED NOT NULL DEFAULT '0'")
        query:Create("owner_name", "VARCHAR(50) UNSIGNED NOT NULL DEFAULT ''")
        query:Create("tenant", "INT(10) UNSIGNED NOT NULL DEFAULT '0'")
        query:Create("tenant_name", "VARCHAR(50) UNSIGNED NOT NULL DEFAULT ''")
        query:Create("renttime", "INT(255) UNSIGNED NOT NULL DEFAULT '0'")
        query:Create("price", "INT(15) UNSIGNED NOT NULL DEFAULT '0'")
        query:Create("price_rent", "INT(15) UNSIGNED NOT NULL DEFAULT '0'")
        query:PrimaryKey("id")
    query:Execute()
    bInit = true
end

PLUGIN.CachedDoors = {}
function PLUGIN:GetAllDoorData(fCallback)
    local select = mysql:Select("ix_properties")
        select:Select("id")
        select:Select("name")
        select:Select("entities")
        select:Select("lock_spawn")
        select:Select("start_open")
        select:Select("is_buyable")
        select:Select("is_rentable")
        select:Select("rent_status")
        select:Select("rent_collect")
        select:Select("category")
        select:Select("preview")
        select:Select("owner")
        select:Select("owner_name")
        select:Select("tenant")
        select:Select("tenant_name")
        select:Select("renttime")
        select:Select("price")
        select:Select("price_rent")
        select:Where("map", game.GetMap())
        select:Callback(function(results)
            PLUGIN.CachedDoors = results
            fCallback(results or {})
        end)
    select:Execute()
end

function PLUGIN:InitializeDoors(bInit)
    self:GetAllDoorData(function(data)
        for k,v in ipairs(data) do
            local bLock = tobool(v.lock_spawn)
            local bOpen = tobool(v.start_open)
            local EntIds = util.JSONToTable(v.entities)
            if not EntIds or istable(EntIds) and #EntIds == 0 then print("L ", EntIds) goto next_ end
            for k, EntId in ipairs(EntIds) do
                local Entity = ents.GetMapCreatedEntity(EntId)
                if not IsValid(Entity) then
                    goto skip
                end 
                if bInit then
                    if bOpen then
                        Entity:Fire("unlock")
                        Entity:Fire("open")
                    end
                    if bLock then
                        Entity:Fire("lock")
                    end
                end
                Entity.KeyRequired = v.id
                ::skip::
            end
            ::next_::
        end
    end)
end

function PLUGIN:InitPostEntity()
    if not bInit then
        self:DatabaseConnected()
    end
    self:InitializeDoors(true)
end

function PLUGIN:WriteProperty(name, lock_spawn, start_open, isbuy, isrent, preview, RentStatus, rentTime, rentCollect, owner, ownerName, tenant,tenantName, price, price_rent, category, entities)
    net.WriteString(name or "Unknown")
    net.WriteBool(tobool(lock_spawn))
    net.WriteBool(tobool(start_open))
    net.WriteBool(tobool(isbuy))
    net.WriteBool(tobool(isrent))
    net.WriteBool(tobool(RentStatus))
    net.WriteString(category or "Unknown")
    net.WriteString(preview or "")
    net.WriteString(owner)
    net.WriteString(ownerName)
    net.WriteString(tenant)
    net.WriteString(tenantName or "Unknown")
    net.WriteInt(rentTime,10)
    net.WriteInt(rentCollect,15)
    net.WriteString(price or "500")
    net.WriteString(price_rent or "10")
    
    local len = #entities
    net.WriteUInt(len, 8)
    for i = 1, len do
        net.WriteEntity(entities[i])
    end
end

util.AddNetworkString("ixKeysDataRequest")
function PLUGIN:WriteProperties(pPlayer)
    self:GetAllDoorData(function(data)
        print("Preparing to write the following data...")
        PrintTable(data or {"no data, wtf?"})
        net.Start("ixKeysDataRequest")
        net.WriteUInt(#data, 12)
        for k,v in ipairs(data) do
            local bLock = tobool(v.lock_spawn)
            local bOpen = tobool(v.start_open)
            local IsBuy = tobool(v.is_buyable)
            local IsRent = tobool(v.is_rentable)
            local Owner = tobool(v.owner)
            local RentStatus = tobool(v.rent_status)
            -- local Category = v.category
            -- local Price = v.price
            -- local Price_rent = v.price_rent
            local EntIds = util.JSONToTable(v.entities)
            if not EntIds or istable(EntIds) and #EntIds == 0 then print("L ", EntIds) goto next_ end
            local tEntities = {}
            for k, v in ipairs(EntIds) do
                local Entity = ents.GetMapCreatedEntity(v)
                if not IsValid(Entity) then
                    goto skip
                end 
                table.insert(tEntities, Entity)
                ::skip::
            end
            self:WriteProperty(v.name or "Invalid Name", bLock, bOpen, IsBuy, IsRent, v.preview, RentStatus, v.renttime, v.rent_collect, v.owner, v.owner_name, v.tenant, v.tenant_name, v.price, v.price_rent, v.category, tEntities)
            ::next_::
        end
        net.Send(pPlayer)
    end)
end

function PLUGIN:RequestProperties(pPlayer)
    -- if not pPlayer:IsSuperAdmin() then
    --     return
    -- end
    self:WriteProperties(pPlayer)
end

function PLUGIN:DeleteProperty(sName, sMap)
    local select = mysql:Select("ix_properties")
        select:Select("id")
        select:Where("name", sName)
        select:Where("map", sMap)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
                local id = data[1].id
                local delete = mysql:Delete("ix_properties")
                    delete:Where("id", id)
                    delete:Where("map", sMap)
                    delete:Where("name", sName)
                delete:Execute()
                print("Deleted property [id]["..sName.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:CreateProperty(data)
    if not data then
        return
    end
    
    sName = tostring(data.name)
    bSpawn = tostring(data.open)
    bLock = tostring(data.lock)
    bBuy = tostring(data.isbuy)
    bRent = tostring(data.isrent)

    bView = tostring(data.preview)

    category = tostring(data.category)

    bPrice = tostring(data.price)
    bPriceRent = tostring(data.price_rent)
    
    bSpawn = bSpawn == nil and 0 or bSpawn == 'true' and 1 or 0
    bLock = bLock == nil and 1 or bLock == 'true' and 1 or 0
    bBuy = bBuy == nil and 1 or bBuy == 'true' and 1 or 0
    bRent = bRent == nil and 1 or bRent == 'true' and 1 or 0

    local tData = {}
    for k,v in ipairs(data.entities) do
        if IsValid(v) then
            table.insert(tData, v:MapCreationID())
        end
    end

    local sData = util.TableToJSON(tData)
    local select = mysql:Select("ix_properties")
        select:Where("name", sName)
        select:Where("map", game.GetMap())
        select:Callback(function(results)
            if not results or #results == 0 then
                local insert = mysql:Insert("ix_properties")
                    insert:Insert("name", sName)
                    insert:Insert("map", game.GetMap())
                    insert:Insert("entities", sData)
                    insert:Insert("lock_spawn", bLock)
                    insert:Insert("start_open", bSpawn)
                    insert:Insert("is_buyable", bBuy)
                    insert:Insert("is_rentable", bRent)
                    insert:Insert("category", category)
                    insert:Insert("preview", bView)
                    insert:Insert("price", bPrice)
                    insert:Insert("price_rent", bPriceRent)
                insert:Execute()
            end
        end)
    select:Execute()
end

function PLUGIN:ReadProperty()

    local JSONToTable = util.JSONToTable(net.ReadString())

    local tData = {
        name = JSONToTable.Title,
        lock = JSONToTable.lock_default,
        open = JSONToTable.start_open,
        isbuy = JSONToTable.buyable_property,
        isrent = JSONToTable.rentable_property,
        category = JSONToTable.category,
        preview = JSONToTable.preview,
        price = JSONToTable.price,
        price_rent = JSONToTable.price_rent,
        entities = {}
    }

    local iEntities = net.ReadUInt(8)
    for i = 1, iEntities do
        tData.entities[i] = net.ReadEntity()
    end
    return tData
end

util.AddNetworkString("ixKeysCreateProperty")
net.Receive("ixKeysCreateProperty", function(_, pPlayer)
    if not pPlayer:IsSuperAdmin() then return end
    local p = PLUGIN:ReadProperty()
    print("Property: ", p)
    PrintTable(p or {"fat L"})
    if p.name == nil or p.lock == nil or p.open == nil or p.isbuy == nil or p.isrent == nil or p.category == nil or p.entities == nil then
        print("missing data :(")
        return
    end

    PLUGIN:CreateProperty(p)

    net.Start("ixKeysCreateProperty")
    net.WriteBool(true)
    net.Send(pPlayer)
end)

function PLUGIN:PlayerDeleteProperty(pPlayer, sName)
    if not pPlayer:IsSuperAdmin() then
        return
    end
    self:DeleteProperty(sName, game.GetMap())
end

net.Receive("ixKeysDataRequest", function(_, pPlayer)
    PLUGIN:RequestProperties(pPlayer)
end)

util.AddNetworkString("ixKeysDeleteProperty")
net.Receive("ixKeysDeleteProperty", function(_, pPlayer)
    if not pPlayer:IsSuperAdmin() then
        print("Banned player for attempting to bypass and exploit keys system")
        pPlayer:Ban(0, true)
        return
    end
    local sName = net.ReadString()
    if not sName then return end
    PLUGIN:PlayerDeleteProperty(pPlayer, sName)
end)

function PLUGIN:PostPlayerLoadout(ply)

    local char = ply:GetCharacter()
    local inv = char:GetInventory()
    local items = inv:GetItems()

    local rentKeys = {}

    for k, v in pairs(items) do

        if (v.uniqueID != "housekey") then continue end 

        if (v:GetData("IsTemp", false)) then
            rentKeys[#rentKeys+1] = v
        end

    end

    PrintTable(rentKeys)
print("not pre")
    PLUGIN:GetAllDoorData(function(data)
        
        for k,v in ipairs(data) do

            for i,j in pairs(rentKeys) do

                if (v.id == j:GetData("PropertyID", 0)) then

                    if (tonumber(v.tenant) != char:GetID()) then
                    
                    ply:Notify("You lose access to "..v.name.." property! The rental time has expired.")
                    j:Remove()

                    end

                end
                    

            end

        end

    end)

    

end