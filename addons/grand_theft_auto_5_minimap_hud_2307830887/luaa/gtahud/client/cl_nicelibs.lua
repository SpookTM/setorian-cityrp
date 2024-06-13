
local paris = paris

function paris:AutoRefresh()
    if paris.HUDMaps then
        for k, v in pairs(paris.HUDMaps) do
            if v.Map == game.GetMap() then
                if !v.UseZones or !IsValid(LocalPlayer()) then
                    if paris.Zone != k then
                        paris.Mat = Material(v.Material..".png","smooth 1")
                    end
                    paris.Zone = "*"
                    if v.Zoom then
                        paris.HUDZoom = v.Zoom
                    else
                        paris.HUDZoom = 1
                    end
                    paris.Scale = v.Scale
                    paris.ScaleX, paris.ScaleY = v.ScaleX, v.ScaleY
                    paris.Translate = v.Translate
                else
                    for k, v in pairs(v.Zones) do
                        if k != "MAIN" then
                            for _, vectors in pairs(v.InsideZones) do
                                if LocalPlayer():GetPos():WithinAABox(vectors[1],vectors[2]) then
                                    if paris.Zone != k then
                                        paris.Mat = Material(v.Material..".png","smooth 1")
                                    end
                                    paris.Zone = k
                                    if v.Zoom then
                                        paris.HUDZoom = v.Zoom
                                    else
                                        paris.HUDZoom = 1
                                    end
                                    paris.Scale = v.Scale
                                    paris.ScaleX, paris.ScaleY = v.ScaleX, v.ScaleY
                                    paris.Translate = v.Translate
                                    break
                                end
                            end
                        else
                            if paris.Zone != k then
                                paris.Mat = Material(v.Material..".png","smooth 1")
                            end
                            paris.Zone = k
                            if v.Zoom then
                                paris.HUDZoom = v.Zoom
                            else
                                paris.HUDZoom = 1
                            end
                            paris.Scale = v.Scale
                            paris.ScaleX, paris.ScaleY = v.ScaleX, v.ScaleY
                            paris.Translate = v.Translate
                        end
                    end
                end
            end
        end
    end
end

local charset = {}

-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

local PLAYER = FindMetaTable("Player")
function PLAYER:HasLOS( Entity )
	local tr = util.TraceLine( {
		start 	= self:GetShootPos(),
		endpos 	= Entity:GetPos() + Vector( 0, 0, 64 ),
        filter 	= { Entity, self, self:GetActiveWeapon(), self:GetVehicle() },
	} )
	
	local tr2 = util.TraceLine( {
		start 	= self:GetShootPos(),
		endpos 	= Entity:GetPos(),
		filter 	= { Entity, self, self:GetActiveWeapon(), self:GetVehicle() },
	} )
	
	if tr.Fraction > 0.98 or tr2.Fraction > 0.98 then return true end
end
function PLAYER:CanSee( Entity, Strict )
	if not IsValid( Entity ) then return end
	
	if Strict then
		if not self:HasLOS( Entity ) then return end
	end

	if self:GetPos():Distance( Entity:GetPos() ) < 200 then return true end

	local fov = self:GetFOV()
	local Disp = Entity:GetPos() - self:GetPos()
	local Dist = Disp:Length()
	local EntWidth = Entity:BoundingRadius() * 0.5
	
	local MaxCos = math.abs( math.cos( math.acos( Dist / math.sqrt( Dist * Dist + EntWidth * EntWidth ) ) + fov * ( math.pi / 180 ) ) )
	Disp:Normalize()

	if Disp:Dot( self:EyeAngles():Forward() ) > MaxCos and Entity:GetPos():Distance( self:GetPos() ) < 5000 then
		return true
	end
end

