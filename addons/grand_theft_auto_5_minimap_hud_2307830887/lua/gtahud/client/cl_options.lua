paris = paris or {}

paris:HUDPrintMessage("Loading HUD Options")

surface.CreateFont("HudSettingsFont", {
	font = "Roboto Thin",
	extended = false,
    size = 22,
} )

local gradient = Material( "gui/gradient_up" )

surface.CreateFont("HudBlipBrowserFont", {
    font = "Roboto Thin",
    extended = false,
    size = 15,
} )

if !paris.HUDSettings or !paris.HUDSettings then  // Fixes stupid fucking issues
    paris.HUDSettings = DefaultClientOptions
end

local ConfigPath = "gtahudconfig.json"
if !file.Exists(ConfigPath, "DATA") or !istable(util.JSONToTable(file.Read(ConfigPath, "DATA"))) then
    file.Write(ConfigPath, util.TableToJSON(DefaultClientOptions, true))
    paris.HUDSettings = DefaultClientOptions -- Just go ahead and set it, incase the server is having issues.
    paris.AllowedChange = {}
end

net.Start("RequestServerSettings")
net.SendToServer()


local OptionDetails = {
    {
        Key = "DrawHUD",
        DisplayText = "Draw HUD",
        Help = "If the whole HUD should show up.",
        Type = "Bool",
    },
    {
        Key = "HUDPosX",
        DisplayText = "Hud X-Axis",
        Help = "Where the HUD goes on the x-axis.",
        Type = "Int",
        Min = 0,
        Max = ScrW() - 100,
    },
    {
        Key = "HUDPosY",
        DisplayText = "Hud Y-Axis",
        Help = "Where the HUD goes on the y-axis.",
        Type = "Int",
        Min = 0,
        Max = ScrH()
    },
    {
        Key = "HUDSizeX",
        DisplayText = "Hud Size X-Axis",
        Help = "How big does HUD go on the x-axis.",
        Type = "Int",
        Min = 1,
        Max = 600
    },
    {
        Key = "HUDSizeY",
        DisplayText = "Hud Size Y-Axis",
        Help = "How big does HUD go on the x-axis.",
        Type = "Int",
        Min = 1,
        Max = 600
    },
    {
        Key = "CarCamHeight",
        DisplayText = "Car HUD Camera Height",
        Help = "How high will the HUD camera go while in a vehicle.",
        Type = "Int",
        Min = 1000,
        Max = 20000
    },
    {
        Key = "CamHeight",
        DisplayText = "HUD Camera Height",
        Help = "How high can the HUD camera go while walking.",
        Type = "Int",
        Min = 1000,
        Max = 20000
    },
    {
        Key = "CarLookAng",
        DisplayText = "Car HUD Angle",
        Help = "The angle of the HUD while in a car.",
        Type = "Int",
        Min = 0,
        Max = 90
    },
    {
        Key = "FOV",
        DisplayText = "HUD FOV",
        Help = "The FOV of the hud.",
        Type = "Int",
        Min = 30,
        Max = 120
    },
    {
        Key = "DrawVOID",
        DisplayText = "Draw Void Area",
        Help = "If the void should draw of the VOID.",
        Type = "Bool",
    },
    {
        Key = "KeepTiltedCamera",
        DisplayText = "Camera Always Tilted",
        Help = "If the camera should always tilt.",
        Type = "Bool",
    },
    {
        Key = "SetHUDColor",
        DisplayText = "HUD Color",
        Help = "Color of the HUD.",
        Type = "Color",
    },
    {
        Key = "BackgroundOpacity",
        DisplayText = "HUD Background Opacity",
        Help = "Opacity of the background in the HUD.",
        Type = "Int",
        Min = 0,
        Max = 255
    },
    {
        Key = "DrawBackgroundBlur",
        DisplayText = "Draw Background Blur",
        Help = "Toggle background blurring (May reduce lag).",
        Type = "Bool",
    },
    {
        Key = "BackgroundBlurStrength",
        DisplayText = "Background Blur Strength",
        Help = "Strength of the background blur in the HUD.",
        Type = "Int",
        Min = 0,
        Max = 100
    },
    {
        Key = "ShowNPC",
        DisplayText = "Draw NPC's",
        Help = "If the HUD should draw NPCs like players.",
        Type = "Bool",
    },
    {
        Key = "DrawOthers",
        DisplayText = "Draw Others",
        Help = "If the HUD should draw other players.",
        Type = "Bool",
    },
    {
        Key = "DrawOutline",
        DisplayText = "Draw Outline",
        Help = "If the HUD should draw the dark outline.",
        Type = "Bool",
    },
    -- {
    --     Key = "DrawStamina",
    --     DisplayText = "Draw Stamina",
    --     Help = "If the stamina bar should draw under the health.",
    --     Type = "Bool",
    -- },
    {
        Key = "PlayerFadeDistance",
        DisplayText = "Player Fade Distance",
        Help = "The distance between when a player should fade off the HUD.",
        Type = "Int",
        Min = 1,
        Max = 100000
    },
    {
        Key = "DrawOnlyIfSeen",
        DisplayText = "Show Only Seen Entities",
        Help = "Show entities only if you can see them.",
        Type = "Bool",
    },
    -- {
    --     Key = "DefaultChat",
    --     DisplayText = "Use Addon Chat",
    --     Help = "Use the chat that comes with this addon.",
    --     Type = "Bool",
    -- },
    -- {
    --     Key = "AllowMaximizeMap",
    --     DisplayText = "Allow Maximizing Map",
    --     Help = "Turn on maximizing of the map.",
    --     Type = "Bool",
    -- },
    {
        Key = "blipdefault_player",
        DisplayText = "Player Default Blip",
        Help = "The default blip for players.",
        Type = "Blip",
    },
    {
        Key = "blipdefault_npc",
        DisplayText = "Player NPC Blip",
        Help = "The default blip for NPC's.",
        Type = "Blip",
    },
    {
        Key = "blipdefault_local",
        DisplayText = "Local Player Blip",
        Help = "The default blip for you the local player.",
        Type = "Blip",
    },
}

