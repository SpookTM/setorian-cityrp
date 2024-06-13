local PANEL = {}

function PANEL:Init()
    local sbar = self:GetVBar()
    function sbar:Paint( w, h )
        draw.RoundedBox( 10, 0, 0, w, h, Color( 125, 125, 125, 100 ) )
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
end

vgui.Register( "PScrollPanel", PANEL, "DScrollPanel" )