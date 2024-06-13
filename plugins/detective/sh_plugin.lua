PLUGIN.name = "Detective"
PLUGIN.author = "gefake"

local playerMeta = FindMetaTable("Player")
function playerMeta:RunAimTrace(distance)
    local data = {}
        data.start = self:GetShootPos()
        data.endpos = data.start + self:GetAimVector() * distance
        data.filter = self
    local trace = util.TraceLine(data)

    return trace
end

local ENTITIES = {
    ["ix_item"] = true
}

local function CanFingerprint(ent)
    return ENTITIES[ent:GetClass()] or ent:IsDoor()
end

hook.Add("ShouldFingerprint", "ix.ShouldFingerprintMain", function(client)
    local gloves = client:GetCharacter():GetInventory():HasItem("gloves")
    if not gloves then return false end
    
    return true
end)

local function AddFingerprint(client, ent)
    if (ent._fingerPrintUse or 0) >= CurTime() then return end
    
    local fingerprints = ent:GetNetVar("Fingerprints", {})
    fingerprints[client:GetCharacter():GetID()] = os.time()

    ent:SetNetVar("fingerprints", fingerprints)

    PrintTable(fingerprints)

    ent._fingerPrintUse = CurTime() + 1
end

function PLUGIN:PlayerUse(client, ent)
    if not CanFingerprint(ent) then return end
    if not hook.Run("ShouldFingerprint", client, ent) then return end
    AddFingerprint(client, ent)
end

if SERVER then
    local LastThink = 0
    hook.Add("Think", "TakeFingerprints", function()
        if LastThink >= CurTime() then return end

        for k, v in pairs(player.GetAll()) do
            if IsValid(v) and v:Alive() and v:GetLocalVar("bIsHoldingObject", false) then
                local hands = v:GetActiveWeapon()
                if not hands or not IsValid(hands) or hands:GetClass() ~= "ix_hands" then continue end
                if not hands.heldEntity or not IsValid(hands.heldEntity) then continue end
                AddFingerprint(v, hands.heldEntity)
            end
        end

        LastThink = CurTime() + 0.65
    end)
end

if not CLIENT then return end

hook.Add("PreDrawPlayerHands", "DetectiveHands", function(hands, vm, client, weapon)
    if client ~= LocalPlayer() then return end

    if not client.oldHandsModel then
        client.oldHandsModel = hands:GetModel()
        return 
    end

    if not client:Alive() then
        return
    end

    if not client:GetCharacter() then
        return 
    end

    local gloves = client:GetCharacter():GetInventory():HasItem("gloves")
    if not gloves then
        hands:SetModel(client.oldHandsModel)
        return
    end

    if not gloves:GetData("equip", nil) then
        hands:SetModel(client.oldHandsModel)
        return
    end

    hands:SetModel("models/weapons/mr_brighstside_ins2_chands/c_insurgent_light_arms.mdl")
end)

hook.Add("PostDrawOpaqueRenderables", "OverrideEntityDraw", function()
    for _, ent in pairs(ents.GetAll()) do
        if not CanFingerprint(ent) then continue end
        if not IsValid(ent) then continue end
        local entPos = ent:GetPos()
        local myPos = LocalPlayer():GetPos()
        if myPos:Distance(entPos) > 200 then continue end
        if not ent:GetNetVar("analyzed", nil) then continue end

        local mins, maxs = ent:GetModelBounds()
		local normal = ent:GetForward():Angle()
        local ang = ent:GetAngles()
        local center = (mins + maxs) / 2

        local pos = ent:GetPos() + Vector(0, 0, 10)

        normal:RotateAroundAxis(normal:Up(), 90)

        cam.Start3D2D(pos, normal, 1 )
            surface.SetDrawColor( 211, 211, 211, 33)
            surface.SetMaterial(Material("setorian/hand.png"))
            surface.DrawTexturedRect(-4, -4, 7, 7)
        cam.End3D2D()
    end
end)