ENT.Type = "anim";
ENT.Author = "Ross Cattero";
ENT.PrintName = "TV";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = '[TV plugin] Entities'

function ENT:SetupDataTables()
    -- Is TV is turned on or not;
    self:NetworkVar("Bool", 0, "Turned")
    -- Current channel;
    self:NetworkVar("Int", 0, "Channel")
    -- Sets owner character ID to the TV;
    self:NetworkVar("Int", 1, "OwnerID")
end;

function ENT:FindButton(client, index)
	client = client or (CLIENT and LocalPlayer())

    local button = index and self.buttons and self.buttons[index]

    local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
    local trace = util.TraceLine(data)
    local hitPos = trace.HitPos

	if (button and hitPos) then
        local distance = self:GetPos() + button.forward * self:GetForward() + button.right * self:GetRight() + button.up * self:GetUp()      
        return distance:DistToSqr(hitPos) < 0.5 and index;
    else
        for index in ipairs( self.buttons ) do
            local button = self.buttons[index]
            local distance = self:GetPos() + button.forward * self:GetForward() + button.right * self:GetRight() + button.up * self:GetUp();

            if distance:DistToSqr(hitPos) < 0.5 then
                return index;
            end;
        end;
	end
end

function ENT:Initialize()
    self:RegisterButtons()
end;

--- Register buttons for clientside.
function ENT:RegisterButtons()
    self.buttons = {};

    -- Turn on/off button;
    self.buttons[1] = {
        forward = 0,
        right = 38.75,
        up = -5.3,
        color = Color(100, 200, 100),
    }

    -- Previous channel;
    self.buttons[2] = {
        forward = 0,
        right = 38.75,
        up = -6.8,
        color = Color(100, 100, 255),
        CanWork = function()
            return self:GetTurned()
        end,
    }

    -- Next channel;
    self.buttons[3] = {
        forward = 0,
        right = 38.75,
        up = -9.7,
        color = Color(100, 100, 255),
        CanWork = function()
            return self:GetTurned()
        end,
    }
end;