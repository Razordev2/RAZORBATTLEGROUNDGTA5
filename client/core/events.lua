RegisterNetEvent("battleground:cl:syncMatchState", function(state, data)
    data = data or {}
    ClientState.SetMatchState(state, data.matchId)
end)

RegisterNetEvent("battleground:cl:notification", function(msg, msgType)
    SendNUIMessage({
        action = "showNotification",
        message = msg,
        type = msgType or "info"
    })
end)
