ServerResults = ServerResults or {}
ServerMatch = ServerMatch or {}

function ServerResults.SendDiscordWebhook(winnerTeam, stats)
    local webhookUrl = Config.DiscordWebhook
    if not webhookUrl or webhookUrl == "" then return end

    local fields = {}
    local winnerKills = 0

    if winnerTeam and winnerTeam.members then
        for _, mSrc in ipairs(winnerTeam.members) do
            local m = PlayerManager.GetPlayer(mSrc)
            if m then winnerKills = winnerKills + (m.kills or 0) end
        end
    end

    table.insert(fields, {
        name = "🏆 WINNER CHAMPION TEAM",
        value = string.format("**%s**\nTotal Team Kills: **%d**", winnerTeam and winnerTeam.name or "UNKNOWN TIM", winnerKills),
        inline = false
    })

    if stats and stats.teams then
        local leaderText = ""
        for i, team in ipairs(stats.teams) do
            if i <= 5 then
                local medal = i == 1 and "🥇" or (i == 2 and "🥈" or (i == 3 and "🥉" or string.format("#%d", i)))
                leaderText = leaderText .. string.format("%s **%s** — Kills: `%d` | Damage: `%d` | Points: `%d`\n", medal, team.name or "TIM", team.kills or 0, team.damage or 0, team.score or 0)
            end
        end
        if leaderText ~= "" then
            table.insert(fields, {
                name = "📊 TOP ARENA LEADERBOARDS",
                value = leaderText,
                inline = false
            })
        end
    end

    local embed = {
        {
            title = "🔥 MATCH BATTLEGROUND COMPLETED! 🔥",
            description = string.format("Match ID: `%s` telah selesai! Berikut adalah hasil resmi pertandingan:", ServerState.ActiveMatchId or "MATCH-PRO"),
            color = 15774216, -- Crimson Gold #f0b90b
            fields = fields,
            footer = {
                text = "Battleground Esports Engine • " .. os.date("%X - %d/%m/%Y"),
                icon_url = Config.DiscordAvatar
            },
            thumbnail = {
                url = winnerTeam and winnerTeam.logo or Config.DiscordAvatar
            }
        }
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = Config.DiscordBotName or "BATTLEGROUND ENGINE",
        avatar_url = Config.DiscordAvatar,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

function ServerMatch.DeclareWinner(winnerTeam)
    if not winnerTeam then return end
    ServerState.SetMatchState(Constants.MatchState.ENDING)
    print(string.format("[Battleground] MATCH ENDED! Winner: %s", winnerTeam.name or "NAMA TIM"))

    local totalKills = 0
    for _, mSrc in ipairs(winnerTeam.members or {}) do
        local m = PlayerManager.GetPlayer(mSrc)
        if m then
            totalKills = totalKills + (m.kills or 0)
        end
    end

    local stats = ServerRanking.GetResults()

    -- Send Discord Webhook Embedded Report
    ServerResults.SendDiscordWebhook(winnerTeam, stats)

    -- Broadcast 3-Step Victory Sequence to all clients
    TriggerClientEvent("battleground:cl:showWinner", -1, {
        teamName = winnerTeam.name or "NAMA TIM",
        logo = winnerTeam.logo or Constants.DefaultTeamLogo,
        kills = totalKills
    })

    TriggerClientEvent("battleground:cl:showResults", -1, stats)
end
