ServerEvents = ServerEvents or {}

-- Player join event wrapper
AddEventHandler("playerJoining", function()
    local src = source
    PlayerManager.RegisterPlayer(src)
end)

-- Player drop event wrapper
AddEventHandler("playerDropped", function(reason)
    local src = source
    if RoomManager and RoomManager.LeaveRoom then
        RoomManager.LeaveRoom(src)
    end
    PlayerManager.UnregisterPlayer(src)
end)

-- Request current match state event
RegisterNetEvent("battleground:sv:requestState", function()
    local src = source
    TriggerClientEvent("battleground:cl:syncMatchState", src, ServerState.GetMatchState(), {
        matchId = ServerState.ActiveMatchId
    })
end)
