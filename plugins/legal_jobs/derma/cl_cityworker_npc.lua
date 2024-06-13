
local PLUGIN = PLUGIN
-- local PLUGIN = ix and ix.plugin and ix.plugin.Get and ix.plugin.Get("realistic_bank") or false

local animationTime = 1
DEFINE_BASECLASS("DFrame")
local PANEL = {}

function PANEL:Init()
-- frame:SetSize(800,550)
	
	self:SetSize(ScrW(),ScrH())
	self:Center()
	self:MakePopup()
	
	-- local parent = self:GetParent()
	-- self:SetSize(parent:GetWide() * 0.6, parent:GetTall())

	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)


	self.Paint = function(s,w,h)

		//Background
	    -- surface.SetDrawColor( 44, 62, 80, 250 )
	    -- surface.SetDrawColor(24, 37, 52, 100)
	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(0,0,w,h)

	    surface.SetDrawColor(52, 73, 94, 255)
	    surface.DrawRect(5,5,w-10,h-10)

	    surface.SetDrawColor(44, 62, 80, 255)
	    surface.DrawRect(5,5,w-10,5+48)

	    draw.SimpleText("City Workers Manager", "ix3D2DMediumFont", 12,5, Color( 240,240,240 ), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)


	    //property type bg

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(0,65,w,45)

	    -- draw.DrawText("Choose property's type", "ixMediumLightFont", 10,75, Color( 240,240,240 ), TEXT_ALIGN_LEFT)

	    -- surface.SetDrawColor(44, 62, 80, 255)
	    -- surface.DrawRect(0,5+48,w,5)


	end

	local modelFOV = (ScrW() > ScrH() * 1.8) and 41 or 21

	local char = LocalPlayer():GetCharacter()

	local plyModel = char:GetModel()

	local Character = vgui.Create( "ixModelPanel", self )
	Character:Dock(RIGHT)
	Character:SetWide(ScreenScale(160))
	-- Character:SetPos( self:GetWide()/2 - Character:GetWide()*1.7, 150)
	Character:SetModel(plyModel or "models/Humans/Group01/Male_04.mdl")
	Character:SetFOV(modelFOV)
	Character:SetMouseInputEnabled(false)
	Character.PaintModel = Character.Paint
	-- Character.PaintOver = function(s,w,h)
	-- 	surface.SetDrawColor(14, 27, 42, 50)
	--     surface.DrawRect(0,0,w,h)
	-- end

	Character.Entity:SetPos(Vector(0,0,-10))
	Character.LayoutEntity = function( s, entity )
	
		local scrW, scrH = ScrW(), ScrH()
		local xRatio = gui.MouseX() / scrW
		local yRatio = gui.MouseY() / scrH
		local x, _ = s:LocalToScreen(s:GetWide() / 2)
		local xRatio2 = x / scrW
		local entity = s.Entity

		entity:SetPoseParameter("head_pitch", yRatio*90 - 30)
		entity:SetPoseParameter("head_yaw", (xRatio - xRatio2)*90 - 5)
		entity:SetAngles(Angle(0,20,0))
		entity:SetIK(false)

		if (s.copyLocalSequence) then
			entity:SetSequence(LocalPlayer():GetSequence())
			entity:SetPoseParameter("move_yaw", 360 * LocalPlayer():GetPoseParameter("move_yaw") - 180)
		end

		s:RunAnimation()
	end

	Character.Entity:SetSkin( char:GetData("skin", 0) )
	for bodygroup, value in pairs (char:GetData("groups", {})) do
		Character.Entity:SetBodygroup( bodygroup, value )
	end

	self.PlyCharacter = Character


	////

	local Character = vgui.Create( "DModelPanel", self )
	Character:Dock(LEFT)
	Character:SetWide(ScreenScale(160))
	Character:SetModel("models/mossman.mdl")
	Character:SetFOV(modelFOV)
	Character:SetAnimated(true)
	Character:SetMouseInputEnabled(false)
	Character.PaintModel = Character.Paint
	-- Character.PaintOver = function(s,w,h)
	-- 	surface.SetDrawColor(14, 27, 42, 50)
	--     surface.DrawRect(0,0,w,h)
	-- end

	
	-- if (idleAnim <= 0) then
	-- 	idleAnim = Character.Entity:SelectWeightedSequence(ACT_BUSY_QUEUE)
	-- end

	function Character:LayoutEntity( Entity )
	
		Entity:SetAngles(Angle(0,70,0) )
		Entity:SetPos(Vector(0,0,-10) )


	-- 	-- if (idleAnim <= 0) then
			Entity:ResetSequence(333)
	-- 	-- end

		
		Character:RunAnimation()	
		return
	end


	self.NPCCharacter = Character

	local GreetingMsg = vgui.Create( "DPanel", self )
	GreetingMsg:Dock(TOP)
	GreetingMsg:SetTall(self:GetTall()*0.05)
	GreetingMsg:DockMargin(0,39,20,20)
	GreetingMsg.Paint = function(s,w,h)
		draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,false,true)
		draw.RoundedBoxEx(25, 2,2,w-4,h-4, Color(240,240,240),true,true,false,true)

		draw.SimpleText("Hello! How I can help you?", "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end


	local MainPanel = vgui.Create( "DPanel", self )
	MainPanel:Dock(FILL)
	MainPanel:DockMargin(0,0,20,30)
	MainPanel.CurrentAlpha = 255
	MainPanel.Paint = function(s,w,h)
		-- surface.SetDrawColor(214, 27, 42, 50)
	 --    surface.DrawRect(0,0,w,h)
	end

	self.mainPanel = MainPanel

	-- self:RenderOptions()

	self:SlideDown(0.5)
	self:AlphaTo(255, 0.3, 0.2, function() self:RenderMenu() end)

	

end

function PANEL:RenderMenu()
	

	-- self.mainPanel:Clear()
	self.mainPanel:CreateAnimation(animationTime * 0.2, {
		index = 1,
		target = {
			CurrentAlpha = 0,
		},
		easing = "outQuint",

		Think = function(animation, panel)
			panel:SetAlpha(panel.CurrentAlpha)
		end,
		OnComplete = function(animation, panel)

			panel:Clear()

			self:RenderOptions()

			panel:CreateAnimation(animationTime * 0.3, {
				index = 2,
				target = {
					CurrentAlpha = 255,
				},
				easing = "inQuint",

				Think = function(animation, panel)

					panel:SetAlpha(panel.CurrentAlpha)
				end,
			})
		end
	})

	

end

function PANEL:RenderOptions()
	

	// Menu = 1 is reserved for the display of selectable options [:RenderOptions()]

	local MenuButtons = {
		[1] = {
			Display = "I would like to become a city worker",
			Func = function(ply)
				
				net.Start("ixLegalJobs_CityWorker.Become")
					net.WriteEntity(self.NPCEnt)
				net.SendToServer()

			end

		},
		[2] = {
			Display = "I don't want to be a city worker anymore",
			Func = function(ply)

				net.Start("ixLegalJobs_CityWorker.Quit")
					net.WriteEntity(self.NPCEnt)
				net.SendToServer()

			end
		},
		[3] = {
			Display = "I want to receive a paycheck",
			Func = function(ply)

				net.Start("ixLegalJobs_CityWorker.ReceiverPaycheck")
					net.WriteEntity(self.NPCEnt)
				net.SendToServer()

			end
		},
		[4] = {
			Display = "Goodbye",
			Func = function(ply)
				self:SlideUp(0.5)
				self:AlphaTo(0, 0.3, 0.2, function() self:Close() end)
			end
		},
		
	}
	
	for k, v in SortedPairs(MenuButtons) do

		local Button1 = vgui.Create( "DButton", self.mainPanel )
		Button1:SetText( "" )
		Button1:Dock(TOP)
		Button1:DockMargin(ScreenScale(35),(k == 1 and ScreenScale(35)) or 20,ScreenScale(35),0)
		Button1:SetTall(50)
		Button1.Paint = function(s,w,h)
			draw.RoundedBoxEx(25, 0,0,w,h, Color(0,0,0),true,true,true,false)
			draw.RoundedBoxEx(25, 2,2,w-4,h-4, (s:IsHovered() and Color(200,200,200)) or Color(240,240,240),true,true,true,false)

			draw.SimpleText(v.Display, "ixMediumFont", 20, h/2, Color( 20,20,20 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Button1.DoClick = function()
			v.Func()
			-- if (v.CustomCheck()) then
			-- 	self:RenderMenu(v.Menu)
			-- else
			-- 	LocalPlayer():Notify(v.CustomCheckMsg or "You can't do that")
			-- end
		end
		Button1.OnCursorEntered = function()
			surface.PlaySound("helix/ui/rollover.wav")
		end

	end

end



vgui.Register("ixLegalJobs_CityWorkerNPCMenu", PANEL, "DFrame")


-- vgui.Create("ixLegalJobs_CityWorkerNPCMenu")
