local PLUGIN = PLUGIN


PLUGIN.Properties = {}

local fCallback = function()end
function PLUGIN:RequestData(fCallback_)
    print(fCallback_)
    net.Start("ixKeysDataRequest")
    fCallback = fCallback_ or function() end
    net.SendToServer()
end

function PLUGIN:ReadProperty()
    local tData = {
        name = net.ReadString(),
        lock = net.ReadBool(),
        open = net.ReadBool(),
        is_buy = net.ReadBool(),
        is_rent = net.ReadBool(),
        rent_status = net.ReadBool(),
        category = net.ReadString(),
        preview = net.ReadString(),
        owner = net.ReadString(),
        owner_name = net.ReadString(),
        tenant = net.ReadString(),
        tenant_name = net.ReadString(),
        renttime = net.ReadInt(10),
        rentcollect = net.ReadInt(15),
        price = net.ReadString(),
        price_rent = net.ReadString(),
        entities = {}
    }

    local iEntities = net.ReadUInt(8)
    for i = 1, iEntities do
        tData.entities[i] = net.ReadEntity()
    end
    return tData
end

function PLUGIN:ReadProperties()
    local tProperties = {}
    local propertyCount = net.ReadUInt(12)
    for i = 1, propertyCount do
        tProperties[i] = self:ReadProperty()
    end
    self.Properties = tProperties
    return tProperties
end

function PLUGIN:DeleteProperty(sName)
    if not LocalPlayer():IsSuperAdmin() or not sName then
        return
    end
    net.Start("ixKeysDeleteProperty")
    net.WriteString(sName)
    net.SendToServer()
end

function PLUGIN:WriteProperty(Data, entities)
    if not Data then return end
    local jsonData = util.TableToJSON(Data)
    net.WriteString(jsonData)
    
    local len = #entities
    net.WriteUInt(len, 8)
    for i = 1, len do
        net.WriteEntity(entities[i])
    end
end

function PLUGIN:RegisterProperty(Data)
    if not Data then return end
    local tool = LocalPlayer():GetTool()
    if not tool or not istable(tool) then return end
    if tool.Name ~= "#tool.keys.name" then
        --print("Wrong tool!")
        return 
    end
    --print("Ents:")
    --PrintTable(tool.SelectedDoors or {})
    net.Start("ixKeysCreateProperty")
    self:WriteProperty(Data, tool.SelectedDoors)
    net.SendToServer()
end

net.Receive("ixKeysDataRequest", function()
    local Data = PLUGIN:ReadProperties()
    fCallback(Data)
end)