paris.GTAOptionDetails = OptionDetails

local SortedByKeyOptionDetails = {}
for k, v in pairs(OptionDetails) do
    SortedByKeyOptionDetails[v.Key] = v
end

local function ReceiveServerSettings()
    local data = net.ReadTable()
    local settings = util.JSONToTable(file.Read(ConfigPath, "DATA"))
    if data.AllowedChange then
        for k, v in pairs(data.Settings) do
            if !data.AllowedChange[k] then
                settings[k] = v
            end
        end
    else
        for k, v in pairs(data.Settings) do
            settings[k] = v
        end
    end

    -- check at end for bad ones and reset them
    for k, v in pairs(DefaultClientOptions) do
        if settings[k] == nil then
            settings[k] = DefaultClientOptions[k]
        end
        if SortedByKeyOptionDetails[k] and SortedByKeyOptionDetails[k].Type == "Blip" and not istable(settings[k]) then settings[k] = DefaultClientOptions[k] end
        if SortedByKeyOptionDetails[k] and SortedByKeyOptionDetails[k].Type == "Int" and not isnumber(settings[k]) then settings[k] = DefaultClientOptions[k] end
        if SortedByKeyOptionDetails[k] and SortedByKeyOptionDetails[k].Type == "Bool" and not isbool(settings[k]) then settings[k] = DefaultClientOptions[k] end
        if SortedByKeyOptionDetails[k] and SortedByKeyOptionDetails[k].Type == "Color" and not (istable(settings[k]) or IsColor(settings[k])) then settings[k] = DefaultClientOptions[k] end
    end

    file.Write(ConfigPath, util.TableToJSON(settings, true))
    paris.HUDSettings = settings
    if data.AllowedChange then
        paris.AllowedChange = data.AllowedChange
    end
    if !data.AllowedChange then
        data.AllowedChange = {}
    end

end

net.Receive("ReceiveServerSettings", ReceiveServerSettings)


