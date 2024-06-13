local PANEL = {}

function PANEL:Init()
	self:SetSize( 100, 100 )
    self:Center()
    self.GradientUp = Material( "gui/gradient_up" )
    self:ShowCloseButton(false)
    self:SetTitle("")
end

local OutLine = Material("paris/hudoutlinefull.png")
local Shadow = Material("paris/panelshadow.png")
local Logo = Material("paris/gtahudlogosmall.png")
function PANEL:Paint( w, h )
    local x, y = self:LocalToScreen( 0, 0 )

    local Fraction = 1.9

    local matBlurScreen = Material( "pp/blurscreen" )
    surface.SetMaterial( matBlurScreen )
    surface.SetDrawColor( 255, 255, 255, 255 )

    for i=0.33, 1, 0.33 do
        matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
        matBlurScreen:Recompute()
        if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
        surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
    end

    surface.SetDrawColor( 77, 77, 77, 230 )
    surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )

    DisableClipping(true)
        surface.SetMaterial(OutLine)
        surface.SetDrawColor(255, 255, 255, 200)
        local x,y = 0,0
        if paris.HUDSettings["DrawOutline"] and self.DrawOutline then
            local safezonex = (25*self:GetWide())/300
            local safezoney = (25*self:GetTall())/200
            surface.DrawTexturedRect((safezonex*-1)+1, (safezoney*-1)+1, self:GetWide()+(safezonex*2)-3, self:GetTall()+(safezoney*2)-2)
        end
        if self.GlowingOutline then
            local f = math.abs(math.sin(CurTime()*4))
            draw.RoundedBox(0, -1, -1, self:GetWide()+2, 1, Color(255*f,255*f,255*f,255))
            draw.RoundedBox(0, -1, -1, 1, self:GetTall()+2, Color(255*f,255*f,255*f,255))
            draw.RoundedBox(0, -1, self:GetTall(), self:GetWide()+2, 1, Color(255*f,255*f,255*f,255))
            draw.RoundedBox(0, self:GetWide(), -1, 1, self:GetTall()+2, Color(255*f,255*f,255*f,255))
        end
        surface.SetMaterial(Shadow)
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawTexturedRect(0, 0, w*2, h*2)
    DisableClipping(false)
    
    --draw.RoundedBox( 0, 0, 0, w, h, Color( 22, 22, 22, 255 ) )
    draw.SimpleTextOutlined(self.Title or "", "HudSettingsFont", 15, 20, Color(200,200,200,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0, Color(255,255,255,255))
    --[[surface.SetDrawColor( 44,44,44, 255 )
    surface.SetMaterial( self.GradientUp )
    surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )]]
end


function PANEL:CloseButton( bool )
    if bool then
        self.CloseButton = vgui.Create("DButton", self)
        self.CloseButton:SetSize(60,30)
        self.CloseButton:SetPos(self:GetWide()-61, 1)
        self.CloseButton:SetText("")
        self.CloseButton.DoClick = function()
            if self.OnClose then
                self:OnClose()
            end
            self:Remove()
        end
        self.CloseButton.Paint = function()
            if self.CloseButton:IsHovered() then
                draw.RoundedBox(0, 0, 0, self.CloseButton:GetWide(), self.CloseButton:GetTall(), Color(88,88,88))
                draw.SimpleTextOutlined("X", "HudSettingsFont", self.CloseButton:GetWide()/2, self.CloseButton:GetTall()/2, Color(166,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(255,255,255,255))
            else
                draw.RoundedBox(0, 0, 0, self.CloseButton:GetWide(), self.CloseButton:GetTall(), Color(44,44,44))
                draw.SimpleTextOutlined("X", "HudSettingsFont", self.CloseButton:GetWide()/2, self.CloseButton:GetTall()/2, Color(255,255,255,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(255,255,255,255))
            end
        end
    elseif self.CloseButton then
        self.CloseButton:Remove()
    end
end

function PANEL:Title( title )
    self.Title = title
end

vgui.Register( "PFrame", PANEL, "DFrame" )