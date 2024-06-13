
local PLUGIN = PLUGIN

PLUGIN.Dealers = {
    {
        DealerName = "Rex",
        DealerType = "psychedelics_blotter_1sheet",
        DealerPrice = 266
    },
    {
        DealerName = "Hector",
        DealerModel = "models/Humans/Group03/male_02.mdl",
        DealerType = {"psychedelics_blotter_25sheet", "psychedelics_blotter_5sheet"}, -- If there is a table here then one item will be drawn when calling the dealer
        DealerPrice = {530, 2650} -- If there are two numbers then one from this range will be drawn
    },
    {
        DealerName = "Brian",
        DealerType = "psychedelics_mushroom",
        DealerModel = "models/Humans/Group03/male_04.mdl",
        DealerPrice = 1500 -- If there are two numbers then one from this range will be drawn
    },
    {
        DealerName = "Leon",
        DealerType = "cocaine_brick",
        DealerPrice = 6800
    },
    {
        DealerName = "John",
        DealerType = "weed_brick",
        DealerPrice = 800
    },
}

PLUGIN.DealersSpawns = {
    {
        Pos = Vector(811.701111, -1020.156494, -12735.968750),
    },
    {
        Pos = Vector( -1378.35, -139.6, -12793.5 ),
    },
    {
        Pos = Vector( 378.6, -151.21, -12287.97 ), 
        Ang = Angle( 89, 45.46, 0 )
    },
}

