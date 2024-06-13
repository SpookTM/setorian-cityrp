local APP = {}

APP.name = "Coinland"
APP.icon = "setorian/crypto/app_crypto.png"

-- A very over complicated app tbh lol

local background = Color(21, 18, 28)
local subBackground = Color(30, 30, 40)
local white = Color(215, 218, 224)
local gray = Color(110, 108, 124)
local blue = Color(164, 185, 239)
function APP:Open(main, main_x, main_y, screenmode, blockcontainer)
	function main:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, background)
	end

	local container
	if blockcontainer then
		container = main:GetChildren()[2]
		container:Clear()
	else
		container = vgui.Create("DScrollPanel", main)
		container:Dock(FILL)
		container:GetVBar():SetWide(0)
		container:DockMargin(15, 40, 15, 0)
	end 

	-- Loading message
	local loadingHeader = vgui.Create("DLabel", container)
	loadingHeader:SetText(Setorian.Crypto.Translation.Loading)
	loadingHeader:SetColor(white)
	loadingHeader:SetFont("setorian_20")
	loadingHeader:SetContentAlignment(5)
	loadingHeader:Dock(TOP)
	loadingHeader:SizeToContentsY()


	-- Request the wallets
	net.Start("Setorian:Crypto:App:MyWallets")
	net.SendToServer()

	net.Receive("Setorian:Crypto:App:MyWallets", function()
		if not IsValid(container) then return end

		container:Clear()
		local wallets = net.ReadTable()
		self.MyWallets = wallets

		-- Existing wallets
		local assetsHeader = vgui.Create("DLabel", container)
		assetsHeader:SetText(Setorian.Crypto.Translation.YourAssets)
		assetsHeader:SetColor(white)
		assetsHeader:SetFont("setorian_15")
		assetsHeader:Dock(TOP)
		assetsHeader:SizeToContentsY()
			for k, v in pairs(wallets) do
				local tokenData = Setorian.Crypto.Tokens[k]

				local shell = vgui.Create("DPanel", container)
				shell:Dock(TOP)
				shell.Paint = nil
				shell:SetTall(50)
				shell:DockMargin(10, 0, 10, 10)

					local valueShell = vgui.Create("DPanel", shell)
					valueShell:Dock(RIGHT)
					valueShell.Paint = nil

					local value = vgui.Create("DLabel", valueShell)
					value:SetText("$"..string.Comma(math.Round(v.amount * tokenData.price, 2)))
					value:SetColor(white)
					value:SetFont("setorian_10")
					value:Dock(TOP)
					value:SetContentAlignment(6)
					value:SizeToContents()

					local amount = vgui.Create("DLabel", valueShell)
					amount:SetText(string.Comma(math.Round(v.amount, 4)))
					amount:SetColor(gray)
					amount:SetFont("setorian_9")
					amount:Dock(BOTTOM)
					amount:SetContentAlignment(6)
					amount:SizeToContents()

				local icon = vgui.Create("DImage", shell)
				icon:Dock(LEFT)
				icon:SetWide(shell:GetTall())
				icon:SetMaterial(Setorian.Crypto.Icons[k])
				icon:DockMargin(0, 0, 5, 0)

				local name = vgui.Create("DLabel", shell)
				name:SetText(tokenData.name)
				name:SetColor(white)
				name:SetFont("setorian_10")
				name:Dock(TOP)
				name:SizeToContents()

				local slug = vgui.Create("DLabel", shell)
				slug:SetText(tokenData.slug)
				slug:SetColor(gray)
				slug:SetFont("setorian_9")
				slug:Dock(BOTTOM)
				slug:SizeToContents()

				-- Used to mask a click
				local btn = vgui.Create("DButton", shell)
				btn.Paint = nil
				btn:SetText("")
				function btn.DoClick()
					self:OpenToken(k, main, main_x, main_y)
				end

				function shell:PerformLayout(w, h)
					valueShell:SetWide(w*0.4)
					btn:SetSize(w, h)
				end
			end

		-- Register a new wallet
		local registerHeader = vgui.Create("DLabel", container)
		registerHeader:SetText(Setorian.Crypto.Translation.RegisterWallet)
		registerHeader:SetColor(white)
		registerHeader:SetFont("setorian_15")
		registerHeader:Dock(TOP)
		registerHeader:SizeToContentsY()
			for k, v in pairs(Setorian.Crypto.Tokens) do
				if wallets[k] then continue end

				local shell = vgui.Create("DPanel", container)
				shell:Dock(TOP)
				shell.Paint = nil
				shell:SetTall(50)
				shell:DockMargin(10, 0, 10, 10)

					local valueShell = vgui.Create("DPanel", shell)
					valueShell:Dock(RIGHT)
					valueShell.Paint = nil

					local value = vgui.Create("DLabel", valueShell)
					value:SetText("$"..string.Comma(math.Round(v.price, 2)))
					value:SetColor(white)
					value:SetFont("setorian_10")
					value:Dock(FILL)
					value:SetContentAlignment(6)
					value:SizeToContents()


				local icon = vgui.Create("DImage", shell)
				icon:Dock(LEFT)
				icon:SetWide(shell:GetTall())
				icon:SetMaterial(Setorian.Crypto.Icons[k])
				icon:DockMargin(0, 0, 5, 0)

				local name = vgui.Create("DLabel", shell)
				name:SetText(v.name)
				name:SetColor(white)
				name:SetFont("setorian_10")
				name:Dock(TOP)
				name:SizeToContents()

				local slug = vgui.Create("DLabel", shell)
				slug:SetText(v.slug)
				slug:SetColor(gray)
				slug:SetFont("setorian_9")
				slug:Dock(BOTTOM)
				slug:SizeToContents()

				-- Used to mask a click
				local btn = vgui.Create("DButton", shell)
				btn.Paint = nil
				btn:SetText("")
				function btn.DoClick()
					net.Start("Setorian:Crypto:App:CreateWallet")
						net.WriteString(k)
					net.SendToServer()

					self:Open(main, main_x, main_y, screenmode, true)
				end

				function shell:PerformLayout(w, h)
					valueShell:SetWide(w*0.4)
					btn:SetSize(w, h)
				end
			end
	end)

