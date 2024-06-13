-- Create a function to draw the watermark
local function DrawWatermark()
    local serverName = "Setorian" -- Replace with your server name
    local serverVersion = "1.0" -- Replace with your server version

    -- Set the font, size, and color for the watermark
    surface.SetFont("DermaDefault") -- You can change the font if needed
    surface.SetTextColor(255, 255, 255, 100) -- White color with lower opacity

    -- Calculate the size of the text
    local textWidth, textHeight = surface.GetTextSize("(" .. serverName .. " " .. serverVersion .. ")")

    -- Calculate the position for the watermark (bottom right corner)
    local posX = ScrW() - textWidth - 10 -- Adjust the position as needed
    local posY = ScrH() - textHeight - 10 -- Adjust the position as needed

    -- Draw the watermark
    surface.SetTextPos(posX, posY)
    surface.DrawText("(" .. serverName .. " " .. serverVersion .. ")")
end

-- Hook into the HUDPaint function to draw the watermark
hook.Add("HUDPaint", "DrawWatermark", DrawWatermark)
