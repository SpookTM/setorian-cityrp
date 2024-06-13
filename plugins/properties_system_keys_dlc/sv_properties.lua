if (CLIENT) then return end

local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("keys") or false

if (!PLUGIN) then return end

timer.Create("PropertiesAutoExpire", 60, 0, function()
	print("[Properties] Rent expire checking")
	local howManyExpired = 0
	PLUGIN:GetAllDoorData(function(data)

		for k,v in ipairs(data) do

			if (tostring(v.is_rentable) == "0") and tostring(v.rent_status) == "0" then continue end
			if (tostring(v.owner) != '0') and (v.rent_status == "0") then continue end

			if (tostring(v.tenant) == '0') then continue end

			-- print(v.name, v.tenant_name)
			-- print(v.renttime)
			-- print(tonumber(v.renttime))

			local ExpireTime = os.time() + tonumber(v.renttime)

			-- print(os.time(), ExpireTime)

			local tenandID = tonumber(v.tenant)
			local char = ix.char.loaded[tenandID]
			local ply

			if (char) then
				ply = ix.char.loaded[tenandID]:GetPlayer()
			end

			-- if (ply:GetCharacter():GetID() != tenandID) then continue end

			if (os.time() == ExpireTime) or ((char) and char:GetMoney() < tonumber(v.price_rent)) then

				local reason = ""

				if (char) and (ply) then
					if (char:GetMoney() < tonumber(v.price_rent)) then
						reason = "You don't have enough money to pay your next rent."
					elseif (os.time() == ExpireTime) then
						reason = "The rental time has expired."
					end
				
					if (ply:GetCharacter() and ply:GetCharacter():GetID() == tenandID) then
						ply:Notify("You lose access to "..v.name.." property! "..reason)
					end

				end
				
				howManyExpired = howManyExpired + 1

				PLUGIN:AssignTenant(v.name,"0","",0,game.GetMap())

				if (char) and (ply) then
					local inv = char:GetInventory()

					local houseKey = inv:HasItem("housekey",{
			            ["PropertyID"] = v.id,
			            ["HouseName"] = v.name,
			            ["IsTemp"] = true,
		        	})

			     	if (houseKey) then
			     		houseKey:Remove()
			     	end
			    end

				local EntIds = util.JSONToTable(v.entities)

				local tEntities = {}
				for k, v in ipairs(EntIds) do
	                local Entity = ents.GetMapCreatedEntity(v)
	                if not IsValid(Entity) then
	                    goto skip
	                end 
	                table.insert(tEntities, Entity)
	                ::skip::
	            end

				for i, j in pairs(tEntities) do
					if not IsValid(j) then continue end
					local partner = j:GetDoorPartner()

					if (IsValid(partner)) then
						partner:Fire("unlock")
					end

					j:Fire("unlock")
				end

			end

			if (tonumber(v.renttime) > 0) then

				local newTime = tonumber(v.renttime) - 1

				print("[Properties] "..v.name.." Time: "..v.renttime.." -> "..newTime)

				PLUGIN:UpdateRentTime(v.name, newTime, game.GetMap())

				if (v.renttime % 60 == 0) then 

					if (!char) then continue end
					if (!ply) then continue end

					char:SetMoney( math.max(0, char:GetMoney() - tonumber(v.price_rent)) )

					if (ply:GetCharacter() and ply:GetCharacter():GetID() == tenandID) then
						ply:Notify("Charged "..ix.currency.Get(tonumber(v.price_rent)).." for property " ..v.name)
					end

					if (!v.owner) or (tostring(v.owner) != '0') then
						PLUGIN:UpdateCollectMoney(v.name, tonumber(v.rent_collect) + tonumber(v.price_rent), game.GetMap())
					end

				end

			end

		end

	end)
	print("[Properties] "..howManyExpired.." properties expired")
	print("[Properties] Rent expire checked")
end)


netstream.Hook("ixPropeties_Buy", function(ply, sName)
	local char = ply:GetCharacter()

	local formatTime = "%m.%d.%Y"

	PLUGIN:GetAllDoorData(function(data)
		
		for k,v in ipairs(data) do

			if (v.name == sName) then
				-- PrintTable(data[k])

				if (!v.owner) or (tostring(v.owner) != '0') then
					ply:NotifyLocalized("Someone has already bought this property.")
					return
				end

				if (char:GetMoney() < tonumber(v.price)) then
					ply:NotifyLocalized("You can't afford to buy this property. You need "..ix.currency.Get(v.price)..".")
					return false
				end

				if (char:GetData("OwnedProperties",0) >= ix.config.Get("PropertyOwnMax", 3)) then
					ply:NotifyLocalized("You have reached your property purchase limit")
					return false
				end

				char:SetMoney(char:GetMoney() - tonumber(v.price))

				local bSuccess, error = char:GetInventory():Add("housekey", 1, {
		            ["PropertyID"] = v.id,
		            ["HouseName"] = v.name,
		            ["NoDrop"] = true
	        	})

	        	local bSuccess, error = char:GetInventory():Add("deed_document", 1, {
		            ["PropertyType"] = v.category,
		            ["PropertyName"] = v.name,
		            ["OwnerName"] = char:GetName(),
		            ["purchaseDate"] = ix.date.GetFormatted(formatTime),
		     	})

		     	char:SetData("OwnedProperties", char:GetData("OwnedProperties",0) + 1)

	        	PLUGIN:AssignOwner(v.name,char:GetID(),char:GetName(),game.GetMap())
				ply:NotifyLocalized("You purchased "..v.name.." property for "..ix.currency.Get(v.price)..".")

				break
			end

		end

	end)
	-- print("==========NEW===========")
	-- PLUGIN:GetAllDoorData(function(data)
	-- 	PrintTable(data)
	-- end)

end)


