SpectateManager = SpectateManager or {}
SpectateManager.IsSpectating = false
SpectateManager.Teammates = {}
SpectateManager.CurrentIndex = 1

RegisterNetEvent("battleground:cl:startSpectate", function(teammates)
    SpectateManager.Teammates = teammates or {}
    if #SpectateManager.Teammates == 0 then return end

    SpectateManager.IsSpectating = true
    SpectateManager.CurrentIndex = 1
    SpectateManager.UpdateTarget(false)

    -- Spectate key thread (Q & E keys)
    CreateThread(function()
        while SpectateManager.IsSpectating do
            Wait(0)
            -- Q Key (Prev Teammate)
            if IsControlJustPressed(0, 44) then
                SpectateManager.CurrentIndex = SpectateManager.CurrentIndex - 1
                if SpectateManager.CurrentIndex < 1 then
                    SpectateManager.CurrentIndex = #SpectateManager.Teammates
                end
                SpectateManager.UpdateTarget(false)
            -- E Key (Next Teammate)
            elseif IsControlJustPressed(0, 38) then
                SpectateManager.CurrentIndex = SpectateManager.CurrentIndex + 1
                if SpectateManager.CurrentIndex > #SpectateManager.Teammates then
                    SpectateManager.CurrentIndex = 1
                end
                SpectateManager.UpdateTarget(false)
            end
        end
    end)

    -- Real-time 500ms Health & Stats Sync Thread
    CreateThread(function()
        while SpectateManager.IsSpectating do
            Wait(500)
            SpectateManager.UpdateTarget(true)
        end
    end)
end)

RegisterNetEvent("battleground:cl:stopSpectate", function()
    SpectateManager.IsSpectating = false
    NetworkSetInSpectatorMode(false, PlayerPedId())
    SendNUIMessage({ action = "updateSpectateHUD", show = false })
end)

function SpectateManager.UpdateTarget(isSyncOnly)
    if #SpectateManager.Teammates == 0 then return end
    local target = SpectateManager.Teammates[SpectateManager.CurrentIndex]
    if not target then return end

    local targetPed = GetPlayerPed(GetPlayerFromServerId(target.source))
    local currentHp = target.health or 100

    if DoesEntityExist(targetPed) then
        if not isSyncOnly then
            NetworkSetInSpectatorMode(true, targetPed)
        end
        currentHp = GetEntityHealth(targetPed)
    end

    SendNUIMessage({
        action = "updateSpectateHUD",
        show = true,
        targetName = target.name or "Teammate",
        teamName = target.teamName or "SQUAD TEAMMATE",
        kills = target.kills or 0,
        health = currentHp
    })
end
