MatchManager = MatchManager or {}

function MatchManager.StartMatch(src)
    if ServerState.GetMatchState() ~= Constants.MatchState.LOBBY then
        if src and src > 0 then
            TriggerClientEvent("battleground:cl:notification", src, "Match already in progress", "error")
        end
        return false
    end

    local player = PlayerManager.GetPlayer(src)
    if src and src > 0 and not PermissionsManager.IsAdmin(src) then
        if not player or not player.roomId then
            TriggerClientEvent("battleground:cl:notification", src, "You are not in a room", "error")
            return false
        end

        local room = ServerState.Rooms[player.roomId]
        if not room or room.ownerSource ~= src then
            TriggerClientEvent("battleground:cl:notification", src, "Only room host can start the match", "error")
            return false
        end
    end

    ServerState.ActiveMatchId = Utils.GenerateId("MATCH")
    ServerState.SetMatchState(Constants.MatchState.STARTING)
    print(string.format("[Battleground] Match %s started!", ServerState.ActiveMatchId))

    ServerCountdown.Start(Config.CountdownDuration)
    return true
end

function MatchManager.StopMatch(src)
    if ServerState.GetMatchState() == Constants.MatchState.LOBBY then return end

    if src and src > 0 and not PermissionsManager.IsAdmin(src) then
        TriggerClientEvent("battleground:cl:notification", src, _L("no_permission"), "error")
        return
    end

    ServerCountdown.Stop()
    ServerState.SetMatchState(Constants.MatchState.LOBBY)
    ServerState.ActiveMatchId = nil
    print("[Battleground] Match stopped manually by admin/server.")
end

RegisterNetEvent("battleground:sv:startMatch", function()
    local src = source
    MatchManager.StartMatch(src)
end)
