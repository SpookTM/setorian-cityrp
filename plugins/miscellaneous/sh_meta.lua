local meta = FindMetaTable("Player")

if (SERVER) then

    function meta:SetBlindfold(bState)

        if (bState) then
            self:SetNetVar("blindfold", true)

        else
            self:SetNetVar("blindfold")

        end

    end

end

function meta:IsBlindfold()
    return self:GetNetVar("blindfold", false)
end