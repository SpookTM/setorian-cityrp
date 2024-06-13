local PLUGIN = PLUGIN

PLUGIN.name = "Keys System"
PLUGIN.author = "BullyHunter"
PLUGIN.description = "Keys required for certain properties"

PLUGIN.PropertiesCategories = {
	"Houses",
	"Warehouses",
	"Apartments",
	"Rooms",
	"Commercial Buildings",
	"Offices",
	"Storage Units",
}

ix.util.Include("core/sv_core.lua", "server")
ix.util.Include("core/cl_core.lua", "client")
ix.util.Include("cl_menu.lua", "client")

ix.command.Add("charGiveKey", {
	description = "Create a key for a property.",
	superAdminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.string,
	},
	OnRun = function(self, client, target, item)
		local uniqueID = item

        local tr = client:GetEyeTrace()
        if not IsValid(tr.Entity) or not tr.Entity:IsDoor() or not tr.Entity.KeyRequired then
            return "This door doesn't require a key!"
        end

        print(item)

		local bSuccess, error = target:GetInventory():Add("housekey", 1, {
            ["PropertyID"] = tr.Entity.KeyRequired,
            ["HouseName"] = item
        })

		if (bSuccess) then
			target:GetPlayer():NotifyLocalized("itemCreated")

			if (target != client:GetCharacter()) then
				return "@itemCreated"
			end
		else
			return "@" .. tostring(error)
		end
	end
})