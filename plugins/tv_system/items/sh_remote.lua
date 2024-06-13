
ITEM.name = "TV remote"
ITEM.model = Model("models/freeman/remotelyinteresting.mdl")
ITEM.description = "Remote for controlling the TV."
ITEM.category = "TV"
ITEM.width = 1
ITEM.height = 1
ITEM.noBusiness = true

--- Checks if player can see and use TV;
--- @param owner table
--- @param tv table
--- @return boolean, string
local function CanSeeTV( id, owner, tv )
    if tv and tv:GetClass() == "ent_tv" then
        if owner:GetPos():DistToSqr( tv:GetPos() ) > 124000 then
            return false, "You're too far!"
        end;
            
        if not ( id and tonumber(tv.tvID) == tonumber(id) ) then
            return false, "This remote is not for this TV!"
        end;

        return true, "";
    end;

    return false, "You need to look on TV!";
end

--- Use remotely TV buttons;
--- @param owner table
--- @param tv table
--- @param buttonID number
local function UseTV( id, owner, tv, buttonID )
    local canSee, reason = CanSeeTV(id, owner, tv)
    if canSee then
        tv.buttons[ buttonID ].OnUse( tv )
    else
        owner:Notify( reason )
    end;
end;

ITEM.functions.Turn = {
    name = "Toggle TV",
    tip = "Toggle TV on/off",
	OnRun = function(item)
        local owner = item.player;
        local trace = owner:GetEyeTraceNoCursor();
        local entity = trace.Entity;

        UseTV( item:GetData("TVID"), owner, entity, 1 )

		return false;
	end
}

ITEM.functions.NextChannel = {
    name = "Next channel",
    tip = "Toggle TV to the next channel.",
	OnRun = function(item)
        local owner = item.player;
        local trace = owner:GetEyeTraceNoCursor();
        local entity = trace.Entity;

        UseTV( item:GetData("TVID"), owner, entity, 2 )

		return false
	end
}

ITEM.functions.PreviousChannel = {
    name = "Previous channel",
    tip = "Toggle TV to the previous channel.",
	OnRun = function(item)
        local owner = item.player;
        local trace = owner:GetEyeTraceNoCursor();
        local entity = trace.Entity;

        UseTV( item:GetData("TVID"), owner, entity, 3 )

		return false
	end
}

ITEM.functions.Remake = {
    name = "[ADMIN] Re-setup",
    tip = "Re-setup a remote to the traced TV.",
    OnRun = function( item )
        local owner = item.player;
        local trace = owner:GetEyeTraceNoCursor();
        local entity = trace.Entity;

        if entity and entity:GetClass() == "ent_tv" then
            item:SetData("TVID", entity.tvID);
            owner:Notify("This remote is belongs to the targeted TV now.")
        else
            owner:Notify("You need to look on the TV!")
        end;

        return false;
    end,
    CanRun = function( item )
        return item.owner:IsAdmin() or item.owner:IsSuperAdmin();
    end,
}