
ITEM.name = "Metal file"
ITEM.description = "You can use it to get rid of the weapon serial number."
ITEM.model = Model("models/gibs/metal_gib5.mdl")

ITEM.functions.claim = {
    name = "Remove Serial Number",
	tip = "Remove serial number from weapon",
	icon = "icon16/pencil_go.png",
	OnRun = function(item, data)
        local client = item.player

        if (!client:Alive()) then return false end

        local char = client:GetCharacter()

        if (!char) then return false end

        net.Start("ixPoliceSys_OpenWepUI")
        	net.WriteString("removenumbers")
		net.Send(client)

        return false
    end,
    OnCanRun = function(item)
		return (!IsValid(item.entity))
	end
}