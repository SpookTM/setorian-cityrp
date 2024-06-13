PLUGIN.name = "Mask"
PLUGIN.author = "Stalker"
PLUGIN.description = "Adds masks to hide your identity."

--[[
 Doesn't matter whats the item just make to have these in some kind of outfit file
 
function ITEM:OnEquipped()
    self.player:SetNetVar("isMasked",true)
end
 
function ITEM:OnUnequipped()
    self.player:SetNetVar("isMasked",false)
end

--]]

function PLUGIN:PopulateCharacterInfo(client, character, container)
    if client:GetNetVar("isMasked") then
        timer.Simple(0.1,function()
       local name = container:GetRow("name")
                name:SetText("Masked Individual")
                name:SizeToContents()
                local description = container:GetRow("description")
                description:SetText("Masked Individual")
                description:SizeToContents()
        end)
    end
end
