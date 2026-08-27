EnemyPingManager = EnemyPingManager or {}

-- Key Z (Control 20 / 48) Enemy Ping Key Thread
CreateThread(function()
    while true do
        Wait(0)
        -- Key Z (Control 20: INPUT_MULTIPLAYER_INFO / Z key)
        if IsControlJustPressed(0, 20) or IsDisabledControlJustPressed(0, 20) then
            EnemyPingManager.TriggerPing()
        end
    end
end)

function EnemyPingManager.TriggerPing()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) or IsEntityDead(ped) then return end

    -- Raycast line-of-sight target calculation
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local forwardVector = Utils.RotationToDirection(camRot)
    local targetCoords = camCoords + (forwardVector * 300.0)

    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(camCoords.x, camCoords.y, camCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, -1, ped, 0)
    local _, hit, hitCoords, _, _ = GetShapeTestResult(rayHandle)

    local finalCoords = hit == 1 and hitCoords or targetCoords
    local dist = Utils.GetDistance3D(GetEntityCoords(ped), finalCoords)

    -- Play Native Frontend Sound
    PlaySoundFrontend(-1, "MP_AWARD", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

    -- Send Ping Event to Server for Team Broadcast
    TriggerServerEvent("battleground:sv:sendEnemyPing", {
        coords = finalCoords,
        distance = math.round(dist)
    })
end

RegisterNetEvent("battleground:cl:showEnemyPing", function(pingData)
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
    SendNUIMessage({
        action = "showEnemyPing",
        distance = pingData and pingData.distance or 145,
        author = pingData and pingData.author or "Teammate"
    })
end)
