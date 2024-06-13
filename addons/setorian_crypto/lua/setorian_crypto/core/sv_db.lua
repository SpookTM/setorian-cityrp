function Setorian.Crypto.Database.Start()
	-- Create the database
	if not sql.TableExists("crypto_wallet") then
		sql.Query([[
CREATE TABLE crypto_wallet(
	user_id VARCHAR(128) PRIMARY KEY,
	wallet REAL,
	address VARCHAR(64),
	holding INT(11),
	created INT(11),
	UNIQUE(`user_id`,`wallet`)
);
]])
	end
end
hook.Add("Initialize", "Setorian:Crypto:Database", Setorian.Crypto.Database.Start)

function Setorian.Crypto.Database.GetByAddress(address)
	return sql.Query(string.format("SELECT * FROM crypto_wallet WHERE address = '%s';", sql.SQLStr(address, true)))
end

function Setorian.Crypto.Database.RegisterWallet(plyID, crypto, address)
	sql.Query(string.format("INSERT INTO crypto_wallet VALUES('%s', '%s', '%s', 0, %i);",
		plyID,
		sql.SQLStr(crypto, true),
		sql.SQLStr(address, true),
		os.time()
	))
end

function Setorian.Crypto.Database.AddToWallet(address, amount)
	sql.Query(string.format("UPDATE crypto_wallet SET holding = holding + %f WHERE address='%s';",
		amount,
		sql.SQLStr(address, true)
	))
end


function Setorian.Crypto.Database.TakeFromWallet(address, amount)
	sql.Query(string.format("UPDATE crypto_wallet SET holding = holding - %f WHERE address='%s';",
		amount,
		sql.SQLStr(address, true)
	))
end

function Setorian.Crypto.Database.GetPlayer(plyID)
	return sql.Query(string.format("SELECT * FROM crypto_wallet WHERE user_id = '%s';", sql.SQLStr(plyID, true)))
end