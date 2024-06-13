if (SERVER) then

    function PLUGIN:PlayerUse(client, ent)
        if (client:IsBlindfold()) then
            return false
        end
    end

    function PLUGIN:CanPlayerInteractItem(client, action, item, data)
        if (client:IsBlindfold()) then
            return false
        end
    end

    function PLUGIN:SetupMove(client, mv, cmd)

        if (client:IsRestricted()) then
            if (client:IsOnGround() and (!client:Crouching()) and (!client.ixRagdoll)) then
                if (!client.ZipTieBonesApplied) then
                    self:ApplyZipTieBones(client)
                end
            else
                if (client.ZipTieBonesApplied) then
                    self:ResetZipTieBones(client)
                end
            end
        else
            if (client.ZipTieBonesApplied) then
                self:ResetZipTieBones(client)
            end
        end

    end

    function PLUGIN:OnPlayerOptionSelected(target, client, option)
        if (option == "Remove Ties") then
            
            if (!client:IsRestricted() and target:IsPlayer() and target:IsRestricted() and !target:GetNetVar("untying")) then
                
                target:SetAction("@beingUntied", 5)
                target:SetNetVar("untying", true)

                client:SetAction("@unTying", 5)

                client:DoStaredAction(target, function()
                    target:SetRestricted(false)
                    target:SetBlindfold(false)
                    target:SetNetVar("untying")
                    client:EmitSound("npc/roller/blade_in.wav")
                end, 5, function()
                    if (IsValid(target)) then
                        target:SetNetVar("untying")
                        target:SetAction()
                    end

                    if (IsValid(client)) then
                        client:SetAction()
                    end
                end)
            end
        end
        if (option == "Remove Blindfold") then
            
            if (!client:IsRestricted() and target:IsPlayer() and target:IsRestricted() and target:IsBlindfold() and !target:GetNetVar("unblinding")) then
                
                target:SetAction("@beingUnBlind", 5)
                target:SetNetVar("unblinding", true)

                client:SetAction("@unblinding", 5)

                client:DoStaredAction(target, function()
                    target:SetRestricted(false)
                    target:SetBlindfold(false)
                    target:ScreenFade( SCREENFADE.IN, Color( 0,0,0 ), 1, 1 )
                    target:SetNetVar("unblinding")
                    client:EmitSound("npc/roller/blade_in.wav")
                end, 5, function()
                    if (IsValid(target)) then
                        target:SetNetVar("unblinding")
                        target:SetAction()
                    end

                    if (IsValid(client)) then
                        client:SetAction()
                    end
                end)
            end
        end
    end

    function PLUGIN:ApplyZipTieBones(client)
        if not IsValid(client) or not client:IsPlayer() then return end 
        
        timer.Simple(0.2, function()
            if not IsValid(client) or not client:IsPlayer() then 
                client.ZipTieBonesApplied = false
            return end 
            for k,v in pairs(self.ManipulateBoneRestrict) do 
                local bone = client:LookupBone(k)
                if bone then
                    client:ManipulateBoneAngles(bone, v)
                end
            end

        end)

        client.ZipTieBonesApplied = true
        

    end


    function PLUGIN:ResetZipTieBones(ply)
        if not IsValid(ply) or not ply:IsPlayer() then return end 

        for k,v in pairs(self.ManipulateBoneRestrict) do 
            if isnumber(ply:LookupBone( k )) then 
                ply:ManipulateBoneAngles(ply:LookupBone( k ), Angle(0,0,0))
            end 
        end
        ply.ZipTieBonesApplied = false
    end

else

    local blindMaterial = ix.util.GetMaterial("models/props_c17/fence_alpha")

    function PLUGIN:RenderScreenspaceEffects()
        if (LocalPlayer():IsBlindfold()) then

            render.UpdateScreenEffectTexture()

            surface.SetDrawColor(Color(0,0,0,255))
            surface.DrawRect(0,0,ScrW(), ScrH())

            blindMaterial:SetFloat("$alpha", 0.5)
            blindMaterial:SetFloat("$color", 0.1)
            blindMaterial:SetInt("$ignorez", 1)

            render.SetMaterial(blindMaterial)
            render.DrawScreenQuad()

        end
    end

    function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
        if (client:IsRestricted()) then
            local panel = tooltip:AddRowAfter("name", "ziptie")
            panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
            panel:SetText(L("tiedUp"))
            panel:SizeToContents()
        elseif (client:GetNetVar("tying")) then
            local panel = tooltip:AddRowAfter("name", "ziptie")
            panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
            panel:SetText(L("beingTied"))
            panel:SizeToContents()
        elseif (client:GetNetVar("untying")) then
            local panel = tooltip:AddRowAfter("name", "ziptie")
            panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
            panel:SetText(L("beingUntied"))
            panel:SizeToContents()
        end
        if (client:IsBlindfold()) then
            local panel = tooltip:AddRowAfter("name", "blindfold")
            panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
            panel:SetText(L("blind"))
            panel:SizeToContents()
        elseif (client:GetNetVar("blindfolding")) then
            local panel = tooltip:AddRowAfter("name", "blindfold")
            panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
            panel:SetText(L("beingBlind"))
            panel:SizeToContents()
        elseif (client:GetNetVar("unblindfolding")) then
            local panel = tooltip:AddRowAfter("name", "blindfold")
            panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
            panel:SetText(L("beingUnBlind"))
            panel:SizeToContents()
        end
    end

    function PLUGIN:GetPlayerEntityMenu(client, options)
        if (client:IsRestricted()) then
            options["Remove Ties"] = true
        end
        if (client:IsBlindfold()) then
            options["Remove Blindfold"] = true
        end
        -- return client, options
    end

end