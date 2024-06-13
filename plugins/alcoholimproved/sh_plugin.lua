local PLUGIN = PLUGIN or {}

PLUGIN.name = "Alcohol (Improved)"
PLUGIN.author = "Winkarst#6698"
PLUGIN.description = "Adds alcohol system."
PLUGIN.schema = "Any"
PLUGIN.version = "V2.0"
PLUGIN.license = [[
    MIT License

    Copyright (c) 2023 Winkarst
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

ix.config.Add("enableAlcoholFallover", true, "Enable fall to the ground on the certain level of intoxication.", nil, {
    category = "Alcohol"
})

ix.config.Add("alcoholFallover", 5, "The level of intoxication on which player fall to the ground.", nil, {
    data = {min = 1, max = 50},
    category = "Alcohol"
})

do
    ix.char.RegisterVar("DrunkEffect", {
        field = "DrunkEffect",
        fieldType = ix.type.number,
        default = 0,
        bNoDisplay = true
    })

    ix.char.RegisterVar("DrunkEffectTime", {
        field = "DrunkEffectTime",
        fieldType = ix.type.number,
        default = 0,
        bNoDisplay = true
    })
end

ix.command.Add("AddDrunkEffect", {
    description = "Adds a drunk effect to character.",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.number,
        ix.type.number,
    },
    OnRun = function(self, client, target, amount, duration)
        target:GetPlayer():AddDrunkEffect(amount, duration)
    end
})

ix.command.Add("RemoveDrunkEffect", {
    description = "Removes drunk effect from character.",
    adminOnly = true,
    arguments = {
        ix.type.character,
    },
    OnRun = function(self, client, target)
        target:GetPlayer():RemoveDrunkEffect()
    end
})

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_meta.lua")
ix.util.Include("sv_hooks.lua")


