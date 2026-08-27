ClientState = ClientState or {}

ClientState.MatchState = Constants.MatchState.LOBBY
ClientState.MatchId = nil
ClientState.PlayerState = Constants.PlayerState.ALIVE
ClientState.RoomData = nil
ClientState.TeamData = nil
ClientState.Inventory = { weapons = {}, items = {} }

function ClientState.SetMatchState(state, matchId)
    ClientState.MatchState = state
    ClientState.MatchId = matchId
    
    SendNUIMessage({
        action = "updateMatchState",
        state = state,
        matchId = matchId
    })
end

function ClientState.GetMatchState()
    return ClientState.MatchState
end
