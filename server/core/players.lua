PlayerManager = PlayerManager or {}

function PlayerManager.RegisterPlayer(src)
    local identifier = GetPlayerIdentifierByType(src, 'license') or string.format("player:%s", src)
    local name = Utils.SanitizeText(GetPlayerName(src) or ("Player " .. src))

    ServerState.Players[src] = {
        source = src,
        identifier = identifier,
        name = name,
        roomId = nil,
        teamId = nil,
        state = Constants.PlayerState.ALIVE,
        health = 100,
        armor = 0,
        kills = 0,
        damageDealt = 0,
        activeKillMessage = "DEFAULT",
        ownedKillMessages = { "DEFAULT" },
        inventory = {
            weapons = {},
            items = {}
        },
        lastRedeemTime = 0
    }
    
    print(string.format("[Battleground] Player %s (ID: %s) registered.", name, src))
    return ServerState.Players[src]
end

function PlayerManager.UnregisterPlayer(src)
    if ServerState.Players[src] then
        print(string.format("[Battleground] Player %s unregistered.", src))
        ServerState.Players[src] = nil
    end
end

function PlayerManager.GetPlayer(src)
    return ServerState.Players[src]
end

function PlayerManager.GetAllPlayers()
    return ServerState.Players
end
