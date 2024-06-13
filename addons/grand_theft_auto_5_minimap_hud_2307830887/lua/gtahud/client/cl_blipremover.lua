
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

concommand.Add("blip_remove", function(ply)

    if (!ply:IsSuperAdmin()) then return end

    local Editor = vgui.Create("PFrame")

    surface.CreateFont("HudBlipEditorFont", {
        font = "Roboto Thin",
        extended = false,
        size = 20,
    } )

    Editor:SetSize(300,400)
    Editor:Center()
    Editor:CloseButton( true )
    Editor:Title("Remove HUD Blips")
    Editor:MakePopup()

    local x = math.Round(LocalPlayer():GetPos().x)
    local y = math.Round(LocalPlayer():GetPos().y)
    local z = math.Round(LocalPlayer():GetPos().z) --// Unused

    local gradient = Material( "gui/gradient_up" )

    browser = PARIS_DrawDarkScrollPanel( Editor )
    browser:SetSize(Editor:GetWide(), Editor:GetTall()-31)
    browser:SetPos(0,31)
    local layout = vgui.Create("DListLayout", browser)
    layout:SetSize(browser:GetWide(), browser:GetTall() / 10)
    layout:SetPos(0, 0)

    local tab = paris.MapBlips

    local lp = LocalPlayer():GetPos()
    table.sort( tab, function(a, b)
        if !b then return a end
        if !a then return b end
        return math.Dist(math.Round(a.Pos.x), math.Round(a.Pos.y), math.Round(lp.x), math.Round(lp.x)) < math.Dist(math.Round(b.Pos.x), math.Round(b.Pos.y), math.Round(lp.x), math.Round(lp.x)) 
    end )

    local mats = {}
    for k, v in pairs(tab) do
        mats[k] = Material(v.Icon)

        local PlayerBlock = vgui.Create("DPanel", layout)
        PlayerBlock:SetSize(layout:GetWide(), layout:GetTall())
        PlayerBlock:SetPos(0,0)
        PlayerBlock.Paint = function()
            draw.RoundedBox(0, 0, 0, PlayerBlock:GetWide(), PlayerBlock:GetTall(), Color( 30, 30, 30, 200 ))
            surface.SetDrawColor( 20,20,20,200 )
            surface.SetMaterial( gradient )
            surface.DrawTexturedRect( 0, 0, PlayerBlock:GetWide(), PlayerBlock:GetTall() )
            local text = k .. ": " .. v.Icon
            draw.SimpleTextOutlined(text, "HudBlipEditorFont", PlayerBlock:GetTall() + (PlayerBlock:GetWide()*0.05), PlayerBlock:GetTall()*0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
            surface.SetDrawColor( v.Color.r,v.Color.g,v.Color.b,v.Color.a )
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
                draw.SimpleTextOutlined("Are you sure you want to remove a blip at:", "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                draw.SimpleTextOutlined("x:" .. v.Pos.x .. "   y:" .. v.Pos.y, "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
                draw.SimpleTextOutlined("using the icon: " .. v.Icon, "HudBlipEditorFont", self:GetWide()/2, self:GetTall()*0.4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0,255))
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

                net.Start("RemoveHUDBlip")
                    net.WriteTable({key = v.ID})
                net.SendToServer()

                AreUSure:Remove()
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

end)