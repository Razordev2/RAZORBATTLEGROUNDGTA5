ServerVehicleSpawner = ServerVehicleSpawner or {}

function ServerVehicleSpawner.SpawnMatchVehicles()
    ServerVehicleSpawner.CleanupVehicles()

    local allPoints = {}
    for _, pt in ipairs(Config.VehicleSpawnPoints or {}) do
        table.insert(allPoints, pt)
    end

    -- Shuffle spawn points randomly
    for i = #allPoints, 2, -1 do
        local j = math.random(i)
        allPoints[i], allPoints[j] = allPoints[j], allPoints[i]
    end

    -- Pick 1 SINGLE vehicle model for the ENTIRE match (e.g. Wrangler24 Only, Sultan Only, etc.)
    local combinedPool = {}
    for _, model in ipairs(Config.VehiclePools.CIVILIAN or {}) do
        table.insert(combinedPool, model)
    end
    for _, model in ipairs(Config.VehiclePools.MILITARY or {}) do
        table.insert(combinedPool, model)
    end

    local singleSelectedModel = combinedPool[math.random(1, #combinedPool)] or `wrangler24`

    local maxSpawnCount = math.min(#allPoints, Config.TotalMatchVehicles or 30)
    print(string.format("[Battleground] Match Single Vehicle Type Selected: Model %s for %d spawn points!", tostring(singleSelectedModel), maxSpawnCount))

    for i = 1, maxSpawnCount do
        local spawnPoint = allPoints[i]

        local veh = CreateVehicle(singleSelectedModel, spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z, spawnPoint.heading, true, true)

        local timeout = 0
        while not DoesEntityExist(veh) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end

        if DoesEntityExist(veh) then
            SetVehicleDoorsLocked(veh, 1) -- Unlocked
            SetVehicleNeedsToBeHotwired(veh, false)

            local netId = NetworkGetNetworkIdFromEntity(veh)
            table.insert(ServerState.Vehicles, veh)
        end
    end
end

function ServerVehicleSpawner.CleanupVehicles()
    for _, veh in ipairs(ServerState.Vehicles or {}) do
        if DoesEntityExist(veh) then
            DeleteEntity(veh)
        end
    end
    ServerState.Vehicles = {}
end