local function PARIS_Slider( Parent )

    local Slider = vgui.Create( "DSlider", Parent )
    Slider:SetSize(4, 4)
    Slider.Text = ""
    Slider.Title = "Title"
    Slider.Max = 10
    local OlPaint = Slider.Paint

    Slider.ShakeX = 0
    Slider.ShakeY = 0
    Slider.ShakeTime = 0
    function Slider:Shake(Time)
        self.ShakeTime = CurTime() + Time
    end

    Slider.PlusOne = false
    Slider.Paint = function(x,y,z)

        DisableClipping(true)

        if Slider.ShakeTime > CurTime() then
            local dif = CurTime() - Slider.ShakeTime
            local fader = (math.sin(CurTime() * 40)) * 0.5
            Slider.ShakeX = (8*fader)*(dif)
        end

        if Slider.Lock then
            Slider.Text = math.Round(Slider.Default*(Slider.Max-Slider.Min)) + Slider.Min
        else
            Slider.Text = math.Round(Slider:GetSlideX()*(Slider.Max-Slider.Min)) + Slider.Min
        end

        draw.SimpleTextOutlined( Slider.Text , "HudSettingsFont", (Slider:GetWide()*0.5) + Slider.ShakeX, Slider:GetTall()*0.15, Color(255,255,255,255), 1, 1, 0, Color(255,255,255,255))
        --draw.SimpleTextOutlined( Slider.Title , "HudSettingsFont", Slider:GetWide()*0.5, Slider:GetTall()*0.85, Color(255,255,255,255), 1, 1, 0, Color(255,255,255,255))
        draw.RoundedBox(0, 0 + Slider.ShakeX, 30, Slider:GetWide(), 1, Color( 255, 255, 255, 255 ))
        draw.RoundedBox(0, 0 + Slider.ShakeX, (Slider:GetTall() * 0.5), 1, 12.5, Color( 255, 255, 255, 255 ))
        draw.RoundedBox(0, (Slider:GetWide() - 1) + Slider.ShakeX, (Slider:GetTall() * 0.5), 1, 12.5, Color( 255, 255, 255, 255 ))
        OlPaint(x,y,z)

        if Slider.UpdateFunc then
            Slider.UpdateFunc()
        end

        DisableClipping(false)

    end
    
    return Slider

end


local function PlaySoundEffect()
    local n = math.random(1, 3)
    surface.PlaySound( "paris/sound" .. n .. ".mp3" )
end


