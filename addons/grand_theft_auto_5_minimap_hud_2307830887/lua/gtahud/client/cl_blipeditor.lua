
// Dark Scroll Bar
function PARIS_DrawDarkScrollPanel( Parent )
    local ScrollPanel = vgui.Create("DScrollPanel", Panel)
    ScrollPanel:SetParent( Parent )
    local sbar = ScrollPanel:GetVBar()
    function sbar:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
    end
    function sbar.btnUp:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, Color( 20, 20, 20, 100 ) )
    end
    function sbar.btnDown:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, Color( 20, 20, 20, 100 ) )
    end
    function sbar.btnGrip:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, Color( 15, 15, 15, 200 ) )
    end
    return ScrollPanel
end

// LERPED TextEntry
function PARIS_LerpedTextEntry( Parent )
    local Text = vgui.Create( "DTextEntry")
    Text:SetDrawBackground(false)
    Text:SetParent(Parent)
    Text.Starting = 0
    Text.Ending = 0
    Text.OtherAxis = 0
    Text.YAxis = false
    Text.OldPaint = Text.Paint
    Text.BackgroundColor = Color(255,255,255,0)
    Text.HighlightedBackgroundColor = Color(255,255,255,0)
    Text:SetTextColor( Color(255,255,255,255) )

    function Text:Paint()
        self:OldPaint(self:GetWide(), self:GetTall())

        if Text:IsHovered() then
            draw.RoundedBox( 2, 0, 0, Text:GetWide(), Text:GetTall(), Text.HighlightedBackgroundColor)
        else
            draw.RoundedBox( 2, 0, 0, Text:GetWide(), Text:GetTall(), Text.BackgroundColor)
        end

        --[[if DEV_MODE then
            draw.RoundedBox( 2, 0, 0, Text:GetWide(), Text:GetTall(), Color(22,22,152,50))
        end]]

        // LERP
        --timer.Simple( Text.Delay * 0.01, function()
            if !Text.YAxis then
                Text.Starting = Lerp( 10 * FrameTime() , Text.Starting , Text.Ending)
                Text:SetPos( Text.Starting, Text.OtherAxis )
            else
                Text.Starting = Lerp( 10 * FrameTime() , Text.Starting , Text.Ending)
                Text:SetPos( Text.OtherAxis, Text.Starting )
            end
        --end)
    end

    return Text

end

local LastOption = 25