netstream.Hook("ixPropeties_Rent", function(ply, sName, rentTime)
	local char = ply:GetCharacter()

	PLUGIN:GetAllDoorData(function(data)
		
		for k,v in ipairs(data) do

			if (v.name == sName) then
				-- PrintTable(data[k])

				if (tonumber(v.owner) == char:GetID()) then
					ply:NotifyLocalized("You cannot rent your own property.")
					return false
				end

				if (!v.tenant) or (tostring(v.tenant) != '0') then
					ply:NotifyLocalized("Someone has already rented this property.")
					return false
				end

				if (char:GetMoney() < tonumber(v.price_rent)) then
					ply:NotifyLocalized("You can't afford to buy this property. You need "..ix.currency.Get(v.price_rent)..".")
					return false
				end

				// In minutes
				local ExpireTime = tonumber(rentTime) * 3600

				// No need this. Player will by charged in the next expire check
				-- char:SetMoney(char:GetMoney() - tonumber(v.price_rent))

				local bSuccess, error = char:GetInventory():Add("housekey", 1, {
		            ["PropertyID"] = v.id,
		            ["HouseName"] = v.name,
		            ["IsTemp"] = true,
		            ["NoDrop"] = true
	        	})


				PLUGIN:AssignTenant(v.name,char:GetID(),char:GetName(), ExpireTime,game.GetMap())
				ply:NotifyLocalized("You rented "..v.name.." property for ".. tonumber(rentTime) .." hour(s).")

	        end

	    end

	end)

end)


netstream.Hook("ixPropeties_Sell", function(ply, sName)
	local char = ply:GetCharacter()
	local inv = char:GetInventory()

	PLUGIN:GetAllDoorData(function(data)
		
		for k,v in ipairs(data) do

			if (v.name == sName) then

				if (tonumber(v.owner) != char:GetID()) then
					ply:NotifyLocalized("You are not a owner of this property.")
					return
				end

				local houseKey = inv:HasItem("housekey",{
		            ["PropertyID"] = v.id,
		            ["HouseName"] = v.name
	        	})

		     	if (houseKey) then
		     		houseKey:Remove()
		     	end

		     	local deed = inv:HasItem("deed_document",{
		            ["PropertyType"] = v.category,
		            ["PropertyName"] = v.name,
		     	})

		     	if (deed) then
		     		deed:Remove()
		     	end

		     	PLUGIN:AssignOwner(v.name,"0","",game.GetMap())
				char:SetMoney(char:GetMoney() + (v.price * 0.5))
				char:SetData("OwnedProperties", math.max( 0, char:GetData("OwnedProperties",0) - 1 ))


				ply:NotifyLocalized("You sold "..v.name.." property for "..ix.currency.Get(v.price * 0.75)..".")

				if (v.rent_collect != "0") or (tonumber(v.rent_collect) > 0) then
					char:SetMoney(char:GetMoney() + v.rent_collect)
					ply:NotifyLocalized("And you get uncollected money ["..ix.currency.Get(v.rent_collect).."].")
					PLUGIN:UpdateCollectMoney(v.name, 0, game.GetMap())
				end

				break
			end
		end

	end)

	-- print("==========NEW===========")
	-- PLUGIN:GetAllDoorData(function(data)
	-- 	PrintTable(data)
	-- end)

end)

netstream.Hook("ixPropeties_MakeRentable", function(ply, sName, Rentable)
	local char = ply:GetCharacter()

	PLUGIN:GetAllDoorData(function(data)
		
		for k,v in ipairs(data) do

			if (v.name == sName) then

				if (tonumber(v.owner) != char:GetID()) then
					ply:NotifyLocalized("You are not a owner of this property.")
					return
				end

				local bRent = (Rentable and 1) or 0

				print(Rentable, bRent)

				if !isnumber(tonumber(v.price_rent)) then
					PLUGIN:UpdateRentPrice(v.name,10,game.GetMap())
				end

				PLUGIN:MakeRentable(v.name,bRent,game.GetMap())
				if (Rentable) then
					ply:NotifyLocalized("Property " ..sName .. " is rentable now")
				else
					ply:NotifyLocalized("Property " ..sName .. " is not rentable now")
				end

				break
			end
		end
	end)
end)


