ServerRanking = ServerRanking or {}

ServerRanking.Rankings = {}
ServerRanking.PlayerRankings = {}

function ServerRanking.RecordTeamPlacement(team, rank)
    if not team then return end

    local totalKills = 0
    local totalKnocks = 0
    local memberCount = (team.members and #team.members) or 1
    local teamLogo = team.logo or Constants.DefaultTeamLogo

    for _, mSrc in ipairs(team.members or {}) do
        local m = PlayerManager.GetPlayer(mSrc)
        if m then
            local pKills = m.kills or 0
            local pKnocks = m.knocks or 0
            totalKills = totalKills + pKills
            totalKnocks = totalKnocks + pKnocks

            -- Record individual player stats
            table.insert(ServerRanking.PlayerRankings, {
                name = m.name or "PLAYER",
                teamName = team.name or "NAMA TIM",
                logo = teamLogo,
                kills = pKills,
                knocks = pKnocks
            })
        end
    end

    local placementPoints = math.max(0, 20 - (rank * 2))
    local totalPoints = placementPoints + (totalKills * 2)

    table.insert(ServerRanking.Rankings, {
        rank = rank,
        teamId = team.id,
        teamName = team.name or "NAMA TIM",
        logo = teamLogo,
        kills = totalKills,
        knocks = totalKnocks,
        members = memberCount,
        points = totalPoints
    })

    -- Sort team rankings by placement rank ascending
    table.sort(ServerRanking.Rankings, function(a, b)
        return a.rank < b.rank
    end)

    -- Sort player rankings by kills descending
    table.sort(ServerRanking.PlayerRankings, function(a, b)
        if a.kills == b.kills then
            return a.knocks > b.knocks
        end
        return a.kills > b.kills
    end)
end

function ServerRanking.GetResults()
    return {
        teams = ServerRanking.Rankings,
        players = ServerRanking.PlayerRankings
    }
end

function ServerRanking.Reset()
    ServerRanking.Rankings = {}
    ServerRanking.PlayerRankings = {}
end
