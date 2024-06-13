PLUGIN.name = "ArcCW Support + Magazine System"
PLUGIN.author = "JohnyReaper"

/////////////////////////////////////////////////
/////////////////// CONFIG //////////////////////
/////////////////////////////////////////////////

PLUGIN.WeaponCategories = {}
PLUGIN.WeaponCategories["arccw_deagle357"] = "sidearm"
PLUGIN.WeaponCategories["arccw_deagle50"] = "sidearm"
PLUGIN.WeaponCategories["arccw_fiveseven"] = "sidearm"
PLUGIN.WeaponCategories["arccw_g18"] = "sidearm"
PLUGIN.WeaponCategories["arccw_m9"] = "sidearm"
PLUGIN.WeaponCategories["arccw_makarov"] = "sidearm"
PLUGIN.WeaponCategories["arccw_ruger"] = "sidearm"
PLUGIN.WeaponCategories["arccw_p228"] = "sidearm"
PLUGIN.WeaponCategories["arccw_ragingbull"] = "sidearm"
PLUGIN.WeaponCategories["arccw_usp"] = "sidearm"

/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////


PLUGIN.AmmoTypes = {}
PLUGIN.AmmoTypes["pistol"] = "models/items/arccw/pistol_ammo.mdl"
PLUGIN.AmmoTypes["smg1"] = "models/items/arccw/smg_ammo.mdl"
PLUGIN.AmmoTypes["SniperPenetratedRound"] = "models/items/arccw/sniper_ammo.mdl"
PLUGIN.AmmoTypes["357"] = "models/items/arccw/magnum_ammo.mdl"
PLUGIN.AmmoTypes["buckshot"] = "models/items/arccw/shotgun_ammo.mdl"
PLUGIN.AmmoTypes["ar2"] = "models/items/arccw/rifle_ammo.mdl"

PLUGIN.AmmoMags = {}
PLUGIN.AmmoMags["pistol"] = "models/weapons/arccw/magazines/mps2_small.mdl"
PLUGIN.AmmoMags["smg1"] = "models/weapons/arccw/magazines/type2_small.mdl"
PLUGIN.AmmoMags["SniperPenetratedRound"] = "models/weapons/arccw/magazines/hs338.mdl"
PLUGIN.AmmoMags["357"] = "models/weapons/arccw/magazines/roland_small.mdl"
PLUGIN.AmmoMags["buckshot"] = "models/weapons/arccw/magazines/m2000g_small.mdl"
PLUGIN.AmmoMags["ar2"] = "models/weapons/arccw/magazines/mk4.mdl"

PLUGIN.ammoNames = {

    ["pistol"] = "Pistol",
    ["smg1"] = "Carbine",
    ["SniperPenetratedRound"] = "Sniper",
    ["357"] = "Magnum",
    ["buckshot"] = "Buckshot",
    ["ar2"] = "Rifle",
    
}

