RoomManager = RoomManager or {}

function RoomManager.CreateRoom(src, roomName, password, logoUrl)
    local player = PlayerManager.GetPlayer(src)
    if not player then return false, "Player not found" end

    if player.roomId then
        return false, "Player is already in a room" end

    roomName = Utils.SanitizeText(roomName)
    if not roomName or #roomName < 3 then
        roomName = string.format("%s's Room", player.name)
    end

    logoUrl = Utils.SanitizeText(logoUrl)
    if not logoUrl or logoUrl == "" then
        logoUrl = Constants.DefaultTeamLogo
    end

    local roomId = Utils.GenerateId("ROOM")
    local teamId = Utils.GenerateId("TEAM")

    local room = {
        id = roomId,
        name = roomName,
        ownerSource = src,
        password = password or "",
        hasPassword = (password and password ~= ""),
        state = Constants.MatchState.LOBBY,
        teams = {
            [teamId] = {
                id = teamId,
                name = string.format("%s TEAM", player.name:upper()),
                logo = logoUrl,
                leader = src,
                members = { src }
            }
        }
    }

    ServerState.Rooms[roomId] = room
    player.roomId = roomId
    player.teamId = teamId

    print(string.format("[Battleground] Room %s (%s) created by %s", roomName, roomId, player.name))

    RoomManager.BroadcastRoomList()
    RoomManager.SyncRoomData(src)
    return true, room
end

function RoomManager.JoinRoom(src, roomId, password)
    local player = PlayerManager.GetPlayer(src)
    if not player then return false, "Player not found" end

    if player.roomId then
        return false, "Player is already in a room" end

    local room = ServerState.Rooms[roomId]
    if not room then
        return false, "Room not found" end

    if room.state ~= Constants.MatchState.LOBBY then
        return false, "Match in progress" end

    if room.hasPassword and room.password ~= password then
        return false, _L("wrong_password")
    end

    -- Join the primary host team
    local primaryTeamId = next(room.teams)
    if not primaryTeamId then
        primaryTeamId = Utils.GenerateId("TEAM")
        room.teams[primaryTeamId] = {
            id = primaryTeamId,
            name = "WARRIORS",
            logo = Constants.DefaultTeamLogo,
            leader = src,
            members = {}
        }
    end

    table.insert(room.teams[primaryTeamId].members, src)
    player.roomId = roomId
    player.teamId = primaryTeamId

    print(string.format("[Battleground] Player %s joined Room %s", player.name, roomId))

    RoomManager.BroadcastRoomList()
    RoomManager.SyncRoomToMembers(roomId)
    return true, room
end

function RoomManager.LeaveRoom(src)
    local player = PlayerManager.GetPlayer(src)
    if not player or not player.roomId then return end

    local roomId = player.roomId
    local room = ServerState.Rooms[roomId]

    if room then
        -- Remove from team
        if player.teamId and room.teams[player.teamId] then
            local members = room.teams[player.teamId].members
            for i, memberSrc in ipairs(members) do
                if memberSrc == src then
                    table.remove(members, i)
                    break
                end
            end
        end

        -- Check total remaining room members
        local totalMembers = 0
        local nextOwner = nil
        for _, team in pairs(room.teams) do
            for _, memberSrc in ipairs(team.members) do
                totalMembers = totalMembers + 1
                if not nextOwner then nextOwner = memberSrc end
            end
        end

        if totalMembers == 0 then
            -- Delete empty room
            ServerState.Rooms[roomId] = nil
            print(string.format("[Battleground] Room %s closed (empty)", roomId))
        else
            -- Transfer ownership if host left
            if room.ownerSource == src then
                room.ownerSource = nextOwner
                print(string.format("[Battleground] Room %s ownership transferred to ID: %s", roomId, nextOwner))
            end
            RoomManager.SyncRoomToMembers(roomId)
        end
    end

    player.roomId = nil
    player.teamId = nil

    TriggerClientEvent("battleground:cl:syncRoomData", src, nil)
    RoomManager.BroadcastRoomList()
end

function RoomManager.SyncRoomData(src)
    local player = PlayerManager.GetPlayer(src)
    if not player or not player.roomId then
        TriggerClientEvent("battleground:cl:syncRoomData", src, nil)
        return
    end

    local room = ServerState.Rooms[player.roomId]
    TriggerClientEvent("battleground:cl:syncRoomData", src, room)
end

function RoomManager.SyncRoomToMembers(roomId)
    local room = ServerState.Rooms[roomId]
    if not room then return end

    for _, team in pairs(room.teams) do
        for _, memberSrc in ipairs(team.members) do
            TriggerClientEvent("battleground:cl:syncRoomData", memberSrc, room)
        end
    end
end

function RoomManager.BroadcastRoomList()
    local roomList = {}
    for _, room in pairs(ServerState.Rooms) do
        local memberCount = 0
        for _, team in pairs(room.teams) do
            memberCount = memberCount + #team.members
        end

        table.insert(roomList, {
            id = room.id,
            name = room.name,
            hasPassword = room.hasPassword,
            state = room.state,
            memberCount = memberCount,
            ownerName = (PlayerManager.GetPlayer(room.ownerSource) and PlayerManager.GetPlayer(room.ownerSource).name) or "Unknown"
        })
    end

    TriggerClientEvent("battleground:cl:syncRoomList", -1, roomList)
end

-- Register Net Events for Room Management
RegisterNetEvent("battleground:sv:createRoom", function(data)
    local src = source
    data = data or {}
    local success, result = RoomManager.CreateRoom(src, data.name, data.password, data.logoUrl)
    if not success then
        TriggerClientEvent("battleground:cl:notification", src, result, "error")
    else
        TriggerClientEvent("battleground:cl:notification", src, _L("room_created", data.name or ""), "success")
    end
end)

RegisterNetEvent("battleground:sv:joinRoom", function(roomId, password)
    local src = source
    local success, result = RoomManager.JoinRoom(src, roomId, password)
    if not success then
        TriggerClientEvent("battleground:cl:notification", src, result, "error")
    else
        TriggerClientEvent("battleground:cl:notification", src, _L("room_joined", roomId), "success")
    end
end)

RegisterNetEvent("battleground:sv:leaveRoom", function()
    local src = source
    RoomManager.LeaveRoom(src)
    TriggerClientEvent("battleground:cl:notification", src, _L("room_left"), "info")
end)

RegisterNetEvent("battleground:sv:fetchRooms", function()
    local src = source
    RoomManager.BroadcastRoomList()
end)
