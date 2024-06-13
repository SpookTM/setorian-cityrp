util.AddNetworkString("Setorian:Crypto:App:MyWallets")
util.AddNetworkString("Setorian:Crypto:App:CreateWallet")
util.AddNetworkString("Setorian:Crypto:App:Purchase")

hook.Add("PlayerInitialSpawn", "Setorian:Crypto:LoadPlayer", function(ply)
	Setorian.Crypto.Users[ply:SteamID64()] = {}

	local wallets = Setorian.Crypto.Database.GetPlayer(ply:SteamID64())

	for k, v in pairs(wallets or {}) do
		Setorian.Crypto.Users[ply:SteamID64()][v.wallet] = {
			address = v.address,
			amount = tonumber(v.holding)
		}
	end
end)


local chars = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","1","2","3","4","5","6","7","8","9","0"}
function Setorian.Crypto.Core.GenerateAddress()
	local address

	while not address do
		address = ""

		for i=1, 64 do
		    address = address..chars[math.random(#chars)] 
		end

		if Setorian.Crypto.Database.GetByAddress(address) then
			address = nil
		end
	end

	return address
end

function Setorian.Crypto.Core.CreateWallet(ply, crypto)
	if Setorian.Crypto.Users[ply:SteamID64()] and Setorian.Crypto.Users[ply:SteamID64()][crypto] then
		return Setorian.Crypto.Users[ply:SteamID64()][crypto]
	end

	local address = Setorian.Crypto.Core.GenerateAddress()

	-- Register the wallet to the database
	Setorian.Crypto.Database.RegisterWallet(ply:SteamID64(), crypto, address)

	-- Ensure the table is created
	Setorian.Crypto.Users[ply:SteamID64()] = Setorian.Crypto.Users[ply:SteamID64()] or {}

	-- Add the new wallet to the user
	Setorian.Crypto.Users[ply:SteamID64()][crypto] = {
		address = address,
		amount = 0
	}
end

function Setorian.Crypto.Core.AddToWallet(ply, crypto, amount)
	if (not Setorian.Crypto.Users[ply:SteamID64()]) or (not Setorian.Crypto.Users[ply:SteamID64()][crypto]) then return end
	local wallet = Setorian.Crypto.Users[ply:SteamID64()][crypto]

	Setorian.Crypto.Users[ply:SteamID64()][crypto].amount = wallet.amount + amount
	Setorian.Crypto.Database.AddToWallet(wallet.address, amount)
end

function Setorian.Crypto.Core.TakeFromWallet(ply, crypto, amount)
	if (not Setorian.Crypto.Users[ply:SteamID64()]) or (not Setorian.Crypto.Users[ply:SteamID64()][crypto]) then return end
	local wallet = Setorian.Crypto.Users[ply:SteamID64()][crypto]

	Setorian.Crypto.Users[ply:SteamID64()][crypto].amount = wallet.amount - amount
	Setorian.Crypto.Database.TakeFromWallet(wallet.address, amount)
end

function Setorian.Crypto.Core.Purchase(ply, crypto, amount)
	if (not Setorian.Crypto.Users[ply:SteamID64()]) or (not Setorian.Crypto.Users[ply:SteamID64()][crypto]) then return end

	amount = math.Round(amount, 4)

	if amount <= 0 then return end 

	local cryptoData = Setorian.Crypto.Tokens[crypto]
	if not cryptoData then return end

	local cost = cryptoData.price * amount

	if not Setorian.Crypto.Config.CanAfford(ply, cost) then return end

	Setorian.Crypto.Config.AddMoney(ply, -cost)
	Setorian.Crypto.Core.AddToWallet(ply, crypto, amount)
end

function Setorian.Crypto.Core.Sell(ply, crypto, amount)
	if (not Setorian.Crypto.Users[ply:SteamID64()]) or (not Setorian.Crypto.Users[ply:SteamID64()][crypto]) then return end

	amount = math.Round(amount, 4)
	if amount <= 0 then return end 

	local wallet = Setorian.Crypto.Users[ply:SteamID64()][crypto]
	-- Don't have enough
	if wallet.amount < amount then return end

	local cryptoData = Setorian.Crypto.Tokens[crypto]
	if not cryptoData then return end

	local value = cryptoData.price * amount

	Setorian.Crypto.Config.AddMoney(ply, value)
	Setorian.Crypto.Core.TakeFromWallet(ply, crypto, amount)
end


net.Receive("Setorian:Crypto:App:MyWallets", function(_, ply)
	--
	--- Add a cooldown here
	--

	net.Start("Setorian:Crypto:App:MyWallets")
		net.WriteTable(Setorian.Crypto.Users[ply:SteamID64()] or {})
	net.Send(ply)
end)

net.Receive("Setorian:Crypto:App:CreateWallet", function(_, ply)
	--
	--- Add a cooldown here
	--
	local walletType = net.ReadString()
	if not Setorian.Crypto.Tokens[walletType] then return end

	Setorian.Crypto.Core.CreateWallet(ply, walletType)
end)


net.Receive("Setorian:Crypto:App:Purchase", function(_, ply)
	local isBuying = net.ReadBool()
	local token = net.ReadString()
	local amount = net.ReadFloat()

	if isBuying then
		Setorian.Crypto.Core.Purchase(ply, token, amount)
	else
		Setorian.Crypto.Core.Sell(ply, token, amount)
	end
end)