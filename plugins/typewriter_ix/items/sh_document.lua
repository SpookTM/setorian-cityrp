ITEM.name = "Document"
ITEM.description = "A piece of thick paper, quite fancy. Looks official."
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.View = {
	name = "View",
	OnClick = function(item)
		MascoTypeWriter.Document = vgui.Create("ixDocument")
		MascoTypeWriter.Document:SetDocument(item)
	end,
	OnRun = function(item) return false end,
	OnCanRun = function(item)
		if IsValid(item.entity) or item:GetData("DocumentBody") == nil then
            return false
        end
	end,
}

function ITEM:GetName()
	return self:GetData("DocumentName", self.name)
end

function ITEM:GetDescription()
	return Format(
		"%s %s %s",
		self.description,
		self:GetData("DocumentBody") and "This document has something written on it." or "This document is blank.",
		LocalPlayer():IsAdmin() and ("This document was created by "..self:GetData("Creator", "N/A")) or ""
	)
end