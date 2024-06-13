PLUGIN.name = "Miscellaneous Scripts"
PLUGIN.author = "JohnyReaper"
local PLUGIN = PLUGIN

PLUGIN.RemindIsActive = false
PLUGIN.TimeToRemove = 0
PLUGIN.TimeToRemind = 0

ix.config.Add("DealerDespawn", 10, "After how many minutes will the dealer disappear?", nil, {
    data = {min = 1, max = 60},
    category = "Drug Dealer"
})

ix.config.Add("DealerCooldown", 10, "After how many minutes can you call the same dealer again?", nil, {
    data = {min = 1, max = 120},
    category = "Drug Dealer"
})

-- ALWAYS_RAISED["weapon_burner_phone"] = true

PLUGIN.ManipulateBoneRestrict = {
    ["ValveBiped.Bip01_R_UpperArm"] = Angle( -15, 30, 0 ),
    ["ValveBiped.Bip01_L_UpperArm"] = Angle( 15, 20, 0 ),
    ["ValveBiped.Bip01_R_Forearm"]  = Angle( -30, -30, 40 ),
    ["ValveBiped.Bip01_L_Forearm"]  = Angle( 30, -30, -40 ),
    ["ValveBiped.Bip01_R_Hand"]     = Angle(45,34,-15),
    ["ValveBiped.Bip01_L_Hand"]     = Angle(0,0,119),
    -- ["ValveBiped.Bip01_R_UpperArm"] = Angle(-28,18,-21),
    -- ["ValveBiped.Bip01_L_Hand"] = Angle(0,0,119),
    -- ["ValveBiped.Bip01_L_Forearm"] = Angle(22.5,20,40),
    -- ["ValveBiped.Bip01_L_UpperArm"] = Angle(15, 26, 0),
    -- ["ValveBiped.Bip01_R_Forearm"] = Angle(0,47.5,0),
    -- ["ValveBiped.Bip01_R_Hand"] = Angle(45,34,-15),
    -- ["ValveBiped.Bip01_L_Finger01"] = Angle(0,50,0),
    -- ["ValveBiped.Bip01_R_Finger0"] = Angle(10,2,0),
    -- ["ValveBiped.Bip01_R_Finger1"] = Angle(-10,0,0),
    -- ["ValveBiped.Bip01_R_Finger11"] = Angle(0,-40,0),
    -- ["ValveBiped.Bip01_R_Finger12"] = Angle(0,-30,0)
}

ix.util.Include("sh_meta.lua", "shared")
ix.util.Include("sh_zipties.lua", "shared")
ix.util.Include("sh_dealers.lua", "shared")
ix.util.Include("sh_keysharing.lua")

local function ChangeAutomaticCleanerTime()
    -- PLUGIN:InitCleaner()

    PLUGIN.RemindIsActive = false
    PLUGIN.TimeToRemove = 0
    PLUGIN.TimeToRemind = 0

    if (SERVER) then

        net.Start("Cleaner_HudEnabler")
            net.WriteBool(false)
        net.Broadcast()

    end

end

ix.config.Add("AutomaticClearItems", 60, "Every how many minutes items left on the floor are to be removed", ChangeAutomaticCleanerTime, {
    data = {min = 10, max = 1440},
    category = "Performance"
})

ix.config.Add("ClearReminder", 10, "How long should there be a reminder to remove items", ChangeAutomaticCleanerTime, {
    data = {min = 1, max = 15},
    category = "Performance"
})

