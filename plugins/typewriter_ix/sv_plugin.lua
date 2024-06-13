util.AddNetworkString("MascoType::CreateDocumentInv")

net.Receive("MascoType::CreateDocumentInv", function(len, ply)
    if not IsValid(ply) or not ply:GetCharacter() then return end

    ply.AntiSpamTypeWriter = ply.AntiSpamTypeWriter or CurTime()

    local timeRemaining = ply.AntiSpamTypeWriter - CurTime()

    if ply.AntiSpamTypeWriter > CurTime() then ply:Notify("You must wait " .. ix.config.Get("AntiSpamTime") .. " second(s) in between uses of the Typewriter. You must wait " .. math.ceil(timeRemaining) .. " more second(s).") return end

    ply.AntiSpamTypeWriter = CurTime() + ix.config.Get("AntiSpamTime")

    MascoTypeWriter.DocumentName = net.ReadString()
    MascoTypeWriter.DocumentBody = net.ReadString()
    MascoTypeWriter.Quantity = net.ReadInt(32)
    MascoTypeWriter.TargetInventory = ply:GetCharacter():GetInventory()
    MascoTypeWriter.TargetCharacterName = ply:GetCharacter():GetName()
    MascoTypeWriter.AmountofPapers = MascoTypeWriter.TargetInventory:GetItemCount("paper")

    if MascoTypeWriter.AmountofPapers >= tonumber(ix.config.Get("MaxQuantityAmount")) then
        ply:Notify("You already have the max amount of documents in your inventory. Please try again.")
        return
    end

    if MascoTypeWriter.Quantity > tonumber(ix.config.Get("MaxQuantityAmount")) or  MascoTypeWriter.Quantity < 1 then
        ply:Notify("There was a problem with your request. Please try again.")
        return
    end

    MascoTypeWriter.TitleTooLong = #MascoTypeWriter.DocumentName > 128
	MascoTypeWriter.TitleTooShort = #MascoTypeWriter.DocumentName == 0

    if MascoTypeWriter.TitleTooLong or MascoTypeWriter.TitleTooShort then
        ply:Notify(MascoTypeWriter.TitleTooLong and "The title cannot be longer than 128 characters in length. Please try again." or "The title cannot be empty. Please try again.")
        return
    end

    MascoTypeWriter.BodyTooLong = #MascoTypeWriter.DocumentBody > 256
	MascoTypeWriter.BodyTooShort = #MascoTypeWriter.DocumentBody < 16
	
    if MascoTypeWriter.BodyTooLong or MascoTypeWriter.BodyTooShort then
        ply:Notify(MascoTypeWriter.BodyTooLong and "The document body cannot be longer than 256 characters in length. Please try again." or "The document body cannot be any shorter than 16 characters in length. Please try again.")
        return
    end

    if MascoTypeWriter.TargetInventory and string.StartsWith(MascoTypeWriter.DocumentBody, "https://docs.google.com/") then
        timer.Create("CreateItemDocuments", 0.5, MascoTypeWriter.Quantity, function()
            MascoTypeWriter.TargetInventory:Add("paper", 1, {
                DocumentName = MascoTypeWriter.DocumentName,
                DocumentBody = MascoTypeWriter.DocumentBody,
                Creator = MascoTypeWriter.TargetCharacterName
            })
        end)

        ply:Notify('You created ' .. MascoTypeWriter.Quantity .. ' document(s) titled "' .. MascoTypeWriter.DocumentName .. '".')
    else
        ply:Notify("There was a problem with your request. Please try again.")
        return
    end
end)