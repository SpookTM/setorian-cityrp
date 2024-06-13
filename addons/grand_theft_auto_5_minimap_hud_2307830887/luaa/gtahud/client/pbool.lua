local PANEL = {}

function PANEL:Init()
	self:SetSize( 60, 30 )
    self:Center()
    self.ShakeX = 0
    self.ShakeY = 0
    self.ShakeTime = 0
end

function PANEL:Paint( w, h )
    DisableClipping(true)
    if self.ShakeTime > CurTime() then
        local dif = CurTime() - self.ShakeTime
        local fader = (math.sin(CurTime() * 40)) * 0.5
        self.ShakeX = (8*fader)*(dif)
    end

    if self.Active then
        local fader = math.abs(math.sin(CurTime() * 2))
        draw.RoundedBox( 5, 5*fader, 5*fader, w-(10*fader), h-(10*fader), Color( 33, 255, 33, (100*fader) ) )
    end
    draw.RoundedBox( 5, 4 + self.ShakeX, 4 + self.ShakeY, w-8, h-8, Color( 0, 0, 0, 255 ) )
    draw.RoundedBox( 5, 5 + self.ShakeX, 5 + self.ShakeY, w-10, h-10, Color( 66, 66, 66, 255 ) )
    draw.RoundedBox( 5, 7 + self.ShakeX, 7 + self.ShakeY, w-14, h-14, Color( 44, 44, 44, 255 ) )
    if !self.Active then
        draw.RoundedBox( 5, 5 + self.ShakeX, 5 + self.ShakeY, ((w-10)/2), h-10, Color( 255, 66, 66, 255 ) )
        draw.RoundedBox( 5, 7 + self.ShakeX, 7 + self.ShakeY, ((w-12)/2), h-14, Color( 150, 66, 66, 255 ) )
    else
        draw.RoundedBox( 5, (5 + (w-10)/2) + self.ShakeX, 5 + self.ShakeY, (w-10)/2, h-10, Color( 66, 255, 66, 255 ) )
        draw.RoundedBox( 5, (7 + (w-12)/2) + self.ShakeX, 7 + self.ShakeY, (w-14)/2, h-14, Color( 66, 150, 66, 255 ) )
    end
    DisableClipping(false)
end

function PANEL:DoClick()
    if !self.AdminMode then
        if !paris.AllowedChange[self.Key] and !self.Surpass then
            self:Shake(2)
            return
        end
    end
    self:Shake(0.5)
    self.Active = !self.Active
    if self.OnDoClick then self.OnDoClick(self.Active) end
end

function PANEL:Shake(Time)
    self.ShakeTime = CurTime() + Time
end

vgui.Register( "PBool", PANEL, "DButton" )