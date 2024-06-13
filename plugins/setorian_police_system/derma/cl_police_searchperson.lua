
local PLUGIN = PLUGIN

local animationTime = 1
DEFINE_BASECLASS("DFrame")

local PANEL = {}

local gradient = Material("vgui/gradient-d")

function PANEL:Init()

	self:SetSize( 300, 400 )
	self:Center()
	self:MakePopup()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self.Paint = function(s,w,h)
		surface.SetDrawColor( 52, 73, 94 )
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor( 44, 62, 80 )
	    surface.DrawRect(0,0,w,24)

	    draw.SimpleText("Person Search", "ixSmallFont", 5, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	    
	end

	local searchBar = vgui.Create("ixIconTextEntry", self)
	searchBar:Dock(TOP)
	searchBar.OnEnter = function(s)
	   	self:FindPeople(s:GetValue())
	end

	local DoneButtonAlpha = 0
	self.DoneButton = vgui.Create( "DButton", self )
	self.DoneButton:Dock(BOTTOM)
	self.DoneButton:DockMargin(0,5,0,5)
	self.DoneButton:SetTall(30)
	self.DoneButton:SetText( "Cancel" )
	self.DoneButton:SetTextColor( Color( 255, 255, 255) )
	self.DoneButton:SetFont("ixSmallFont")
	self.DoneButton.DoClick = function()
		surface.PlaySound( "ui/buttonclick.wav")
	end
	self.DoneButton.Paint = function(s,w,h)
		surface.SetDrawColor( 24, 42, 60,240 )
	    surface.DrawRect(0,0,w,h)
	    surface.SetDrawColor(60,60,60,DoneButtonAlpha)
	    surface.DrawOutlinedRect(0,0,w,h)
	end
	self.DoneButton.OnCursorEntered = function()
	DoneButtonAlpha = 240
	surface.PlaySound( "ui/buttonrollover.wav")
	end
	self.DoneButton.OnCursorExited = function()
	DoneButtonAlpha = 0
	end
	self.DoneButton.DoClick = function()
		self:Close()

		if (self:GetParent()) then
			self:GetParent().IsModified = false
		end

	end

	local DataScroll = vgui.Create( "DScrollPanel", self )
	DataScroll:Dock( FILL )
	-- DataScroll:DockMargin(0,5,0,0)
	-- DataScroll:DockPadding(5,5,5,5)
	DataScroll.Paint = function(s,w,h)

		surface.SetDrawColor(20,20,20,50)
	    surface.DrawRect(0,0,w,h)

	end

	self.DataScroll = DataScroll


end

function PANEL:FindPeople(searchWord)

	self.DataScroll:Clear()

	for client, char in ix.util.GetCharacters() do

		if (searchWord and (!string.StartWith(string.lower(client:GetName()),string.lower(searchWord)))) then continue end

		local ProfilePanel = vgui.Create( "DButton", self.DataScroll )
		ProfilePanel:Dock(TOP)
		ProfilePanel:DockMargin(5,5,5,10)
		ProfilePanel:SetTall(100)
		ProfilePanel:SetText("")
		ProfilePanel.Paint = function(s,w,h)

			if (s:IsHovered()) then
				surface.SetDrawColor(230,230,230)
			else
				surface.SetDrawColor(200,200,200)
		    end

		    surface.DrawRect(0,0,w,h)

		end
		ProfilePanel.OnCursorEntered = function(s)
			LocalPlayer():EmitSound("Helix.Rollover")
		end
		ProfilePanel.DoClick = function(s)
			surface.PlaySound("helix/ui/press.wav")

			-- print(client)


			if (self.TableToAdd) and (self:GetParent()) then

				local personTable = {
					PName = char:GetName(),
					PModel = char:GetModel()
				}

				if (self.TableToAdd == "Officers") then
					
					local rank = MRS.GetNWdata(LocalPlayer(), "Rank")
					local rank_info = MRS.Ranks[PLUGIN.PoliceRankGroup].ranks[rank]

					personTable.PRank = rank_info.name
				elseif (self.TableToAdd == "Suspects") then
					personTable.Chargers = {}
				end

				self:GetParent().PersonCaseData[self.TableToAdd].People[#self:GetParent().PersonCaseData[self.TableToAdd].People+1] = personTable

				self:GetParent():RenderCaseDetails(self:GetParent().PersonCaseData[self.TableToAdd].People,self.TableToAdd)

			end
 		
			self:Close()

		end

		local BGPanel = vgui.Create("DPanel", ProfilePanel)
		BGPanel:Dock(LEFT)
		BGPanel:SetWide(100)
		BGPanel:SetMouseInputEnabled(false)
		BGPanel.Paint = function(s,w,h)
			surface.SetDrawColor(34, 52, 70)
		    surface.DrawRect(0,0,w,h)

		    

		end

		local mdl = vgui.Create("DModelPanel", BGPanel)
		mdl:Dock(FILL)
		mdl:DockMargin(2,2,2,2)
		mdl:SetModel(client:GetModel() or "models/error.mdl")

		function mdl:LayoutEntity( Entity )
			return 
		end

		local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		mdl:SetLookAt(headpos-Vector(0, 0, 0))

		mdl:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

		mdl.Entity:SetEyeTarget(headpos-Vector(-30, 0, 0))

		local NamePanel = vgui.Create( "DLabel", ProfilePanel )
		NamePanel:Dock(TOP)
		NamePanel:DockMargin(10,10,0,0)
		NamePanel:SetFont("ixSmallFont")
		NamePanel:SetTextColor(Color(20,20,20))
		NamePanel:SetText( "Name:" )
		NamePanel:SetAutoStretchVertical(true)

		local NamePanel_Title = vgui.Create( "DLabel", ProfilePanel )
		NamePanel_Title:Dock(TOP)
		NamePanel_Title:DockMargin(10,0,0,0)
		NamePanel_Title:SetFont("ixSmallFont")
		NamePanel_Title:SetTextColor(Color(20,20,20))
		NamePanel_Title:SetText( client:GetName() )
		NamePanel_Title:SetAutoStretchVertical(true)

		local charFaction = char:GetFaction()

		local faction = ix.faction.indices[charFaction]

		local FactionTitle = vgui.Create( "DLabel", ProfilePanel )
		FactionTitle:Dock(TOP)
		FactionTitle:DockMargin(10,10,0,0)
		FactionTitle:SetFont("ixSmallFont")
		FactionTitle:SetTextColor(Color(20,20,20))
		FactionTitle:SetText( "Faction:" )
		FactionTitle:SetAutoStretchVertical(true)

		local FactionName = vgui.Create( "DLabel", ProfilePanel )
		FactionName:Dock(TOP)
		FactionName:DockMargin(10,0,0,0)
		FactionName:SetFont("ixSmallFont")
		FactionName:SetTextColor(Color(20,20,20))
		FactionName:SetText( faction.name )
		FactionName:SetAutoStretchVertical(true)



	end

end


vgui.Register("ixPoliceSys_SearchPerson", PANEL, "DFrame")
-- vgui.Create("ixPoliceSys_SearchPerson"):Populate()
