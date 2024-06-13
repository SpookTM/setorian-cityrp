-- All the supported tokens
-- You can find a list of tokens here: https://data.messari.io/api/v1/assets?fields=id,slug,symbol,metrics/market_data/price_usd
Setorian.Crypto.Config.Tokens = {
	"BTC",
	"ADA",
	"ETH",
	"XRP"
}

-- How often (in seconds) should the crypto price be refreshed? Doing this too quickly will get the server rate limited
-- with the data
Setorian.Crypto.Config.RefreshSpeed = 60 * 5 -- 5 minutes

-- Check if the player can afford something
Setorian.Crypto.Config.CanAfford = function(ply, amount)
	return ply:canAfford(amount)
end
-- Modify the money
Setorian.Crypto.Config.AddMoney = function(ply, amount)
	-- Add money
	if amount > 0 then
		ply:addMoney(amount)

	-- Take money
	else
		ply:addMoney(amount)

	end
end