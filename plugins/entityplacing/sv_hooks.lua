
local PLUGIN = PLUGIN

util.AddNetworkString("CreateFurniture")

net.Receive("CreateFurniture", function(len, client)
	local model = net.ReadString()
	local pos = net.ReadVector()
	local ang = net.ReadAngle()
	local bCantPlace = net.ReadBool()

	if (client.ixNextConstruction or 0) > CurTime() then
		client:Notify("You must wait a moment before placing another object!")
		return
	end

	if !client:GetLocalVar("furniture", false) then
		client:Notify("You do not have an object equipped to place!")
		return
	end

	if bCantPlace or (pos:Distance(client:GetPos()) > 300) then
		client:Notify("You cannot place furniture that far away!")
		return
	end

	if model:lower() != client:GetLocalVar("furniture", "")["model"]:lower() then
		client:Notify("Great, you fucked up placing the furniture and bugged yourself somehow. Tell an admin or something.")
		return
	end

	local furniture = client:GetLocalVar("furniture")

	if client:GetActiveWeapon() and (client:GetActiveWeapon():GetClass() == "ix_building") and (client:GetLocalVar("furniture", "")["model"]:lower() == model:lower()) then
		local ent = ents.Create( furniture["class"] or "prop_physics" )

		if !furniture["class"] then
			ent:SetModel( model )
		end

		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:Spawn()
	
		ent:SetSolid( SOLID_VPHYSICS )
		ent:SetMoveType( MOVETYPE_VPHYSICS )
		ent:SetNotSolid( false )
		ent:SetNWBool("constructed", true)
		ent:SetNWInt("owner", client:GetCharacter():GetID())
		ent:SetNWString("item", furniture["item"])

		local physObject = ent:GetPhysicsObject( )
		
		if ( IsValid( physObject ) ) then
			physObject:EnableMotion( false )
			physObject:Wake( )
		end

		local character = client:GetCharacter()
		local item = "object"

		if character then
			local inventory = character:GetInventory()

			for k, v in pairs(inventory:GetItems()) do
				if (v.entityclass and furniture["class"] and (v.entityclass:lower() == furniture["class"]:lower())) or (v.model:lower() == model:lower()) then
					item = v:GetName()

					if v.OnDeploy then
						v:OnDeploy(client, ent)
					end
					
					v:Remove()
					break
				end
			end
		end

		-- * Fix for item entity;
		if furniture then
			local itemEntity = furniture.item_entity;
			if itemEntity and itemEntity ~= NULL then
				local _item = itemEntity:GetItemTable();

				if _item and _item.OnDeploy then
					_item:OnDeploy(client, ent)
				end;

				itemEntity:Remove();
			end;
		end;

		client:SetLocalVar("furniture")
		client:StripWeapon("ix_building")

		client:Notify("You place the " .. item .. ".")

		client.ixNextConstruction = CurTime() + 2
	end
end)

function PLUGIN:PlayerUse(client, entity)
    -- Check if the Ctrl key (IN_DUCK) is being pressed along with the Use key
    if client:KeyDown(IN_DUCK) then
        if (entity:GetClass() == "prop_physics" and !client:GetLocalVar("furniture", nil) and (entity:GetNWString("owner", nil) == client:GetCharacter():GetID()) and ((client.ixNextPickup or 0) < CurTime())) then
            
            local character = client:GetCharacter()
            local item = ix.item.Get(entity:GetNWString("item", false))

            if item then
                local inventory = character:GetInventory()

                if inventory:FindEmptySlot(item.width, item.height) then
                    inventory:Add(item.uniqueID)
                else
                    ix.item.Spawn(item.uniqueID, client:GetPos())
                end
            end
            
            client:SetLocalVar("furniture", {
                item = item.uniqueID,
                model = entity:GetModel():lower()
            })
            entity:Remove()
            client:Give("ix_building")
            client:SelectWeapon("ix_building")

            client:Notify("You pick up the " .. item:GetName() .. ".")

            client.ixNextPickup = CurTime() + 1
        end
    end
end


ix.entityplacing = ix.entityplacing or {};
-- list of entity classes to ignore because we already have a way of saving them
-- beds are here because they have their own saving hook
-- * Edited by Ross to make it global.
ix.entityplacing.ignore = ix.entityplacing.ignore or {}
ix.entityplacing.ignore["ix_bed"] = true;

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.GetAll()) do
		if v:GetNWBool("constructed", false) and not ix.entityplacing.ignore[v:GetClass()] then
			data[#data + 1] = {
				v:GetPos(),
				v:GetAngles(),
				v:GetNWBool("constructed", false),
				v:GetModel(),
				v:GetNWInt("owner", nil),
				v:GetClass(),
				v:GetNWString("item", false)
			}
		end
	end

	ix.data.Set("construction", data)
end
	
function PLUGIN:LoadData()
	for _, v in ipairs(ix.data.Get("construction") or {}) do
		local construction = ents.Create(v[6] or "prop_physics")

		construction:SetModel(v[4])
		construction:SetPos(v[1])
		construction:SetAngles(v[2])
		construction:Spawn()
		construction:SetNWBool("constructed", v[3])
		construction:SetNWInt("owner", v[5])
		construction:SetNWString("item", v[7])
		construction:SetSolid( SOLID_VPHYSICS )
		construction:SetMoveType( MOVETYPE_VPHYSICS )
		construction:SetNotSolid( false )

		local physObject = construction:GetPhysicsObject( )
		
		if ( IsValid( physObject ) ) then
			physObject:EnableMotion( false )
			physObject:Wake( )
		end
	end
end

function PLUGIN:PlayerDeath(client)
	client:SetLocalVar("furniture")
end

function PLUGIN:PlayerSwitchWeapon(client, oldweapon, newweapon)
	local character = client:GetCharacter()

	if character and IsValid(oldweapon) then
		if oldweapon:GetClass() == "ix_building" then
			client:SetLocalVar("furniture")

			-- im going to hurl
			timer.Simple(0.01, function()
				if IsValid(client) and IsValid(oldweapon) then
					client:StripWeapon("ix_building")
				end
			end)

		end
	end
end

