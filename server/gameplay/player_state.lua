ServerPlayerState = ServerPlayerState or {}

-- Real-time Team HUD Sync Thread (Syncs squad health, name, state to squad members in real-time)
CreateThread(function()
    while true do
        Wait(250)
        if ServerState and ServerState.Rooms then
            for roomId, room in pairs(ServerState.Rooms) do
                if room.teams then
                    for teamId, team in pairs(room.teams) do
                        local memberList = {}
                        for _, mSrc in ipairs(team.members or {}) do
                            local mPed = GetPlayerPed(mSrc)
                            local mPlayer = PlayerManager.GetPlayer(mSrc)
                            if DoesEntityExist(mPed) and mPlayer then
                                local rawHp = GetEntityHealth(mPed)
                                local hpPercent = math.max(0, math.min(100, rawHp - 100))
                                if rawHp <= 0 then hpPercent = 0 end

                                table.insert(memberList, {
                                    source = mSrc,
                                    name = mPlayer.name,
                                    health = hpPercent,
                                    state = mPlayer.state or "ALIVE"
                                })
                            end
                        end

                        -- Broadcast live team HUD to all team members
                        for _, mSrc in ipairs(team.members or {}) do
                            TriggerClientEvent("battleground:cl:syncTeamHUD", mSrc, {
                                id = team.id,
                                name = team.name,
                                logo = team.logo,
                                members = memberList
                            })
                        end
                    end
                end
            end
        end
    end
end)
