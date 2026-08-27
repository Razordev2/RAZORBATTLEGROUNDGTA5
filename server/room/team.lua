TeamManager = TeamManager or {}

function TeamManager.SyncVoiceChannel(src, teamId)
    if not teamId then
        TriggerClientEvent("battleground:cl:syncVoiceChannel", src, 0)
        return
    end
    local voiceChannel = 1000 + (math.abs(GetHashKey(teamId)) % 8000)
    TriggerClientEvent("battleground:cl:syncVoiceChannel", src, voiceChannel)
end

function TeamManager.CreateTeam(src, teamName, logoUrl)
    local player = PlayerManager.GetPlayer(src)
    if not player or not player.roomId then return false, "Not in a room" end

    local room = ServerState.Rooms[player.roomId]
    if not room then return false, "Room not found" end

    teamName = Utils.SanitizeText(teamName)
    if not teamName or #teamName < 2 then
        teamName = string.format("TEAM %s", player.name:upper())
    end

    logoUrl = Utils.SanitizeText(logoUrl)
    if not logoUrl or logoUrl == "" then logoUrl = Constants.DefaultTeamLogo end

    local teamId = Utils.GenerateId("TEAM")

    -- Remove player from existing team first
    if player.teamId and room.teams[player.teamId] then
        local oldMembers = room.teams[player.teamId].members
        for i, mSrc in ipairs(oldMembers) do
            if mSrc == src then
                table.remove(oldMembers, i)
                break
            end
        end
    end

    room.teams[teamId] = {
        id = teamId,
        name = teamName,
        logo = logoUrl,
        leader = src,
        members = { src }
    }

    player.teamId = teamId
    TeamManager.SyncVoiceChannel(src, teamId)
    RoomManager.SyncRoomToMembers(room.id)
    return true, room.teams[teamId]
end

function TeamManager.JoinTeam(src, teamId)
    local player = PlayerManager.GetPlayer(src)
    if not player or not player.roomId then return false, "Not in a room" end

    local room = ServerState.Rooms[player.roomId]
    if not room or not room.teams[teamId] then return false, "Team not found" end

    -- Remove from old team
    if player.teamId and room.teams[player.teamId] then
        local oldMembers = room.teams[player.teamId].members
        for i, mSrc in ipairs(oldMembers) do
            if mSrc == src then
                table.remove(oldMembers, i)
                break
            end
        end
    end

    table.insert(room.teams[teamId].members, src)
    player.teamId = teamId
    TeamManager.SyncVoiceChannel(src, teamId)
    RoomManager.SyncRoomToMembers(room.id)
    return true
end

RegisterNetEvent("battleground:sv:createTeam", function(teamName, logoUrl)
    local src = source
    TeamManager.CreateTeam(src, teamName, logoUrl)
end)

RegisterNetEvent("battleground:sv:joinTeam", function(teamId)
    local src = source
    TeamManager.JoinTeam(src, teamId)
end)
