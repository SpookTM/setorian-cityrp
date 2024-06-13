PLUGIN.name = "Restrict Business Menu"
PLUGIN.author = "_HappyGoLucky"
PLUGIN.description = "Allows you to restrict or disable the business menu."

--Add FACTION.business = true to each faction you want to have access to the business menu if you have the below config enabled.

ix.config.Add("restrictBusinessToFactions", false, "Should the business menu be restricted to factions you have designated in the faction file with 'FACTION.business = true'?", nil, {
    category = "server"
})

ix.config.Add("showBusinessMenu", false, "Should the business menu show up?", nil, {
    category = "server"
})

function PLUGIN:CanPlayerUseBusiness(client)
    if (ix.config.Get("showBusinessMenu") and ix.config.Get("restrictBusinessToFactions")) then
        return ix.faction.Get(client:Team()).business or false
    end

    return ix.config.Get("showBusinessMenu")
end

if (CLIENT) then
    function PLUGIN:BuildBusinessMenu()
        if (ix.config.Get("showBusinessMenu") and ix.config.Get("restrictBusinessToFactions")) then
            return ix.faction.Get(LocalPlayer():Team()).business or false
        end

        return ix.config.Get("showBusinessMenu")
    end
end