if (SERVER) then

    function PLUGIN:PlayerEnteredVehicle(ply, veh, role)

        if (veh:GetClass() != "prop_vehicle_prisoner_pod") and (ply) and (IsValid(ply)) and (veh) and (IsValid(veh)) then

            local inv = veh:GetGloveBox()
            if (inv) and (inv.AddReceiver) and (inv.Sync) then
                inv:AddReceiver(ply)
                inv:Sync(ply)
                -- timer.Simple(1, function()
                --     if (!ply) or (!IsValid(ply)) then return end
                --     if (!ply:Alive()) then return end
                --     if (!veh) or (!IsValid(veh)) then return end
                --     net.Start("OpenGloveBoxUI")
                --     net.Send(ply)
                -- end)
            end
        end

    end

    util.AddNetworkString("Cleaner_HudEnabler")
    util.AddNetworkString("OpenGloveBoxUI")

    function PLUGIN:InitPostEntity()
        self:InitCleaner()
    end

    -- if (CLIENT) then
        local function StartRemindTimer(newTime,RemindTime)

            timer.Create( "AutomaticItemsReminder", newTime - RemindTime, 1, function()
                PLUGIN.RemindIsActive = true

                if (CLIENT) then
                    LocalPlayer():ChatPrint("Any items left on the floor will soon be removed. Collect your items or place them in a container to avoid deletion")
                end

                if ( timer.Exists( "AutomaticReminderActive" ) ) then
                    timer.Remove( "AutomaticReminderActive")
                end

                if (CLIENT) then
                    timer.Create( "AutomaticReminderActive", RemindTime, 1, function()
                        PLUGIN.RemindIsActive = false
                        hook.Remove("HUDPaint", "Setorian_RemoveItemsReminder")
                        StartRemindTimer(newTime,RemindTime)
                    end)

                    hook.Add("HUDPaint", "Setorian_RemoveItemsReminder", function()
                        localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
                        if not IsValid(localplayer) then return end

                        surface.SetDrawColor(20,00,20, 200)
                        surface.DrawRect(ScrW()/2-(290/2),5,290,60)

                        ix.util.DrawText("Z", ScrW()/2 - 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "ixIconsMedium")
                        ix.util.DrawText("Z", ScrW()/2 + 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, "ixIconsMedium")
                        ix.util.DrawText(string.ToMinutesSeconds( (timer.Exists( "AutomaticReminderActive" ) and timer.TimeLeft( "AutomaticReminderActive" )) or 0), ScrW()/2, 45, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, "ixMediumFont")
                        ix.util.DrawText("Items on the floor will be removed soon", ScrW()/2, 21, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, "ixMenuMiniFont")


                    end)
                end

            end)

        end
    -- end

    local function CreateReminder(newTime, RemindTime)

        if ( timer.Exists( "AutomaticItemsReminder" ) ) then
            timer.Remove( "AutomaticItemsReminder")
        end

        timer.Create( "AutomaticItemsReminder", newTime - RemindTime, 1, function()
            PLUGIN.RemindIsActive = true

            if (SERVER) then
                for client, character in ix.util.GetCharacters() do
                    client:ChatPrint("Any items left on the floor will soon be removed. Collect your items or place them in a container to avoid deletion")
                end
            end
        end)
    end

    function PLUGIN:InitCleaner()

        local newTime = ix.config.Get("AutomaticClearItems", 60) * 60
        local RemindTime = ix.config.Get("ClearReminder", 10) * 60


        -- if (SERVER) then
            if ( timer.Exists( "AutomaticItemsCleaner" ) ) then
                timer.Remove( "AutomaticItemsCleaner")
                -- timer.Adjust( "AutomaticItemsCleaner", newTime)
            end
                timer.Create( "AutomaticItemsCleaner", 1, 0, function()

                    self.TimeToRemove = math.min(self.TimeToRemove + 1, newTime)

                    if (self.TimeToRemove == newTime) then

                        for _, v in ipairs(ents.FindByClass("ix_item")) do
                            v:Remove()
                        end
                        for client, character in ix.util.GetCharacters() do
                            client:ChatPrint("All items left on the floor were removed")
                        end


                        net.Start("Cleaner_HudEnabler")
                            net.WriteBool(false)
                        net.Broadcast()

                        self.TimeToRemove = 0

                    elseif (self.TimeToRemove == (newTime-RemindTime)) then

                        for client, character in ix.util.GetCharacters() do
                            client:ChatPrint("Any items left on the floor will soon be removed. Collect your items or place them in a container to avoid deletion")
                        end

                        net.Start("Cleaner_HudEnabler")
                            net.WriteBool(true)
                        net.Broadcast()

                    end
                        
                    -- PLUGIN.RemindIsActive = false
                    -- CreateReminder(newTime, RemindTime)
                end)
                -- CreateReminder(newTime, RemindTime)
            -- end



        -- end

        -- if (CLIENT) then
            -- if ( timer.Exists( "AutomaticItemsReminder" ) ) then
            --     timer.Adjust( "AutomaticItemsReminder", newTime - RemindTime)
            --     if ( timer.Exists( "AutomaticReminderActive" ) ) then
            --         timer.Remove( "AutomaticReminderActive")
            --     end
            -- else
            --     StartRemindTimer(newTime,RemindTime)
            -- end

        -- end

    end

