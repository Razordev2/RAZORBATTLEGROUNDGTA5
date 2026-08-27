ClientRoom = ClientRoom or {}

ClientRoom.IsUIOpen = false

function ClientRoom.ToggleUI(show)
    ClientRoom.IsUIOpen = show
    SetNuiFocus(show, show)
    SendNUIMessage({
        action = "toggleRoomUI",
        show = show
    })
    
    if show then
        TriggerServerEvent("battleground:sv:fetchRooms")
    end
end

function ClientRoom.OpenCreateTeamUI(show)
    ClientRoom.IsUIOpen = show
    SetNuiFocus(show, show)
    SendNUIMessage({
        action = "openCreateTeamUI",
        show = show
    })
end

-- pma-voice Integration
RegisterNetEvent("battleground:cl:syncVoiceChannel", function(channelId)
    if GetResourceState('pma-voice') == 'started' then
        exports['pma-voice']:setRadioChannel(channelId or 0)
        if channelId and channelId > 0 then
            exports['pma-voice']:setVoiceProperty('radioEnabled', true)
        end
    end
end)

-- Commands
RegisterCommand("createroom", function()
    ClientRoom.OpenCreateTeamUI(true)
end, false)

RegisterCommand("jointim", function()
    ClientRoom.ToggleUI(true)
end, false)

RegisterCommand("joinroom", function()
    ClientRoom.ToggleUI(true)
end, false)

-- Net Events
RegisterNetEvent("battleground:cl:syncRoomData", function(roomData)
    ClientState.RoomData = roomData
    SendNUIMessage({
        action = "updateCurrentRoom",
        room = roomData
    })
end)

RegisterNetEvent("battleground:cl:syncRoomList", function(roomList)
    SendNUIMessage({
        action = "updateRoomList",
        rooms = roomList
    })
end)

-- NUI Callbacks
RegisterNUICallback("closeRoomUI", function(data, cb)
    ClientRoom.ToggleUI(false)
    cb("ok")
end)

RegisterNUICallback("closeCreateTeamUI", function(data, cb)
    ClientRoom.OpenCreateTeamUI(false)
    cb("ok")
end)

RegisterNUICallback("createRoom", function(data, cb)
    TriggerServerEvent("battleground:sv:createRoom", data)
    ClientRoom.OpenCreateTeamUI(false)
    cb("ok")
end)

RegisterNUICallback("joinRoom", function(data, cb)
    TriggerServerEvent("battleground:sv:joinRoom", data.roomId, data.password)
    cb("ok")
end)

RegisterNUICallback("leaveRoom", function(data, cb)
    TriggerServerEvent("battleground:sv:leaveRoom")
    cb("ok")
end)

RegisterNUICallback("createTeam", function(data, cb)
    TriggerServerEvent("battleground:sv:createTeam", data.name, data.logoUrl)
    cb("ok")
end)

RegisterNUICallback("joinTeam", function(data, cb)
    TriggerServerEvent("battleground:sv:joinTeam", data.teamId)
    cb("ok")
end)

RegisterNUICallback("startMatch", function(data, cb)
    TriggerServerEvent("battleground:sv:startMatch")
    cb("ok")
end)