if (SERVER) then

    function PLUGIN:Think()

        for client, character in ix.util.GetCharacters() do
            
            if (client:GetActiveWeapon()) and (IsValid(client:GetActiveWeapon())) and (string.find(client:GetActiveWeapon():GetClass(),"arccw")) then

                local weapon = client:GetActiveWeapon()

                if (weapon.Base == "arccw_base_melee") or (weapon.Base == "arccw_base_nade") then continue end
                
                if (weapon:GetReloading() and (weapon:GetHolster_Time() == 0) and (!weapon.UnReady)) then

                    if (client.MagsNextCheck or 0) < CurTime() then

                        client.ReloadAmmoOldV = client:GetAmmo()[weapon:GetPrimaryAmmoType()] or 0
                        
                        if (weapon.ShotgunReload) then

                            if (weapon:GetShotgunReloading() != 0) and (weapon.LastAnimKey == "sgreload_insert") then

                                local inv = character:GetInventory()

                                for k, v in pairs(inv:GetItems()) do

                                    local magName = string.lower(game.GetAmmoName(weapon:GetPrimaryAmmoType())).."_box"

                                    if (v.uniqueID == magName) then

                                        v:SetData("ammo", v:GetData("ammo") - 1)

                                        if (v:GetData("ammo") <= 0) then
                                            v:Remove()
                                        end

                                        break

                                    end

                                end

                            end

                        else

                            timer.Simple( (weapon:GetReloadingREAL() - CurTime() + 0.1), function()
     
                                if (!IsValid(weapon)) then client.ReloadAmmoOldV = nil return end
                                if (client:GetActiveWeapon() != weapon) then client.ReloadAmmoOldV = nil return end

                                if (!client.ReloadAmmoOldV) then return end

                                local newAmmo = client.ReloadAmmoOldV - (client:GetAmmo()[weapon:GetPrimaryAmmoType()] or 0)

                                local inv = character:GetInventory()

                                for k, v in pairs(inv:GetItems()) do

                                    local magName = string.lower(game.GetAmmoName(weapon:GetPrimaryAmmoType())).."_mag"

                                    if (v.uniqueID == magName) then
      
                                        if (v:GetData("maxAmmo") <= 0) then continue end
    
                                        if (v:GetData("maxAmmo") == weapon:GetCapacity()) then
           
                                            if (newAmmo > v:GetData("ammo",0)) then

                                                newAmmo = newAmmo - v:GetData("ammo",0)
                                                v:SetData("ammo", 0)
                                                -- break
                                            else

                                                v:SetData("ammo", v:GetData("ammo",0) - newAmmo)
                                                break

                                            end

                                        end


                                    end

                                    

                                end

                            end)

                        end


                        -- print(client:GetViewModel():GetSequenceName(client:GetViewModel():GetSequence()), weapon.LastAnimKey)

                        client.MagsNextCheck = weapon:GetReloadingREAL() --+ client:GetViewModel():SequenceDuration(client:GetViewModel():GetSequence())
                        
                    end

                end

            end

        end

    end

    function PLUGIN:PlayerSwitchWeapon(client, oldWeapon, newWeapon )

        if (IsValid(newWeapon)) then

            if (string.find(newWeapon:GetClass(),"arccw")) then

                if (newWeapon.Base != "arccw_base_melee") and (newWeapon.Base != "arccw_base_nade") then

                    client.MagsNextCheck = CurTime() + 1

                    timer.Simple(0.1, function()

                        local data = {
                            ["equip"] = true
                        }

                        local char = client:GetCharacter()
                        local inv = char:GetInventory()

                        local item = inv:HasItem(newWeapon:GetClass(),data)

                        if (item) then

                            local ammoType = newWeapon:GetPrimaryAmmoType()

                            client.OldAmmo = client.OldAmmo or {}
                            client.OldAmmo[ammoType] = client:GetAmmo()[ammoType]

                            client:RemoveAmmo(99999, ammoType)

                            for k, v in pairs(inv:GetItems()) do

                                if (newWeapon.ShotgunReload) then

                                    local magName = string.lower(game.GetAmmoName(ammoType)).."_box"

                                    if (v.uniqueID == magName) then

                                        client:GiveAmmo(v:GetData("ammo", 0), ammoType, true)

                                    end

                                else

                                    local magName = string.lower(game.GetAmmoName(ammoType)).."_mag"

                                    if (v.uniqueID == magName) then

                                        if (v:GetData("maxAmmo") <= 0) then continue end

                                        if (v:GetData("maxAmmo") == newWeapon:GetCapacity()) then

                                            client:GiveAmmo(v:GetData("ammo", 0), ammoType, true)

                                        end

                                    end

                                end

                            end

                        end

                    end)

                end

            elseif (IsValid(oldWeapon)) and (!string.find(newWeapon:GetClass(),"arccw")) and (string.find(oldWeapon:GetClass(),"arccw")) then 

                local ammoType = oldWeapon:GetPrimaryAmmoType()

                client.OldAmmo = client.OldAmmo or {}
                if (client.OldAmmo[ammoType]) then
                    client:SetAmmo(client.OldAmmo[ammoType], ammoType, true)
                    client.OldAmmo[ammoType] = nil
                end

            end

        end

    end
end

function PLUGIN:ArcCW_PlayerCanAttach(ply, wep, attname, slot, detach)
    local char = ply:GetCharacter()
    if(!char) then 
        return false 
    end

    local inv = char:GetInventory()
    if(!inv) then 
        return false 
    end

    -- if (string.find(attname, "charm")) then
    --     return true
    -- end

    -- print(attname)

    if (attname) and (attname != "") then
        if (ArcCW.AttachmentTable[attname].Free) then
            if(wep.Attachments) then

                local curAtt = wep.Attachments[slot].Installed or nil

                if (curAtt) then
                    if (ArcCW.AttachmentTable[curAtt].Free) then
                        return true
                    else
                        return false
                    end
                else
                    return true
                end

                -- if (wep.Attachments[slot].Installed) then

                --     local curAtt = wep.Attachments[slot].Installed

                -- end

            end
        end
    else

        if(wep.Attachments) then

            local curAtt = wep.Attachments[slot].Installed or nil

            if (curAtt) then
                if (ArcCW.AttachmentTable[curAtt].Free) then
                    return true
                else
                    return false
                end
            end

        end

    end
        

    local data = {
        ["equip"] = true
    }

    local item = inv:HasItem(wep:GetClass(),data)

    if (item) then

        local getAllAtts = item:GetData("Attachments", {})

        if (getAllAtts[attname]) and (ply.AttachUsingItem) then
            return true
        end


    end


end

