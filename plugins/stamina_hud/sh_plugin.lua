local PLUGIN = PLUGIN
PLUGIN.name = "Stamina HUD"
PLUGIN.author = "cometopapa & feralcat"
PLUGIN.desc = "I love you."
local icon_stm = Material("stm.png")

local function CalcStaminaChange(client)
    local character = client:GetCharacter()
    if not character or client:GetMoveType() == MOVETYPE_NOCLIP then return 0 end
    local runSpeed

    if SERVER then
        runSpeed = ix.config.Get("runSpeed") + character:GetAttribute("stm", 0)

        if client:WaterLevel() > 1 then
            runSpeed = runSpeed * 0.775
        end
    end

    local walkSpeed = ix.config.Get("walkSpeed")
    local maxAttributes = ix.config.Get("maxAttributes", 100)
    local offset

    if client:KeyDown(IN_SPEED) and client:GetVelocity():LengthSqr() >= (walkSpeed * walkSpeed) then
        -- characters could have attribute values greater than max if the config was changed
        offset = -ix.config.Get("staminaDrain", 1) + math.min(character:GetAttribute("end", 0), maxAttributes) / 100
    else
        offset = client:Crouching() and ix.config.Get("staminaCrouchRegeneration", 2) or ix.config.Get("staminaRegeneration", 1.75)
    end

    offset = hook.Run("AdjustStaminaOffset", client, offset) or offset

    if CLIENT then
        return offset -- for the client we need to return the estimated stamina change
    else
        local current = client:GetLocalVar("stm", 0)
        local value = math.Clamp(current + offset, 0, 100)

        if current ~= value then
            client:SetLocalVar("stm", value)

            if value == 0 and not client:GetNetVar("brth", false) then
                client:SetRunSpeed(walkSpeed)
                client:SetNetVar("brth", true)
                character:UpdateAttrib("end", 0.1)
                character:UpdateAttrib("stm", 0.01)
                hook.Run("PlayerStaminaLost", client)
            elseif value >= 50 and client:GetNetVar("brth", false) then
                client:SetRunSpeed(runSpeed)
                client:SetNetVar("brth", nil)
                hook.Run("PlayerStaminaGained", client)
            end
        end
    end
end

if CLIENT then
    local function drawBox(x, y, w, h, color)
        -- draw.RoundedBox(0, x, y, w, h, color)
        surface.SetDrawColor(color)
        surface.DrawRect( x, y, w, h)
    end

    local predictedStamina = 100

    function PLUGIN:Think()
        local offset = CalcStaminaChange(LocalPlayer())
        -- the server check it every 0.25 sec, here we check it every [FrameTime()] seconds
        offset = math.Remap(FrameTime(), 0, 0.25, 0, offset)

        if offset ~= 0 then
            predictedStamina = math.Clamp(predictedStamina + offset, 0, 100)
        end
    end

    function PLUGIN:HUDPaint()
        local client = LocalPlayer():GetCharacter()
        local char = LocalPlayer():GetCharacter()
        local stam = LocalPlayer():GetLocalVar("stm")
        -- local stam = hook.Run("AdjustStaminaOffset", client, offset)
        local v1, v2, v3, v4, v5 = 1
        v5 = math.max(0, 1 * ((predictedStamina - 80) / 20))

        if v5 == 0 then
            v4 = math.max(0, 1 * ((predictedStamina - 60) / 20))
        else
            v4 = 1
        end

        if v4 == 0 then
            v3 = math.max(0, 1 * ((predictedStamina - 40) / 20))
        else
            v3 = 1
        end

        if v3 == 0 then
            v2 = math.max(0, 1 * ((predictedStamina - 20) / 20))
        else
            v2 = 1
        end

        if v2 == 0 then
            v1 = math.max(0, 1 * (predictedStamina / 20))
        else
            v1 = 1
        end

        if client and predictedStamina ~= 100 then
            local w, h = 300, 10
            local x, y = 0, 0
            x, y = ScrW() / 2 - (w / 2), ScrH() - 20
            surface.SetDrawColor(255, 255, 255, 255) -- Set the drawing color
            surface.SetMaterial(icon_stm)
            surface.DrawTexturedRect(x + w / 5 * 5 + 8, y - 5, 16, 16)
            drawBox(x + 2, y + 2, math.Clamp((w / 5) * v1, 0, w) - 4, h - 4, Color(255, 255, 255, 200))
            drawBox(x, y, w / 5, h, Color(0, 0, 0, 70))
            drawBox(x + w / 5 + 2, y + 2, math.Clamp((w / 5) * v2, 0, w) - 4, h - 4, Color(255, 255, 255, 200))
            drawBox(x + w / 5, y, w / 5, h, Color(0, 0, 0, 70))
            drawBox(x + w / 5 * 2 + 2, y + 2, math.Clamp((w / 5) * v3, 0, w) - 4, h - 4, Color(255, 255, 255, 200))
            drawBox(x + w / 5 * 2, y, w / 5, h, Color(0, 0, 0, 70))
            drawBox(x + w / 5 * 3 + 2, y + 2, math.Clamp((w / 5) * v4, 0, w) - 4, h - 4, Color(255, 255, 255, 200))
            drawBox(x + w / 5 * 3, y, w / 5, h, Color(0, 0, 0, 70))
            drawBox(x + w / 5 * 4 + 2, y + 2, math.Clamp((w / 5) * v5, 0, w) - 4, h - 4, Color(255, 255, 255, 200))
            drawBox(x + w / 5 * 4, y, w / 5, h, Color(0, 0, 0, 70))
        end
    end

    -- function PLUGIN:OnLocalVarSet(key, var)
    --     if key ~= "stm" then return end

    --     if math.abs(predictedStamina - var) > 5 then
    --         predictedStamina = var
    --     end
    -- end
end