for i = 1, 40 do
	surface.CreateFont("setorian_"..i, {
		font = "Calibri",
		size = ScreenScale(i),
		weight = 100
	})
end

for i = 20, 80 do
	surface.CreateFont("setorian_s_"..i, {
		font = "Calibri",
		size = i,
		weight = 100
	})
end

hook.Add("HUDPaint", "Setorian.Crypto.Icons", function()
	print("[Setorian Crypto]", "Loading all crypto icons")

	if not file.Exists("setorian", "DATA") then
		print("[Setorian Crypto]", "Creating setorian directory")

	    file.CreateDir("setorian")
	end 

	for k, v in pairs(Setorian.Crypto.Config.Tokens) do
		file.Delete("setorian/"..v..".png")

		print("[Setorian Crypto]", "Attempting to load", v)
		http.Fetch("https://cryptoicon-api.vercel.app/api/icon/"..string.lower(v), function(body, len, headers, code)
			file.Write("setorian/"..v..".png", body)
			Setorian.Crypto.Icons[v] = Material("data/setorian/"..v..".png")
			print("[Setorian Crypto]", v, "successfully pulled and saved")
		end)
	end

	print("[Reticle Image]", "Full load complete")
	hook.Remove("HUDPaint", "Setorian.Crypto.Icons")
end)