end

if (CLIENT) then

    CHAT_RECOGNIZED = CHAT_RECOGNIZED or {}
    CHAT_RECOGNIZED["ic"] = true
    CHAT_RECOGNIZED["y"] = true
    CHAT_RECOGNIZED["w"] = true
    CHAT_RECOGNIZED["me"] = true

    function PLUGIN:IsRecognizedChatType(chatType)
        if (CHAT_RECOGNIZED[chatType]) then
            return true
        end
    end

    function PLUGIN:CharHasAlias(client,target)
        if (client == target) then return false end

        local char = client:GetCharacter()

        if (char and target:GetCharacter()) then

            local aliasTable = char:GetData("chars_alias", {})

            if (aliasTable[ target:GetCharacter():GetID() ]) and (aliasTable[ target:GetCharacter():GetID() ] != "") and (aliasTable[ target:GetCharacter():GetID() ]:Trim() != "") then
                return aliasTable[ target:GetCharacter():GetID() ]
            end

        end

        return false

    end

    function PLUGIN:GetCharacterName(client, chatType)
        if (client != LocalPlayer()) then
            local character = client:GetCharacter()
            local ourCharacter = LocalPlayer():GetCharacter()

            if (ourCharacter and character and !ourCharacter:DoesRecognize(character) and !hook.Run("IsPlayerRecognized", client)) then
                if (chatType and hook.Run("IsRecognizedChatType", chatType)) then
                    if (self:CharHasAlias(LocalPlayer(),client)) then
                        return self:CharHasAlias(LocalPlayer(),client)
                    end
                elseif (!chatType) then
                    if (self:CharHasAlias(LocalPlayer(),client)) then
                        return self:CharHasAlias(LocalPlayer(),client)
                    end
                end
            end

        end
    end

    function PLUGIN:GetCharacterDescription(client)
        if (client:GetCharacter() and client != LocalPlayer() and LocalPlayer():GetCharacter()) then
            if (!LocalPlayer():GetCharacter():DoesRecognize(client:GetCharacter()) and !hook.Run("IsPlayerRecognized", client) and (!self:CharHasAlias(LocalPlayer(),client))) then
                return L"noRecog"
            end
        end
    end

    function PLUGIN:ShouldShowGloveBoxUI()
        return LocalPlayer():InVehicle() and (LocalPlayer():GetVehicle():GetClass() != "prop_vehicle_prisoner_pod") and LocalPlayer():GetVehicle():GetGloveBox()
    end

    function PLUGIN:ShowGloveBoxUI()

        if (LocalPlayer():GetVehicle():GetClass() == "prop_vehicle_prisoner_pod") then return end
        local inventory = LocalPlayer():GetVehicle():GetGloveBox()

        if (inventory) then

            local index = inventory:GetID()
            if (index == 0) then return end
            local panel = ix.gui["inv"..index]
            
            local parent = IsValid(ix.gui.menuInventoryContainer) and ix.gui.menuInventoryContainer
        
            if (parent) then
                
                if (IsValid(panel)) then return true end
                --     panel:Remove()
                -- end

                if (inventory and inventory.slots) then
                    panel = vgui.Create("ixInventory", IsValid(parent) and parent or nil)
                    panel:SetInventory(inventory)
                    panel:ShowCloseButton(false)
                    panel:SetTitle("Glovebox")

                    if (parent == ix.gui.menuInventoryContainer) then
                        panel:MoveToFront()
                    end
                    
                    -- parent:Layout()
                    ix.gui["inv"..index] = panel
                else
                    ErrorNoHalt("[Helix] Attempt to view an uninitialized inventory '"..index.."'\n")
                end

            end

        end

    end

    function PLUGIN:PostDrawInventory()

        if (hook.Run("ShouldShowGloveBoxUI") != false) then
            self:ShowGloveBoxUI()
        end

    end

    -- net.Receive("OpenGloveBoxUI", function()

    --     if (hook.Run("ShouldShowGloveBoxUI") != false) then
    --         PLUGIN:ShowGloveBoxUI()
    --     end

    -- end)


    PLUGIN.RemindTimer = 0

    local function DeleteReminder()

        localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
        if not IsValid(localplayer) then return end

        if (!PLUGIN.RemindIsActive) then return end
        if (CurTime() > PLUGIN.RemindTimer) then return end

        -- local newTime = ix.config.Get("AutomaticClearItems", 60)
        

        local TimeToRemove = math.Round(PLUGIN.RemindTimer - CurTime())

        surface.SetDrawColor(20,00,20, 200)
        surface.DrawRect(ScrW()/2-(290/2),5,290,60)

        ix.util.DrawText("Z", ScrW()/2 - 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, "ixIconsMedium")
        ix.util.DrawText("Z", ScrW()/2 + 135, 44, Color(250,math.abs(math.cos(RealTime()*2) * 120),math.abs(math.cos(RealTime()*2) * 120)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, "ixIconsMedium")
        ix.util.DrawText(string.ToMinutesSeconds(TimeToRemove), ScrW()/2, 45, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, "ixMediumFont")
        ix.util.DrawText("Items on the floor will be removed soon", ScrW()/2, 21, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, "ixMenuMiniFont")




    end

    hook.Remove("HUDPaint", "Setorian_RemoveItemsReminder")

    net.Receive("Cleaner_HudEnabler", function()

        local isEnable = net.ReadBool()

        if (isEnable) then
            local RemindTime = ix.config.Get("ClearReminder", 10) * 60

            PLUGIN.RemindIsActive = true
            PLUGIN.RemindTimer = CurTime()+RemindTime

            hook.Add("HUDPaint", "Setorian_RemoveItemsReminder", DeleteReminder)

        else
            PLUGIN.RemindIsActive = false
            PLUGIN.RemindTimer = 0
            hook.Remove("HUDPaint", "Setorian_RemoveItemsReminder")
        end

    end)

end


ix.command.Add("ItemCleanUp", {
    description = "Remove all items on the ground.",
    adminOnly = true,
    OnRun = function(self, client)
        local count = 0
        for _, v in ipairs(ents.FindByClass("ix_item")) do
            v:Remove()
            count = count + 1
        end

        PLUGIN.RemindIsActive = false
        PLUGIN.TimeToRemove = 0
        PLUGIN.TimeToRemind = 0

        net.Start("Cleaner_HudEnabler")
            net.WriteBool(false)
        net.Broadcast()

        client:Notify("You have removed "..count.." item(s).")
    end
})

ix.command.Add("setAlias", {
    description = "Set the alias for the character you are looking at.",
    arguments = ix.type.text,
    OnRun = function(self, client, text)

        if (!text) then return end
        if (text == "") or (text:Trim() == "") then return end

        local data = {}
            data.start = client:GetShootPos()
            data.endpos = data.start + client:GetAimVector() * 96
            data.filter = client
        local target = util.TraceLine(data).Entity

        if (target:IsPlayer() and target:GetCharacter()) then

            local char = client:GetCharacter()

            local aliasTable = char:GetData("chars_alias", {})

            aliasTable[ target:GetCharacter():GetID() ] = text

            char:SetData("chars_alias", aliasTable)
            client:Notify("The alias for this person has been set up")
        end

    end

})

ix.command.Add("removeAlias", {
    description = "Remove the alias for the character you are looking at.",
    OnRun = function(self, client)

        local data = {}
            data.start = client:GetShootPos()
            data.endpos = data.start + client:GetAimVector() * 96
            data.filter = client
        local target = util.TraceLine(data).Entity

        if (target:IsPlayer() and target:GetCharacter()) then

            local char = client:GetCharacter()

            local aliasTable = char:GetData("chars_alias", {})

            if (aliasTable[ target:GetCharacter():GetID() ]) then
                aliasTable[ target:GetCharacter():GetID() ] = nil

                char:SetData("chars_alias", aliasTable)
                client:Notify("You have removed the alias for this person")
            else
                client:Notify("You have not set up the alias for this person")
            end

        end

    end

})