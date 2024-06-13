// Full credit goes to Tom [Pixel UI]

local materials = {}

file.CreateDir("imgur-images")

function PLUGIN:GetImgur(id, callback, useproxy, matSettings)
    if materials[id] then return callback(materials[id]) end

    if file.Exists("imgur-images/" .. id .. ".png", "DATA") then
        materials[id] = Material("../data/imgur-images/" .. id .. ".png", matSettings or "noclamp smooth mips")
        return callback(materials[id])
    end

    http.Fetch(useproxy and "https://proxy.duckduckgo.com/iu/?u=https://i.imgur.com" or "https://i.imgur.com/" .. id .. ".png",
        function(body, len, headers, code)
            if len > 2097152 then
                materials[id] = Material("nil")
                return callback(materials[id])
            end

            file.Write("imgur-images/" .. id .. ".png", body)
            materials[id] = Material("../data/imgur-images/" .. id .. ".png", matSettings or "noclamp smooth mips")

            return callback(materials[id])
        end,
        function(error)
            if useproxy then
                materials[id] = Material("nil")
                return callback(materials[id])
            end
            return PLUGIN:GetImgur(id, callback, true)
        end
    )
end