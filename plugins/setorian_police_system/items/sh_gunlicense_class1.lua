
ITEM.name = "Gun License: Class 1"
ITEM.description = "Permits the purchase and use of pistols and light weapons."
ITEM.model = Model("models/props_lab/clipboard.mdl")
ITEM.category = "Gun Licenses"

ITEM.functions.claim = {
    name = "Claim Weapon",
	tip = "Claim weapon to use it",
	icon = "icon16/pencil_go.png",
	OnRun = function(item, data)
        local client = item.player

        if (!client:Alive()) then return false end

        local char = client:GetCharacter()

        if (!char) then return false end

        net.Start("ixPoliceSys_OpenWepUI")
        	net.WriteString("class1")
		net.Send(client)

        return false
    end,
    OnCanRun = function(item)
		return (!IsValid(item.entity))
	end
}