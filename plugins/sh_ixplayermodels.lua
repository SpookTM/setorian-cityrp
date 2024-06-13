PLUGIN.name = "IX Player Models Fix"
PLUGIN.author = "Masco"
PLUGIN.description = "Fixes models in IX to make Player Models."

local IXPlayerModels = {
    "models/player/citizen/female_01_headless.mdl",
    "models/player/citizen/female_03_headless.mdl",
    "models/player/citizen/male_01_headless.mdl",
    "models/player/citizen/male_02_headless.mdl",
}

for _, model in ipairs(IXPlayerModels) do
    print("Setting " .. model .. " to a playermodel.")
    ix.anim.SetModelClass(model, "player")
end