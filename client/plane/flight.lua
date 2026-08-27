ClientFlight = ClientFlight or {}

ClientFlight.Cam = nil

function ClientFlight.StartCameraThread()
    if not ClientFlight.Cam then
        ClientFlight.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end

    SetCamActive(ClientFlight.Cam, true)
    RenderScriptCams(true, true, 1000, true, true)

    CreateThread(function()
        while ClientPlane.InPlane do
            Wait(0)
            local elapsed = (GetGameTimer() - ClientPlane.StartTime) / 1000.0
            local startPos = ClientPlane.FlightPath.startCoords
            local endPos = ClientPlane.FlightPath.endCoords
            local totalDist = Utils.GetDistance3D(startPos, endPos)
            local speed = Config.PlaneSpeed or 60.0
            local travelRatio = math.min(1.0, (elapsed * speed) / totalDist)

            local currentPos = vec3(
                startPos.x + (endPos.x - startPos.x) * travelRatio,
                startPos.y + (endPos.y - startPos.y) * travelRatio,
                startPos.z
            )

            local ped = PlayerPedId()
            SetEntityCoords(ped, currentPos.x, currentPos.y, currentPos.z, false, false, false, false)

            if ClientPlane.PlaneEntity and DoesEntityExist(ClientPlane.PlaneEntity) then
                SetEntityCoords(ClientPlane.PlaneEntity, currentPos.x, currentPos.y, currentPos.z, false, false, false, false)
                SetEntityHeading(ClientPlane.PlaneEntity, ClientPlane.FlightPath.heading or 45.0)
            end

            -- Position cinematic spectator camera behind aircraft
            SetCamCoord(ClientFlight.Cam, currentPos.x - 25.0, currentPos.y - 25.0, currentPos.z + 10.0)
            PointCamAtCoord(ClientFlight.Cam, currentPos.x, currentPos.y, currentPos.z)

            -- Render HUD prompt
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName("Press ~INPUT_JUMP~ [SPACE] or [G] to JUMP FROM PLANE")
            EndTextCommandDisplayHelp(0, false, true, -1)

            -- Auto eject at end of path
            if travelRatio >= 1.0 then
                ClientJump.Eject()
                break
            end
        end

        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(ClientFlight.Cam, false)
        ClientFlight.Cam = nil
        ClientPlane.Cleanup()
    end)
end