concommand.Add("blip_add", function(ply)

    if (!ply:IsSuperAdmin()) then return end

    local Editor = vgui.Create("PFrame")

    local scrw,scrh = paris.ScreenRatio(1920, 1080,ScrW(),ScrH())

    surface.CreateFont("HudBlipEditorFont", {
        font = "Roboto Thin",
        extended = false,
        size = 20,
    } )

    Editor:SetSize(scrw*0.2,scrh*0.6)
    Editor:Center()
    Editor:CloseButton( true )
    Editor:Title("Add HUD Blip")
    Editor.GlowingOutline = true
    Editor:MakePopup()

    local gradient = Material( "gui/gradient_up" )

    local ColorNode = vgui.Create("DButton", Editor)
    ColorNode:SetText("")
    ColorNode:SetSize(Editor:GetWide(), Editor:GetTall()*0.05)
    ColorNode:SetPos(0,Editor:GetTall()*0.08)
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
        local x,y = Editor:GetPos()
        ColorNode.Col:SetPos(x+(Editor:GetWide()/2)-150,y+(Editor:GetTall()/2)-50)
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
        r:SetFont("HudBlipEditorFont")
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
        g:SetFont("HudBlipEditorFont")
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
        b:SetFont("HudBlipEditorFont")
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
        end
        DisableClipping(true)
        if ColorNode.ShakeTime > CurTime() then
            local dif = CurTime() - ColorNode.ShakeTime
            local fader = (math.sin(CurTime() * 40)) * 0.5
            ColorNode.ShakeX = (8*fader)*(dif)
        end
        draw.RoundedBox(5, ((Editor:GetWide()/2)-(150/2))+ColorNode.ShakeX, (ColorNode:GetTall()/2) - 10, 150, 20, ColorNode.ChosenColor)
        draw.SimpleTextOutlined("BLIP COLOR", "HudBlipEditorFont", ColorNode:GetWide()/2, ColorNode:GetTall()*0.5, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
        DisableClipping(false)
    end
    ColorNode:SetToolTip("Set the blips color")
    ColorNode.ShakeX = 0
    ColorNode.ShakeY = 0
    ColorNode.ShakeTime = 0
    function ColorNode:Shake(Time)
        self.ShakeTime = CurTime() + Time
    end

    local slider = vgui.Create("DNumSlider", Editor)
    slider:SetMin(0)
    slider:SetMax(10000)
    slider:SetPos(Editor:GetWide()*0.05, ColorNode:GetTall() + (Editor:GetTall()*0.065))
    slider:SetSize(Editor:GetWide() - (Editor:GetWide()*0.1),(Editor:GetTall()*0.1))
    slider:SetDark(true)
    slider:SetValue(5000)
    slider:SetDefaultValue(5000)
    slider:SetText("Fade Distance")
    slider:SetToolTip("The distance it takes from LocalPlayer to the blip to fade away")

    local ShowInAllZones = vgui.Create("DCheckBoxLabel", Editor)
    ShowInAllZones:SetChecked(false)
    ShowInAllZones:SetPos(Editor:GetWide()*0.05, ColorNode:GetTall() + (Editor:GetTall()*0.14))
    ShowInAllZones:SetSize(Editor:GetWide() - (Editor:GetWide()*0.1),(Editor:GetTall()*0.1))
    ShowInAllZones:SetDark(true)
    ShowInAllZones:SetText("Show In All Zones")
    ShowInAllZones:SetToolTip("If TRUE then it is *, if FALSE it will only save to show in your current zone.")

    local browser
    local function MakeSearch(Needle)
        browser = PARIS_DrawDarkScrollPanel( Editor )
        browser:SetPos(0,121 + Editor:GetTall() * 0.125)
        browser:SetSize(Editor:GetWide(), Editor:GetTall() * (0.7-(0.025)))
        local layout = vgui.Create("DListLayout", browser)
        layout:SetSize(browser:GetWide(), browser:GetTall() / 15)
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
                    draw.SimpleTextOutlined(text, "HudBlipEditorFont", PlayerBlock:GetTall() + (PlayerBlock:GetWide()*0.05), PlayerBlock:GetTall()*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
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
                    local AreUSure = vgui.Create("DFrame")
                    AreUSure:SetTitle("")
                    AreUSure:SetSize(500, 200)
                    AreUSure:SetPos((ScrW()-500)/2,(ScrH()-200)/2)
                    AreUSure:MakePopup()
                    AreUSure:SetBackgroundBlur(true)
                    AreUSure:ShowCloseButton(false)
                    AreUSure.OldPaint = AreUSure.Paint
                    function AreUSure:Paint(a,b,c,d,e,f)
                        AreUSure:OldPaint(a,b,c,d,e,f)
                        draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(22,22,22,255))
                        draw.SimpleTextOutlined("Are you sure you want to add a blip at:", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                        draw.SimpleTextOutlined("x:" .. LocalPlayer():GetPos().x .. "   y:" .. LocalPlayer():GetPos().y, "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                        draw.SimpleTextOutlined("using the icon: " .. v[1], "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                    end
                    local Yes = vgui.Create("DButton",AreUSure)
                    Yes:SetSize(200,40)
                    Yes:SetPos((AreUSure:GetWide()-200)/2, AreUSure:GetTall()*0.5)
                    Yes:SetText("")
                    function Yes:Paint()
                        if self:IsHovered() then
                            draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,150))
                            draw.SimpleTextOutlined("YES I'M SURE", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(194, 217, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                        else
                            draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,50))
                            draw.SimpleTextOutlined("YES I'M SURE", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                        end
                    end
                    Yes.DoClick = function()

                        AreUSure:Remove()

                        local zone = paris.Zone or "*"

                        if ShowInAllZones:GetChecked() then
                            zone = "*"
                        end

                        net.Start("AddHUDBlip")
                            net.WriteTable({

                                Pos = {x = LocalPlayer():GetPos().x, y = LocalPlayer():GetPos().y, z = 0},
                                Icon = v[1],
                                Scale = 30,
                                Color = ColorNode.ChosenColor,
                                Zone = zone,
                                FadeDistance = slider:GetValue()

                            })
                        net.SendToServer()

                        AreUSure:Remove()

                    end
                    local No = vgui.Create("DButton",AreUSure)
                    No:SetSize(200,40)
                    No:SetPos((AreUSure:GetWide()-200)/2, (AreUSure:GetTall()*0.5) + 41 )
                    No:SetText("")
                    function No:Paint()
                        if self:IsHovered() then
                            draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,150))
                            draw.SimpleTextOutlined("NO", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(194, 217, 255,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                        else
                            draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,50))
                            draw.SimpleTextOutlined("NO", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(255,255,255,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                        end
                    end
                    No.DoClick = function()
                        AreUSure:Remove()
                    end
                end
            end
        end
    end
    MakeSearch()

    local Search = vgui.Create( "DTextEntry", Editor)
    Search:SetSize(Editor:GetWide()*0.75,Editor:GetTall()*0.07)
    Search:SetPos(Editor:GetWide()*0.05, Editor:GetTall()*0.225)
    Search:SetUpdateOnType( true )
    Search:SetTabPosition( 1 )
    Search:SetDrawBackground(false)
    Search:SetFont("HudBlipEditorFont")
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

    local AddMoreDirectories = vgui.Create( "DButton", Editor)
    AddMoreDirectories:SetSize(Editor:GetWide()*0.15,Editor:GetTall()*0.07)
    AddMoreDirectories:SetPos(Editor:GetWide()*0.8, Editor:GetTall()*0.225)
    AddMoreDirectories:SetText("")
    local icon = Material("icon16/folder_add.png")
    AddMoreDirectories:SetToolTip("Add more search directories")
    function AddMoreDirectories:Paint()
        surface.SetMaterial(icon)
        surface.SetDrawColor(255, 255, 255, 255)
        if self:IsHovered() then
            surface.DrawTexturedRect((self:GetWide()/2)-(18/2), (self:GetTall()/2)-(18/2), 18, 18)
        else
            surface.DrawTexturedRect((self:GetWide()/2)-(16/2), (self:GetTall()/2)-(16/2), 16, 16)
        end
    end
    function AddMoreDirectories:DoClick()
        local AreUSure = vgui.Create("DFrame")
        AreUSure:SetTitle("")
        AreUSure:SetSize(500, 350)
        AreUSure:SetPos((ScrW()-500)/2,(ScrH()-200)/2)
        AreUSure:MakePopup()
        AreUSure:SetBackgroundBlur(true)
        AreUSure:ShowCloseButton(false)
        AreUSure.OldPaint = AreUSure.Paint
        function AreUSure:Paint(a,b,c,d,e,f)
            AreUSure:OldPaint(a,b,c,d,e,f)
            draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(22,22,22,255))
            draw.SimpleTextOutlined("Paste the directory you want to add here", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            draw.SimpleTextOutlined('Example Directory: "paris/blips/"', "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            draw.SimpleTextOutlined("Relative to the materials folder", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.35, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
        end
        local TextEntry = vgui.Create( "DTextEntry", AreUSure)
        TextEntry:SetSize(400,50)
        TextEntry:SetPos(50, 150)
        TextEntry:SetTabPosition( 1 )
        TextEntry:SetDrawBackground(false)
        TextEntry:SetFont("HudBlipEditorFont")
        TextEntry.OldPaint = TextEntry.Paint
        function TextEntry:Paint()

            draw.RoundedBox( 0, 0, 0, TextEntry:GetWide(), TextEntry:GetTall(), Color(200,200,200,255 * (math.abs(math.sin(CurTime()*4))))) -- outline
            draw.RoundedBox( 0, 1, 1, TextEntry:GetWide()-2, TextEntry:GetTall()-2, Color(33,33,33,255))

            self:OldPaint(self:GetWide(), self:GetTall())
            TextEntry:SetTextColor( Color(255,255,255) )
            TextEntry:SetPlaceholderText("Message")
            TextEntry:SetCursorColor(Color(255, 255, 255,255))
        end
        local Yes = vgui.Create("DButton",AreUSure)
        Yes:SetSize(200,40)
        Yes:SetPos((AreUSure:GetWide()-200)/2, 220)
        Yes:SetText("")
        function Yes:Paint()
            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,150))
                draw.SimpleTextOutlined("Add", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(194, 217, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            else
                draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,50))
                draw.SimpleTextOutlined("Add", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            end
        end
        Yes.DoClick = function()
            local otherfoldersjson = "gtahudblipfolders.json"
            local otherfolders = util.JSONToTable(file.Read(otherfoldersjson, "DATA") or "{}")
            if not istable(otherfolders) then Error(otherfoldersjson .. " is not properly formatted!!") end
            table.insert(otherfolders, TextEntry:GetValue())
            file.Write(otherfoldersjson, util.TableToJSON(otherfolders, true))
            Editor:Remove()
            LocalPlayer():ConCommand("blip_add")
            AreUSure:Remove()
        end
        local No = vgui.Create("DButton",AreUSure)
        No:SetSize(200,40)
        No:SetPos((AreUSure:GetWide()-200)/2, 265 )
        No:SetText("")
        function No:Paint()
            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,150))
                draw.SimpleTextOutlined("Cancel", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(194, 217, 255,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            else
                draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,50))
                draw.SimpleTextOutlined("Cancel", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(255,255,255,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            end
        end
        No.DoClick = function()
            AreUSure:Remove()
        end


        local RemoveDirectories = vgui.Create( "DButton", AreUSure)
        RemoveDirectories:SetSize(AreUSure:GetWide()*0.2,AreUSure:GetTall()*0.1)
        RemoveDirectories:SetPos(AreUSure:GetWide()*0.8, AreUSure:GetTall()*0.9)
        RemoveDirectories:SetText("")
        local icon = Material("icon16/folder_delete.png")
        RemoveDirectories:SetToolTip("Remove search directories")
        function RemoveDirectories:Paint()
            surface.SetMaterial(icon)
            surface.SetDrawColor(255, 255, 255, 255)
            if self:IsHovered() then
                surface.DrawTexturedRect((self:GetWide()/2)-(18/2), (self:GetTall()/2)-(18/2), 18, 18)
            else
                surface.DrawTexturedRect((self:GetWide()/2)-(16/2), (self:GetTall()/2)-(16/2), 16, 16)
            end
        end

        function RemoveDirectories:DoClick()

            AreUSure:Remove()

            local Frame = vgui.Create("DFrame")
            Frame:SetTitle("")
            Frame:SetSize(500, 350)
            Frame:SetPos((ScrW()-500)/2,(ScrH()-200)/2)
            Frame:MakePopup()
            Frame:SetBackgroundBlur(true)
            Frame:ShowCloseButton(false)
            Frame.OldPaint = Frame.Paint
            function Frame:Paint(a,b,c,d,e,f)
                Frame:OldPaint(a,b,c,d,e,f)
                draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(22,22,22,255))
                draw.SimpleTextOutlined("Remove Directories Below", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            end

            local browser
            local function MakeSearch(Needle)
                browser = PARIS_DrawDarkScrollPanel( Frame )
                browser:SetPos(0,Frame:GetTall() * 0.35)
                browser:SetSize(Frame:GetWide(), Frame:GetTall() * 0.7)
                local layout = vgui.Create("DListLayout", browser)
                layout:SetSize(browser:GetWide(), browser:GetTall() / 7)
                layout:SetPos(0, 0)
        
                local data = file.Read("gtahudblipfolders.json", "DATA")
                local folders = {}
                if istable(util.JSONToTable(data or "{}")) then
                    folders = util.JSONToTable(data or "{}")
                else
                    Error("data/gtahudblipfolders.json is not formatted correctly... fix it!")
                end
        
                for k, v in pairs(folders) do
                    if !Needle or string.find(string.lower(v),string.lower(Needle)) then
                        local PlayerBlock = vgui.Create("DPanel", layout)
                        PlayerBlock:SetSize(layout:GetWide(), layout:GetTall())
                        PlayerBlock:SetPos(0,0)
                        PlayerBlock.Paint = function()
                            draw.RoundedBox(0, 0, 0, PlayerBlock:GetWide(), PlayerBlock:GetTall(), Color( 30, 30, 30, 200 ))
                            surface.SetDrawColor( 20,20,20,200 )
                            surface.SetMaterial( gradient )
                            surface.DrawTexturedRect( 0, 0, PlayerBlock:GetWide(), PlayerBlock:GetTall() )
                            draw.SimpleTextOutlined(v, "HudBlipEditorFont", PlayerBlock:GetTall() + (PlayerBlock:GetWide()*0.05), PlayerBlock:GetTall()*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
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
                            local AreUSure = vgui.Create("DFrame")
                            AreUSure:SetTitle("")
                            AreUSure:SetSize(500, 200)
                            AreUSure:SetPos((ScrW()-500)/2,(ScrH()-200)/2)
                            AreUSure:MakePopup()
                            AreUSure:SetBackgroundBlur(true)
                            AreUSure:ShowCloseButton(false)
                            AreUSure.OldPaint = AreUSure.Paint
                            function AreUSure:Paint(a,b,c,d,e,f)
                                AreUSure:OldPaint(a,b,c,d,e,f)
                                draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(22,22,22,255))
                                draw.SimpleTextOutlined("Are you sure you want to remove the directory:", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                                draw.SimpleTextOutlined(v, "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                            end
                            local Yes = vgui.Create("DButton",AreUSure)
                            Yes:SetSize(200,40)
                            Yes:SetPos((AreUSure:GetWide()-200)/2, AreUSure:GetTall()*0.5)
                            Yes:SetText("")
                            function Yes:Paint()
                                if self:IsHovered() then
                                    draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,150))
                                    draw.SimpleTextOutlined("YES I'M SURE", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(194, 217, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                                else
                                    draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,50))
                                    draw.SimpleTextOutlined("YES I'M SURE", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                                end
                            end
                            Yes.DoClick = function()
        
                                AreUSure:Remove()
        
                                folders[k] = nil

                                file.Write("gtahudblipfolders.json", util.TableToJSON(folders,true))

                                PlayerBlock:Remove()
        
                            end
                            local No = vgui.Create("DButton",AreUSure)
                            No:SetSize(200,40)
                            No:SetPos((AreUSure:GetWide()-200)/2, (AreUSure:GetTall()*0.5) + 41 )
                            No:SetText("")
                            function No:Paint()
                                if self:IsHovered() then
                                    draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,150))
                                    draw.SimpleTextOutlined("NO", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(194, 217, 255,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                                else
                                    draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,50))
                                    draw.SimpleTextOutlined("NO", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(255,255,255,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                                end
                            end
                            No.DoClick = function()
                                AreUSure:Remove()
                            end
                        end
                    end
                end
            end
            MakeSearch()
        
            local Search = vgui.Create( "DTextEntry", Frame)
            Search:SetSize(Frame:GetWide()*0.8,Frame:GetTall()*0.1)
            Search:SetPos(Frame:GetWide()*0.1, Frame:GetTall()*0.2)
            Search:SetUpdateOnType( true )
            Search:SetTabPosition( 1 )
            Search:SetDrawBackground(false)
            Search:SetFont("HudBlipEditorFont")
            Search.OldPaint = Search.Paint
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

            local Done = vgui.Create("DButton",Frame)
            Done:SetSize(200,40)
            Done:SetPos((Frame:GetWide()-200)/2, Frame:GetTall()-60 )
            Done:SetText("")
            function Done:Paint()
                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,150))
                    draw.SimpleTextOutlined("Done", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(194, 217, 255,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                else
                    draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,50))
                    draw.SimpleTextOutlined("Done", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.5, Color(255,255,255,175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                end
            end
            Done.DoClick = function()
                Frame:Remove()
            end

        end

    end

end)