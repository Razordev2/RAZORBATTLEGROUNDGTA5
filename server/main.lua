AddEventHandler("onResourceStart", function(resName)
    if GetCurrentResourceName() ~= resName then return end
    print("==================================================")
    print(" [BATTLEGROUND] Server-Authoritative Engine Started")
    print(" State: LOBBY | Version: 1.0.0")
    print("==================================================")
    
    -- Register existing connected players
    for _, playerId in ipairs(GetPlayers()) do
        local src = tonumber(playerId)
        if src then
            PlayerManager.RegisterPlayer(src)
        end
    end
end)

RegisterNetEvent("battleground:sv:sendChatMessage", function(message)
    local src = source
    if not message or message == "" then return end

    local player = PlayerManager and PlayerManager.GetPlayer(src)
    local authorName = player and player.name or GetPlayerName(src) or "Player"
    local isAdmin = PermissionsManager and PermissionsManager.IsAdmin(src) or false
    local tag = isAdmin and "ADMIN" or "PLAYER"

    TriggerClientEvent("battleground:cl:addChatMessage", -1, {
        tag = tag,
        author = authorName,
        message = message,
        isAdmin = isAdmin
    })
end)

RegisterNetEvent("battleground:sv:sendEnemyPing", function(pingData)
    local src = source
    local player = PlayerManager and PlayerManager.GetPlayer(src)
    local authorName = player and player.name or GetPlayerName(src) or "Teammate"

    local recipients = { src } -- Default fallback to sender

    if player and player.roomId and player.teamId then
        local room = ServerState.Rooms and ServerState.Rooms[player.roomId]
        if room and room.teams and room.teams[player.teamId] then
            recipients = room.teams[player.teamId].members or { src }
        end
    end

    -- Broadcast ONLY to teammates!
    for _, memberSrc in ipairs(recipients) do
        TriggerClientEvent("battleground:cl:showEnemyPing", memberSrc, {
            distance = pingData and pingData.distance or 145,
            author = authorName
        })
    end
end)
