ClientMatch = ClientMatch or {}

RegisterNetEvent("battleground:cl:syncMatchState", function(state, data)
    ClientState.SetMatchState(state, data and data.matchId)

    if state == Constants.MatchState.LOBBY then
        -- Clean up client views
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "hideAllOverlays" })
    elseif state == Constants.MatchState.STARTING then
        -- Close room modal, show countdown UI
        ClientRoom.ToggleUI(false)
    elseif state == Constants.MatchState.DROPPING then
        SendNUIMessage({ action = "hideCountdown" })
    end
end)

RegisterNetEvent("battleground:cl:showWinner", function(winnerData)
    SendNUIMessage({
        action = "showWinner",
        winner = winnerData
    })
end)

RegisterNetEvent("battleground:cl:showResults", function(resultsData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "showResults",
        teams = resultsData and resultsData.teams or {},
        players = resultsData and resultsData.players or {}
    })
end)
