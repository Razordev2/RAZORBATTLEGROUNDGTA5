ServerLootZone = ServerLootZone or {}

function ServerLootZone.CreateZone(center, radius, tableType)
    tableType = tableType or "BASIC"
    if not Config.LootTables[tableType] then tableType = "BASIC" end

    local zoneId = #ServerState.LootZones + 1
    local zone = {
        id = zoneId,
        center = center,
        radius = tonumber(radius) or 100.0,
        tableType = tableType
    }

    table.insert(ServerState.LootZones, zone)
    print(string.format("[Battleground] Loot Zone #%d created at (%s, %s, %s) with radius %s [%s]", zoneId, center.x, center.y, center.z, radius, tableType))

    -- Generate loot items within zone
    ServerLootZone.PopulateZone(zone)
    ServerLootZone.SyncToAdmins()
    return zone
end

function ServerLootZone.DeleteZone(zoneId)
    zoneId = tonumber(zoneId)
    if not zoneId or not ServerState.LootZones[zoneId] then return false end

    table.remove(ServerState.LootZones, zoneId)
    -- Re-index zone IDs
    for i, z in ipairs(ServerState.LootZones) do z.id = i end

    ServerLootZone.SyncToAdmins()
    return true
end

function ServerLootZone.PopulateZone(zone)
    local itemCount = math.floor(zone.radius / 5) -- 1 item per 5 meters radius
    for i = 1, itemCount do
        local angle = math.random() * math.pi * 2
        local dist = math.random() * zone.radius
        local spawnCoords = vec3(
            zone.center.x + math.cos(angle) * dist,
            zone.center.y + math.sin(angle) * dist,
            zone.center.z
        )

        local lootData = ServerLootTable.GetRandomLoot(zone.tableType)
        ServerLoot.SpawnGroundItem(spawnCoords, lootData.itemType, lootData.name, lootData.count, lootData.prop)
    end
end

function ServerLootZone.SyncToAdmins()
    for src, player in pairs(ServerState.Players) do
        if PermissionsManager.IsAdmin(src) then
            TriggerClientEvent("battleground:cl:syncLootZone", src, ServerState.LootZones)
        end
    end
end
