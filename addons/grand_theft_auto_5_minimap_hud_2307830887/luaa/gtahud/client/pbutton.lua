local PANEL = {}

function PANEL:Init()
	self:SetSize( 100, 100 )
    self:Center()
    self.GradientUp = Material( "gui/gradient_up" )
    self:SetText("")
end

local OutLine = Material("paris/hudoutlinefull.png")
function PANEL:Paint( w, h )
    --[[local x, y = self:LocalToScreen( 0, 0 )

    local Fraction = 1.9

    local matBlurScreen = Material( "pp/blurscreen" )
    surface.SetMaterial( matBlurScreen )
    surface.SetDrawColor( 255, 255, 255, 255 )

    for i=0.33, 1, 0.33 do
        matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
        matBlurScreen:Recompute()
        if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
        surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
    end]]

    if self:IsHovered() then
        surface.SetDrawColor( 66, 66, 66, 150 )
        surface.DrawRect( 0, 0, ScrW(), ScrH() )
    else
        surface.SetDrawColor( 22, 22, 22, 150 )
        surface.DrawRect( 0, 0, ScrW(), ScrH() )
    end

    DisableClipping(true)
        surface.SetMaterial(OutLine)
        surface.SetDrawColor(255, 255, 255, 200)
        if paris.HUDSettings["DrawOutline"] then
            local safezonex = (25*self:GetWide())/300
            local safezoney = (25*self:GetTall())/200
            surface.DrawTexturedRect((safezonex*-1), safezoney*-1, self:GetWide()+(safezonex*2)-1, self:GetTall()+(safezoney*2))
        end
    DisableClipping(false)

    --draw.RoundedBox( 0, 0, 0, w, h, Color( 22, 22, 22, 255 ) )
    draw.SimpleTextOutlined(self.text or "", "HudSettingsFont", self:GetWide()/2, self:GetTall()/2, Color(200,200,200,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(255,255,255,255))
    --[[surface.SetDrawColor( 44,44,44, 255 )
    surface.SetMaterial( self.GradientUp )
    surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )]]
end

function PANEL:Text( Text )
    self.text = Text
end

vgui.Register( "PButton", PANEL, "DButton" )