ServerAdminCommands = ServerAdminCommands or {}

-- Admin Command: /createlootzone [radius] [table] (Restricted)
RegisterCommand("createlootzone", function(src, args)
    if not PermissionsManager.IsAdmin(src) then
        TriggerClientEvent("battleground:cl:notification", src, _L("no_permission"), "error")
        return
    end

    local radius = tonumber(args[1]) or 100
    local tableType = string.upper(args[2] or "BASIC")
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    ServerLootZone.CreateZone(coords, radius, tableType)
    TriggerClientEvent("battleground:cl:notification", src, string.format("Loot Zone created! Radius: %d, Table: %s", radius, tableType), "success")
end, true)

-- Admin Command: /deletelootzone [id] (Restricted)
RegisterCommand("deletelootzone", function(src, args)
    if not PermissionsManager.IsAdmin(src) then return end
    local zoneId = tonumber(args[1])
    if ServerLootZone.DeleteZone(zoneId) then
        TriggerClientEvent("battleground:cl:notification", src, string.format("Loot Zone #%d deleted.", zoneId), "success")
    else
        TriggerClientEvent("battleground:cl:notification", src, "Zone ID not found.", "error")
    end
end, true)

-- Admin Command: /createcode <code> <rewardType> <rewardId> [maxUses] (Restricted)
RegisterCommand("createcode", function(src, args)
    if not PermissionsManager.IsAdmin(src) then return end
    local code = string.upper(args[1] or "")
    local rewardType = string.upper(args[2] or "KILLMESSAGE")
    local rewardId = string.upper(args[3] or "NEON")
    local maxUses = tonumber(args[4]) or 100

    if code == "" then
        TriggerClientEvent("battleground:cl:notification", src, "Usage: /createcode <code> <rewardType> <rewardId> [maxUses]", "info")
        return
    end

    ServerState.RedeemCodes[code] = {
        code = code,
        rewardType = rewardType,
        rewardId = rewardId,
        maxUses = maxUses,
        currentUses = 0,
        enabled = true,
        claimedBy = {}
    }

    TriggerClientEvent("battleground:cl:notification", src, string.format("Code %s created! Max uses: %d", code, maxUses), "success")
end, true)

-- Admin Command: /startmatch (Restricted)
RegisterCommand("startmatch", function(src, args)
    MatchManager.StartMatch(src)
end, true)

-- Admin Command: /stopmatch (Restricted)
RegisterCommand("stopmatch", function(src, args)
    MatchManager.StopMatch(src)
end, true)

-- Manual Command: /airdropmanual (Restricted)
RegisterCommand("airdropmanual", function(src, args)
    if src > 0 and not PermissionsManager.IsAdmin(src) then
        TriggerClientEvent("battleground:cl:notification", src, _L("no_permission"), "error")
        return
    end

    if ServerAirdropSpawner and ServerAirdropSpawner.SpawnAirdrop then
        ServerAirdropSpawner.SpawnAirdrop()
        if src > 0 then
            TriggerClientEvent("battleground:cl:notification", src, "Airdrop Manual Triggered!", "success")
        end
    end
end, true)

-- Manual Command: /zonemanual (Restricted)
RegisterCommand("zonemanual", function(src, args)
    if src > 0 and not PermissionsManager.IsAdmin(src) then
        TriggerClientEvent("battleground:cl:notification", src, _L("no_permission"), "error")
        return
    end

    TriggerClientEvent("battleground:cl:showZoneWarn", -1, {
        title = "ZONA MULAI BERGERAK!",
        message = string.format("SAFEZONE FASE %d MULAI MENYEMPITT! SEGERA LARI KE ZONA AMAN!", ServerZone.CurrentPhase or 1)
    })
    if src > 0 then
        TriggerClientEvent("battleground:cl:notification", src, "Zone Warning Manual Triggered!", "success")
    end
end, true)

-- Restricted Admin Command: /playmanual (Force starts match for all teams) (Restricted)
RegisterCommand("playmanual", function(src, args)
    if src > 0 and not PermissionsManager.IsAdmin(src) then
        TriggerClientEvent("battleground:cl:notification", src, _L("no_permission"), "error")
        return
    end

    if ServerState.GetMatchState() ~= Constants.MatchState.LOBBY then
        if src > 0 then
            TriggerClientEvent("battleground:cl:notification", src, "Match sudah berjalan!", "error")
        end
        return
    end

    ServerState.ActiveMatchId = Utils.GenerateId("MATCH")
    ServerState.SetMatchState(Constants.MatchState.STARTING)
    print(string.format("[Battleground] Admin /playmanual executed by src %d! Match ID: %s", src, ServerState.ActiveMatchId))

    -- Broadcast notification to all players
    TriggerClientEvent("battleground:cl:notification", -1, "ADMIN TELAH MEMULAI MATCH UNTUK SEMUA TIM! SIAP-SIAP!", "success")

    -- Start countdown and transition to airplane/gameplay
    ServerCountdown.Start(Config.CountdownDuration or 5)

    if src > 0 then
        TriggerClientEvent("battleground:cl:notification", src, "Match berhasil dimulai secara manual (/playmanual)!", "success")
    end
end, true)

-- Restricted Admin Command: /spawnvehiclesmanual (Force spawns random vehicles across map)
RegisterCommand("spawnvehiclesmanual", function(src, args)
    if src > 0 and not PermissionsManager.IsAdmin(src) then
        TriggerClientEvent("battleground:cl:notification", src, _L("no_permission"), "error")
        return
    end

    if ServerVehicleSpawner and ServerVehicleSpawner.SpawnMatchVehicles then
        ServerVehicleSpawner.SpawnMatchVehicles()
        if src > 0 then
            TriggerClientEvent("battleground:cl:notification", src, "Random Vehicles Spawned Manual Triggered!", "success")
        end
    end
end, true)
