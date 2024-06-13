local PLUGIN = PLUGIN

local scrw = ScrW()
local scrh = ScrH()

local origin_x = ScrW() / 2.0
local origin_y = ScrH() / 2.0

local CachedPoses = {}

local CachedMiddleCirle

local CachedMouseSpace = {}

local CloseIcon = Material("setorian_interaction_menu/close.png", "noclamp smooth")

surface.CreateFont("Setorian_Interaction_Font", {
	font = "Roboto",
	size = 16,
	antialias = true,
	weight = 400,
})

local Segments = #PLUGIN.Interaction_Functions

local slice = 2 * math.pi / Segments

local TFont = "Setorian_Interaction_Font"

local text_offset = 130
-- local text_width, text_height = surface.GetTextSize( string text )
local text_width = 3.15 -- Magic number, trial and error
local text_height = draw.GetFontHeight(TFont)

local BackGroundAnim = 0

local function RadiusSpoke(x, y, angle, rad)
    x = x + (math.cos(angle) * rad)
    y = y + (math.sin(angle) * rad)

    return x, y
end

local function interactionhud()

	for k, v in ipairs(CachedPoses) do
		-- print(CheckMousePos(), k)
		surface.SetDrawColor( (CheckMousePos() == k and Color(0,0,0,BackGroundAnim * 200)) or Color(0,0,0, BackGroundAnim * 150))
		-- surface.SetDrawColor( Color(25,25 * k,25 * k))
		surface.DrawArc(v)
	end

	-- surface.SetDrawColor( Color(150,150,150) )
	surface.SetDrawColor( (!CheckMousePos() and Color(0,0,0,BackGroundAnim * 200)) or Color(0,0,0, BackGroundAnim * 150))
	surface.DrawArc(CachedMiddleCirle)

	surface.SetDrawColor(240,240,240, BackGroundAnim*255)
	surface.SetMaterial( CloseIcon )
	surface.DrawTexturedRect(scrw/2 - 18, scrh/2 - 18,36,36)

	local ss = ScreenScale(1)

	local rad = ss * 100

    -- draw each segment
    local arc = 360 / Segments

    for i = 1, Segments do
        local angle = (i * arc) + (30 + (Segments * 5))

        local d = (angle + 180 + 360) % 360 - 180
        d = math.abs(d)

        local inf_x, inf_y = RadiusSpoke(origin_x, origin_y, math.rad(angle), 125)

        local PrintText = PLUGIN.Interaction_Functions[i].Name

        local TextLen = PrintText:len()

        if (TextLen >= 14) then
        	-- PrintText = PrintText:utf8sub(1, 11).."..."
        	PrintText = utf8.sub( PrintText, 1, 11 ).."..."
        end

        surface.SetFont(TFont)
        local inf_w, inf_h = surface.GetTextSize(PrintText)

        local tb_w = inf_w + (ss * 4)

        local matIcon = PLUGIN.Interaction_Functions[i].Icon

        surface.SetDrawColor(240,240,240, BackGroundAnim * 255)
		surface.SetMaterial( matIcon )
		surface.DrawTexturedRect(inf_x - 18, inf_y - 18 - 15 , 36, 36)

        draw.SimpleText(PrintText, TFont, inf_x - (inf_w * 0.5), inf_y + 10, Color( 255, 255, 255, BackGroundAnim * 255 ),TEXT_ALIGN_LEFT)
    end

end

local function PreparePanels()
	for i = 1, Segments do

		-- local offsetX = 0
		-- local offsetX = ((i == 2 or i == 5) and 0) or 5
		-- offsetX = ((i == 1 or i == 3) and -offsetX) or offsetX

		-- local offsetX = ((i == 2 or i == 5) and 5) or 3
		-- offsetX = (i > 3 and offsetX) or -offsetX

		-- local offsetY = ((i == 2 or i == 5) and 5) or 5
		-- offsetY = (i > 3 and -offsetY) or offsetY

		-- local offsetY = ((i == 2 or i == 5) and 0) or 5
		-- offsetY = ((i == 3 or i == 4) and -offsetY) or offsetY

		local startPos = (360 / Segments) * (i-1) + 90
		local endPos = (360 / Segments) * i + 90

		local isMiddleLeft = startPos < 180 and endPos > 180
		local isMiddleRight = startPos < 360 and endPos > 360

		local isMiddleTop = startPos < 270 and endPos > 270


		local offsetX = ((isMiddleLeft or isMiddleRight) and 5) or 3
		offsetX = ((360 / Segments) * (i-1) + 90 >= 270 and offsetX) or -offsetX

		offsetX = (isMiddleTop and 0) or offsetX

		local offsetY = ((isMiddleLeft or isMiddleRight) and 0) or 5

		offsetY = (isMiddleTop and 7) or offsetY

		offsetY = (( (360 / Segments) * (i-1) + 90 >= 180 and (360 / Segments) * i + 90 <= 360 ) and -offsetY) or offsetY



		

		-- print(i, (360 / Segments) * (i-1) + 90 >= 90, (360 / Segments) * i + 90 <= 180)
		-- print(i, (360 / Segments) * (i-1) + 90 >= 180, (360 / Segments) * i + 90 <= 360)
		-- print(i, (360 / Segments) * (i-1) + 90 >= 360, (360 / Segments) * i + 90 <= 450)
		-- print(i, (360 / Segments) * (i-1) + 90 < 180, (360 / Segments) * i + 90 > 180)

		-- CachedPoses[i] = surface.PrecacheArc(scrw/2 +offsetX,scrh/2 + offsetY,180,130,(360 / Segments) * (i-1) + 90 ,(360 / Segments) * i + 90,2)
	end


	-- CachedPoses = {}

	local ss = ScreenScale(1)

	local rad = ss * 100

    -- draw each segment
    local arc = 360 / Segments

    for i = 1, Segments do
        local angle = (i * arc) + 60

        local d = (angle + 180 + 360) % 360 - 180
        d = math.abs(d)

        local inf_x, inf_y = RadiusSpoke(origin_x, origin_y, math.rad(angle), 5)

        CachedPoses[i] = surface.PrecacheArc(inf_x,inf_y,180,130,(360 / Segments) * (i-1) * -1 - 90, (360 / Segments) * i * -1 - 90,2)
        -- CachedPoses[i] = surface.PrecacheArc(inf_x,inf_y,180,130,-90, -150,2)
    end

	CachedMiddleCirle = surface.PrecacheArc(scrw/2,scrh/2,50,50,0 ,360,2)

	print("[Setorian Interaction UI] Panels Prepared and ready to use")

	-- PrintTable(CachedPoses)
