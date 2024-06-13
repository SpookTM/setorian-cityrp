function Setorian.Crypto.Core.GetTokenData(token, callback)
	http.Fetch("https://data.messari.io/api/v1/assets/"..string.lower(token).."/metrics", function(body, len, headers, code)
		if not body then return end
		local data = util.JSONToTable(body)
		if (not data) or (not data.data) then return end

		callback(data.data)
	end)
end

function Setorian.Crypto.Core.RefreshAllTokenData()
	for k, v in ipairs(Setorian.Crypto.Config.Tokens) do
		Setorian.Crypto.Core.GetTokenData(v, function(data)
			Setorian.Crypto.Tokens[v] = {
				name = data.name,
				slug = data.symbol,
				price = data.market_data.price_usd
			}
		end)
	end
end