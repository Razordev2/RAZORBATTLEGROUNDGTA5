ClientCombat = ClientCombat or {}

RegisterNetEvent("battleground:cl:syncPlayerState", function(state)
    ClientState.PlayerState = state
    local ped = PlayerPedId()

    if state == Constants.PlayerState.DOWNED then
        SetPedToRagdoll(ped, 1000, 1000, 0, true, true, false)
        ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
    elseif state == Constants.PlayerState.ALIVE then
        ClearPedTasksImmediately(ped)
        if GetResourceState('illenium-appearance') == 'started' then
            exports['illenium-appearance']:reloadPedAppearance(ped)
        end
    elseif state == Constants.PlayerState.DEAD then
        SetEntityHealth(ped, 0)
    end
end)

RegisterNetEvent("battleground:cl:startReviveAnim", function(duration)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
    Wait(duration)
    ClearPedTasks(ped)
end)

-- Push Kill Feed Notification Event from Server
RegisterNetEvent("battleground:cl:pushKillFeed", function(killer, weapon, victim, isHeadshot)
    SendNUIMessage({
        action = "pushKillFeed",
        killer = killer,
        weaponIcon = "icon/Vector.png",
        victim = victim,
        isHeadshot = isHeadshot
    })
end)

-- Detect damage events on client ped and relay to server
AddEventHandler("gameEventTriggered", function(name, args)
    if name == "CEventNetworkEntityDamage" then
        local victim = args[1]
        local attacker = args[2]
        local weaponHash = args[7]
        local isFatal = args[6]
        local isHeadshot = (args[8] == 1 or args[10] == 1 or args[11] == 1)

        if victim == PlayerPedId() and DoesEntityExist(attacker) and IsEntityAPed(attacker) then
            local attackerSrc = NetworkGetPlayerIndexFromPed(attacker)
            if attackerSrc and attackerSrc ~= -1 then
                local serverId = GetPlayerServerId(attackerSrc)
                TriggerServerEvent("battleground:sv:reportDamage", serverId, weaponHash, isHeadshot)
            end
        end
    end
end)

-- Check distance to downed teammate to trigger revive prompt
CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        if ClientState.PlayerState == Constants.PlayerState.ALIVE then
            for _, player in pairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                if targetPed ~= ped and IsPedDeadOrDying(targetPed, true) then
                    local dist = Utils.GetDistance3D(GetEntityCoords(ped), GetEntityCoords(targetPed))
                    if dist <= (Config.ReviveDistance or 2.5) then
                        BeginTextCommandDisplayHelp("STRING")
                        AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ [E] to REVIVE TEAMMATE")
                        EndTextCommandDisplayHelp(0, false, true, -1)

                        if IsControlJustPressed(0, 38) then
                            local targetSrc = GetPlayerServerId(player)
                            TriggerServerEvent("battleground:sv:requestRevive", targetSrc)
                        end
                    end
                end
            end
        end
    end
end)