if(CLIENT and ArcCW) then //Crosshair is broken for IX, we have already Health indicator in IX.
    GetConVar("arccw_crosshair"):SetInt(0)
    GetConVar("arccw_hud_showhealth"):SetInt(0)
    function PLUGIN:ShouldDrawCrosshair(_, weapon)
        if IsValid(weapon) and (string.find(weapon:GetClass(),"arccw")) then
            return true
        end
    end

    function PLUGIN:CanDrawAmmoHUD(weapon)
        if IsValid(weapon) and (string.find(weapon:GetClass(),"arccw")) then
            return false
        end
    end

end

function PLUGIN:InitializedPlugins()
    if(!ArcCW) then 
        return print("[ArcCW Support] Can not find ArcCW addon!")
    end

    if (SERVER) then
        GetConVar("arccw_attinv_free"):SetInt(0)
        GetConVar("arccw_attinv_lockmode"):SetInt(0)
        GetConVar("arccw_enable_customization"):SetInt(0)
        GetConVar("arccw_enable_dropping"):SetInt(0)
        GetConVar("arccw_equipmentammo"):SetInt(0)
    end

    local ammoCount = {
        ["pistol"] = 24,
        ["smg1"] = 30,
        ["ar2"] = 30,
        ["357"] = 6,
        ["buckshot"] = 12,
        ["SniperPenetratedRound"] = 5,
    }

    print("[ArcCW Support] Registering ammo and magazines items...")

    for k,v in pairs(self.AmmoTypes) do
        local ITEM = ix.item.Register(k.."_box", nil, false, nil, true)
        ITEM.name = self.ammoNames[k ] .. " Ammo"
        ITEM.description = "Package containing a mix of cartridges for '"..self.ammoNames[k].."' ammo type"
        ITEM.model = v
        ITEM.width = 1
        ITEM.height = 1
        ITEM.category = "Ammo"
        ITEM.isArcCWAmmo = true
        ITEM.AmmoType = k
        ITEM.bDropOnDeath = true

        function ITEM:GetDescription()
            return self.description
        end

        function ITEM:OnRemoved()

            self.player = self:GetOwner()

            local ply = self.player

            if (ply and IsValid(ply) and IsValid(ply:GetActiveWeapon())) then
                if (ply:GetActiveWeapon():GetPrimaryAmmoType() > 0) then
                    if (ply:GetActiveWeapon().ShotgunReload) then
                        if (string.lower(game.GetAmmoName(ply:GetActiveWeapon():GetPrimaryAmmoType())) == self.AmmoType) then
                            ply:RemoveAmmo(self:GetData("ammo", ammoCount[self.AmmoType]), self.AmmoType)
                        end
                    end
                end
            end

            self.player = nil

        end

        function ITEM:OnTransferred(curInv, inventory)

            local owner = curInv.owner
            local NewOwner = inventory.owner

            if (isfunction(curInv.GetOwner)) then
                local owner = curInv:GetOwner()
                if (IsValid(owner)) then

                    if (IsValid(owner:GetActiveWeapon())) then
                        if (owner:GetActiveWeapon():GetPrimaryAmmoType() > 0) then
                            if (owner:GetActiveWeapon().ShotgunReload) then
                                if (string.lower(game.GetAmmoName(owner:GetActiveWeapon():GetPrimaryAmmoType())) == self.AmmoType) then
                                    owner:RemoveAmmo(self:GetData("ammo", ammoCount[self.AmmoType]), self.AmmoType)
                                end
                            end
                        end
                    end

                end
            end

            if (isfunction(inventory.GetOwner)) then
                local NewOwner = inventory:GetOwner()
                if (IsValid(NewOwner)) then

                    if (IsValid(NewOwner:GetActiveWeapon())) then
                        if (NewOwner:GetActiveWeapon():GetPrimaryAmmoType() > 0) then
                            if (NewOwner:GetActiveWeapon().ShotgunReload) then
                                if (string.lower(game.GetAmmoName(NewOwner:GetActiveWeapon():GetPrimaryAmmoType())) == self.AmmoType) then
                                    NewOwner:GiveAmmo(self:GetData("ammo", ammoCount[self.AmmoType]), self.AmmoType)
                                end
                            end
                        end
                    end
                    
                end
            end

        end

        function ITEM:OnInstanced(invID, x, y)
            -- self:SetData("ammo", ammoCount[k])
        end

        function ITEM:PaintOver(item, w, h)

            local ammo = item:GetData("ammo") or ammoCount[item.AmmoType] or 0

            draw.SimpleTextOutlined(ammo, "DermaDefault", w - 5, h - 3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)

        end

    end

    for k,v in pairs(self.AmmoMags) do
        local ITEM = ix.item.Register(k.."_mag", nil, false, nil, true)
        ITEM.name = self.ammoNames[k] .. " Magazine"
        ITEM.description = "Magazine that can be used for weapons that use "..self.ammoNames[k].." ammo type"
        ITEM.model = v
        ITEM.width = 1
        ITEM.height = 1
        ITEM.category = "Magazines"
        ITEM.isArcCWMag = true
        ITEM.AmmoType = k
        ITEM.bDropOnDeath = true



        function ITEM:GetName()
            if (self:GetData("newName")) then
                return self:GetData("newName") .. " Magazine"
            else   
                return self.name
            end
        end

        function ITEM:GetDescription()
            return self.description
        end


        function ITEM:OnTransferred(curInv, inventory)

            local owner = curInv.owner
            local NewOwner = inventory.owner


            if (isfunction(curInv.GetOwner)) then
                local owner = curInv:GetOwner()

                if (IsValid(owner)) then

                    -- if (self:GetData("weaponClass", "") != "") then

                    --     local oldWep = self:GetData("weaponClass", "")
                    if (self:GetData("maxAmmo") > 0) then
                        local current_wep = owner:GetActiveWeapon()

                        -- if (owner:GetActiveWeapon():GetClass() == oldWep) then
                        if (current_wep.ArcCW) and (current_wep:GetPrimaryAmmoType() > 0) and (string.lower(game.GetAmmoName(current_wep:GetPrimaryAmmoType())) == self.AmmoType) and (self:GetData("maxAmmo") == current_wep:GetCapacity()) then
                            owner:RemoveAmmo(self:GetData("ammo", 0), self.AmmoType)
                        end

                    end

                end
            end


            if (isfunction(inventory.GetOwner)) then
                local NewOwner = inventory:GetOwner()

                if (IsValid(NewOwner)) then

                    -- if (self:GetData("weaponClass", "") != "") then

                    --     local oldWep = self:GetData("weaponClass", "")

                        -- if (NewOwner:GetActiveWeapon():GetClass() == oldWep) then
                    if (self:GetData("maxAmmo") > 0) then
                        local current_wep = NewOwner:GetActiveWeapon()

                        if (current_wep.ArcCW) and (current_wep:GetPrimaryAmmoType() > 0) and (string.lower(game.GetAmmoName(current_wep:GetPrimaryAmmoType())) == self.AmmoType) and (self:GetData("maxAmmo") == current_wep:GetCapacity()) then
                            NewOwner:GiveAmmo(self:GetData("ammo", 0), self.AmmoType)
                        end

                    end
                    
                end
            end

        end

        function ITEM:OnRemoved()

            -- if (self:GetData("weaponClass", "") != "") then
            if (self:GetData("maxAmmo") > 0) then

            --     local oldWep = self:GetData("weaponClass", "")

                self.player = self:GetOwner()

                local ply = self.player

                -- if (ply:GetActiveWeapon():GetClass() == oldWep) then
                if (ply and IsValid(ply)) then

                    local current_wep = ply:GetActiveWeapon()

                    if (current_wep.ArcCW) and (current_wep:GetPrimaryAmmoType() > 0) and (string.lower(game.GetAmmoName(current_wep:GetPrimaryAmmoType())) == self.AmmoType) and (self:GetData("maxAmmo") == current_wep:GetCapacity()) then
                        ply:RemoveAmmo(self:GetData("ammo", 0), self.AmmoType)
                    end
                end

                self.player = nil

            end

        end

        function ITEM:OnInstanced(invID, x, y)
            self:SetData("maxAmmo", 0)
        end

        ITEM.functions.combine = {
            OnCanRun = function(item, data)
                if not data then return false end
                local targetItem = ix.item.instances[data[1]]

                if (targetItem.isArcCWAmmo) or (targetItem.isArcCWMag) then
                    if (targetItem.AmmoType == item.AmmoType) then
                        return true
                    else
                        return false
                    end
                else
                    return false
                end

            end,
            OnRun = function(item, data)
                local targetItem = ix.item.instances[data[1]]

                if (!item:GetData("ammo")) then
                    item:SetData("ammo", 0)
                end

                if (targetItem.isArcCWMag) then
                    if (!targetItem:GetData("ammo")) then
                        targetItem:SetData("ammo", 0)
                    end
                end

                if (item:GetData("maxAmmo", 0) == 0) then return false end
                -- if (item:GetData("ammo", 0) == 0) then return false end
                
                if (targetItem.isArcCWMag) then
                    if (targetItem:GetData("maxAmmo", 0) == 0) then return false end
                    if (targetItem:GetData("ammo", 0) == 0) then return false end
                end

                if (item:GetData("ammo") == item:GetData("maxAmmo")) then
                    return false
                end

                local oldValue = item:GetData("ammo")

                local ammoChange = math.Clamp(item:GetData("ammo") + targetItem:GetData("ammo", ammoCount[targetItem.AmmoType]), 0, item:GetData("maxAmmo"))

                item:SetData("ammo", ammoChange)
                targetItem:SetData("ammo", targetItem:GetData("ammo",ammoCount[targetItem.AmmoType]) - (ammoChange-oldValue) )

                local owner = item.player

                if (IsValid(owner:GetActiveWeapon())) then
                    if (owner:GetActiveWeapon():GetPrimaryAmmoType() > 0) then
                        if (owner:GetActiveWeapon().ShotgunReload) then
                            if (string.lower(game.GetAmmoName(owner:GetActiveWeapon():GetPrimaryAmmoType())) == item.AmmoType) then
                                owner:RemoveAmmo( (ammoChange-oldValue), item.AmmoType)
                            end
                        end
                    end
                end

                -- for k, v in pairs(item.player:GetWeapons()) do

                if (IsValid(owner:GetActiveWeapon())) then
                    if (owner:GetActiveWeapon():GetPrimaryAmmoType() > 0) then
                        if (string.lower(game.GetAmmoName(owner:GetActiveWeapon():GetPrimaryAmmoType())) == item.AmmoType) then
                            if (owner:GetActiveWeapon():GetClass() == item:GetData("weaponClass")) or (item:GetData("maxAmmo") == owner:GetActiveWeapon():GetCapacity()) then
                                item.player:GiveAmmo( (ammoChange-oldValue), item.AmmoType, true)
                                -- break
                            end
                        end
                    end
                end

                -- end

                item.player:EmitSound("weapons/arccw/useatt.wav", 60)

                if (targetItem:GetData("ammo") <= 0) and (targetItem.isArcCWAmmo) then
                    targetItem:Remove()
                end

                return false

            end,
        }

        function ITEM:PaintOver(item, w, h)

            local ammo = item:GetData("ammo") or 0
            local maxAmmo = item:GetData("maxAmmo") or 0


            if (ammo <= 0) and (maxAmmo <= 0) then
                draw.SimpleTextOutlined("Assign", "DermaDefault", w - 3, h - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
            else
                draw.SimpleTextOutlined(ammo.."/"..maxAmmo, "DermaDefault", w - 3, h - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
            end

            

        end

    end

    print("[ArcCW Support] Registering attachements items...")

    local items= {}

    for k,v in pairs(ArcCW.AttachmentTable) do
        items[k]={
            ["name"] = v.PrintName,
            ["model"] = v.Model or "models/props_junk/cardboard_box004a.mdl",
            ["width"] = 1,
		    ["height"] = 1,
            ["att_slot"] = v.Slot,
            ["desc"] = v.Description or "You can attach it to the weapon."
        }
    end

    for k,v in pairs(items) do
        local ITEM = ix.item.Register(k, nil, false, nil, true)
        ITEM.name = v.name
        ITEM.description = v.desc
        ITEM.model = v.model
        ITEM.width = v.width or 1
        ITEM.height = v.height or 1
        ITEM.isArcCWAtt = true
        ITEM.AttSlot = v.att_slot
        ITEM.category = "Weapon Attachments"
        ITEM.bDropOnDeath = true

        function ITEM:GetDescription()
		    return self.description
	    end

    end


    print("[ArcCW Support] Registering weapons items...")

    local allWeapons = weapons.GetList()

    local PLUGIN = self

    for k, v in ipairs(allWeapons) do
        
        if ((v.Base == "arccw_base") or (v.Base == "arccw_base_melee") or (v.Base == "arccw_base_nade")) and (v.ClassName != "arccw_base_melee" and v.ClassName != "arccw_base_nade") then

            if (v.Base == "arccw_base_melee") then

                local ITEM = ix.item.Register(v.ClassName, "base_weapons", false, nil, true)
                ITEM.name = v.PrintName
                ITEM.description = v.Trivia_Desc or "Melee weapon"
                ITEM.model = v.WorldModel or "models/error.mdl"
                ITEM.class = v.ClassName
                ITEM.width = 1
                ITEM.height = 1
                ITEM.isWeapon = true
                ITEM.isArcCW = true
                -- ITEM.AmmoType = WeaponData.Primary.Ammo
                ITEM.weaponCategory = "melee"
                ITEM.category = "Melee Weapons"
                ITEM.bDropOnDeath = true


            elseif (v.Base == "arccw_base_nade") then

                local WeaponData = weapons.GetStored(v.ClassName)

                if (!WeaponData) then
                    continue
                end

                local ITEM = ix.item.Register(v.ClassName, "base_weapons", false, nil, true)
                ITEM.name = v.PrintName
                ITEM.description = v.Trivia_Desc or "Throwable weapon"
                ITEM.model = v.WorldModel or "models/error.mdl"
                ITEM.class = v.ClassName
                ITEM.width = 1
                ITEM.height = 1
                ITEM.isWeapon = true
                ITEM.isArcCW = true
                ITEM.isGrenade = true
                -- ITEM.AmmoType = WeaponData.Primary.Ammo
                ITEM.weaponCategory = "throwable"
                ITEM.category = "Throwable Weapons"
                ITEM.bDropOnDeath = true


                WeaponData.ForceDefaultAmmo = 0

                function WeaponData:InitialDefaultClip()
                    return
                end

                -- function WeaponData:Hook_Throw(data)
                function WeaponData:Hook_PostFireRocket(rocket_ent)

                    if (rocket_ent) then

                        rocket_ent.ixItem = self.ixItem

                        rocket_ent:CallOnRemove("GrenadeItemRemover", function(ent)
                            
                            if (ent.ixItem) then
                                ent.ixItem:Unequip(ent:GetOwner(), false, true)
                            end
                        end)

                    end

                end

            else

                -- ALWAYS_RAISED[v.ClassName] = true

                local WeaponData = weapons.GetStored(v.ClassName)

                if (!WeaponData) then
                    continue
                end

                -- WeaponData.LowerAngles = WeaponData.HolsterAng--Angle(5,-10,-5)
                -- WeaponData.LowerAngles2 = WeaponData.HolsterAng

                WeaponData.ForceDefaultAmmo = 0

                -- function WeaponData:InitialDefaultClip()
                --     return
                -- end

                local ITEM = ix.item.Register(v.ClassName, "base_weapons", false, nil, true)
                ITEM.name = v.PrintName
                ITEM.description = v.Trivia_Desc or "Firearm"
                ITEM.model = v.WorldModel or "models/error.mdl"
                ITEM.class = v.ClassName
                ITEM.width = (PLUGIN.WeaponCategories[v.ClassName] and 2) or 3
                ITEM.height = 1
                ITEM.isWeapon = true
                ITEM.isArcCW = true
                ITEM.AmmoType = WeaponData.Primary.Ammo
                ITEM.weaponCategory = PLUGIN.WeaponCategories[v.ClassName] or "primary"
                ITEM.category = "Firearms"
                ITEM.bDropOnDeath = true


                -- ITEM:SetData("Attachments", {})

                function ITEM:ArcCW_CheckWeaponAcceptAtt(wep, att)

                    if wep.ArcCW and wep.Attachments then

                        local WhichSlot = ArcCW.AttachmentTable[att].Slot

                        local IsAccepted = false

                        for k, v in pairs(wep.Attachments) do
                            
                            if (istable(v.Slot)) then

                                for i, j in ipairs(v.Slot) do
                                    
                                    if (j == WhichSlot) then
                                        return true, k
                                    end

                                end

                            else
                                if (v.Slot == WhichSlot) then
                                    return true, k
                                end
                            end

                        end

                        return false

                    else
                        return false
                    end

                end

                ITEM.functions.combine = {
                    OnCanRun = function(item, data)
                        if not data then return false end
                        local targetItem = ix.item.instances[data[1]]

                        if (targetItem.isArcCWAtt) or (targetItem.isArcCWMag) then
                            return true
                        end

                        return false

                    end,
                    OnRun = function(item, data)
                        local targetItem = ix.item.instances[data[1]]

                        local ply = item.player
                        local char = ply:GetCharacter()
                        local inv = char:GetInventory()

                        if (targetItem.isArcCWMag) then

                            if (!item:GetData("equip")) then
                                ply:Notify("Equip your weapon before you assign a magazine to it.")
                                return false
                            end

                            if (ply:HasWeapon( item.class )) then

                                local WepData = ply:GetWeapon( item.class )

                                if (item.AmmoType != targetItem.AmmoType) then
                                    return false
                                end

                                if (WepData.ShotgunReload) then
                                    ply:Notify("This weapon does not require magazines")
                                    return false
                                end

                                -- if (targetItem:GetData("weaponClass", "") == item.class) then
                                --     return false
                                -- end

                                if (WepData:GetCapacity() == targetItem:GetData("maxAmmo", 0)) then
                                    return false
                                end

                                -- if (targetItem:GetData("weaponClass", "") != "") then

                                --     local oldWep = targetItem:GetData("weaponClass", "")
                                if (IsValid(ply:GetActiveWeapon())) then

                                    local current_wep = ply:GetActiveWeapon()

                                    -- if (ply:GetActiveWeapon():GetClass() == oldWep) then
                                    if (current_wep.ArcCW) and (current_wep:GetPrimaryAmmoType() > 0) and (string.lower(game.GetAmmoName(current_wep:GetPrimaryAmmoType())) == targetItem.AmmoType) and (WepData:GetCapacity() != current_wep:GetCapacity()) then
                                        ply:RemoveAmmo(targetItem:GetData("ammo", 0), targetItem.AmmoType)
                                    end

                                end

                                -- targetItem:SetData("newName", item.name)
                                -- targetItem:SetData("weaponClass", item.class)
                                targetItem:SetData("maxAmmo", WepData:GetCapacity())
                                //                             ammoCount[targetItem.AmmoType]
                                if (targetItem:GetData("ammo", 0) > targetItem:GetData("maxAmmo", 0)) then

                                    local ammo_data = {
                                        ammo = targetItem:GetData("ammo", 0) - targetItem:GetData("maxAmmo", 0)
                                    }

                                    -- print(ammo_data.ammo)

                                    if (!inv:Add(targetItem.AmmoType.."_box",1,ammo_data)) then
                                        ix.item.Spawn(targetItem.AmmoType.."_box", ply, nil, Angle(0,0,0),ammo_data)
                                    end

                                    targetItem:SetData("ammo", targetItem:GetData("maxAmmo", 0))

                                end

                                if (ply:GetActiveWeapon():GetClass() == item.class) then
                                    item.player:GiveAmmo( targetItem:GetData("ammo", 0), targetItem.AmmoType, true)
                                end

                                item.player:EmitSound("weapons/arccw/dragatt.wav", 60)

                            end

                            return false

                        elseif (targetItem.isArcCWAtt) then

                            if (!item:GetData("Attachments")) then
                                item:SetData("Attachments", {})
                            end

                            
                            if (item:GetData("Attachments")[targetItem.uniqueID]) then
                                ply:Notify("This attachment has already been attached to this weapon.")
                                return false
                            end

                            local WeaponData = weapons.Get(item.class)

                            if (!WeaponData) then
                                return false
                            end

                            local SlotAccepted, SlotID = item:ArcCW_CheckWeaponAcceptAtt(WeaponData, targetItem.uniqueID)

                            if (SlotAccepted) then

                                if (v.Attachments[SlotID].Installed) and (!ArcCW.AttachmentTable[v.Attachments[SlotID].Installed].Free) then
                                    ply:Notify("This weapon already has an attachment in this slot")
                                    return false
                                end

                            else
                                ply:Notify("It isn't possible to attach this attachment to this weapon")
                                return false
                            end

                            local getAllAtts = item:GetData("Attachments", {})

                            getAllAtts[targetItem.uniqueID] = true

                            item:SetData("Attachments", getAllAtts)

                            item.player:EmitSound("weapons/arccw/install.wav", 60)

                            ArcCW:PlayerGiveAtt(ply, targetItem.uniqueID)

                            local weps = ply:GetWeapons()

                            ply.AttachUsingItem = true

                            for k, v in pairs(weps) do
                                if (v.ClassName == item.class) then

                                    local SlotAccepted, SlotID = item:ArcCW_CheckWeaponAcceptAtt(v, targetItem.uniqueID)

                                    if (SlotAccepted) then
                                        v:Attach(SlotID, targetItem.uniqueID)
                                    end

                                    if (ArcCW.AttachmentTable[targetItem.uniqueID].Override_ClipSize) or (ArcCW.AttachmentTable[targetItem.uniqueID].MagExtender) or (ArcCW.AttachmentTable[targetItem.uniqueID].MagReducer) then

                                        ply:SetAmmo(0, v:GetPrimaryAmmoType())

                                        for i, j in pairs(inv:GetItems()) do

                                            local magName = string.lower(game.GetAmmoName(v:GetPrimaryAmmoType())).."_mag"

                                            if (j.uniqueID == magName) then

                                                if (j:GetData("maxAmmo") <= 0) then continue end

                                                if (j:GetData("maxAmmo") == v:GetCapacity()) then

                                                    ply:GiveAmmo(j:GetData("ammo", 0), v:GetPrimaryAmmoType(), true)

                                                end

                                            end

                                        end

                                    end


                                    break
                                end
                            end

                            ply.AttachUsingItem = nil 

                            targetItem:Remove()

                        end

                        return false

                    end
                }

                ITEM.functions.Attachments = {
                    name = "Attachments",
                    tip = "useTip",
                    icon = "icon16/link_break.png",
                    isMulti = true,
                    OnCanRun = function(item)

                        if (!item:GetData("Attachments")) then return false end
                        if table.Count(item:GetData("Attachments", {})) <= 0 then return false end
                        if IsValid(item.entity) then return false end

                    end,
                    multiOptions = function(item, client)
                        local targets = {}
                        local char = client:GetCharacter()

                        if (char) then
                            local atts = item:GetData("Attachments", {})

                            for k, v in pairs(atts) do
                                
                                if (ArcCW.AttachmentTable[k]) then
                                    table.insert(targets, {
                                        name = ArcCW.AttachmentTable[k].PrintName,
                                        data = {k},
                                    })
                                end

                            end

                            
                        end

                        return targets
                    end,
                    OnRun = function(item, data)
                        if not data[1] then return false end
                        local target = data[1]

                        local ply = item.player
                        local char = ply:GetCharacter()

                        if (char) then

                            local inv = char:GetInventory()

                            if (inv) then

                                local successAdd, addError = inv:Add(target)

                                if (!successAdd) then
                                    ply:Notify(addError)
                                    return false
                                end

                                local weps = ply:GetWeapons()

                                ply.AttachUsingItem = true

                                for k, v in pairs(weps) do
                                    if (v.ClassName == item.class) then

                                        local SlotAccepted, SlotID = item:ArcCW_CheckWeaponAcceptAtt(v, target)

                                        if (SlotAccepted) then
                                            v:Detach(SlotID)
                                        end

                                        if (ArcCW.AttachmentTable[target].Override_ClipSize) or (ArcCW.AttachmentTable[target].MagExtender) or (ArcCW.AttachmentTable[target].MagReducer) then

                                            ply:SetAmmo(0, v:GetPrimaryAmmoType())

                                            for i, j in pairs(inv:GetItems()) do

                                                local magName = string.lower(game.GetAmmoName(v:GetPrimaryAmmoType())).."_mag"

                                                if (j.uniqueID == magName) then

                                                    if (j:GetData("maxAmmo") <= 0) then continue end

                                                    if (j:GetData("maxAmmo") == v:GetCapacity()) then

                                                        ply:GiveAmmo(j:GetData("ammo", 0), v:GetPrimaryAmmoType(), true)

                                                    end

                                                end

                                            end

                                        end

                                        break
                                    end
                                end

                                ply.AttachUsingItem = nil

                                local getAllAtts = item:GetData("Attachments")

                                getAllAtts[target] = nil

                                item:SetData("Attachments", getAllAtts)

                                ArcCW:PlayerTakeAtt(ply, target)

                                item.player:EmitSound("weapons/arccw/uninstall.wav", 60)

                            end

                        end

                        return false

                    end
                }



                function ITEM:OnEquipWeapon(client, weapon)

                    timer.Simple(0.1, function()

                        if (!IsValid(weapon)) then return end

                        -- local ammoType = weapon:GetPrimaryAmmoType()

                        -- client:RemoveAmmo(99999, ammoType)

                        -- print(weapon:Clip1(), client:GetAmmoCount(ammoType))

                        local getAllAtts = self:GetData("Attachments")

                        client.AttachUsingItem = true

                        for k, v in pairs(getAllAtts or {}) do
                            
                            ArcCW:PlayerGiveAtt(client, k)
                            -- ArcCW:PlayerSendAttInv(client)

                            local SlotAccepted, SlotID = self:ArcCW_CheckWeaponAcceptAtt(weapon, k)


                            if (SlotAccepted) then
                                weapon:Attach(SlotID, k)
                            end

                        end

                        client.AttachUsingItem = nil

                    end)

                end

                -- timer.Simple(10, function()

                --     local PLUGINPolice = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("setorian_police_system") or false

                --     if (PLUGINPolice.WeaponsClass1[v.ClassName]) or (PLUGINPolice.WeaponsClass3[v.ClassName]) then

                --         function ITEM:OnInstanced(invID, x, y)

                --             local randNum = math.random(1, 99999)

                --             local amount = math.max(1, 5 - string.len(randNum))
                --             local number = string.rep("", amount)..tostring(randNum)


                --             self:SetData("serial_number", number)

                --         end

                --         function ITEM:OnRemoved()

                --             if (PLUGINPolice.GlobalWeaponsData[self:GetData("serial_number", "0")]) then
                --                 PLUGINPolice.GlobalWeaponsData[self:GetData("serial_number", "0")] = nil
                --                 print("Weapon ["..v:GetName().."] was removed from database")
                --                 PLUGINPolice:SaveGlobalWeaponBase()
                --             end

                --         end

                --     end

                -- end)


                if (CLIENT) then

                    function ITEM:PopulateTooltip(tooltip)

                        local count = self:GetData("Attachments") and table.Count(self:GetData("Attachments")) or 0

                        local panel = tooltip:AddRowAfter("name", "atts_count")
                        panel:SetBackgroundColor(Color(39, 174, 96))
                        panel:SetText("Attachments: "..count)
                        panel:SizeToContents()

                        local ammo_name = (self.AmmoType and PLUGIN.ammoNames[self.AmmoType]) or "Unknown"

                        local panel = tooltip:AddRowAfter("atts_count", "ammo_name")
                        panel:SetBackgroundColor(Color(230, 126, 34))
                        panel:SetText("Ammo Type: "..ammo_name)
                        panel:SizeToContents()

                        local serial_number = self:GetData("serial_number", 0)

                        if (serial_number != 0) then

                            local panel = tooltip:AddRowAfter("ammo_name", "serial_number")
                            panel:SetBackgroundColor(Color(39, 174, 96))
                            panel:SetText("Serial Number: "..serial_number)
                            panel:SizeToContents()

                        end

                        
                    end

                end

            end

        end

    end


end



