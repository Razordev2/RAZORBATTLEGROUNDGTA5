ServerState = ServerState or {}

ServerState.CurrentMatchState = Constants.MatchState.LOBBY
ServerState.ActiveMatchId = nil
ServerState.Rooms = {}
ServerState.Players = {}
ServerState.LootZones = {}
ServerState.GroundLoot = {}
ServerState.Vehicles = {}
ServerState.Airdrops = {}
ServerState.RedeemCodes = Utils.DeepCopy(Config.DefaultRedeemCodes or {})

function ServerState.SetMatchState(newState)
    ServerState.CurrentMatchState = newState
    TriggerClientEvent("battleground:cl:syncMatchState", -1, newState, {
        matchId = ServerState.ActiveMatchId
    })
    print(string.format("[Battleground] Server Match State changed to: %s", newState))
end

function ServerState.GetMatchState()
    return ServerState.CurrentMatchState
end
