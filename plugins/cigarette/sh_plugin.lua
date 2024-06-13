local PLUGIN = PLUGIN
PLUGIN.name = "Cigarettes"
PLUGIN.author = "JohnyReaper"
PLUGIN.desc = "Let's smoke."

ALWAYS_RAISED["weapon_ciga"] = true
ALWAYS_RAISED["weapon_ciga_cheap"] = true
ALWAYS_RAISED["weapon_ciga_blat"] = true

function PLUGIN:PlayerLoadedCharacter(client, newChar, prevChar)

    if (prevChar) then
        if (prevChar.HasCig) then

            if (timer.Exists("ligcig_"..prevChar:GetID())) then
                timer.Remove( "ligcig_"..prevChar:GetID() )
            end

            prevChar.HasCig = false

        end
    end

end