if (SERVER) then
    util.AddNetworkString("DealerSays")
    util.AddNetworkString("NetDealerCalled")

    PLUGIN.SpawnFindRetry = 0
    PLUGIN.SpawnedDealers = PLUGIN.SpawnedDealers or {}

    function PLUGIN:DealerCalled(client,dealerID)

        local dealerData = self.Dealers[dealerID]

        if (client.DealerCalled) then
            client:Notify("You've already called the dealer.")
        end

        if (!dealerData) then
            ErrorNoHalt("No dealer data for ID:"..dealerID)
            return
        end

        local DealerSpawn, SpawnID = self:RandomSpawn()

        if (DealerSpawn) and ((dealerData.CoolDown or 0) < CurTime()) then

            self.Dealers[dealerID].CoolDown = CurTime() + (ix.config.Get("DealerCooldown", 10)*60)
            self.DealersSpawns[SpawnID].CoolDown = CurTime() + (ix.config.Get("DealerDespawn", 10)*60)

            self.SpawnFindRetry = 0

            local DealerNPC = ents.Create("j_misc_npc_drugdealer");
            DealerNPC:SetPos( DealerSpawn.Pos )
            DealerNPC:SetAngles( (DealerSpawn.Ang and Angle(0,DealerSpawn.Ang.y,0)) or angle_zero)
            DealerNPC:Spawn()
            DealerNPC:Activate()
            DealerNPC.SpawnID = SpawnID
            DealerNPC.dealerID = dealerID

            if (dealerData.DealerName) then
                DealerNPC:SetDealerName(dealerData.DealerName)
            end

            if (dealerData.DealerModel) then
                DealerNPC:SetModel(dealerData.DealerModel)
                DealerNPC:ResetSequence( ACT_IDLE )
            end

            local dealerType

            if (istable(dealerData.DealerType)) then
                dealerType = dealerData.DealerType[ math.random( #dealerData.DealerType ) ]
            else
                dealerType = dealerData.DealerType
            end

            local dealerPrice

            if (istable(dealerData.DealerPrice)) then
                dealerPrice = math.random(dealerData.DealerPrice[1], dealerData.DealerPrice[2])
            else
                dealerPrice = dealerData.DealerPrice
            end


            DealerNPC:SetDealerPrice(dealerPrice)
            -- DealerNPC.LookingItem = dealerType
            DealerNPC:SetDealerType(dealerType)

            local itemData = ix.item.list[DealerNPC:GetDealerType()]

            DealerNPC:SetDealerTypeName(itemData.name)

            DealerNPC:SetLookingForPly(client)

            timer.Simple(1.5, function()
                if (!DealerNPC) or (!IsValid(DealerNPC)) then return end

                PLUGIN.SpawnedDealers = PLUGIN.SpawnedDealers or {}
                PLUGIN.SpawnedDealers[DealerNPC] = dealerID

                net.Start("NetDealerCalled")
                --     -- net.WriteTable(PLUGIN.SpawnedDealers)
                --     net.WriteEntity(DealerNPC)
                    net.WriteUInt(dealerID, 5)
                    net.WriteVector(DealerNPC:GetPos())
                    net.WriteString(DealerNPC:GetDealerName())
                    net.WriteString(DealerNPC:GetDealerTypeName())
                net.Send(client)
            end)

            client.DealerCalled = true

            client:Notify("The dealer appeared. Visit before it leaves the area for a while.")
        else
            client:Notify("The dealer is now unable to show up at any area. Try again later")
        end

    end


    function PLUGIN:RandomSpawn()

        local spawnID = math.random( #self.DealersSpawns )
        local randomSpawn = self.DealersSpawns[spawnID]

        local spawnCorrect = true
        -- print("PLUGIN.SpawnFindRetry", PLUGIN.SpawnFindRetry)
        -- if (PLUGIN.SpawnFindRetry >= 5) then
        --     return false
        -- end

        if (randomSpawn.CoolDown) and (randomSpawn.CoolDown > CurTime()) and (PLUGIN.SpawnFindRetry < 5) then
            spawnCorrect = false
            self:RandomSpawn()
            PLUGIN.SpawnFindRetry = PLUGIN.SpawnFindRetry + 1
        end

        if (spawnCorrect) then
            if (self.SpawnFindRetry < 5) then
                local foundEnts = ents.FindInSphere( randomSpawn.Pos, 1000 )

                for k, v in ipairs(foundEnts) do
                    if (v:IsPlayer()) then
                        spawnCorrect = false
                        self:RandomSpawn()
                        self.SpawnFindRetry = self.SpawnFindRetry + 1
                        break
                    end
                end

            end
        end

        if (spawnCorrect) then
            return randomSpawn, spawnID
        end

        return false

    end

end

if (CLIENT) then

    local PLUGIN = PLUGIN
    PLUGIN.SpawnedDealers = PLUGIN.SpawnedDealers or {}

    // lua_run PrintTable(ix.plugin.Get("miscellaneous").SpawnedDealers)

    net.Receive( "DealerSays", function( len, client )

        local DEnt = net.ReadEntity()
        local text = net.ReadString()

        if (!DEnt) or (!IsValid(DEnt)) then return end
        if (!text) or (text == "")  then return end

        PLUGIN:DealerSays(DEnt, text)

    end)

    net.Receive( "NetDealerCalled", function( len, client )

    --     -- local tbl = net.ReadTable()
    --     local DEnt = net.ReadEntity()
        local DID = net.ReadUInt(5)
        local vector = net.ReadVector()    
        local dname = net.ReadString()
        local dtype = net.ReadString()

        PLUGIN.SpawnedDealers[#PLUGIN.SpawnedDealers+1] = {
            DLocation = vector,
            DName = dname,
            DType = dtype,
            Despawn = CurTime() + (ix.config.Get("DealerDespawn", 10)*60)
        }

    --     PLUGIN.Dealers[DID].CoolDown = CurTime() + (ix.config.Get("DealerDespawn", 10)*60)

    --     -- if (!DEnt) or (!IsValid(DEnt)) then return end

    --     -- LocalPlayer().DealerLocation = DEnt
    

    end)

    local function JR_DealersLocations()
        localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
        if (!IsValid(localplayer)) then return end

        if (!localplayer:GetCharacter()) then return end

        for k, v in pairs(PLUGIN.SpawnedDealers or {}) do
        -- for i, k in ipairs(ents.FindByClass( "j_misc_npc_drugdealer" )) do

            -- if (IsValid(k)) and (k.GetLookingForPly and k:GetLookingForPly() and k:GetLookingForPly() == localplayer) then

            if ((v.Despawn or 0) < CurTime()) then
                PLUGIN.SpawnedDealers[k] = nil
            end

                local PlayerPos = localplayer:GetPos()
                local DealerLoc = v.DLocation--k:GetPos()

                if (PlayerPos:DistToSqr(DealerLoc) < 50000) then
                    PLUGIN.SpawnedDealers[k] = nil
                end

                local drawPos = (DealerLoc + Vector( 0,0,20 )):ToScreen()

                local dist = PlayerPos:Distance(DealerLoc)
                local convertUnit = math.floor( dist * ( 1 / 16 ) * 10 ) / 10

                -- surface.SetDrawColor(255,anim,anim)
                -- surface.SetMaterial( heart_icon )
                -- surface.DrawTexturedRect(drawPos.x - 12, drawPos.y - 75, 32,32)
                draw.SimpleText( "/", "ixIconsBig", drawPos.x + 5, drawPos.y - 55, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText( v.DName .. " ["..v.DType.."]", "ixMediumFont", drawPos.x + 5, drawPos.y - 25, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                -- draw.SimpleText( k:GetDealerName() .. " ["..k:GetDealerTypeName().."]", "ixMediumFont", drawPos.x + 5, drawPos.y - 25, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText( convertUnit.."'", "ixMediumLightFont", drawPos.x + 5, drawPos.y - 5, Color(250,250,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            -- end
        end
    end

    hook.Add("HUDPaintBackground", "IxMisc_DrawJRDealersLocations", JR_DealersLocations)

end

function PLUGIN:DealerSays(DEnt, text)

    if (SERVER) then

        net.Start("DealerSays")
            net.WriteEntity(DEnt)
            net.WriteString(text)
        net.Broadcast()

    else

        if ((DEnt:GetPos() - LocalPlayer():GetPos()):LengthSqr() < (ix.config.Get("chatRange", 280)^2)) then

            local format = "%s says \"%s\""

            local DName = DEnt:GetDealerName()

            chat.AddText(ix.config.Get("chatColor"), string.format(format, DName, text))
        end
    end
end