-- Define the GetGender function to return the gender based on the model path
function ix.anim.GetGender(model)
    local lowerModel = model:lower()

    if lowerModel:find("female") or lowerModel:find("alyx") then
        return "female"
    elseif lowerModel:find("male") then
        return "male"
    end

    return "unknown"
end

Schema.voices.Add("Human_Male", "ALMOST MADE SENSE", "That... almost made sense", "vo/npc/male01/vanswer09.wav") --test

Schema.voices.Add("Human_Female", "ALMOST MADE SENSEEEEEEE", "That... almost made sense", "vo/npc/male01/vanswer09.wav") --tes

Schema.voices.AddClass("Human_Male", function(client)
    local gender = ix.anim.GetGender(client:GetModel())

    if gender == "male" then
        return client:GetCharacter():GetData("gender", "male") == "male" and client:Team() == FACTION_CITIZEN
    else
        return false
    end
end)

Schema.voices.AddClass("Human_Female", function(client)
    local gender = ix.anim.GetGender(client:GetModel())
	local model = client:GetModel():lower()
	if model:find("models/Humans/Group01/Female_") or model:find("female") then
		return client:Team() == FACTION_CITIZEN
	end
end)

--test
-- Schema.voices.AddClass("Human_Male", function(client)
-- 	local model = client:GetModel():lower()
-- 	if model:find("models/Humans/Group01/male_") or model:find("male")  then
-- 		return client:Team() == FACTION_CITIZEN 
-- 	end
-- end)