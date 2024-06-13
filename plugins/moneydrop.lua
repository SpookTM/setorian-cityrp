-- sv_deathmoney.lua
local PLUGIN = PLUGIN

-- Set the percentage of money to be deducted upon death
local deathMoneyDeductionPercent = 10 -- 10% for this example

-- Function to handle the player death event
function PLUGIN:PlayerDeath(victim, inflictor, attacker)
    if not IsValid(victim) or not victim:IsPlayer() then return end

    -- Get the player's current money
    local currentMoney = victim:GetCharacter():GetMoney()

    -- Calculate the deduction
    local deduction = math.floor(currentMoney * (deathMoneyDeductionPercent / 100))

    -- Deduct the money
    victim:GetCharacter():SetMoney(currentMoney - deduction)

    -- Optionally notify the player
    victim:Notify("You have lost $" .. deduction .. " of your money due to death.")
end