function string.random(length)
  math.randomseed(os.time())

  if length > 0 then
    return string.random(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

local editingInSky = false
local SkyFog = function(scale)
    if not editingInSky then return end

	local fogend,fogstart = 1000000, 1000000

	render.FogMode( 1 )
	render.FogStart( fogstart )
	render.FogEnd( fogend )
	render.FogMaxDensity( 0 )

	return true
end

hook.Add("SetupSkyboxFog","fogshit",SkyFog)
hook.Add("SetupWorldFog","fogshit",SkyFog)

concommand.Add("mapscreenshot", function(ply)

    if (!ply:IsSuperAdmin()) then return end

    editingInSky = true

    local Frame = vgui.Create("DFrame")
    Frame:SetSize(ScrW(),ScrH())
    Frame:Center()
    Frame:MakePopup()
    Frame.OnClose = function()
        editingInSky = false
    end

    local Zoominf = 500
    local Zoom = Zoominf

    local movex, movey = 0,0
    local movexinf, moveyinf = 0,0

    function Frame:OnMouseWheeled(scrollDelta)
        if input.IsKeyDown(KEY_LSHIFT) then 
            Zoominf = Zoominf + (-500*scrollDelta)
        else
            Zoominf = Zoominf + (-100*scrollDelta)
        end
    end
    function Frame:PaintOver(w,h)

        local x,y = Frame:LocalToScreen( 0, 0 )
        if input.IsKeyDown(KEY_LSHIFT) and input.IsKeyDown(KEY_LALT) then
            y = y + 30
        end

        local speed = 5000
        if input.IsKeyDown(KEY_LSHIFT) then
            speed = speed*2
        end
        if input.IsKeyDown(KEY_W) then
            movexinf = movexinf + (speed * FrameTime())
        end
        if input.IsKeyDown(KEY_S) then
            movexinf = movexinf - (speed * FrameTime())
        end
        if input.IsKeyDown(KEY_A) then
            moveyinf = moveyinf + (speed * FrameTime())
        end
        if input.IsKeyDown(KEY_D) then
            moveyinf = moveyinf - (speed * FrameTime())
        end

        movex = Lerp( 4 * FrameTime() , movex , movexinf)
        movey = Lerp( 4 * FrameTime() , movey , moveyinf)
        Zoom = Lerp( 4 * FrameTime() , Zoom , Zoominf)

        local viewdata = {
            x = x,
            y = y,
            w = w,
            h = h,
            type = "3D",
            ortho = "top",
            origin = ((Vector(0,0,10)*(Vector(Zoom,Zoom,Zoom)))) + (Vector(movex,movey,0)),
            angles = Angle(90,0,0),
            fov = 10,
            aspect = (w/h),
            subrect = true, -- Maybe idk
            zfar = 1000000,
            dopostprocess  = false,
            bloomtone  = false,
        }

        render.RenderView(viewdata)

        if input.IsKeyDown(KEY_LSHIFT) and input.IsKeyDown(KEY_ENTER) then
            local data = render.Capture( {
                format = "png",
                x = 0,
                y = 0,
                w = ScrW(),
                h = ScrH()
            } )
        
            file.Write( "image.png", data )
    
            Frame:Remove()
        end

    end
end)

concommand.Add("openalignmenu", function(ply)
    if (!ply:IsSuperAdmin()) then return end
    local Frame = vgui.Create("DFrame")
    Frame:SetSize(1300,1030)
    Frame:Center()
    Frame:MakePopup()

    local Zoominf = 500
    local Zoom = Zoominf
    local ZoomSlider = vgui.Create("DNumSlider", Frame)
    local DHTML

    function Frame:OnMouseWheeled(scrollDelta)
        if input.IsKeyDown(KEY_LSHIFT) then 
            Zoominf = Zoominf + (-100*scrollDelta)
        else
            Zoominf = Zoominf + (-30*scrollDelta)
        end
    end

    ZoomSlider:SetSize(200,30)
    ZoomSlider:SetDark(true)
    ZoomSlider:SetPos(Frame:GetWide()-250, 100)
    ZoomSlider:SetText("Zoom")
    ZoomSlider:SetMin(0.1)
    ZoomSlider:SetMax(2500)
    ZoomSlider:SetDecimals(1)
    ZoomSlider:SetDefaultValue(Zoom)
    ZoomSlider.OnValueChanged = function( self, value )
        Zoominf = value
    end

    if paris.HUDMaps then
        for k, v in pairs(paris.HUDMaps) do
            if v.Map == game.GetMap() then
                if !v.UseZones or !IsValid(LocalPlayer()) then
                    if paris.Zone != k then
                        paris.Mat = Material(v.Material..".png","smooth 1")
                    end
                    paris.Zone = "*"
                    if v.Zoom then
                        paris.HUDZoom = v.Zoom
                    else
                        paris.HUDZoom = 1
                    end
                    paris.Scale = v.Scale
                    paris.ScaleX, paris.ScaleY = v.ScaleX, v.ScaleY
                    paris.Translate = v.Translate
                end
            end
        end
    end

    local Menu = vgui.Create("DComboBox", Frame)
    Menu:SetPos(Frame:GetWide()-250,40)
    Menu:SetSize(200,30)

    Menu:SetValue( "CHOOSE A HUDMAP" )

    local HUDMAPS = {}
    if paris.HUDMaps then
        for k, v in pairs(paris.HUDMaps) do
            if v.Map == game.GetMap() then
                HUDMAPS = v
                if v.UseZones then
                    for zone,value in pairs(v.Zones) do
                        Menu:AddChoice( zone,value )
                    end
                else
                    Menu:AddChoice( "Default",v )
                end
            end
        end
    end

    local Sliders = {}
    local HUDMAP
    Menu.OnSelect = function( self, index, data )
        Menu:SetValue( data )
        if data != "Default" then
            HUDMAP = HUDMAPS.Zones[data]
            if HUDMAP.Translate then
                Sliders["Translate X"]:SetValue(HUDMAP.Translate.x)
                Sliders["Translate Y"]:SetValue(HUDMAP.Translate.y)
                Sliders["Translate Z"]:SetValue(HUDMAP.Translate.z)
            end
            if HUDMAP.ScaleX then
                Sliders["Scale X"]:SetValue(HUDMAP.ScaleX)
            end
            if HUDMAP.ScaleY then
                Sliders["Scale Y"]:SetValue(HUDMAP.ScaleY)
            end
        else
            HUDMAP = HUDMAPS
            if HUDMAP.Translate then
                Sliders["Translate X"]:SetValue(HUDMAP.Translate.x)
                Sliders["Translate Y"]:SetValue(HUDMAP.Translate.y)
                Sliders["Translate Z"]:SetValue(HUDMAP.Translate.z)
            end
            if HUDMAP.ScaleX then
                Sliders["Scale X"]:SetValue(HUDMAP.ScaleX)
            end
            if HUDMAP.ScaleY then
                Sliders["Scale Y"]:SetValue(HUDMAP.ScaleY)
            end
        end
    end

    local translateorder = {
        [1] = {
            RealKey = "Translate X",
            key = "x",
            value = 0
        },
        [2] = {
            RealKey = "Translate Y",
            key = "y",
            value = 0
        },
        [3] = {
            RealKey = "Translate Z",
            key = "z",
            value = 0
        },
        [4] = {
            RealKey = "Scale X",
            value = 1,
            min = 0.1,
            max = 4
        },
        [5] = {
            RealKey = "Scale Y",
            value = 1,
            min = 0.1,
            max = 4
        },
        [6] = {
            RealKey = "Opacity",
            value = 150,
            min = 0,
            max = 255
        }
    }
    local translate = {}
    for k, v in pairs(translateorder) do
        translate[v.RealKey] = v
    end


    local n = 0
    for k, v in ipairs(translateorder) do
        n = n + 1
        local Slider = vgui.Create("DNumSlider", Frame)
        Sliders[v.RealKey] = Slider
        Slider:SetDark(true)
        Slider:SetSize(200,30)
        Slider:SetPos(Frame:GetWide()-250, 130+(n*30))
        Slider:SetText(v.RealKey)
        Slider:SetMin(v.min or -20000)
        Slider:SetMax(v.max or 20000)
        Slider:SetDecimals(4)
        Slider:SetValue(v.value)
        Slider.OnValueChanged = function( self, value )
            translate[v.RealKey].value = value
        end
    end
    
    local mapmin,mapmax = game.GetWorld():GetModelBounds()
    local mapx = mapmax.x-mapmin.x
    local mapy = mapmax.y-mapmin.y
    
    local trans

    local movex, movey = 0,0
    local movexinf, moveyinf = 0,0

    local color_grey = Color(44,44,44,255)
    local color_lightwhite = Color(244,244,244,255)

    function Frame:Paint(w,h)

        draw.RoundedBox(0, 0, 0, w, h, color_grey)
        draw.RoundedBox(0, w-300, 30, 300, h-30, color_lightwhite)

        local x,y = Frame:LocalToScreen( 0, 0 )
        y = y + 30

        local speed = 5000
        if input.IsKeyDown(KEY_LSHIFT) then
            speed = speed*2
        end
        if input.IsKeyDown(KEY_W) then
            movexinf = movexinf + (speed * FrameTime())
        end
        if input.IsKeyDown(KEY_S) then
            movexinf = movexinf - (speed * FrameTime())
        end
        if input.IsKeyDown(KEY_A) then
            moveyinf = moveyinf + (speed * FrameTime())
        end
        if input.IsKeyDown(KEY_D) then
            moveyinf = moveyinf - (speed * FrameTime())
        end

        movex = Lerp( 4 * FrameTime() , movex , movexinf)
        movey = Lerp( 4 * FrameTime() , movey , moveyinf)
        Zoom = Lerp( 4 * FrameTime() , Zoom , Zoominf)

        trans = Vector(translate["Translate X"].value,translate["Translate Y"].value,translate["Translate Z"].value)

        local viewdata = {
            x = x,
            y = y,
            w = w-300,
            h = h-30,
            type = "3D",
            origin = ((Vector(0,0,10)*(Vector(Zoom,Zoom,Zoom)))) + (Vector(movex,movey,0)),
            angles = Angle(90,0,0),
            fov = 60,
            aspect = ((w-300)/(h-30)),
            subrect = true, -- Maybe idk
            zfar = 50000,
            dopostprocess  = false,
            bloomtone  = false,
        }

        render.RenderView(viewdata)

        cam.Start(viewdata)

            if HUDMAP and not HUDMAP.Mat and HUDMAP.Material then
                HUDMAP.Mat = Material(HUDMAP.Material..".png","smooth 1")
            end

            if HUDMAP and HUDMAP.Mat then
                render.SetMaterial(HUDMAP.Mat)
                render.DrawQuadEasy(Vector(0,0,0) + trans, Vector(0,0,1), mapx*(translate["Scale X"].value or 1), mapy*(translate["Scale Y"].value or 1), Color(255,255,255,translate["Opacity"].value or 0), 90)
            end
    
        cam.End3D()
    end

end)


hook.Add("InitPostEntity", "InitializeHealthDamageIsTaken", function()

    net.Start("RequestNewBlips")
    net.SendToServer()

    local Health = LocalPlayer():Health()
    hook.Add("Think", "HealthDamageIsTaken", function()
        if LocalPlayer():Health() < Health then
            hook.Run("PARIS_DamageTaken", (LocalPlayer():Health() - Health), Health)
        end
        Health = LocalPlayer():Health()
    end)
end)


paris.ScreenRatio = function(Ratio1,Ratio2)
    local Ratio = math.Round(Ratio1/Ratio2, 1)
    local Width, Height = ScrW(), ScrH()
    if Ratio == math.Round(Width/Height, 1) then
        return Width, Height
    else
        if Ratio1/Ratio2 > Width/Height then -- 16/9 > 16/10
            local NewHeight = (Width*Ratio2) / Ratio1
            local NewWidth = Width

            return NewWidth, NewHeight
        elseif Ratio1/Ratio2 < Width/Height then -- 16/19 < 16/5
            local NewHeight = Height
            local NewWidth = (Ratio1*Height) / Ratio2

            return NewWidth, NewHeight
        end
    end
    return Width, Height
end
paris.ScrW, paris.ScrH = paris.ScreenRatio(1920, 1080) -- thats what it was coded on





// Moats Text Effects
// https://github.com/moatato/moat-texteffects
// Credits to ^ all the way!

local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawLine = surface.DrawLine
local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local string_Explode = string.Explode
local math_Rand = math.Rand
local math_random = math.random
local math_sin = math.sin
local math_abs = math.abs
local HSVtoColor = HSVToColor
local Realtime = RealTime
local Frametime = FrameTime
local Curtime = CurTime
local Color = Color


/*---------------------------------------------------------------------------
Align Text Helper
---------------------------------------------------------------------------*/
local function m_GetTextSize(text, font)
    surface_SetFont(font)
    return surface_GetTextSize(text)
end

local should_align_x = {[TEXT_ALIGN_CENTER] = true, [TEXT_ALIGN_RIGHT] = true}
local should_align_y = {[TEXT_ALIGN_BOTTOM] = true}
local function m_AlignText(text, font, x, y, xalign, yalign)
    local tw, th = m_GetTextSize(text, font)

    if (should_align_x[xalign]) then x = xalign == TEXT_ALIGN_CENTER and x - (tw / 2) or x - tw end
    if (should_align_y[yalign]) then y = y - th end

    return x, y
end

/*---------------------------------------------------------------------------
Color Transition Function
---------------------------------------------------------------------------*/

function GlowColor(c, t, m)
    return Color(c.r + ((t.r - c.r) * (m)), c.g + ((t.g - c.g) * (m)), c.b + ((t.b - c.b) * (m)))
end

/*---------------------------------------------------------------------------
Text Effect Functions
---------------------------------------------------------------------------*/

function DrawShadowedText(shadow, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    draw_SimpleText(text, font, x + shadow, y + shadow, Color(0, 0, 0, color.a or 255), xalign, yalign)
    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawEnchantedText(speed, text, font, x, y, color, glow_color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    glow_color = glow_color or Color(127, 0, 255)

    local texte = string_Explode("", text)
    local chars_x = 0

    x, y = m_AlignText(text, font, x, y, xalign, yalign)
    surface_SetFont(font)

    for i = 1, #texte do
        local char = texte[i]
        local charw = surface_GetTextSize(char)
        local color_glowing = GlowColor(glow_color, color, math_abs(math_sin((Realtime() - (i * 0.08)) * speed)))
        draw_SimpleText(char, font, x + chars_x, y, color_glowing, xalign, yalign)

        chars_x = chars_x + charw
    end
end

function DrawFadingText(speed, text, font, x, y, color, fading_color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    fading_color = fading_color or Color(255, 255, 255)

    local c = GlowColor(color, fading_color, math_abs(math_sin((Realtime() - 0.08) * speed)))
    draw_SimpleText(text, font, x, y, c, xalign, yalign)
end

function DrawRainbowText(speed, text, font, x, y, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    draw_SimpleText(text, font, x, y, HSVtoColor(Curtime() * (70 * speed) % 360, 1, 1), xalign, yalign)
end

function DrawGlowingText(static, text, font, x, y, color, xalign, yalign)
    local xalign = xalign or TEXT_ALIGN_LEFT
    local yalign = yalign or TEXT_ALIGN_TOP
    local g = static and 1 or math_abs(math_sin((Realtime() - 0.1) * 2))

    for i = 1, 2 do -- You can change this if you want a heavier glow
        draw_SimpleTextOutlined(text, font, x, y, color, xalign, yalign, i, Color(color.r, color.g, color.b, (20 - (i * 5)) * g))
        -- first number (20) is the initial alpha of the glow, then the following number (5) is the amount at which the alpha declines for the glow
    end

    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawBouncingText(style, intesity, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    local chars_x = 0
    local texte = string_Explode("", text)
    local x, y = m_AlignText(text, font, x, y, xalign, yalign)
    surface_SetFont(font)

    for i = 1, #texte do
        local char = texte[i]
        local charw = surface_GetTextSize(char)
        local y_pos = 1
        local mod = math_sin((Realtime() - (i * 0.1)) * (2 * intesity))

        if (style < 3) then
            y_pos = style == 1 and y_pos - math_abs(mod) or y_pos + math_abs(mod)
        else
            y_pos = y_pos - mod
        end

        draw_SimpleText(char, font, x + chars_x, y - (5 * y_pos), color, xalign, yalign) -- You can change the number (5) for a heavier impact
        chars_x = chars_x + charw
    end
end

local ne, ea = Curtime(), 0 -- next electric effect and current effect
function DrawElectricText(intensity, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    draw_SimpleText(text, font, x, y, color, xalign, yalign)

    local charw, charh = m_GetTextSize(text, font)
    ea = ea > 0 and ea - (1000 * Frametime()) or 0
    surface_SetDrawColor(102, 255, 255, ea)

    for i = 1, math_random(5) do
        surface_DrawLine(x + math_random(charw), y + math_random(charh), x + math_random(charw), y + math_random(charh))
    end

    if (ne <= Curtime()) then
        ne = Curtime() + math_Rand(0.5 + (1 - intensity), 1.5 + (1 - intensity))
        ea = 255
    end
end

function DrawFireText(intensity, text, font, x, y, color, xalign, yalign, glow, shadow)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    local cw, ch = m_GetTextSize(text, font)
    for i = 1, cw do
        surface_SetDrawColor(255, math_random(255), 0, 150)
        surface_DrawLine(x - 1 + i, y + ch, x - 1 + i + math_random(-4, 4), y + math_random(ch * intensity, ch))
    end

    if (glow) then DrawGlowingText(true, text, font, x, y, color, xalign, yalign) end
    if (shadow) then draw_SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0), xalign, yalign) end

    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawSnowingText(intensity, text, font, x, y, color, color2, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    color2 = color2 or Color(255, 255, 255)

    draw_SimpleText(text, font, x, y, color, xalign, yalign)
    surface_SetDrawColor(color2.r, color2.g, color2.b, 255)

    local tw, th = m_GetTextSize(text, font)
    for i = 1, intensity do
        local lx, ly = math_Rand(0, tw), math_Rand(0, th)

        surface_DrawLine(x + lx, y + ly, x + lx, y + ly + 1)
    end
end



/*---------------------------------------------------------------------------
Example Command to see Text Effects -- You should exclude this if you're not using it.
---------------------------------------------------------------------------*/

-- local MOAT_SHOW_EFFECT_EXAMPLES = false

-- function moat_DrawEffectExamples()
--     if (not MOAT_SHOW_EFFECT_EXAMPLES) then return end

--     draw.RoundedBox(0, 50, 50, 700, 500, Color(0, 0, 0, 200))

--     local font = "DermaLarge"
--     local x = 100
--     local y = 100

--     DrawGlowingText(false, "GLOWING TEXT", font, x, y, Color(255, 0, 0, 255))
--     y = y + 50
--     DrawFadingText(1, "FADING COLORS TEXT", font, x, y, Color(255, 0, 0), Color(0, 0, 255))
--     y = y + 50
--     DrawRainbowText(1, "RAINBOW TEXT", font, x, y)
--     y = y + 50
--     DrawEnchantedText(2, "ENCHANTED TEXT", font, x, y, Color(255, 0, 0), Color(0, 0, 255))
--     y = y + 50
--     DrawFireText(0.5, "INFERNO TEXT", font, x, y, Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, true, true)
--     y = y + 50
--     DrawElectricText(1, "ELECTRIC TEXT", font, x, y, Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
--     y = y + 50
--     DrawBouncingText(3, 3, "BOUNCING AND WAVING TEXT", font, x, y, Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
--     y = y + 50
--     DrawSnowingText(10, "SPARKLING/SNOWING TEXT", font, x, y, Color(255, 0, 0), Color(255, 255, 255))
-- end
-- hook.Add("HUDPaint", "moat_TextEffectsExample", moat_DrawEffectExamples)
-- concommand.Add("moat_textexamples", function() MOAT_SHOW_EFFECT_EXAMPLES = not MOAT_SHOW_EFFECT_EXAMPLES end)


