ServerRevive = ServerRevive or {}

RegisterNetEvent("battleground:sv:requestRevive", function(targetSrc)
    local reviverSrc = source
    local reviver = PlayerManager.GetPlayer(reviverSrc)
    local target = PlayerManager.GetPlayer(targetSrc)

    if not reviver or not target then return end

    -- Authoritative Validations
    if reviver.state ~= Constants.PlayerState.ALIVE then
        TriggerClientEvent("battleground:cl:notification", reviverSrc, "You must be alive to revive", "error")
        return
    end

    if target.state ~= Constants.PlayerState.DOWNED then
        TriggerClientEvent("battleground:cl:notification", reviverSrc, "Target is not downed", "error")
        return
    end

    if reviver.teamId ~= target.teamId then
        TriggerClientEvent("battleground:cl:notification", reviverSrc, "Target is not in your squad", "error")
        return
    end

    local reviverPed = GetPlayerPed(reviverSrc)
    local targetPed = GetPlayerPed(targetSrc)
    local dist = Utils.GetDistance3D(GetEntityCoords(reviverPed), GetEntityCoords(targetPed))

    if dist > (Config.ReviveDistance or 2.5) + 1.0 then
        TriggerClientEvent("battleground:cl:notification", reviverSrc, "Target is too far away", "error")
        return
    end

    -- Check Medkit in Inventory
    local hasMedkit = ServerInventory.RemoveItem(reviverSrc, "medkit", 1)
    if not hasMedkit then
        TriggerClientEvent("battleground:cl:notification", reviverSrc, "You need a Medkit to revive teammates!", "error")
        return
    end

    TriggerClientEvent("battleground:cl:notification", reviverSrc, _L("revive_started"), "info")
    TriggerClientEvent("battleground:cl:startReviveAnim", reviverSrc, Config.ReviveDuration or 5000)

    SetTimeout(Config.ReviveDuration or 5000, function()
        if target.state == Constants.PlayerState.DOWNED then
            target.state = Constants.PlayerState.ALIVE
            target.health = Config.ReviveHealth or 50

            -- Restore health on ped
            SetEntityHealth(targetPed, 100 + target.health)
            TriggerClientEvent("battleground:cl:syncPlayerState", targetSrc, Constants.PlayerState.ALIVE)
            TriggerClientEvent("battleground:cl:notification", reviverSrc, _L("revived_success"), "success")
            TriggerClientEvent("battleground:cl:notification", targetSrc, _L("revived_success"), "success")
        end
    end)
end)