end

function APP:OpenToken(token, main, main_x, main_y)
	local container = main:GetChildren()[2]
	container:Clear()

	local tokenData = Setorian.Crypto.Tokens[token]
	local wallet = self.MyWallets[token]

	local back = vgui.Create("DButton", container)
	back:Dock(TOP)
	back:SetText("←")
	back:SetColor(white)
	back:SetFont("setorian_15")
	back.Paint = nil
	back:SetContentAlignment(4)
	back:SetTall(30)
	function back.DoClick()
		self:Open(main, main_x, main_y, screenmode, true)
	end

	local header = vgui.Create("DLabel", container)
	header:SetText(string.format(Setorian.Crypto.Translation.TokenPrice, tokenData.name))
	header:SetColor(gray)
	header:SetFont("setorian_10")
	header:Dock(TOP)
	header:SizeToContents()

	local price = vgui.Create("DLabel", container)
	price:SetText("$"..string.Comma(math.Round(tokenData.price, 2)))
	price:SetColor(white)
	price:SetFont("setorian_13")
	price:Dock(TOP)
	price:SizeToContents()

	local myAsset = vgui.Create("DPanel", container)
	myAsset:Dock(TOP)
	myAsset:SetTall(80)
	myAsset:DockPadding(10, 10, 10, 10)
	myAsset:DockMargin(0, 10, 0, 10)
	function myAsset:Paint(w, h)
		draw.RoundedBox(10, 0, 0, w, h, subBackground)
	end

		local icon = vgui.Create("DImage", myAsset)
		icon:Dock(LEFT)
		icon:SetWide(myAsset:GetTall() - 40)
		icon:SetMaterial(Setorian.Crypto.Icons[token])
		icon:DockMargin(10, 10, 10, 10)

		local name = vgui.Create("DLabel", myAsset)
		name:SetText(tokenData.name)
		name:SetColor(white)
		name:SetFont("setorian_9")
		name:Dock(FILL)
		name:SetContentAlignment(4)
		name:SizeToContents()

			local valueShell = vgui.Create("DPanel", myAsset)
			valueShell:Dock(RIGHT)
			valueShell.Paint = nil

			local value = vgui.Create("DLabel", valueShell)
			value:SetText("$"..string.Comma(math.Round(wallet.amount * tokenData.price, 2)))
			value:SetColor(white)
			value:SetFont("setorian_10")
			value:Dock(TOP)
			value:SetContentAlignment(3)
			value:SetTall(valueShell:GetTall()*0.5)

			local amount = vgui.Create("DLabel", valueShell)
			amount:SetText(string.Comma(math.Round(wallet.amount, 4)))
			amount:SetColor(gray)
			amount:SetFont("setorian_9")
			amount:Dock(BOTTOM)
			amount:SetContentAlignment(9)
			amount:SetTall(valueShell:GetTall()*0.5)

		function myAsset:PerformLayout(w, h)
			valueShell:SetWide(w*0.4)

			value:SetTall(valueShell:GetTall()*0.5)
			amount:SetTall(valueShell:GetTall()*0.5)
		end

	local trade = vgui.Create("DButton", container)
	trade:Dock(TOP)
	trade:SetTall(50)
	trade:SetText(Setorian.Crypto.Translation.Trade)
	trade:SetColor(background)
	trade:SetFont("setorian_15")
	function trade:Paint(w, h)
		draw.RoundedBox(10, 0, 0, w, h, blue)
	end
	function trade.DoClick()
		self:CreateOverlay(main, function(parent)
			local buffer = vgui.Create("DPanel", parent)
			buffer:Dock(BOTTOM)
			buffer:DockPadding(10, 10, 10, 10)
			buffer:SetTall(main:GetTall()*0.25)
			function buffer:Paint(w, h)
				draw.RoundedBoxEx(20, 0, 0, w, h, subBackground, true, true)
			end

			local buy = vgui.Create("DButton", buffer)
			buy:SetText(string.format(Setorian.Crypto.Translation.Buy, tokenData.slug))
			buy:SetColor(white)
			buy:SetFont("setorian_13")
			buy:SetTall(25)
			buy:SizeToContentsY()
			buy:Dock(TOP)
			buy.Paint = nil
			buy:DockMargin(0, 0, 0, 10)
			function buy.DoClick()
				parent:DoClick()

				self:TradeToken(token, "buy", main, main_x, main_y)
			end

			local sell = vgui.Create("DButton", buffer)
			sell:SetText(string.format(Setorian.Crypto.Translation.Sell, tokenData.slug))
			sell:SetColor(white)
			sell:SetFont("setorian_13")
			sell:SetTall(25)
			sell:SizeToContentsY()
			sell:Dock(TOP)
			sell.Paint = nil
			function sell.DoClick()
				parent:DoClick()

				self:TradeToken(token, "sell", main, main_x, main_y)
			end

			parent:InvalidateLayout()
			function parent:PerformLayout(w, h)
				buffer:SizeToContentsY(20)
			end
		end)
	end