netstream.Hook("ixPropeties_SetRentPrice", function(ply, sName, Rentprice)
	local char = ply:GetCharacter()

	PLUGIN:GetAllDoorData(function(data)
		
		for k,v in ipairs(data) do

			if (v.name == sName) then

				if (tonumber(v.owner) != char:GetID()) then
					ply:NotifyLocalized("You are not a owner of this property.")
					return
				end

				PLUGIN:UpdateRentPrice(v.name,Rentprice,game.GetMap())
				ply:NotifyLocalized("You set "..Rentprice.." for rent.")

				break
			end
		end
	end)
end)

netstream.Hook("ixPropeties_Collect", function(ply, sName)
	local char = ply:GetCharacter()

	PLUGIN:GetAllDoorData(function(data)
		
		for k,v in ipairs(data) do

			if (v.name == sName) then

				if (v.rent_collect != 0) or (v.rent_collect > 0) then
					char:SetMoney(char:GetMoney() + v.rent_collect)
					ply:NotifyLocalized("You've collected "..ix.currency.Get(v.rent_collect).." from rent.")
					PLUGIN:UpdateCollectMoney(v.name, 0, game.GetMap())
				end

			break
			end
		end
	end)
end)			

function PLUGIN:AssignOwner(sName, charID, charName, sMap)
    local select = mysql:Select("ix_properties")
    	select:Select("id")
        select:Where("name", sName)
        select:Where("map", sMap)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
            	local id = data[1].id
                local insert = mysql:Update("ix_properties")
                	insert:Where("id", id)
                    insert:Update("owner", charID)
                    insert:Update("owner_name", charName)
                    insert:Update("rent_collect", 0)
                insert:Execute()
                print("[Properties] New owner ["..charID.."] for ["..sName.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:AssignTenant(sName, charID, charName, rentTime, sMap)
    local select = mysql:Select("ix_properties")
    	select:Select("id")
        select:Where("name", sName)
        select:Where("map", sMap)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
            	local id = data[1].id
                local insert = mysql:Update("ix_properties")
                	insert:Where("id", id)
                    insert:Update("tenant", charID)
                    insert:Update("tenant_name", charName)
                    insert:Update("renttime", rentTime)
                insert:Execute()
                print("[Properties] New tenant ["..charID.."] for ["..sName.."]. Expire: ["..rentTime.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:UpdateRentTime(sName, rentTime, sMap)
    local select = mysql:Select("ix_properties")
    	select:Select("id")
        select:Where("name", sName)
        select:Where("map", sMap)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
            	local id = data[1].id
                local insert = mysql:Update("ix_properties")
                	insert:Where("id", id)
                    insert:Update("renttime", rentTime)
                insert:Execute()
                print("[Properties] Updated time ["..rentTime.."] for ["..sName.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:UpdateRentPrice(sName, rentPrice, sMap)
    local select = mysql:Select("ix_properties")
    	select:Select("id")
        select:Where("name", sName)
        select:Where("map", sMap)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
            	local id = data[1].id
                local insert = mysql:Update("ix_properties")
                	insert:Where("id", id)
                    insert:Update("price_rent", tonumber(rentPrice))
                insert:Execute()
                print("[Properties] New rent price ["..rentPrice.."] for ["..sName.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:MakeRentable(sName, Rentable, sMap)
    local select = mysql:Select("ix_properties")
    	select:Select("id")
        select:Where("name", sName)
        select:Where("map", sMap)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
            	local id = data[1].id
                local insert = mysql:Update("ix_properties")
                	insert:Where("id", id)
                    insert:Update("rent_status", tonumber(Rentable))
                insert:Execute()
                -- print("New rent status ["..tonumber(Rentable).."] for ["..sName.."]")
            end
        end)
    select:Execute()
end

function PLUGIN:UpdateCollectMoney(sName, rentCollect, sMap)
    local select = mysql:Select("ix_properties")
    	select:Select("id")
        select:Where("name", sName)
        select:Where("map", sMap)
        select:Limit(1)
        select:Callback(function(data)
            if istable(data) and #data > 0 then
            	local id = data[1].id
                local insert = mysql:Update("ix_properties")
                	insert:Where("id", id)
                    insert:Update("rent_collect", tonumber(rentCollect))
                insert:Execute()
                print("[Properties] New rent collect value ["..rentCollect.."] for ["..sName.."]")
            end
        end)
    select:Execute()
end

-- local PLUGIN = PLUGIN

-- function PLUGIN:CharacterLoaded(char)
-- 	print("Characted Loaded:")
-- 	print(char:GetLastJoinTime())
-- end