end


function CheckMousePos()
	
	local mouse_x, mouse_y = gui.MousePos()
	mouse_x = mouse_x - origin_x 
	mouse_y = mouse_y - origin_y

	if (mouse_x*mouse_x + mouse_y*mouse_y < 50*50) or mouse_x*mouse_x + mouse_y*mouse_y > 450*450 then
		return false
	else
		local mouse_ang = math.atan2( mouse_x, mouse_y ) * -1
		if mouse_ang < 0 then
			mouse_ang = math.pi * 2 + mouse_ang
		end
		local slice = 2 * math.pi / Segments
		local num_chosen = math.ceil( mouse_ang / slice )
		
		return num_chosen

	end

end



function DrawInteractionHUD()
        
	if (!IsValid(LocalPlayer()) and (!LocalPlayer())) then return end

	BackGroundAnim = Lerp(FrameTime() * 10, BackGroundAnim, 1)

	cam.Start2D()
		interactionhud()
	cam.End2D()
	
end


-- hook.Add("HUDPaint", "Setorian_InteractionMenu", DrawInteractionHUD)

-- SInteraction_Menu
SInteraction_Menu_Active = false

local function ShowRadialMenu(  )

	if (SInteraction_Menu_Active) then return end

	local ply = LocalPlayer()

	if (ply.InteractionDelay or 0) > CurTime() then
		return
	end

	PreparePanels()

	hook.Add("PostDrawHUD", "Setorian_InteractionMenu", DrawInteractionHUD)

	gui.EnableScreenClicker( true )

	SInteraction_Menu_Active = true

end

local function HideRadialMenu(  )

	if (!SInteraction_Menu_Active) then return end

	hook.Remove("PostDrawHUD", "Setorian_InteractionMenu")

	BackGroundAnim = 0

	if (CheckMousePos() and CheckMousePos() > 0) then
		netstream.Start("SetorianInteraction_Choosen", CheckMousePos())
	end

	local ply = LocalPlayer()

	gui.EnableScreenClicker( false )

	surface.PlaySound("helix/ui/press.wav")

	ply.InteractionDelay = CurTime() + 0.3

	SInteraction_Menu_Active = false

end

hook.Add( "Think", "RadialMenu_BindChecker", function()

	if (!gui.IsGameUIVisible()) and (!gui.IsConsoleVisible()) and (!IsValid(ix.gui.characterMenu)) and (!IsValid(ix.gui.menu)) and (!ix.gui.chat:GetActive()) then

		if (input.IsKeyDown( PLUGIN.KeysData[string.lower(ix.option.Get("interactionmenukey", "n"))] )) and (!SInteraction_Menu_Active) then
			ShowRadialMenu()
		elseif (!input.IsKeyDown( PLUGIN.KeysData[string.lower(ix.option.Get("interactionmenukey", "n"))] )) and (SInteraction_Menu_Active) then
			HideRadialMenu()
		end

	end

end)

-- function PLUGIN:PlayerButtonDown(client, button)

-- 	if (!gui.IsGameUIVisible()) and (!gui.IsConsoleVisible()) and (!IsValid(ix.gui.characterMenu)) and (!IsValid(ix.gui.menu)) and (!ix.gui.chat:GetActive()) then 

-- 		if (button == KEY_N ) and (!SInteraction_Menu_Active) then
-- 			ShowRadialMenu()
-- 			print("nacisnieto")
-- 		end

-- 	end

-- end

-- function PLUGIN:PlayerButtonUp(client, button)

-- 	if (!gui.IsGameUIVisible()) and (!gui.IsConsoleVisible()) and (!IsValid(ix.gui.characterMenu)) and (!IsValid(ix.gui.menu)) and (!ix.gui.chat:GetActive()) then 

-- 		if (button == KEY_N ) and (SInteraction_Menu_Active) then
-- 			HideRadialMenu()
-- 		end

-- 	end

-- end

-- concommand.Add( "+setorian_interaction_menu", ShowRadialMenu)

-- concommand.Add( "-setorian_interaction_menu", HideRadialMenu)