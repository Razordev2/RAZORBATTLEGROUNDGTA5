ServerAirdropSpawner = ServerAirdropSpawner or {}

function ServerAirdropSpawner.StartLoop()
    CreateThread(function()
        while ServerState.GetMatchState() == Constants.MatchState.ACTIVE do
            Wait((Config.AirdropInterval or 60) * 1000)
            if ServerState.GetMatchState() == Constants.MatchState.ACTIVE then
                ServerAirdropSpawner.SpawnAirdrop()
            end
        end
    end)
end

function ServerAirdropSpawner.SpawnAirdrop()
    -- Calculate random drop location inside current safe zone radius
    local center = ServerZone.CurrentCenter or vec3(0,0,0)
    local radius = math.max(50.0, ServerZone.CurrentRadius * 0.7)
    local angle = math.random() * math.pi * 2
    local dist = math.random() * radius

    local dropCoords = vec3(
        center.x + math.cos(angle) * dist,
        center.y + math.sin(angle) * dist,
        15.0
    )

    local airdropId = Utils.GenerateId("AIRDROP")
    local airdrop = {
        id = airdropId,
        coords = dropCoords,
        state = "DROPPING",
        loot = Utils.DeepCopy(Config.AirdropLoot or {})
    }

    ServerState.Airdrops[airdropId] = airdrop
    print(string.format("[Battleground] Airdrop %s spawned at (%s, %s)", airdropId, dropCoords.x, dropCoords.y))

    -- Broadcast Airdrop Entity spawn and Crimson Glass UI Notification to all clients
    TriggerClientEvent("battleground:cl:spawnAirdrop", -1, airdrop)
    TriggerClientEvent("battleground:cl:showAirdrop", -1, string.format("AIRDROP SUPPLY PHASE %d BERADA DI SEKITAR SAFE ZONE!", ServerZone.CurrentPhase or 1))
end
