ServerZone = ServerZone or {}

ServerZone.CurrentPhase = 1
ServerZone.CurrentCenter = Config.InitialZoneCenter or vec3(0.0, 0.0, 0.0)
ServerZone.CurrentRadius = Config.InitialZoneRadius or 1500.0
ServerZone.NextCenter = vec3(0.0, 0.0, 0.0)
ServerZone.NextRadius = 1000.0
ServerZone.Timer = Config.ZoneInterval or 30
ServerZone.IsActive = false

function ServerZone.StartEngine()
    ServerZone.IsActive = true
    ServerZone.CurrentPhase = 1
    ServerZone.CurrentCenter = Config.InitialZoneCenter or vec3(0.0, 0.0, 0.0)
    ServerZone.CurrentRadius = Config.InitialZoneRadius or 1500.0
    ServerZone.CalculateNextZone()

    -- Zone timer and shrink thread
    CreateThread(function()
        while ServerZone.IsActive and ServerState.GetMatchState() == Constants.MatchState.ACTIVE do
            Wait(1000)
            ServerZone.Timer = ServerZone.Timer - 1

            if ServerZone.Timer <= 0 then
                -- Move to next zone phase
                ServerZone.AdvancePhase()
            end

            -- Sync zone state to clients every second
            TriggerClientEvent("battleground:cl:syncZone", -1, {
                currentCenter = ServerZone.CurrentCenter,
                currentRadius = ServerZone.CurrentRadius,
                nextCenter = ServerZone.NextCenter,
                nextRadius = ServerZone.NextRadius,
                timer = ServerZone.Timer,
                phase = ServerZone.CurrentPhase
            })

            -- Authoritative Out-of-Zone damage check
            ServerZone.ApplyOutofZoneDamage()
        end
    end)
end

function ServerZone.CalculateNextZone()
    local phaseConfig = Config.ZonePhases[ServerZone.CurrentPhase + 1] or Config.ZonePhases[#Config.ZonePhases]
    ServerZone.NextRadius = phaseConfig.radius

    -- Calculate random center drift within current circle radius
    local maxOffset = math.max(0.0, ServerZone.CurrentRadius - ServerZone.NextRadius)
    local angle = math.random() * math.pi * 2
    local dist = math.random() * maxOffset

    ServerZone.NextCenter = vec3(
        ServerZone.CurrentCenter.x + math.cos(angle) * dist,
        ServerZone.CurrentCenter.y + math.sin(angle) * dist,
        0.0
    )
    ServerZone.Timer = Config.ZoneInterval or 30
end

function ServerZone.AdvancePhase()
    ServerZone.CurrentCenter = ServerZone.NextCenter
    ServerZone.CurrentRadius = ServerZone.NextRadius
    ServerZone.CurrentPhase = math.min(#Config.ZonePhases, ServerZone.CurrentPhase + 1)
    ServerZone.CalculateNextZone()
    print(string.format("[Battleground] SafeZone advanced to Phase %d (Radius: %f)", ServerZone.CurrentPhase, ServerZone.CurrentRadius))

    -- Trigger Zone Warning UI Notification to all clients immediately!
    TriggerClientEvent("battleground:cl:showZoneWarn", -1, {
        title = "ZONA MULAI BERGERAK!",
        message = string.format("SAFEZONE FASE %d MULAI MENYEMPITT! SEGERA LARI KE ZONA AMAN!", ServerZone.CurrentPhase)
    })

    -- Trigger Airdrop supply drop & UI notification 5 seconds after zone starts moving!
    SetTimeout(5000, function()
        if ServerState.GetMatchState() == Constants.MatchState.ACTIVE then
            if ServerAirdropSpawner and ServerAirdropSpawner.SpawnAirdrop then
                ServerAirdropSpawner.SpawnAirdrop()
            end
        end
    end)
end

function ServerZone.ApplyOutofZoneDamage()
    local phaseConfig = Config.ZonePhases[ServerZone.CurrentPhase] or Config.ZonePhases[1]
    local damage = phaseConfig.damagePerSec or 5

    for src, player in pairs(ServerState.Players) do
        if player.state == Constants.PlayerState.ALIVE then
            local ped = GetPlayerPed(src)
            if DoesEntityExist(ped) then
                local pCoords = GetEntityCoords(ped)
                local dist2D = Utils.GetDistance2D(pCoords, ServerZone.CurrentCenter)

                if dist2D > ServerZone.CurrentRadius then
                    -- Player is outside safe zone!
                    player.health = player.health - damage
                    SetEntityHealth(ped, math.max(1, GetEntityHealth(ped) - damage))

                    TriggerClientEvent("battleground:cl:notification", src, "WARNING: YOU ARE OUTSIDE THE SAFE ZONE!", "error")

                    if player.health <= 0 then
                        ServerKill.RegisterKill(0, src, `WEAPON_UNARMED`)
                    end
                end
            end
        end
    end
end
