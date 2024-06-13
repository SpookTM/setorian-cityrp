ITEM.name = "Analyze Case"
ITEM.model = "models/props_c17/SuitCase001a.mdl"

function ITEM:GetName()
	return self.name .. " #" .. self:GetID()
end

function ITEM:GetDescription()
	return self:GetData("fingerprints", nil) and "Containts fingerprints" or "Not containts fingerprints"
end

ITEM.functions.Compare = {
	name = "Compare Fingerprints",
	icon = "icon16/wrench.png",
	isMulti = true,
	multiOptions = function(item, client)
		local items = client:GetItems()
		local result = {}

		if (items) then
			for _, v in pairs(items) do
				if v == item then continue end
				if v:GetData("fingerprints", nil) then
					result[#result + 1] = {
						name = Format("%s (#%s)", v.name, v:GetID()),
						data = {v:GetID()}
					}
				end
			end
		end

		return result
	end,
	OnRun = function(item, data)
		local client = item.player

		local items = client:GetItems() or {}
		local target

		if (istable(data) and data[1]) then
			target = ix.item.instances[data[1]]

			if (!items[target.id]) then
				return false
			end

			if target then
				client:ConCommand("/me comparing fingerprints")

				-- client:SetAction("Comparing...", 1, function()
					local fingerprints = item:GetData("fingerprints", {})

					local match = nil

					PrintTable(fingerprints)
					PrintTable(target:GetData("fingerprints", {}))

					for k, v in pairs(target:GetData("fingerprints", {})) do
						if fingerprints[k] then
							match = true
							break
						end
					end

					client:Notify(match and "Fingerprints matching" or "Fingerprint don't matching!")
				-- end)
			end
		end

		return false
	end,
	OnCanRun = function(item)
		return not IsValid(item.entity)
	end
}

ITEM.functions.Powder = {
	name = "Powder",
	icon = "icon16/pencil.png",
	OnRun = function(item)
        local client = item.player

		local trace = client:RunAimTrace(128)
		local entity = trace.Entity
		if not entity then return false end
		if entity:IsPlayer() then return end

		client:SetAction("Powdering...", 5)
		client:DoStaredAction(entity, function()
			if IsValid(entity) and entity:GetNetVar("fingerprints", nil) then
				entity:SetNetVar("analyzed", true)
			end
		end, 5, function()
			if (IsValid(client)) then
				client:SetAction()
			end
		end)

        return false
	end
}

ITEM.functions.TakeFinger = {
	name = "Take Fingeprints",
	icon = "icon16/pencil.png",
	OnRun = function(item)
        local client = item.player

		local trace = client:RunAimTrace(128)
		local entity = trace.Entity
		if not entity then return false end

		client:SetAction("Taking fingerprints...", 2)
		client:DoStaredAction(entity, function()
			if not IsValid(entity) then return end

			if entity:IsPlayer() then
				client:ConCommand("say /me taking fingerprints from person...")
				item:SetData("fingerprints", {
					[entity:GetCharacter():GetID()] = true
				})

				PrintTable(item:GetData("fingerprints"))
			elseif entity:GetNetVar("fingerprints", nil) then
                if not entity:GetNetVar("analyzed", false) then
                    client:Notify("You should make fingerprints powder on this object first!")
                    return 
                end

				item:SetData("fingerprints", entity:GetNetVar("fingerprints"))
                client:Notify("You took some fingerprints from this object")

				PrintTable(item:GetData("fingerprints"))
			end
		end, 2, function()
			if (IsValid(client)) then
				client:SetAction()
			end
		end)

        return false
	end
}