end

local buttonOptions = {}
for i=1, 9 do
	buttonOptions[i] = {
		i,
		function(val)
			return val..i
		end
	}
end
buttonOptions[10] = {
	"",
	function(val)
		return val
	end
}
buttonOptions[11] = {
	"0",
	function(val)
		return val.."0"
	end
}
buttonOptions[12] = {
	"←",
	function(val)
		local newval = string.sub(tostring(val), 0, #val-1)

		return (newval == "") and "0" or newval
	end
}

function APP:TradeToken(token, type, main, main_x, main_y)
	local container = main:GetChildren()[2]
	container:Clear()

	local isBuying = type == "buy"

	local modifyVal = ""

	local tokenData = Setorian.Crypto.Tokens[token]
	local wallet = self.MyWallets[token]

	local back = vgui.Create("DButton", container)
	back:Dock(TOP)
	back:SetText("←")
	back:SetColor(white)
	back:SetFont("setorian_15")
	back.Paint = nil
	back:SetContentAlignment(4)
	back:SetTall(30)
	function back.DoClick()
		self:OpenToken(token, main, main_x, main_y)
	end

	local header = vgui.Create("DLabel", container)
	header:SetText(string.format(isBuying and Setorian.Crypto.Translation.Buy or Setorian.Crypto.Translation.Sell, tokenData.name))
	header:SetColor(white)
	header:SetFont("setorian_12")
	header:SetContentAlignment(5)
	header:Dock(TOP)
	header:SizeToContents()

	if not isBuying then
		local available = vgui.Create("DLabel", container)
		available:SetText(string.format(Setorian.Crypto.Translation.Available, "$"..string.Comma(math.Round(wallet.amount * tokenData.price, 2))))
		available:SetColor(gray)
		available:SetFont("setorian_10")
		available:SetContentAlignment(5)
		available:Dock(TOP)
		available:SizeToContents()
	end

	local modifyAmount = vgui.Create("DLabel", container)
	modifyAmount:SetText("$0")
	modifyAmount:SetColor(blue)
	modifyAmount:SetFont("setorian_22")
	modifyAmount:SetContentAlignment(5)
	modifyAmount:Dock(TOP)
	modifyAmount:SizeToContents()

	local modifyAmountToken = vgui.Create("DLabel", container)
	modifyAmountToken:SetText("0 "..tokenData.slug)
	modifyAmountToken:SetColor(grey)
	modifyAmountToken:SetFont("setorian_12")
	modifyAmountToken:SetContentAlignment(5)
	modifyAmountToken:Dock(TOP)
	modifyAmountToken:SizeToContents()

	local buttons = vgui.Create("DIconLayout", container)
	buttons:SetSpaceX(aphone.GUI.ScaledSizeX(5))
	buttons:SetSpaceY(aphone.GUI.ScaledSizeY(5))
	buttons:Dock(TOP)

	for k, v in SortedPairs(buttonOptions) do
		local d = buttons:Add("DButton")
		d:SetText(v[1])
		d:SetFont("setorian_15")
		d:SetSize(container:GetWide() / 3 - aphone.GUI.ScaledSizeX(5), container:GetWide() / 3 - aphone.GUI.ScaledSizeX(5))
		d:SetTextColor(white)
		d:SetPaintBackground(false)
	
		function d.DoClick()
			modifyVal = v[2](modifyVal)
			
			local sellVal = tonumber(modifyVal)/100

			modifyAmount:SetText("$"..string.Comma(sellVal))

			local tokenVal = sellVal/tokenData.price
			modifyAmountToken:SetText(string.Comma(math.Round(tokenVal, 4)).." "..tokenData.slug)
		end
	end

	local trade = vgui.Create("DButton", container)
	trade:Dock(TOP)
	trade:SetTall(50)
	trade:SetText(string.format(isBuying and Setorian.Crypto.Translation.Buy or Setorian.Crypto.Translation.Sell, tokenData.slug))
	trade:SetColor(background)
	trade:SetFont("setorian_15")
	function trade:Paint(w, h)
		draw.RoundedBox(10, 0, 0, w, h, blue)
	end
	function trade.DoClick()
		-- Needs to be atleast $1 lol
		if (tonumber(modifyVal) or 0) < 100 then return end

		local tokenVal = ((tonumber(modifyVal) or 0)/100)/tokenData.price
		tokenVal = math.Round(tokenVal, 4)
		if tokenVal == 0 then return end 

		if (not isBuying) and (tokenVal > wallet.amount) then return end

		net.Start("Setorian:Crypto:App:Purchase")
			net.WriteBool(isBuying)
			net.WriteString(token)
			net.WriteFloat(tokenVal)
		net.SendToServer()

		self:Open(main, main_x, main_y, screenmode, true)
	end
end

function APP:CreateOverlay(parent, build)
	local shell = vgui.Create("DButton", parent)
	shell:SetSize(parent:GetWide(), parent:GetTall())
	shell:SetPos(0, parent:GetTall())
	shell:SetText("")
	shell.Paint = nil

	shell:MoveTo(0, 0, 0.5)

	function shell:DoClick()
		self:MoveTo(0, parent:GetTall(), 0.5, 0, -1, function()
			self:Remove()
		end)
	end

	build(shell)
end

aphone.RegisterApp(APP)