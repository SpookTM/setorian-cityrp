local dataHeight = 60;

function PLUGIN:Tick()
    local client = LocalPlayer();
    if not (client:IsValid() and client:Alive() and client:GetCharacter()) then
        return;
    end;

    for entity, bDraw in pairs(ix.tv.instances) do
        if (IsValid(entity) and bDraw) then
            render.PushRenderTarget(entity.texture)
            if entity:GetTurned() then
                local w, h = entity.material:Width(), entity.material:Height();
                local channels = ix.tv.channel.instances;
                if next(channels) ~= nil then
                    local channel = channels[ entity:GetChannel() ];
                    if channel then
                        local stream = channel:IsStreaming();
                        if stream and stream.vector then
                            render.RenderView({
                                origin = stream.vector,
                                angles = stream.angles,
                                fov = 90,
                                aspect = 2,
                                x = 0,
                                y = 0,
                                w = 512,
                                h = 256,
                                drawviewmodel = false
                            })
                        else
                            render.Clear(0, 0, 0, 255, false, true)
                        end;
                        cam.Start2D()
                            if not stream then
                                ix.tv.channel.DrawNoSignal(w, h)
                            end;
                            surface.SetDrawColor(170, 50, 50, 100)
                            surface.DrawRect(0, h - dataHeight, w, dataHeight)
                        
                            surface.SetFont( "DermaDefault" )
                            local nameW = surface.GetTextSize(channel.name);
                            surface.SetTextColor( 255, 255, 255 )
                            surface.SetTextPos( w - nameW - 8, 8 )
                            surface.DrawText(channel.name)

                            draw.SimpleText(channel.title, "CloseCaption_Bold", 10, h - dataHeight + 8)
                            draw.SimpleText(channel.topic, "Trebuchet18", 11, h - dataHeight + 34)
                        cam.End2D()

                        entity:SetSubMaterial(1, "!" .. entity.material:GetName())
                        entity.material:SetTexture("$basetexture", entity.texture)
                    end;
                else
                    ix.tv.channel.DrawNoSignal(w, h)
                end;
            else
                entity.material:SetTexture("$basetexture", entity.texture)
                entity:SetSubMaterial(1, "!" .. entity.material:GetName())
                render.Clear(0, 0, 0, 255, false, true)
            end;
            render.PopRenderTarget()
        end
    end
end;

function PLUGIN:HUDPaint()
    local client = LocalPlayer();
    if not (client:IsValid() and client:Alive() and client:GetCharacter()) then
        return;
    end;

    ix.tv.channel.DrawStreamOverlay()

    local trace = client:GetEyeTrace()

    if ix.tv.transporting then
        if not ix.tv.transport_model then
            ix.tv.transport_model = ents.CreateClientProp( "models/sonysmarttv42inch/sonysmarttv42inch.mdl" )
            ix.tv.transport_model:SetSolid( SOLID_VPHYSICS )
            ix.tv.transport_model:SetMoveType( MOVETYPE_NONE )
            ix.tv.transport_model:SetNotSolid( true )
            ix.tv.transport_model:SetRenderMode( RENDERMODE_TRANSALPHA )
            ix.tv.transport_model:SetMaterial("models/wireframe")
            ix.tv.transport_model:Spawn()
            ix.tv.transport_model.yaw = 0;
        else            
            local position = ix.tv.transport_model:GetPos()
            local obbMins, obbMaxs = ix.tv.transport_model:OBBMins(), ix.tv.transport_model:OBBMaxs()

            if input.IsMouseDown( MOUSE_LEFT ) then
                ix.tv.transport_model.yaw = ix.tv.transport_model.yaw + 0.5;
            end;
        
            if input.IsMouseDown( MOUSE_RIGHT ) then
                ix.tv.transport_model.yaw = ix.tv.transport_model.yaw - 0.5;
            end;

            -- Accept
            if input.IsKeyDown( input.GetKeyCode( input.LookupBinding( "+reload", true ) ) ) then
                net.Start("ix.tv.transporting.finish")
                    net.WriteBool( true )
                    net.WriteVector( obbMaxs )
                    net.WriteFloat(ix.tv.transport_model.yaw)
                net.SendToServer()

                ix.tv.transporting = nil;
            end;

            timer.Simple(1, function()
                if ix.tv.transport_model then
                -- Decline;
                    if input.IsKeyDown( input.GetKeyCode( input.LookupBinding( "+use", true ) ) ) then
                        net.Start("ix.tv.transporting.finish")
                            net.WriteBool( false )
                        net.SendToServer()

                        ix.tv.transporting = nil;
                    end;
                end;
            end)
        
            ix.tv.transport_model:SetPos( trace.HitPos + trace.HitNormal * obbMaxs.z )
            ix.tv.transport_model:SetAngles( Angle( 0, ix.tv.transport_model.yaw, 0 ) )
            
            local hullTrace = util.TraceHull( {
                start = position,
                endpos = position,
                mins = obbMins,
                maxs = obbMaxs
            } )
            if hullTrace.Hit then
                ix.tv.transport_model:SetColor( Color( 255, 100, 100, 150 ) )
            else
                ix.tv.transport_model:SetColor( Color( 255, 255, 255, 150 ) )
            end;
        end;
    else
        if ix.tv.transport_model then
            ix.tv.transport_model:SetNoDraw( true )
            timer.Simple(0.5, function()
                if ix.tv.transport_model then
                    ix.tv.transport_model:Remove();
                end;
                ix.tv.transport_model = nil;
            end);
        end;
    end;
end;