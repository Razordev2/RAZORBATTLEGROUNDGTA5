ServerElimination = ServerElimination or {}

function ServerElimination.CheckTeamElimination(roomId, teamId)
    local room = ServerState.Rooms[roomId]
    if not room or not room.teams[teamId] then return end

    local team = room.teams[teamId]
    local allDead = true
    local livingTeammates = {}

    for _, memberSrc in ipairs(team.members) do
        local member = PlayerManager.GetPlayer(memberSrc)
        if member and member.state ~= Constants.PlayerState.DEAD then
            allDead = false
            table.insert(livingTeammates, {
                source = memberSrc,
                name = member.name or GetPlayerName(memberSrc) or "Teammate",
                health = GetEntityHealth(GetPlayerPed(memberSrc)) or 100,
                kills = member.kills or 0
            })
        end
    end

    if allDead then
        -- Count total remaining active teams
        local aliveTeamsCount = 0
        local lastAliveTeam = nil

        for tId, tObj in pairs(room.teams) do
            local hasAlive = false
            for _, mSrc in ipairs(tObj.members) do
                local m = PlayerManager.GetPlayer(mSrc)
                if m and m.state ~= Constants.PlayerState.DEAD then
                    hasAlive = true
                    break
                end
            end
            if hasAlive then
                aliveTeamsCount = aliveTeamsCount + 1
                lastAliveTeam = tObj
            end
        end

        local rank = aliveTeamsCount + 1
        print(string.format("[Battleground] Team %s ELIMINATED! Rank: #%d", team.name, rank))

        -- Stop spectating for all team members and send back to lobby
        for _, memberSrc in ipairs(team.members) do
            TriggerClientEvent("battleground:cl:stopSpectate", memberSrc)
            TriggerClientEvent("battleground:cl:showTeamEliminated", memberSrc, {
                rank = rank,
                teamName = team.name,
                logo = team.logo or Constants.DefaultTeamLogo
            })

            -- Teleport player back to Lobby Coords after 4 seconds
            SetTimeout(4000, function()
                local ped = GetPlayerPed(memberSrc)
                if DoesEntityExist(ped) then
                    local lobbyCoords = Config.LobbyCoords or vec3(0.0, 0.0, 70.0)
                    SetEntityCoords(ped, lobbyCoords.x, lobbyCoords.y, lobbyCoords.z, false, false, false, false)
                    local player = PlayerManager.GetPlayer(memberSrc)
                    if player then
                        player.state = Constants.PlayerState.LOBBY
                    end
                    TriggerClientEvent("battleground:cl:notification", memberSrc, "Match Selesai untuk tim Anda. Menunggu Match selesai di Lobby...", "info")
                end
            end)
        end

        -- Record placement ranking
        ServerRanking.RecordTeamPlacement(team, rank)

        -- Check for Winner
        if aliveTeamsCount == 1 and lastAliveTeam then
            ServerRanking.RecordTeamPlacement(lastAliveTeam, 1)
            ServerMatch.DeclareWinner(lastAliveTeam)
        end
    else
        -- Team still has living members! Start spectate for dead members
        for _, memberSrc in ipairs(team.members) do
            local member = PlayerManager.GetPlayer(memberSrc)
            if member and member.state == Constants.PlayerState.DEAD then
                TriggerClientEvent("battleground:cl:startSpectate", memberSrc, livingTeammates)
            end
        end
    end
end