concommand.Add("gtahud", function()
    local Panel = vgui.Create("PFrame")
    Panel:SetSize(800,600)
    Panel:Center()
    Panel:CloseButton( true )
    Panel:Title("GTAHUD SETTINGS")
    Panel:MakePopup()
    Panel.DrawOutline = false

    local ScrollPanel = vgui.Create("PScrollPanel",Panel)
    ScrollPanel:SetSize(790,500)
    ScrollPanel:SetPos(5, 50)

    local Changed = {}
    local AdminChanged = {}

    local Layout = vgui.Create("DListLayout", ScrollPanel)
    Layout:SetSize(ScrollPanel:GetWide(), ScrollPanel:GetTall() / 10)
    Layout:SetPos(0, 0)

    for k, v in pairs(OptionDetails) do
        local Option = vgui.Create("DPanel", Layout)
        Option:SetSize(Layout:GetWide(), Layout:GetTall() )
        Option:SetPos(0,0)
        Option.Key = v.Key
        Option.Paint = function(w,h)
            draw.SimpleTextOutlined(v.DisplayText, "HudSettingsFont", 50, Option:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            draw.RoundedBox(0, 50, Option:GetTall()-1, Option:GetWide()-150, 1, Color(255,255,255,2))
        end

        if LocalPlayer():IsSuperAdmin() then
            Option.AllowChange = vgui.Create("PBool", Option)
            Option.AllowChange.Key = v.Key
            Option.AllowChange:SetText("")
            Option.AllowChange:SetPos((Option:GetWide()-50) -Option.AllowChange:GetWide(),(Option:GetTall()/2) - (Option.AllowChange:GetTall()/2))
            if paris.AllowedChange then
                Option.AllowChange.Active = paris.AllowedChange[v.Key]
            end
            Option.AllowChange.Surpass = true -- Surpasses the shaking permission.
            Option.AllowChange:SetToolTip("Should players be allowed to change this option?")

            Option.AllowChange.OnDoClick = function(bool)
                PlaySoundEffect()
                AdminChanged[v.Key] = bool
            end
        end

        if v.Type == "Bool" then
            Option.Adjust = vgui.Create("PBool", Option)
            Option.Adjust.Key = v.Key
            Option.Adjust:SetText("")
            Option.Adjust:SetPos((Option:GetWide()-150) -Option.Adjust:GetWide(),(Option:GetTall()/2) - (Option.Adjust:GetTall()/2))
            Option.Adjust.Active = paris.HUDSettings[Option.Key]
            Option.Adjust.OnDoClick = function(bool)
                Changed[Option.Key] = bool
                PlaySoundEffect()
            end
            Option.Adjust.DebugChangeable = v.DebugChangeable
            Option.Adjust:SetToolTip(v.Help)
        elseif v.Type == "Int" then
            Option.Adjust = PARIS_Slider( Option )
            Option.Adjust:SetSize(250,50)
            Option.Adjust:SetPos((Option:GetWide()-150) -Option.Adjust:GetWide(),(Option:GetTall()/2) - (Option.Adjust:GetTall()/2) + 4)
            Option.Adjust.Max = v.Max
            Option.Adjust.Min = v.Min
            if !paris.HUDSettings[Option.Key] then
                paris.HUDSettings[Option.Key] = DefaultClientOptions[Option.Key]
            end
            Option.Adjust.Default = (paris.HUDSettings[Option.Key]-v.Min)/(v.Max-v.Min)
            Option.Adjust:SetSlideX((paris.HUDSettings[Option.Key]-v.Min)/(v.Max-v.Min))
            function Option.Adjust.UpdateFunc()
                if Option.Adjust:IsEditing() and (paris.AllowedChange and paris.AllowedChange[v.Key]) then
                    Changed[Option.Key] = (math.Round(Option.Adjust:GetSlideX()*(Option.Adjust.Max-Option.Adjust.Min)) + Option.Adjust.Min)
                end
            end
            if paris.AllowedChange then
                Option.Adjust.Lock = !paris.AllowedChange[v.Key]
            end
            Option.Adjust:SetToolTip(v.Help)
        elseif v.Type == "Color" then
            Option.Adjust = vgui.Create("DButton", Option)
            Option.Adjust:SetToolTip(v.Help)
            Option.Adjust:SetText("")
            Option.Adjust:SetSize(250,50)
            Option.Adjust:SetPos((Option:GetWide()-150) -Option.Adjust:GetWide(),(Option:GetTall()/2) - (Option.Adjust:GetTall()/2))
            Option.Adjust.DoClick = function(bool)
                if paris.AllowedChange and !paris.AllowedChange[v.Key] then
                    Option.Adjust:Shake(2)
                    return
                end

                if IsValid(Option.Adjust.Col) then
                    Option.Adjust.Col:Remove()
                end

                Option.Adjust.Col = vgui.Create("PFrame",Panel)
                Option.Adjust.Col:SetSize(400,300)
                local x,y = Panel:GetPos()
                Option.Adjust.Col:SetPos(x+(Panel:GetWide()/2)-200,y+(Panel:GetTall()/2)-150)
                Option.Adjust.Col:CloseButton( true )
                Option.Adjust.Col:Title(v.DisplayText)
                Option.Adjust.Col:MakePopup()

                local Mixer = vgui.Create( "DColorMixer", Option.Adjust.Col )
                Mixer:SetPos(50,50)
                Mixer:SetSize(Option.Adjust.Col:GetWide()-100,Option.Adjust.Col:GetTall()-150)
                Mixer:SetPalette( false )
                Mixer:SetAlphaBar( true )
                Mixer:SetWangs( false )
                Mixer:SetColor( Changed[Option.Key] or paris.HUDSettings[Option.Key] )

                local Done = vgui.Create( "PButton", Option.Adjust.Col )
                Done:SetSize(100,30)
                Done:SetPos((Option.Adjust.Col:GetWide()/2)-50,Option.Adjust.Col:GetTall()-50)
                Done:Text("Close")

                function Done:DoClick()
                    PlaySoundEffect()
                    Changed[Option.Key] = Mixer:GetColor()
                    Option.Adjust.Col:Remove()
                end

            end
            Option.Adjust.Paint = function(w,h)
                DisableClipping(true)
                if Option.Adjust.ShakeTime > CurTime() then
                    local dif = CurTime() - Option.Adjust.ShakeTime
                    local fader = (math.sin(CurTime() * 40)) * 0.5
                    Option.Adjust.ShakeX = (8*fader)*(dif)
                end
                draw.RoundedBox(5, (Option.Adjust:GetWide()-150)+Option.Adjust.ShakeX, (Option.Adjust:GetTall()/2) - 10, 150, 20, Changed[Option.Key] or paris.HUDSettings[Option.Key])
                DisableClipping(false)
            end
            Option.Adjust.ShakeX = 0
            Option.Adjust.ShakeY = 0
            Option.Adjust.ShakeTime = 0
            function Option.Adjust:Shake(Time)
                self.ShakeTime = CurTime() + Time
            end
        elseif v.Type == "Blip" then
            Option.Adjust = vgui.Create("DButton", Option)
            Option.Adjust.Key = v.Key
            Option.Adjust:SetSize(Option:GetTall(),Option:GetTall())
            Option.Adjust:SetText("")
            Option.Adjust:SetPos((Option:GetWide()-145) -Option.Adjust:GetWide(),(Option:GetTall()/2) - (Option.Adjust:GetTall()/2))
            Changed[v.Key] = paris.HUDSettings[v.Key] or DefaultClientOptions[v.Key]
            Changed[v.Key].Material = Material(Changed[v.Key].mat or "")
            function Option.Adjust:Paint(w,h)
                surface.SetDrawColor(Changed[v.Key].col.r,Changed[v.Key].col.g,Changed[v.Key].col.b,Changed[v.Key].col.a)
                surface.SetMaterial(Changed[v.Key].Material)
                surface.DrawTexturedRect(0, 0, h, h)
            end
            Option.Adjust:SetToolTip(v.Help)
            function Option.Adjust:DoClick()

                if not paris.AllowedChange[v.Key] then return end

                local BlipPanel = vgui.Create("PFrame", Panel)
                BlipPanel:SetSize(350,500)
                BlipPanel:CloseButton( true )
                BlipPanel:Title("CHANGE BLIP")
                BlipPanel.DrawOutline = true
                BlipPanel:Center()

                local ChosenBlip = Changed[v.Key].mat or ""
                local ChosenBlipMat = Material(ChosenBlip)
                local ChosenBlipColor = Changed[v.Key].col

                function BlipPanel:PaintOver(w,h)
                    surface.SetDrawColor(ChosenBlipColor.r,ChosenBlipColor.g,ChosenBlipColor.b,ChosenBlipColor.a)
                    surface.SetMaterial(ChosenBlipMat)
                    surface.DrawTexturedRect((w/2)-32, 40, 64, 64)
                end

                function BlipPanel:OnClose()
                    Changed[v.Key] = {
                        mat = ChosenBlip,
                        Material = Material(ChosenBlip),
                        col = ChosenBlipColor,
                    }
                end

                local browser
                local function MakeSearch(Needle)
                    browser = PARIS_DrawDarkScrollPanel( BlipPanel )
                    browser:SetPos(0,121 + BlipPanel:GetTall() * 0.125)
                    browser:SetSize(BlipPanel:GetWide(), BlipPanel:GetTall() * (0.7-(0.025)))
                    local layout = vgui.Create("DListLayout", browser)
                    layout:SetSize(browser:GetWide(), browser:GetTall() / 12)
                    layout:SetPos(0, 0)
            
                    local files, folders = file.Find("materials/paris/blips/*.png", "GAME", "nameasc")
                    local allfiles = {}
                    for k, v in pairs(files) do
                        table.insert(allfiles,{"paris/blips/"..tostring(v),v})
                    end
            
            
                    local otherfoldersjson = "gtahudblipfolders.json"
                    local otherfolders = util.JSONToTable(file.Read(otherfoldersjson, "DATA") or "{}")
                    if istable(otherfolders) then
                        for k, folder in pairs(otherfolders) do
                            if file.Exists("materials/"..folder, "GAME") then
                                local otherfiles, otherfolders = file.Find("materials/"..folder.."*.png", "GAME", "nameasc")
                                for k, v in pairs(otherfiles) do
                                    table.insert(allfiles,{folder..tostring(v),v})
                                end
                            end
                        end
                    end
            
                    local mats = {}
                    for k, v in pairs(allfiles) do
                        mats[k] = Material(v[1])
                        if !Needle or string.find(string.lower(v[2]),string.lower(Needle)) then
                            local PlayerBlock = vgui.Create("DPanel", layout)
                            PlayerBlock:SetSize(layout:GetWide(), layout:GetTall())
                            PlayerBlock:SetPos(0,0)
                            PlayerBlock.Paint = function()
                                draw.RoundedBox(0, 0, 0, PlayerBlock:GetWide(), PlayerBlock:GetTall(), Color( 30, 30, 30, 200 ))
                                surface.SetDrawColor( 20,20,20,200 )
                                surface.SetMaterial( gradient )
                                surface.DrawTexturedRect( 0, 0, PlayerBlock:GetWide(), PlayerBlock:GetTall() )
                                local text = string.Left(v[1], #v[1] - 4)
                                draw.SimpleTextOutlined(text, "HudBlipBrowserFont", PlayerBlock:GetTall() + (PlayerBlock:GetWide()*0.05), PlayerBlock:GetTall()*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                                surface.SetDrawColor( 255,255,255,255 )
                                surface.SetMaterial( mats[k] )
                                surface.DrawTexturedRect( 0, 0, PlayerBlock:GetTall(), PlayerBlock:GetTall() )
                            end
            
                            local WhiteHighlight = vgui.Create( "DButton", PlayerBlock )
                            WhiteHighlight:SetPos( 0, 0 )
                            WhiteHighlight:SetSize( PlayerBlock:GetWide(), PlayerBlock:GetTall() )
                            WhiteHighlight:SetText("")
                            WhiteHighlight.Paint = function()
                                if WhiteHighlight:IsHovered() or WhiteHighlight.Loading then
                                    surface.SetDrawColor( 120,120,120,10 )
                                    if WhiteHighlight.Loading then
                                        local fader = math.abs(math.sin(CurTime() * 2));
                                        surface.SetDrawColor( 150*fader,20,20,25 )
                                    end
                                    surface.SetMaterial( gradient )
                                    surface.DrawTexturedRect( 0, 0, WhiteHighlight:GetWide(), WhiteHighlight:GetTall() )
                                end
                            end
            
                            WhiteHighlight.DoClick = function()
                                ChosenBlip = v[1]
                                ChosenBlipMat = Material(ChosenBlip)
                            end
                        end
                    end
                end
                MakeSearch()
            
                local Search = vgui.Create( "DTextEntry", BlipPanel)
                Search:SetSize(BlipPanel:GetWide()*0.9,BlipPanel:GetTall()*0.07)
                Search:SetPos(BlipPanel:GetWide()*0.05, BlipPanel:GetTall()*0.225)
                Search:SetUpdateOnType( true )
                Search:SetTabPosition( 1 )
                Search:SetDrawBackground(false)
                Search:SetFont("HudBlipBrowserFont")
                Search.OldPaint = Search.Paint
                Search:SetToolTip("Make a derp search")
                function Search:Paint()
            
                    draw.RoundedBox( 0, 0, 0, Search:GetWide(), Search:GetTall(), Color(200,200,200,255 * (math.abs(math.sin(CurTime()*4))))) -- outline
                    draw.RoundedBox( 0, 1, 1, Search:GetWide()-2, Search:GetTall()-2, Color(33,33,33,255))
            
                    self:OldPaint(self:GetWide(), self:GetTall())
                    Search:SetTextColor( Color(255,255,255) )
                    Search:SetPlaceholderText("Search")
                    Search:SetCursorColor(Color(255, 255, 255,255))
                end
                function Search:OnValueChange(KEY)
                    browser:Remove()
                    MakeSearch(Search:GetText())
                end

                local ColorNode = vgui.Create("DButton", BlipPanel)
                ColorNode:SetText("")
                ColorNode:SetSize(BlipPanel:GetWide(), BlipPanel:GetTall()*0.05)
                ColorNode:SetPos(0,150)
                ColorNode.ChosenColor = Color(255,255,255,255)
                local Mixer
                ColorNode.DoClick = function(bool)
            
                    ColorNode:Shake(0.5)
            
                    if IsValid(ColorNode.Col) then
                        ColorNode.Col:Remove()
                    end
            
                    ColorNode.Col = vgui.Create("PFrame",Panel)
                    ColorNode.Col.GlowingOutline = true
                    ColorNode.Col:SetSize(300,350)
                    local x,y = BlipPanel:GetPos()
                    ColorNode.Col:SetPos(x+(BlipPanel:GetWide()/2)-150,y+(BlipPanel:GetTall()/2)-50)
                    ColorNode.Col:CloseButton( true )
                    ColorNode.Col:Title("Change Blip Color")
                    ColorNode.Col:MakePopup()
            
                    Mixer = vgui.Create( "DColorMixer", ColorNode.Col )
                    Mixer:SetPos(0,50)
                    Mixer:SetSize(ColorNode.Col:GetWide(),ColorNode.Col:GetTall()-100)
                    Mixer:SetPalette( false )
                    Mixer:SetAlphaBar( true )
                    Mixer:SetWangs( false )
                    Mixer:SetColor( ColorNode.ChosenColor )
            
                    local p = ColorNode.Col
                    local r = vgui.Create( "DTextEntry", p)
                    r:SetSize(70,30)
                    r:SetPos(((p:GetWide()/4)*1)-(r:GetWide()/2), p:GetTall()-40)
                    r:SetUpdateOnType( true )
                    r:SetTabPosition( 1 )
                    r:SetDrawBackground(false)
                    r:SetFont("HudBlipBrowserFont")
                    r.OldPaint = r.Paint
                    function r:Paint()
                        draw.RoundedBox( 0, 0, 0, r:GetWide(), r:GetTall(), Color(200,200,200,255 * (math.abs(math.sin(CurTime()*8))))) -- outline
                        draw.RoundedBox( 0, 1, 1, r:GetWide()-2, r:GetTall()-2, Color(33,33,33,255))
                        self:OldPaint(self:GetWide(), self:GetTall())
                        r:SetTextColor( Color(255,255,255) )
                        r:SetPlaceholderText("r")
                        r:SetCursorColor(Color(255, 255, 255,255))
                        self:SetValue(Mixer:GetColor().r)
                    end
                    function r:OnValueChange(KEY)
                        if isnumber(tonumber(r:GetValue())) then
                            Mixer:SetColor( Color(tonumber(r:GetValue()),Mixer:GetColor().g,Mixer:GetColor().b) )
                        elseif istable(string.Explode(",", r:GetValue())) and #(string.Explode(",", r:GetValue())) > 1 then
                            for k, v in pairs(string.Explode(",", r:GetValue())) do
                                if k == 1 then
                                    if tonumber(v) then
                                        Mixer:SetColor( Color( tonumber(v),Mixer:GetColor().g,Mixer:GetColor().b ) )
                                    end
                                elseif k == 2 then
                                    if tonumber(v) then
                                        Mixer:SetColor( Color( Mixer:GetColor().r,tonumber(v),Mixer:GetColor().b ) )
                                    end
                                elseif k == 3 then
                                    if tonumber(v) then
                                        Mixer:SetColor( Color( Mixer:GetColor().r,Mixer:GetColor().g,tonumber(v) ) )
                                    end
                                end
                            end
                            if isnumber(tonumber(string.Explode(",", r:GetValue())[1])) then
                                r:SetValue(string.Explode(",", r:GetValue())[1])
                            end
                        end
                    end
            
                    local g = vgui.Create( "DTextEntry", p)
                    g:SetSize(70,30)
                    g:SetPos(((p:GetWide()/4)*2)-(g:GetWide()/2), p:GetTall()-40)
                    g:SetUpdateOnType( true )
                    g:SetTabPosition( 1 )
                    g:SetDrawBackground(false)
                    g:SetFont("HudBlipBrowserFont")
                    g.OldPaint = g.Paint
                    function g:Paint()
                        draw.RoundedBox( 0, 0, 0, g:GetWide(), g:GetTall(), Color(200,200,200,255 * (math.abs(math.sin(CurTime()*8))))) -- outline
                        draw.RoundedBox( 0, 1, 1, g:GetWide()-2, g:GetTall()-2, Color(33,33,33,255))
                        self:OldPaint(self:GetWide(), self:GetTall())
                        g:SetTextColor( Color(255,255,255) )
                        g:SetPlaceholderText("g")
                        g:SetCursorColor(Color(255, 255, 255,255))
                        self:SetValue(Mixer:GetColor().g)
                    end
                    function g:OnValueChange(KEY)
                        if isnumber(tonumber(r:GetValue())) then
                            Mixer:SetColor( Color( Mixer:GetColor().r,tonumber(g:GetValue()),Mixer:GetColor().b ) )
                        end
                    end
            
                    local b = vgui.Create( "DTextEntry", p)
                    b:SetSize(70,30)
                    b:SetPos(((p:GetWide()/4)*3)-(r:GetWide()/2), p:GetTall()-40)
                    b:SetUpdateOnType( true )
                    b:SetTabPosition( 1 )
                    b:SetDrawBackground(false)
                    b:SetFont("HudBlipBrowserFont")
                    b.OldPaint = b.Paint
                    function b:Paint()
                        draw.RoundedBox( 0, 0, 0, b:GetWide(), b:GetTall(), Color(200,200,200,255 * (math.abs(math.sin(CurTime()*8))))) -- outline
                        draw.RoundedBox( 0, 1, 1, b:GetWide()-2, b:GetTall()-2, Color(33,33,33,255))
                        self:OldPaint(self:GetWide(), self:GetTall())
                        b:SetTextColor( Color(255,255,255) )
                        b:SetPlaceholderText("b")
                        b:SetCursorColor(Color(255, 255, 255,255))
                        self:SetValue(Mixer:GetColor().b)
                    end
                    function b:OnValueChange(KEY)
                        if isnumber(tonumber(r:GetValue())) then
                            Mixer:SetColor( Color( Mixer:GetColor().r,Mixer:GetColor().g,tonumber(b:GetValue()) ) )
                        end
                    end
            
                end
                ColorNode.Paint = function(w,h)
                    if IsValid(Mixer) then
                        ColorNode.ChosenColor = Mixer:GetColor()
                        ChosenBlipColor = Mixer:GetColor()
                    end
                    DisableClipping(true)
                    if ColorNode.ShakeTime > CurTime() then
                        local dif = CurTime() - ColorNode.ShakeTime
                        local fader = (math.sin(CurTime() * 40)) * 0.5
                        ColorNode.ShakeX = (8*fader)*(dif)
                    end
                    draw.RoundedBox(5, ((BlipPanel:GetWide()/2)-(150/2))+ColorNode.ShakeX, (ColorNode:GetTall()/2) - 10, 150, 20, ColorNode.ChosenColor)
                    draw.SimpleTextOutlined("BLIP COLOR", "HudBlipBrowserFont", ColorNode:GetWide()/2, ColorNode:GetTall()*0.5, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                    DisableClipping(false)
                end
                ColorNode:SetToolTip("Set the blips color")
                ColorNode.ShakeX = 0
                ColorNode.ShakeY = 0
                ColorNode.ShakeTime = 0
                function ColorNode:Shake(Time)
                    self.ShakeTime = CurTime() + Time
                end

            end
        end
    end

    local SaveAndClose = vgui.Create("PButton",Panel)
    SaveAndClose:SetSize(200,30)
    SaveAndClose:Text("Save & Close")
    SaveAndClose:SetPos((Panel:GetWide()/3)-(SaveAndClose:GetWide()/2), (Panel:GetTall()-25)-(SaveAndClose:GetTall()/2))
    function SaveAndClose:DoClick()
        PlaySoundEffect()
        if LocalPlayer():IsSuperAdmin() then
            net.Start("paris_adminupdatehudsettings")
            -- First what the clients are allowed to change
            net.WriteTable(AdminChanged)
            net.SendToServer()
        end
        for k, v in pairs(Changed) do
            if paris.AllowedChange and paris.AllowedChange[k] then
                paris.HUDSettings[k] = v
            end
        end
        file.Write(ConfigPath, util.TableToJSON(paris.HUDSettings, true))
        net.Start("ReloadHUDBlips")
        net.SendToServer()
    end

    local ResetToDefault = vgui.Create("PButton",Panel)
    ResetToDefault:SetSize(200,30)
    ResetToDefault:Text("Reset To Default")
    ResetToDefault:SetPos(((Panel:GetWide()/3)*2)-(ResetToDefault:GetWide()/2), (Panel:GetTall()-25)-(ResetToDefault:GetTall()/2))
    local function ResetNormal()
        for k, v in pairs(DefaultClientOptions) do
            if paris.AllowedChange and paris.AllowedChange[k] then
                paris.HUDSettings[k] = v
            end
        end
        file.Write(ConfigPath, util.TableToJSON(paris.HUDSettings, true))
        Panel:Remove()
        LocalPlayer():ConCommand("gtahud")
    end
    local function ResetAdmin()
        net.Start("paris_resetadminsettings")
        net.SendToServer()
        net.Receive("ReceiveServerSettings", function()
            ReceiveServerSettings()
            if IsValid(Panel) then
                Panel:Remove()
                LocalPlayer():ConCommand("gtahud")
            end
        end)
    end
    function ResetToDefault:DoClick()
        PlaySoundEffect()
        if LocalPlayer():IsSuperAdmin() then
            local Menu = DermaMenu()
            Menu:AddOption( "Reset Local Options", function() 
                ResetNormal()
            end)
            Menu:AddOption( "Reset Changable Options", function() 
                ResetAdmin()
            end)
            Menu:Open()
        else
            ResetNormal()
        end
        net.Start("ReloadHUDBlips")
        net.SendToServer()
    end

    if LocalPlayer():IsAdmin() then
        local Reload = vgui.Create("DButton",Panel)
        Reload:SetSize(30,30)
        Reload:SetText("")
        Reload:SetPos(10, (Panel:GetTall()-25)-(Reload:GetTall()/2))
        function Reload:DoClick()
            PlaySoundEffect()
            net.Start("RequestNewBlips")
            net.SendToServer()
        end
        local RefreshMaterial = Material("paris/refresh.png")
        local Rot = 0
        function Reload:Paint()
            DisableClipping(true)
            if self:IsHovered() then
                Rot = Rot + (200 * FrameTime())
                surface.SetMaterial(RefreshMaterial)
                surface.SetDrawColor(255, 255, 255, ((math.sin(CurTime()*5)+1)*100)+20)
                surface.DrawTexturedRectRotated( self:GetWide()/2, self:GetTall()/2,self:GetWide(), self:GetTall(), Rot )
            else
                surface.SetMaterial(RefreshMaterial)
                surface.SetDrawColor(255, 255, 255, 20)
                surface.DrawTexturedRectRotated( self:GetWide()/2, self:GetTall()/2,self:GetWide(), self:GetTall(), Rot )
            end
            DisableClipping(false)
        end
    end


end)

concommand.Add("reloadblips", function()
    net.Start("ReloadHUDBlips")
    net.SendToServer()
end)